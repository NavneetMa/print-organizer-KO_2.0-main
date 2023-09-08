import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.KOTHEADER)
class EKotHeader {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? fKotId;
  String kotHeaderText = "";
 
  EKotHeader({
    this.id,
    this.fKotId = 0,
    this.kotHeaderText = "",
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fKotId': fKotId,
    'kotHeaderText': kotHeaderText,
  };
}
