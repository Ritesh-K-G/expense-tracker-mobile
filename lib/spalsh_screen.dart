import 'dart:async';

import 'package:expense_tracker/views/ExpenseHomePage.dart';
import 'package:flutter/material.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ExpenseHomePage()),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/spalsh.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      scale: 1.0,
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/naruto.png',
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              const Text(
                  'Shinobi Expenses',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
