import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_favorite/data/api/api_service.dart';
import 'package:restaurant_favorite/data/db/database_helper.dart';
import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/provider/favorite_restaurant_provider.dart';
import 'package:restaurant_favorite/utils/result_state.dart';
import '../provider/detail_restaurant_provider.dart';

class DetailRestaurantPage extends StatelessWidget {
  static String routeName = "detail_restaurant_page";
  final RestaurantList restaurantList;
  const DetailRestaurantPage({super.key, required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailRestaurantProvider>(
            create: (_) => DetailRestaurantProvider(
                apiService: ApiService(), id: restaurantList.id)),
      ],
      child: Scaffold(
        body: _builder(context),
      ),
    );
  }

  Widget _builder(contex) {
    return Consumer<DetailRestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (state.state == ResultState.hasData) {
          const url = "https://restaurant-api.dicoding.dev/images/medium/";
          final resto = state.detailRestaurant.restaurant;
          return SafeArea(
            child: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(url + resto.pictureId),
                                fit: BoxFit.cover)),
                      ),
                      Consumer<FavoriteRestaurantProvider>(
                        builder: (context, value, child) {
                          return FutureBuilder<bool>(
                              future: value.isFavorited(resto.id),
                              builder: (context, snapshot) {
                                var isFavorited = snapshot.data ?? false;

                                return Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: isFavorited
                                          ? IconButton(
                                              icon: Icon(Icons.favorite),
                                              onPressed: () {
                                                value.removeFavorite(
                                                    restaurantList.id);
                                                print("berhasil Hapus");
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite_border),
                                              onPressed: () {
                                                value.addFavorite(
                                                    restaurantList);
                                                print("berhasil tambah");
                                              },
                                            )),
                                );
                              });
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resto.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        resto.address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Dekripsi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text(resto.description),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Menu(
                          titleMenu: "Menu Drink",
                          widgetMenu: ListView.builder(
                            shrinkWrap: false,
                            itemCount: resto.menus.drinks.length,
                            itemBuilder: (BuildContext context, int index) {
                              final menuItem = resto.menus.drinks[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(menuItem.name),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Menu(
                          titleMenu: "Menu Makanan",
                          widgetMenu: ListView.builder(
                            shrinkWrap: false,
                            itemCount: resto.menus.foods.length,
                            itemBuilder: (BuildContext context, int index) {
                              final menuItem = resto.menus.foods[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(menuItem.name),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )),
          );
        } else if (state.state == ResultState.noData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      }
    });
  }
}

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required this.titleMenu,
    required this.widgetMenu,
  }) : super(key: key);

  final String titleMenu;
  final Widget widgetMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleMenu,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: widgetMenu,
        ),
      ],
    );
  }
}
