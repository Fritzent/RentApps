import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/bike.dart';
import 'package:flutter_rent_apps/widgets/button_primary.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../widgets/input_field.dart';

class BookingPages extends StatefulWidget {
  const BookingPages({super.key, required this.bike });
  final Bike bike;

  @override
  State<BookingPages> createState() => _BookingPagesState();
}

class _BookingPagesState extends State<BookingPages> {
  final edtName = TextEditingController();
  final edtStartRentDate = TextEditingController();
  final edtEndDate = TextEditingController();
  int agencyIndex = 0;
  String selectedAgency = '';
  String selectedInsurance = '';

  pickDate(TextEditingController editingController) {
    DateTime firstDate;

    if (editingController.text.isNotEmpty) {
    try {
      firstDate = DateFormat('dd MMM yyyy').parse(editingController.text);
    } catch (e) {
      firstDate = DateTime.now();
    }
  } else {
    firstDate = DateTime.now();
  }

    showDatePicker(
      context: context, 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: firstDate,
    ).then((chooseDate) {
      if (chooseDate == null) return;
      
      editingController.text = DateFormat('dd MMM yyyy').format(chooseDate);
    });
  }
  backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        children: [
          Gap(30 + MediaQuery.of(context).padding.top),
          buildHeader(),
          const Gap(16),
          buildSnippetBike(),
          const Gap(16),
          buildFormBooking(),
          const Gap(24),
          buildFormAgency(),
          const Gap(32),
          buildFormInsurance(),
          const Gap(32),
          ButtonPrimary(
            text: 'Checkout', 
            onTap: () {
              Navigator.pushNamed(context, '/checkout', arguments: {
                'bike' : widget.bike,
                'startDate' : edtStartRentDate.text,
                'endDate' : edtEndDate.text
              });
            }
          ),
          const Gap(32),
        ],
      ),
    );
  }
  Widget buildFormInsurance() {
    final listAgency = [
      'Select available insurance',
      'Jiwa Perkasa', 
      'Kejiwaan', 
      'Jiwa raga'
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Insurance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 52,
          child: DropdownButtonFormField<String>(
            icon: Image.asset(
              'assets/ic_arrow_down.png',
              width: 20,
              height: 20,
            ),
            value: 'Select available insurance',
            items: listAgency.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:  Color(0xff070623),
                  ),
                ),
              );
            }).toList(), 
            onChanged: (value){
              selectedInsurance = value!;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(right: 16,),
              prefixIcon: UnconstrainedBox(
                alignment: const Alignment(0.2, 0),
                child: Image.asset(
                  'assets/ic_insurance.png',
                  width: 24,
                  height: 24,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  width: 2,
                  color: Color(0xff4a1dff),
                )
              ),
            ),
          ),  
        )
      ],
    );
  }
  Widget buildFormAgency() {
    final listAgency = ['Revolte', 'KBP City', 'Sumedang'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agency',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: listAgency.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    agencyIndex = index;
                    selectedAgency = listAgency[agencyIndex];
                  });
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 16
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: agencyIndex == index ? Border.all(
                      color: const Color(0xff4a1dff),
                      width: 3,
                    ) : null
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/agency.png',
                        width: 38,
                        height: 38,
                      ),
                      const Gap(16),
                      Text(
                        listAgency[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:  Color(0xff070623),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }
  Widget buildFormBooking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        ),
        const Gap(16),
        InputField(
          icon: 'assets/ic_profile.png', 
          hint: 'Input name', 
          textEditingController: edtName,
        ),
        const Gap(24),
        const Text(
          'Start Rent Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        ),
        const Gap(16),
        InputField(
          icon: 'assets/ic_calendar.png', 
          hint: 'Choose your date', 
          enable: false,
          textEditingController: edtStartRentDate,
          onTapBox: () => pickDate(edtStartRentDate),
        ),
        const Gap(24),
        const Text(
          'End Rent Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        ),
        const Gap(16),
        InputField(
          icon: 'assets/ic_calendar.png', 
          hint: 'Choose your date', 
          enable: false,
          textEditingController: edtEndDate,
          onTapBox: () => pickDate(edtEndDate),
        ),
      ],
    );
  }
  Widget buildSnippetBike(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ExtendedImage.network(
            widget.bike.image,
            height: 70,
            width: 90,
            fit: BoxFit.contain,
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.bike.name,
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
                    widget.bike.category,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.bike.rating}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff070623),
                ),
              ),
              const Gap(4),
              const Icon(
                size: 20,
                Icons.star,
                color: Color(0xffffbc1c),
              ),
            ],
          )
        ],
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
              'Booking',
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