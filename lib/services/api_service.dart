
import 'dart:convert';
 
import 'package:http/http.dart' as http;
 
import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart'; 
 
class ApiService {
  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');
 
  static Future<List<Destination>> getDestinations() async {
    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);
 
    if (reponse.statusCode != 200) {
      throw Exception('Erreur lors de la récupération des destinations : ${reponse.statusCode}');
    } 
    // TODO 4 : si statusCode n'est pas 200, lancer une Exception
    //          avec un message contenant le code
 
    // utf8.decode garde les accents (Médenine, Désert...)
    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));
 
    // TODO 5 : transformer chaque élément de liste en Destination
    //          (map + Destination.fromJson + toList)
    return liste.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
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
    return creee['id'].toString(); // Retourne l'id attribué par le serveur
  }
}

// Q1 Pourquoi factory ? Un constructeur factory permet d'exécuter du code 
// de traitement (comme lire une Map) avant de retourner l'instance de l'objet, 
// tout en s'utilisant avec la syntaxe naturelle Destination.fromJson().
// Q2 Si prix est entre guillemets ("420"), il est considéré comme un String. 
// Le cast as int ou .toInt() échouera à l'exécution (TypeError) car Dart 
// ne convertit pas implicitement une chaîne en entier.
//Q3 La méthode est asynchrone (async) car la requête HTTP prend du temps. 
// Elle retourne un Future<List<Destination>> qui représente une "promesse" 
// de fournir la liste des objets une fois que le serveur aura répondu.
