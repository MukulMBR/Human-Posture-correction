import 'package:flutter/material.dart';
import 'package:smartposture/profile/details.dart';
import '../components/about.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'contributors.dart';

  class PackageInfoWidget extends StatefulWidget {
    @override
    _PackageInfoWidgetState createState() => _PackageInfoWidgetState();
  }

  class _PackageInfoWidgetState extends State<PackageInfoWidget> {
    PackageInfo? _packageInfo;

    @override
    void initState() {
      super.initState();
      _initPackageInfo();
    }

    Future<void> _initPackageInfo() async {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
      });
    }

    @override
 Widget build(BuildContext context) {
  return Center(
    child: _packageInfo == null
        ? const CircularProgressIndicator()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center, // center horizontally
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'lib/imports/images/icon.jpeg', // Replace with your app icon asset path
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Pasture',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Version: ${_packageInfo!.version}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
    );
  }
}

  class DottedLineDivider extends StatelessWidget {
    final double height;
    final Color color;
    final double dotRadius;
    final double dotSpacing;

    DottedLineDivider({
      this.height = 1.0,
      this.color = Colors.black,
      this.dotRadius = 2.0,
      this.dotSpacing = 4.0,
    });

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        height: height,
        child: CustomPaint(
          painter: _DottedLinePainter(
            color: color,
            dotRadius: dotRadius,
            dotSpacing: dotSpacing,
          ),
        ),
      );
    }
  }

  class _DottedLinePainter extends CustomPainter {
    final Color color;
    final double dotRadius;
    final double dotSpacing;

    _DottedLinePainter({
      this.color = Colors.black,
      this.dotRadius = 2.0,
      this.dotSpacing = 4.0,
    });

    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = size.height
        ..strokeCap = StrokeCap.round;

      final double dashWidth = dotRadius * 2 + dotSpacing;
      int dotsCount = (size.width / dashWidth).floor();
      double startX = (size.width - dashWidth * dotsCount + dotSpacing) / 2;

      for (int i = 0; i < dotsCount; i++) {
        double x = startX + i * dashWidth;
        canvas.drawCircle(Offset(x, size.height / 2), dotRadius, paint);
      }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }


  class AboutActivityState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AboutPage ab = AboutPage();
    ab.customStyle(descFontFamily: "Roboto",listTextFontFamily: "RobotoMedium");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("About Page"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/imports/images/kcpd.jpg',
                      fit: BoxFit.cover,
                      width: 160.0,
                      height: 160.0,
                    ),
                  ),
                ),
                ab.addDescription("Our team is made up of experienced software developers, designers, and health professionals who are passionate about creating innovative solutions that make a real difference. We\'ve worked hard to create an app that is easy to use, effective, and enjoyable."),
              ],
            ),
          ),
          DottedLineDivider(height: 1.0, color: Colors.grey),
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: ab.addEmail("mukulmbr@gmail.com")),
                    Expanded(flex: 1, child: ab.addPhone("+91 8919866652")),
                    Expanded(flex: 1, child: ab.addText("+91 8919866652"))
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: ab.addFacebook("balaram.karanam.5")),
                    Expanded(flex: 1, child: ab.addInstagram("dheerajmanjunadha")),
                    Expanded(flex: 1, child: ab.addTwitter("Twitter")),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: ab.addYoutube("YouTube")),
                    Expanded(flex: 1, child: ab.addGithub("MukulMBR")),
                    Expanded(flex: 1, child: ab.addWebsite("https://posture2.wordpress.com/")),
                  ],
                ),
              ],
            ),
          ),
          DottedLineDivider(height: 1.0, color: Colors.grey),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PackageInfoWidget(),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContributorPage()),
                        );
                      },
                      child: Row(
                        children:[
                          Icon(Icons.people),
                          const SizedBox(width: 5),
                          Text('Contributors'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                      child: Row(
                        children:[
                          Icon(Icons.warning),
                          const SizedBox(width: 5),
                          Text('Disclaimer'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}