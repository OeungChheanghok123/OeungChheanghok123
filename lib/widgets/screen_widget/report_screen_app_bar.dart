import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/report_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class ReportScreenAppBars extends StatelessWidget implements PreferredSize {
  const ReportScreenAppBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportController reportController = Get.put(ReportController());

    return AppBar(
      backgroundColor: lightGray,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => TextWidget(
              isTitle: true,
              text: reportController.dateMonthReport.value,
            ),
          ),
          const IconWidget(
            icon: Icons.arrow_drop_down_sharp,
            size: 20,
            color: black,
          ),
        ],
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
