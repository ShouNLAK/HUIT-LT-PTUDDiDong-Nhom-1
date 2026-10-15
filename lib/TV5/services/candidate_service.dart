import 'package:file_picker/file_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await _notificationsPlugin.initialize(settings: initSettings);
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  static Future<void> showLocalNotification(String title, String body) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'job_channel_id',
        'Kênh thông báo tuyển dụng',
        importance: Importance.max,
        priority: Priority.high,
      );
      const platformDetails = NotificationDetails(android: androidDetails);
      await _notificationsPlugin.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (_) {}
  }

  static Future<String?> pickCvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.name;
    }
    return null;
  }
}