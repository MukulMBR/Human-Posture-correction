import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SpPoint extends StatefulWidget {
  @override
  _SpPointState createState() => _SpPointState();
}
class _SpPointState extends State<SpPoint> {
  List<List<dynamic>> _rows = [];
  Map<DateTime, double> _goodPointCounts = {};
  Map<DateTime, double> _badPointCounts = {};

  String url = '';
  User? user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference _databaseReference;
  late final String documentId;
  List<String> docIDs = [];

  Future<void> getDocID() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();

    setState(() {
    docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
      Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
      url = (userData?['url'] as String?)!;
    });
  }

  @override
    void initState() {
    super.initState();
    getDocID().then((value) {
      if (docIDs.isNotEmpty) {
        documentId = docIDs[0];
        _databaseReference = FirebaseDatabase.instance.reference().child('/users/$documentId');
        _databaseReference.onValue.listen((event) {
        });
        _loadCSV();
      } else {
        // handle error: no document found for the user
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
    });
  }
  
  Future<void> _loadCSV() async {
    try {
      final response = await http.get(Uri.parse(url));
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(response.body);
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
    if (postureValue > 150) {
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
