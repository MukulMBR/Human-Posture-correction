import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PosturePage extends StatefulWidget {
  @override
  _PosturePageState createState() => _PosturePageState();
}

class _PosturePageState extends State<PosturePage> {
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
