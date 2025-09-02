import 'package:flutter/material.dart';

class AttendanceToggleButton extends StatefulWidget {
  final bool isCheckedIn;
  final Function(bool) onToggle;
  final Duration animationDuration;
  final double width;
  final double height;
  final Color checkedInColor;
  final Color checkedOutColor;
  final TextStyle? textStyle;
  final IconData? checkedInIcon;
  final IconData? checkedOutIcon;
   final bool? isLoading;

  const AttendanceToggleButton({
    Key? key,
    required this.isCheckedIn,
    required this.onToggle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.width = 200,
    this.height = 60,
    this.checkedInColor = Colors.green,
    this.checkedOutColor = Colors.red,
    this.textStyle,
    this.checkedInIcon = Icons.login,
    this.checkedOutIcon = Icons.logout,
    this.isLoading
  }) : super(key: key);

  @override
  State<AttendanceToggleButton> createState() => _AttendanceToggleButtonState();
}

class _AttendanceToggleButtonState extends State<AttendanceToggleButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.checkedOutColor,
      end: widget.checkedInColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Set initial state
    if (widget.isCheckedIn) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AttendanceToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCheckedIn != widget.isCheckedIn) {
      if (widget.isCheckedIn) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Scale animation for press feedback
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Toggle the state
    widget.onToggle(!widget.isCheckedIn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_animationController, _scaleController]),
        builder: (context, child) {
          final slideOffset = _slideAnimation.value * (widget.width - widget.height);
          
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: _colorAnimation.value,
                boxShadow: [
                  BoxShadow(
                    color: (_colorAnimation.value ?? Colors.grey).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Left side text (Check Out)
                  Positioned(
                    left: 60,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: widget.isCheckedIn ? 0.0 : 1.0,
                        duration: widget.animationDuration,
                        child: Row(
                          children: [
                            Icon(
                              widget.checkedOutIcon,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                             Text(
                              'تسجيل الانصراف',
                              style: widget.textStyle ?? const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Right side text (Check In)
                  Positioned(
                    right: 70,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: widget.isCheckedIn ? 1.0 : 0.0,
                        duration: widget.animationDuration,
                        child: Row(
                          children: [
                            Text(
                              'تسجيل الحضور',
                              style: widget.textStyle ?? const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              widget.checkedInIcon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Sliding thumb button
                  AnimatedPositioned(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    left: slideOffset + 4,
                    top: 4,
                    child: Container(
                      width: widget.height - 8,
                      height: widget.height - 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: widget.isLoading == true? CircularProgressIndicator() :  Icon(
                            widget.isCheckedIn ? Icons.person : Icons.person_outline,
                            key: ValueKey(widget.isCheckedIn),
                            color: _colorAnimation.value,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}