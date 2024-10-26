import 'package:d_session/d_session.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/controller/detail_controller.dart';
import 'package:flutter_rent_apps/models/account.dart';
import 'package:flutter_rent_apps/widgets/failed_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bike.dart';
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
                fontSize: 24,
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
          ExtendedImage.network(
            data.image,
          ),
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
              borderRadius: BorderRadius.circular(16),
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
                          fontSize: 24,
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