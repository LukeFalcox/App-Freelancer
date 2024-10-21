import 'package:flutter/material.dart';

class BuildList extends StatelessWidget {
  final List<String> img;
  final List<String> tit;

  const BuildList({
    super.key,
    required this.img,
    required this.tit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 10.0,
        children: List.generate(tit.length, (index) {
          return Container(
            width: 101,
            height: 130,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(img[index], height: 60),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 90,
                    child: Text(
                      tit[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
