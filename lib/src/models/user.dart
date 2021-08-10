class User {
  int idPatient;
  String name;
  String lastName;
  String ci;
  String cellphone;
  String? birthday;
  String sex;
  String email;

  User({
    required this.idPatient,
    required this.name,
    required this.lastName,
    required this.ci,
    required this.cellphone,
    required this.birthday,
    required this.sex,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> json)
      : idPatient = json['id_patient'],
        name = json['name'],
        lastName = json['last_name'],
        ci = json['ci'],
        cellphone = json['cellphone'],
        sex = json['sex'],
        email = json['email']{
    birthday = '2020-08-07';
  }
}
