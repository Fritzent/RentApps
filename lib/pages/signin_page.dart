import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/common/info.dart';
import 'package:flutter_rent_apps/sources/auth_source.dart';
import 'package:gap/gap.dart';

import '../widgets/button_primary.dart';
import '../widgets/button_secondary.dart';
import '../widgets/input_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  signIn(){
    if (edtEmail.text == '') return Info.error('Email must be filled');
    if (edtPassword.text == '') return Info.error('Password must be filled');

    Info.netral('Loading...');

    AuthSource.signIn(
      edtEmail.text, 
      edtPassword.text
    ).then((response) {
      if (response != 'success') return Info.error(response);

      Info.success('Success Sign In');
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, '/discover');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 0
        ),
        children: [
          const Gap(64),
          Center(
            child: Image.asset(
              'assets/logo_text.png',
              width: 171,
              height: 38,
            ),
          ),
          const Gap(64),
          const Text(
            'Sign In Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(24),
          const Text(
            'Email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(16),
          InputField(
            icon: 'assets/ic_email.png', 
            hint: 'Input email', 
            textEditingController: edtEmail,
          ),
          const Gap(24),
          const Text(
            'Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(16),
          InputField(
            icon: 'assets/ic_key.png', 
            hint: 'Input password', 
            textEditingController: edtPassword,
            obsecure: true,
          ),
          const Gap(32),
          ButtonPrimary(
            text: 'Sign In', 
            onTap: (){
              signIn();
            },
          ),
          const Gap(16),
          const DottedLine(
            dashGapLength: 6,
            dashLength: 6,
            dashColor: Color(0xffceced5),
          ),
          const Gap(16),
          ButtonSecondary(
            text: 'Create Account', 
            onTap: (){
              Navigator.pushReplacementNamed(context, '/signup');
            }
          ),
          const Gap(64),
        ],
      ),
    );
  }
}