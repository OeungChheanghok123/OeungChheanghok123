import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class HomeScreenBarChart extends StatelessWidget {
  final List<ReportChart> chartData;
  const HomeScreenBarChart({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        minY: 0,
        groupsSpace: 20,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: getLeftTitle(),
          bottomTitles: getBottomTitle(),
          topTitles: getTopTitle(),
          rightTitles: getRightTitle(),
        ),
        barGroups: chartData.map((data) => BarChartGroupData(
              barsSpace: 40,
              x: data.id,
              barRods: [
                BarChartRodData(
                  toY: data.price,
                  width: 30,
                  color: rabbit,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            )).toList(),
      ),
    );
  }

  AxisTitles getLeftTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 2.toDouble(),
      reservedSize: 25.toDouble(),
      getTitlesWidget: (double value, titleMeta) => TextWidget(
        text: value == 0 ? '0' : '${value.toInt()}\$',
      ),
    ),
  );
  AxisTitles getRightTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: false,
      interval: 10.toDouble(),
      reservedSize: 30.toDouble(),
      getTitlesWidget: (double value, titleMeta) => TextWidget(
        text: '${value.toInt()}\$',
      ),
    ),
  );
  AxisTitles getBottomTitle() => AxisTitles(
    sideTitles:  SideTitles(
      showTitles: true,
      reservedSize: 45.toDouble(),
      getTitlesWidget: (double id, value) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: TextWidget(
          textAlign: TextAlign.center,
          text: chartData.firstWhere((element) => element.id == id.toInt()).date,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
  AxisTitles getTopTitle() => AxisTitles(
    sideTitles:  SideTitles(
      showTitles: false,
      reservedSize: 45.toDouble(),
      getTitlesWidget: (double id, value) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: TextWidget(
          textAlign: TextAlign.center,
          text: chartData.firstWhere((element) => element.id == id.toInt()).date,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}