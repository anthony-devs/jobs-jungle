// ignore_for_file: prefer__literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:job_jungle_flutter/Models(Anthony)/ProjectModel.dart';
import 'login_or_register.dart';
import '../Components(Anthony Devs)/my_textfield.dart';
import '../Components(Anthony Devs)/square_tile.dart';
import '../Components(Anthony Devs)/my_button.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models(Anthony)/ProjectModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CustomUser? thisUser;
CustomUser? _userFromFireUser(User user, String bio, TechRole techRole) {
  return user != null
      ? thisUser = CustomUser(
          uid: user.uid,
          bio: bio,
          role: techRole,
          user: user,
          displayName: user.displayName,
          email: user.email)
      : null;
}

// Create a new Firestore document for the user
Future<void> createUserDocument({
  String? userId,
  String? techRole,
  String? bio,
  bool? isHiring,
}) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    await userDoc.set({
      'techrole': techRole,
      'bio': bio,
      'isHiring': isHiring,
    });
    print('User document created successfully!');
  } catch (error) {
    print('Failed to create user document: $error');
  }
}

Future<void> updateUserAdditionalData({
  String? thisTechRole,
  String? userBio,
  bool? isHiring,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);

  try {
    await userDoc.update({
      'techrole': thisTechRole,
      'bio': userBio,
      'isHiring': isHiring,
    });
    print('User data updated successfully!');
  } catch (error) {
    print('Failed to update user data: $error');
  }
}

Future<Map<String, dynamic>?> getUserDetails() async {
  final user = FirebaseAuth.instance.currentUser;
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);

  try {
    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      return userData;
    } else {
      print('User document does not exist.');
      return null;
    }
  } catch (error) {
    print('Failed to retrieve user details: $error');
    return null;
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget regNow() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => LoginPage(onTap: () {
                      Navigator.pop(context);
                    })));
      },
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool? selectedOption;

  void _handleOptionChange(bool? value) {
    setState(() {
      selectedOption = value;
    });
  }

  // text editing controllers

  TechRole _selectedTechRole = TechRole.Software_Engineer;

  final emailController = TextEditingController();
  final nameController = TextEditingController();

  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isValid = false;

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

  TextEditingController bioController = TextEditingController();
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
  dynamic signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
          );
        });
    if (nameController.text.isEmpty) {
      isValid = false;
    } else if (passwordController.text.isEmpty) {
      isValid = false;
    } else if (emailController.text.contains('@') == false) {
      isValid = false;
    } else {
      isValid = true;
    }

    if (isValid) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User? user = result.user;
        print(user!.uid);
        thisUser =
            _userFromFireUser(user, bioController.text, _selectedTechRole);

        createUserDocument(
            techRole: _selectedTechRole
                .toString()
                .split('.')
                .join('')
                .replaceAll('Techrole', '')
                .replaceAll('_', ' '),
            bio: bioController.text,
            userId: user.uid,
            isHiring: thisUser!.isHiring);

        setState(() async {
          await user.updateDisplayName(nameController.text);
        });

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print(e.message);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Put In the Appropriate Information'),
            );
          });
      print(thisUser);
    }
  }

  @override
  Widget Profile(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
              semanticLabel: 'Logout',
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Hi, ${user!.displayName}',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 42)),
            Text(user.email.toString(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w100, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: ListView(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Create an Account!',
                    style: TextStyle(
                        color: Color.fromARGB(150, 255, 230, 105),
                        fontSize: 12,
                        fontWeight: FontWeight.w100),
                  ),

                  const SizedBox(height: 25),

                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  // Bio Field
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: bioController,
                      maxLength: 200,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  SizedBox(height: 30),

                  // role
                  DropdownButtonFormField<TechRole>(
                    dropdownColor: Color.fromARGB(255, 192, 212, 205),
                    value: _selectedTechRole,
                    items: TechRole.values.map((role) {
                      return DropdownMenuItem<TechRole>(
                        value: role,
                        child: Container(
                          width: 310.0,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              role
                                  .toString()
                                  .split('.')
                                  .join(' ')
                                  .replaceAll('_', ' ')
                                  .replaceAll('TechRole', ''),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTechRole = value!;
                      });
                    },
                  ),

                  SizedBox(height: 16.0),
                  // Type
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "I'm A Recruiter",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Radio(
                            value: true,
                            groupValue: selectedOption,
                            onChanged: _handleOptionChange,
                          ),
                        ),
                        ListTile(
                          title: Text("I'm A Freelancer",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: false,
                            groupValue: selectedOption,
                            onChanged: _handleOptionChange,
                            
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Selected Option: ${selectedOption.toString()}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: signUserUp,
                  ),

                  SizedBox(height: 10),

                  // or continue with
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(150, 255, 230, 105),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(150, 255, 230, 105),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 223, 208, 133)),
                      ),
                      SizedBox(width: 4),
                      this.regNow()
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  String? techRole;

  String? bio;

  bool? isHiring;

  dynamic data;

  @override
  Widget build(BuildContext context) {
    
    
    getUserDetails().then((userData) {
      if (userData != null) {
        // Use the user details
        setState(() {
          techRole = userData['techrole'];
          bio = userData['bio'];
          isHiring = userData['isHiring'];
          data = userData;
        });


        
        

        // Perform further operations with the retrieved data
        // ...
      } else {
        // Handle the case when the user document does not exist
        print('No Such Document');
        return CircularProgressIndicator();
      }
    });

    if (data != null) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
              semanticLabel: 'Logout',
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text('Hi, ${user!.displayName}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 42)),
              Text(user!.email.toString(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w100, color: Colors.black)),
              Text(bio.toString()),
              Container(
                child: isHiring! ? Text('') : Text(
                  techRole
                      .toString()
                      .split('.')
                      .join('')
                      .replaceAll('TechRole', '')
                      .replaceAll('_', ' ')
                      .toString(),
                  style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Color.fromARGB(100, 0, 0, 0),
                      fontWeight: FontWeight.w400),
                )
              ),
                Container(
                  child: Text(isHiring! ? 'Recruiter' : 'Searching for A Job',
                      style: GoogleFonts.poppins(
                          color: isHiring! ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold, backgroundColor: isHiring! ? Colors.deepPurple : Colors.blueGrey,)),
                  
                  width: 56,
                  height: 24,
                
              )
            ],
          ),
        ),
      ),
    );
    } else{
      return Center(child: CircularProgressIndicator());
    }
    

    

    
  }
}
