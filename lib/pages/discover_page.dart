import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/pages/fragments/browse_fragment.dart';
import 'package:flutter_rent_apps/pages/fragments/orders_fragment.dart';
import 'package:flutter_rent_apps/pages/fragments/settings_fragment.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../common/info.dart';
import '../models/account.dart';
import '../sources/chat_source.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late final Account account;


  final fragments = [
    const BrowseFragment(),
    const OrdersFragment(),
    const SettingsFragment(),
  ];
  final fragmentIndex = 0.obs;

  @override
  void initState() {
    DSession.getUser().then((value) {
      account = Account.fromJson(Map.from(value!));
    }); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() => fragments[fragmentIndex.value]),
      bottomNavigationBar: Obx(() {
          return Container(
            height: 78,
            width: double.infinity,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff070623),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                buildItemNav(
                  label: 'Browse', 
                  icon: 'assets/ic_browse.png', 
                  iconOn: 'assets/ic_browse_on.png', 
                  isActive: fragmentIndex.value == 0,
                  onTap: (){
                    fragmentIndex.value = 0;
                  },
                ),
                buildItemNav(
                  label: 'Order', 
                  icon: 'assets/ic_orders.png', 
                  iconOn: 'assets/ic_orders_on.png', 
                  isActive: fragmentIndex.value == 1,
                  onTap: (){
                    fragmentIndex.value = 1;
                  }
                ),
                buildItemCircle(),
                buildItemNav(
                  label: 'Chats', 
                  icon: 'assets/ic_chats.png', 
                  iconOn: 'assets/ic_chats_on.png', 
                  hasNewUpdate: true,
                  onTap: (){ 
                    Info.netral('Loading');
                    ChatSource.openChatRoom(account.uid, account.name).then((value) {
                      Navigator.pushNamed(
                        context, 
                        '/chatting',
                        arguments: {
                          'uid' : account.uid,
                          'userName': account.name,
                        },
                      );
                    });
                  }
                ),
                buildItemNav(
                  label: 'Settings', 
                  icon: 'assets/ic_settings.png', 
                  iconOn: 'assets/ic_settings_on.png', 
                  isActive: fragmentIndex.value == 2,
                  onTap: (){
                    fragmentIndex.value = 2;
                  }
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget buildItemNav({
    required String label,
    required String icon,
    required String iconOn,
    bool isActive = false,
    required VoidCallback onTap,
    bool hasNewUpdate = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          height: 46,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                isActive ? iconOn : icon,
                height: 24,
                width: 24,
              ),
              const Gap(4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isActive ? const Color(0xffffbc1c) : const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  if (hasNewUpdate) Container(
                    margin: const EdgeInsets.only(left: 2),
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffff2056),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget buildItemCircle(){
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffffbc1c),
      ),
      child: UnconstrainedBox(
        child: Image.asset(
          'assets/ic_status.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}