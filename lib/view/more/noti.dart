import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hack/view/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool isNotificationScheduled = true;
  bool isUserScheduledEnabled = false;
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    _loadNotificationState();
    super.initState();
  }

  void _loadNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationScheduled =
          prefs.getBool('isNotificationScheduled') ?? true;
      isUserScheduledEnabled = prefs.getBool('isUserScheduledEnabled') ?? false;
      int savedHour = prefs.getInt('selectedHour') ?? 9;
      int savedMinute = prefs.getInt('selectedMinute') ?? 00;
      selectedTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    });

    if (isNotificationScheduled) {
      _scheduleDefaultNotifications();
    }

    if (isUserScheduledEnabled) {
      _scheduleUserNotifications();
    }
  }

  void _saveNotificationState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isNotificationScheduled', value);

    if (value) {
      _scheduleDefaultNotifications();
    } else {
      AwesomeNotifications().cancelAllSchedules();
    }
  }

  void _toggleUserScheduledNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserScheduledEnabled = value;
    });
    prefs.setBool('isUserScheduledEnabled', value);

    if (value) {
      _scheduleUserNotifications();
    } else {
      // Cancel user-scheduled notifications
      // Add your logic to cancel specific user-scheduled notifications
    }
  }

  void _scheduleDefaultNotifications() {
    _scheduleNotification(6, 0, 'Good Morning!', 'Have a great day!');
    _scheduleNotification(
        18, 0, 'Good Afternoon!', "it's your time for a meal");
  }

  void _scheduleUserNotifications() {
    _scheduleNotification(
      selectedTime.hour,
      selectedTime.minute,
      'Hungry? It\'s Zorko mealtime!',
      'Zorko delights await! Time to treat yourself with some mouthwatering cuisine. Enjoy!',
    );
  }

  void _scheduleNotification(int hour, int minute, String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: hour * 60 + minute,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('selectedHour', selectedTime.hour);
      prefs.setInt('selectedMinute', selectedTime.minute);

      if (isUserScheduledEnabled) {
        _scheduleUserNotifications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Push Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade900,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppColor.blueColor,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Switch(
                  value: isNotificationScheduled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationScheduled = value;
                      _saveNotificationState(value);
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.amber.shade900,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'U-Scheduled Notifications',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppColor.blueColor,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Switch(
                  value: isUserScheduledEnabled,
                  onChanged: (value) {
                    _toggleUserScheduledNotifications(value);
                  },
               activeColor: Colors.white,
                  activeTrackColor: Colors.amber.shade900,
                    ),
              ],
            ),
            if (isUserScheduledEnabled)
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Time',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: AppColor.blueColor,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      TextButton(
                        onPressed: () => _selectTime(context),
                        child: Text(
                          '${selectedTime.format(context)}',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColor.blueColor,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
