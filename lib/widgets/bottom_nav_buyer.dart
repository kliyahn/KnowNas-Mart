// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '/pages/buyer_dashboard.dart';
import '../pages/products_buyer.dart';
import '../pages/chat_buyer.dart';
import '../pages/settings_buyer.dart';
import '/pages/mypurchase.dart';

class BottomNavBarBuyer extends StatelessWidget {
  // Only keep the required index property
  final int currentIndex;
  const BottomNavBarBuyer({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    // Prevent navigation if already on the current page
    if (index == currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const BuyerDashboardPage();
        break;
      case 1:
        page = const ProductsBuyerPage();
        break;
      case 2:
        // Note: MyPurchasePage requires cartItems argument, mocking empty list for simple navigation
        page = const MyPurchasePage(cartItems: [],);
        break;
      case 3:
        page = const ChatBuyerPage(); 
        break;
      case 4:
        page = const SettingsBuyerPage();
        break;
      default:
        return;
    }

    // Using pushReplacement is correct for navigation bar tabs
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        // Using transitionDuration: Duration.zero is a good choice for fast, non-animated tab switches
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        // Changed color constant name to follow convention: const Color(0xFF3B5F3F)
        selectedItemColor: const Color(0xFF3B5F3F),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'My Purchase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}