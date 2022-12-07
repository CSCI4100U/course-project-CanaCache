import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/controller/modify_cache_controller.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";

class ModifyCacheArguments {
  LatLng? coordinates;
  Cache? cache;

  ModifyCacheArguments({this.coordinates, this.cache});
}

class ModifyCache extends StatefulWidget {
  const ModifyCache({
    super.key,
    required this.args,
  });

  final ModifyCacheArguments args;

  @override
  State<ModifyCache> createState() => ModifyCacheState();
}

class ModifyCacheState extends ViewState<ModifyCache, ModifyCacheController> {
  ModifyCacheState() : super(ModifyCacheController());

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

    return CanaScaffold(
      body: Form(
        key: con.formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.drive_file_rename_outline),
                labelText: translate("cache.edit.name"),
              ),
              initialValue: widget.args.cache?.name ?? "",
              onChanged: (value) => con.name = value,
            ),
            ElevatedButton(
              onPressed: con.saveCacheAndClose,
              child: Text(translate("edit_dialog.save")),
            ),
          ],
        ),
      ),
    );
  }
}
