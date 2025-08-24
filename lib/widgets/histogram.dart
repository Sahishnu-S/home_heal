import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Histogram extends StatelessWidget{
  const Histogram(this.data, {super.key});

  final List<Map<String, dynamic>> data;

  List<BarChartGroupData> groups(BuildContext context) {
    final List<BarChartGroupData> result = [];
    final List<int> durations = data.map((e) {
      final value = e['duration'];
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw Exception("Unsupported type for 'duration': ${value.runtimeType}");
    }).toList();
    final int columnCount = ((MediaQuery.of(context).size.width - 50) / 70).floor();
    final int minDuration = durations.isNotEmpty? durations.reduce((a, b) => a<b ?a : b): 0;
    final int maxDuration = durations.isNotEmpty?  durations.reduce((a, b) => a > b ? a : b):0;
    final int range = maxDuration - minDuration + 1;
    final int binSize = (range / columnCount).ceil();

    final List<int> bins = List.filled(columnCount, 0);

    for (int duration in durations) {
      int binIndex = ((duration - minDuration) / binSize).floor();
      if (binIndex >= columnCount) binIndex = columnCount - 1;
      bins[binIndex]++;
    }

    print(bins);
    for (int i = 0; i < columnCount; i++) {
      result.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: bins[i].toDouble(), color: Theme.of(context).colorScheme.tertiary.withAlpha(60+60*i), width: 60, borderRadius: BorderRadius.all(Radius.zero))],
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: groups(context),
          
        )
      ),
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class HistogramWidget extends StatelessWidget {
//   final List<double> data; // Your raw data

//   const HistogramWidget({Key? key, required this.data}) : super(key: key);

//   // Helper function to calculate bins and frequencies
//   Map<String, int> _calculateFrequencies(List<double> data) {
//     // Define your bins and calculate frequencies here
//     // For example, bins could be 0-10, 10-20, 20-30, etc.
//     final Map<String, int> frequencies = {};
//     // ... logic to populate frequencies ...
//     return frequencies;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, int> binFrequencies = _calculateFrequencies(data);
//     final List<BarGroupData> barGroups = binFrequencies.entries.map((entry) {
//       // Convert bin name (e.g., "0-10") to a numeric position for the x-axis
//       final int xValue = binFrequencies.keys.toList().indexOf(entry.key);
//       return BarGroupData(
//         x: xValue, // Use the index of the bin as the x-axis value
//         barRods: [
//           BarRodData(
//             toY: entry.value.toDouble(), // Frequency of the bin
//             color: Colors.blue,
//             width: 20, // Adjust bar width
//           ),
//         ],
//       );
//     }).toList();

//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: binFrequencies.values.isEmpty ? 1 : binFrequencies.values.reduce(max).toDouble() + 1,
//         barGroups: barGroups,
//         titlesData: FlTitlesData(
//           show: true,
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getAxisLabelWidget: (value, meta) {
//                 // Show bin labels on the x-axis
//                 return Text(
//                   binFrequencies.keys.elementAt(value.toInt()),
//                   style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
//                 );
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: false),
//       ),
//     );
//   }
// }