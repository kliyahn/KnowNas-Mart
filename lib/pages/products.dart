import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import 'mypurchase_farmer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = 'All';
  static Map<String, int> cart = {};

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Fresh Pineapple',
      'category': 'Pineapple',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/nenas01.png',
    },
    {
      'id': '2',
      'name': 'Pineapple Juice',
      'category': 'Drinks',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/jus_nenas.png',
    },
    {
      'id': '3',
      'name': 'Canned Pineapple',
      'category': 'Food',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/tin_nenas.png',
    },
    {
      'id': '4',
      'name': 'Pineapple Tart',
      'category': 'Food',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 7.20',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/tart_nenas.png',
    },
    {
      'id': '5',
      'name': 'Pineapple Jam',
      'category': 'Food',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/jem_nenas.png',
    },
    {
      'id': '6',
      'name': 'Fresh Pineapple Box',
      'category': 'Pineapple',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'image': 'assets/nenas02.png',
    },
  ];


  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 'All') {
      return products;
    }
    return products.where((p) => p['category'] == selectedCategory).toList();
  }

  void addToCart(String productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });
    
    // Show snackbar with option to view cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Added to cart'),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPurchaseFarmerPage(
                      cartItems: _buildCartItems(),
                    ),
                  ),
                );
              },
              child: const Text(
                'VIEW CART',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF2D5F3F),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void updateQuantity(String productId, int change) {
    setState(() {
      int currentQty = cart[productId] ?? 0;
      int newQty = currentQty + change;
      if (newQty <= 0) {
        cart.remove(productId);
      } else {
        cart[productId] = newQty;
      }
    });
  }

  List<Map<String, dynamic>> _buildCartItems() {
    List<Map<String, dynamic>> cartItems = [];
    
    cart.forEach((productId, quantity) {
      final product = products.firstWhere(
        (p) => p['id'] == productId,
        orElse: () => {},
      );
      
      if (product.isNotEmpty) {
        cartItems.add({
          'id': product['id'],
          'name': product['name'],
          'image': product['image'],
          'currentPrice': double.parse(product['currentPrice'].replaceAll('RM ', '')),
          'newPrice': double.parse(product['oldPrice'].replaceAll('RM ', '')),
          'wholesalePrice': double.parse(product['wholesalePrice'].replaceAll('RM ', '')),
          'quantities': quantity,
          'isSelected': false,
        });
      }
    });
    
    return cartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2D5F3F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PRODUCTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Cart Badge
                    if (cart.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPurchaseFarmerPage(
                                cartItems: _buildCartItems(),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cart.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BB8A3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Search Products',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5F3F),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton('All'),
                _buildCategoryButton('Pineapple'),
                _buildCategoryButton('Drinks'),
                _buildCategoryButton('Food'),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9BB8A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2D5F3F) : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    String productId = product['id'];
    int quantity = cart[productId] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9BB8A3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A9D6F),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(product['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Product Info
          Text(
            product['name'],
            style: const TextStyle(
              color: Color(0xFF2D5F3F),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),

          // Prices
          Row(
            children: [
              const Text(
                'Current Price',
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                product['currentPrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Text(
                'New Price / unit',
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                product['oldPrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Text(
                'Wholesale Price',
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                product['wholesalePrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Quantity Controls or Add Button
          quantity > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        color: Color(0xFF2D5F3F),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => updateQuantity(productId, -1),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: Color(0xFF2D5F3F),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              color: Color(0xFF2D5F3F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => updateQuantity(productId, 1),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D5F3F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        color: Color(0xFF2D5F3F),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => addToCart(productId),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D5F3F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}