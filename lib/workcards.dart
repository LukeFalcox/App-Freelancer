import 'package:flutter/material.dart';

class Workscards extends StatefulWidget {
  const Workscards({super.key});

  @override
  State<Workscards> createState() => _WorkscardsState();
}

class _WorkscardsState extends State<Workscards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Site De WorkSpace em ReactJs",
              style: TextStyle(
                color: Color(0xFF17A2B8),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.people_alt, color: Color(0xFF007BFF)),
                    SizedBox(width: 5),
                    Text("Luis Henrique Falco", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                    SizedBox(width: 15),
                    Text("Linguagens:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F1F1),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: const Text(
                          "Preciso de Um WebSite que funcione em Js",
                          style: TextStyle(color: Color(0xFF343A40)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEEEEEE),
                  ),
                  child: const Text(
                    "Adicionar Trabalho",
                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
