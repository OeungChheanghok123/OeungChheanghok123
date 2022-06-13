import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/models/notification_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class NotificationDetailScreen extends StatelessWidget {
  final int notificationIndex;
  const NotificationDetailScreen({
    Key? key,
    required this.notificationIndex,
  }) : super(key: key);

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
            text: listNotification[notificationIndex].title.toString(),
            color: black,
            textOverflow: TextOverflow.ellipsis,
          ),
          actions: [
            InkWell(
              splashColor: none,
              onTap: (){
                listNotification.removeAt(notificationIndex);
                homeController.notificationCount.value = listNotification.length;
                Get.offNamed('/notification');
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
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