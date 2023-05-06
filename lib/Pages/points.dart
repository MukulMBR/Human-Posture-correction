import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Point extends StatefulWidget {
  @override
  _PointState createState() => _PointState();
}
class _PointState extends State<Point> {
  List<List<dynamic>> _rows = [];
  Map<DateTime, double> _goodPointCounts = {};
  Map<DateTime, double> _badPointCounts = {};
  @override
  void initState() {
    super.initState();
    _loadCSV();
  }
  Future<void> _loadCSV() async {
    try {
      final response = await http.get(Uri.parse('https://drive.google.com/uc?id=17_UgYlbGAoKIHtRNgAF0wPkXleq0ExGf&export=download'));
      final List<List<dynamic>> csvTable = CsvToListConverter().convert(response.body);
      setState(() {
        _rows = csvTable;
        _calculatePostureCounts();
      });
    } catch (e) {
      print('Error loading CSV file: $e');
    }
  }
  void _calculatePostureCounts() {
  DateTime intervalStart = DateTime.parse(_rows[1][0]);
  double intervalPoints = 0.0;
  double badPoints = 0.0;

  for (int i = 1; i < _rows.length; i++) {
    final DateTime timestamp = DateTime.parse(_rows[i][0]);
    final int postureValue = _rows[i][2];

    // Check if current timestamp is within current interval
    if (intervalStart == null || timestamp.difference(intervalStart).inMinutes >= 10) {
      // Interval has ended, save points and reset interval data
      _addIntervalPoints(intervalStart, intervalPoints, badPoints);
      intervalStart = timestamp;
      intervalPoints = 0.0;
      badPoints = 0.0;
    }

    // Update interval points based on posture value
    if (postureValue > 13) {
      badPoints += 1.0;
    } else {
      intervalPoints += 1.0;
    }
  }

  // Save points for final interval
  _addIntervalPoints(intervalStart, intervalPoints, badPoints);
}

void _addIntervalPoints(DateTime intervalStart, double intervalPoints, double badPoints) {
  if (intervalStart != null) {
    final intervalDate = DateTime(intervalStart.year, intervalStart.month, intervalStart.day);
    final totalPoints = intervalPoints - badPoints;
    _goodPointCounts.update(
      intervalDate,
      (value) => value + totalPoints,
      ifAbsent: () => totalPoints,
    );
    _badPointCounts.update(
      intervalDate,
      (value) => value + badPoints,
      ifAbsent: () => badPoints,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Points: ${_goodPointCounts.values.map((value) => value.toInt()).fold(0, (sum, value) => sum + value) - _badPointCounts.values.map((value) => value.toInt()).fold(0, (sum, value) => sum + value)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: 
                ListView.builder(
                  itemCount: _goodPointCounts.length,
                  itemBuilder: (context, index) {
                    final date = _goodPointCounts.keys.elementAt(index);
                    final goodPoints = _goodPointCounts[date] ?? 0;
                    final badPoints = _badPointCounts[date] ?? 0;
                    final totalPoints = goodPoints - badPoints;
                    return ListTile(
                      title: Text('${DateFormat('EEE, MMM d, yyyy').format(date)}'),
                      subtitle: Text('Total Points: $totalPoints'),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}