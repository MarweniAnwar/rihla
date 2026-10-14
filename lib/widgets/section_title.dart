
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String titre;
  final String? action;

  const SectionTitle({
    super.key,
    required this.titre,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          titre,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (action != null)
          TextButton(
            onPressed: () {},
            child: Text(
              action!,
              style: TextStyle(color: cs.primary),
            ),
          ),
      ],
    );
  }
}
