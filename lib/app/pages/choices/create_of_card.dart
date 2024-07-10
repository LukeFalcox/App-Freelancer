import 'package:app_freelancer/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CreateOCard extends StatefulWidget {
 final IoniconsData icon ;
 final String title;
 final String subtitle;

  const CreateOCard({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  State<CreateOCard> createState() => _CreateOCardState();
}

class _CreateOCardState extends State<CreateOCard> {

  bool _isHovering = false;

  void onHover(bool isHovering){
    setState(() {
      _isHovering = isHovering;
    });
  }




  @override
  Widget build(BuildContext context) {
    return  Container(
            width: 200,
            height: 265,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                   SizedBox(
                    height: 130,
                    child: Icon(
                      widget.icon,
                      size: 90,
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.white,
                          offset: Offset(2, 5)
                        )
                      ],
                    ),
                  ),
                   Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 10.0),
                     child: Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                                       ),
                   ),
                   SizedBox(height: 5,),
                   MouseRegion(
                    onEnter: (_) => onHover(true),
                    onExit: (_) => onHover(false),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                    height: _isHovering ? 40 : 30,
                    width: _isHovering ? 120 : 100,
                    child: FilledButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                    }, child: const Text('Entrar'),style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green), ), ),
                  ),),
                   ),
                 
                ],
              ),
            ),
        );
  }
}