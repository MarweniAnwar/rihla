import 'package:flutter/material.dart';
import 'package:rihla/widgets/home_header.dart';
 import '../widgets/search_box.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            HomeHeader(prenom:'rihla'),
            SizedBox(height: 20),
            SearchBox(),
          ],
        ),
      ),
    );
  }
}
