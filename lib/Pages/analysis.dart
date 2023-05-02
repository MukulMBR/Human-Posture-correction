import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<charts.Series<DataPoint, DateTime>> _seriesData = [];

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
    final response = await http.get(
        Uri.parse(
            'https://drive.google.com/uc?id=17_UgYlbGAoKIHtRNgAF0wPkXleq0ExGf&export=download'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load CSV data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCsvData().then((csv) {
      _generateDataFromCsv(csv);
      setState(() {});
    }).catchError((error) {
      print('Error loading CSV: $error');
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