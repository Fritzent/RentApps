import 'package:d_session/d_session.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/controller/detail_controller.dart';
import 'package:flutter_rent_apps/models/account.dart';
import 'package:flutter_rent_apps/sources/chat_source.dart';
import 'package:flutter_rent_apps/widgets/failed_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/info.dart';
import '../models/bike.dart';
import '../models/chat.dart';
import '../widgets/button_primary.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.bikeId});
  final String bikeId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final detailController = Get.put(DetailController());
  late Account account;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      detailController.fetchDetail(widget.bikeId);
    });
    DSession.getUser().then((value) {
      account = Account.fromJson(Map.from(value!));
    });
    super.initState();
  }

  backPage() {
    Navigator.pop(context);
  }
  bookNow() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        children: [
          Gap(30 + MediaQuery.of(context).padding.top),
          buildHeader(),
          const Gap(32),
          buildDetailBike(),
        ],
      ),
    );
  }

  Widget buildDetailBike() {
    return Obx(() {
      String status = detailController.status;
      if (status == '') return const SizedBox();
      if (status == 'Loading') {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (status == 'Error') {
        return Center(
          child: FailedUi(message: status),
        );
      }
      Bike data = detailController.bike;
      return Column(
        children: [
          Center(
            child: Text(
              data.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623)
              ),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/ic_beach.png',
                    width: 24,
                    height: 24,
                  ),
                  const Gap(4),
                  Text(
                    data.level,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:  Color(0xff070623),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/ic_downhill.png',
                    width: 24,
                    height: 24,
                  ),
                  const Gap(4),
                  Text(
                    data.level,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:  Color(0xff070623),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xff6747e9),
                    size: 24,
                  ), 
                  const Gap(4),
                  Text(
                    data.rating.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:  Color(0xff070623),
                    ),
                  ),
                ],
              )
            ],
          ),
          const Gap(16),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                'assets/ellipse.png',
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ExtendedImage.network(
                  data.image,
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ]
          ),
          const Gap(16),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:  Color(0xff070623),
              ),
            ),
          ),
          const Gap(8),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              data.about,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color:  Color(0xff070623),
              ),
            ),
          ),
          const Gap(32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xff070623),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.currency(
                          decimalDigits: 0,
                          locale: 'id_ID',
                          symbol: '\Rp',
                        ).format(data.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '/day',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/booking', arguments: data);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xffffbc1c),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:  Color(0xff070623),
                      ),
                    )
                  ),
                ),

              ],
            ),
          ),
          const Gap(16),
          GestureDetector(
            onTap: () {
              Chat chat = Chat(
                roomId: account.uid, 
                message: 'Ready?', 
                receiverId: 'cs', 
                senderId: account.uid,
                bikeDetail: {
                  'image': data.image,
                  'name': data.name,
                  'category': data.category,
                  'id': data.id,
                },
              );
              String uid = account.uid;
              Info.netral('Loading');
              ChatSource.openChatRoom(uid, account.name).then((value) {
                ChatSource.sendChat(chat, uid).then((responseSendChat) {
                  Navigator.pushNamed(
                    context, 
                    '/chatting',
                    arguments: {
                      'uid' : uid,
                      'userName': account.name,
                    },
                  );
                });
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ic_message.png',
                    width: 24,
                    height: 24,
                  ),
                  const Gap(8),
                  const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:  Color(0xff070623),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
        ],
      );
    });
  }
  
  Widget buildHeader(){
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            backPage();
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: UnconstrainedBox(
              child: Image.asset(
                'assets/ic_arrow_back.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:  Color(0xff070623),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            backPage();
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: UnconstrainedBox(
              child: Image.asset(
                'assets/ic_favorite.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}