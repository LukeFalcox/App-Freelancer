import 'package:flutter/material.dart';

class FreelancerOrClient extends StatefulWidget {
  const FreelancerOrClient({super.key});

  @override
  State<FreelancerOrClient> createState() => _FreelancerOrClientState();
}

class _FreelancerOrClientState extends State<FreelancerOrClient> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        
        children: [
          Text(
            'Choose whether you will be a Freelancer or a Client',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Card(
            child: Column(
              children: [Text("Freelancer")],
            ),
          ),
          Card()
        ],
      ),
    );
  }
}
