import 'package:flutter/material.dart';

class ButtonsChoice extends StatefulWidget {
  const ButtonsChoice(
      {Key? key,
      required this.titlebutton,
      required this.color,
      required this.widget, required this.sizebutton})
      : super(key: key);

  final String titlebutton;
  final Color color;
  final double sizebutton;
  final Widget widget;

  @override
  _ButtonsChoiceState createState() => _ButtonsChoiceState();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.widget,
              ),
            );
          },
          child: SizedBox(
            width: 100,
            height: 50,
            child: Center(
              child: Text(
                widget.titlebutton,
                style: TextStyle(
                    fontSize: widget.sizebutton,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
