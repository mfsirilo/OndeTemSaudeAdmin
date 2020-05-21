String validatorEmail(text) {
  if (text.isEmpty) return "Informe o e-mail.";
  if (!text.contains("@") && !text.contains(".")) return "E-mail inválido!";
  return null;
}

String validatorSenha(text) {
  if (text.isEmpty) return "Informe a senha.";
  if (text.toString().length < 6) return "Senha inválida!";
  return null;
}

String validatorConfirmarSenha(senha, confSenha) {
  if (validatorSenha(senha) != null) return validatorSenha(senha);
  if (senha != confSenha) return "Confirmação de Senha Diferente da Senha!";
  return null;
}

String validatorNome(text) {
  if (text.isEmpty) return "Nome inválido!";
  return null;
}

String validatorTitulo(text) {
  if (text.isEmpty) return "Título inválido!";
  return null;
}

String validatorEndereco(text) {
  if (text.isEmpty) return "Endereço inválido!";
  return null;
}

String validatorTelefone(text) {
  if (text.isEmpty) return "Telefone inválido!";
  return null;
}

String validatorCidade(text) {
  if (text.isEmpty) return "Selecione a cidade!";
  return null;
}

String validatorBairro(text) {
  if (text.isEmpty) return "Selecione o bairro!";
  return null;
}
