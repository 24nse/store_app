import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/screens/add_product_page.dart';
import 'package:store_app/services/all_categories_service.dart';
import 'package:store_app/services/categories_service.dart';
import 'package:store_app/services/get_all_product_service.dart';
import 'package:store_app/widgets/custom_card.dart';
import 'package:store_app/widgets/product_section.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'all';
  late Future<List<ProductModel>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = AllProductsService().getAllProducts();
  }

  void _updateProductsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'all') {
        productsFuture = AllProductsService().getAllProducts();
      } else {
        productsFuture = CategoriesService().getCategoriesProducts(categoryName: category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductPage.id);
        },
        child: const Text("Add"),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.cartPlus,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New Trend',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: AllCategoriesService().getAllCateogires(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> categories = ['all', ...snapshot.data!];
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ChoiceChip(
                        label: Text(
                          categories[index],
                          style: TextStyle(
                            color: selectedCategory == categories[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: selectedCategory == categories[index],
                        selectedColor: Colors.blue.shade700,
                        backgroundColor: Colors.grey.shade200,
                        onSelected: (selected) {
                          _updateProductsByCategory(categories[index]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          ProductSection(productsFuture: productsFuture),
        ],
      ),
    );
  }
}
