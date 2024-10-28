import 'package:flutter_rent_apps/sources/bike_source.dart';
import 'package:get/get.dart';

import '../models/bike.dart';

class BrowseFeatureController extends GetxController {
  final _list = <Bike>[].obs;
  List<Bike> get list => _list;
  set list(List<Bike> n) => _list.value = n;

  final _status = ''.obs;
  String get status => _status.value;
  set status(String n) => _status.value = n;

  @override
  void onInit() {
    super.onInit();
    fetchFeature();
  }

  fetchFeature() async {
    status = 'Loading';
    final bikes = await BikeSource.featchFeatureBike();
    if (bikes == null) {
      status = 'Error';
      return;
    }
    status = 'Success';
    list = bikes;
  }
}