import 'package:flutter_rent_apps/sources/bike_source.dart';
import 'package:get/get.dart';

import '../models/bike.dart';

class DetailController extends GetxController {
  final _bike = Bike.empty.obs;
  Bike get bike => _bike.value;
  set bike(Bike n) => _bike.value = n;

  final _status = ''.obs;
  String get status => _status.value;
  set status(String n) => _status.value = n;

  fetchDetail(String bikeId) async {
    status = 'Loading';
    final bikeDetail = await BikeSource.featchBike(bikeId);
    if (bikeDetail == null) {
      status = 'Error';
      return;
    }
    status = 'Success';
    bike = bikeDetail;
  }
}