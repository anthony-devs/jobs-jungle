import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginPage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: ListView(
          children: [
            Text('DISCLAIMER:', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 50),),

            Text('''
This app is an open source platform for freelancers and clients to connect and collaborate on projects. While we strive to maintain a safe and secure environment for all users, we cannot guarantee the quality, safety, or legality of the projects or users on this platform.

By using this app, you acknowledge and agree that you assume all responsibility and risk associated with your use of this platform. You also agree to exercise caution and common sense when communicating, negotiating, and transacting with other users on this platform.

We strongly advise that you take the following measures to protect yourself and avoid scams:

Verify the identity and reputation of clients and freelancers before starting a project. Look for reviews, ratings, and feedback from previous clients or freelancers.

Use secure payment methods and avoid sending money or sensitive information through unsecured channels.

Use a clear and detailed project description, contract, and scope of work to avoid misunderstandings and disputes.

Report any suspicious activity or fraudulent behavior to our support team immediately.

Remember, your safety and security are our top priority, and we will do our best to investigate and resolve any issues that arise on this platform. However, we cannot guarantee the outcome of any dispute or transaction, and we strongly advise that you use your own judgment and due diligence when using this platform.
''')
          ],
        ),
      ),
    );
  }
}
