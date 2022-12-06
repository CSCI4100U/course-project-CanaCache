import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/stats/model/stat_state.dart";
import "package:canacache/features/stats/view/common_charts.dart";

class CommonStatController
    extends Controller<LineChartTimeView, LineChartTimeViewState> {
  late StatStateModel _modelState;

  @override
  void initState() {
    super.initState();

    _modelState = StatStateModel(table: state.widget.table);
    _modelState.readDBData().then(
          (var res) => setState(
            (() {
              _modelState.plotInfo = FLChartReqInfo(
                rawData: res,
                state: dateState,
                table: state.widget.table,
              );
            }),
          ),
        );
  }

  void dateButtonController(int index) async {
    await _modelState.setDateState(index);
    var res = await _modelState.readDBData();

    setState(
      () {
        _modelState.plotInfo = FLChartReqInfo(
          rawData: res,
          state: dateState,
          table: state.widget.table,
        );
      },
    );
  }

  List<bool> get selections => _modelState.dateStateSelections;
  DateState get dateState => _modelState.dateState;
  FLChartReqInfo get plotInfo => _modelState.plotInfo;
}
