class Enseignant {
  final int? id;
  final String nom;
  final String email;
  final String password;

  Enseignant({this.id, required this.nom, required this.email, required this.password});

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'password': password,
    };
  }
}