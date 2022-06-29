import 'package:appdiet/data/repository/account_repository.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit({required this.accountRepository})
      : super(DeleteAccountInitial());

  final AccountRepository accountRepository;
  Future<void> deleteAccount() async {
    try {
      final result = await accountRepository.deleteAccount();
      result ? emit(DeleteAccountSuccess()) : emit(DeleteAccountFail());
    } catch (e) {
      emit(DeleteAccountFail());
    }
  }
}
