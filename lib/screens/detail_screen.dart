import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../widgets/favorite_button.dart';
import 'reservation_screen.dart';
import '../models/reservation.dart';
import '../models/avis.dart';
import 'avis_screen.dart';
import '../services/api_service.dart'; // Ajout de l'import du service API

/// Devoir TP3 — Écran de détail d'une destination (version du kit TP4).
/// À relier aux cartes au palier 2 du TP4.
class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 1;

  // Liste initiale d'avis pour le Checkpoint 1
  final List<Avis> _avisList = [
    const Avis(
      auteur: 'Sarra',
      note: 5,
      commentaire: 'Séjour magnifique, la plage de Sidi Mahrez est superbe. Je recommande la formule Confort !',
    ),
    const Avis(
      auteur: 'Karim',
      note: 4,
      commentaire: 'Très bonne organisation, guide sympathique. Un peu de monde en août.',
    ),
  ];

  Future<void> _reserver() async {
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _voyageurs,
        ),
      ),
    );

    if (reservation == null) return;
    if (!mounted) return;

    final String id;
    try {
      id = await ApiService.creerReservation(reservation);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Envoi impossible : json-server est-il lancé ?'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Réservation confirmée'),
        content: Text(
          '${reservation.nom}, votre séjour à ${reservation.destination.nom} est '
          'réservé pour ${reservation.voyageurs} voyageur(s), formule ${reservation.formule}.\n\n'
          'Total : ${reservation.total} DT\n'
          'Un e-mail de confirmation sera envoyé à ${reservation.email}.\n\n'
          'N° de réservation :\n$id',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }

  Future<void> _laisserAvis() async {
    final avis = await Navigator.push<Avis>(
      context,
      MaterialPageRoute(
        builder: (context) => AvisScreen(destination: widget.destination),
      ),
    );

    if (avis == null) return;
    if (!mounted) return;

    setState(() {
      _avisList.insert(0, avis);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Merci pour votre avis !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'image-${d.nom}',
                  child: Image.asset(d.image, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: _BoutonRond(
                    child: IconButton(
                      tooltip: 'Retour',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                const Positioned(
                  top: 48,
                  right: 16,
                  child: _BoutonRond(child: FavoriteButton()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.nom,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.place_outlined,
                                  size: 18, color: cs.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(d.region,
                                  style: TextStyle(color: cs.onSurfaceVariant)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${d.note}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                          icone: Icons.schedule, label: 'Durée', valeur: d.duree),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoTile(
                          icone: Icons.category_outlined,
                          label: 'Type',
                          valeur: d.categorie),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _InfoTile(
                          icone: Icons.groups_outlined,
                          label: 'Groupe',
                          valeur: 'Max 12'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('À propos',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(d.description,
                    style: TextStyle(height: 1.5, color: cs.onSurfaceVariant)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text('Voyageurs',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton.outlined(
                      onPressed: _voyageurs > 1
                          ? () => setState(() => _voyageurs--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$_voyageurs',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () => setState(() => _voyageurs++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // --- SECTION AVIS (Checkpoint 1) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Avis (${_avisList.length})',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: _laisserAvis,
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Laisser un avis'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _avisList.isEmpty
                    ? const Text('Soyez le premier à donner votre avis.')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _avisList.length,
                        itemBuilder: (context, index) {
                          final avis = _avisList[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 0,
                            color: cs.surfaceContainerLow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            cs.primaryContainer,
                                        child: Text(
                                          avis.auteur[0].toUpperCase(),
                                          style: TextStyle(
                                            color: cs.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          avis.auteur,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => Icon(
                                            i < avis.note
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(avis.commentaire),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(color: cs.onSurfaceVariant)),
                  Text(
                    '${d.prix * _voyageurs} DT',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton(
                  onPressed: _reserver,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoutonRond extends StatelessWidget {
  final Widget child;

  const _BoutonRond({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _InfoTile({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icone, color: cs.primary),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}