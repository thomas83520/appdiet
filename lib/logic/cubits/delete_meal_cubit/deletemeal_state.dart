part of 'deletemeal_cubit.dart';

abstract class DeletemealState extends Equatable {
  const DeletemealState();

  @override
  List<Object> get props => [];
}

class DeletemealInitial extends DeletemealState {}

class DeletemealLoading extends DeletemealState {}

class DeletemealSucces extends DeletemealState {}

class DeletemealFailure extends DeletemealState {}
