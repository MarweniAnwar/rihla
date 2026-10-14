import 'package:flutter/material.dart';
import '../data/destinations.dart'; 
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart'; 
import '../widgets/section_title.dart';
 
import '../widgets/destination_card.dart'; 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
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
             const SizedBox(height: 12),
             const SizedBox(height: 24),
             const SectionTitle(
              titre:'populairés',
             action:'voir tout',
             ),
             const SizedBox(height: 12,),
             for(final d in destinations)
             DestinationCard(destination: d)
          ],
        ),
      ),
    );
  }
}
