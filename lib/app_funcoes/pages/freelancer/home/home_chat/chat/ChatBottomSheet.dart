import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:flutter/material.dart';

class ChatBottomSheet extends StatefulWidget {
  final AuthService authService;
  final String receiverUserID;
  final String chatRoomId;
  const ChatBottomSheet({super.key, required this.authService, required this.receiverUserID, required this.chatRoomId});
  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
final TextEditingController _messageController = TextEditingController();
void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Captura a hora atual quando a mensagem é enviada
      DateTime now = DateTime.now();
      String formattedTime = '${now.hour}:${now.minute}';

      // Envia a mensagem e a hora atual
      await widget.authService.sendMessage(
          widget.receiverUserID, _messageController.text, formattedTime,widget.chatRoomId);

      // Limpa o controlador de texto após o envio da mensagem
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 3),
        )
      ]),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.add,
              color: Color(0xFF113953),
              size: 30,
            ),
            ),

            const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.emoji_emotions_outlined,
              color: Color(0xFF113953),
              size: 30,
            ),
            ),
            Padding(padding: const EdgeInsets.only(left: 10),
            child: Container(
              alignment: Alignment.centerRight,
              width: 270,
              child: TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Digite algo",
                  border: InputBorder.none,
                ),
              ),
            ),
            ),
        const Spacer(),
         Padding(
          padding: const EdgeInsets.only(right: 10),
        child:  IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            
            Icons.send,
            color: Color(0xFF113953),
            size: 30,
          ),
        ),
        ),
        ],
      )
    );
  }
}
