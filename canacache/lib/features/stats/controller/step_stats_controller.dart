import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/stats/model/stat_state.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";

class StepStatController extends Controller<StepStatView, StepStatViewState> {
  final StatStateModel _modelState = StatStateModel(table: LocalDBTables.steps);

  dateButtonController(int index) {
    setState(
      () => _modelState.setDateState(index),
    );
  }

  get selections => _modelState.dateStateSelections;

  graphButtonController() {}
}
