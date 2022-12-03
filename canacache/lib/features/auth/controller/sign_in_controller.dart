import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/features/auth/model/auth.dart" as auth;
import "package:canacache/features/auth/model/sign_in_listener.dart";
import "package:canacache/features/auth/view/sign_in.dart";

class SignInFormController extends Controller<SignInForm, SignInFormState> {
  final _listener = SignInListener();

  @override
  void initState() {
    super.initState();
    _listener.listen(state.onSuccessfulSignIn);
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  Future signInWithGoogle() async {
    challengeSnackBarAsync(state.context, auth.signInWithGoogle);
  }

  Future signInWithGitHub() async {
    challengeSnackBarAsync(state.context, auth.signInWithGitHub);
  }
}
