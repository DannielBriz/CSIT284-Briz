import 'package:flutter/material.dart';
import 'assessment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF237A68);
  static const Color backgroundColor = Color(0xFFF5F8F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 40 : 22,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Campus Wellness Tracker',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF20332F),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Welcome section
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _buildWelcome()),
                            const SizedBox(width: 24),
                            Expanded(child: _buildIllustration()),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcome(),
                            const SizedBox(height: 16),
                            Center(child: _buildIllustration()),
                          ],
                        ),

                      const SizedBox(height: 28),

                      // Student information
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE2ECE8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  color: primaryColor,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Student Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF20332F),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _infoRow(
                              Icons.person_outline_rounded,
                              'Student Name',
                              'John Doe',
                            ),
                            const SizedBox(height: 14),
                            _infoRow(
                              Icons.menu_book_rounded,
                              'Course and Year',
                              'BSCS - 3',
                            ),
                            const SizedBox(height: 14),
                            _infoRow(
                              Icons.health_and_safety_outlined,
                              'Assessment',
                              'Daily Wellness Check',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Start button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AssessmentScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text(
                            'Start Assessment',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Small steps toward a healthier you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF71817B),
                            fontSize: 13,
                          ),
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
    );
  }

  Widget _buildWelcome() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your well-being matters.',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20332F),
          ),
        ),
        SizedBox(height: 14),
        Text(
          'Take a moment to check in with yourself. '
          'Answer a few simple questions about your daily habits, '
          'stress, sleep, and social connections.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xFF63746E),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Image.asset(
      'assets/images/undraw_meditation.png',
      height: 210,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 180,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F1EC),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.self_improvement_rounded,
            size: 90,
            color: primaryColor,
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF71817B),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF20332F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
