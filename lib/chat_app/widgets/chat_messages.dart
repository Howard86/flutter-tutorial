import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/chat_app/widgets/chat_bubbles.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = messages[index].data();
            final nextChatMessage =
                index + 1 < messages.length ? messages[index + 1].data() : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextChatMessage?['userId'];

            if (currentMessageUserId == nextMessageUserId) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: currentMessageUserId == user.uid,
              );
            }

            return MessageBubble.first(
              message: chatMessage['text'],
              isMe: currentMessageUserId == user.uid,
              // TODO: get user image and username based on userId
              userImage: '',
              username: '',
            );
          },
        );
      },
    );
  }
}
