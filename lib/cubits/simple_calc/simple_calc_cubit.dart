import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'simple_calc_state.dart';

class SimpleCalcCubit extends Cubit<SimpleCalcState> {
  SimpleCalcCubit() : super(SimpleCalcCalculated({}, 0, ''));

  List<num> validDenominations = [200, 50, 20, 10, 5, 2, 1, 0.5, 0.2];

  void calculateWithMod(double? cost, double? tender) {
  num totalChange = 0; // variable initialised because cant be null
  Map<String, num> breakdown = {};

    try {
      if (cost != null && tender != null){
        if((cost > 0) && (tender > 0) && (cost < tender)){
          totalChange = tender - cost;
          for (var i = 0; i < validDenominations.length; i++) {
            if(changeCount(validDenominations, totalChange)[i] != 0) { // to get rid of zero values
              breakdown[validDenominations[i].toString()] = changeCount(validDenominations, totalChange)[i];
            }
          }
          emit(SimpleCalcCalculated(breakdown, totalChange, ''));
        } else {throw('Insufficient Funds');}
      } else {throw('The rand note value is incorrect');}
    } catch (error) {
      // String errorMessage = 'The rand note value is incorrect';
      emit(SimpleCalcCalculated({}, 0,error.toString()));
      return;
    }

}

  void clearAll() {
    emit(SimpleCalcCalculated({}, 0, ''));
  }
  // helper functions
  changeCount(denominations, change) {
    var remainingCoins = change;
    var arrNotes = [];

    for (var i = 0; i < denominations.length; i++) {
      if (denominations[i] <= change) {
        arrNotes.add((remainingCoins / denominations[i]).toInt());
        remainingCoins = remainingCoins % denominations[i];
      } else {
        arrNotes.add(0);
      }
    }
    return arrNotes;
  }
}
