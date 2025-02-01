import 'dart:math';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else if (valor == 'sin') {
        _resultado = sin(_parseInput() * pi / 180).toStringAsFixed(6);
      } else if (valor == 'cos') {
        _resultado = cos(_parseInput() * pi / 180).toStringAsFixed(6);
      } else if (valor == 'tan') {
        _resultado = tan(_parseInput() * pi / 180).toStringAsFixed(6);
      } else if (valor == 'log') {
        _resultado = log(_parseInput()).toStringAsFixed(6);
      } else if (valor == '!') {
        _resultado = calcularFatorial(_parseInput()).toString();
      } else {
        // Verifica se o último caractere é um operador
        if (_expressao.isNotEmpty && _ehOperador(_expressao[_expressao.length - 1]) && _ehOperador(valor)) {
          // Substitui o último operador pelo novo
          _expressao = _expressao.substring(0, _expressao.length - 1) + valor;
        } else {
          _expressao += valor;
        }
      }
    });
  }

  // Função para verificar se um caractere é um operador
  bool _ehOperador(String valor) {
    return valor == '+' || valor == '-' || valor == '*' || valor == '/' || valor == 'x' || valor == '÷';
  }

  double _parseInput() {
    return double.tryParse(_expressao) ?? 0;
  }

  // Função para validar a expressão
  bool _validarExpressao(String expressao) {
    // Verifica se há operadores inválidos seguidos (como */ ou +-)
    if (expressao.contains(RegExp(r'[\+\-\*/]{2,}'))) {
      return false;
    }
    // Verifica se a expressão termina com um operador
    if (expressao.endsWith('+') || expressao.endsWith('-') || expressao.endsWith('*') || expressao.endsWith('/')) {
      return false;
    }
    // Verifica se há operadores no início da expressão
    if (expressao.startsWith('+') || expressao.startsWith('-') || expressao.startsWith('*') || expressao.startsWith('/')) {
      return false;
    }
    // Verifica se há números e operadores misturados de forma inválida
    if (expressao.contains(RegExp(r'[0-9]+\s*[\+\-\/]\s[\+\-\*/]'))) {
      return false;
    }
    return true;
  }

  void _calcularResultado() {
    try {
      if (!_validarExpressao(_expressao)) {
        _resultado = 'Erro: Expressão inválida';
        return;
      }
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro';
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '').replaceAll('÷', '/').replaceAll('^', '*');
    try {
      ExpressionEvaluator avaliador = const ExpressionEvaluator();
      return avaliador.eval(Expression.parse(expressao), {});
    } catch (e) {
      return double.nan;
    }
  }

  double calcularFatorial(double num) {
    if (num < 0) return double.nan;
    if (num == 0 || num == 1) return 1;
    double resultado = 1;
    for (int i = 2; i <= num; i++) {
      resultado *= i;
    }
    return resultado;
  }

  Widget _botao(String valor, {double fontSize = 18}) {
    return Container(
      margin: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[100],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(50, 50),
        ),
        onPressed: () => _pressionarBotao(valor),
        child: Text(
          valor,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Text(
                  _expressao,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 4),
                Text(
                  _resultado,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                _botao('7'), _botao('8'), _botao('9'), _botao('÷'),
                _botao('4'), _botao('5'), _botao('6'), _botao('x'),
                _botao('1'), _botao('2'), _botao('3'), _botao('-'),
                _botao('0'), _botao('.'), _botao('='), _botao('+'),
                _botao('sin'), _botao('cos'), _botao('tan'), _botao('log'),
                _botao('^'), _botao('!'), _botao(_limpar, fontSize: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}