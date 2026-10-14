import 'package:flutter/material.dart';
import '../models/destination.dart';
 
class HeroBanner extends StatelessWidget {
  final Destination destination;
 
  const HeroBanner({super.key, required this.destination});
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Couche 1 : l'image
            Image.asset(destination.image, fit: BoxFit.cover),
 
            // Couche 2 : dégradé pour la lisibilité du texte blanc
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            // TODO 1 : Positioned(top: 16, right: 16) contenant un badge blanc
            //          arrondi : étoile ambre + note de la destination
            
 
              Positioned(top: 16, right: 16, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(destination.note.toStringAsFixed(1),
                     style: const TextStyle
                     (fontWeight: FontWeight.bold, color: Colors.black87,fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TODO 2 : Positioned(left: 20, right: 130, bottom: 20) contenant
            //          une Column : 'DESTINATION DU MOIS', le nom, la région
            Positioned(
              left: 20,
              right: 130,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESTINATION DU MOIS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.nom,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destination.region,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
           
                        ),
                  
                ],
              ),
            ),            Positioned(
              right: 16,
           
              bottom: 20,
              child: ElevatedButton(
                onPressed: () {
                  // TODO : action du bouton "Découvrir"
                },
               
                child: const Text('Découvrir'),
               ),
            ),
          ],
        ),
      ),
    );
  }
}
   
  

