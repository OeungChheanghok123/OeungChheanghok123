import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {

  final notifications = FirebaseFirestore.instance.collection('notification');
  final id = ''.obs;
  final title = ''.obs;

  @override
  void initState() {
    id.value = Get.arguments['ref_id'];
    super.initState();
    readTitleNotification();
    updateStatus();
  }

  void readTitleNotification() {
    notifications.where('ref_id', isEqualTo: id.value).get().then((value){
      for (var element in value.docs) {
        title.value = element['title'];
      }
    });
  }
  Future<void> updateStatus() async{

    await notifications.where("ref_id", isEqualTo: id.value).get().then((value) {
      FlutterAppBadger.updateBadgeCount(value.docs.length);
      debugPrint("ref id get in detail page ${value.docs[0].id}");

      notifications.doc(value.docs[0].id).update({'isRead': true}).then((value) {
        notifications.where("isRead", isEqualTo: false).get().then((value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
      }).catchError((error) => print("Failed to add user: $error"));      // ignore: avoid_print, invalid_return_type_for_catch_error
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          titleSpacing: 0,
          leading: InkWell(
            splashColor: none,
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.close,
              color: black,
              size: 24,
            ),
          ),
          title: Obx(() => TitleAppBarWidget(
            text: title.value,
            color: black,
            textOverflow: TextOverflow.ellipsis,
          )),
          actions: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              child: InkWell(
                splashColor: none,
                onTap: (){
                 notifications.where('ref_id', isEqualTo: id.value).get().then((value) => {notifications.doc(value.docs[0].id).delete()});
                 Get.offNamed('/notification');
                },
                child: const IconWidget(
                  icon: Icons.delete,
                  color: silver,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}