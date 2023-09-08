import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.KOTFOOTER)
class EKotFooter {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? fKotId;
  String kotFooterText = "";

  EKotFooter({
    this.id,
    this.fKotId = 0,
    this.kotFooterText = "",
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fKotId': fKotId,
    'kotFooterText': kotFooterText,
  };
}
