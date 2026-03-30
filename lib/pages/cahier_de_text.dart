import 'dart:convert';

import 'package:courzy/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CahierDeText extends StatefulWidget {
  const CahierDeText({super.key});

  @override
  State<CahierDeText> createState() => _CahierDeTextState();
}

class _CahierDeTextState extends State<CahierDeText> {
  final TextEditingController nom = TextEditingController();
  final TextEditingController cours = TextEditingController();
  final TextEditingController chapitre = TextEditingController();
  final TextEditingController niveau = TextEditingController();
  final TextEditingController groupe = TextEditingController();

Future<void> addCahier() async {
  final url = Uri.parse('http://localhost:8084/api/addcahier');

  if (nom.text.isEmpty || cours.text.isEmpty || chapitre.text.isEmpty || 
      niveau.text.isEmpty || groupe.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs'), backgroundColor: Colors.red),
    );
    return;
  }

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nomEnseignant': nom.text,
        'nomCours': cours.text,
        'chapitre': chapitre.text,
        'niveau': niveau.text,
        'groupe': groupe.text
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bien envoyé, merci monsieur'), backgroundColor: Colors.green),
      );
      nom.clear(); cours.clear(); chapitre.clear(); niveau.clear(); groupe.clear();
    } else {
      print("Erreur 500: ${response.body}"); // Regarde ici si l'erreur persiste
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur serveur: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur de connexion : $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text("Ecrire votre cahier de texte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextfield(controller: nom, hintText: 'votre nom', obscureText: false),
          SizedBox(height: 10,),
          MyTextfield(controller: cours, hintText: 'cours', obscureText: false),
          SizedBox(height: 10,),
          MyTextfield(controller: chapitre, hintText: 'chapitre', obscureText: false),
          SizedBox(height: 10,),
          MyTextfield(controller: niveau, hintText: 'niveau', obscureText: false),
          SizedBox(height: 10,),
          MyTextfield(controller: groupe, hintText: 'groupe', obscureText: false),
          SizedBox(height: 10,),

           SizedBox(
            width: 200,
            height: 50,
             child: ElevatedButton.icon(
                          onPressed: addCahier,
                          icon:  Icon(Icons.send, color: Colors.white),
                          label:  Text('Envoyer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    );
  }
}