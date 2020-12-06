import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.firstName,
    @required this.creatingAccount,
    @required this.uidDiet,
    @required this.linkStorageFolder,
    @required this.linkFoodPlan,
    @required this.birthDate
  }) : assert(email != null),
        assert(id != null),
        assert(creatingAccount != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  final String firstName;

  final bool creatingAccount;

  final String linkStorageFolder;

  final String linkFoodPlan;

  final String uidDiet;

  final String birthDate;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(email: '', id: '', name: '',firstName : '', creatingAccount: false, linkStorageFolder: null, linkFoodPlan: null, uidDiet: null, birthDate: null);

  @override
  List<Object> get props => [email, id, name,firstName, creatingAccount,linkFoodPlan,linkStorageFolder,uidDiet,birthDate];
}
