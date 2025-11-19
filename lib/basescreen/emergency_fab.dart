import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siren24/state/api_calling.dart';

class EmergencyFAB extends StatefulWidget {
  final VoidCallback? onEmergencyTap;

  const EmergencyFAB({
    Key? key,
    this.onEmergencyTap,
  }) : super(key: key);

  @override
  _EmergencyFABState createState() => _EmergencyFABState();
}

class _EmergencyFABState extends State<EmergencyFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleEmergencyPress() {
    HapticFeedback.heavyImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Show emergency options
    _showEmergencyOptions();
  }

  void _showEmergencyOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmergencyOptionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffEE2417),
                    Color(0xffFF4136),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffEE2417).withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _handleEmergencyPress,
                backgroundColor: Colors.transparent,
                elevation: 0,
                splashColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmergencyOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xffEE2417).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.emergency,
                        color: Color(0xffEE2417),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Get immediate help',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Emergency options
                _buildEmergencyOption(
                  context,
                  icon: Icons.local_hospital,
                  title: 'Book Emergency Ambulance',
                  subtitle: 'Immediate medical assistance',
                  color: Color(0xffEE2417),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to emergency booking
                  },
                ),

                SizedBox(height: 16),

                _buildEmergencyOption(
                  context,
                  icon: Icons.phone,
                  title: 'Call Emergency Hotline',
                  subtitle: '24/7 emergency support: 999',
                  color: Color(0xff4C6EE5),
                  onTap: () {
                    Navigator.pop(context);
                    ApiCaller().launchPhoneDialer('999');
                  },
                ),

                SizedBox(height: 16),

                _buildEmergencyOption(
                  context,
                  icon: Icons.support_agent,
                  title: 'Contact Support Center',
                  subtitle: 'Speak with our support team',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    ApiCaller().launchPhoneDialer('9718459379');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
