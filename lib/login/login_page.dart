import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_mvi_example/core/view_model_mixin.dart';
import 'package:signals_mvi_example/login/view_model/login_view_model.dart';

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
  LoginViewModel createViewModel() => widget.viewModel;

  @override
  void onEffect(LoginEffect? effect) {
    if (effect == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    switch (effect) {
      case LoginSuccess():
        showDialog<void>(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Login success!'),
          ),
        );
      case LoginError():
        showDialog<void>(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Login error!'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
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
              onPressed: () => addEvent(LoginRequested()),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
