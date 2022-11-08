import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/snackbars.dart";
import "../model/sign_in_listener.dart";
import "../model/auth.dart";
import "../view/sign_in.dart";

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
    challengeSnackBarAsync(state.context, UserAuth.signInWithGoogle);
  }

  Future signInWithGitHub() async {
    challengeSnackBarAsync(state.context, UserAuth.signInWithGitHub);
  }
}
