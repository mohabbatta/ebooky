import 'package:ebooky2/bloc/signin_bloc.dart';
import 'package:ebooky2/common_widgets/form_raised_button.dart';
import 'package:ebooky2/model/email_signin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final EmailSignInBloc bloc = EmailSignInBloc();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  Future<void> _submit() async {
      await bloc.submit(context);
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoaded == false,
      ),
      onChanged: bloc.updatePassword,
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@email.com',
        errorText: model.emailErrorText,
        enabled: model.isLoaded == false,
      ),
      onChanged: bloc.updateEmail,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8),
      _buildPasswordTextField(model),
      SizedBox(height: 8),
      FormRaisedButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryButtonText,
      ),
      SizedBox(height: 8),
      FlatButton(
        onPressed: !model.isLoaded ? () => _toggleFormType() : null,
        child: Text(model.secondButtonText),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: StreamBuilder<EmailSignInModel>(
            stream: bloc.modelStream,
            initialData: EmailSignInModel(),
            builder: (context, snapshot) {
              final EmailSignInModel model = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('images/Book-lover-bro.png'),
                  ),
                  Text(
                    'eBooky',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildChildren(model),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
