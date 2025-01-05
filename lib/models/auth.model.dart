class Auth {
  String email;
  String token;

  Auth({required this.email, required this.token});

  factory Auth.destroy() {
    return Auth(
      email: "",
      token: "",
    );
  }
}