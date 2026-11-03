import 'package:flutter/material.dart';
import 'package:rihla/models/destination.dart';
import '../data/destinations.dart'; 
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart'; 
import '../widgets/section_title.dart';
import '../widgets/destination_card.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _onglet = 0; // l'état : l'onglet choisi
  String _categorie = 'Tout'; // l'état : la catégorie choisie

  List<Destination> get _filtrees {
    if(_categorie == 'Tout') {
      return destinations;
    } else {
      return destinations.where((d) => d.categorie == _categorie).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            HomeHeader(prenom:'rihla'),
            SizedBox(height: 20),
            SearchBox(),
            SizedBox(height: 24),
            HeroBanner(destination: destinations.first),
            SizedBox(height: 24),
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
            for(final d in _filtrees)
              DestinationCard(destination: d)
          ],
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