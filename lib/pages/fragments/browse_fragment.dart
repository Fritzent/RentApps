import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/controller/browse_feature_controller.dart';
import 'package:flutter_rent_apps/controller/browse_news_controller.dart';
import 'package:flutter_rent_apps/controller/browse_status_controller.dart';
import 'package:flutter_rent_apps/widgets/failed_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../models/bike.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> {
  final browseFeatureController = Get.put(BrowseFeatureController());
  final browseNewsController = Get.put(BrowseNewsController());
  final browseBookingController =  Get.put(BookingStatusController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      browseFeatureController.fetchFeature();
      browseNewsController.fetchNewsFeature();
      // browseBookingController.bike = {
      //   'name': 'Enfielding Pro',
      //   'image': 'https://a.storyblok.com/f/176629/3000x2000/99845c56db/300sr_ghost-grey.png',
      // };
    });
    super.initState();
  }

  @override
  void dispose() {
    /* To remove the data and cleare from memory */
    Get.delete<BrowseFeatureController>(force: true);
    Get.delete<BrowseNewsController>(force: true);
    Get.delete<BookingStatusController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      children: [
        Gap(30 + MediaQuery.of(context).padding.top),
        buildHeader(),
        buildBookingStatus(),
        const Gap(30),
        buildCategories(),
        const Gap(30),
        buildFeatures(),
        const Gap(30),
        buildNews(),
        const Gap(98),
      ],
    );
  }

  Widget buildBookingStatus() {
    return Obx(() {
      Map bike = browseBookingController.bike;

      if (bike.isEmpty) return const SizedBox();
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xff4a1dff),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 16),
              blurRadius: 20,
              color: const Color(0xff4a1dff).withOpacity(0.25),
            ),
          ]
        ),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              top: 0,
              bottom: 0,
              child: ExtendedImage.network(
                bike['image'],
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Your Booking....',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: bike['name'],
                          style: const TextStyle(
                            color: Color(0xffffbc1c),
                          ),
                        ),
                        const TextSpan(
                          text: '\nhas been delivered to.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ]
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'News Bikes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xff070623),
          ),
        ),
        const Gap(10),
        Obx(() {
          String status = browseNewsController.status;
          if(status == '') return const SizedBox();
          if(status == 'Loading') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(status == 'Error') {
            return Center(
              child: FailedUi(message: status),
            );
          }
          List<Bike> list = browseNewsController.list;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Bike bike = list[index];
              final margin = EdgeInsets.only(
                top: index == 0 ? 0:9,
                bottom: index == list.length-1?24:9,                  
              );
              return buildItemNewest(bike, margin);
            }
          );
        })
      ],
    );
  }
  Widget buildItemNewest(
    Bike bike, EdgeInsetsGeometry margin
  ) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/detail', arguments: bike.id);
        //Navigator.popAndPushNamed(context, '/detail', arguments: bike.id);
      },
      child: Container(
        height: 98,
        padding: EdgeInsets.symmetric(horizontal: 14),
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ExtendedImage.network(
              bike.image,
              width: 90,
              height: 70,
              fit: BoxFit.contain,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bike.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff070623),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    bike.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff838384),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                    decimalDigits: 0,
                    locale: 'id_ID',
                    symbol: '\Rp',
                  ).format(bike.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff6747e9),
                  ),
                ),
                const Text(
                  '/day',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff838384),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xff070623),
          ),
        ),
        const Gap(10),
        Obx(() {
          String status = browseFeatureController.status;
          if(status == '') return const SizedBox();
          if(status == 'Loading') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(status == 'Error') {
            return Center(
              child: FailedUi(message: status),
            );
          }
          List<Bike> list = browseFeatureController.list;
          return SizedBox(
            height: 295,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Bike bike = list[index];
                final margin = EdgeInsets.only(
                  left: index == 0 ? 0:12,
                  right: index == list.length-1?24:12,                  
                );
                bool isTrending = index == 0;
                return buildItemFeature(bike, margin, isTrending);
              }
            ),
          );
        })
      ],
    );
  }

  Widget buildItemFeature(
    Bike bike, EdgeInsetsGeometry margin, bool isTrending
  ){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/detail', arguments: bike.id);
      },
      child: Container(
        width: 252,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ExtendedImage.network(
                  bike.image,
                  width: 220,
                  height: 170,
                ),
                if (isTrending) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xffff2056),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                        color: const Color(0xff205680).withOpacity(0.5),
                      ),
                    ]
                  ),
                  child: const Text(
                    'TRENDING',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff070623),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        bike.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff838384),
                        ),
                      ),
                    ],
                  ),
                ),
                RatingBar.builder(
                  initialRating: bike.rating.toDouble(),
                  itemPadding: const EdgeInsets.all(0),
                  itemSize: 16,
                  unratedColor: Colors.grey[300],
                  allowHalfRating: true,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Color(0xffffbc1c),
                  ), 
                  ignoreGestures: true,
                  onRatingUpdate: (value){},
                ),
              ],
            ),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                    decimalDigits: 0,
                    locale: 'id_ID',
                    symbol: '\Rp',
                  ).format(bike.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff6747e9),
                  ),
                ),
                const Text(
                  '/day',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff838384),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategories(){
    final categories = [
      ['City', 'assets/ic_city.png'],
      ['Downhill', 'assets/ic_downhill.png'],
      ['Beach', 'assets/ic_beach.png'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xff070623),
          ),
        ),
        const Gap(10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((e) {
                return Container(
                  height: 52,
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.fromLTRB(16, 14, 30, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        e[1],
                        width: 24,
                        height: 24,
                      ),
                      const Gap(10),
                      Text(
                        e[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff070623),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ).toList(),
          ),
        )
      ],
    );
  }

  Widget buildHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/logo_text.png',
          height: 38,
          fit: BoxFit.fitHeight,
        ),
        Container(
          height: 46,
          width: 46,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: UnconstrainedBox(
            child: Image.asset(
              'assets/ic_notification.png',
              height: 24,
              width: 24,
            ),
          ),
        )
      ],
    );
  }
}