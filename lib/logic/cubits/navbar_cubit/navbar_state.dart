part of 'navbar_cubit.dart';

class NavbarState extends Equatable {
  const NavbarState({required this.index});

  final int index;
  @override
  List<Object> get props => [index];
}

