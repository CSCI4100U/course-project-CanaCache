import "package:flutter/material.dart";

/// MVC view class implemented as a subclass of State with an integrated Controller, accessible via the member variable `con`.
///
/// {@template canacache.mvc_example}
/// Example usage:
/// ```dart
/// // model
/// class FooModel {
///   int count = 0;
///
///   void increment() {
///     count++;
///   }
/// }
///
/// // view
/// // types are totally unchanged from vanilla StatefulWidget
/// class Foo extends StatefulWidget {
///   const Foo({super.key, required this.title, required this.setTitle});
///
///   // example of lifting state up
///   final String title;
///   final Function(String) setTitle;
///
///   @override
///   State<Foo> createState() => FooState();
/// }
///
/// // also view
/// // public, not private; extends ViewState, not State
/// class FooState extends ViewState<Foo, FooController> {
///   FooState() : super(FooController());
///
///   @override
///   Widget build(BuildContext context) {
///     return Center(
///       child: Column(
///         mainAxisAlignment: MainAxisAlignment.center,
///         children: [
///           // here we use data and methods from the controller
///           Text("${widget.title}: ${con.count}"),
///           IconButton(
///             onPressed: con.onPressedIncrement,
///             icon: const Icon(Icons.add),
///           ),
///           IconButton(
///             onPressed: con.onPressedSwap,
///             icon: const Icon(Icons.comment),
///           ),
///         ],
///       ),
///     );
///   }
/// }
///
/// // controller
/// class FooController extends Controller<Foo, FooState> {
///   final _model = FooModel();
///   int get count => _model.count;
///
///   void onPressedIncrement() {
///     // note that we're in the controller, but we can still do setState
///     setState(() {
///       _model.increment();
///     });
///   }
///
///   void onPressedSwap() {
///     // we have access to the state object as an instance variable
///     state.widget.setTitle(state.widget.title == "foo" ? "bar" : "foo");
///
///     // technically we have access to context
///     // but this would probably fit better as a method in the View that we call
///     ScaffoldMessenger.of(state.context).showSnackBar(const SnackBar(
///       content: Text("Changed the title"),
///     ));
///   }
/// }
/// ```
/// {@endtemplate}
abstract class ViewState<W extends StatefulWidget,
    C extends Controller<W, ViewState<W, C>>> extends State<W> {
  ViewState(this.con) {
    con.state = this;
  }

  @protected
  C con;

  @override
  @protected
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  @protected
  void initState() {
    super.initState();
    con.initState();
  }

  @override
  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    con.didChangeDependencies();
  }

  @override
  @protected
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    con.didUpdateWidget(oldWidget);
  }

  @override
  @protected
  void deactivate() {
    super.deactivate();
    con.deactivate();
  }

  @override
  @protected
  void dispose() {
    super.dispose();
    con.dispose();
  }
}

/// MVC controller class for implementing business logic for a view.
///
/// {@macro canacache.mvc_example}
abstract class Controller<W extends StatefulWidget,
    S extends ViewState<W, Controller<W, S>>> {
  @protected
  late final S state; // initialized by ViewState

  /// Allows calling setState from controllers.
  ///
  /// See also: [State.setState]
  @protected
  @mustCallSuper
  void setState(VoidCallback fn) => state.setState(fn);

  /// [State.initState]
  @protected
  @mustCallSuper
  void initState() {}

  /// [State.didChangeDependencies]
  @protected
  @mustCallSuper
  void didChangeDependencies() {}

  /// [State.didUpdateWidget]
  @protected
  @mustCallSuper
  void didUpdateWidget(W oldWidget) {}

  /// [State.deactivate]
  @protected
  @mustCallSuper
  void deactivate() {}

  /// [State.dispose]
  @protected
  @mustCallSuper
  void dispose() {}
}
