import 'package:flutter/material.dart';

class ContributorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contributors'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/imports/images/Sumesh.jpeg',
                fit: BoxFit.cover,
              ),
              Text('Sumesh Ak'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/Dheeraj.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Dheeraj'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/gnani.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Nikhil'),
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
                          'lib/imports/images/Balaram.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Balaram'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/imports/images/Mukul.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Text('Mukul'),
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
