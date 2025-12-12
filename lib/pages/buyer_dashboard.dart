// lib/pages/buyer_dashboard.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../utils/supabase_service.dart';
import 'settings_buyer.dart';
import 'event_buyer.dart';
import 'analytic_buyer.dart';
import 'products_buyer.dart';
import '/pages/mypurchase.dart';
import '../widgets/bottom_nav_buyer.dart';

class BuyerDashboardPage extends StatefulWidget {
  const BuyerDashboardPage({super.key});

  @override
  State<BuyerDashboardPage> createState() => _BuyerDashboardPageState();
}

class _BuyerDashboardPageState extends State<BuyerDashboardPage> {
  int _currentAdIndex = 0;
  final PageController _adController = PageController();
  static Map<String, int> cart = {};

  // --- DYNAMIC STATE VARIABLES ---
  String _fullName = 'Loading...'; 
  String _buyerLocation = 'Loading...'; // Use buyerLocation state
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _fullName = 'Guest';
          _buyerLocation = 'No location set';
          _isLoadingProfile = false;
        });
      }
      return;
    }

    try {
      // Fetch both full_name and farm_location (used for buyer address)
      final response = await supabase
          .from('profiles')
          .select('full_name, farm_location')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _fullName = response['full_name'] ?? 'Buyer';
          _buyerLocation = response['farm_location'] ?? 'No address set'; // Use farm_location column
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fullName = 'Error loading name';
          _buyerLocation = 'Error loading address';
          _isLoadingProfile = false;
        });
      }
      print('Error fetching dashboard profile: $e');
    }
  }
  // --- END DYNAMIC STATE VARIABLES ---

  // Advertisement data (unchanged)
  final List<Map<String, String>> _advertisements = [
    {
      'image': 'assets/nenas03.png',
      'title': 'NEW\nCOLLECTION\n2025',
      'subtitle': 'Get 30% OFF',
    },
    {
      'image': 'assets/nenas02.png',
      'title': 'FRESH\nPRODUCE',
      'subtitle': 'Direct from Farm',
    },
    {
      'image': 'assets/nenas01.png',
      'title': 'SPECIAL\nOFFER',
      'subtitle': 'Limited Time',
    },
  ];

  // Sample product data (unchanged)
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Fresh Pineapple',
      'image': 'assets/nenas01.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
    },
    {
      'id': '2',
      'name': 'Pineapple Juice',
      'image': 'assets/jus_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
    },
    {
      'id': '3',
      'name': 'Canned Pineapple',
      'image': 'assets/tin_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
    },
  ];

  final List<Map<String, dynamic>> _popularProducts = [
    {
      'id': '4',
      'name': 'Pineapple Tart',
      'image': 'assets/tart_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 7.20',
      'wholesalePrice': 'RM 6.00',
    },
    {
      'id': '5',
      'name': 'Pineapple Jam',
      'image': 'assets/jem_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
    },
    {
      'id': '6',
      'name': 'Fresh Pineapple Box',
      'image': 'assets/nenas02.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
    },
  ];

  @override
  void dispose() {
    _adController.dispose();
    super.dispose();
  }

  void _viewMap() {
    print('View Map clicked');
  }

  void addToCart(String productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });

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
                    builder: (context) => MyPurchasePage(
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
        backgroundColor: const Color(0xFF3B5F3F),
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
    List<Map<String, dynamic>> allProducts = [..._products, ..._popularProducts];

    cart.forEach((productId, quantity) {
      final product = allProducts.firstWhere(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF3B5F3F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome and Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _fullName, // DYNAMIC NAME DISPLAY
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsBuyerPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Farm Location Card (Updated to use dynamic location)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _buyerLocation, // DYNAMIC - Uses fetched buyer location
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _viewMap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3B5F3F),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('View Map'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Advertisement Carousel (unchanged)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 230,
                      child: PageView.builder(
                        controller: _adController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentAdIndex = index;
                          });
                        },
                        itemCount: _advertisements.length,
                        itemBuilder: (context, index) {
                          final ad = _advertisements[index];
                          return _buildAdCard(
                            ad['title']!,
                            ad['subtitle']!,
                            ad['image']!,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _advertisements.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentAdIndex
                                ? const Color(0xFF3B5F3F)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Quick Action Section (unchanged)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QUICK ACTION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.event,
                          label: 'Events',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EventBuyerPage(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.trending_up,
                          label: 'Analytics',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnalyticsBuyerPage(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.inventory_2,
                          label: 'Browse',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductsBuyerPage(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.shopping_bag,
                          label: 'My Purchase',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyPurchasePage(
                                  cartItems: _buildCartItems(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Products Section (unchanged)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PRODUCTS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsBuyerPage(),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Popular This Week Section (unchanged)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'POPULAR THIS WEEK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsBuyerPage(),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = _popularProducts[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarBuyer(currentIndex: 0),
    );
  }

  // Helper methods: _buildAdCard, _buildQuickActionButton, _buildProductCard (unchanged)
  Widget _buildAdCard(String title, String subtitle, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B5F3F),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Learn More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF3B5F3F),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    String productId = product['id'];
    int quantity = cart[productId] ?? 0;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF9BB8A3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4A9D6F),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(product['image']),
                fit: BoxFit.cover,
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
                  fontSize: 9,
                ),
              ),
              const Spacer(),
              Text(
                product['currentPrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
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
                  fontSize: 9,
                ),
              ),
              const Spacer(),
              Text(
                product['oldPrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
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
                  fontSize: 9,
                ),
              ),
              const Spacer(),
              Text(
                product['wholesalePrice'],
                style: const TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 10,
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
                      'Quantities',
                      style: TextStyle(
                        color: Color(0xFF2D5F3F),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => updateQuantity(productId, -1),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 14,
                              color: Color(0xFF2D5F3F),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              color: Color(0xFF2D5F3F),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => updateQuantity(productId, 1),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D5F3F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 14,
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
                      'Quantities',
                      style: TextStyle(
                        color: Color(0xFF2D5F3F),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => addToCart(productId),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D5F3F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
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
    );
  }
}