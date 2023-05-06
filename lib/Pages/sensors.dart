import 'package:smartposture/Pages/analysis.dart';
import 'package:smartposture/Pages/piechart.dart';
import 'package:flutter/material.dart';
import 'package:smartposture/Pages/smartchair.dart';
import 'package:smartposture/Pages/smartposture.dart';
import '../components/square_title.dart';
import 'bad_posture_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_svg/flutter_svg.dart';

class sensors extends StatefulWidget {
  const sensors({Key? key}) : super(key: key);
  @override
  _sensorsState createState() => _sensorsState();
}

class _sensorsState extends State<sensors> {

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Smart Chair and Smart Posture'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Analysis()),
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage('lib/imports/images/sc.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            'Smart Chair',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Posture()),
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage('lib/imports/images/sp.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            'Smart Posture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    ),
    body: Center(
      child: SfRadialGauge(),
    ),
  );
  }
}