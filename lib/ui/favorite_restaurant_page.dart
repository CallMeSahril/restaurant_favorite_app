import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:restaurant_favorite/data/model/list_restaurant_model.dart';
import 'package:restaurant_favorite/provider/favorite_restaurant_provider.dart';

import 'package:restaurant_favorite/ui/detail_restaurant_page.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class FavoriteRestaurantPage extends StatelessWidget {
  static String routeName = "favorite_restaurant_page";

  const FavoriteRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavoriteRestaurantProvider>(builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (BuildContext context, int index) {
              print(state.favorites.length);
              return ListContainer(restaurant: state.favorites[index]);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      }),
    );
  }
}

class ListContainer extends StatelessWidget {
  const ListContainer({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  final RestaurantList restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
            context, DetailRestaurantPage.routeName,
            arguments: restaurant),
        title: Text(
          restaurant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 15,
                ),
                Text(restaurant.city),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 15,
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
        leading: Container(
          width: 100,
          height: 75,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                  ),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
