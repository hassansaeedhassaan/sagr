import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationBarWidget extends StatefulWidget {
  final int initialActiveIndex;
  final Function(int)? onTabChanged;
  
  const NavigationBarWidget({
    Key? key,
    this.initialActiveIndex = 0,
    this.onTabChanged,
  }) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  late int activeIndex;

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.person_3_outlined,
      label: "الحضور والإنصراف",
      route: '/attendance_screen',
    ),
    NavigationItem(
      icon: Icons.phone_in_talk,
      label: "Walkie Talkie",
      route: '/walkie_talkie_screen',
    ),
    NavigationItem(
      icon: Icons.notifications,
      label: "التنبيهات",
      route: '/notifications_screen',
    ),
    NavigationItem(
      icon: Icons.chat,
      label: "الدردشة",
      route: '/chat_screen',
    ),
  ];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialActiveIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      activeIndex = index;
    });
    
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(index);
    }
    
    // Navigate to the corresponding route
    if (navigationItems[index].route != null) {
      Get.toNamed(navigationItems[index].route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          navigationItems.length,
          (index) => _buildNavigationItem(index),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(int index) {
    final item = navigationItems[index];
    final isActive = index == activeIndex;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isActive
                ? Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: isActive 
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  size: isActive ? 24 : 22,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isActive ? 11 : 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive 
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                ),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String? route;
  
  NavigationItem({
    required this.icon,
    required this.label,
    this.route,
  });
}

// Alternative version with floating design
class FloatingNavigationBarWidget extends StatefulWidget {
  final int initialActiveIndex;
  final Function(int)? onTabChanged;
  
  const FloatingNavigationBarWidget({
    Key? key,
    this.initialActiveIndex = 0,
    this.onTabChanged,
  }) : super(key: key);

  @override
  State<FloatingNavigationBarWidget> createState() => _FloatingNavigationBarWidgetState();
}

class _FloatingNavigationBarWidgetState extends State<FloatingNavigationBarWidget> {
  late int activeIndex;

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.person_3_outlined,
      label: "الحضور والإنصراف",
      route: '/attendance_screen',
    ),
    NavigationItem(
      icon: Icons.phone_in_talk,
      label: "Walkie Talkie",
      route: '/walkie_talkie_screen',
    ),
    NavigationItem(
      icon: Icons.notifications,
      label: "التنبيهات",
      route: '/notifications_screen',
    ),
    NavigationItem(
      icon: Icons.chat,
      label: "الدردشة",
      route: '/chat_screen',
    ),
  ];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialActiveIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      activeIndex = index;
    });
    
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(index);
    }
    
    if (navigationItems[index].route != null) {
      Get.toNamed(navigationItems[index].route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      margin: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          navigationItems.length,
          (index) => _buildFloatingNavigationItem(index),
        ),
      ),
    );
  }

  Widget _buildFloatingNavigationItem(int index) {
    final item = navigationItems[index];
    final isActive = index == activeIndex;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: Icon(
                  item.icon,
                  color: isActive 
                      ? Colors.white
                      : Colors.grey[600],
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: TextStyle(
                  fontSize: isActive ? 11 : 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive 
                      ? Colors.white
                      : Colors.grey[600],
                ),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}