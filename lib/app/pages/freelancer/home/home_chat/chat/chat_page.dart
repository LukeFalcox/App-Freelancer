import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/chat_bubble.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserID;
  const ChatPage({super.key, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final AuthService _chatService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Captura a hora atual quando a mensagem é enviada
      DateTime now = DateTime.now();
      String formattedTime = '${now.hour}:${now.minute}:${now.second}';

      // Envia a mensagem e a hora atual
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text, formattedTime);

      // Limpa o controlador de texto após o envio da mensagem
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tela do Chat",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
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

    Color bubbleColor = isCurrentUser
        ? const Color.fromARGB(255, 18, 104, 216)
        : const Color.fromARGB(255, 2, 133, 255);

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 5),
            ChatBubble(
              message: data['message'],
              color: bubbleColor,
            ),
            if (data.containsKey('formattedTime')) // Verifica se 'formattedTime' está presente
              Text(
                data['formattedTime'], // Exibe a hora da mensagem
                style: const TextStyle(
                    color: Color.fromARGB(179, 0, 98, 255), fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  // build message input
  _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212)),
                ),
                fillColor: Color.fromARGB(255, 197, 197, 197),
                filled: true,
                hintText: 'Enter the Message',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),

          // send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
                color: Color.fromARGB(255, 0, 0, 0),
              ))
        ],
      ),
    );
  }
}
