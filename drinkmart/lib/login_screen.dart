import 'dart:convert';
import 'package:drinkmart/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password are required');
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('http://10.0.2.2:8000/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Login failed';
      _showError(error);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/half_fraction.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstATop),
              ),
            ),
          ),
          // Login Form
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 140,
                      child: const Center(
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 60,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Image.asset('assets/logo.png', width: 250, height: 250),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'Sign in to get the most of Drink',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 0),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(0, 0, 0, 0),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9933),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/google.png',
                          width: 24,
                          height: 24,
                        ),
                        label: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 16, 16, 16),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9D2A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/apple.png',
                          width: 34,
                          height: 34,
                        ),
                        label: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Continue with Apple',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 16, 16, 16),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9D2A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
