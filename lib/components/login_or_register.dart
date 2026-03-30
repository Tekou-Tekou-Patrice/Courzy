import 'package:courzy/pages/login_chef.dart';
import 'package:courzy/pages/registration_chef.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginChef(
        onTap: togglePages,
      );
    }else{
      return RegistrationChef(
        onTap: togglePages,
      );
    }
  }
}
