class SnoozeKot {
  String snoozeDateTime = "";
  String hashMD5 = "";

  SnoozeKot(this.snoozeDateTime,this.hashMD5);

  Map<String, dynamic> toJson() => {'snoozeDateTime': snoozeDateTime, 'hashMD5': hashMD5};

  factory SnoozeKot.fromJson(Map<String, dynamic> json) {
    return SnoozeKot(json['snoozeDateTime'].toString(), json['hashMD5'].toString());
  }
}