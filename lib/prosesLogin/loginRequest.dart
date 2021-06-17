import 'dart:async';
import '../Models/User.dart';
import '../DbHelper/DbHelper.dart';

class LoginRequest {
  DbHelper dbHelper = new DbHelper();
 Future<User> getLogin(String username, String password) {
    var result = dbHelper.getLogin(username,password);
    return result;
  }
}