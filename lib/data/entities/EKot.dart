import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.KOT)
class EKot {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String? kot = "";
  int? kotDismissed = 0;
  String receivedTime = "";
  String fKotWithSeparator = "";
  String hashMD5 = "";
  bool isUndoKot = false;
  String snoozeDateTime = "";
  bool hideKot = false;
  int singleCategory = 1;
  bool tableNameMatch = false;
  bool inSum = false;

  EKot({
    this.id,
    this.kot = "",
    this.kotDismissed = 0,
    this.receivedTime = "",
    this.fKotWithSeparator = "",
    this.hashMD5 = "",
    this.isUndoKot = false,
    this.snoozeDateTime = "",
    this.hideKot = false,
    this.singleCategory = 1,
    this.inSum = false,
    this.tableNameMatch = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kot': kot,
        'kotDismissed': kotDismissed,
        'receivedTime': receivedTime,
        'fKotWithSeparator': fKotWithSeparator,
        'hashMD5': hashMD5,
        'isUndoKot': isUndoKot,
        'snoozeDateTime': snoozeDateTime,
        'hideKot': hideKot,
        'singleCategory': singleCategory,
        'inSum': false,
        'tableNameMatch': tableNameMatch
      };
}

