class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String passwordHash;
  final bool isVerified;
  final DateTime createdAt;
  final double walletBalance;
  final int couponsCount;
  final int cardsCount;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.passwordHash,
    this.isVerified = false,
    required this.createdAt,
    this.walletBalance = 0.0,
    this.couponsCount = 0,
    this.cardsCount = 0,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? passwordHash,
    bool? isVerified,
    DateTime? createdAt,
    double? walletBalance,
    int? couponsCount,
    int? cardsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      walletBalance: walletBalance ?? this.walletBalance,
      couponsCount: couponsCount ?? this.couponsCount,
      cardsCount: cardsCount ?? this.cardsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'passwordHash': passwordHash,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'walletBalance': walletBalance,
      'couponsCount': couponsCount,
      'cardsCount': cardsCount,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      passwordHash: json['passwordHash'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      couponsCount: json['couponsCount'] as int? ?? 0,
      cardsCount: json['cardsCount'] as int? ?? 0,
    );
  }
}
