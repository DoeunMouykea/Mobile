import 'package:drinkmart/favorite_screen.dart';
import 'package:drinkmart/history_screen.dart';
import 'package:flutter/material.dart';
import 'account_profile_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'favorite_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkMart',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/products/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body);
        setState(() {
          allProducts = decoded.cast<Map<String, dynamic>>();
          filteredProducts = List.from(allProducts);
        });
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchProducts(); // Call API on load
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts =
          allProducts
              .where((product) => product['name'].toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 218, 215, 215),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: filteredProducts[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ProductDetailScreen(product: filteredProducts[index]),
                ),
              );
            },
          );
        },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
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
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductCard({required this.product, required this.onTap});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // bool _isHeartClicked = false;

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(widget.product['name']);
    final imageUrl = widget.product['image'].replaceAll(
      '127.0.0.1',
      '10.0.2.2',
    );
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: Color(0xFFFCCD34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    widget.product['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3F1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 3,
                      ),
                    ),
                    child: Text(
                      widget.product['price'],
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 228, 31, 31),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  favoriteProvider.toggleFavorite(widget.product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? productDetails;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    final id = widget.product['id']; // Assuming 'id' exists
    final url = Uri.parse('http://10.0.2.2:8000/api/products/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          productDetails = json.decode(response.body);
        });
      } else {
        print('Failed to load product detail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final product = productDetails!;
    final imageUrl = product['image'].replaceAll('127.0.0.1', '10.0.2.2');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9933),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_wave.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(0, 0, 0, 0),
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 40),

              // Product Image
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  errorBuilder:
                      (context, error, stackTrace) => Center(
                        child: Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      product['description'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 30),

                    Divider(thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Volume
                        Text(
                          product['volume'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Volume and Price + Quantity Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price Text
                        Text(
                          product['price'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),

                        // Quantity Controls
                        Row(
                          children: [
                            // Decrease Button
                            GestureDetector(
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),

                            // Quantity Text
                            Text('$quantity', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),

                            // Increase Button
                            GestureDetector(
                              onTap: () {
                                setState(() => quantity++);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final cartProvider = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          final imagePath = product['image'];
                          final fullImageUrl =
                              imagePath.startsWith('http')
                                  ? imagePath
                                  : 'http://10.0.2.2:8000/$imagePath';
                          cartProvider.addToCart({
                            'name': product['name'],
                            'price': product['price'].toString(),
                            'image': fullImageUrl,
                            'quantity': quantity,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${product['name']} to cart'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
}
