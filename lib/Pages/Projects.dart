import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_jungle_flutter/Components(Anthony Devs)/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_jungle_flutter/Components(Anthony%20Devs)/my_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'search.dart';
import 'package:flutter/services.dart';
import 'Profile.dart';
import '../Models(Anthony)/ProjectModel.dart';


import 'myNewTextField.dart';

class dJobs extends StatefulWidget {
  dJobs({super.key});

  @override
  State<dJobs> createState() => _dJobsState();
}

class _dJobsState extends State<dJobs> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _applicationLinkController =
      TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('projects');

  DateTime? _selectedDate;

  

      Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    bool isValid = false;
    TechRole _selectedTechRole = TechRole.Software_Engineer;
    String role = _selectedTechRole.toString().split('.').join('').replaceAll('TechRole', '').replaceAll('_', ' ');
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            color: Color.fromARGB(255, 29, 29, 29),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: ListView(
                children: [
                  MyNewTextField(
                      controller: _nameController,
                      hintText: 'Name',
                      obscureText: false),
                  Container(
                    width: 490,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
                      child: TextField(
                        
                        controller: _descriptionController,
                        
                        maxLines:
                            null, // Set maxLines to null to create a multiline input field
                        decoration: InputDecoration(
                          border: null,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        
                        ),
                      ),
                    ),
                  ),
                  
                  MyNewTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false),

                      //Roles

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

                      //Location

                      //Career level
                      Container(
                        width: 490,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                        child: Column(
                          
                            children: [
                              
                              Text('Stop Receiving Applications on: '),
                              ListTile(
                            leading: Icon(Icons.calendar_today),
                            onTap: () {
                              _selectDate(context);
                            },
                            title: Text('Date'),
                            trailing: Text(
                                  _selectedDate == null
                                      ? 'Select date'
                                      : '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                  Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500000)
          ),

      width: 490.0,
      
      child:
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: TextField(
            
            style: GoogleFonts.poppins(color: Colors.black),
            keyboardType: TextInputType.number,
  inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
  ],
            controller: _priceController,
            obscureText: false,
            decoration: InputDecoration(
              
              border: null,
                fillColor: Color.fromARGB(255, 255, 255, 255),
                hoverColor: Color.fromARGB(90, 60, 60, 60),
                filled: true,
                hintText: 'Salary',
                hintStyle: TextStyle(color: Colors.grey[500]),),
          ),
        ),
      ),
    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3000)),
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 60, 60, 60),
                      ),
                      child: Text('Create'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String description = _descriptionController.text;

                        void CreatePost() async {
                          if (description != null) {
                          await _products.add({
                            "name": name,
                            "description": description,
                            "email": _emailController.text,
                            "price": _priceController.text,
                            "role": role,
                            'dateEnding' : _selectedDate.toString()
                          });
                          _applicationLinkController.text = '';
                          _priceController.text = '';
                          _roleController.text = '';
                          _emailController.text = '';
                          _nameController.text = '';
                          _descriptionController.text = '';
                          _selectedDate = null;
                          Navigator.of(context).pop();
                        }
                        }

                         if (_descriptionController.text.isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else if (_emailController.text.isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else if (_nameController.text.isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else if (_priceController.text.isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else if (_roleController.text.isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else if (_selectedDate.toString().isEmpty) {
                          setState(() {
                            isValid = false;
                          });
                        } else{
                          setState(() {
                            isValid = true;
                          });
                        }

                        if (!isValid) {
                          showDialog(context: context, builder: (context) {
                            return Dialog(child: Center(child: Text('Fields Can Not Be Blank'),),);
                          });
                        } else{
                          CreatePost();
                        }
                        
                        
                        
                        
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
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

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? description =
                        double.tryParse(_descriptionController.text);
                    if (description != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"name": name, "description": description});
                      _nameController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    
  }

  @override
  Widget build(BuildContext context) {
    String? techRole;

  String? bio;

  bool? isHiring;

  dynamic data;

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
    

    TextEditingController searchQuery = TextEditingController();

    
    
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 29, 29, 29),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            
            if (streamSnapshot.hasData) {
              
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                      if(DateTime.now().isAfter(DateTime.parse(documentSnapshot['dateEnding']))){
                        _delete(documentSnapshot.id);
                      }

                      
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      width: MediaQuery.of(context).size.width / 4,
                      height: 128,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 29, 29, 29),
                                ),
                                body: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: ListView(
                                      children: [
                                        Text(documentSnapshot['name'],
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 42)),
                                        Text(
                                          documentSnapshot['email'],
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w100,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 12),
                                        ),
                                        Text(documentSnapshot['description']),
                                        SizedBox(
                                          height: 87,
                                        ),
                                        GestureDetector(
                                          child: Container(width: 68, height: 74, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(50)), child: Center(child: Text('Apply Here')),),
                                          onTap: () {
                                            launch('mailto:${documentSnapshot['email']}');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        title: Text(documentSnapshot['name']),
                        subtitle: Text(documentSnapshot['role'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Text("\$ ${documentSnapshot['price']}"),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product
        floatingActionButton:Container(
          width: 340,
          height: 54,
          child: ElevatedButton(
            onPressed: () => _create(),
            child: Row(children: [
              Text('Post A Project'), Icon(Icons.add)
            ] ,) 
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}


