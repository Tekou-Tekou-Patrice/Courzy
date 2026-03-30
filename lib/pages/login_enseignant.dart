import 'dart:convert';
import 'package:courzy/components/my_textfield.dart';
import 'package:courzy/pages/dashboard_enseignant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginEnseignant extends StatefulWidget {
  const LoginEnseignant({super.key});

  @override
  State<LoginEnseignant> createState() => _LoginEnseignantState();
}

class _LoginEnseignantState extends State<LoginEnseignant> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8084/loginenseignant'), // Ton endpoint Spring Boot
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text,
          'password': password.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        
        int idTrouve = userData['id'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardEnseignant(enseignantId: idTrouve),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e'), backgroundColor: Colors.orange),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        title: const Text(
          'Connexion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color.fromARGB(255, 193, 55, 218),
                child: Icon(Icons.lock, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                'Se connecter',
                style: TextStyle(
                  color: Color.fromARGB(255, 193, 55, 218),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez vos informations pour continuer',
                style: TextStyle(color: Colors.black54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    MyTextfield(controller: email, hintText: 'Votre mail', obscureText: false),
                    const SizedBox(height: 12),
                    MyTextfield(controller: password, hintText: 'Mot de passe', obscureText: true),
                    const SizedBox(height: 12),
                    const Text(
                      'Si vous n\'avez pas de compte, veuillez rencontrer le chef de département',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : login,
                        icon: isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.login, color: Colors.white),
                        label: Text(
                          isLoading ? 'Connexion...' : 'Se connecter',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 193, 55, 218),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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