import 'package:smartposture/Pages/analysis.dart';
import 'package:smartposture/Pages/piechart.dart';
import 'package:flutter/material.dart';
import 'bad_posture_analysis.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late DatabaseReference _databaseReference;
  double _sensorData = 0;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child('distance');
    _databaseReference.onValue.listen((event) {
      setState(() {
        _sensorData = double.parse(event.snapshot.value.toString());
      });
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
        title: const Text('My Widget'),
      ),
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
        currentIndex: 0,// set the background color to green
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
