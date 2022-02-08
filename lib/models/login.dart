class Login{
  String password;
  String email;
  String pseudo;
  String urlPhoto;

  Login({
    this.password = '',
    this.email = '',
    this.pseudo = '',
    this.urlPhoto = '',
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      password: json['password'],
      email: json['email'],
      pseudo: json['pseudo'],
      urlPhoto: json['urlPhoto'],
    );
  }

  @override
  String toString() {
    return 'email: ' + email + ' | password: ' + password;
  }
}