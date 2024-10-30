import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/controller/browse_status_controller.dart';
import 'package:flutter_rent_apps/models/bike.dart';
import 'package:flutter_rent_apps/widgets/button_primary.dart';
import 'package:flutter_rent_apps/widgets/button_secondary.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key, required this.bike});
  final Bike bike;

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final bookingStatusController = Get.find<BookingStatusController>();
  final edtPinOne = TextEditingController();
  final edtPinTwo = TextEditingController();
  final edtPinThree = TextEditingController();
  final edtPinFour = TextEditingController();

  final isComplete = false.obs;

  backPage() {
    Navigator.pop(context);
  }

  tapPin(int number) {
    if (edtPinOne.text.isEmpty) {
      edtPinOne.text = number.toString();
      return;
    }
    if (edtPinTwo.text.isEmpty) {
      edtPinTwo.text = number.toString();
      return;
    }
    if (edtPinThree.text.isEmpty) {
      edtPinThree.text = number.toString();
      return;
    }
    if (edtPinFour.text.isEmpty) {
      edtPinFour.text = number.toString();
      isComplete.value = true;
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          children: [
            Gap(30 + MediaQuery.of(context).padding.top),
            buildHeader(),
            const Gap(16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      inputPin(edtPinOne),
                      const Gap(16),
                      inputPin(edtPinTwo),
                      const Gap(16),
                      inputPin(edtPinThree),
                      const Gap(16),
                      inputPin(edtPinFour),
                    ],
                  ),
                  const Gap(48),
                  buildNumberInput(),
                ],
              ),
            ),
            const Gap(16),
            Obx(() {
                if (!isComplete.value) return const SizedBox();
                return ButtonPrimary(
                  text: 'Pay', 
                  onTap: (){
                     bookingStatusController.bike = {
                      'id' : widget.bike.id,
                      'name': widget.bike.name,
                      'image': widget.bike.image,
                      'category': widget.bike.category
                     };
                     Navigator.pushNamed(context, '/success-booking', arguments: widget.bike);
                  }
                ); 
              }
            ),
            const Gap(16),
            ButtonSecondary(
              text: 'Cancel', 
              onTap: (){
                backPage(); 
              }
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
  Widget inputPin(TextEditingController edtInput) {
    InputBorder inputBorder = const UnderlineInputBorder(
      borderSide: BorderSide(
         color: Color(0xff070623), 
         width: 3,
      ), 
    );
    return SizedBox(
      width: 30,
      height: 48,
      child: TextField(
        controller: edtInput,
        obscureText: true,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Color(0xff070623),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          enabled: false,
           focusedBorder: inputBorder,
           enabledBorder: inputBorder,
           border: inputBorder,
           disabledBorder: inputBorder
        ),
      ),
    ); 
  }
  Widget buildNumberInput() {
    return SizedBox(
      width: 300,
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: [1,2,3,4,5,6,7,8,9].map((number) {
          return Center(
            child: IconButton(
              onPressed: () => tapPin(number), 
              style: const ButtonStyle(
                 backgroundColor: WidgetStatePropertyAll(Colors.white)
              ),
              constraints: const BoxConstraints(
                minHeight: 60,
                maxHeight: 60,
                minWidth: 60,
                maxWidth: 60
              ),
              icon: Text(
                '${number}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xff070623),
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
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
              'Wallet Security',
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
                'assets/ic_more.png',
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