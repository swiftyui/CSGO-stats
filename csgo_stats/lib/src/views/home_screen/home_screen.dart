import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHOC - An Entelect Project'),
      ),
      body: Center(
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/data.json',
            ),
            const Text('Coming soon....')
          ],
        ),
      ),
    );
  }
}
