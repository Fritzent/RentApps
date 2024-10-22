import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/sources/auth_source.dart';
import 'package:gap/gap.dart';

import '../common/info.dart';
import '../widgets/button_primary.dart';
import '../widgets/input_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final edtNewName = TextEditingController();

  editProfileData() {
    if (edtNewName.text.isEmpty) return Info.error('Name must be filled');

    Map<String, dynamic> data = {
      'name' : edtNewName.text
    };

    AuthSource.editProfile(data).then((response) {
      if (response != 'success') return Info.error(response);

      Info.success('Profile Updated');
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
                'Edit Profile',
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
                  'Username',
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
                    icon: 'assets/ic_profile.png', 
                    hint: 'Input new username', 
                    textEditingController: edtNewName,
                  ),
                ),
                const Gap(32),
                ButtonPrimary(
                  text: 'Update', 
                  onTap: (){
                    editProfileData();
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