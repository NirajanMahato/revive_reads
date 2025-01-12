import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/core/common/widgets/onboarding_element.dart';
import 'package:revive_reads/features/onBoarding/presentation/view_model/onboarding_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 670,
                child: PageView(
                  controller: pageController,
                  allowImplicitScrolling: true,
                  children: const [
                    OnboardingElement(
                      subtitle:
                          "Explore a wide variety of books to buy and sell at your convenience",
                      imagePath: "assets/images/onboarding1.png",
                    ),
                    OnboardingElement(
                      subtitle:
                          "Buy and sell books with confidence through a secure platform",
                      imagePath: "assets/images/onboarding2.png",
                    ),
                    OnboardingElement(
                      subtitle:
                          "Engage with a community of readers and book lovers",
                      imagePath: 'assets/images/onboarding3.png',
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 58.0),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: const SlideEffect(
                    activeDotColor: Color(0xff008080),
                    dotColor: Color(0x73008080),
                    dotHeight: 12,
                    dotWidth: 12),
              ),
            ),
            SizedBox(
              width: 290,
              child: OutlinedButton(
                onPressed: () =>
                    context.read<OnboardingCubit>().navigateToLogin(context),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(width: 2, color: Colors.black26)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Continue",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
