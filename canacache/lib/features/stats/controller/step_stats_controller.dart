import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/stats/model/stat_state.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";

class StepStatController extends Controller<StepStatView, StepStatViewState> {
  final StatStateModel _modelState = StatStateModel(table: LocalDBTables.steps);

  @override
  void initState() {
    super.initState();
    _modelState.readDBData().then(
          (var res) => setState(
            (() {
              _modelState.plotInfo = FLChartReqInfo(
                rawData: res,
                state: dateState,
              );
            }),
          ),
        );
  }

  dateButtonController(int index) async {
    await _modelState.setDateState(index);
    var res = await _modelState.readDBData();

    setState(
      () {
        _modelState.plotInfo = FLChartReqInfo(
          rawData: res,
          state: dateState,
        );
      },
    );
  }

  get selections => _modelState.dateStateSelections;
  get dateState => _modelState.dateState;
  get plotInfo => _modelState.plotInfo;

  graphButtonController() {}
}
