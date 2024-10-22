import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/account.dart';
import 'package:flutter_rent_apps/pages/change_password.dart';
import 'package:flutter_rent_apps/pages/edit_profile.dart';
import 'package:gap/gap.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  logout() {
    DSession.removeUser().then((result) {
      if (!result) return;

      Navigator.pushReplacementNamed(context, '/signin');
    });
  }
  editProfile() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const EditProfilePage()));
  }
  changePassword() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      children: [
        Gap(30 + MediaQuery.of(context).padding.top),
        const Text(
          'My Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xff070623),
          ),
        ),
        const Gap(20),
        Container(
          padding: EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 255, 255, 255)
          ),
          child: Column(
            children: [
              buildProfile(),
              const Gap(32),
              buildItemSettingsMenu(
                'assets/ic_profile.png',
                'Edit Profile',
                editProfile,
              ),
              const Gap(32),
              buildItemSettingsMenu(
                'assets/ic_wallet.png',
                'My Digital Wallet',
                () {}
              ),
              const Gap(32),
              buildItemSettingsMenu(
                'assets/ic_rate.png',
                'Rate This App',
                () {}
              ),
              const Gap(32),
              buildItemSettingsMenu(
                'assets/ic_key.png',
                'Change Password',
                changePassword,
              ),
              const Gap(32),
              buildItemSettingsMenu(
                'assets/ic_logout.png',
                'Logout',
                logout,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildItemSettingsMenu(
    String icon,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0xffefeef7),
            width: 1
          )
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const Gap(16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff070623),
                ),
              ),
            ),
            Image.asset(
              'assets/ic_arrow_next.png',
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return FutureBuilder(
      future: DSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        Account account = Account.fromJson(Map.from(snapshot.data!));
        return Row(
          children: [
            Image.asset(
              'assets/profile.png',
              width: 50,
              height: 50,
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623),
                  ),
                ),
                const Gap(2),
                Text(
                  account.email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff838384),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}