import 'package:drinkmart/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_provider.dart';
import 'account_profile_screen.dart';
import 'home_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoriteProvider>(context).favorites;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Favorite',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body:
          favorites.isEmpty
              ? Center(child: Text('No favorites yet.'))
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: favorites.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    final imageUrl = product['image'].replaceAll(
                      '127.0.0.1',
                      '10.0.2.2',
                    );
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFCCD34),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: Image.network(
                                  imageUrl,
                                  height: 160,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  product['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF3F1F1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        product['price'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.favorite, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: EdgeInsets.all(5),
              child: Icon(Icons.favorite, color: Colors.white, size: 20),
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
