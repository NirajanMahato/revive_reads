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
        const SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
              width: double.infinity,
              height: 400,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 21.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
