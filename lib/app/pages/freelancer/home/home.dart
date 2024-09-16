import 'package:flutter/material.dart';

import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  final AuthService authService;
  const Home({
    super.key,
    required this.authService,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    const categories = [
      "All",
      "Breakfast",
      "Lunch",
      "Dinner",
    ];
    String currentCat = "All";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications),
            // Corrigido estilo incorreto de IconButton.
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What are you\ncooking today",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: const Row(
                  children: [
                    Icon(Ionicons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search any recipes",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("image/img/carousel01.png")),
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: List.generate(
                  categories.length,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: currentCat == categories[index]
                          ? const Color(0xff568A9F)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: currentCat == categories[index]
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quick & Fast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View all")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: List.generate(
                   
              //     ),
              //   ),
              // ),

              TextButton(onPressed: (){
                widget.authService.getprojects('All');
              }, child: Text("Testar"))
            ],
          ),
        ),
      ),
    );
  }
}
