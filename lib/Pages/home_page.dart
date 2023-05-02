import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartposture/Pages/points.dart';
import 'package:smartposture/profile/about.dart';
import 'package:flutter/material.dart';
import '../profile/profile.dart';
import 'diplay_analysis.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get document IDs
  Future<void> getDocID() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();

    setState(() {
      docIDs = querySnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getDocID();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Logged In As: ${user!.email!}",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,// set the background color to green
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Posture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // handle home button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // handle settings button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 2) {
            // handle profile button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyWidget()),
            );
          } else if (index == 3) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Point()),
            );
          }
        },
      ),
    );
  }
}
