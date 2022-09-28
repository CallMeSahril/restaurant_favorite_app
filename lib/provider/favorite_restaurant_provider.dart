import 'package:flutter/material.dart';
import 'package:restaurant_favorite/data/db/database_helper.dart';
import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class FavoriteRestaurantProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  FavoriteRestaurantProvider({required this.databaseHelper}) {
    getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantList> _favorites = [];
  List<RestaurantList> get favorites => _favorites;

  void getFavorites() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _favorites = await databaseHelper.getFavorites();
      if (_favorites.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = 'Empty Data';
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void addFavorite(RestaurantList restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
