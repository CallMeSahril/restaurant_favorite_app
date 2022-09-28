import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_favorite/data/api/api_service.dart';
import 'package:restaurant_favorite/data/db/database_helper.dart';

import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/provider/favorite_restaurant_provider.dart';

import 'package:restaurant_favorite/provider/list_restaurant_provider.dart';
import 'package:restaurant_favorite/provider/search_restaurants_provider.dart';
import 'package:restaurant_favorite/ui/detail_restaurant_page.dart';
import 'package:restaurant_favorite/ui/favorite_restaurant_page.dart';
import 'package:restaurant_favorite/ui/home_page.dart';
import 'package:restaurant_favorite/ui/search_restaurant_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListRestaurantPovider>(
          create: (context) => ListRestaurantPovider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<SearchRestaurantProvider>(
          create: (_) => SearchRestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<FavoriteRestaurantProvider>(
            create: (_) =>
                FavoriteRestaurantProvider(databaseHelper: DatabaseHelper())),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restaurant',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            DetailRestaurantPage.routeName: (context) => DetailRestaurantPage(
                restaurantList: ModalRoute.of(context)!.settings.arguments!
                    as RestaurantList),
            FavoriteRestaurantPage.routeName: (context) =>
                const FavoriteRestaurantPage(),
            SearchRestaurantPage.routeName: (context) =>
                const SearchRestaurantPage(),
          }),
    );
  }
}
