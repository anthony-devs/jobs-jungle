// ignore_for_file: prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    bool _visible = false;

    void toggleVisible(){
      setState(() {
        _visible = !_visible;
      });
    }
    
    return Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500)
          ),

      width: 490.0,
      
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5000))
          ),
          child: TextField(
            
            style: GoogleFonts.poppins(color: Colors.white),
            
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 159, 194, 204))
              ),
                
                
                fillColor: Color.fromARGB(255, 60, 60, 60),
                hoverColor: Color.fromARGB(90, 60, 60, 60),
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[500]),),
          ),
        ),
      ),
    );
  }
}