import 'package:flutter/material.dart';

class OnboardingElement extends StatelessWidget {
  const OnboardingElement(
      {super.key, required this.subtitle, required this.imagePath});
  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70, left: 30, right: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Start Your Journey",
              //   style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 21.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
              width: double.infinity,
              height: 400,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
              )),
        )
      ],
    );
  }
}
