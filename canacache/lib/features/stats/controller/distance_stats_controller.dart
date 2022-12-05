import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/stats/model/stat_state.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";
import "package:canacache/features/stats/view/common_charts.dart";

class DistanceStatController
    extends Controller<LineChartTimeView, LineChartTimeViewState> {
  late StatStateModel _modelState;
  final LocalDBTables table;

  DistanceStatController({required this.table}) {
    _modelState = StatStateModel(table: table);
  }

  @override
  void initState() {
    super.initState();
    _modelState.readDBData().then(
          (var res) => setState(
            (() {
              _modelState.plotInfo = FLChartReqInfo(
                rawData: res,
                state: dateState,
                table: table,
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
          table: table,
        );
      },
    );
  }

  get selections => _modelState.dateStateSelections;
  get dateState => _modelState.dateState;
  get plotInfo => _modelState.plotInfo;

  graphButtonController() {}
}
