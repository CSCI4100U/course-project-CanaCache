import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/features/auth/model/auth.dart" as auth;
import "package:canacache/features/auth/model/sign_in_listener.dart";
import "package:canacache/features/auth/view/sign_in.dart";
import "package:canacache/features/firestore/model/collections/users.dart";

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
    await challengeSnackBarAsync(state.context, auth.signInWithGoogle);
    await Users().getCurrentUser(); // ensure the user object is created
  }

  Future signInWithGitHub() async {
    await challengeSnackBarAsync(state.context, auth.signInWithGitHub);
    await Users().getCurrentUser(); // ensure the user object is created
  }
}
