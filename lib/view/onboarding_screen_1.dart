import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboarding1.png', height: 300),
            const SizedBox(height: 20),
            const Text(
              "Discover Amazing Books",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Explore a wide variety of books to buy and sell at your convenience.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/onboarding2');
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
