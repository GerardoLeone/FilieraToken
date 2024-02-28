import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';


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



class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Added methods for specific user data access
  int getId() => user?.id ?? 0; // Handle potential null user case
  String getFullName() => user?.fullName ?? ""; // Handle potential null user case
  String getPassword() => user?.password ?? ""; // Handle potential null user case
  String getEmail() => user?.email ?? ""; // Handle potential null user case
  int getBalance() => user?.balance ?? 0; // Handle potential null user case
  Actor getType() => user?.type ?? Actor.unknown; // Handle potential null user case

}