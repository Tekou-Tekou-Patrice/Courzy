class Cahier {
  

    final String nom;
    final String course;
    final String chapitre;
    final String niveau;
    final String groupe;

    Cahier({ 
      required this.nom,
      required this.course,
      required this.chapitre,
      required this.niveau,
      required this.groupe
    });

    factory Cahier.fromJson(Map<String,dynamic> json) {
      return Cahier(
        nom: json['nomEnseignant'],
        course: json['nomCours'],
        chapitre: json['chapitre'],
        niveau: json['niveau'],
        groupe: json['groupe']
      );
    }
}