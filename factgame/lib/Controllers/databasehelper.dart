import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class DatabaseHelper{

  String serverUrl = "https://lmsturkey.com/api/users";
  var errorMessage ;
  var Message;

  var token ;

  loginData(String username , String password) async{

    String myUrl = "$serverUrl/login/?format=json";
    final response = await  http.post(myUrl,
        body: {
          "username": "$username",
          "password" : "$password",
        } ) ;
    errorMessage = response.body.contains('No active account');

    var data = json.decode(response.body);
    if(errorMessage){
      print('No active account ${data}');
    }else{
      print('data : ${data["access"]}');
      _save(data["access"]);
    }

  }

  registerData(String username ,String email , String password, String first_name, String last_name) async{

    String myUrl = "$serverUrl/register";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "username": "$username",
          "password" : "$password",
          "email": "$email",
          'first_name': "$first_name",
          'last_name' : "$last_name",
        } ) ;
    //errorMessage = response.body.contains('error');

    var data = json.decode(response.body);
    Message = data["message"].contains('User Created Successfully');
    // errorMessage = data['message'].contains("This field may not be blank.") || data['message'].contains("Enter a valid email address.");

    //print(data)
    if(Message){
      print('data : ${data["message"]}');
    }else{
      print('data : ${data["error"]}');
    }
  }


  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = token;
    prefs.setString(key, value);
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('read : $value');
  }






}
