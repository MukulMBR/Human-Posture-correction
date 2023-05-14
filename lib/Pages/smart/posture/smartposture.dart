import 'package:smartposture/Pages/smart/posture/analysis.dart';
import 'package:smartposture/Pages/smart/posture/piechart.dart';
import 'package:flutter/material.dart';
import '../posture/bad_posture_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'points.dart';

class SmartPosture extends StatefulWidget {
  const SmartPosture({Key? key}) : super(key: key);
  @override
  _SmartPostureState createState() => _SmartPostureState();
}

class _SmartPostureState extends State<SmartPosture> {
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
        _databaseReference = FirebaseDatabase.instance.reference().child('/users/$documentId/$sensorValue/angle');
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
      appBar: AppBar(
        title: const Text('Smart Posture'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpPoint()),
              );
            },
            icon: const Icon(Icons.scoreboard),
          ),
        ],
      
      ),
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
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    'Sensor data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.1,
                  angle: 90,
                ),
                GaugeAnnotation(
                  widget: Text(
                    '$_sensorData cm',
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
        ],
        onTap: (index) {
          if (index == 0) {
            // handle settings button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChartPage()),
            );
          } else if (index == 1) {
            // handle profile button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PosturePieChart()),
            );
          } else if (index == 2) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PosturePage()),
            );
          }
        },
      ),
    );
  }
}
