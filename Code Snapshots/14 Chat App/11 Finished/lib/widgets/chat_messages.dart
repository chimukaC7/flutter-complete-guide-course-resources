import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    //we can update the UI whenever a new document is added to this collection.
    //whenever we add a new message like this should work you see that's added here automatically.
    // We don't have to manage any state manually
    // we don't have to do anything like that
    // We just submit the data,then thanks to this stream here, so to this listener which we in the end have here

    // it's all updated automatically thereafter.
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
        //make sure that my latest message, is at the bottom of that list though.
          .orderBy('createdAt',descending: true,)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        // connection state waiting, we know that we're still waiting to receive some data.
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        //check if chat snapshots has data is false by adding an exclamation market
        // at the beginning or if chat snapshots data,
        // if we have data, if that is actually an empty list.
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          //the entire list is reversed
          // And instead of going from top to bottom, it now goes from bottom to top.
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
            //if there is a next message, we will get hold of it by using loadedMessages
            // for index plus one.
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              //if the user is the same as the current user, we want to return MessageBubble.next
              // because we have an ongoing sequence of messages from the same user.
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              // the first time that we're outputting a message for the given user.
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
