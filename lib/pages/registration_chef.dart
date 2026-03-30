import 'dart:convert';

import 'package:courzy/components/my_textfield.dart';
import 'package:courzy/pages/dashboard_chef.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationChef extends StatefulWidget {
  final void Function()? onTap;
  const RegistrationChef({super.key,required this.onTap});

  @override
  State<RegistrationChef> createState() => _RegistrationChefState();
}

class _RegistrationChefState extends State<RegistrationChef> {
  TextEditingController nom =TextEditingController();
  TextEditingController email =TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController controllepass = TextEditingController();

  Future<void> addChef() async {
    final url = Uri.parse('http://localhost:8084/addchef');

   if(password.text == controllepass.text) {
     await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom.text,
        'email': email.text,
        'password': password.text,
      }),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardChef()));
   }

    nom.clear();
    email.clear();
    password.clear();
    controllepass.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inscription réussie')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 207, 51, 235),
        title: const Text(
          'Inscription',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        leading: Text(' '),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                child:  Icon(Icons.lock, color: Colors.white, size: 36),
              ),
              SizedBox(height: 20),
               Text(
                'S\'inscrire',
                style: TextStyle(
                  color: Color.fromARGB(255, 193, 55, 218),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
               Text(
                'Entrez vos informations pour continuer',
                style: TextStyle(color: Colors.black54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
               SizedBox(height: 20),
              Container(
                padding:  EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:  [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    MyTextfield(controller: nom, hintText: 'Nom', obscureText: false),
                     SizedBox(height: 12),
                    MyTextfield(controller: email, hintText: 'Email', obscureText: false),
                     SizedBox(height: 12),
                    MyTextfield(controller: password, hintText: 'Mot de passe', obscureText: true),
                     SizedBox(height: 12),
                     MyTextfield(controller: controllepass, hintText: 'confirmer mot de pass', obscureText: false),
                     SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text('Avez vous deja un compte?'),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Se connecter',style: TextStyle(color: Color.fromARGB(255, 193, 55, 218)),)),
                      ],
                    ),
                     SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:addChef,
                        icon:  Icon(Icons.login, color: Colors.white),
                        label:  Text('Se connecter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                          padding:  EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}