import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/model/collections/user_items.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class UserItemsListPage extends StatelessWidget {
  const UserItemsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = settings.theme;
    final locale = settings.language;

    return CanaScaffold(
      title: translate("profile.items.title"),
      body: CanaStreamBuilder(
        stream: UserItems.forCurrentUser().streamObjects(),
        builder: (context, data) => DataTable(
          columns: [
            DataColumn(
              label: Text(
                translate("profile.items.name"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.primaryTextColor),
              ),
            ),
            DataColumn(
              label: Text(
                translate("profile.items.date"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.primaryTextColor),
              ),
            ),
          ],
          rows: data
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.name,
                        style: TextStyle(color: theme.primaryTextColor),
                      ),
                    ),
                    DataCell(
                      Text(
                        DateFormat.yMd(locale.languageCode).format(
                          item.addedAt.toDate(),
                        ),
                        style: TextStyle(color: theme.primaryTextColor),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
