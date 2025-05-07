import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String aboutText = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchAboutText();
  }

  Future<void> fetchAboutText() async {
    final url = Uri.parse(
      'http://10.0.2.2:8000/api/abouts/',
    ); // your actual endpoint
    try {
      final response = await http.get(url);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          aboutText = data['content'] ?? 'No content available';
        });
      } else {
        setState(() {
          aboutText = 'Failed to load content. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        aboutText = 'Error: $e';
      });
    }
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background1.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 25),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\n$aboutText\n',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, height: 1.6),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The DrinkMart Team',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color(0xFFFAD9B4),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Image.asset('assets/logo1.png', height: 50),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', width: 34),
                        const SizedBox(width: 12),
                        const Icon(Icons.apple, size: 28),
                        const SizedBox(width: 12),
                        const Icon(Icons.facebook, size: 28),
                        const SizedBox(width: 12),
                        Image.asset('assets/instagram.png', width: 34),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 1),
                    _footerLink('ABOUT'),
                    const Divider(height: 1, thickness: 1),
                    _footerLink('CONTACT US'),
                    const Divider(height: 1, thickness: 1),
                    _footerLink('PRIVACY'),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 20),
                    const Text(
                      'Copyright ©2025 DrinkMart. All Rights Reserved',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
