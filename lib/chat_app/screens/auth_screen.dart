import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstapp/chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _isAuthenticating = false;
  File? _selectedImage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (!_isLogin && (_selectedImage == null || _selectedImage!.path.isEmpty)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image.'),
        ),
      );
      return;
    }

    setState(() => _isAuthenticating = true);

    _formKey.currentState!.save();

    late UserCredential userCredential;

    try {
      if (_isLogin) {
        userCredential = await _firebase.signInWithEmailAndPassword(
          email: _emailController.value.text,
          password: _passwordController.value.text,
        );
      } else {
        userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _emailController.value.text,
          password: _passwordController.value.text,
        );

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(
          _selectedImage!,
          SettableMetadata(contentType: 'image/jpg', customMetadata: {
            'picked-file-path': _selectedImage!.path,
          }),
        );

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _usernameController.value.text,
          'email': _emailController.value.text,
          'image_url': imageUrl,
        });
      }

      if (!_isLogin) {}
    } on FirebaseAuthException catch (e) {
      print(e.code);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred! Please try again.'),
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() => _isAuthenticating = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) =>
                                  _selectedImage = pickedImage,
                            ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) => (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@'))
                                ? 'Please enter a valid email address'
                                : null,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.trim().length < 4) {
                                  return 'Username must be at least 4 characters long';
                                }
                                return null;
                              },
                            ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: _isLogin
                                  ? const Text('Log in')
                                  : const Text('Sign up'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () =>
                                  setState(() => _isLogin = !_isLogin),
                              child: _isLogin
                                  ? const Text('Create an account')
                                  : const Text('I already have an account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
