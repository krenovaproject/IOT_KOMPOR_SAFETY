

class StoveRtdb {
  final String stoveName;
  final String serialNumber;
  final bool isRunningGUI;
  final String fcmToken;
  final String timeOff;
  final bool isRunningEsp;
  final double temperature;

  StoveRtdb(
      {required this.stoveName,
      required this.isRunningGUI,
      required this.timeOff,
      required this.temperature,
      required this.isRunningEsp,
      required this.serialNumber,
      required this.fcmToken});

  factory StoveRtdb.fromJson(Map<dynamic, dynamic> dataR) {
    return StoveRtdb(
        stoveName: dataR['stoveName'] ?? '',
        isRunningGUI: dataR['isRunningGUI'],
        timeOff: dataR['timeOff'] ?? '',
        isRunningEsp: dataR['isRunningEsp'] ,
        temperature: 0.0 + dataR['temperature'] ,
        serialNumber: dataR['serialNumber'] ?? '',
        fcmToken: dataR['fcmToken'] ?? '');
  }
}
