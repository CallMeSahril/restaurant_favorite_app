import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_favorite/data/api/api_service.dart';
import 'package:restaurant_favorite/data/model/search_restaurant_model.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService}) {
    getSearchProviderRestaurant(search);
  }

  SearchRestaurantModel? _restaurantResult;
  ResultState? _state;
  String _message = '';
  String _search = '';

  String get message => _message;

  SearchRestaurantModel? get result => _restaurantResult;

  String get search => _search;

  ResultState? get state => _state;

  Future<dynamic> getSearchProviderRestaurant(String search) async {
    try {
      if (search.isNotEmpty) {
        _state = ResultState.loading;
        _search = search;
        notifyListeners();
        final restaurant = await apiService.getSearchRestaurant(search);
        if (restaurant.restaurants.isEmpty) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Empty Data Boss!';
        } else {
          _state = ResultState.hasData;
          notifyListeners();
          return _restaurantResult = restaurant;
        }
      } else {
        return _message = 'text null';
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message =
          "Terjadi kesalahan saat menghubungkan, silahkan cek koneksi anda";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
