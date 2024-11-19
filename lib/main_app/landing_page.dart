import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/controller/cart_controller.dart';
import 'package:the_shawarma_hub/helper/location_helper.dart';
import 'package:the_shawarma_hub/main_app/cart.dart';
import 'package:the_shawarma_hub/main_app/home.dart';
import 'package:the_shawarma_hub/main_app/menu.dart';
import 'package:the_shawarma_hub/sidebar/navbar.dart';
import 'package:badges/badges.dart' as badges;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  final locationHelper = LocationHelper();
  final screens = [
    const Home(),
    const Menu(),
    const Cart(),
  ];
  Position? currentposition;
  final CartController cartController = Get.put(CartController());
  final RxInt cartItemCount = 0.obs;

  @override
  void initState() {
    super.initState();
    locationHelper.initLocation();
    //_loadCartItemCount();
  }

  @override
  Widget build(BuildContext context) {
    locationHelper.initLocation();
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          bottomOpacity: 0.2,
          elevation: 24,
          backgroundColor: const Color(0xFFF4F0F9),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Address',
                      style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      locationHelper.currentCity,
                      style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Get.to(() => ());
                },
              )
            ],
          ),
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          //type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFE23744),
          unselectedItemColor: const Color.fromARGB(255, 164, 163, 163),
          selectedFontSize: 16,
          unselectedFontSize: 12,
          elevation: 24,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                  color: _currentIndex == 0
                      ? const Color(0xFFE23744)
                      : Colors.grey,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book_rounded,
                  color: _currentIndex == 1
                      ? const Color(0xFFE23744)
                      : Colors.grey,
                ),
                label: 'Menu'),
            BottomNavigationBarItem(
              icon: Obx(() {
                // Wrap the badge with Obx for real-time updates
                return badges.Badge(
                  badgeContent: Text(
                    cartController.cartItemCount.value.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  showBadge: cartController.cartItemCount.value >
                      0, // Only show if count > 0
                  position: badges.BadgePosition.topEnd(top: -10, end: -12),
                  child: Icon(
                    Icons.shopping_cart,
                    color: _currentIndex == 2
                        ? const Color(0xFFE23744)
                        : Colors.grey,
                  ),
                );
              }),
              label: 'Cart',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
