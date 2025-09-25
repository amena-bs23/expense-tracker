import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/go_router_extension.dart';
import '../../../../core/base/status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/link_text.dart';
import '../riverpod/registration_provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.locale.signUp)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const FlutterLogo(size: 100),
              const SizedBox(height: 80),
              TextFormField(
                controller: _firstName,
                decoration: InputDecoration(hintText: context.locale.firstName),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'This field is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastName,
                decoration: InputDecoration(hintText: context.locale.lastName),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'This field is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(hintText: context.locale.email),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'This field is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(hintText: context.locale.password),
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'This field is required'
                    : null,
              ),
              const SizedBox(height: 32),
              Consumer(builder: (context, ref, _) {
                ref.listen(registrationProvider, (prev, next) {
                  if (next.status.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Success')),
                    );
                    context.pushNamedAndRemoveUntil(Routes.login);
                  }
                  if (next.status.isError && next.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(next.error!)),
                    );
                  }
                });

                final state = ref.watch(registrationProvider);
                final loading = state.status.isLoading;
                return FilledButton(
                  onPressed: loading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.read(registrationProvider.notifier).register(
                                  firstName: _firstName.text,
                                  lastName: _lastName.text,
                                  email: _email.text,
                                  password: _password.text,
                                );
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.locale.continueAction),
                );
              }),
              LinkText(
                text: context.locale.alreadyHaveAccount,
                linkText: context.locale.signIn,
                onTap: () {
                  context.pushNamedAndRemoveUntil(Routes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
