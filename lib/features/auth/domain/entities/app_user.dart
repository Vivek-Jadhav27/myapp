import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? uid;
  final String? email;
  final String? name;

  const AppUser({this.uid, this.email, this.name});

  @override
  List<Object?> get props => [uid, email, name];
}
