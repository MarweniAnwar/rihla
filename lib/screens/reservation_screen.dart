import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // pour inputFormatters
 
import '../models/destination.dart';
import '../models/reservation.dart'; 

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
  DateTime? _date;             // null tant qu'aucune date n'est choisie
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
    
    setState(() {
      _date = choisie;
      _dateCtrl.text = '${choisie.day.toString().padLeft(2, '0')}/${choisie.month.toString().padLeft(2, '0')}/${choisie.year}';
    });
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
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail invalide (ex. : nom@mail.tn)';
  }
 
  String? _validerTel(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre téléphone';
    if (v.trim().length != 8) return '8 chiffres attendus';
    return null;
  }
 
  void _valider() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidation = AutovalidateMode.onUserInteraction);
      return;
    }
    
    final reservation = Reservation(
      destination: widget.destination,
      nom: _nomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      dateDepart: _date!,
      voyageurs: widget.voyageurs,
      formule: _formule,
      total: _total,
    );

    Navigator.pop(context, reservation);
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
              const SizedBox(height: 24),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco('Date de départ', Icons.calendar_month_outlined),
                validator: (_) => _date == null ? 'Choisissez une date' : null,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Essentiel', label: Text('Essentiel'),
                      icon: Icon(Icons.backpack_outlined)),
                  ButtonSegment(value: 'Confort', label: Text('Confort +30 %'),
                      icon: Icon(Icons.hotel_outlined)),
                ],
                selected: {_formule},          
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
            ],
          ),
        ),
      ),
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
  }
}

/*
Q1. Que vaut reservation si l'utilisateur quitte le formulaire avec la flèche retour ?
- L'objet reservation vaut `null`. En effet, lorsque l'utilisateur quitte l'écran de formulaire 
  en appuyant sur la flèche retour (sans valider), aucun objet n'est passé en paramètre de 
  la méthode `Navigator.pop(context)`, ce qui renvoie `null` à l'appel `await Navigator.push`.

Q2. Retirez le test mounted : quel avertissement affiche VS Code ? Que signifie-t-il ?
- VS Code affiche l'avertissement : "Don't use 'BuildContext's across async gaps" (use_build_context_synchronously).
  Cela signifie qu'on essaie d'utiliser le `BuildContext` (avec `showDialog` ou `Navigator`) après un délai 
  asynchrone (`await`), ce qui est risqué si l'écran a été détruit ou fermé entre-temps.

Q3. Le bouton « Parfait » ferme la boîte de dialogue avec Navigator.pop. Qu'est-ce que cela vous apprend sur les boîtes de dialogue ?
- Cela apprend qu'une boîte de dialogue (`showDialog`) est gérée par Flutter comme une route ou un écran 
  superposé au-dessus de l'écran actuel (dans la pile de navigation), et qu'il faut utiliser `Navigator.pop(context)` 
  pour la dépiler et la refermer.
*/