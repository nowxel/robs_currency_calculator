class RequestError {

  RequestError({this.code, this.type, this.info});

  RequestError.fromJson(Map<String, dynamic> json) {
    code = json['code'] as int;
    type = json['type'] as String;
    info = json['info'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['type'] = type;
    data['info'] = info;
    return data;
  }

  int code;
  String type;
  String info;

}