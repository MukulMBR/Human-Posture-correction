import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<charts.Series<DataPoint, DateTime>> _seriesData = [];
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

  _generateDataFromCsv(String csv) {
    List<DataPoint> dataPoints = [];
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(csv);

    for (int i = 1; i < lines.length; i++) {
      List<String> fields = lines[i].split(',');

      int entryId = int.parse(fields[1]);
      int value = int.parse(fields[2]);

      DateTime dateTime = DateTime.parse(fields[0]).toLocal();

      DataPoint dataPoint = DataPoint(dateTime, value);
      dataPoints.add(dataPoint);
    }

    _seriesData.add(
      charts.Series(
        id: 'Data',
        data: dataPoints,
        domainFn: (DataPoint dataPoint, _) => dataPoint.dateTime,
        measureFn: (DataPoint dataPoint, _) => dataPoint.value,
      ),
    );
    }

  Future<String> _fetchCsvData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load CSV data');
    }
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
        _fetchCsvData().then((csv) {
      _generateDataFromCsv(csv);
      setState(() {});
    }).catchError((error) {
      print('Error loading CSV: $error');
    });
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
        title: Text('Chart Page'),
      ),
      body: Center(
        child: _seriesData.isNotEmpty
            ? charts.TimeSeriesChart(
                _seriesData,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class DataPoint {
  final DateTime dateTime;
  final int value;

  DataPoint(this.dateTime, this.value);
}