import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/my_list.dart';
import '../components/footer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const MyListPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: Text(
    _currentIndex == 0 ? 'Globoplay' : 'Minha Lista',
  ),
  centerTitle: _currentIndex == 0,
  backgroundColor: Colors.black,
  titleSpacing: _currentIndex == 0 ? 0 : 16.0,
  automaticallyImplyLeading: false,
),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
