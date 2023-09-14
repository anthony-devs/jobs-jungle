import 'package:firebase_auth/firebase_auth.dart';
class Projects {
  String Name;
  DateTime dateCreated = DateTime.now();
  DateTime dateEnding;
  User? user = FirebaseAuth.instance.currentUser;
  String Description;
  List<Comment>? bids = [];
  TechRole? role;

  Projects({
    required this.Name,
    required this.Description,
    this.role,
    required this.dateEnding,
    this.bids,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
      'dateCreated': dateCreated.toIso8601String(),
      'dateEnding': dateEnding.toIso8601String(),
      'user': user != null ? user!.uid : null,
      'Description': Description,
      'bids': bids?.map((bid) => bid.toString()).toList(),
      'role' : role.toString().split('.').join('').replaceAll('TechRole', '').replaceAll('_', ' '),
    };
  }
}

class Comment{
  String title;
  String body;
  DateTime dateCreated = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  List<User>? likes;
  Comment({required this.body, required this.user, required this.title});
}
enum TechRole {
  Software_Engineer,
  Data_Scientist,
  Product_Manager,
  UX_Designer,
  UI_Designer,
  Systems_Administrator,
  Network_Engineer,
  Cybersecurity_Analyst,
  Database_Administrator,
  IT_Support_Specialist,
  DevOps_Engineer,
  Cloud_Architect,
  QA_Engineer,
  Mobile_Developer,
  Web_Developer,
  AI_Engineer,
  Blockchain_Developer,
  IT_Consultant,
  Tech_Writer,
  Project_Manager,
  IT_Trainer,
  IT_Architect,
}
class CustomUser{
  final String uid;
  String? bio;
  TechRole? role;
  bool isHiring = false;
  User? user;
  String? displayName;
  String? email;

  CustomUser({required this.uid, this.bio, this.isHiring = false, this.role, required this.user, this.displayName, this.email});
}