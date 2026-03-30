import 'dart:convert';
import 'package:courzy/models/cours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalTimetable extends StatefulWidget {
  const PersonalTimetable({super.key});

  @override
  State<PersonalTimetable> createState() => _PersonalTimetableState();
}

class _PersonalTimetableState extends State<PersonalTimetable> {
  static const String baseUrl = 'http://localhost:8084/api/enseignant';

  Future<List<Cours>> getTimetable() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getCours'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Cours.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de contacter le serveur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps General'),
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<List<Cours>>(
            future: getTimetable(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun cours trouvé'));
              }

              // Si on a des données, on construit les lignes du tableau
              List<Cours> listeCours = snapshot.data!;

              return DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.purple[50]),
                columns: const [
                  DataColumn(label: Text('Heure', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Jour', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Cours', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Niveau', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Groupe', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Salle', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: listeCours.map((cours) {
                  return DataRow(cells: [
                    DataCell(Text('${cours.heureDebut} - ${cours.heureFin}')),
                    DataCell(Text(cours.jourDeLaSemaine ?? '')),
                    DataCell(Text(cours.nomcours ?? '')),
                    DataCell(Text(cours.niveau ?? '')),
                    DataCell(Text(cours.groupe ?? '')),
                    DataCell(Text(cours.salle ?? '')),
                  ]);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}