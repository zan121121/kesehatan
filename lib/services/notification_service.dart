import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  // ================= INIT =================
  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notif.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;

        if (payload != null) {
          final Uri url = Uri.parse(payload);
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
    );

    await Permission.notification.request();
  }

  // ================= CORE NOTIF =================
  static Future<void> showInstant({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notif.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          channelDescription: 'Notifikasi instan aplikasi',
          importance: Importance.max,
          priority: Priority.high,

          // 🔥 ICON APK KAMU (taruh di android/app/src/main/res/drawable)
          icon: 'hearts',
        ),
      ),
      payload: payload,
    );
  }

  // ================= DAILY NOTIF =================
  static Future<void> scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _notif.zonedSchedule(
      id,
      title,
      body,
      _nextInstance(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Notifikasi harian aplikasi',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ================= TIME =================
  static tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  // ================= DAILY REMINDER (3x sehari) =================
  static Future<void> setupDailyReminders() async {
    await scheduleDaily(
      id: 1,
      hour: 8,
      minute: 0,
      title: "🌤️ Pagi untuk kamu",
      body: "Jangan lupa sarapan ya. Hari ini kamu tetap berharga 💚",
    );

    await scheduleDaily(
      id: 2,
      hour: 12,
      minute: 0,
      title: "🍱 Waktu istirahat",
      body: "Saatnya makan siang dan tarik napas sebentar 💚",
    );

    await scheduleDaily(
      id: 3,
      hour: 19,
      minute: 0,
      title: "🌙 Malam untuk diri kamu",
      body: "Jangan lupa makan & istirahat. Kamu sudah cukup hari ini 💚",
    );
  }

  // ================= MOOD ALERT =================
  static Future<void> notifyMoodCritical() async {
    await showInstant(
      id: 100,
      title: "💚 Kami peduli dengan kamu",
      body:
          "Kondisi kamu sedang kurang stabil. Tidak apa-apa untuk istirahat atau mencari bantuan.",
    );
  }

  static Future<void> notifyMoodDeclining() async {
    await showInstant(
      id: 101,
      title: "🌿 Kami di sini untuk kamu",
      body:
          "Kamu terlihat lelah akhir-akhir ini. Istirahat sebentar ya 💚",
    );
  }

  static Future<void> notifySupport() async {
    await showInstant(
      id: 102,
      title: "💚 Kamu tidak sendiri",
      body:
          "Ambil waktu untuk dirimu. Kamu layak merasa lebih tenang.",
    );
  }

  // ================= PSIKOLOG + MAPS CLICK =================
  static Future<void> notifyPsychologistSuggestion() async {
    await showInstant(
      id: 103,
      title: "💚 Kami peduli dengan kamu",
      body:
          "Kalau terasa berat,\ncari bantuan itu oke."
"👉 Ketuk untuk bantuan",
payload: "https://www.google.com/maps/search/psikiater+terdekat",
    );
  }
}