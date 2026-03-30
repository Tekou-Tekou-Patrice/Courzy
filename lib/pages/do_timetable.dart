import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  // Contrôleurs pour les textes
  final nomCours = TextEditingController();
  final salle = TextEditingController();
  final niveau = TextEditingController();
  final groupe = TextEditingController();
  final heureDebut = TextEditingController();
  final heureFin = TextEditingController();

  // Données de sélection
  String? selectedDay;
  String? selectedEnseignant; // Simplifié en String pour l'exemple
  bool isLoading = false;

  final List<String> jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
  final List<String> enseignants = [];

  // Fonction pour choisir l'heure
  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitData() {
    setState(() => isLoading = true);
    // Simulation d'envoi
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cours enregistré !")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmer un cours"),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Liste Enseignants
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Enseignant", border: OutlineInputBorder()),
            items: enseignants.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedEnseignant = val),
          ),
          const SizedBox(height: 15),

          // Nom du cours
          TextField(
            controller: nomCours,
            decoration: const InputDecoration(labelText: "Nom du cours", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),

          // Jour
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Jour", border: OutlineInputBorder()),
            items: jours.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
            onChanged: (val) => setState(() => selectedDay = val),
          ),
          const SizedBox(height: 15),

          // Ligne Heures
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: heureDebut,
                  readOnly: true,
                  onTap: () => _selectTime(heureDebut),
                  decoration: const InputDecoration(labelText: "Début", prefixIcon: Icon(Icons.access_time), border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: heureFin,
                  readOnly: true,
                  onTap: () => _selectTime(heureFin),
                  decoration: const InputDecoration(labelText: "Fin", prefixIcon: Icon(Icons.access_time), border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Ligne Niveau & Groupe
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: niveau,
                  decoration: const InputDecoration(labelText: "Niveau", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: groupe,
                  decoration: const InputDecoration(labelText: "Groupe", border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Salle
          TextField(
            controller: salle,
            decoration: const InputDecoration(labelText: "Salle", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 30),

          // Bouton
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submitData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("ENREGISTRER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}