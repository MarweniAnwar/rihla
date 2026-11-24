import 'dart:convert';
 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 
import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart'; 
 
class ApiService {
  static const _cleCache = 'cache_destinations';
  static bool depuisCache = false;

  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');

  static List<Destination> _decoder(String corps) =>
      (jsonDecode(corps) as List)
          .map((e) => Destination.fromJson(e as Map<String, dynamic>))
          .toList();
 
  static Future<List<Destination>> getDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final reponse = await http
          .get(_url('/destinations'))
          .timeout(ApiConfig.timeout);
 
      if (reponse.statusCode != 200) {
        throw Exception('Erreur lors de la récupération des destinations : ${reponse.statusCode}');
      } 

      final corps = utf8.decode(reponse.bodyBytes);
      await prefs.setString(_cleCache, corps);
      depuisCache = false;
      return _decoder(corps);
    } catch (e) {
      final cache = prefs.getString(_cleCache);
      if (cache == null) {
        rethrow;
      }
      depuisCache = true;
      return _decoder(cache);
    }
  }

  static Future<String> creerReservation(Reservation reservation) async {
    final reponse = await http
        .post(
          _url('/reservations'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 201) {
      throw Exception('Erreur lors de la création de la réservation : ${reponse.statusCode}');
    }

    final Map<String, dynamic> creee = jsonDecode(utf8.decode(reponse.bodyBytes));
    return creee['id'].toString();
  }


  static Future<List<Reservation>> getReservations() async {
    final reponse = await http
        .get(_url('/reservations?_embed=destination'))
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 200) {
      throw Exception('Erreur ${reponse.statusCode} lors de la récupération des réservations');
    }

    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));
    return liste.map((e) => Reservation.fromJson(e as Map<String, dynamic>)).toList();
  }
   static Future<void> supprimerReservation(String id) async {
    final reponse = await http
        .delete(_url('/reservations/$id'))
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 200) {
      throw Exception('Erreur ${reponse.statusCode} lors de la suppression de la réservation');
    }
  }
}