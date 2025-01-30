import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_mvi_example/core/view_model_mixin.dart';
import 'package:signals_mvi_example/login/view_model/login_view_model.dart';
import 'package:signals_mvi_example/posts/data/posts_repository.dart';
import 'package:signals_mvi_example/posts/posts_screen.dart';
import 'package:signals_mvi_example/posts/view_model/posts_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.viewModel,
    super.key,
  });
  final LoginViewModel viewModel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with ViewModelMixin<LoginPage, LoginViewModel> {
  @override
  LoginViewModel provideViewModel() => widget.viewModel;

  @override
  void onEffect(LoginEffect effect) => switch (effect) {
        LoginSuccess() => _onLoginSuccess(),
        LoginError() => _onLoginError(),
      };

  void _onLoginSuccess() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PostsScreen(
          viewModel: PostsViewModel(
            postsRepository: PostsRepository(),
          ),
        ),
      ),
    );
  }

  void _onLoginError() {
    showDialog<void>(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Error, please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVI Example'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) => addEvent(EmailChanged(value)),
            ),
            Watch(
              (context) => Text('Email: ${viewModel.state.value.email}'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) => addEvent(PasswordChanged(value)),
            ),
            Watch(
              (context) => Text(
                'Password: ${viewModel.state.value.password}',
              ),
              debugLabel: 'Password',
            ),
            ElevatedButton(
              onPressed: () async {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                }

                addEvent(LoginRequested());
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
