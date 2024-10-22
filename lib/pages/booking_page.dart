import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/bike.dart';

class BookingPages extends StatefulWidget {
  const BookingPages({super.key, required this.bike });
  final Bike bike;

  @override
  State<BookingPages> createState() => _BookingPagesState();
}

class _BookingPagesState extends State<BookingPages> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}