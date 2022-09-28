import 'package:flutter/material.dart';
import 'package:restaurant_favorite/data/api/api_service.dart';
import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class ListRestaurantPovider extends ChangeNotifier {
  final ApiService apiService;

  ListRestaurantPovider({required this.apiService}) {
    _getListProviderRestaurant();
  }

  late ListRestaurantModel _articlesResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ListRestaurantModel get result => _articlesResult;

  ResultState get state => _state;

  Future<dynamic> _getListProviderRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final article = await apiService.getListRestaurant();
      if (article.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _articlesResult = article;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Whoops. Kamu tidak tersambung dengan Internet!';
    }
  }
}
