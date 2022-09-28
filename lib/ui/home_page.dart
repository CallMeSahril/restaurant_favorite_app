import 'package:flutter/material.dart';
import 'package:restaurant_favorite/ui/favorite_restaurant_page.dart';
import 'package:restaurant_favorite/ui/list_restaurant_page.dart';
import 'package:restaurant_favorite/ui/search_restaurant_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pc = PageController();
  int index = 0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigation(),
      appBar: AppBar(
        title: Text("Restaurant"),
      ),
      body: PageView(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListRestaurantPage(),
          SearchRestaurantPage(),
          FavoriteRestaurantPage(),
        ],
      ),
    );
  }

  Container _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 20,
          color: Colors.black.withOpacity(0.06),
        )
      ]),
      child: BottomAppBar(
          color: Colors.white,
          child: Container(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          index = 0;
                          _pc.animateToPage(index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.bounceInOut);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.home),
                            Text("Home"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          index = 1;
                          _pc.animateToPage(index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.bounceInOut);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.search),
                            Text("Search"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          index = 3;
                          _pc.animateToPage(index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.bounceInOut);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.favorite),
                            Text("Favorite"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
