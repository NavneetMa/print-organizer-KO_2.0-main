class ApiData {
  String apiName = "";
  dynamic data = "";

  ApiData({
    required this.apiName,
    required this.data,
  }) : super();

  Map<String, dynamic> toJson() => {'apiName': apiName, 'data': "$data"};

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
        apiName: json['apiName'].toString(),
        data: json['data'],
    );
  }
}
