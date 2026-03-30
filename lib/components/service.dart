import 'dart:convert';
import 'package:courzy/models/enseignant.dart';
import 'package:http/http.dart' as http;

class Service {
  static const String baseUrl = 'http://localhost:8084';

  static Future<List<Enseignant>> getAllEnseignants() async {
    final response = await http.get(Uri.parse('$baseUrl/enseignant'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Enseignant.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des tâches');
    }
  }



  
}
