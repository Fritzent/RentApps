import 'package:d_session/d_session.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/bike.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../models/account.dart';
import '../widgets/button_primary.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key, 
    required this.bike,
    required this.startDate, 
    required this.endDate
  });
  final Bike bike;
  final String startDate;
  final String endDate; 

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double subTotal = 0;
  double insurance = 0;
  double tax = 0;
  double grandTotal = 0;
  int paymentIndex = 0;
  String selectedPayment = '';
  double balance = 95000000; 
  late Future<Account> _accountFuture;
  FToast fToast = FToast();

  backPage() {
    Navigator.pop(context);
  }
  checkoutNow() {
    if (balance < grandTotal) {
      Widget customeUi = Transform.translate(
        offset: const Offset(0, -45 ),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical:  24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffff2055),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const  Offset(0, 16),
                color: const Color(0xffff2055).withOpacity(0.25),
              ),
            ]
          ),
          child: const Text(
            'Failed to checkout. Your wallet has no enough balance at this moment.', 
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ); 
      fToast.showToast(
        child: customeUi,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(milliseconds: 2500),
      );
      return;
    }

    Navigator.pushNamed(context, '/pin', arguments: widget.bike);
  }

  @override
  void initState() {
    fToast.init(context);
    _accountFuture = DSession.getUser().then((data) {
      return Account.fromJson(Map.from(data!));
    });
    super.initState();
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
          buildBookingDetail(),
          const Gap(32),
          buildPaymentMethod(),
          const Gap(32),
          ButtonPrimary(
            text: 'Pay Now', 
            onTap: () {
              checkoutNow();
            }
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget buildBookingDetail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          buildDetailPrice(),
          const Gap(16),
          buildDetailStartDate(),
          const Gap(16),
          buildDetailEndDate(),
          const Gap(16),
          buildDetailDuration(),
          const Gap(16),
          buildDetailSubTotal(),
          const Gap(16),
          buildDetailCalculateInsurance(),
          const Gap(16),
          buildDetailCalculateTax(),
          const Gap(16),
          buildDetailGrandTotal(),
        ],
      )
    );
  }
  Widget buildPaymentMethod() {
    final listpayment = [
      {'My Wallet' : 'assets/wallet.png'}, 
      {'Credit Card': 'assets/cards.png'}, 
      {'Cash' : 'assets/cash.png'}, 
    ];
    
    return FutureBuilder<Account>(
      future: _accountFuture,
      builder :(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Account account = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xff070623),
                ),
              ),
              const Gap(16),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  itemCount: listpayment.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          paymentIndex = index;
                          var paymentMethod = listpayment[paymentIndex];
                          selectedPayment = paymentMethod.keys.first;
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
                          border: paymentIndex == index ? Border.all(
                            color: const Color(0xff4a1dff),
                            width: 3,
                          ) : null
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              listpayment[index][listpayment[index].keys.first].toString(),
                              width: 38,
                              height: 38,
                            ),
                            const Gap(16),
                            Text(
                              listpayment[index].keys.first,
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
              ),
              const Gap(24),
              Stack(
                children: [
                  Image.asset(
                    'assets/bg_wallet.png',
                    width: double.infinity ,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          account.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color:  Colors.white,
                          ),
                        ),
                        const Text(
                          '02/30',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color:  Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 0,
                    top: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Balance',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color:  Colors.white,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            decimalDigits: 0,
                            locale: 'id_ID',
                            symbol: '\Rp',
                          ).format(balance),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }
  Widget buildDetailGrandTotal() {
    grandTotal = subTotal + insurance + tax;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Grand Total',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            locale: 'id_ID',
            symbol: '\Rp',
          ).format(grandTotal),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff4a1dff),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailCalculateTax() {
    DateTime startDate = DateFormat('dd MMM yyyy').parse(widget.startDate);
    DateTime endDate = DateFormat('dd MMM yyyy').parse(widget.endDate);

    Duration difference = endDate.difference(startDate);

    final calculateTax = (difference.inDays * widget.bike.price) * 0.2 ;
    tax = calculateTax;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tax 20%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            locale: 'id_ID',
            symbol: '\Rp',
          ).format(calculateTax),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailCalculateInsurance() {
    DateTime startDate = DateFormat('dd MMM yyyy').parse(widget.startDate);
    DateTime endDate = DateFormat('dd MMM yyyy').parse(widget.endDate);

    Duration difference = endDate.difference(startDate);

    final calculateInsurance = (difference.inDays * widget.bike.price) * 0.2 ;
    insurance = calculateInsurance;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Insurance 20%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            locale: 'id_ID',
            symbol: '\Rp',
          ).format(calculateInsurance),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailSubTotal() {
    DateTime startDate = DateFormat('dd MMM yyyy').parse(widget.startDate);
    DateTime endDate = DateFormat('dd MMM yyyy').parse(widget.endDate);

    Duration difference = endDate.difference(startDate);

    final calculateSubTotal = difference.inDays * widget.bike.price;
    subTotal = calculateSubTotal.toDouble();

    return Row(
      children: [
        Expanded(
          child: Text(
            'Sub Total Price',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            locale: 'id_ID',
            symbol: '\Rp',
          ).format(calculateSubTotal),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailDuration() {
    DateTime startDate = DateFormat('dd MMM yyyy').parse(widget.startDate);
    DateTime endDate = DateFormat('dd MMM yyyy').parse(widget.endDate);

    Duration difference = endDate.difference(startDate);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Duration',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          '${difference.inDays}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
        const Gap(4),
        const Text(
          'day',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff838384),
          ),
        ),
      ],
    );
  }
  Widget buildDetailEndDate() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'End Date',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          widget.endDate,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailStartDate() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Start Date',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          widget.startDate,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
          ),
        ),
      ],
    );
  }
  Widget buildDetailPrice() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Price',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            locale: 'id_ID',
            symbol: '\Rp',
          ).format(widget.bike.price),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
            letterSpacing: 1
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
              'Checkout',
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