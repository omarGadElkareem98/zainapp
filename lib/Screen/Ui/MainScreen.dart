
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/BookingScreen.dart';
import 'package:panda_store/Screen/Ui/FavouriteScreen.dart';
import 'package:panda_store/Screen/Ui/HomeScreen.dart';
import 'package:panda_store/Screen/Ui/MoreScreen.dart';
import 'package:panda_store/Screen/Ui/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override

  int PageIndex = 4;

  List Screens = [
    MoreSscreen(),
    BookingScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    HomeScreen(),
  ];

  List items = [
    {
      'name':'More',
      'icon':Icon(Icons.more_horiz)
    },
    {
      'name':'Bookings',
      'icon':Icon(Icons.book_outlined)
    },
    {
      'name':'Favorites',
      'icon':Icon(Icons.favorite_outline)
    },
    {
      'name':'Profile',
      'icon':Icon(Icons.person_outline)
    },



  ];


  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            PageIndex = 4;
          });
        },
        backgroundColor: Colors.green,
        child: Text('Z',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: Colors.white54,

        activeIndex: PageIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => PageIndex = index), itemCount: items.length, tabBuilder: (int index, bool isActive) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              items[index]['icon'],
              Text(items[index]['name'])
            ],
          );
      },
        //other params
      ),
      body: Screens[PageIndex],
    );
  }
}
