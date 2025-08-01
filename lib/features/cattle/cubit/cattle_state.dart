part of 'cattle_cubit.dart';

///
abstract class CattleState extends Equatable {
  ///
  const CattleState({required this.cattle});

  ///
  final List<Cattle> cattle;

  @override
  List<Object> get props => <Object>[cattle];
}

///
class CattleInitial extends CattleState {
  ///
  const CattleInitial() : super(cattle: const <Cattle>[]);
}

class CattleLoadingState extends CattleState {
  const CattleLoadingState({required super.cattle});
}

class CattleCreatedSuccess extends CattleState {
  const CattleCreatedSuccess({
    required super.cattle,
    required this.newlyCreatedCattle,
  });
  final Cattle newlyCreatedCattle;
}

class CattleCreatedFailure extends CattleState {
  const CattleCreatedFailure({required super.cattle, required this.msg});
  final String msg;
}

class CattleLoadedState extends CattleState {
  const CattleLoadedState({required super.cattle});
}

class CattleLoadedFailure extends CattleState {
  final String msg;

  const CattleLoadedFailure({required super.cattle, required this.msg});
}
