class User {
  int id;
  String tokenType;
  int expiresIn;
  String token;

  User({
    this.id, this.tokenType, this.expiresIn, this.token
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      id: responseData['user_id'],
      tokenType: responseData['token_type'],
      expiresIn: responseData['expires_in'],
      token: responseData['token'],
    );
  }
}