import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/data/services/product_service.dart';
import 'package:delivery_factory_app/domain/models/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final Logger _logger = AppLogger().getLoggerForClass(ProductController);

  // List of products
  final RxList<Product> products = <Product>[].obs;

  // Featured products
  final RxList<Product> featuredProducts = <Product>[].obs;

  // Currently viewing product
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalProducts = 0.obs;

  // Filtering
  final RxString category = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxBool inStock = false.obs;
  final RxBool featured = false.obs;
  final RxString search = ''.obs;
  final RxString sort = 'newest'.obs;

  // Error handling
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchFeaturedProducts();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      isRefreshing.value = true;
      currentPage.value = 1;
    } else if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    error.value = '';

    try {
      final response = await _productService.getProducts(
        category: category.value.isNotEmpty ? category.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 1000 ? maxPrice.value : null,
        inStock: inStock.value ? true : null,
        featured: featured.value ? true : null,
        search: search.value.isNotEmpty ? search.value : null,
        sort: sort.value,
        page: currentPage.value,
      );

      if (response.containsKey('products') &&
          response['products'] is List<Product>) {
        final newProducts = response['products'] as List<Product>;

        if (currentPage.value == 1) {
          products.value = newProducts;
        } else {
          products.addAll(newProducts);
        }

        // Update pagination info
        if (response.containsKey('pagination') &&
            response['pagination'] is Map) {
          final pagination = response['pagination'] as Map;
          totalPages.value = pagination['pages'] as int? ?? 1;
          totalProducts.value = pagination['total'] as int? ?? 0;
        }
      }
    } catch (e) {
      _logger.e('Error fetching products: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      currentPage.value++;
      await fetchProducts();
    }
  }

  Future<void> refresh() async {
    await fetchProducts(refresh: true);
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      final featured = await _productService.getFeaturedProducts();
      featuredProducts.value = featured;
    } catch (e) {
      _logger.e('Error fetching featured products: $e');
    }
  }

  Future<void> getProductById(String id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final product = await _productService.getProductById(id);
      selectedProduct.value = product;
    } catch (e) {
      _logger.e('Error fetching product details: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String newCategory) {
    if (category.value != newCategory) {
      category.value = newCategory;
      currentPage.value = 1;
      fetchProducts();
    }
  }

  void setPrice(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    currentPage.value = 1;
    fetchProducts();
  }

  void setInStock(bool value) {
    inStock.value = value;
    currentPage.value = 1;
    fetchProducts();
  }

  void setFeatured(bool value) {
    featured.value = value;
    currentPage.value = 1;
    fetchProducts();
  }

  void setSearch(String query) {
    search.value = query;
    currentPage.value = 1;
    fetchProducts();
  }

  void setSort(String sortOption) {
    sort.value = sortOption;
    currentPage.value = 1;
    fetchProducts();
  }

  void resetFilters() {
    category.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 1000.0;
    inStock.value = false;
    featured.value = false;
    search.value = '';
    sort.value = 'newest';
    currentPage.value = 1;
    fetchProducts();
  }

  // Vendor operations (if user is a vendor)
  Future<bool> createProduct(Map<String, dynamic> productData) async {
    isLoading.value = true;
    error.value = '';

    try {
      await _productService.createProduct(productData);
      isLoading.value = false;
      return true;
    } catch (e) {
      _logger.e('Error creating product: $e');
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    isLoading.value = true;
    error.value = '';

    try {
      await _productService.updateProduct(id, productData);
      isLoading.value = false;
      return true;
    } catch (e) {
      _logger.e('Error updating product: $e');
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final success = await _productService.deleteProduct(id);
      if (success) {
        // Remove the product from the list
        products.removeWhere((product) => product.id == id);
      }
      isLoading.value = false;
      return success;
    } catch (e) {
      _logger.e('Error deleting product: $e');
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  // Helper methods
  List<String> getCategories() {
    final Set<String> categoriesSet = {};

    for (final product in products) {
      if (product.category != null && product.category!.isNotEmpty) {
        categoriesSet.add(product.category!);
      }
    }

    return categoriesSet.toList()..sort();
  }

  double getMaxProductPrice() {
    if (products.isEmpty) return 1000.0;

    double maxPrice = 0.0;
    for (final product in products) {
      if (product.price > maxPrice) {
        maxPrice = product.price;
      }
    }

    return maxPrice > 0 ? maxPrice : 1000.0;
  }
}
