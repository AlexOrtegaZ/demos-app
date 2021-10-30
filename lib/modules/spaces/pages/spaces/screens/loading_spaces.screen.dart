import 'package:flutter/material.dart';

class LoadingSpacesScreen extends StatelessWidget {
  const LoadingSpacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}