import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // pour inputFormatters
 
import '../models/destination.dart';
//import '../models/reservation.dart';

 
class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;
 
  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}
 
class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
DateTime? _date;               // null tant qu'aucune date n'est choisie
String _formule = 'Essentiel';
bool _conditions = false;
AutovalidateMode _autoValidation = AutovalidateMode.disabled;
 
int get _prixParPersonne => _formule == 'Confort'
    ? (widget.destination.prix * 1.3).round()
    : widget.destination.prix;
 
int get _total => _prixParPersonne * widget.voyageurs;

 
  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
    // TODO 1 : libérer les trois contrôleurs, puis super.dispose()
  }
  Future<void> _choisirDate() async {
  final demain = DateTime.now().add(const Duration(days: 1));
  final choisie = await showDatePicker(
    context: context,
    initialDate: _date ?? demain,
    firstDate: demain,
    lastDate: DateTime.now().add(const Duration(days: 365)),
    helpText: 'Date de départ',
  );
  
  if (choisie == null) return; // L'utilisateur a annulé
  // TODO 1 : si l'utilisateur annule (null), ne rien faire
  
  setState(() {
    _date = choisie;
    _dateCtrl.text = '${choisie.day.toString().padLeft(2, '0')}/${choisie.month.toString().padLeft(2, '0')}/${choisie.year}';
  });
  // TODO 2 : avec setState, mémoriser la date dans _date et écrire
  //          'jj/mm/aaaa' dans _dateCtrl.text (padLeft(2, '0'))
}
 

 
  InputDecoration _deco(String label, IconData icone, {String? aide}) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
 
  String? _validerNom(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre nom';
    if (v.trim().length < 3) return 'Au moins 3 caractères';
    return null;
  }
 
  String? _validerEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre e-mail';
    final ok =RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail invalide (ex. : nom@mail.tn)';
    // TODO 2 : vide -> "Indiquez votre e-mail"
    //          ne respecte pas RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$')
    //          -> 'E-mail invalide (ex. : nom@mail.tn)'
  }
 
  String? _validerTel(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre téléphone';
    if (v.trim().length != 8) return '8 chiffres attendus';
    return null;
    // TODO 3 : vide -> 'Indiquez votre téléphone'
    //          longueur différente de 8 -> '8 chiffres attendus'
  }
 
  void _valider() {
    if (!_formKey.currentState!.validate()) return;
    // Provisoire : sera remplacé au palier 5
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulaire valide')),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réserver')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          widget.destination.image,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 64),
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.destination.nom,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text('Durée : ${widget.destination.duree}'),
            Text('Voyageurs : ${widget.voyageurs}'),
          ],
        ),
      ),
    ],
  ),
),
              // TODO 4 : récapitulatif (image 64 x 64, nom, durée, voyageurs)
              
              const SizedBox(height: 24),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco('Date de départ', Icons.calendar_month_outlined),
                validator: (_) => _date == null ? 'Choisissez une date' : null,
              ),
              
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Essentiel', label: Text('Essentiel'),
                      icon: Icon(Icons.backpack_outlined)),
                  ButtonSegment(value: 'Confort', label: Text('Confort +30 %'),
                      icon: Icon(Icons.hotel_outlined)),
                ],
                selected: {_formule},          // un Set : ici un seul élément
                onSelectionChanged: (choix) {
                  
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                value: _conditions,
                onChanged: (v) => setState(() => _conditions = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text("J'accepte les conditions d'annulation"),
                subtitle: const Text("Annulation gratuite jusqu'à 48 h avant"),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco('Nom complet', Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailCtrl,
                decoration: _deco('E-mail', Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),
              const SizedBox(height: 16),
              // TODO 5 : champ E-mail (clavier emailAddress)
              TextFormField(
                controller: _telCtrl,
                decoration: _deco('Téléphone', Icons.phone_outlined, aide: '8 chiffres, sans indicatif'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: _validerTel,
              ),
              // TODO 6 : champ Téléphone (clavier phone, chiffres seulement,
              //          8 maximum, texte d'aide '8 chiffres, sans indicatif')
            ],
          ),
        ),
      ),

      
      // TODO 7 : bottomNavigationBar avec un FilledButton.icon « Confirmer »
      //          qui appelle _valider (inspirez-vous de la barre du détail)
      bottomNavigationBar: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_prixParPersonne DT × ${widget.voyageurs} voyageurs'),
              Text(
                'Total : $_total DT',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          FilledButton(
            // Le bouton est grisé et désactivé (onPressed: null) si les conditions ne sont pas cochées
            onPressed: !_conditions
                ? null
                : () {
                    setState(() {
                      _autoValidation = AutovalidateMode.onUserInteraction;
                    });
                    _valider();
                  },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    ),
  );
  }}

  //Q1. Pourquoi le champ date est-il en readOnly ? Que se passerait-il sinon ?
 // R1. Le champ est en readOnly pour empêcher l'ouverture du clavier virtuel de l'appareil. 
   //   Sinon, l'utilisateur pourrait essayer de saisir la date manuellement au clavier, 
     // ce qui compliquerait grandement le formatage et contournerait le sélecteur de 
      //date sécurisé (showDatePicker).

  //Q2. _total est un getter. Pourquoi n'a-t-on pas besoin de le mettre à jour 
    //  nous-mêmes quand la formule change ?
  //R2. Un getter (int get _total) est recalculé dynamiquement et automatiquement à 
     // chaque fois qu'il est lu (notamment lors d'un appel à setState qui reconstruit 
      //l'arbre des widgets). Comme il dépend directement de _prixParPersonne (qui 
      //lui-même dépend de _formule), il se met à jour instantanément dès que la 
      //formule change.