// import 'package:apple_sign_in/apple_sign_in.dart';
// import 'package:apple_sign_in/apple_sign_in_button.dart' as applebutton;
// import 'package:dietapp/main.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:dietapp/login/login.dart';
// import 'package:dietapp/sign_up/sign_up.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:formz/formz.dart';
// import 'package:provider/provider.dart';

// class LoginForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final appleSignInAvailable =
//         //Provider.of<AppleSignInAvailable>(context, listen: false);

//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state.status.isSubmissionFailure) {
//           Scaffold.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               const SnackBar(content: Text('Authentication Failure')),
//             );
//         }
//       },
//       child: Align(
//         alignment: const Alignment(0, -2 / 3),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 'assets/splash.png',
//                 height: 120,
//               ),
//               Text(
//                 "Ma diet et moi",
//                 style: TextStyle(color: Colors.lightGreen, fontSize: 15.0),
//               ),
//               const SizedBox(height: 26.0),
//               Row(
//                 children: <Widget>[
//                   Text(
//                     "Se connecter",
//                     style: TextStyle(fontSize: 30.0),
//                     textAlign: TextAlign.left,
//                   ),
//                 ],
//               ),
//               Row(
//                 children: <Widget>[
//                   Text(
//                     "Heureux de vous revoir !",
//                     style: TextStyle(color: Colors.grey, fontSize: 14.0),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 30.0),
//               _EmailInput(),
//               const SizedBox(height: 8.0),
//               _PasswordInput(),
//               const SizedBox(height: 8.0),
//               _LoginButton(),
//               const SizedBox(height: 8.0),
//               _GoogleLoginButton(),
//               const SizedBox(height: 4.0),
//               //if (appleSignInAvailable.isAvailable) _AppleLoginButton(),
//               const SizedBox(height: 4.0),
//               _SignUpButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('loginForm_emailInput_textField'),
//           onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             labelText: 'email',
//             hintText: 'test',
//             errorText: state.email.invalid ? 'invalid email' : null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('loginForm_passwordInput_textField'),
//           onChanged: (password) =>
//               context.read<LoginCubit>().passwordChanged(password),
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'password',
//             helperText: '',
//             errorText: state.password.invalid ? 'invalid password' : null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         return state.status.isSubmissionInProgress
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 key: const Key('loginForm_continue_raisedButton'),
//                 child: const Text(
//                   'Se connecter',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                     primary: theme.primaryColor,
//                     onSurface: theme.accentColor,
//                     shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     elevation: 5),
//                 onPressed: state.status.isValidated
//                     ? () => context.read<LoginCubit>().logInWithCredentials()
//                     : null,
//               );
//       },
//     );
//   }
// }

// class _GoogleLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       key: const Key('loginForm_googleLogin_raisedButton'),
//       label: const Text(
//         'Se connecter avec Google',
//         style: TextStyle(color: Colors.black),
//       ),
//       style: ElevatedButton.styleFrom(
//         primary: Colors.white,
//         elevation: 1,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       ),
//       icon: const Icon(FontAwesomeIcons.google, color: Colors.black),
//       onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
//     );
//   }
// }

// /*class _AppleLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppleSignInButton(
//         // style as needed
//         style: applebutton.ButtonStyle.black,
//         type: ButtonType.signIn, // style as needed
//         onPressed: () => context.read<LoginCubit>().logInWithApple());
//   }
// }*/

// class _SignUpButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return FlatButton(
//       key: const Key('loginForm_createAccount_flatButton'),
//       child: Text(
//         'Créer un compte',
//         style: TextStyle(color: theme.primaryColor),
//       ),
//       onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
//     );
//   }
// }


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:appdiet/login/login.dart';
import 'package:appdiet/sign_up/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/splash.png',
                height: 120,
              ),
              const SizedBox(height: 16.0),
              _EmailInput(),
              const SizedBox(height: 8.0),
              _PasswordInput(),
              const SizedBox(height: 8.0),
              _LoginButton(),
              const SizedBox(height: 8.0),
              _GoogleLoginButton(),
              const SizedBox(height: 4.0),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('LOGIN'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: const Color(0xFFFFD600),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RaisedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      color: theme.accentColor,
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FlatButton(
      key: const Key('loginForm_createAccount_flatButton'),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
    );
  }
}
