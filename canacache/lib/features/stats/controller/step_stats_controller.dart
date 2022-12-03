import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";

enum DateState { day, week, month, year }

class StepStatController extends Controller<StepStatView, StepStatViewState> {
  List<bool> selections = List.generate(4, (_) => false);
  int selectedIndex = 0;

  @override
  initState() {
    super.initState();
    selections[selectedIndex] = true;
  }

  dateButtonController(int index) {
    selections = List.generate(4, (_) => false);
    selectedIndex = index;

    setState(
      () {
        selections[selectedIndex] = true;
      },
    );
  }
}
