class User {

final String uid;

  User ({ this.uid });

}

class UserData {

  final String uid;
  final String name;
  final String surname;
  final String email;
  final String nickname;
  final bool  admin;

  UserData({ this.uid, this.name, this.surname, this.email, this.nickname, this.admin});

}