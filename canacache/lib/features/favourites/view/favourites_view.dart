import "package:flutter/material.dart";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/auth/controller/sign_in_controller.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_signin_button/flutter_signin_button.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";

class FavouritesView extends StatelessWidget {
  final String? title;

  const FavouritesView({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      title: title,
      body: SingleChildScrollView(
        child: Text("eue"),
      ),
    );
  }
}
