import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.only(bottom: 65.0),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: const SlideEffect(
                      activeDotColor: Colors.black,
                      dotColor: Colors.black45,
                      dotHeight: 12,
                      dotWidth: 12),
                ),
              ),
              CustomElevatedButton(
                text: "Continue",
                onPressed: () {
                  context.read<OnboardingCubit>().navigateToLogin(context);
                },
                width: double.infinity,
                textColor: Colors.white,
                verticalPadding: 18.0,
                fontSize: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
