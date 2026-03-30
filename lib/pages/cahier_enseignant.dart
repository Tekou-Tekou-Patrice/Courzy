import 'dart:convert';
import 'package:courzy/models/cahier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CahierEnseignant extends StatefulWidget {
  const CahierEnseignant({super.key});

  @override
  State<CahierEnseignant> createState() => _CahierEnseignantState();
}

class _CahierEnseignantState extends State<CahierEnseignant> {
  static const String baseUrl = 'http://localhost:8084/api';

  // Récupération des données du backend
  Future<List<Cahier>> getAllCahiers() async {
    final response = await http.get(Uri.parse('$baseUrl/cahiers'));
     // Note le "s" à cahiers si c'est ce que tu as mis en Java

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Cahier.fromJson(json)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Cahiers de Texte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Cahier>>(
        future: getAllCahiers(),
        builder: (context, snapshot) {
          // 1. Pendant le chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. En cas d'erreur
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          // 3. Si on a des données
          else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cahier = snapshot.data![index];
                return _buildCahierCard(cahier);
              },
            );
          }
          return const Center(child: Text('Aucune donnée disponible'));
        },
      ),
    );
  }

  // Widget de la carte (Design simplifié)
  Widget _buildCahierCard(Cahier cahier) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 245, 230, 250),
            child: Icon(Icons.menu_book, color: Color.fromARGB(255, 193, 55, 218)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cahier.course,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("Prof: ${cahier.nom}"),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Niveau: ${cahier.niveau}"),
                    Text("Groupe: ${cahier.groupe}"),
                  ],
                ),
                Text("Chapitre: ${cahier.chapitre}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}