import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Profile',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AccountProfileScreen(),
    );
  }
}

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  _AccountProfileScreenState createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      'token',
    ); // Make sure this is saved during login

    if (token == null) {
      print("No token found");
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/auth/user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _usernameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['country'] ?? '';
      });
    } else {
      print(
        'Failed to fetch user data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  void _saveProfile(BuildContext context) {
    final updatedProfile = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'country': _addressController.text,
      'image': 'assets/profile_picture.jpg',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailsScreen(profileData: updatedProfile),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () => _saveProfile(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_wave.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage(
                      'assets/profile_picture.jpg',
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildProfileField('Username', _usernameController),
              const SizedBox(height: 20),
              _buildProfileField('Email', _emailController),
              const SizedBox(height: 20),
              _buildProfileField('Phone', _phoneController),
              const SizedBox(height: 20),
              _buildProfileField('Address', _addressController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _saveProfile(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF474747),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(24, 8, 8, 8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class AccountDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const AccountDetailsScreen({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_wave.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileData['image']),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 30),
              _buildDetailItem('Username', profileData['username']),
              const SizedBox(height: 20),
              _buildDetailItem('Email', profileData['email']),
              const SizedBox(height: 20),
              _buildDetailItem('Phone', profileData['phone']),
              const SizedBox(height: 20),
              _buildDetailItem('Address', profileData['country']),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF474747),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
