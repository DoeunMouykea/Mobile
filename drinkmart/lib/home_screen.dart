import 'package:drinkmart/about_screen.dart';
import 'package:drinkmart/account_profile_screen.dart';
import 'package:drinkmart/blog_screen.dart';
import 'package:drinkmart/cart_screen.dart';
import 'package:drinkmart/contact_screen.dart';
import 'package:drinkmart/favorite_screen.dart';
import 'package:drinkmart/login_screen.dart';
import 'package:drinkmart/product_screen.dart';
import 'package:drinkmart/register_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'history_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkMart',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  List<Map<String, String>> banners = [];

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchSlideshowData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= banners.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchSlideshowData() async {
    setState(() {});

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/slideshow/'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          banners =
              data
                  .map<Map<String, String>>(
                    (item) => {
                      'image': 'http://10.0.2.2:8000${item['image']}',
                      'title': item['title'] as String? ?? 'Promotion',
                    },
                  )
                  .toList();
        });
      } else {
        throw Exception('Failed to load slideshows');
      }
    } catch (e) {
      print('Error fetching slideshows: $e');
      // Fallback to default banners if API fails
      setState(() {
        banners = [
          {'image': 'assets/banner1.jpg', 'title': 'Special Offer 20%'},
          {'image': 'assets/banner2.jpg', 'title': 'New Arrivals'},
          {'image': 'assets/banner3.jpg', 'title': 'Limited Edition'},
          {'image': 'assets/banner4.png', 'title': 'Flash Sale'},
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/menu_icon.png', width: 40, height: 40),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/logo1.png', width: 150, height: 150)],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, size: 28), onPressed: () {}),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.asset(
                'assets/promotion_30.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(),
                        ),
                      );
                    },
                    child: CategoryChip(label: 'All', isSelected: true),
                  ),
                  CategoryChip(label: 'Energy Drinks'),
                  CategoryChip(label: 'Sugar'),
                  CategoryChip(label: 'Zero Sugar'),
                  CategoryChip(label: 'Juice'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 350,
              child: Stack(
                children: [
                  banners.isNotEmpty
                      ? PageView.builder(
                        controller: _pageController,
                        itemCount: banners.length,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final banner = banners[index];
                          return _buildPromoBannerWithButton(
                            context,
                            banner['image']!,
                            banner['title']!,
                          );
                        },
                      )
                      : Center(child: CircularProgressIndicator()),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentPage == index
                                    ? Color.fromARGB(255, 244, 152, 54)
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Best Seller',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              padding: EdgeInsets.all(16),
              children: [
                ProductCard(
                  name: 'Red Bull Energy Drink',
                  price: '\$1.50',
                  image: 'assets/red_bull.jpg',
                ),
                ProductCard(
                  name: 'Brewed Tea & Lemonade',
                  price: '\$1.50',
                  image: 'assets/tea_lemonade.jpg',
                ),
                ProductCard(
                  name: 'Monster Zero Sugar',
                  price: '\$2.50',
                  image: 'assets/monster_zero.jpg',
                ),
                ProductCard(
                  name: 'Sugartree Wrings',
                  price: '\$1.50',
                  image: 'assets/sugartree.jpg',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [Expanded(child: Image.asset('assets/banner2.jpg'))],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Energy Drink is appreciated worldwide by top athletes, busy professionals, university students and travelers on long journeys.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [Expanded(child: Image.asset('assets/banner3.jpg'))],
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Color(0xFFFAD9B4),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo1.png', height: 50),
                  SizedBox(height: 8),
                  Text(
                    'DrinkMart',
                    style: TextStyle(
                      fontFamily: 'KaushanScript',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google.png', width: 24),
                      SizedBox(width: 12),
                      Icon(Icons.apple, size: 28),
                      SizedBox(width: 12),
                      Icon(Icons.facebook, size: 28),
                      SizedBox(width: 12),
                      Image.asset('assets/instagram.png', width: 34),
                    ],
                  ),
                  SizedBox(height: 12),
                  footerLink('ABOUT'),
                  const Divider(thickness: 1, color: Colors.grey),
                  footerLink('CONTACT US'),
                  const Divider(thickness: 1, color: Colors.grey),
                  footerLink('PRIVACY'),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Copyright ©2025 DrinkMart. All Rights Reserved',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFFF9933),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined),
              iconSize: 30,
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.article),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPromoBannerWithButton(
    BuildContext context,
    String imagePath,
    String title,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 139, 54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'HOT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$title - Buy Now clicked!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                      fontFamily: 'KaushanScript',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/menu_icon1.png', width: 40, height: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/logo1.png', width: 150, height: 150)],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, size: 28), onPressed: () {}),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, size: 28),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFED3B4),
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildMenuItem(context, 'HOME', Icons.home, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            _buildMenuItem(context, 'PRODUCT', Icons.shopping_bag, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            _buildMenuItem(context, 'ABOUT', Icons.info, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            _buildMenuItem(context, 'BLOG', Icons.article, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlogScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            _buildMenuItem(context, 'CONTACT US', Icons.contact_mail, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            _buildMenuItem(context, 'ACCOUNT', Icons.account_circle, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountProfileScreen()),
              );
            }),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Log in',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(child: Text('or')),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Create account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google.png', width: 24),
                SizedBox(width: 12),
                Icon(Icons.apple, size: 28),
                SizedBox(width: 12),
                Icon(Icons.facebook, size: 28),
                SizedBox(width: 12),
                Image.asset('assets/instagram.png', width: 24),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const CategoryChip({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor:
            isSelected ? Color.fromARGB(255, 244, 152, 54) : Color(0xFFE0DEDE),
        labelStyle: TextStyle(
          color:
              isSelected
                  ? const Color.fromARGB(255, 255, 223, 223)
                  : Color(0xFF727272),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String image;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHeartClicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFCCD34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(widget.image, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF3F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                ),
                child: Text(
                  widget.price,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 238, 49, 49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                _isHeartClicked ? Icons.favorite : Icons.favorite_border,
                color: _isHeartClicked ? Colors.red : Colors.black,
              ),
              onPressed:
                  () => setState(() => _isHeartClicked = !_isHeartClicked),
            ),
          ),
        ],
      ),
    );
  }
}
