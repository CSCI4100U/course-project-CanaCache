class CannaScaffold extends StatefulWidget {
  final String? title;
  final GlobalKey<ScaffoldState> _scaffState = GlobalKey<ScaffoldState>();
  final Widget body;

  CannaScaffold({Key? key, this.title, required this.body}) : super(key: key);

  @override
  State<CannaScaffold> createState() => _CannaScaffoldState();
}
