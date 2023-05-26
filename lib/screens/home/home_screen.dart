import 'package:car_rent/providers/user_state.dart';
import 'package:car_rent/screens/cart_screen/cart_screen.dart';
import 'package:car_rent/screens/home_car/home_car.dart';
import 'package:car_rent/screens/profile/profile_screen.dart';
import 'package:car_rent/screens/welcome/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = const [
    HomeCarScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserState, bool>(
        builder: (ctx, value, child) {
          if (!value) {
            _currentIndex = 0;
          }
          return value == true
              ? Scaffold(
                  key: navigatorKey,
                  body: SafeArea(child: _children[_currentIndex]),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.car_crash_outlined),
                        label: 'Cart',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      )
                    ],
                    currentIndex: _currentIndex,
                    selectedItemColor: Colors.blueAccent,
                    unselectedItemColor: Colors.black,
                    onTap: onTabTapped,
                  ),
                )
              : const LoginScreen();
        },
        selector: (ctx, state) => state.isLogin);
  }
}
