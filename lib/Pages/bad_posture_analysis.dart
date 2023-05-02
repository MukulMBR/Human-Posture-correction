import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PosturePage extends StatefulWidget {
  @override
  _PosturePageState createState() => _PosturePageState();
}

class _PosturePageState extends State<PosturePage> {
  List<List<dynamic>> data = [];
  Map<String, List<Map<String, dynamic>>> badPostureData = {};

  Future<void> loadAsset() async {
    final response = await http.get(Uri.parse('https://drive.google.com/uc?id=17_UgYlbGAoKIHtRNgAF0wPkXleq0ExGf&export=download'));
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
  void initState() {
    super.initState();
    loadAsset();
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
