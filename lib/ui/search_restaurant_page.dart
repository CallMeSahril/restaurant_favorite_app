import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_favorite/provider/search_restaurants_provider.dart';
import 'package:restaurant_favorite/ui/detail_restaurant_page.dart';
import 'package:restaurant_favorite/utils/result_state.dart';

class SearchRestaurantPage extends StatefulWidget {
  static const routeName = '/search_page';

  const SearchRestaurantPage({
    Key? key,
  }) : super(key: key);
  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  TextEditingController controller = TextEditingController();
  String hasil = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.grey.shade500.withOpacity(0.23))
                      ]),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.23)),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    onChanged: (String query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          hasil = query;
                        });
                        state.getSearchProviderRestaurant(hasil);
                      }
                    },
                  ),
                ),
                (hasil.isEmpty)
                    ? const Center(
                        child: Text('Tuliskan apa yang ingin dicari!'),
                      )
                    : Consumer<SearchRestaurantProvider>(
                        builder: (context, state, _) {
                          if (state.state == ResultState.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == ResultState.hasData) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.result!.restaurants.length,
                              itemBuilder: (context, index) {
                                var restaurant =
                                    state.result!.restaurants[index];
                                return Stack(
                                  children: [
                                    Material(
                                      color: const Color(0xFFFFFFFF),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                        leading: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                                                  ),
                                                  fit: BoxFit.cover)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.white),
                                              Text(
                                                restaurant.rating.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          restaurant.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on),
                                            Text(restaurant.city)
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              DetailRestaurantPage.routeName,
                                              arguments: restaurant.id);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (state.state == ResultState.noData) {
                            return Center(child: Text(state.message));
                          } else if (state.state == ResultState.error) {
                            return Center(child: Text(state.message));
                          } else {
                            return const Center(child: Text(''));
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
