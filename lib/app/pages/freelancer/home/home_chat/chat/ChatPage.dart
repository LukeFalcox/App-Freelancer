
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/chat_bubble.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/ChatBottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatPageNew extends StatefulWidget{
  final String receiverUserID;
  final AuthService authService;
  final String  email;
  final String chatRoomId;
  const ChatPageNew({super.key, required this.receiverUserID, required this.chatRoomId, required this.authService, required this.email});

  @override
  State<ChatPageNew> createState() => _ChatPageNewState();
}

class _ChatPageNewState extends State<ChatPageNew> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    @override
    Widget build(BuildContext context) {
        return Scaffold(

            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AppBar(
                        leadingWidth: 30,
                        title:  Row(
                          children: [
                            // ClipRRect(
                            //     borderRadius: BorderRadius.circular(30),
                            //     child: Image.asset(
                            //         "images/avatar.jpg",
                            //         height: 45,
                            //         width: 45,
                            //         ),
                            //     ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                child: 
                                FutureBuilder<Map<String, dynamic>?>(
                              future: widget.authService.getInfosUsers(widget.email),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text(
                                          'Erro ao carregar informações.'));
                                }
                                if (snapshot.hasData) {
                                  final userInfo = snapshot.data;

                                  return Text(userInfo?['nome']);
                                }
                              return Text("Default");
                              },
                            ),
                                ),
                            ],
                        ),
                        actions: const [
                        Padding(
                          padding: EdgeInsets.only(right:25),
                        child: Icon(
                            Icons.call,
                            color: Color(0xFF113953),
                        ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right:25),
                        child: Icon(
                            Icons.video_call,
                            color: Color(0xFF113953),
                        ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right:25),
                        child: Icon(
                            Icons.more_vert,
                            color: Color(0xFF113953),
                        ),
                        ),
                        ],
                    ),
                ),
            ),
            body: _buildMessageList(),
              bottomSheet: ChatBottomSheet(authService: widget.authService,chatRoomId: widget.chatRoomId,receiverUserID: widget.receiverUserID,),
        );

        
    }
       Widget _buildMessageList() {
    return StreamBuilder(
      stream: widget.authService.getMessages(widget.chatRoomId),
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

}
