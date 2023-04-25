import 'dart:convert';

class User {
  late String id;
  late String name;
  late String registrationNo;
  late String loginCode;
  bool isEditAllowed = false;
  bool isScoreboardAllowed = false;
  String? department;
  List<String> deptList = [];
  int eng = 0;
  int math = 0;
  int phy = 0;
  int geo = 0;
  int critical = 0;
  int psych = 0;

  User(userData) {
    id = userData['_id'];
    name = userData['name'];
    registrationNo = userData['registrationNo'];
    loginCode = userData['loginCode'];
    isEditAllowed = userData['control']['isEditAllowed'];
    deptList = new List<String>.from(userData['control']['deptList']);
    isScoreboardAllowed = userData['isScoreboardAllowed'];

    department = userData['department'];
    eng = userData['eng'];
    math = userData['math'];
    phy = userData['phy'];
    geo = userData['geo'];
    critical = userData['critical'];
    psych = userData['psych'];
  }

  // Add a converter to from an encoded JSON string
  static User fromJSONString(String jsonDataString) {
    Map<String, dynamic> jsonData = json.decode(jsonDataString);
    return User(jsonData);
  }

  // Add a converter to JSON
  Map<String, dynamic> toJSON() {
    return {
      "_id": id,
      "name": name,
      "registrationNo": registrationNo,
      "loginCode": loginCode,
      "isScoreboardAllowed": isScoreboardAllowed,
      "control": {
        "isEditAllowed": isEditAllowed,
        "deptList": deptList,
      },
      "department": department,
      "eng": eng,
      "math": math,
      "phy": phy,
      "geo": geo,
      "critical": critical,
      "psych": psych
    };
  }

  // Add a converter to JSON string
  String toJSONString() {
    return json.encode(toJSON());
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.toJSON().toString();
  }
}
