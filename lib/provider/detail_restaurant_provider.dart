import 'package:flutter/material.dart';

import 'package:restaurant_favorite/data/api/api_service.dart';
import 'package:restaurant_favorite/data/model/detail_restaurant_model.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  late DetailRestaurantModel _detailRestaurant;
  late ResultState _state;
  String _message = '';

  DetailRestaurantProvider({required this.id, required this.apiService}) {
    _getDetailProviderRestaurant(id);
  }

  String get message => _message;
  DetailRestaurantModel get detailRestaurant => _detailRestaurant;
  ResultState get state => _state;

  Future<dynamic> _getDetailProviderRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detailRestaurant = await apiService.getDetailRestaurant(id);

      if (detailRestaurant.error) {
        _state = ResultState.noData;
        notifyListeners();
      } else {
        _state = ResultState.hasData;

        notifyListeners();
        return _detailRestaurant = detailRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Tidak Ada Favorite';
    }
  }
}
