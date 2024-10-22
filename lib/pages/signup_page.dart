import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/common/info.dart';
import 'package:flutter_rent_apps/sources/auth_source.dart';
import 'package:flutter_rent_apps/widgets/button_primary.dart';
import 'package:flutter_rent_apps/widgets/button_secondary.dart';
import 'package:flutter_rent_apps/widgets/input_field.dart';
import 'package:gap/gap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final edtName = TextEditingController();
  final edtEmail= TextEditingController();
  final edtPassword = TextEditingController();

  createNewAccount(){
    if(edtName.text == '') return Info.error('Username must be filled');
    if(edtEmail.text == '') return Info.error('Email must be filled');
    if(edtPassword.text == '') return Info.error('Password must be filled');

    Info.netral('Loading...');
    AuthSource.signUp(
      edtEmail.text, 
      edtName.text, 
      edtPassword.text).then((response) {
        if(response != 'success') return Info.error(response);

        Info.success('Success Sign Up');
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
            'Sign Up Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(24),
          const Text(
            'Username',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:  Color(0xff070623),
            ),
          ),
          const Gap(16),
          InputField(
            icon: 'assets/ic_profile.png', 
            hint: 'Input Username', 
            textEditingController: edtName,
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
            text: 'Create Account', 
            onTap: (){
              createNewAccount();
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
            text: 'Sign In', 
            onTap: (){
              Navigator.pushReplacementNamed(context, '/signin');
            }
          ),
          const Gap(64),
        ],
      ),
    );
  }
}