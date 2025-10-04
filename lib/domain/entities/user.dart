import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, createdAt];
}
