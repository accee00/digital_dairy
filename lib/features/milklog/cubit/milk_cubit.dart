import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'milk_state.dart';

class MilkCubit extends Cubit<MilkState> {
  MilkCubit() : super(MilkInitial());
}
