import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelected;

  const OptionCard({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          Wrap(
            children: options
                .map(
                  (e) => ElevatedButton(
                    onPressed: () => onSelected(e),
                    child: Text(e),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
