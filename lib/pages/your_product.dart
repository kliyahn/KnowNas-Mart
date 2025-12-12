// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/widgets/bottom_nav.dart';

class YourProductsPage extends StatefulWidget {
  const YourProductsPage({super.key, required List<dynamic> cartItems});

  @override
  State<YourProductsPage> createState() => _YourProductsPageState();
}

class _YourProductsPageState extends State<YourProductsPage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Fresh Pineapple',
      'image': 'assets/nenas01.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Pineapple',
      'description': 'Fresh pineapple from local farms',
    },
    {
      'id': '2',
      'name': 'Pineapple Juice',
      'image': 'assets/jus_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Drinks',
      'description': 'Refreshing pineapple juice',
    },
    {
      'id': '3',
      'name': 'Canned Pineapple',
      'image': 'assets/tin_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Food',
      'description': 'Premium canned pineapple',
    },
    {
      'id': '4',
      'name': 'Pineapple Tart',
      'image': 'assets/tart_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 7.20',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Food',
      'description': 'Delicious pineapple tart',
    },
    {
      'id': '5',
      'name': 'Pineapple Jam',
      'image': 'assets/jem_nenas.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Food',
      'description': 'Sweet pineapple jam',
    },
    {
      'id': '6',
      'name': 'Fresh Pineapple Box',
      'image': 'assets/nenas02.png',
      'currentPrice': 'RM 6.40',
      'oldPrice': 'RM 8.00',
      'wholesalePrice': 'RM 6.00',
      'quantities': 1,
      'category': 'Pineapple',
      'description': 'Bulk pineapple pack',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 'All') {
      return products;
    }
    return products.where((p) => p['category'] == selectedCategory).toList();
  }

  void _showEditProductModal(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditAddProductModal(product: product),
    );
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
                const Text(
                  'YOUR PRODUCTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
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

          // Quantities and Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantities',
                style: TextStyle(
                  color: Color(0xFF2D5F3F),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      product['quantities'].toString(),
                      style: const TextStyle(
                        color: Color(0xFF2D5F3F),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showEditProductModal(product),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D5F3F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Edit/Add Product Modal
class EditAddProductModal extends StatefulWidget {
  final Map<String, dynamic>? product;

  const EditAddProductModal({super.key, this.product});

  @override
  State<EditAddProductModal> createState() => _EditAddProductModalState();
}

class _EditAddProductModalState extends State<EditAddProductModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _currentPriceController;
  late TextEditingController _newPriceController;
  late TextEditingController _wholesalePriceController;
  late TextEditingController _currentQuantitiesController;
  late TextEditingController _updateQuantitiesController;
  late TextEditingController _productDescriptionController;
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with product data if editing
    _productNameController = TextEditingController(
      text: widget.product?['name'] ?? '',
    );
    _currentPriceController = TextEditingController(
      text: widget.product?['currentPrice']?.replaceAll('RM ', '') ?? '',
    );
    _newPriceController = TextEditingController(
      text: widget.product?['oldPrice']?.replaceAll('RM ', '') ?? '',
    );
    _wholesalePriceController = TextEditingController(
      text: widget.product?['wholesalePrice']?.replaceAll('RM ', '') ?? '',
    );
    _currentQuantitiesController = TextEditingController(
      text: widget.product?['quantities']?.toString() ?? '',
    );
    _updateQuantitiesController = TextEditingController();
    _productDescriptionController = TextEditingController(
      text: widget.product?['description'] ?? '',
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _currentPriceController.dispose();
    _newPriceController.dispose();
    _wholesalePriceController.dispose();
    _currentQuantitiesController.dispose();
    _updateQuantitiesController.dispose();
    _productDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product saved successfully!'),
          backgroundColor: Color(0xFF2D5F3F),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _addNewProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New product added successfully!'),
        backgroundColor: Color(0xFF2D5F3F),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2D5F3F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  'EDIT/ADD YOUR PRODUCT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image Upload Area
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9BB8A3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2D5F3F),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to add image',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'or drag and drop',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Product Name
                    _buildTextField(
                      controller: _productNameController,
                      label: 'Product Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Current Price
                    _buildTextField(
                      controller: _currentPriceController,
                      label: 'Current Price',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // New Price / Unit
                    _buildTextField(
                      controller: _newPriceController,
                      label: 'New Price / Unit',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Wholesale Price
                    _buildTextField(
                      controller: _wholesalePriceController,
                      label: 'Wholesale Price',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter wholesale price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Quantities Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _currentQuantitiesController,
                            label: 'Current Quantities',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _updateQuantitiesController,
                            label: 'Update Quantities',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Product Description
                    _buildTextField(
                      controller: _productDescriptionController,
                      label: 'Product Description',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9BB8A3),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addNewProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9BB8A3),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add New\nProduct',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showImageSourceDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9BB8A3),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add New\nPicture',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: const Color(0xFF9BB8A3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}