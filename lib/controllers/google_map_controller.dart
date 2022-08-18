// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class MapController extends GetxController {
  final orderController = Get.put(OrderController());

  var zoom = 16.0.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var merchantId = ''.obs;

  Set<Marker> markers = <Marker>{};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late LatLng destinationMerchant;
  List<LatLng> myPosLatLng = [];

  @override
  void onInit() {
    getCurrentCameraPosition();
    _loadOrderData();
    super.onInit();
  }

  Future<Position> getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } else {
      final request = await Geolocator.requestPermission();
      if (request == LocationPermission.always ||
          request == LocationPermission.whileInUse) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else {
        throw Exception("Access to Location permission was denied.");
      }
    }
  }
  Future<CameraPosition> getCurrentCameraPosition() async {
    Position _currentPos = await getCurrentPosition();
    latitude.value = _currentPos.latitude;
    longitude.value = _currentPos.longitude;
    debugPrint('current location: ${latitude.value} and ${longitude.value}');
    if (_currentPos != null) {
      return CameraPosition(
        target: LatLng(latitude.value, longitude.value),
        zoom: zoom.value,
      );
    } else {
      throw Exception('Error current location because Google Maps permission was denied.');
    }
  }

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _merchantData = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<MerchantModel>> get merchantData => _merchantData.value;

  void _loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).where(OrderModel.orderIdString, isEqualTo: orderController.orderId.value).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        merchantId.value = orders[0].merchantId;
        _loadMerchantData(merchantId.value);
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadMerchantData(String id) {
    try {
      debugPrint('merchant id : ${merchantId.value}');
      final data = FirebaseFirestore.instance.collection(MerchantModel.collectionName).where(MerchantModel.merchantIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final merchant = result.docs.map((e) => MerchantModel.fromMap(e.data())).toList();
        debugPrint('merchant position lat: ${merchant[0].position.latitude} and log: ${merchant[0].position.longitude}');
        destinationMerchant = LatLng(merchant[0].position.latitude, merchant[0].position.longitude);
        myPosLatLng.add(destinationMerchant);
        _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.success, data: merchant);
      });
    } catch (ex) {
      _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}