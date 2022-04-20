import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String titleText = 'Invite Friends to Earn Points';

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
            onTap: () => Navigator.pop(context),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: titleText),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitleAndDetail,
                _buildQRCode,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildTitleAndDetail{
    return Column(
      children: [
        const TextWidget(text: 'Scan QR Code', isTitle: true),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          width: 200,
          child: const TextWidget(
            textAlign: TextAlign.center,
            text: 'Ask your friend to open smart phone camera and shoot it!',
          ),
        ),
      ],
    );
  }
  Widget get _buildQRCode{
    return QrImage(
      data: 'https://www.youtube.com/',
      version: QrVersions.auto,
      size: 200,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
  }
}
