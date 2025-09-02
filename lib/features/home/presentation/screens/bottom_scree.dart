import 'package:flutter/material.dart';

class ModernBottomNavigation extends StatefulWidget {
  @override
  _ModernBottomNavigationState createState() => _ModernBottomNavigationState();
}

class _ModernBottomNavigationState extends State<ModernBottomNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.search_rounded, label: 'Search'),
    NavItem(icon: Icons.favorite_rounded, label: 'Favorites'),
    NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Modern Navigation',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _buildPage(_selectedIndex),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          onPressed: () {
            // Handle center button action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Center action pressed!'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        height: 85,
        color: const Color.fromARGB(255, 7, 7, 7),
        elevation: 20,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side items
              for (int i = 0; i < 2; i++)
                Expanded(child: _buildNavItem(_navItems[i], i)),
              
              // Space for floating action button
              SizedBox(width: 60),
              
              // Right side items
              for (int i = 2; i < _navItems.length; i++)
                Expanded(child: _buildNavItem(_navItems[i], i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        height: 70,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isSelected 
                ? Color(0xFF667eea).withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? Color(0xFF667eea).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  item.icon,
                  color: isSelected 
                      ? Color(0xFF667eea)
                      : Colors.grey[600],
                  size: isSelected ? 24 : 22,
                ),
              ),
              SizedBox(height: 2),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isSelected 
                        ? Color(0xFF667eea)
                        : Colors.grey[600],
                    fontSize: isSelected ? 12.5 : 14,
                    fontWeight: isSelected 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                  ),
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      key: ValueKey(index),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF667eea).withOpacity(0.1),
              ),
              child: Icon(
                _navItems[index].icon,
                size: 60,
                color: Color(0xFF667eea),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _navItems[index].label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This is the ${_navItems[index].label.toLowerCase()} page',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}