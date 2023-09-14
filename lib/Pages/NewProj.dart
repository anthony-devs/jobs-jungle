import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Widget leading;
  final Widget trailing;

  MyBar({
    required this.backgroundColor,
    required this.leading,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          leading: leading,
          actions: <Widget>[
            Center(child: trailing),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ProjFormDesktop extends StatelessWidget {
  final Function()? onSubmit;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController roleController;
  final TextEditingController emailController;
  const ProjFormDesktop({super.key, this.onSubmit, required this.descriptionController, required this.emailController, required this.nameController, required this.priceController, required this.roleController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyBar(
          trailing: Text(
            'Jobs Jungle',
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 24),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
    constraints: BoxConstraints(maxWidth: 500.0), // Set a maximum width for the ListView
    child: ListView(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(child: Text('Project Title')),
                SizedBox(width: 10.0,),
                Expanded(
                  child: TextField(
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
));
    
  }
}
