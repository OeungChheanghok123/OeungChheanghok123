import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSize{
  const HomeScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Obx(() => AppBar(
      backgroundColor: homeController.appBarColor.value,
      elevation: 0,
      leading: InkWell(
        splashColor: none,
        onTap: () => homeController.toggleClicked(),
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          child: IconWidget(
            icon: homeController.toggleIcon.value,
            size: 40,
            color: white,
          ),
        ),
      ),
      titleSpacing: 10,
      title: TitleAppBarWidget(
        text: homeController.status.value,
        color: white,
      ),
      actions: <Widget> [
        Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              splashColor: none,
              onTap: () => Get.toNamed("/notification"),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const IconWidget(
                  icon: Icons.notifications,
                  size: 35,
                  color: white,
                ),
              ),
            ),
            homeController.readAll.value ? Container() : Obx(() => Positioned(
              top: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: homeController.notificationColor.value,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextWidget(
                  text: homeController.notificationCount.value.toString(),
                  color: white,
                  size: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )) ,
          ],
        ),
      ],
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);

  @override
  Widget get child => throw UnimplementedError();
}