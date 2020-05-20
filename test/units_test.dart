import 'package:flutter_test/flutter_test.dart';
import 'package:onde_tem_saude_admin/validators/validators.dart';

void main() {
  group('LOGIN', () {
    test("Email vazio", () {
      var result = validatorEmail("");
      expect(result, "Informe o e-mail.");
    });

    test("Email inválido", () {
      var result = validatorEmail("teste");
      expect(result, "E-mail inválido!");
    });

    test("Senha vazia", () {
      var result = validatorSenha("");
      expect(result, "Informe a senha.");
    });

    test("Senha inválida", () {
      var result = validatorSenha("12345");
      expect(result, "Senha inválida!");
    });
  });

  group('UNIDADE DE SAÚDE', () {
    test("Título vazio", () {
      var result = validatorTitulo("");
      expect(result, "Título inválido!");
    });

    test("Telefone vazio", () {
      var result = validatorTelefone("");
      expect(result, "Telefone inválido!");
    });

    test("Endereço vazio", () {
      var result = validatorEndereco("");
      expect(result, "Endereço inválido!");
    });

    test("Cidade não selecionada", () {
      var result = validatorCidade("");
      expect(result, "Selecione a cidade!");
    });

    test("Bairro não selecionado", () {
      var result = validatorBairro("");
      expect(result, "Selecione o bairro!");
    });
  });

  group('USUARIO', () {
    test("Email vazio", () {
      var result = validatorEmail("");
      expect(result, "Informe o e-mail.");
    });
    test("Email inválido", () {
      var result = validatorEmail("teste");
      expect(result, "E-mail inválido!");
    });

    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });

    test("Telefone vazio", () {
      var result = validatorTelefone("");
      expect(result, "Telefone inválido!");
    });

    test("Endereço vazio", () {
      var result = validatorEndereco("");
      expect(result, "Endereço inválido!");
    });

    test("Cidade não selecionada", () {
      var result = validatorCidade("");
      expect(result, "Selecione a cidade!");
    });

    test("Bairro não selecionado", () {
      var result = validatorBairro("");
      expect(result, "Selecione o bairro!");
    });
  });

  group('ESPECIALIDADE', () {
    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });
  });

  group('SERVIÇO', () {
    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });
  });

  group('CIDADE', () {
    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });
  });

  group('BAIRRO', () {
    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });
  });
}
