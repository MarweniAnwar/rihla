import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // AJOUT
import 'package:rihla/models/destination.dart';
import '../data/destinations.dart'; 
import '../providers/favoris_model.dart'; // AJOUT
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart'; 
import '../widgets/section_title.dart';
import '../widgets/destination_card.dart'; 
import '../services/api_service.dart';
import 'mes_reservations_screen.dart'; 
import 'favoris_screen.dart'; 
// Import de l'onglet Voyages

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _onglet = 0; // l'état : l'onglet choisi
  String _categorie = 'Tout'; // l'état : la catégorie choisie
  late Future<List<Destination>> _futurDestinations;

  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur;
    });
    try {
      await futur;
    } catch (_) {}
  }

  List<Destination> _filtrer(List<Destination> toutes) {
    if(_categorie == 'Tout') {
      return toutes;
    } else {
      return toutes.where((d) => d.categorie == _categorie).toList();
    }
  }

  // --- Gestion des écrans selon l'onglet sélectionné ---
  Widget _afficherOnglet() {
    switch (_onglet) {
      case 0:
        return _construireExplorer();
      case 1:
        // MODIFIÉ : l'onglet Favoris affiche FavorisScreen
        return const SafeArea(child: FavorisScreen());
      case 2:
        return const MesReservationsScreen(); // Onglet Voyages
      default:
        return _construireExplorer();
    }
  }

  Widget _construireExplorer() {
    return SafeArea(
      child: FutureBuilder<List<Destination>>(
        future: _futurDestinations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErreurReseau(
              message: 'Impossible de charger les destinations.',
              onReessayer: _recharger,
            );
          }
          final destinations = snapshot.data!;
          final filtrees = _filtrer(destinations);

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                const HomeHeader(prenom:'rihla'),
                const SizedBox(height: 20),
                const SearchBox(),
                const SizedBox(height: 24),
                if (destinations.isNotEmpty)
                  HeroBanner(destination: destinations.first),
                const SizedBox(height: 24),
                const SectionTitle(titre: 'Categaries'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final c in categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(c),
                            selected: _categorie == c, 
                            onSelected: (_) {
                              setState(() {
                                _categorie = c; // mémoriser la catégorie choisie
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 24),
                const SectionTitle(
                  titre:'populairés',
                  action:'voir tout',
                ),
                const SizedBox(height: 12,),
                for(final d in filtrees)
                  DestinationCard(destination: d)
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AJOUT : nombre de favoris, lu avec watch pour que le badge se mette à jour
    final nombre = context.watch<FavorisModel>().nombre;

    return Scaffold(
      body: _afficherOnglet(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _onglet,
        onTap: (index) {
          setState(() {
            _onglet = index; // mémoriser l'onglet choisi
          });
        },
        // MODIFIÉ : "const" retiré, car le badge dépend de la variable "nombre"
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(
            // MODIFIÉ : badge avec le nombre de favoris
            icon: Badge(
              isLabelVisible: nombre > 0,
              label: Text('$nombre'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favoris',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.luggage_outlined),
            label: 'Mes Voyages',
          ),
        ],
      ),
    );
  }
}

// Widget d'erreur réutilisable
class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurReseau({super.key, required this.message, required this.onReessayer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text('Vérifiez que json-server est lancé.'),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
//un commit par ia