import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo/Logo2.png',
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        BoxIcons.bx_bell,
                        color: Colors.black,
                        size: 33,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search bar with a search icon prefix
              TextField(
                decoration: InputDecoration(
                  hintText: "What are you looking for?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      BoxIcons.bx_search,
                      color: Colors.grey,
                      size: 29,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              // Categories section
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem("${Emojis.openBook} Fiction"),
                    _buildCategoryItem("${Emojis.books} Non-Fiction"),
                    _buildCategoryItem("${Emojis.sparkles} Fantasy"),
                    _buildCategoryItem("${Emojis.lightBulb} Mystery"),
                    _buildCategoryItem("${Emojis.rocket} Science Fiction"),
                    _buildCategoryItem("${Emojis.memo} Biography"),
                    _buildCategoryItem("${Emojis.scroll} History"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recommended Section
              const Text(
                "Recommended For You",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // 2 Books in a row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRecommendedItem(
                        "It Starts With Us", "assets/images/book1.jpg"),
                    _buildRecommendedItem(
                        "Gitanjali", "assets/images/book2.jpg"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recent Listings Section
              const Text(
                "Recent Listings",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // 2 Columns of recent listings
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 70,
                ),
                itemCount: 4, // Example item count
                itemBuilder: (context, index) {
                  return _buildListingItem(
                    "Leo Tolstoy ${index + 1}",
                    "assets/images/book4.jpg",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create a category item with emoji and label
  Widget _buildCategoryItem(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFdcdfe6)), // Grey border
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins Medium',
        ),
      ),
    );
  }

  // Function to create a recommended book item
  Widget _buildRecommendedItem(String title, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 170, // Set width for each book
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Apply ClipRRect to add border radius on the image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(12), // Border radius for the image
            child: Image.asset(
              imagePath,
              width: 170,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12), // Add some space between image and title
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Function to create a recent listing item
  Widget _buildListingItem(String title, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 170, // Set width for each book
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Apply ClipRRect to add border radius on the image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(12), // Border radius for the image
            child: Image.asset(
              imagePath,
              width: 170,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12), // Add some space between image and title
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
