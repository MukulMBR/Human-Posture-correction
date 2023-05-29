import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;


class Posture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // add back button
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // Add back button functionality
                },
                icon: const Icon(Icons.arrow_back), // Use the appropriate back icon
              ),
              const SizedBox(width: 8), // Add some spacing between back button and title
              Center(
                 child: Text(' Smart Chair and Posture'),
                        ),
            ],
          ),
          centerTitle: false, // align title to the left
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Image.asset(
                  'lib/imports/images/sc.jpg',
                  height: 40,
                  width: 40,
                ),
                text: 'Smart Chair',
              ),
              Tab(
                icon: Image.asset(
                  'lib/imports/images/sp.png',
                  height: 40,
                  width: 40,
                ),
                text: 'Smart Posture',
              ),
            ],
          ),
        ),

          body: TabBarView(
            children: [
              SmartChair(),
              Smartposture(),
            ],
          ),
        ),
      ),
    );
  }
}

class SmartChair extends StatefulWidget {
  @override
  _SmartChairState createState() => _SmartChairState();
}

class Smartposture extends StatefulWidget {
  @override
  _SmartpostureState createState() => _SmartpostureState();
}

class ScChartPage extends StatefulWidget {
  @override
  _ScChartPageState createState() => _ScChartPageState();
}

class ScPosturePieChart extends StatefulWidget {
  @override
  _ScPosturePieChartState createState() => _ScPosturePieChartState();
}

class ScPosturePage extends StatefulWidget {
  @override
  _ScPosturePageState createState() => _ScPosturePageState();
}

class ScPoint extends StatefulWidget {
  @override
  _ScPointState createState() => _ScPointState();
}

class SpChartPage extends StatefulWidget {
  @override
  _SpChartPageState createState() => _SpChartPageState();
}

class SpPosturePage extends StatefulWidget {
  @override
  _SpPosturePageState createState() => _SpPosturePageState();
}

class SpPosturePieChart extends StatefulWidget {
  @override
  _SpPosturePieChartState createState() => _SpPosturePieChartState();
}

class DSpPoint extends StatefulWidget {
  @override
  _DSpPointState createState() => _DSpPointState();
}

class _SmartChairState extends State<SmartChair> {
  User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _databaseReference;
  double _sensorData = 0;
  List<String> docIDs = [];
  late final String documentId;
  String sensorValue = '';
  
  //get document IDs
  Future<void> getDocID() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();
      setState(() {
        docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
            Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
            sensorValue = (userData?['sensor'] as String?)!;
      });
  }
  List<String> gaugeDocIDs = [];
  @override
  void initState() {
    super.initState();
    getDocID().then((value) {
      if (docIDs.isNotEmpty) {
        documentId = docIDs[0];
        _databaseReference = FirebaseDatabase.instance.reference().child('/users/$documentId/$sensorValue/Smart Chair/distance');
        _databaseReference.onValue.listen((event) {
          setState(() {
            gaugeDocIDs = docIDs;
            _sensorData = double.parse(event.snapshot.value.toString());
          });
        }, onError: (Object? error) {
          // handle error: failed to fetch sensor data from the realtime database
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to fetch sensor data from the realtime database. Please check the database path and try again.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      } else {
        // handle error: no document found for the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No document found for the user. Please check your account and try again.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch the document ID from Firestore. Please check your account and try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _databaseReference.onDisconnect();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 100,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 50,
                  color: Colors.green,
                ),
                GaugeRange(
                  startValue: 50,
                  endValue: 80,
                  color: Colors.orange,
                ),
                GaugeRange(
                  startValue: 80,
                  endValue: 100,
                  color: Colors.red,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: _sensorData,
                  enableAnimation: true,
                  animationDuration: 500,
                  animationType: AnimationType.easeOutBack,
                ),
              ],
              annotations: [
                if (_sensorData < 14)
                  GaugeAnnotation(
                    widget: Text(
                      'Good Posture',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.3,
                    angle: 90,
                  ),
                GaugeAnnotation(
                  widget: Text(
                    _sensorData < 14 ? '$_sensorData' : 'Bad Posture',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.6,
                  angle: 90,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Ratio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous),
            label: 'Bad Posture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard),
            label: 'Points',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // handle settings button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScChartPage()),
            );
          } else if (index == 1) {
            // handle profile button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScPosturePieChart()),
            );
          } else if (index == 2) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScPosturePage()),
            );
          }
          else if (index == 3) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScPoint()),
            );
          }
        },
      ),
    );
  }
}

class _ScChartPageState extends State<ScChartPage> {
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
      url = (userData?['curl'] as String?)!;
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

class _ScPosturePieChartState extends State<ScPosturePieChart> {
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
      url = (userData?['curl'] as String?)!;
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
      if (value > 13) {
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

class _ScPosturePageState extends State<ScPosturePage> {
  List<List<dynamic>> data = [];
  Map<String, List<Map<String, dynamic>>> badPostureData = {};
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
      url = (userData?['curl'] as String?)!;
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
        loadAsset();
      } else {
        // handle error: no document found for the user
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
    });
  }

  Future<void> loadAsset() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<List<dynamic>> csvTable = CsvToListConverter().convert(response.body);
      setState(() {
        data = csvTable;
        _analyzeBadPostureData();
      });
    } else {
      throw Exception('Failed to load CSV data');
    }
  }

  void _analyzeBadPostureData() {
    for (var i = 0; i < data.length; i++) {
      int postureValue = int.tryParse(data[i][2].toString()) ?? 0;
      if (postureValue > 14) {
        final date = data[i][0].toString().split(" ")[0];
        final time = data[i][0].toString().split(" ")[1];
        if (badPostureData.containsKey(date)) {
          badPostureData[date]?.add({'time': time, 'issuse': postureValue});
        } else {
          badPostureData[date] = [{'time': time, 'issuse': postureValue}];
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Analysis'),
      ),
      body: ListView.builder(
        itemCount: badPostureData.length,
        itemBuilder: (BuildContext context, int index) {
          final date = badPostureData.keys.elementAt(index);
          final badPostureList = badPostureData[date];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Date: $date',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  itemCount: badPostureList?.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final time = badPostureList![index]['time'];
                    final issuse = 'Bad Posture';
                    return ListTile(
                      title: Text('Time: $time'),
                      subtitle: Text('issuse: $issuse'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScPointState extends State<ScPoint> {

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
      url = (userData?['curl'] as String?)!;
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

class DataPoint {
  final DateTime dateTime;
  final int value;

  DataPoint(this.dateTime, this.value);
}

class _SmartpostureState extends State<Smartposture> {
 User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _databaseReference;
  double _sensorData = 0;
  List<String> docIDs = [];
  late final String documentId;
  String sensorValue = '';
  
  //get document IDs
  Future<void> getDocID() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();
      setState(() {
        docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
            Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
            sensorValue = (userData?['sensor'] as String?)!;
      });
  }
  List<String> gaugeDocIDs = [];
  @override
  void initState() {
    super.initState();
    getDocID().then((value) {
      if (docIDs.isNotEmpty) {
        documentId = docIDs[0];
        _databaseReference = FirebaseDatabase.instance.reference().child('/users/$documentId/$sensorValue/Smart Posture/angle');
        _databaseReference.onValue.listen((event) {
          setState(() {
            gaugeDocIDs = docIDs;
            _sensorData = double.parse(event.snapshot.value.toString());
          });
        }, onError: (Object? error) {
          // handle error: failed to fetch sensor data from the realtime database
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to fetch sensor data from the realtime database. Please check the database path and try again.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      } else {
        // handle error: no document found for the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No document found for the user. Please check your account and try again.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch the document ID from Firestore. Please check your account and try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _databaseReference.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 100,
              maximum: 200,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.green,
                ),
                GaugeRange(
                  startValue: 150,
                  endValue: 180,
                  color: Colors.orange,
                ),
                GaugeRange(
                  startValue: 180,
                  endValue: 200,
                  color: Colors.red,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: _sensorData,
                  enableAnimation: true,
                  animationDuration: 500,
                  animationType: AnimationType.easeOutBack,
                ),
              ],
              annotations: [
                if (_sensorData < 140)
                  GaugeAnnotation(
                    widget: Text(
                      'Good Posture',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.3,
                    angle: 90,
                  ),
                  GaugeAnnotation(
                    widget: Text(
                      _sensorData < 140 ? '$_sensorData' : 'Bad Posture',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.6,
                    angle: 90,
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Ratio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous),
            label: 'Bad Posture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard),
            label: 'Points',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // handle settings button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpChartPage()),
            );
          } else if (index == 1) {
            // handle profile button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpPosturePieChart()),
            );
          } else if (index == 2) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpPosturePage()),
            );
          }
          else if (index == 3) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DSpPoint()),
            );
          }
        },
      ),
    );
  }
}

class _SpChartPageState extends State<SpChartPage> {
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

class _SpPosturePageState extends State<SpPosturePage> {
  List<List<dynamic>> data = [];
  Map<String, List<Map<String, dynamic>>> badPostureData = {};
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
        loadAsset();
      } else {
        // handle error: no document found for the user
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
    });
  }

  Future<void> loadAsset() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<List<dynamic>> csvTable = CsvToListConverter().convert(response.body);
      setState(() {
        data = csvTable;
        _analyzeBadPostureData();
      });
    } else {
      throw Exception('Failed to load CSV data');
    }
  }

  void _analyzeBadPostureData() {
    for (var i = 0; i < data.length; i++) {
      int postureValue = int.tryParse(data[i][2].toString()) ?? 0;
      if (postureValue > 140) {
        final date = data[i][0].toString().split(" ")[0];
        final time = data[i][0].toString().split(" ")[1];
        if (badPostureData.containsKey(date)) {
          badPostureData[date]?.add({'time': time, 'issuse': postureValue});
        } else {
          badPostureData[date] = [{'time': time, 'issuse': postureValue}];
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Analysis'),
      ),
      body: ListView.builder(
        itemCount: badPostureData.length,
        itemBuilder: (BuildContext context, int index) {
          final date = badPostureData.keys.elementAt(index);
          final badPostureList = badPostureData[date];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Date: $date',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  itemCount: badPostureList?.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final time = badPostureList![index]['time'];
                    final issuse = 'Bad Posture';
                    return ListTile(
                      title: Text('Time: $time'),
                      subtitle: Text('issuse: $issuse'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpPosturePieChartState extends State<SpPosturePieChart> {
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

class _DSpPointState extends State<DSpPoint> {

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

