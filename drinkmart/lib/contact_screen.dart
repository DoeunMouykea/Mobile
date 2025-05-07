import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padded content only
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      iconTheme: const IconThemeData(color: Colors.black),
                    ),
                    Center(
                      child: Image.asset('assets/contact_us.png', height: 180),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "We'd love to hear from you!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Whether you have a question, feedback, or\n"
                      "need assistance, the DrinkMart team is\n"
                      "here to help. Reach out to us through any\n"
                      "of the methods below:",
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    _buildContactInfo(
                      Icons.location_on,
                      "Address: 123 Royal Street, Phnom Penh ",
                    ),
                    const SizedBox(height: 10),
                    _buildContactInfo(
                      Icons.phone,
                      "Phone: (+855) 85378162 / 889390038",
                    ),
                    const SizedBox(height: 10),
                    _buildContactInfo(
                      Icons.email,
                      "Email: support@drinkmart.com",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Footer - full width, no padding constraint
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
                    const SizedBox(height: 5),
                    const Divider(height: 1, thickness: 1),
                    const _FooterLink(text: 'ABOUT'),
                    const Divider(height: 1, thickness: 1),
                    const _FooterLink(text: 'CONTACT US'),
                    const Divider(height: 1, thickness: 1),
                    const _FooterLink(text: 'PRIVACY'),
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
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.orange),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () {
          // Handle navigation
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
