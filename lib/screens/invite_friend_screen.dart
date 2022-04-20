import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/invite_friend_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({Key? key}) : super(key: key);

  @override
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  InviteFriendController inviteFriendController = Get.put(InviteFriendController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            splashColor: none,
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: inviteFriendController.titleText),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTotalPoints,
              _buildUnderLine,
              _buildGuildLine,
            ],
          ),
        ),
        bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 30),
          color: white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                onPressed: () => inviteFriendController.shareLink(),
                child: const TextWidget(
                  isTitle: true,
                  text: 'Share Your Link',
                  color: white,
                ),
              ),
              ButtonWidget(
                onPressed: () => Get.toNamed('/qr_code'),
                child: const TextWidget(
                  isTitle: true,
                  text: 'Scan QR Code',
                  color: white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildTotalPoints {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextWidget(text: 'Total Points'),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                isTitle: true,
                text: inviteFriendController.points,
                color: rabbit,
              ),
              const Space(width: 10),
              const IconWidget(icon: Icons.loyalty_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _buildUnderLine {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1.5,
      color: silver,
      margin: const EdgeInsets.symmetric(vertical: 15),
    );
  }

  Widget get _buildGuildLine {
    return Column(
      children: [
        const TextWidget(
          text: 'Invite a friend, Get 5 points with terms:',
          fontWeight: FontWeight.bold,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      flex: 0,
                      child: TextWidget(
                        text: '1. ',
                      ),
                    ),
                    Expanded(
                      child: TextWidget(
                        text: 'Download a Driver App.',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 0,
                      child: TextWidget(
                        text: '2. ',
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'Apply for a driver by using your referral code: ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: inviteFriendController.referralCode,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: carrot,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      flex: 0,
                      child: TextWidget(
                        text: '3. ',
                      ),
                    ),
                    Expanded(
                      child: TextWidget(
                        text: 'The driver is approved and staring the driving job.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}