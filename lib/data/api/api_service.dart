import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_favorite/data/model/detail_restaurant_model.dart';
import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/data/model/search_restaurant_model.dart';

class ApiService {
  final String _url = 'https://restaurant-api.dicoding.dev/';

  Future<ListRestaurantModel> getListRestaurant() async {
    final response = await http.get(Uri.parse("${_url}list"));
    if (response.statusCode == 200) {
      return ListRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<DetailRestaurantModel> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse('${_url}detail/$id'));

    if (response.statusCode == 200) {
      return DetailRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detail Restaurant');
    }
  }

  Future<SearchRestaurantModel> getSearchRestaurant(String query) async {
    final response = await http.get(Uri.parse("${_url}search?q=$query"));
    if (response.statusCode == 200) {
      return SearchRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
