import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rent_apps/models/bike.dart';
import 'package:get/get.dart';

class BikeSource {
  static Future<List<Bike>?> featchFeatureBike() async{
    try {
      final datas = FirebaseFirestore.instance.collection('Bikes').where('rating', isGreaterThan: 4.5).orderBy('rating', descending: true).limit(5);
      final query = await datas.get();
      List<Bike> listData = query.docs.map((doc) => Bike.fromJson(doc.data())).toList();

      // FirebaseFirestore.instance.collection('your_collection').snapshots().listen((snapshot) {
      //   dataList.clear(); // Clear the old data
      //   for (var doc in snapshot.docs) {
      //     dataList.add(doc['your_field']); // Add new data
      //   }
      // });
      RxList<List<Bike>> listDatas = <List<Bike>>[].obs;
      final datas2 = FirebaseFirestore.instance.collection('Bikes').snapshots().listen((snapshot) {
        listDatas.clear();
        for (var doc in snapshot.docs) {
          
        }
      });

      return listData;
    } catch (e) {
      log(e.toString() as num);
      return null;
    }
  }

  static Future<List<Bike>?> featchNewsBikes() async{
    try {
      final datas = FirebaseFirestore.instance.collection('Bikes').orderBy('release', descending: true).limit(5);
      final query = await datas.get();
      List<Bike> listData = query.docs.map((doc) => Bike.fromJson(doc.data())).toList();
      return listData;
    } catch (e) {
      log(e.toString() as num);
      return null;
    }
  }

  static Future<Bike?> featchBike(String bikeId) async {
    try {
      final datas = await FirebaseFirestore.instance.collection('Bikes').doc(bikeId).get();
      Bike? bike = datas.exists ? Bike.fromJson(datas.data()!) : null;
      return bike;   
    }
    catch (e) {
      log (e.toString() as num);
      return null;
    }
  }
}