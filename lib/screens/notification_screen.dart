import 'package:cloud_firestore/cloud_firestore.dart';
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

  final notification = FirebaseFirestore.instance.collection('notification');
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    final data = notification.where('isRead', isEqualTo: true).snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        homeController.readAll.value = false;
      }
      else {
        homeController.readAll.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homeController.wait3SecAndLoadData(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          final error = snapshot.error;
          return Scaffold(
            backgroundColor: lightGray,
            body: Center(child: TextWidget(text: "$error")),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          String text = 'Loading...';
          return Scaffold(
            backgroundColor: lightGray,
            body: Center(child: TextWidget(text: text)),
          );
        }

        return SafeArea(
          child: Scaffold(
            extendBody: true,
            backgroundColor: lightGray,
            appBar: appBar(icon: Icons.arrow_back_ios, appBarText: "Notification"),
            body: StreamBuilder<QuerySnapshot>(
              stream: notification.orderBy('date', descending: true).snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasError) {
                  return const Center(child: TextWidget(text: 'Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: TextWidget(text: 'Loading...'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String,dynamic> data = document.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: (){
                        Get.toNamed('/notification_detail', arguments: {'ref_id': data['ref_id']});
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
                                                    text: data['title'],
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
                                              text: data['body'],
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
                                        text: data['date'],
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
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: data['isRead'] ? none : rabbit,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: data['isRead'] ? none : rabbit,
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
                  }).toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }

  AppBar appBar({required IconData icon, required String appBarText}) {
    return AppBar(
      backgroundColor: white,
      elevation: 0,
      titleSpacing: 0,
      leading: _buildLeadingAppBar(icon),
      title: _buildTitleAppBar(appBarText),
      actions: _buildActionButton(),
    );
  }

  Widget _buildLeadingAppBar(IconData iconData) {
    return InkWell(
      onTap: () {
        Get.back();

        notification.where('isRead', isEqualTo: false).get().then((QuerySnapshot snapshot) => {
          homeController.notificationCount.value = snapshot.docs.length,
        });
      },
      child: IconWidget(
        icon: iconData,
        color: black,
        size: 24,
      ),
    );
  }
  Widget _buildTitleAppBar(String text) {
    return TitleAppBarWidget(
      text: text,
    );
  }
  List<Widget> _buildActionButton() {
    return [
      Obx(() => InkWell(
        splashColor: none,
        onTap: () {
          notification.where('isRead', isEqualTo: false).get().then((QuerySnapshot snapshot) => {
            // ignore: avoid_function_literals_in_foreach_calls
            snapshot.docs.forEach((element) {
              notification.doc(element.id).update({'isRead': true});
            }),
          });
          homeController.readAll.value = true;
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 10),
          child:  TextWidget(
            text: 'Read all',
            color: homeController.readAll.value ? silver : rabbit,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    ];
  }
}