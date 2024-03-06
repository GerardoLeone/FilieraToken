import 'package:bcrypt/bcrypt.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/user_service.dart';
import 'package:filiera_token_front_end/models/User.dart';


class SigninService {


  /// Injection of Service 
  final userService = UserSerivce();



    Future<bool> checkLogin(
    String emailInput,
    String passwordInput,
    String walletInput,
    String selectedValueUserType, 
    )async {
      return await userService.login(emailInput, passwordInput, walletInput, selectedValueUserType);
    }




  Future<User?> onLoginSuccess(String selectedValueUserType, String walletInput, SecureStorageService secureStorageService) async{
    /// Go to Home User page 
    /// Create a JWT (Optional)  
    /// Move to home-page-user and select our product 
    /// Retrieve all data of User 
    /// Retrieve all data of other Product 
    User? userProvider =  await userService.getData(selectedValueUserType,walletInput);
    // Inserisco nel Database 
    await _saveUserReference(userProvider!,walletInput, secureStorageService);

    return userProvider;
  }

  Future<void> _saveUserReference(User user, String wallet, SecureStorageService secureStorageService) async {    
      await secureStorageService.save(
        user.id,
        user.fullName,
        user.email,
        user.password,
        user.balance,
        wallet,
        user.type
      );
  }
}