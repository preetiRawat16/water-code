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
                  reservedSize: 50, // Create enough space for labels
                  getTitlesWidget: (value, meta) {
                    // Dynamic interval: Show labels that make sense for the data range
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
                    // Display title only for indices divisible by 7
                    if (index % 7 == 0 && index >= 0 && index < dateValues.length) {
                      return Text(
                        dateValues[index].key.split(' ')[0], // Show only the date
                        style: TextStyle(fontSize: 10),
                      );
                    }
                    return const SizedBox.shrink();
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
                  y: dma5,
                  color: Colors.red, // Color for the 5 DMA line
                  strokeWidth: 2,
                  dashArray: [5, 5], // Dotted line
                ),
                HorizontalLine(
                  y: dma20,
                  color: Colors.green, // Color for the 20 DMA line
                  strokeWidth: 2,
                  dashArray: [5, 5], // Dotted line
                ),
                HorizontalLine(
                  y: dma50,
                  color: Colors.blue, // Color for the 50 DMA line
                  strokeWidth: 2,
                  dashArray: [5, 5], // Dotted line
                ),
                HorizontalLine(
                  y: dma100,
                  color: Colors.orange, // Color for the 100 DMA line
                  strokeWidth: 2,
                  dashArray: [5, 5], // Dotted line
                ),
                HorizontalLine(
                  y: dma200,
                  color: Colors.purple, // Color for the 200 DMA line
                  strokeWidth: 2,
                  dashArray: [5, 5], // Dotted line
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
          ),
        ),
      ),
    );
  }
}
