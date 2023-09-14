import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Jobs.dart';
import 'Home.dart';
import 'Notification.dart';
import 'RegisterPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class HomePage extends StatefulWidget {
  HomePage({super.key});

  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> tabs = [Home(), Profile(), Jobs()];

  final user = FirebaseAuth.instance.currentUser;
 
  

  dynamic changePage(int index){
    setState(() {
      currentPage = tabs[index];
    });
    
  }

  Widget? currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      bottomNavigationBar:  
          
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(800)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GNav(
                    onTabChange: (index) {
                      changePage(index);
                    },
                    iconSize: 16, color: Colors.grey, backgroundColor: Colors.black, tabBackgroundColor: Color.fromARGB(73, 92, 92, 92), activeColor: Colors.grey[200], gap: 8, tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.person_3_rounded,
                      text: 'Profile',
                    ),
                    GButton(
                      icon: Icons.work,
                      text: 'Jobs',
                    ),
                  ]),
                ),
              ),
          

          body: currentPage,
    );
  }
}
