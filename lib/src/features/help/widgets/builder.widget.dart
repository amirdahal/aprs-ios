import 'package:flutter/material.dart';

class BuildSection extends StatelessWidget {
  final String title;
  final String content;

  const BuildSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }
}

class BuildSteps extends StatelessWidget {
  final List<String> steps;
  const BuildSteps({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: steps
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "${entry.key + 1}. ${entry.value}",
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BuildImage extends StatelessWidget {
  final String imageName;
  final String caption;
  const BuildImage({super.key, required this.imageName, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/$imageName",
              // fit: BoxFit.contain,
              // height: 400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
