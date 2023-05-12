import 'package:flutter/material.dart';

class ContributorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/imports/images/apple.jpg',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/google.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Google'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/icon.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Your app icon'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/kcpd.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('KCPD'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/mb.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('MB'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
