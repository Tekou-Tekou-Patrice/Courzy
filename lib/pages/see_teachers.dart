import 'package:courzy/components/service.dart';
import 'package:courzy/models/enseignant.dart';
import 'package:flutter/material.dart';

class SeeTeacher extends StatefulWidget {
  const SeeTeacher({super.key});

  @override
  State<SeeTeacher> createState() => _SeeTeacherState();
}

class _SeeTeacherState extends State<SeeTeacher> {
  late Future<List<Enseignant>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = Service.getAllEnseignants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Enseignants'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Enseignant>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun enseignant'));
          }

          List<Enseignant> tasks = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(task.nom),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
