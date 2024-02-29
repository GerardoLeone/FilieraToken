import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  
  SecureStorageService._internal(); // Private constructor for singleton pattern

  static final SecureStorageService _instance = SecureStorageService._internal(); // Singleton instance

  factory SecureStorageService() { // Factory constructor for access
    return _instance;
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();

   // **Save User data securely (assuming password is already hashed):**
  Future<void> save(
    String id,
     String fullName,
     String email,
     String password,
     String balance,
      Actor type) async {
    try {
      await storage.write(key: 'user_id', value: id);
      await storage.write(key: 'full_name', value: fullName);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'balance', value: balance);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'type', value: Enums.getActorText(type)); // Assuming Actor has a toString() method
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error saving user data: $e');
    }
  }

  // **Get User data:**
  Future<User?> get() async {
    try {

      final userId = await storage.read(key: 'user_id');
      final fullName = await storage.read(key: 'full_name');
      final email = await storage.read(key: 'email');
      final balance = await storage.read(key: 'balance');
      final password = await storage.read(key: 'password');
      final typeString = await storage.read(key: 'type');
      final type = Actor.values.firstWhere((t) => t.toString() == typeString); // Assuming Actor has a fromString() method

      if (userId != null && fullName != null && email != null && balance != null && type != null && password!=null) {
        return User(
          id: userId,
          fullName: fullName,
          email: email,
          balance: balance,
          type: type, 
          password: password,
        );
      }
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error getting user data: $e');
    }
    return null;
  }

  // **Delete User data:**
  Future<void> delete() async {
    try {
      await storage.delete(key: 'user_id');
      await storage.delete(key: 'full_name');
      await storage.delete(key: 'email');
      await storage.delete(key: 'password');
      await storage.delete(key: 'balance');
      await storage.delete(key: 'type');
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error deleting user data: $e');
    }
  }
}