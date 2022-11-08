import "package:flutter/widgets.dart";
import "package:canacache/theming/models/cana_palette_model.dart";

class CanaThemeProvider with ChangeNotifier {
  late CanaTheme _selectedTheme;

  CanaThemeProvider() {
    String savedTheme = "";
    if (!CanaPalette.isValidTheme(savedTheme)) {
      savedTheme = CanaPalette.defaultTheme;
      // Write default theme to db
    }
    _selectedTheme = CanaPalette.getCanaTheme(savedTheme);
  }

  set selectedTheme(CanaTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  CanaTheme get selectedTheme => _selectedTheme;
}
