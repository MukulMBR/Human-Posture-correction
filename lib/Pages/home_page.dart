import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smartposture/profile/settings.dart';
import 'package:smartposture/Pages/smart/sensors.dart';
import 'package:smartposture/profile/about.dart';
import 'package:flutter/material.dart';
import '../profile/profile.dart';
import 'shop.dart';
import '../services/wifi.dart';
import 'smart/chair/smartchair.dart';
import 'smart/posture/smartposture.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference _databaseReference;
  late final String documentId;
  String sensorValue = '';

  

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
    // Get the sensor value from the first document in the query snapshot
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
    sensorValue = (userData?['sensor'] as String?)!;
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
      } else {
        // handle error: no document found for the user
      }
    }).catchError((error) {
      // handle error: failed to fetch the document ID
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$sensorValue",
          style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.bold,),
        ),
        actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],    
        ),
      body: Center(
        child: Text('Home Page'),
        
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/imports/images/kcpd.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Hello: ${user!.email!} with ${sensorValue}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: const Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              leading: Icon(Icons.person), // icon here
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Analysis'),
              leading: Icon(Icons.analytics), // icon here
              onTap: () {
                if(sensorValue=='Smart Chair'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Analysis()),
                );
              }else if(sensorValue == 'Smart Posture'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SmartPosture()),
                );
              }
              else if(sensorValue=='Smart C P'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Posture()),
                );
              }
              },
            ),
            ListTile(
              title: const Text('About'),
              leading: Icon(Icons.info), // icon here
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutActivityState()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                signUserOut();
              },
            ),
          ],
        ),
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
            icon: Icon(Icons.shopping_basket),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset('lib/imports/images/wifi.gif'),
            ),
            label: '$sensorValue',
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
            if(sensorValue=='Smart Chair'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Analysis()),
                );
              }else if(sensorValue == 'Smart Posture'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SmartPosture()),
                );
              }
              else if(sensorValue=='Smart C P'){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Posture()),
                );
              }
              else if(sensorValue==null){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Buy our product!"),
                      content: Text("Sorry to see this you haven't bought our product"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Okay"),
                          onPressed: () {
                            // TODO: Implement buy product logic here
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
          } else if (index == 3) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShoppingPage()),
            );
          } else if (index == 4) {
            // handle about button tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => wifi()),
            );
          }
        },
      ),
    );
  }
}
