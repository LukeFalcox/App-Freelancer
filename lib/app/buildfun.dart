import 'package:flutter/material.dart';

class BuildFun extends StatelessWidget {
  final List<String> img;
  final List<String> tit;

  const BuildFun({
    super.key,
    required this.img,
    required this.tit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: tit.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 135, // Ajuste a largura do item se necessário
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(img[index], height: 70),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 110,
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
                const SizedBox(width: 16), // Espaçamento entre cada item
              ],
            ),
          );
        },
      ),
    );
  }
}

