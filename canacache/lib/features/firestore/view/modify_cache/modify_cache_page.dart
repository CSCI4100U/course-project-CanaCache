import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/controller/modify_cache_controller.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:latlong2/latlong.dart";

class CreateCacheArguments {
  LatLng? coordinates;
  Cache? cache;

  CreateCacheArguments({this.coordinates, this.cache});
}

class CreateCache extends StatefulWidget {
  const CreateCache({
    super.key,
    required this.args,
  });

  final CreateCacheArguments args;

  @override
  State<CreateCache> createState() => CreateCacheState();
}

class CreateCacheState extends ViewState<CreateCache, CreateCacheController> {
  CreateCacheState() : super(CreateCacheController());

  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      body: Form(
        key: con.formKey,
        child: Column(
          children: [
            // TODO: refactor and localize
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.drive_file_rename_outline),
                labelText: translate("cache.edit.name"),
              ),
              initialValue: widget.args.cache?.name ?? "",
              onChanged: (value) => con.name = value,
            ),
            // TODO: center this
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
