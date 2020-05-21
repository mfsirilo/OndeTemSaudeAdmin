import 'dart:async';

import 'package:onde_tem_saude_admin/validators/validators.dart';

class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (validatorEmail(email) == null) {
      sink.add(email);
    } else {
      sink.addError("Insira um e-mail válido!");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (validatorSenha(password) == null) {
      sink.add(password);
    } else {
      sink.addError("Senha inválida, deve conter pelo menos 6 caracteres!");
    }
  });
}
