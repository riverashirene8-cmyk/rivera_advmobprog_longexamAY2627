import 'package:flutter/material.dart';
import 'package:rivera_mobprog/constants.dart';
import 'package:rivera_mobprog/screens/newsfeed_screen.dart';
import 'package:rivera_mobprog/screens/notification_screen.dart';
import 'package:rivera_mobprog/screens/profile_screen.dart';
import 'package:rivera_mobprog/widgets/custom_font.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String displayName; // ✅ logged-in / registered name
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ RECEIVE NAME FROM LOGIN / REGISTER
    displayName =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'Shirene Rivera';
  }

  void _onTappedBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  String _getAppBarTitle() {
    if (_selectedIndex == 0) return 'EduConnect';
    if (_selectedIndex == 1) return 'Notifications';
    return displayName; // ✅ Profile tab shows name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fbSecondary,

      // ✅ APP BAR (DYNAMIC TITLE)
      appBar: AppBar(
        backgroundColor: fbPrimary,
        title: CustomFont(
          text: _getAppBarTitle(),
          fontSize: 25,
          color: Colors.white,
          fontFamily: 'Klavika',
        ),
      ),

      // ✅ BODY WITH PAGEVIEW
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          const NewsFeedScreen(),
          const NotificationScreen(),

          // ✅ PASS NAME TO PROFILE
          ProfileScreen(displayName: displayName),
        ],
      ),

      // ✅ BOTTOM NAV BAR (UNCHANGED)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: fbPrimary,
        currentIndex: _selectedIndex,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
