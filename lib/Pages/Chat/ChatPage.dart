import 'package:app_freelancer/Pages/Chat/ChatBubble.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userEmail;
  final String receiverUserID;
  const ChatPage(
      {super.key, required this.userEmail, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final AuthService _chatService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //only send message if there is something to send
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Defina a cor desejada aqui
          ),
        backgroundColor: const Color(0xDF000000),
        title: Text(
          widget.userEmail,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        
      ),
      body: Column(children: [
        //messages
        Expanded(
          child: _buildMessageList(),
        ),

        //user input
        _buildMessageInput(),

        const SizedBox(height: 25),
      ]),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  bool isCurrentUser = (data['senderId'] == _firebaseAuth.currentUser!.uid);

  Color bubbleColor = isCurrentUser ? Colors.purple : Colors.blue;


  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(
            data['senderEmail'],
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          ChatBubble(
            message: data['message'],
            color: bubbleColor,
          )
        ],
      ),
    ),
  );
}

  //build message Input
  _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                fillColor: Colors.grey[700],
                filled: true,
                hintText: 'Enter the Message',
                hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),

          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
                color: Color(0xFFFFFFFF),
              ))
        ],
      ),
    );
  }
}
