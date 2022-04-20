import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';

class InviteFriendController extends GetxController{
  var titleText = 'Invite Friends to Earn Points';
  var points = '100p';
  var referralCode = '4323';

  Future<void> shareLink() async {
    await FlutterShare.share(
      title: 'Share Your Link',
      text: 'Invite your friend to use the code $referralCode',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Example Chooser Title',
    );
  }

}