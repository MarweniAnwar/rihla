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
      // TODO 1 : email, telephone, voyageurs, formule, total
      'id': id,
      // TODO 2 : dateDepart -> texte avec toIso8601String()
    };
  }
}



  
