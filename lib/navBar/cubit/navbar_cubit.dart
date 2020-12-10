import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarState(index: 0));

  navigateTo(int index){
    emit(NavbarState(index :index));
  }
}
