import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../models/avis.dart';

class AvisScreen extends StatefulWidget {
  final Destination destination;

  const AvisScreen({super.key, required this.destination});

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomCtrl = TextEditingController();
  final _commCtrl = TextEditingController();
  int _note = 0;
  String? _erreurNote;
  AutovalidateMode _autoValidation = AutovalidateMode.disabled;

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _commCtrl.dispose();
    super.dispose();
  }

  void _publier() {
    setState(() {
      _erreurNote = _note == 0 ? 'Veuillez attribuer une note' : null;
    });

    if (!_formKey.currentState!.validate() || _note == 0) {
      setState(() => _autoValidation = AutovalidateMode.onUserInteraction);
      return;
    }

    final avis = Avis(
      auteur: _prenomCtrl.text.trim(),
      note: _note,
      commentaire: _commCtrl.text.trim(),
    );

    Navigator.pop(context, avis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avis sur ${widget.destination.nom}'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Votre note',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _note ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _note = index + 1;
                      _erreurNote = null;
                    });
                  },
                );
              }),
            ),
            if (_erreurNote != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _erreurNote!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _prenomCtrl,
              decoration: InputDecoration(
                labelText: 'Votre prénom',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Indiquez votre prénom';
                }
                if (v.trim().length < 2) {
                  return 'Au moins 2 caractères requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commCtrl,
              maxLines: 4,
              maxLength: 300,
              decoration: InputDecoration(
                labelText: 'Votre commentaire',
                alignLabelWithHint: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Écrivez un commentaire';
                }
                if (v.trim().length < 20) {
                  return 'Au moins 20 caractères requis';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _publier,
            icon: const Icon(Icons.send),
            label: const Text('Publier'),
          ),
        ),
      ),
    );
  }
}