import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/bike.dart';
import 'package:flutter_rent_apps/widgets/button_primary.dart';
import 'package:flutter_rent_apps/widgets/button_secondary.dart';
import 'package:gap/gap.dart';

class SuccessBookingPage extends StatefulWidget {
  const SuccessBookingPage({super.key, required this.bike});
  final Bike bike;

  @override
  State<SuccessBookingPage> createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        children: [
          Gap(30 + MediaQuery.of(context).padding.top),
          const Center(
            child: Text(
              'Success Booking \nHave a Great Ride!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color:  Color(0xff070623),
              ),
            ),
          ),
          const Gap(24),
          buildDetailBike(),
          const Gap(24),
          Column(
            children: [
              Text(
                widget.bike.name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xff070623),
                ),
              ),
              Text(
                widget.bike.category,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color:  Colors.grey,
                ),
              ),
            ],
          ),
          const Gap(24),
          ButtonPrimary(
            text: 'Booking Order Bike', 
            onTap: (){
              Navigator.restorablePushNamedAndRemoveUntil(
                context, 
                '/discover', 
                (route) => route.settings.name=='/detail',
              );
            }
          ),
          const Gap(16),
          ButtonSecondary(
            text: 'View My Orders', 
            onTap: (){
              Navigator.restorablePushNamedAndRemoveUntil(
                context, 
                '/discover', 
                (route) => route.settings.name=='/detail',
              );
            }
          ),
        ],
      ),
    );
  }

  Widget buildDetailBike() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/ellipse.png',
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ExtendedImage.network(
            widget.bike.image,
            height: 250,
            fit: BoxFit.fitHeight,
          ),
        ),
      ]
    );
  }
}