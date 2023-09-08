import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.PRINTER)
class EPrinter {

  @PrimaryKey(autoGenerate: true)
  int id;
  String name = "";
  String ipAddress = "";
  String port = "";
  String color = "";
  bool isSend = false;
  bool isRemove = false;

  EPrinter({
    this.id = 0,
    this.name = "",
    this.ipAddress = "",
    this.port = "",
    this.color = "",
    this.isSend = false,
    this.isRemove=false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ipAddress': ipAddress,
    'port': port,
    'color': color,
    'isSelected': isSend,
    'isRemove':isRemove
  };

}