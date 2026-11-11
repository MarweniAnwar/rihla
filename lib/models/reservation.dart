import 'destination.dart';

/// TP4 — Résultat du formulaire de réservation.
/// Il est créé par ReservationScreen puis renvoyé à l'écran précédent
/// avec Navigator.pop(context, reservation).
class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule;
  final int total;

  const Reservation({
    this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.dateDepart,
    required this.voyageurs,
    required this.formule,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'destinationId': destination.id,   // l'id suffit
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'dateDepart': dateDepart.toIso8601String(),
      'voyageurs': voyageurs,
      'formule': formule,
      'total': total,
      'id': id,
    };
  }


  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id']?.toString(),
      destination: Destination.fromJson(json['destination'] as Map<String, dynamic>),
      nom: json['nom'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String,
      dateDepart: DateTime.parse(json['dateDepart'] as String),
      voyageurs: (json['voyageurs'] as num).toInt(),
      formule: json['formule'] as String,
      total: (json['total'] as num).toInt(),
    );
  }
}