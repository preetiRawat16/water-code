import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartScreen extends StatelessWidget {
  final String nseCode;
  final List<MapEntry<String, String>> dateValues;
  final double dma5;
  final double dma20;
  final double dma50;
  final double dma100;
  final double dma200;

  const LineChartScreen({
    Key? key,
    required this.nseCode,
    required this.dateValues,
    required this.dma5,
    required this.dma20,
    required this.dma50,
    required this.dma100,
    required this.dma200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse data for the chart
    List<FlSpot> spots = [];
    for (var entry in dateValues) {
      double? yValue = double.tryParse(entry.value);
      if (yValue != null) {
        spots.add(FlSpot(dateValues.indexOf(entry).toDouble(), yValue));
      }
    }

    // Calculate min and max y values for vertical axis range
    double minY = spots.isNotEmpty ? spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) : 0;
    double maxY = spots.isNotEmpty ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) : 0;

    // Extend the range by 20 units
    minY -= 20;
    maxY += 20;

    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart for $nseCode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    if (value % 5 == 0) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index % 7 == 0 && index >= 0 && index < dateValues.length) {
                      return Text(
                        dateValues[index].key.split(' ')[0],
                        style: TextStyle(fontSize: 10),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(y: dma5, color: Colors.green, strokeWidth: 2, dashArray: [5, 5]),
                HorizontalLine(y: dma20, color: Colors.blue, strokeWidth: 2, dashArray: [5, 5]),
                HorizontalLine(y: dma50, color: Colors.yellow, strokeWidth: 2, dashArray: [5, 5]),
                HorizontalLine(y: dma100, color: Colors.purple, strokeWidth: 2, dashArray: [5, 5]),
                HorizontalLine(y: dma200, color: Colors.red, strokeWidth: 2, dashArray: [5, 5]),
              ],
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 


