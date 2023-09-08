import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';
@Entity(tableName: TableNames.FKOT)
class EFKot {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? kotId = 0;
  String? tableName = "";
  String? userName = "";
  double? total = 0;
  int? kotDismissed = 0;
  String? receivedTime = "";
  String? kitchenMessage = "";

  EFKot({
    this.id,
    this.kotId = 0,
    this.tableName = "",
    this.userName = "",
    this.total = 0,
    this.kotDismissed = 0,
    this.receivedTime = "",
    this.kitchenMessage = "",
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'kotId': kotId,
    'tableName': tableName,
    'userName': userName,
    'total': total,
    'kotDismissed': kotDismissed,
    'receivedTime': receivedTime,
    'kitchenMessage': kitchenMessage,
  };
}
