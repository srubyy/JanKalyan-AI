import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../widgets/scheme_card.dart';
import 'scheme_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Scheme> schemes;

  const DashboardScreen({super.key, required this.schemes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eligible Schemes")),
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SchemeDetailScreen(scheme: schemes[i]),
              ),
            ),
            child: SchemeCard(scheme: schemes[i]),
          );
        },
      ),
    );
  }
}
