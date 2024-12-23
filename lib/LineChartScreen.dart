import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartScreen extends StatelessWidget {
  final String nseCode;
  final List<MapEntry<String, String>> dateValues;

  const LineChartScreen({Key? key, required this.nseCode, required this.dateValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse data for the chart
    List<FlSpot> spots = [];
    for (var entry in dateValues) {
      double? yValue = double.tryParse(entry.value);
      if (yValue != null) {
        // Use the index as the x-coordinate (days)
        spots.add(FlSpot(dateValues.indexOf(entry).toDouble(), yValue));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart for $nseCode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,// Add margin here to increase space on the left
// Create space for the left axis labels
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      // Display title only for indices divisible by 7
                      if (index % 7 == 0 && index >= 0 && index < dateValues.length) {
                        return Text(
                          dateValues[index].key.split(' ')[0], // Show only the date
                          style: TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink(); // Hide titles for other indices
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Disable right axis titles
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Disable top axis titles
                ),
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 505,
                    color: Colors.red, // Color for the lowest line
                    strokeWidth: 2,
                    dashArray: null, // Solid line
                  ),
                  HorizontalLine(
                    y: 515,
                    color: Colors.green, // Color for the middle line
                    strokeWidth: 2,
                    dashArray: [5, 5], // Dotted line
                  ),
                  HorizontalLine(
                    y: 531,
                    color: Colors.blue, // Color for the highest line
                    strokeWidth: 2,
                    dashArray: null, // Solid line
                  ),
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
            )
        ),
      ),
    );
  }
}
