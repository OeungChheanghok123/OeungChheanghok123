import 'package:flutter/material.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreenBarChart extends StatelessWidget {
  final List<ReportChart> data;

  const HomeScreenBarChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<charts.Series<ReportChart, String>> chart = [
      charts.Series(
        id: "Report Chart",
        data: data,
        domainFn: (ReportChart chart, _) => chart.date,
        measureFn: (ReportChart chart, _) => chart.price,
        colorFn: (ReportChart chart, _) => chart.barColor,
        labelAccessorFn: (ReportChart chart, _) => chart.price == 0 ? '' : '${chart.price}',
      ),
    ];

    return charts.BarChart(
      chart,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: const charts.TextStyleSpec(
          fontSize: 8,
        ),
        labelPosition: charts.BarLabelPosition.outside,
        labelPadding: 5,
        labelAnchor: charts.BarLabelAnchor.end,
      ),
    );
  }
}