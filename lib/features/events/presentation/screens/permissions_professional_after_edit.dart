import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  ScrollController? _scrollController;
  
  // For infinite scroll
  List<EventItem> events = [];
  bool _isLoading = false;
  bool _hasMore = true;
  
  // Sample event templates for infinite generation
  final List<Map<String, dynamic>> _eventTemplates = [
    {
      'icon': Icons.business_center,
      'type': 'Conference',
      'eventNames': ['Tech Innovation Summit', 'Digital Transformation Conference', 'Future of Work Summit', 'AI Leadership Conference'],
      'zones': ['Main Hall A', 'Auditorium B', 'Convention Center', 'Grand Hall'],
    },
    {
      'icon': Icons.school,
      'type': 'Workshop',
      'eventNames': ['Flutter Development Masterclass', 'React Native Workshop', 'UI/UX Design Workshop', 'Cloud Computing Basics'],
      'zones': ['Training Room B', 'Lab Room A', 'Workshop Hall', 'Learning Center'],
    },
    {
      'icon': Icons.mic,
      'type': 'Seminar',
      'eventNames': ['Digital Marketing Strategy', 'Social Media Trends', 'Content Creation Mastery', 'SEO Best Practices'],
      'zones': ['Conference Room C', 'Meeting Room A', 'Presentation Hall', 'Seminar Room'],
    },
    {
      'icon': Icons.people,
      'type': 'Networking',
      'eventNames': ['Industry Connect Meetup', 'Startup Networking', 'Professional Mixer', 'Tech Community Gathering'],
      'zones': ['Lobby Area', 'Networking Lounge', 'Social Hall', 'Reception Area'],
    },
    {
      'icon': Icons.computer,
      'type': 'Hackathon',
      'eventNames': ['AI Innovation Challenge', 'Mobile App Hackathon', 'Web Development Sprint', 'IoT Innovation Lab'],
      'zones': ['Lab Complex', 'Development Center', 'Innovation Hub', 'Tech Lab'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _controller?.forward();
    
    // Load initial events
    _loadMoreEvents();
  }

  void _scrollListener() {
    if (_scrollController!.position.pixels == _scrollController!.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  Future<void> _loadMoreEvents() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newEvents = _generateEvents(20); // Generate 20 more events
    
    setState(() {
      events.addAll(newEvents);
      _isLoading = false;
      // For demo purposes, we'll allow infinite scroll
      // In real app, you might set _hasMore = false when no more data
    });
  }

  List<EventItem> _generateEvents(int count) {
    final List<EventItem> newEvents = [];
    final List<String> statuses = ['Active', 'Upcoming', 'Completed'];
    final List<String> times = ['09:00 AM', '10:30 AM', '02:00 PM', '03:30 PM', '06:00 PM'];
    final List<String> durations = ['1 hour', '1.5 hours', '2 hours', '3 hours', '4 hours', '8 hours'];
    
    for (int i = 0; i < count; i++) {
      final template = _eventTemplates[i % _eventTemplates.length];
      final eventNames = template['eventNames'] as List<String>;
      final zones = template['zones'] as List<String>;
      
      newEvents.add(EventItem(
        icon: template['icon'] as IconData,
        type: template['type'] as String,
        duration: durations[i % durations.length],
        time: times[i % times.length],
        eventName: eventNames[i % eventNames.length],
        zoneName: zones[i % zones.length],
        status: statuses[i % statuses.length],
      ));
    }
    
    return newEvents;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          _buildEventList(),
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 170,
      floating: true,
      pinned: false,
      elevation: 0,
      primary: true,
      backgroundColor: const Color(0xFF1E293B),
      // This title will show when collapsed
      // title: Row(
      //   children: [
      //     Container(
      //       width: 32,
      //       height: 32,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(16),
      //         color: const Color(0xFF3B82F6),
      //       ),
      //       child: const Icon(
      //         Icons.person,
      //         color: Colors.white,
      //         size: 18,
      //       ),
      //     ),
      //     const SizedBox(width: 12),
      //     const Text(
      //       'Ahmed Mohamed',
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 18,
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //   ],
      // ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E293B),
                Color(0xFF334155),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(60, 45, 0, 40),
            child: _fadeAnimation != null && _slideAnimation != null
                ? FadeTransition(
                    opacity: _fadeAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Hero(
                                tag: 'user_avatar',
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(0xFF64748B),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Container(
                                      color: const Color(0xFF3B82F6),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ahmed Mohamed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Active',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(Icons.badge, 'ID: 123456789'),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.phone, '+20 123 456 7890'),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF64748B),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= events.length) return null;
            
            return _controller != null
                ? AnimatedBuilder(
                    animation: _controller!,
                    builder: (context, child) {
                      final delay = (index % 10) * 0.1; // Reset animation delay every 10 items
                      final animationValue = Curves.easeOutCubic.transform(
                        (_controller!.value - delay).clamp(0.0, 1.0),
                      );

                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - animationValue)),
                        child: Opacity(
                          opacity: animationValue,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildEventCard(events[index]),
                          ),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEventCard(events[index]),
                  );
          },
          childCount: events.length,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(EventItem event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle card tap
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getIconColor(event.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        event.icon,
                        color: _getIconColor(event.status),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.eventName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.zoneName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(event.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.category_outlined,
                      event.type,
                      const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.schedule,
                      event.time,
                      const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.timer_outlined,
                      event.duration,
                      const Color(0xFF06B6D4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Active':
        color = const Color(0xFF10B981);
        break;
      case 'Upcoming':
        color = const Color(0xFFF59E0B);
        break;
      case 'Completed':
        color = const Color(0xFF64748B);
        break;
      default:
        color = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Upcoming':
        return const Color(0xFFF59E0B);
      case 'Completed':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF64748B);
    }
  }
}

class EventItem {
  final IconData icon;
  final String type;
  final String duration;
  final String time;
  final String eventName;
  final String zoneName;
  final String status;

  EventItem({
    required this.icon,
    required this.type,
    required this.duration,
    required this.time,
    required this.eventName,
    required this.zoneName,
    required this.status,
  });
}