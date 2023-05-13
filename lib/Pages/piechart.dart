import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class PosturePieChart extends StatefulWidget {
  @override
  _PosturePieChartState createState() => _PosturePieChartState();
}

class _PosturePieChartState extends State<PosturePieChart> {
  List<List<dynamic>> _rows = [];

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
      final List<List<dynamic>> csvTable = CsvToListConverter().convert(response.body);
      setState(() {
        _rows = csvTable;
      });
    } catch (e) {
      print('Error loading CSV file: $e');
    }
  }

  Map<String, int> _calculatePostureCounts() {
    int goodPostureCount = 0;
    int badPostureCount = 0;
    for (int i = 1; i < _rows.length; i++) {
      final int postureValue = _rows[i][2];
      if (postureValue > 13) {
        badPostureCount++;
      } else {
        goodPostureCount++;
      }
    }
    return {'Good': goodPostureCount, 'Bad': badPostureCount};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Pie Chart'),
      ),
      body: Center(
        child: _rows.isEmpty
            ? CircularProgressIndicator()
            : _buildChart(),
      ),
    );
  }

    Widget _buildChart() {
  final Map<String, int> postureCounts = _calculatePostureCounts();
  final int totalPostures = postureCounts['Good']! + postureCounts['Bad']!;
  final double goodPosturePercentage = (postureCounts['Good']! / totalPostures) * 100;
  final double badPosturePercentage = (postureCounts['Bad']! / totalPostures) * 100;
  final List<charts.Series<PostureCount, String>> seriesList = [    charts.Series<PostureCount, String>(     
     id: 'Posture',      
     domainFn: (PostureCount count, _) => count.displayText,   
      measureFn: (PostureCount count, _) => count.count, 
      colorFn: (PostureCount count, _) =>          
      charts.ColorUtil.fromDartColor(count.postureType == 'Good' ? Colors.green : Colors.red),
      data: [
        PostureCount('Good', postureCounts['Good']!, '${goodPosturePercentage.toStringAsFixed(2)}% Good Posture'),
        PostureCount('Bad', postureCounts['Bad']!, '${badPosturePercentage.toStringAsFixed(2)}% Bad Posture'),
      ],
      
    ),
  ];
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Good Posture VS Bad Posture',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 16),
      Expanded(
        child: charts.PieChart(seriesList, animate: true),
      ),
      SizedBox(height: 16),
      Text(
        'Good Posture: ${goodPosturePercentage.toStringAsFixed(2)}%',
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Bad Posture: ${badPosturePercentage.toStringAsFixed(2)}%',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

}

class PostureCount {
  final String postureType;
  final int count;
  final String displayText;

  PostureCount(this.postureType, this.count, this.displayText);
}