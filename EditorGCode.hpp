#pragma once

#include <QObject>
#include <QSettings>

class EditorGCode : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString caminhoArquivo READ caminhoArquivo WRITE defineCaminhoArquivo NOTIFY caminhoArquivoMudou)
    Q_PROPERTY(int minimoEntrada READ minimoEntrada WRITE defineMinimoEntrada NOTIFY minimoEntradaMudou)
    Q_PROPERTY(int maximoEntrada READ maximoEntrada WRITE defineMaximoEntrada NOTIFY maximoEntradaMudou)
    Q_PROPERTY(int minimoSaida READ minimoSaida WRITE defineMinimoSaida NOTIFY minimoSaidaMudou)
    Q_PROPERTY(int maximoSaida READ maximoSaida WRITE defineMaximoSaida NOTIFY maximoSaidaMudou)
    Q_PROPERTY(QString cabecalho READ cabecalho WRITE defineCabecalho NOTIFY cabecalhoMudou)
    Q_PROPERTY(QString rodape READ rodape WRITE defineRodape NOTIFY rodapeMudou)
    Q_PROPERTY(bool substituirG0 READ substituirG0 WRITE defineSubstituirG0 NOTIFY substituirG0Mudou)
    Q_PROPERTY(bool substituirM5 READ substituirM5 WRITE defineSubstituirM5 NOTIFY substituirM5Mudou)

public:
   explicit EditorGCode(QObject* parent = nullptr);

   QString caminhoArquivo() const;
   void defineCaminhoArquivo(const QString& caminhoArquivo);

   int minimoEntrada() const;
   void defineMinimoEntrada(int minimoEntrada);

   int maximoEntrada() const;
   void defineMaximoEntrada(int maximoEntrada);

   int minimoSaida() const;
   void defineMinimoSaida(int minimoSaida);

   int maximoSaida() const;
   void defineMaximoSaida(int maximoSaida);

   QString cabecalho() const;
   void defineCabecalho(const QString& cabecalho);

   QString rodape() const;
   void defineRodape(const QString& rodape);

   bool substituirG0() const;
   void defineSubstituirG0(bool substituirG0);

   bool substituirM5() const;
   void defineSubstituirM5(bool substituirM5);

   Q_INVOKABLE void altera();

signals:
   void caminhoArquivoMudou();
   void minimoEntradaMudou();
   void maximoEntradaMudou();
   void minimoSaidaMudou();
   void maximoSaidaMudou();
   void cabecalhoMudou();
   void rodapeMudou();
   void substituirG0Mudou();
   void substituirM5Mudou();

   void alteracaoIniciou();
   void alteracaoProgrediu(double porcento);
   void alteracaoConcluiu(qint64 milisegundos);
   void erroAlteracao(const QString& mensagem);

private:
   QSettings* m_settings{ nullptr };
   QString m_caminhoArquivo{ "" };
   int m_minimoEntrada{ 0 };
   int m_maximoEntrada{ 1000 };
   int m_minimoSaida{ 1000 };
   int m_maximoSaida{ 0 };
   QString m_cabecalho{ "" };
   QString m_rodape{ "" };
   bool m_substituirG0{ false };
   bool m_substituirM5{ false };

   void carrega();
   void salva();
   template < typename T >
   T mapeia(T x);
   template < typename T >
   static T mapeia(T x, T inMin, T inMax, T outMin, T outMax);
};

