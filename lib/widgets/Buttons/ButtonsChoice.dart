import 'package:flutter/material.dart';

class ButtonsChoice extends StatefulWidget {
  const ButtonsChoice({super.key,required this.titlebutton, required this.color});
  final String titlebutton;
  final Color color;
  @override
  _ButtonsChoiceState createState() =>
      _ButtonsChoiceState();
}

class _ButtonsChoiceState extends State<ButtonsChoice> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 1),
      child: Card(
        color: widget.color,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.green.withAlpha(30),
          onTap: () {
            print('Test');
          },
          child: SizedBox(
            width: 100,
            height: 50,
            child: Center(child: Text(widget.titlebutton,style: const TextStyle(fontSize:16, fontWeight:FontWeight.bold,),)),
          ),
        ),
      ),
    );
  }
}
