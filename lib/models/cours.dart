class Cours {
  final String jourDeLaSemaine; 
  final String heureDebut;
  final String heureFin;        
  final String nomcours;
  final String salle;
  final String niveau;
  final String groupe;
  final bool isDone; 

  Cours({
    required this.jourDeLaSemaine,
    required this.heureDebut,
    required this.heureFin,
    required this.nomcours,
    required this.salle,
    required this.niveau,
    required this.groupe,
    this.isDone = false,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      jourDeLaSemaine: json['jourDeLaSemaine'] ?? '',
      heureDebut: json['heureDebut'] ?? '',
      heureFin: json['heureFin'] ?? '',
      nomcours: json['nomcours'] ?? '',
      salle: json['salle'] ?? '',
      niveau: json['niveau'] ?? '',
      groupe: json['groupe'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'jourDeLaSemaine': jourDeLaSemaine,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'nomcours': nomcours,
      'salle': salle,
      'niveau': niveau,
      'groupe': groupe,
      'isDone': isDone,
    };
  }
}