import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    //you should also add the dispose method/ when dealing with controllers.
    //to make sure that the memory resources occupied by the controller get freed up
    // as its not needed anymore.
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    //make sure that once I send a message, I don't just reset the input but I also close this keyboard.
    //this will close any open keyboard by removing the focus from the input field.
    FocusScope.of(context).unfocus();
    // reset that input so that this text field is set back to an empty text field again.
    _messageController.clear();

    //to get information about the currently logged in user
    final user = FirebaseAuth.instance.currentUser!;

    //Now that data, username and user image, of course wasn't stored with help of FirebaseAuth.
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();


    // here I'm deliberately using this remote solution using Firestore even though it leads
    // to this extra HTTP request being sent whenever we submit a new message.

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          //text field inside a row can be problematic,
          //Hence, I'll wrap it with expanded,
          Expanded(
            //a text field, not a text form field, because here I'm not using the form widget.
            //of course you could also use that if you wanted to.
            child: TextField(
              //add a controller to get hold of the value entered by the user.
              controller: _messageController,
              //to make sure how the device supports the user with entering text, that it, for example,
              // should capitalize the start of every new sentence, which you can turn off or configure differently,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
