import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import 'home_screen.dart'; 

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key});

  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class _MesReservationsScreenState extends State<MesReservationsScreen> {
  late Future<List<Reservation>> _futurReservations;

  @override
  void initState() {
    super.initState();
    _futurReservations = ApiService.getReservations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getReservations();
    setState(() {
      _futurReservations = futur;
    });
    try {
      await futur;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Reservation>>(
        future: _futurReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErreurReseau(
              message: 'Impossible de charger vos voyages.',
              onReessayer: _recharger,
            );
          }

          final reservations = snapshot.data!;

          if (reservations.isEmpty) {
            return const Center(
              child: Text('Aucune réservation pour le moment.', style: TextStyle(fontSize: 16)),
            );
          }

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                final dateFormatee = '${r.dateDepart.day.toString().padLeft(2, '0')}/${r.dateDepart.month.toString().padLeft(2, '0')}/${r.dateDepart.year}';
                
                return Dismissible(
                  key: ValueKey(r.id ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    final reservationSupprimee = reservations[index];

                
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final errorColor = Theme.of(context).colorScheme.error;

                    setState(() {
                      reservations.removeAt(index);
                    });

                    try {
                      if (reservationSupprimee.id != null) {
                        await ApiService.supprimerReservation(reservationSupprimee.id!);
                      }
                      
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Réservation annulée avec succès')),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: const Text('Erreur lors de la suppression sur le serveur'),
                          backgroundColor: errorColor,
                        ),
                      );
                      _recharger();
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              r.destination.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.destination.nom,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('Départ le $dateFormatee', style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text('${r.voyageurs} voyageur(s) · ${r.formule}', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          Text(
                            '${r.total} DT',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}