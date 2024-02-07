import 'package:flutter/material.dart';
import 'package:flutter_google_docs/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            'Sign in With Google',
            style: TextStyle(color: kBlackColor),
          ),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: kWhiteColor,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}
