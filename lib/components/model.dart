import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  Users({
    this.id='',
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.email,
  });

  String id;
  String firstname;
  String lastname;
  int age;
  String email;
  
  
  static Users fromJson(Map<String, dynamic> json)=> Users(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    age: json["age"],
    email: json["email"],
  );

  Map<String,dynamic>toJson()=>{
    "id": id,
    "firstname":firstname,
    "lastname":lastname,
    "age":age,
    "email":email,
  };


  factory Users.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data =document.data()!;
    return Users(id:document.id,firstname: data ['firstname'], lastname: data ['lastname'], age: data ['age'], email: data ['email'],);
  }

}