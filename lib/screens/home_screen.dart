import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/screens/home_tab.dart';
import 'package:crypto_tracker/screens/portfolio_tab.dart';
import 'package:crypto_tracker/screens/asset_tab.dart';
import 'package:crypto_tracker/screens/profile_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  final _kTabPages = <Widget>[
    HomeTab(),
    PortfolioTab(),
    AssetTab(),
    ProfileTab(),
  ];

  final _kBottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.data_saver_off), label: 'Portfolio'),
    BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Prices'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: _currentTabIndex == 0
        //     ? null
        //     : AppBar(automaticallyImplyLeading: false, title: Text(_kBottomNavigationBarItems[_currentTabIndex].label)),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedFontSize: 14.0,
          selectedFontSize: 14.0,
          iconSize: 30.0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kLightGrayColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: _kBottomNavigationBarItems,
          currentIndex: _currentTabIndex,
          onTap: (int index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: _kTabPages[_currentTabIndex],
          ),
        ));
  }
}
