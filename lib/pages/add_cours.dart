import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:courzy/components/my_textfield.dart'; 
import 'package:http/http.dart' as http;

class AddCoursPage extends StatefulWidget {
  const AddCoursPage({super.key});

  @override
  State<AddCoursPage> createState() => _AddCoursPageState();
}

class _AddCoursPageState extends State<AddCoursPage> {
  // Contrôleurs
  final nomCoursController = TextEditingController();
  final salleController = TextEditingController();
  final niveauController = TextEditingController();
  final groupeController = TextEditingController();
  final heureDebutController = TextEditingController();
  final heureFinController = TextEditingController();

  // États
  String? selectedDay;
  dynamic selectedEnseignant; 
  List<dynamic> enseignants = []; 
  bool isLoadingPage = true; // Chargement initial des profs
  bool isSaving = false;     // Chargement lors du clic sur Enregistrer

  final List<String> jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];

  @override
  void initState() {
    super.initState();
    fetchEnseignants(); 
  }

  // 1. RÉCUPÉRER LES ENSEIGNANTS DEPUIS LE BACKEND
  Future<void> fetchEnseignants() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8084/enseignant'));

      if (response.statusCode == 200) {
        setState(() {
          enseignants = jsonDecode(response.body);
          isLoadingPage = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingPage = false);
      _showSnackBar("Erreur de connexion au serveur", Colors.red);
    }
  }

  // 2. ENVOYER LE COURS À LA BD
  Future<void> addCours() async {
    // Validation simple
    if (selectedEnseignant == null || selectedDay == null || nomCoursController.text.isEmpty || heureDebutController.text.isEmpty) {
      _showSnackBar("Veuillez remplir tous les champs", Colors.orange);
      return;
    }

    setState(() => isSaving = true);

    // Map pour correspondre à l'Enum DayOfWeek de Java
    Map<String, String> daysMap = {
      'Lundi': 'MONDAY',
      'Mardi': 'TUESDAY',
      'Mercredi': 'WEDNESDAY',
      'Jeudi': 'THURSDAY',
      'Vendredi': 'FRIDAY',
      'Samedi': 'SATURDAY',
    };

    final url = Uri.parse('http://localhost:8084/api/enseignant/addcours');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomcours': nomCoursController.text,
          'salle': salleController.text,
          'niveau': niveauController.text,
          'groupe': groupeController.text,
          'jourDeLaSemaine': daysMap[selectedDay],
          // Ajout de :00 pour correspondre au format LocalTime (HH:mm:ss)
          'heureDebut': "${heureDebutController.text}:00",
          'heureFin': "${heureFinController.text}:00",
          'enseignant': {
            'id': selectedEnseignant['id'] 
          },
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar("Cours ajouté avec succès !", Colors.green);
        Navigator.pop(context); // Retour au dashboard
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        _showSnackBar("Erreur serveur (${response.statusCode})", Colors.red);
      }
    } catch (e) {
      print("Erreur : $e");
      _showSnackBar("Erreur réseau ou serveur injoignable", Colors.red);
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  // Sélecteur d'heure
  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Cours", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoadingPage
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Sélecteur d'Enseignant
                  DropdownButtonFormField<dynamic>(
                    decoration: const InputDecoration(
                      labelText: "Enseignant",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    value: selectedEnseignant,
                    hint: const Text("Choisir un enseignant"),
                    items: enseignants.map((e) {
                      return DropdownMenuItem<dynamic>(
                        value: e,
                        child: Text(e['nom'] ?? 'Sans nom'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedEnseignant = val),
                  ),
                  const SizedBox(height: 15),

                  MyTextfield(controller: nomCoursController, hintText: "Intitulé du cours (ex: ICT201)", obscureText: false),
                  const SizedBox(height: 15),

                  // Sélecteur de Jour
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Jour de la semaine", 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    items: jours.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
                    onChanged: (val) => setState(() => selectedDay = val),
                  ),
                  const SizedBox(height: 15),

                  // Heures Début / Fin
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: heureDebutController,
                          readOnly: true,
                          onTap: () => _selectTime(heureDebutController),
                          decoration: const InputDecoration(
                            labelText: "Heure Début",
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: heureFinController,
                          readOnly: true,
                          onTap: () => _selectTime(heureFinController),
                          decoration: const InputDecoration(
                            labelText: "Heure Fin",
                            prefixIcon: Icon(Icons.access_time_filled),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Niveau / Groupe
                  Row(
                    children: [
                      Expanded(child: MyTextfield(controller: niveauController, hintText: "Niveau", obscureText: false)),
                      const SizedBox(width: 10),
                      Expanded(child: MyTextfield(controller: groupeController, hintText: "Groupe", obscureText: false)),
                    ],
                  ),
                  const SizedBox(height: 15),

                  MyTextfield(controller: salleController, hintText: "Salle / Amphi", obscureText: false),
                  const SizedBox(height: 30),

                  // Bouton Enregistrer
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : addCours, // Désactivé pendant l'envoi
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 193, 55, 218),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("ENREGISTRER LE COURS",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}