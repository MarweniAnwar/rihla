import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}
class _FavoriteButtonState extends State<FavoriteButton> {
  bool _favori = false;
  // TODO 1 : un booléen privé _favori, faux au départ
 
  void _basculer() {
    setState(() {
      _favori = !_favori;
    });
    // TODO 2 : inverser _favori avec setState
 
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_favori ? 'Ajouté aux favoris' : 'Retiré des favoris'),
        duration: const Duration(seconds: 1),
      ));
  }
 
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_favori ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: _basculer,
    );
    // TODO 3 : IconButton qui appelle _basculer ;
    //          icône favorite (rouge) ou favorite_border selon _favori
  }
}
