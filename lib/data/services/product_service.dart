import 'package:delivery_factory_app/config/env.dart';
import 'base_service.dart';

class ProductService extends ApiBaseService {
  Future<Map<String, dynamic>> getProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    bool? featured,
    String? search,
    String? sort,
    int page = 1,
    int limit = Environment.defaultPageSize,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
    if (inStock != null) queryParams['inStock'] = inStock.toString();
    if (featured != null) queryParams['featured'] = featured.toString();
    if (search != null) queryParams['search'] = search;
    if (sort != null) queryParams['sort'] = sort;

    return await request<Map<String, dynamic>>(
      endpoint: Environment.productsEndpoint,
      method: HttpMethod.get,
      queryParameters: queryParams,
      onSuccess: (data) {
        if (data is Map<String, dynamic> && data.containsKey('products')) {
          final List<dynamic> productsList = data['products'];

          final products =
              productsList.map((item) => Product.fromJson(item)).toList();

          // Return formatted data with pagination
          return {'products': products, 'pagination': data['pagination']};
        }
        return data;
      },
    );
  }

  Future<Product> getProductById(String id) async {
    return await request<Product>(
      endpoint: '${Environment.productsEndpoint}/$id',
      method: HttpMethod.get,
      onSuccess: (data) => Product.fromJson(data),
    );
  }

  Future<List<Product>> getFeaturedProducts({int limit = 5}) async {
    return await request<List<Product>>(
      endpoint: '${Environment.productsEndpoint}/featured/list',
      method: HttpMethod.get,
      queryParameters: {'limit': limit.toString()},
      onSuccess: (data) {
        if (data is List) {
          return data.map((item) => Product.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  Future<List<Product>> getProductsByVendor(String vendorId) async {
    return await request<List<Product>>(
      endpoint: '${Environment.productsEndpoint}/vendor/$vendorId',
      method: HttpMethod.get,
      onSuccess: (data) {
        if (data is List) {
          return data.map((item) => Product.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    return await request<Product>(
      endpoint: Environment.productsEndpoint,
      method: HttpMethod.post,
      data: productData,
      onSuccess: (data) => Product.fromJson(data),
    );
  }

  Future<Product> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    return await request<Product>(
      endpoint: '${Environment.productsEndpoint}/$id',
      method: HttpMethod.put,
      data: productData,
      onSuccess: (data) => Product.fromJson(data),
    );
  }

  Future<bool> deleteProduct(String id) async {
    return await request<bool>(
      endpoint: '${Environment.productsEndpoint}/$id',
      method: HttpMethod.delete,
      onSuccess: (data) {
        if (data is Map && data.containsKey('message')) {
          return true;
        }
        return false;
      },
    );
  }
}
