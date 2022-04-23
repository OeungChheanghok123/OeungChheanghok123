import 'package:charts_flutter/flutter.dart' as charts;

class ReportChart {
  final String date;
  final double price;
  final charts.Color barColor;

  ReportChart({
    required this.date,
    required this.price,
    required this.barColor,
  });
}