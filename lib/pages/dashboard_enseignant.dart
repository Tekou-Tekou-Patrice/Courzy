import 'dart:convert';
import 'package:courzy/pages/cahier_de_text.dart';
import 'package:courzy/pages/modification_cours.dart';
import 'package:courzy/pages/personal_timetable.dart';
import 'package:courzy/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardEnseignant extends StatefulWidget {
  final int enseignantId; // Reçu depuis le Login

  const DashboardEnseignant({super.key, required this.enseignantId});

  @override
  State<DashboardEnseignant> createState() => _DashboardEnseignantState();
}

class _DashboardEnseignantState extends State<DashboardEnseignant> {
  List<dynamic> coursDuJour = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoursDuJour();
  }

  Future<void> fetchCoursDuJour() async {
    // Utilise 10.0.2.2 si tu es sur émulateur Android, sinon localhost
    final url = Uri.parse('http://localhost:8084/api/enseignant/${widget.enseignantId}/cours-du-jour');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          coursDuJour = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Erreur réseau: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Bienvenue, Professeur',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Votre emploi du temps du jour',
                    style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : coursDuJour.isEmpty
                            ? const Center(child: Text("Aucun cours prévu pour aujourd'hui"))
                            : ListView.separated(
                                itemCount: coursDuJour.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final cour = coursDuJour[i];
                                  
                                  final nom = cour['nomcours'] ?? 'Sans nom';
                                  final salle = cour['salle'] ?? 'N/A';
                                  final debut = cour['heureDebut']?.toString().substring(0, 5) ?? '--:--';
                                  final fin = cour['heureFin']?.toString().substring(0, 5) ?? '--:--';

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => ModifierCoursPage(cours: cour))
                                      ).then((_) => fetchCoursDuJour()); 
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 3,
                                      child: ListTile(
                                        leading: const Icon(Icons.book, color: Color.fromARGB(255, 207, 51, 235)),
                                        title: Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Text('Salle: $salle • Groupe: ${cour['groupe']}'),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("$debut - $fin", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            const SizedBox(height: 6),
                                            const Icon(Icons.circle, size: 12, color: Colors.greenAccent),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
                      },
                      icon:  Icon(Icons.logout, color: Colors.white),
                      label:  Text(
                        'Deconnexion',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                 ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalTimetable()));
                      },
                      icon:  Icon(Icons.book, color: Colors.white),
                      label:  Text(
                        'voir l\'emploi du temps',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                 ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CahierDeText()));
                      },
                      icon:  Icon(Icons.note_add, color: Colors.white),
                      label:  Text(
                        'remplir le cahier de texte',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }

  }
