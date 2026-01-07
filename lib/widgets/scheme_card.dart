import 'package:flutter/material.dart';
import '../models/scheme.dart';

class SchemeCard extends StatelessWidget {
  final Scheme scheme;

  const SchemeCard({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(scheme.name),
        subtitle: Text(scheme.description),
      ),
    );
  }
}
