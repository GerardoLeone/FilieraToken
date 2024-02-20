import 'package:filiera_token_front_end/utils/enums.dart';


class User {
  final int id;
  final String fullName;
  final String password; // Si presume che sia già crittografata dal front-end
  final String email;
  final int balance;
  final Actor type;

  const User({
    required this.id,
    required this.fullName,
    required this.password,
    required this.email,
    required this.balance,
    required this.type
  });

  // Getters Function 
  
  int get getId => id;

  String get getFullName => fullName;
  
  String get getPassword => password; 
  
  String get getEmail => email;
  
  int get getBalance => balance;

  Actor get getType => type;

}