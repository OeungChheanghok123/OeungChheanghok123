import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/order_detail_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/product_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class ReportOrderDetailController extends GetxController{

  final remarkController = TextEditingController();
  var getOrderNo = ''.obs;
  var getDeliveryFee = ''.obs;
  var getTip = ''.obs;
  var getBonus = ''.obs;
  var getCustomerName = ''.obs;
  var customerNo = ''.obs;
  var itemLength = 0.obs;

  var itemCount = 0.obs;
  var subTotal = 0.0.obs;
  var total = 0.0.obs;
  var totalEarning = 0.0.obs;
  var yourEarning = 0.0.obs;

  var listAmount = [];
  var listQty = [];
  var listSalePrice = [];
  var listProductId = [];
  var listProductName = [];

  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final orderDetailCollection = FirebaseFirestore.instance.collection(OrderDetailModel.collectionName);
  final productCollection = FirebaseFirestore.instance.collection(ProductModel.collectionName);
  final customerCollection = FirebaseFirestore.instance.collection(CustomerModel.collectionName);

  final _customerData = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<CustomerModel>> get customerData => _customerData.value;
  final _orderDetailData = RemoteData<List<OrderDetailModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderDetailModel>> get orderDetailData => _orderDetailData.value;
  final _productData = RemoteData<List<ProductModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<ProductModel>> get productData => _productData.value;

  @override
  void onInit() {
    getOrderNo.value = Get.arguments['order'];
    getDeliveryFee.value = Get.arguments['delivery_fee'];
    getTip.value = Get.arguments['tip'];
    getBonus.value = Get.arguments['bonus'];
    getCustomerName.value = Get.arguments['customerName'];
    super.onInit();

    loadOrderData();
    loadOrderDetailData();
  }

  void loadOrderData() {
    final order = orderCollection.where(OrderModel.orderIdString, isEqualTo: getOrderNo.value).snapshots();
    order.listen((e) {
      final data = e.docs.map((e) => OrderModel.fromMap(e.data())).toList();
      customerNo.value = data[0].customerId;
      getCustomerDetail(customerNo.value);
    });
  }
  void loadOrderDetailData() {
    final orderDetail = orderDetailCollection.where(OrderDetailModel.orderIdString, isEqualTo: getOrderNo.value).snapshots();
    orderDetail.listen((e) {
      if (e.docs.isNotEmpty) {
        final data = e.docs.map((e) => OrderDetailModel.fromMap(e.data())).toList();
        itemCount.value = data[0].items.length;
        debugPrint('itemCount : ${itemCount.value}');

        for(int i = 0 ; i < data[0].items.length ; i++) {
          var qty = data[0].items[i]['qty'];
          listQty.add(qty);
          itemLength.value = itemLength.value + int.parse(qty);

          var proId = data[0].items[i]['product_id'];
          listProductId.add(proId);
        }

        for(int i = 0 ; i < listProductId.length ; i++) {
          var id = listProductId[i];
          getProductDetail(id);
        }

        _orderDetailData.value = RemoteData<List<OrderDetailModel>>(status: RemoteDataStatus.success, data: data);
      }
    });
  }

  void getCustomerDetail(String id) {
    try {
      final data = customerCollection.where(CustomerModel.customerIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final customer = result.docs.map((e) => CustomerModel.fromMap(e.data())).toList();
        _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.success, data: customer);
      });
    } catch (ex) {
      _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void getProductDetail(String id) {
    final data = productCollection.where(ProductModel.productIdString, isEqualTo: id).snapshots();
    data.listen((result) {
      final product = result.docs.map((e) => ProductModel.fromMap(e.data())).toList();
      listProductName.add(product[0].productName);
      listSalePrice.add(product[0].price);

      debugPrint('listSalePrice : ${listSalePrice.length}');
      for(int i = listSalePrice.length - 1 ; i < listSalePrice.length ; i++) {
        var qty = double.parse(listQty[i]);
        var salePrice = double.parse(listSalePrice[i]);

        listAmount.add(qty * salePrice);
        debugPrint('amount : $listAmount');
        calculate();
      }
      _productData.value = RemoteData<List<ProductModel>>(status: RemoteDataStatus.success, data: product);
    });
  }

  void calculate() {
    for (int i = listAmount.length - 1 ; i < listAmount.length ; i++) {
      var amount = listAmount[i];
      total.value = total.value + amount;
      debugPrint('total : ${total.value}');

      if (listAmount.length == itemCount.value) {
        subTotal.value = total.value;
        total.value = total.value + double.parse(getDeliveryFee.value);
        totalEarning.value = total.value + double.parse(getTip.value) + double.parse(getBonus.value);
        yourEarning.value = double.parse(getDeliveryFee.value) + double.parse(getTip.value) + double.parse(getBonus.value);
      }
    }
  }
}