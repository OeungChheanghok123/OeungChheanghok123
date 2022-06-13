import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/image_icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String titleText = "Notification";
  HomeController homeController = Get.put(HomeController());

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
            onTap: () => Get.offNamed('/instruction'),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          title: TitleAppBarWidget(
            text: titleText,
            color: black,
          ),
          actions: [
            InkWell(
              splashColor: none,
              onTap: () => homeController.readAllNotification(),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                child: Obx(
                  () => TextWidget(
                    text: 'Read all',
                    color: homeController.readAll.value ? silver : rabbit,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() => homeController.notificationCount.value > 0 ? _notification : _nonNotification),
      ),
    );
  }

  Widget get _nonNotification {
    return Container(
      color: lightGray,
      alignment: Alignment.center,
      child: const IconWidget(
        icon: Icons.notifications_off,
        size: 100,
        color: silver,
      ),
    );
  }
  Widget get _notification {
    return Obx(() => Container(
      padding: const EdgeInsets.all(10),
      color: lightGray,
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: homeController.notificationCount.value,
        itemBuilder: (BuildContext context, int index){
          return _buildCardDetail(index, rabbit);
        },
      ),
    ));
  }

  Widget _buildCardDetail(int index, Color color){
    return InkWell(
      onTap: (){
        homeController.notificationIndex.value = index;
        if (index == homeController.notificationIndex.value){
          color = white;
        }
        Get.toNamed('/notification_detail');
        //Get.offNamed("/notification_detail");

      },
      child: Card(
        elevation: 1,
        color: white,
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: white.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const ImageIconWidget(
                                image: 'assets/image/icon_promotion.png',
                                size: 40,
                                backgroundColor: white,
                                borderColor: white,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextWidget(
                                    text: homeController.notificationModel[index].title.toString(),
                                    fontWeight: FontWeight.bold,
                                    size: 12,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8, bottom: 5),
                            child: TextWidget(
                              text: homeController.notificationModel[index].subTile.toString(),
                              size: 10,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextWidget(
                        //text: '28 Feb',
                        text: homeController.notificationModel[index].date.toString(),
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child:Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: color,
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(3, 1), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}