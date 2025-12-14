import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:timezone/timezone.dart' as tz;
import 'storage_service.dart';

/// Service for managing notifications across platforms
class NotificationService {
  final FlutterLocalNotificationsPlugin _mobilePlugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification system
  Future<void> initialize() async {
    // Android & iOS initialization
    if (Platform.isAndroid || Platform.isIOS) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      
      await _mobilePlugin.initialize(initializationSettings);
    }
    // Desktop initialization is handled in main()
  }

  /// Schedule or cancel notifications based on enabled state
  Future<void> updateNotificationSchedule({
    required bool enabled,
    required String title,
    required String body,
  }) async {
    if (!enabled) {
      await cancelAll();
      return;
    }

    // Android: Schedule daily notification
    if (Platform.isAndroid) {
      await _mobilePlugin.zonedSchedule(
        0,
        title,
        body,
        _nextInstanceOf9AM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_budget_channel',
            'Daily Budget Notifications',
            channelDescription: 'Daily reminder of available budget',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Check and show desktop notification if needed (once per day)
  Future<void> checkAndShowDesktopNotification({
    required bool enabled,
    required String title,
    required String body,
  }) async {
    if (!enabled) return;
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) return;

    final lastShownStr = await StorageService.getLastNotificationDate();
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastShownStr != todayStr) {
      // Show notification
      final notification = LocalNotification(
        identifier: 'daily_budget_reminder',
        title: title,
        body: body,
      );
      
      await notification.show();
      
      // Save today as last shown
      await StorageService.setLastNotificationDate(todayStr);
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    if (Platform.isAndroid) {
      await _mobilePlugin.cancelAll();
    }
  }

  /// Get next instance of 9 AM
  tz.TZDateTime _nextInstanceOf9AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
