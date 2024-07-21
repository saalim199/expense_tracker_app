import 'package:expense_tracker_app/bloc/expense%20bloc/expense_bloc.dart';
import 'package:expense_tracker_app/graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  final int startYear;
  const BarGraph(
      {super.key,
      required this.monthlySummary,
      required this.startMonth,
      required this.startYear});

  @override
  State<StatefulWidget> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<IndividualBar> barsData = [];

  Map<int, String> monthMap = {
    0: 'Jan',
    1: 'Feb',
    2: 'Mar',
    3: 'Apr',
    4: 'May',
    5: 'Jun',
    6: 'Jul',
    7: 'Aug',
    8: 'Sep',
    9: 'Oct',
    10: 'Nov',
    11: 'Dec',
  };

  void initializeBarsData() {
    barsData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: index,
        y: widget.monthlySummary[index],
      ),
    );
  }

  double calculateMaxValue() {
    double max = 500;
    widget.monthlySummary.sort();
    if (widget.monthlySummary.isNotEmpty) {
      max = widget.monthlySummary.last * 1.05;
    }
    if (max < 500) {
      return 500;
    } else {
      return max;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeBarsData();
    double barWidth = 20;
    double spaceBetweenBars = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: barWidth * barsData.length +
              spaceBetweenBars * (barsData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMaxValue(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitle,
                    reservedSize: 24,
                  ),
                ),
              ),
              barGroups: barsData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.y,
                          width: 20,
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: calculateMaxValue(),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
              barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final month = monthMap[
                          (group.x.toInt() + widget.startMonth - 1) % 12] ??
                      '';
                  final expense = rod.toY.toString();
                  return BarTooltipItem(
                    '$month : $expense',
                    const TextStyle(color: Colors.red),
                  );
                },
              ), touchCallback:
                  (FlTouchEvent event, BarTouchResponse? response) {
                if (event is FlTapUpEvent && response != null) {
                  final monthIndex = response.spot!.touchedBarGroup.x.toInt();
                  final month = (monthIndex + widget.startMonth) % 12;
                  final year = ((monthIndex + widget.startMonth) ~/ 12) +
                      widget.startYear;
                  context
                      .read<ExpenseBloc>()
                      .add(ReadMonthExpesnes(year: year, month: month));
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomTitle(double value, TitleMeta meta) {
    const textStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = monthMap[(value.toInt() + widget.startMonth - 1) % 12] ?? '';
    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          text,
          style: textStyle,
        ));
  }
}
