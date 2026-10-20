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
 String _categorie = 'Tout'; // l'état : la catégorie choisie
 
  List<Destination> get _filtrees {

    
    if(_categorie == 'Tout') {
      return destinations;
    } else {
      return destinations.where((d) => d.categorie == _categorie).toList();
    }
    // TODO 1 : si _categorie vaut 'Tout', renvoyer destinations ;
    //          sinon, seulement celles dont categorie == _categorie
    //          (méthode where puis toList, vue en TP 2)
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
            
            // TODO 2 : vrai seulement pour la catégorie choisie
            onSelected: (_) {
              setState(() {
                _categorie = c; // mémoriser la catégorie choisie
              });
              // TODO 3 : mémoriser c dans _categorie avec setState
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
    );
  }
}
