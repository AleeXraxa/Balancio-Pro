import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChart extends StatefulWidget {
  final double income;
  final double expense;

  const CustomChart({
    required this.income,
    required this.expense,
    super.key,
  });

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  late double incomePerc;
  late double expensePerc;
  @override
  void initState() {
    double total = widget.income - widget.expense;
    double incomePerc = (widget.income / total * 100);
    double expensePerc = (widget.expense / total * 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 0.2.sh,
              child: PieChart(
                PieChartData(
                    centerSpaceRadius: 60,
                    sectionsSpace: 0,
                    startDegreeOffset: -30,
                    sections: [
                      PieChartSectionData(
                        value: widget.income,
                        color: Colors.green,
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: widget.expense,
                        color: Colors.red,
                        radius: 50,
                        showTitle: false,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
