import 'package:appdiet/logic/cubits/navbar_cubit/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<NavbarCubit,NavbarState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex:
              context.select((NavbarCubit cubit) => cubit.state.index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.kitchen), label: "Cuisine"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes), label: "Objectifs"),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.orange[300],
          onTap: (index) => context.read<NavbarCubit>().navigateTo(index),
        );
      },
    );
  }
}
