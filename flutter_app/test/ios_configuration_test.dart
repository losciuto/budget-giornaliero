import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Configurazione iOS', () {
    test('include le descrizioni privacy per fotocamera e foto', () {
      final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();

      expect(infoPlist, contains('NSCameraUsageDescription'));
      expect(infoPlist, contains('NSPhotoLibraryUsageDescription'));
      expect(infoPlist, isNot(contains('UIBackgroundModes')));
      expect(infoPlist, isNot(contains('NSUserNotificationsUsageDescription')));
    });

    test('configura CocoaPods per ML Kit e notifiche', () {
      final podfile = File('ios/Podfile');
      expect(podfile.existsSync(), isTrue);

      final content = podfile.readAsStringSync();
      expect(content, contains("platform :ios, '15.5'"));
      expect(content, contains('flutter_install_all_ios_pods'));
      expect(content, contains('flutter_additional_ios_build_settings'));
      expect(content,
          contains("config.build_settings['EXCLUDED_ARCHS[sdk=*]'] = 'armv7'"));
    });

    test('configura il delegate delle notifiche e il target iOS', () {
      final appDelegate =
          File('ios/Runner/AppDelegate.swift').readAsStringSync();
      final project =
          File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();

      expect(
          appDelegate, contains('UNUserNotificationCenter.current().delegate'));
      expect(
        appDelegate,
        contains('FlutterLocalNotificationsPlugin.setPluginRegistrantCallback'),
      );
      expect(project, contains('IPHONEOS_DEPLOYMENT_TARGET = 15.5;'));
    });
  });
}
