import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class MapController extends GetxController {
  final newOrderController = Get.put(NewOrderCardController());
  final googleApiKey = "AIzaSyBSyQsntLybWDXtK0XIhYOHMNs9z-6LdVg";

  var zoom = 15.0.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var merchantId = ''.obs;
  var customerId = ''.obs;

  var markers = <Marker>[].obs;
  var polyLines = <PolylineId, Polyline>{}.obs;
  late LatLng merchantPosition;
  late LatLng customerPosition;
  List<LatLng> myPosLatLng = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _merchantData = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<MerchantModel>> get merchantData => _merchantData.value;

  final _customerData = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<CustomerModel>> get customerData => _customerData.value;

  @override
  void onInit() {
    super.onInit();
    getCurrentCameraPosition();
    loadOrderData();
  }

  Future<Position> getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
    else {
      final request = await Geolocator.requestPermission();
      if (request == LocationPermission.always || request == LocationPermission.whileInUse) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
      else {
        throw Exception("Access to Location permission was denied.");
      }
    }
  }
  Future<CameraPosition> getCurrentCameraPosition() async {
    Position _currentPos = await getCurrentPosition();
    latitude.value = _currentPos.latitude;
    longitude.value = _currentPos.longitude;
    if (_currentPos != null) {        // ignore: unnecessary_null_comparison
      return CameraPosition(
        target: LatLng(latitude.value, longitude.value),
        zoom: zoom.value,
      );
    } else {
      throw Exception('Error current location because Google Maps permission was denied.');
    }
  }

  Future<Set<Marker>> initMerchantMarker() async {
    final icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    final merchant = merchantData.data![0];
    for (LatLng location in myPosLatLng) {
      Marker marker = Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: icon,
        infoWindow: infoWindowMerchant(merchant),
      );
      markers.clear();
      markers.add(marker);
    }
    return markers.toSet();
  }
  InfoWindow infoWindowMerchant(MerchantModel merchantModel) {
    return InfoWindow(
      title: merchantModel.merchantName,
      snippet: merchantModel.location,
    );
  }

  Future<Set<Marker>> initCustomerMarker() async {
    final icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    final customer = customerData.data![0];
    for (LatLng location in myPosLatLng) {
      Marker marker = Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: icon,
        infoWindow: infoWindowCustomer(customer),
      );
      markers.clear();
      markers.add(marker);
    }
    return markers.toSet();
  }
  InfoWindow infoWindowCustomer(CustomerModel customerModel) {
    return InfoWindow(
      title: customerModel.customerName,
      snippet: customerModel.location,
    );
  }

  void loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).where(OrderModel.orderIdString, isEqualTo: newOrderController.newOrderId.value).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);

        merchantId.value = orders[0].merchantId;
        customerId.value = orders[0].customerId;
        loadMerchantData();
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void loadMerchantData() {
    try {
      final data = FirebaseFirestore.instance.collection(MerchantModel.collectionName).where(MerchantModel.merchantIdString, isEqualTo: merchantId.value).snapshots();
      data.listen((result) {
        final merchant = result.docs.map((e) => MerchantModel.fromMap(e.data())).toList();
        _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.success, data: merchant);

        merchantPosition = LatLng(merchant[0].position.latitude, merchant[0].position.longitude);
        myPosLatLng.add(merchantPosition);
        initMerchantMarker().then((marker) => markers = marker as RxList<Marker>);
        debugPrint('merchant position : $merchantPosition');
        getPolyline(merchantPosition);
      });
    } catch (ex) {
      _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void loadCustomerData() {
    try {
      final data = FirebaseFirestore.instance.collection(CustomerModel.collectionName).where(CustomerModel.customerIdString, isEqualTo: customerId.value).snapshots();
      data.listen((result) {
        final customer = result.docs.map((e) => CustomerModel.fromMap(e.data())).toList();
        _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.success, data: customer);

        customerPosition = LatLng(customer[0].position.latitude, customer[0].position.longitude);
        myPosLatLng.clear();
        myPosLatLng.add(customerPosition);
        initCustomerMarker().then((marker) => markers = marker as RxList<Marker>);
        getPolyline(customerPosition);
      });
    } catch (ex) {
      _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.error, data: null);
    }
  }

  void getPolyline(LatLng location) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(latitude.value, longitude.value),
      PointLatLng(location.latitude, location.longitude),
      travelMode: TravelMode.driving,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    addPolyLine(location.toString());
  }
  void addPolyLine(String location) {
    PolylineId id = PolylineId(location);
    Polyline polyline = Polyline(
      width: 5,
      polylineId: id,
      color: red,
      points: polylineCoordinates,
    );
    polyLines[id] = polyline;
  }
}