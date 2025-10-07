import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _cardController;
  late AnimationController _buttonController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _buttonBounceAnimation;
  
  bool _isAccepted = false;
  bool _isRejected = false;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _cardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));
    
    _buttonBounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));
    
    _mainController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _cardController.forward();
    });
  }

    EventController _eventController = Get.put(EventController(Get.find()));


  @override
  void dispose() {
    _mainController.dispose();
    _cardController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
  
  void _handleButtonPress(bool isAccept) async {
    HapticFeedback.lightImpact();
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });
    
    setState(() {
      if (isAccept) {
        _isAccepted = true;
        _isRejected = false;
      } else {
        _isRejected = true;
        _isAccepted = false;
      }
    });
    
    // Show success animation
    await Future.delayed(const Duration(milliseconds: 500));
    _showStatusDialog(isAccept);
  }
  
  void _showStatusDialog(bool isAccept) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isAccept ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isAccept ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  isAccept ? "تم القبول بنجاح!" : "تم الرفض",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isAccept 
                    ? "سيتم التواصل معك قريباً"
                    : "يمكنك البحث عن فرص أخرى",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAccept ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "موافق",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background Gradient
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade50.withOpacity(_fadeAnimation.value),
                      Colors.white,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Header Section
                _buildHeroHeader(),
                
                // Content Card
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildContentCard(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Floating Action Elements
          _buildFloatingElements(),
        ],
      ),
    );
  }
  
  Widget _buildHeroHeader() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Background Image with Parallax Effect
          Container(
            height: 260,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/cover.jpg",
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Back Button with Glass Effect
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          
          // Floating Title Card
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: AnimatedBuilder(
              animation: _cardScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _cardScaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "القبول المبدئي",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.work_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContentCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Details Section
          _buildDetailsSection(),
          
          const SizedBox(height: 30),
          
          // Contract Terms Button
          _buildContractButton(),
          
          const SizedBox(height: 30),
          
          // Action Buttons
          _buildActionButtons(),
          
          const SizedBox(height: 30),
          
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }
  
  Widget _buildDetailsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [


// Text("https://crowds.sa/${_eventController.event!.attachment!}"),






          _buildDetailRow(
            Icons.calendar_today,
            "تاريخ مباشرة العمل",
            "22/03/2025",
            Colors.blue,
          ),
          const SizedBox(height: 25),
          _buildDetailRow(
            Icons.access_time,
            "ساعات العمل",
            "08:00 AM - 05:00 PM",
            Colors.orange,
          ),
          const SizedBox(height: 25),
          _buildDetailRow(
            Icons.account_balance_wallet,
            "المبلغ المقدم",
            "500 ريال",
            Colors.green,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String title, String value, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - animationValue), 0),
          child: Opacity(
            opacity: animationValue,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildContractButton() {
    return GestureDetector(
      onTap: () => _showContractTerms(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.blue.shade700],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              "شروط العقد",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _buttonBounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isAccepted ? _buttonBounceAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: () => _handleButtonPress(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: _isAccepted
                            ? LinearGradient(
                                colors: [Colors.green.shade400, Colors.green.shade600],
                              )
                            : null,
                        color: _isAccepted ? null : Colors.white,
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _isAccepted
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isAccepted)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                          if (_isAccepted) const SizedBox(width: 8),
                          Text(
                            _isAccepted ? "تم القبول" : "أوافق",
                            style: TextStyle(
                              color: _isAccepted ? Colors.white : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: AnimatedBuilder(
              animation: _buttonBounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isRejected ? _buttonBounceAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: () => _handleButtonPress(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: _isRejected
                            ? LinearGradient(
                                colors: [Colors.red.shade400, Colors.red.shade600],
                              )
                            : null,
                        color: _isRejected ? null : Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _isRejected
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isRejected)
                            const Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 20,
                            ),
                          if (_isRejected) const SizedBox(width: 8),
                          Text(
                            _isRejected ? "تم الرفض" : "أرفض",
                            style: TextStyle(
                              color: _isRejected ? Colors.white : Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.list, "القائمة", false),
          _buildNavItem(Icons.campaign, "الإعلانات", false),
          _buildNavItem(Icons.celebration_outlined, "", true),
          _buildNavItem(Icons.notifications, "التنبيهات", false),
          _buildNavItem(Icons.chat, "الدردشة", false),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, bool isCenter) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isCenter ? 15 : 8),
          decoration: BoxDecoration(
            color: isCenter ? Colors.indigo.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(isCenter ? 25 : 12),
            boxShadow: isCenter
                ? [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isCenter ? Colors.white : Colors.grey.shade600,
            size: isCenter ? 24 : 20,
          ),
        ),
        if (!isCenter) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildFloatingElements() {
    return Positioned(
      top: 120,
      right: 20,
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(30 * (1 - _fadeAnimation.value), 0),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.bookmark_outline,
                  color: Colors.indigo.shade600,
                  size: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _showContractTerms() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.description,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "شروط العقد",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

              SizedBox(
                height: 600,
                child: SfPdfViewer.network(
                  "https://crowds.sa/${_eventController.event!.attachment!}"
                ),
              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContractSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, left: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}