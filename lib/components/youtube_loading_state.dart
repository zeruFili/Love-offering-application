import 'package:flutter/material.dart';

class YouTubeLoadingState extends StatelessWidget {
  const YouTubeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5D4A)),
      ),
    );
  }
}
