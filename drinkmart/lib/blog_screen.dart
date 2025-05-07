import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  Map<String, dynamic>? blog;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBlogData();
  }

  Future<void> fetchBlogData() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/blogs/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            blog = data[0]; // Display the first blog
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No blog found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load blog. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Blog',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      blog?['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Blog image (use a placeholder if null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          blog?['image'] != null
                              ? Image.network(blog!['image'], fit: BoxFit.cover)
                              : Image.asset(
                                'assets/blog1.jpg',
                                fit: BoxFit.cover,
                              ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      blog?['content'] ?? 'No content',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Author: ${blog?['author'] ?? 'Unknown'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }
}
