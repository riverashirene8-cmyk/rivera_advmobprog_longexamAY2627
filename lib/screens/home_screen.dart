import 'package:flutter/material.dart';
 
import '../constants.dart';
import '../services/storage_service.dart';
import '../widgets/custom_font.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NewsFeedScreenState> _newsFeedKey =
      GlobalKey<NewsFeedScreenState>();
 
  final PageController _pageController = PageController();
 
  int _selectedIndex = 0;
  String displayName = 'User 1';
  String username = 'user';
 
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
 
  Future<void> _loadUser() async {
    final user = await StorageService.getAuthUser();
 
    if (!mounted) return;
 
    setState(() {
      displayName = user?.fullName ?? 'User 1';
      username = user?.username ?? 'user';
    });
  }
 
  void _onTappedBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
 
    _pageController.jumpToPage(index);
  }
 
  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'EduConnect';
      case 1:
        return 'Notifications';
      case 2:
        return username.isNotEmpty
            ? '${username[0].toUpperCase()}${username.substring(1)}'
            : 'user';
      default:
        return 'EduConnect';
    }
  }
 
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fbSecondary,
 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: fbPrimary,
        foregroundColor: Colors.white,
        title: CustomFont(
          text: _getTitle(),
          fontSize: 25,
          color: Colors.white,
          fontFamily: 'Klavika',
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _newsFeedKey.currentState?.refreshFeed();
              },
            ),
 
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
 
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          NewsFeedScreen(key: _newsFeedKey),
          const NotificationScreen(),
          ProfileScreen(displayName: displayName),
        ],
      ),
 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTappedBar,
        backgroundColor: fbPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
 