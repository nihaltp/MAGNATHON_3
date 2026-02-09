class UserModel {
  final String uid;
  final String email;
  final String name;
  final int score;
  final int highScore;
  final int remainingPoints;
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.score,
    required this.highScore,
    required this.remainingPoints,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      score: map['score'] ?? 0,
      highScore: map['highScore'] ?? 0,
      remainingPoints: map['remainingPoints'] ?? 100,
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'score': score,
      'highScore': highScore,
      'remainingPoints': remainingPoints,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    int? score,
    int? highScore,
    int? remainingPoints,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      remainingPoints: remainingPoints ?? this.remainingPoints,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
