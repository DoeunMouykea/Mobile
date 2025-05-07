import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Registration successful: $data');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registered successfully!')));
    } else {
      print('Registration failed: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFFF9933),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/half_fraction1.png', fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 140),
                Center(child: Image.asset('assets/logo.png', height: 100)),
                const SizedBox(height: 20),
                const Text(
                  'Sign up to get the most of DrinkMart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 61, 60, 60),
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField('Full Name', controller: nameController),
                const SizedBox(height: 10),
                _buildTextField(
                  'Email *',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Create Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 58, 58, 58),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 109, 108, 108),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 98, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Color.fromARGB(255, 102, 100, 100)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 98, 96, 96),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Color.fromARGB(255, 90, 88, 88)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSocialButton('Sign up with Google', 'assets/google.png'),
                const SizedBox(height: 10),
                _buildAppleButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 108, 107, 107)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(179, 115, 115, 115),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, String assetPath) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color.fromARGB(255, 151, 149, 149)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Image.asset(assetPath, height: 24),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 30, 29, 29),
        ),
      ),
    );
  }

  Widget _buildAppleButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: const BorderSide(color: Color.fromARGB(255, 151, 149, 149)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(
        Icons.apple,
        size: 24,
        color: Color.fromARGB(255, 13, 13, 13),
      ),
      label: const Text(
        'Sign up with Apple',
        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 30, 29, 29)),
      ),
    );
  }
}
