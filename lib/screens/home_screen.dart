import 'package:flutter/material.dart';
import 'package:rihla/models/destination.dart';
import '../data/destinations.dart'; 
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart'; 
import '../widgets/section_title.dart';
import '../widgets/destination_card.dart'; 
import '../services/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

            // Correction : on retourne le RefreshIndicator qui contient la ListView
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _onglet,
        onTap: (index) {
          setState(() {
            _onglet = index; // mémoriser l'onglet choisi
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Widget d'erreur réutilisable exigé par le TP
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