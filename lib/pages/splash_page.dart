import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/button_primary.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(64),
          Center(
            child: Image.asset(
              'assets/logo_text.png',
              width: 171,
              height: 38,
            ),
          ),
          const Gap(10),
          const Text(
            'Drive & Be Happy!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Transform.translate(
              offset: const Offset(-99, 0),
              child: Image.asset(
                'assets/splash_screen.png',
              ),
            ),
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24
            ),
            child: Text(
              'We provide all beatiful motorbike for your road trip and great memories of life.',
              style: TextStyle(
                height: 1.7,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:  Color(0xff070623),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ButtonPrimary(
              text: 'Explore Now',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }
}