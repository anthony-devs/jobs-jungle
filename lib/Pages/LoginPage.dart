// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_jungle_flutter/Models(Anthony)/ProjectModel.dart';
import 'login_or_register.dart';
import '../Components(Anthony Devs)/my_textfield.dart';
import '../Components(Anthony Devs)/square_tile.dart';
import '../Components(Anthony Devs)/my_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});
  void Function() onTap;

  @override
  State<LoginPage> createState() => _LoginPageState(onTap: onTap );

}

class _LoginPageState extends State<LoginPage> {
  void Function() onTap;
  _LoginPageState({required this.onTap});

  Widget regNow() {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        'Register now',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  bool isValid = false;

  // text editing controllers

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //Wrong Email
  void WrongEmailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text('Email Not Signed In'),
            ),
          );
        });
  }

  void WrongPasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text('Password Is Not Correct'),
            ),
          );
        });
  }

  // sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
          );
        });
        if (passwordController.text.isEmpty) {
      isValid = false;
    } else if (emailController.text.isEmpty) {
      isValid = false;
    } else {
      isValid = true;
    }

    if (isValid) {
      try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        WrongEmailDialog();
      } else if (e.code == 'wrong-password') {
        WrongPasswordDialog();
      }
    }
    }else{
      Navigator.pop(context);
      showDialog(context: context, builder: (context) {
        return AlertDialog(content: Text('Fill Out All Fields'),);
      });
      
    }
    
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: ListView(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  ClipRRect(
                      borderRadius: BorderRadius.circular(7000),
                      child: Image.asset(
                        'images/logo.png',
                        scale: 3.0,
                      )),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                        color: Color.fromARGB(150, 255, 230, 105),
                        fontSize: 12,
                        fontWeight: FontWeight.w100),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),


                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                 

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(
                            color: Colors.white),
                      ),
                      SizedBox(width: 4),

                      regNow(),

                      
                      
                      
                    ],

                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
