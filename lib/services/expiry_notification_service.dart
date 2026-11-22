import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ExpiryNotificationService {
  static final ExpiryNotificationService _instance =
  ExpiryNotificationService._internal();
  factory ExpiryNotificationService() => _instance;
  ExpiryNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Tunis'));

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    _initialized = true;
  }

  Future<void> scheduleExpiryAlerts({
    required String productId,
    required String productName,
    required DateTime expiryDate,
  }) async {
    await init();

    const offsets = [30, 7, 1];
    final expiryDay =
    DateTime(expiryDate.year, expiryDate.month, expiryDate.day, 9, 0);

    for (final daysBefore in offsets) {
      final alertDate = expiryDay.subtract(Duration(days: daysBefore));
      if (alertDate.isAfter(DateTime.now())) {
        final notifId = _buildNotificationId(productId, daysBefore);
        final tzDate = tz.TZDateTime.from(alertDate, tz.local);

        const androidDetails = AndroidNotificationDetails(
          'expiry_alerts_channel',
          'Alertes Péremption',
          channelDescription:
          'Notifications avant expiration des produits agricoles',
          importance: Importance.high,
          priority: Priority.high,
        );

        await _plugin.zonedSchedule(
          notifId,
          'Alerte expiration : $productName',
          daysBefore == 1
              ? '$productName expire demain !'
              : '$productName expire dans $daysBefore jours.',
          tzDate,
          const NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future<void> cancelExpiryAlerts(String productId) async {
    await init();
    for (final daysBefore in [30, 7, 1]) {
      await _plugin.cancel(_buildNotificationId(productId, daysBefore));
    }
  }

  int _buildNotificationId(String productId, int daysBefore) {
    return (productId.hashCode ^ daysBefore.hashCode) & 0x7fffffff;
  }
}