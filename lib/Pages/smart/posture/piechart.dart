import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class PosturePieChart extends StatefulWidget {
  @override
  _PosturePieChartState createState() => _PosturePieChartState();
}

class _PosturePieChartState extends State<PosturePieChart> {
  List<List<dynamic>> _rows = [];
  int goodPostureCount = 0;
  int badPostureCount = 0;
  String url = '';
  String value='';
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

  Future<void> _fetchCsvData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final csv = response.body;
      _parseCsvData(csv);
    } else {
      throw Exception('Failed to load CSV data');
    }
  }

  void _parseCsvData(String csv) {
    final lines = csv.trim().split('\n');
    for (int i = 1; i < lines.length; i++) {
      final fields = lines[i].split(',');
      final value = int.tryParse(fields[2]) ?? 0;
      if (value > 140) {
        badPostureCount++;
      } else {
        goodPostureCount++;
      }
    }
    setState(() {
      value='true';
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
        _fetchCsvData();
      } else {
        // handle error: no document found for the user
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
    });
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Count Page'),
      ),
      body: Center(
        child: value!='true' 
        ? CircularProgressIndicator()
        :_buildChart(),
      ),
    );
  }

    Widget _buildChart() {
  return Stack(
    children: [
      Center(
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 100,
            borderData: FlBorderData(show: false),
            sections: [
              PieChartSectionData(
                value: goodPostureCount.toDouble(),
                color: Colors.greenAccent,
                title: '$goodPostureCount'
              ),
              PieChartSectionData(
                value: badPostureCount.toDouble(),
                color: Colors.redAccent,
                title: '$badPostureCount'
              ),
            ],
          ),
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.greenAccent),
                SizedBox(width: 8.0),
                Text('Good Posture'),
                SizedBox(width: 16.0),
                Icon(Icons.circle, color: Colors.redAccent),
                SizedBox(width: 8.0),
                Text('Bad Posture'),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

}
