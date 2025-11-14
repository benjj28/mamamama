import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsFromFirestore();
  }

  // Fetch all products from Firestore
  Future<void> _fetchProductsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Save the document ID
        return data;
      }).toList();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => _isLoading = false);
    }
  }

  // Filter products based on user input
  void _searchProduct(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
          (product['name'] as String).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Navigate to product detail
  void _openProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productData: product,
          productID: product['id'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Products"),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchProduct,
            ),
          ),

          // 📦 Product List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final p = _filteredProducts[index];
                return ListTile(
                  leading: Image.network(
                    p['imageUrl'],
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(p['name']),
                  subtitle: Text("₱${p['price']}"),
                  onTap: () => _openProductDetail(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
