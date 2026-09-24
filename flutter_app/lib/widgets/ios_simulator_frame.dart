import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Wraps the application with an authentic iPhone 16 Pro frame
/// when running in iOS preview mode on desktop or web platforms.
class IosSimulatorFrame extends StatefulWidget {
  final Widget child;
  final bool isSimulated;
  final VoidCallback? onToggleMode;

  const IosSimulatorFrame({
    super.key,
    required this.child,
    this.isSimulated = true,
    this.onToggleMode,
  });

  @override
  State<IosSimulatorFrame> createState() => _IosSimulatorFrameState();
}

class _IosSimulatorFrameState extends State<IosSimulatorFrame> {
  bool _showFrame = true;

  @override
  Widget build(BuildContext context) {
    // On real iOS or Android devices, never render the outer simulator frame
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return widget.child;
    }

    if (!widget.isSimulated || !_showFrame) {
      return Stack(
        children: [
          widget.child,
          if (widget.isSimulated)
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: IconButton(
                    icon: const Icon(Icons.phone_iphone, color: Colors.white, size: 20),
                    tooltip: 'Mostra cornice iPhone',
                    onPressed: () => setState(() => _showFrame = true),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    final currentTimeStr = DateFormat('HH:mm').format(DateTime.now());

    // iPhone 16 Pro dimensions: 393 x 852 pt
    const double phoneWidth = 393.0;
    const double phoneHeight = 852.0;
    const double cornerRadius = 48.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      body: SafeArea(
        child: Column(
          children: [
            // Top iOS Simulator Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF2C2C2E), width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.apple, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Simulatore iOS (iPhone 16 Pro • iOS 18)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Toggle Fullscreen / Frame
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    icon: const Icon(Icons.fullscreen, size: 18),
                    label: const Text('Schermo intero', style: TextStyle(fontSize: 12)),
                    onPressed: () => setState(() => _showFrame = false),
                  ),
                ],
              ),
            ),

            // Centered iPhone frame area
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    width: phoneWidth,
                    height: phoneHeight,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(cornerRadius),
                      border: Border.all(
                        color: const Color(0xFF38383A),
                        width: 10.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 30,
                          spreadRadius: 8,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: const Color(0xFF2196F3).withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cornerRadius - 10),
                      child: Stack(
                        children: [
                          // App Content with iOS Safe Area padding
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 48, bottom: 20),
                              child: widget.child,
                            ),
                          ),

                          // iOS Status Bar
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Time (left)
                                  Text(
                                    currentTimeStr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  // Signal / Wifi / Battery (right)
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Icon(Icons.wifi, color: Colors.white, size: 14),
                                      SizedBox(width: 5),
                                      Icon(Icons.battery_full, color: Colors.white, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Dynamic Island (Centered Pill)
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 110,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF1E1E1E),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0C1021),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // iOS Home Indicator (Bottom Pill)
                          Positioned(
                            bottom: 6,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 135,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
