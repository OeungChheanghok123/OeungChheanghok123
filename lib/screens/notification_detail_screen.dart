import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String refId;
  const NotificationDetailScreen({
    Key? key,
    required this.refId,
  }) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {


  @override
  void initState() {
    super.initState();
    updateStatus();
  }

  CollectionReference notifications = FirebaseFirestore.instance.collection('notification');

  updateStatus() async{
    await notifications.where("ref_id", isEqualTo: widget.refId).get().then((value) {
      FlutterAppBadger.updateBadgeCount(value.docs.length);
      // ignore: avoid_print
      print("ref id get in detail page ${value.docs[0].id}");
      notifications.doc(value.docs[0].id).update({
        'isRead': true // 42
      })
          .then((value) {
        notifications.where("isRead", isEqualTo: false).get().then(
                (value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
      }).catchError((error) => print("Failed to add user: $error"));      // ignore: avoid_print, invalid_return_type_for_catch_error
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
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
          title: TitleAppBarWidget(
            text: widget.refId,
            //text: listNotification[notificationIndex].title.toString(),
            color: black,
            textOverflow: TextOverflow.ellipsis,
          ),
          actions: [
            InkWell(
              splashColor: none,
              onTap: (){
                //listNotification.removeAt(notificationIndex);
                //homeController.notificationCount.value = listNotification.length;
                Get.offNamed('/notification');
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: (){
                   notifications.where('ref_id', isEqualTo: widget.refId).get().then((value) => {
                     notifications.doc(value.docs[0].id).delete(),
                   });
                   Get.back();
                  },
                  child: const IconWidget(
                    icon: Icons.delete,
                    color: silver,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}