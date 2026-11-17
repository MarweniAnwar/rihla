import 'package:flutter/foundation.dart';
import '../models/destination.dart';

/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  

  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
 // TODO estFavori(Destination d) -> bool




  // TODO estFavori(Destination d) -> bool
  bool estFavori(Destination d) {
    return _favoris.containsKey(d.id);
  }

  // TODO getter liste : les destinations favorites
  List<Destination> get liste => List.unmodifiable(_favoris.values);

  // TODO getter nombre
  int get nombre => _favoris.length;

  // TODO basculer(Destination d) : ajoute ou retire,
  //      prévient les écouteurs, renvoie true si ajouté
 bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    // ignore: collection_methods_unrelated_type
    if (ajoute) _favoris[d.id] = d;
    notifyListeners();
    return ajoute;
  }
}