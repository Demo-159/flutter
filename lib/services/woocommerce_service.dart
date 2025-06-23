import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';

class WooCommerceService {
  // ⚠️ CAMBIAR ESTAS CREDENCIALES POR LAS TUYAS
  static const String baseUrl = 'https://tu-tienda.com/wp-json/wc/v3/';
  static const String consumerKey = 'ck_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  static const String consumerSecret = 'cs_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

  Map<String, String> get _headers => {
    'Authorization': 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    'Content-Type': 'application/json',
  };

  Future<List<Product>> getProducts({int page = 1, int perPage = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products?page=$page&per_page=$perPage'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products?search=$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createOrder(List<CartItem> items, {
    String paymentMethod = 'pos',
    String customerEmail = 'pos@tienda.com',
    String customerName = 'Cliente POS',
  }) async {
    try {
      Map<String, dynamic> orderData = {
        'payment_method': paymentMethod,
        'payment_method_title': 'Punto de Venta',
        'set_paid': true,
        'status': 'completed',
        'billing': {
          'first_name': customerName,
          'last_name': '',
          'email': customerEmail,
        },
        'line_items': items.map((item) => item.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('${baseUrl}orders'),
        headers: _headers,
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  Future<bool> updateStock(int productId, int newStock) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}products/$productId'),
        headers: _headers,
        body: json.encode({'stock_quantity': newStock}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating stock: $e');
      return false;
    }
  }
}
