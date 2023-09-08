class Res {
  int code = 0;
  String message = "";
  String data = "";

  Res(this.code,this.message,this.data);

  Map<String, dynamic> toJson() => {'code': code, 'message': message, 'data':data};

  factory Res.fromJson(Map<String, dynamic> json) {
    return Res(int.parse(json['code'].toString()), json['message'].toString(), json['data'].toString());
  }
}