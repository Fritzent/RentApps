import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/sources/auth_source.dart';
import 'package:gap/gap.dart';

import '../common/info.dart';
import '../widgets/button_primary.dart';
import '../widgets/input_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final edtNewPassword = TextEditingController();
  final edtConfirmNewPassword = TextEditingController();
  final edtCurrentPassword = TextEditingController();

  changeAccountPassword() {
    AuthSource.changePassword(
      edtCurrentPassword.text,
      edtNewPassword.text, 
      edtConfirmNewPassword.text
    ).then((response) {
      if (response != 'success') return Info.error(response);

      Info.success('Change Password Success');
      backPage();
    });
  }
  backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
        children: [
          Gap(30 + MediaQuery.of(context).padding.top),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  backPage();
                },
                child: Container(
                  child: Image.asset(
                    'assets/ic_arrow_back.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const Gap(8),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color:  Color(0xff070623),
                ),
              ),
            ],
          ),
          const Gap(24),
          Container(
          padding: EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 255, 255, 255)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xff070623),
                ),
              ),
              const Gap(8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: const Color(0xffceced5),
                    width: 1,
                  ),
                ),
                child: InputField(
                  icon: 'assets/ic_key.png', 
                  hint: 'Input current password', 
                  textEditingController: edtCurrentPassword,
                  obsecure: true,
                ),
              ),
              const Gap(24),
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xff070623),
                ),
              ),
              const Gap(8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: const Color(0xffceced5),
                    width: 1,
                  ),
                ),
                child: InputField(
                  icon: 'assets/ic_key.png', 
                  hint: 'Input new password', 
                  textEditingController: edtNewPassword,
                  obsecure: true,
                ),
              ),
              const Gap(24),
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xff070623),
                ),
              ),
              const Gap(8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                    color: const Color(0xffceced5),
                    width: 1,
                  ),
                ),
                child: InputField(
                  icon: 'assets/ic_key.png', 
                  hint: 'Input confirm password', 
                  textEditingController: edtConfirmNewPassword,
                  obsecure: true,
                ),
              ),
              const Gap(32),
              ButtonPrimary(
                text: 'Update', 
                onTap: (){
                  changeAccountPassword();
                },
              ),
            ],
          ),
        )
        ],
      ),
    );
  }
}