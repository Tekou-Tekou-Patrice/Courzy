import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModifierCoursPage extends StatefulWidget {
  final Map<String, dynamic> cours; // Reçoit les données du cours à modifier

  const ModifierCoursPage({super.key, required this.cours});

  @override
  State<ModifierCoursPage> createState() => _ModifierCoursPageState();
}

class _ModifierCoursPageState extends State<ModifierCoursPage> {
  late TextEditingController _jourController;
  late TextEditingController _debutController;
  late TextEditingController _finController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _jourController = TextEditingController(text: widget.cours['jourDeLaSemaine']);
    _debutController = TextEditingController(text: widget.cours['heureDebut']);
    _finController = TextEditingController(text: widget.cours['heureFin']);
  }

  Future<void> _updateCours() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:8084/api/enseignant/update-time/${widget.cours['id']}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jourDeLaSemaine': _jourController.text.toUpperCase(),
          'heureDebut': _debutController.text,
          'heureFin': _finController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Modification réussie !"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Retourne à la liste et signale le succès
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le Cours"),
        backgroundColor: const Color.fromARGB(255, 207, 51, 235),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _jourController,
              decoration: const InputDecoration(labelText: "Jour (ex: MONDAY)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _debutController,
              decoration: const InputDecoration(labelText: "Heure Début (ex: 08:00:00)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _finController,
              decoration: const InputDecoration(labelText: "Heure Fin (ex: 10:00:00)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateCours,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 51, 235),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("ENREGISTRER LES MODIFICATIONS", style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}