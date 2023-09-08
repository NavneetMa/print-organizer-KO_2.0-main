class MT {

  int? id = 0;
  String receivedTime = "";
  String currentTime = "";
  String finishedTime = "";
  String kotLiveDuration = "";
  String tableName = "";
  String userName = "";
  int numOfItems = 0;
  String poIp = "";
  String mtIp = "";
  String category = "";

  MT({this.id = 0, this.receivedTime = "", this.currentTime = "", this.finishedTime = "", this.kotLiveDuration = "", this.tableName = "", this.userName = "", this.numOfItems = 0, this.category= "", this.poIp= "", this.mtIp = ""}) : super();

  Map<String, dynamic> toJson() => {
    'id': id,
    'receivedTime': receivedTime,
    'currentTime': currentTime,
    'finishedTime': finishedTime,
    'kotLiveDuration': kotLiveDuration,
    'tableName': tableName,
    'userName': userName,
    'numOfItems': numOfItems,
    'category': category,
    'poIp': poIp,
    'mtIp': mtIp,
  };

  factory MT.fromJson(Map<String, dynamic> json) {
    return MT(
      id: json['id'] as int,
      receivedTime: json['receivedTime'].toString(),
      currentTime: json['currentTime'].toString(),
      finishedTime: json['finishedTime'].toString(),
      kotLiveDuration: json['kotLiveDuration'].toString(),
      tableName: json['tableName'].toString(),
      userName: json['userName'].toString(),
      numOfItems: json['numOfItems'] as int,
      category: json['category'].toString(),
      poIp: json['poIp'].toString(),
      mtIp: json['mtIp'].toString(),
    );
  }
}