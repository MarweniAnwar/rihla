import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  static const _cle = 'favoris';

  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};

  bool estFavori(Destination d) {
    return _favoris.containsKey(d.id);
  }

  List<Destination> get liste => List.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final textes = prefs.getStringList(_cle) ?? [];
    _favoris.clear();
    for (final t in textes) {
      final d = Destination.fromJson(jsonDecode(t) as Map<String, dynamic>);
      _favoris[d.id] = d;
    }
    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final textes = _favoris.values
        .map((d) => jsonEncode(d.toJson()))
        .toList();
    await prefs.setStringList(_cle, textes);
  }

  bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    if (ajoute) _favoris[d.id] = d;
    _sauvegarder();
    notifyListeners();
    return ajoute;
  }
}