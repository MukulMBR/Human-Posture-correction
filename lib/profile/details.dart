import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Posture App'),
      ),
      body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header section with app information and developer details
          Container(
            width: double.infinity,
            color: Colors.blueGrey,
            padding: EdgeInsets.all(20),
            child: Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Guide",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Developed by",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Mr. Sumesk AK",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Karanam Balaram",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Motakatla Mukul Bushi Reddy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Kota Venkata Dheeraj Manjunadh Guptha",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Puli Gnana Venkata Satya Sai Naga nikhil",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Text(
            'As a team, we believe that technology can be used to make people\'s lives better. That\'s why we developed this app, which is designed to help you improve your posture and reduce the risk of pain and injury.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Our team is made up of experienced software developers, designers, and health professionals who are passionate about creating innovative solutions that make a real difference. We\'ve worked hard to create an app that is easy to use, effective, and enjoyable.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Our app uses the latest technology to analyze your posture and provide you with personalized recommendations for improvement. We understand that maintaining good posture can be difficult, but with our app, you\'ll have the tools you need to make it a habit.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Thank you for choosing our app. We hope that it helps you to feel more comfortable and confident in your daily life.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'If you have any questions or feedback, please don\'t hesitate to reach out We\'d love to hear from you!',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    ),
    );
  }
}