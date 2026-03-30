import 'dart:convert';
import 'package:courzy/pages/add_cours.dart';
import 'package:courzy/pages/cahier_enseignant.dart';
import 'package:courzy/pages/register_enseignant.dart';
import 'package:courzy/pages/see_teachers.dart';
import 'package:courzy/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardChef extends StatefulWidget {
  const DashboardChef({super.key});

  @override
  State<DashboardChef> createState() => _DashboardChefState();
}

class _DashboardChefState extends State<DashboardChef> {
  List<dynamic> coursActuels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoursActuels();
  }

  Future<void> fetchCoursActuels() async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://localhost:8084/api/enseignant/actuels');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          coursActuels = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Erreur réseau: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        centerTitle: true,
        title: const Text(
          'Bienvenue, Chef de département',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchCoursActuels,
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Professeurs en cours actuellement',
                    style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : coursActuels.isEmpty
                            ? const Center(child: Text("Aucun cours en ce moment"))
                            : ListView.separated(
                                itemCount: coursActuels.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final cours = coursActuels[i];

                                  return Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 3,
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Color.fromARGB(255, 207, 51, 235),
                                        child: Icon(Icons.class_, color: Colors.white),
                                      ),
                                      title: Text(
                                        cours['nomcours'] ?? 'Cours sans nom',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         
                                          Text(" ${cours['heureDebut']} - ${cours['heureFin']}"),
                                        ],
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.purple[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          cours['salle'] ?? 'N/A',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
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
            width: 280,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.person,size: 100,color: Colors.purpleAccent,),
                  const SizedBox(height: 20),
                  const Text('Gestion Rapide', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const Divider(color: Colors.purpleAccent),
                  const SizedBox(height: 20),
                  
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterEnseignant(onTap: () {  },)));
                      },
                      icon:  Icon(Icons.person_add_alt_1, color: Colors.white),
                      label:  Text(
                        'Ajouter un enseignant',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  const SizedBox(height: 10),
                  
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCoursPage()));
                      },
                      icon:  Icon(Icons.add_circle, color: Colors.white),
                      label:  Text(
                        'Ajouter un cours',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                   SizedBox(height: 10),
                  
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeTeacher()));
                      },
                      icon:  Icon(Icons.remove_red_eye, color: Colors.white),
                      label:  Text(
                        'voir les enseignants',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 10,),
                     ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CahierEnseignant()));
                      },
                      icon:  Icon(Icons.book, color: Colors.white),
                      label:  Text(
                        'voir les cahiers de texte',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 193, 55, 218),
                        fixedSize:  Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                  SizedBox(height: 50),

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

                 
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

 
  }
