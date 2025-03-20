import 'package:example/src/core/model/form/meta.dart';
import 'package:example/src/feature/register/logic/register_form_notifier.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Register')), body: const _Form());
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final RegisterFormNotifier formNotifier;

  @override
  void initState() {
    formNotifier = RegisterFormNotifier();

    formNotifier.addListener(_onFormChanged);
    super.initState();
  }

  void _onFormChanged() {
    setState(() {}); // Rebuild widget when state changes
  }

  @override
  void dispose() {
    formNotifier
      ..removeListener(_onFormChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          onChanged: formNotifier.setUsername,
          forceErrorText: formNotifier.username.errorMessage,
          enabled: formNotifier.username.status.isEnabled,
          decoration: InputDecoration(
            suffixIcon: formNotifier.username.status.isProcessing ? const _InputLoader() : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        TextFormField(
          onChanged: formNotifier.setPassword,
          forceErrorText: formNotifier.password.errorMessage,
          enabled: formNotifier.password.status.isEnabled,
        ),
        TextFormField(
          onChanged: formNotifier.setConfirmPassword,
          forceErrorText: formNotifier.confirmPassword.errorMessage,
          enabled: formNotifier.confirmPassword.status.isEnabled,
        ),
        OutlinedButton(
          onPressed: () async {
            final rv = await formNotifier.confirm();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(rv ? 'Success' : 'Error'),
                backgroundColor: rv ? Colors.green : Colors.red,
                duration: Durations.extralong4,
              ),
            );
          },
          child: const Text('Register'),
        ),
      ],
    ),
  );
}

class _InputLoader extends StatelessWidget {
  const _InputLoader();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeCap: StrokeCap.round));
}
