import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Réglages de l'application, mémorisés sur l'appareil.
class ReglagesModel extends ChangeNotifier {
  static const _cle = 'sombre';
  bool _sombre = false;
  bool get sombre => _sombre;

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    _sombre = prefs.getBool(_cle) ?? false;
    notifyListeners();
  }

  Future<void> basculerTheme() async {
    _sombre = !_sombre;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cle, _sombre);
    notifyListeners();
  }
}