import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/rating_score_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class RatingScoreScreen extends StatefulWidget {
  const RatingScoreScreen({Key? key}) : super(key: key);

  @override
  _RatingScoreScreenState createState() => _RatingScoreScreenState();
}

class _RatingScoreScreenState extends State<RatingScoreScreen> {
  RatingScoreController ratingScoreController =
  Get.put(RatingScoreController());

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
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: ratingScoreController.titleText.tr),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              _buildTotalScore,
              _buildRecentFeedback,
              _buildHorizontalLine,
              _buildSatisfactionDetail,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildTotalScore {
    return Column(
      children: [
        TextWidget(text: 'Total Satisfaction Score'.tr),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                isTitle: true,
                text: '${ratingScoreController.totalScorePercentage.value}%',
                color: rabbit,
              ),
              const Space(),
              const IconWidget(icon: Icons.thumb_up),
            ],
          ),
        ),
        TextWidget(
          text: '('+ 'Aim'.tr + ' >= 90%)',
          color: rabbit,
        )
      ],
    );
  }

  Widget get _buildRecentFeedback {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Recent Feedback'.tr,
            isTitle: true,
          ),
          _buildDetailFeedbackAndRating(1, 'You did a great service.', 4),
          _buildDetailFeedbackAndRating(
              2, 'You did a great service. Keep your work.', 5),
          _buildDetailFeedbackAndRating(3, 'Why too late? I don\'t like.', 3),
        ],
      ),
    );
  }

  Widget get _buildSatisfactionDetail {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextWidget(
              isTitle: true,
              text: 'Satisfaction Detail',
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TextWidget(
                    text: 'All time ratings',
                    size: 10,
                  ),
                  IconWidget(
                    icon: Icons.keyboard_arrow_down,
                    color: black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        _buildCustomerRating,
        _buildMerchantRating,
      ],
    );
  }

  Widget get _buildCustomerRating {
    int rating = 5;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Customer',
                color: rabbit,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text:
                    '${ratingScoreController.totalCustomerPercentage.value}%',
                    fontWeight: FontWeight.bold,
                    color: rabbit,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: const IconWidget(
                      icon: Icons.thumb_up,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const DottedLine(
              dashLength: 2.5,
              lineThickness: 2,
              dashColor: silver,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    TextWidget(
                      text: '4.0',
                      size: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    TextWidget(text: 'Out of 5'),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: rating,
                  itemBuilder: (context, index) {
                    return _buildStarRating(rating--);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _buildMerchantRating {
    int rating = 5;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Merchant',
                color: rabbit,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text:
                    '${ratingScoreController.totalMerchantPercentage.value}%',
                    fontWeight: FontWeight.bold,
                    color: rabbit,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: const IconWidget(
                      icon: Icons.thumb_up,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const DottedLine(
              dashLength: 2.5,
              lineThickness: 2,
              dashColor: silver,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    TextWidget(
                      text: '4.5',
                      size: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    TextWidget(text: 'Out of 5'),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: rating,
                  itemBuilder: (context, index) {
                    return _buildStarRating(rating--);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _buildHorizontalLine {
    return Container(
      width: double.infinity,
      height: 1.5,
      color: silver,
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
    );
  }

  Widget _buildDetailFeedbackAndRating(int index, String text, int itemCount) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 0,
                  child: TextWidget(text: '$index.'),
                ),
                Expanded(
                  child: TextWidget(text: text),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.minPositive,
              height: 20,
              margin: const EdgeInsets.only(left: 45),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: const [
                      IconWidget(
                        icon: Icons.star_outlined,
                        color: black,
                        size: 20,
                      ),
                      Space(width: 3),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(int itemCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              width: double.minPositive,
              height: 20,
              child: Align(
                alignment: Alignment.centerRight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconWidget(
                        icon: itemCount > 1
                            ? Icons.star_outlined
                            : Icons.star_border_outlined,
                        color: black,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              child: TextWidget(
                text: itemCount > 1 ? '${itemCount * 2}' : '0',
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const Space(),
        ],
      ),
    );
  }
}