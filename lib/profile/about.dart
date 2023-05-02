import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Contact details for the app owner
  final String phoneNumber = "+91 8919866652";
  final String smsMessage = "Hi, welcome to Smart Posture";
  final String emailSubject = "This is the subject title";
  final String emailBody = "This is the body of the email";
  final String websiteUrl = "https://posture2.wordpress.com/";

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to the Good Posture App!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Developed by:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "M Mukul Bushi Reddy",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Kotha Venkata Dheeraj Manjunadh Guptha",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Karanam Balaram",
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
                SizedBox(height: 10),
                Text(
                  "Guide:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Mr. Sumesk AK",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'At our company, we believe that technology can be used to make people\'s lives better. That\'s why we developed this app, which is designed to help you improve your posture and reduce the risk of pain and injury.',
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
          // Contact section with options to call, text, email, and visit website
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Icon(Icons.phone, size: 64, color: Colors.green),
                onTap: () {
                  launch('tel:$phoneNumber');
                },
              ),
              SizedBox(width: 20),
              InkWell(
                child: Icon(Icons.sms, size: 64, color: Colors.orange),
                onTap: () {
                  launch('sms:$phoneNumber?body=$smsMessage');
                },
              ),
              SizedBox(width: 20),
              InkWell(
                child: Icon(Icons.email, size: 64, color: Colors.blue),
                onTap: () {
                  launch('mailto:mukulmbr@gmail.com?subject=$emailSubject&body=$emailBody');
                },
              ),
              SizedBox(width: 20),
              InkWell(
                child: Icon(Icons.language, size: 64, color: Colors.purple),
                onTap: (){
                  launch(websiteUrl);
                },
              ),
            ],
          )

        ],
      ),
    ),
    );
  }
}