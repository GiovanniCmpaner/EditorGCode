#include <QQuickItem>
#include <QDebug>
#include <QSettings>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QRegularExpression>
#include <QElapsedTimer>
#include <QThread>
#include <QtConcurrent/QtConcurrent>

#include "EditorGCode.hpp"

EditorGCode::EditorGCode(QObject* parent)
    : QObject{ parent }
{
    const QString arquivo{ qApp->applicationDirPath() + "/" + qApp->applicationName() + ".ini" };
    m_settings = new QSettings{ arquivo, QSettings::IniFormat, this };

    carrega();
}

void EditorGCode::carrega(){
    m_settings->beginGroup("configuracoes");
    {
        m_caminhoArquivo = m_settings->value("caminhoArquivo","").toString();
        m_minimoEntrada = m_settings->value("minimoEntrada",0).toInt();
        m_maximoEntrada = m_settings->value("maximoEntrada",1000).toInt();
        m_minimoSaida = m_settings->value("minimoSaida",1000).toInt();
        m_maximoSaida = m_settings->value("maximoSaida",0).toInt();
        m_cabecalho = m_settings->value("cabecalho","").toString();
        m_rodape = m_settings->value("rodape","").toString();
        m_substituirG0 = m_settings->value("substituirG0","").toBool();
        m_substituirM5 = m_settings->value("substituirM5","").toBool();
    }
    m_settings->endGroup();

    salva();
}

void EditorGCode::salva(){
    m_settings->beginGroup("configuracoes");
    {
        m_settings->setValue("caminhoArquivo",m_caminhoArquivo);
        m_settings->setValue("minimoEntrada",m_minimoEntrada);
        m_settings->setValue("maximoEntrada",m_maximoEntrada);
        m_settings->setValue("minimoSaida",m_minimoSaida);
        m_settings->setValue("maximoSaida",m_maximoSaida);
        m_settings->setValue("cabecalho",m_cabecalho);
        m_settings->setValue("rodape",m_rodape);
        m_settings->setValue("substituirG0",m_substituirG0);
        m_settings->setValue("substituirM5",m_substituirM5);
    }
    m_settings->endGroup();

    m_settings->sync();
}

QString EditorGCode::caminhoArquivo() const {
    return m_caminhoArquivo;
}

void EditorGCode::defineCaminhoArquivo(const QString& caminhoArquivo){
    QString caminhoLocal;
    QUrl url{ caminhoArquivo };
    if(url.isLocalFile()){
      caminhoLocal = url.toLocalFile();
    }
    else {
      caminhoLocal = caminhoArquivo;
    }
    if(m_caminhoArquivo == caminhoLocal){
        return;
    }
    m_caminhoArquivo = caminhoLocal;
    emit caminhoArquivoMudou();
}

int EditorGCode::minimoEntrada() const {
    return m_minimoEntrada;
}
void EditorGCode::defineMinimoEntrada(int minimoEntrada){
    if(m_minimoEntrada == minimoEntrada){
        return;
    }
    m_minimoEntrada = minimoEntrada;
    emit minimoEntradaMudou();
}

int EditorGCode::maximoEntrada() const {
    return m_maximoEntrada;
}
void EditorGCode::defineMaximoEntrada(int maximoEntrada){
    if(m_maximoEntrada == maximoEntrada){
        return;
    }
    m_maximoEntrada = maximoEntrada;
    emit maximoEntradaMudou();
}

int EditorGCode::minimoSaida() const {
    return m_minimoSaida;
}
void EditorGCode::defineMinimoSaida(int minimoSaida){
    if(m_minimoSaida == minimoSaida){
        return;
    }
    m_minimoSaida = minimoSaida;
    emit minimoSaidaMudou();
}

int EditorGCode::maximoSaida() const {
    return m_maximoSaida;
}
void EditorGCode::defineMaximoSaida(int maximoSaida){
    if(m_maximoSaida == maximoSaida){
        return;
    }
    m_maximoSaida = maximoSaida;
    emit maximoSaidaMudou();
}

QString EditorGCode::cabecalho() const {
  return m_cabecalho;
}
void EditorGCode::defineCabecalho(const QString& cabecalho){
  if(m_cabecalho == cabecalho){
      return;
  }
  m_cabecalho = cabecalho;
  emit cabecalhoMudou();
}

QString EditorGCode::rodape() const {
  return m_rodape;
}
void EditorGCode::defineRodape(const QString& rodape){
  if(m_rodape == rodape){
      return;
  }
  m_rodape = rodape;
  emit rodapeMudou();
}

bool EditorGCode::substituirG0() const{
  return m_substituirG0;
}
void EditorGCode::defineSubstituirG0(bool substituirG0){
  if(m_substituirG0 == substituirG0){
      return;
  }
  m_substituirG0 = substituirG0;
  emit substituirG0Mudou();
}

bool EditorGCode::substituirM5() const{
  return m_substituirM5;
}
void EditorGCode::defineSubstituirM5(bool substituirM5){
  if(m_substituirM5 == substituirM5){
      return;
  }
  m_substituirM5 = substituirM5;
  emit substituirM5Mudou();
}

void EditorGCode::altera(){

  if(m_minimoEntrada == m_maximoEntrada){
    emit erroAlteracao("Mínimo da entrada deve ser diferente do máximo da entrada");
    return;
  }
  if(m_minimoSaida == m_maximoSaida){
    emit erroAlteracao("Mínimo da saída deve ser diferente do máximo da saída");
    return;
  }
  if(m_minimoEntrada == m_minimoSaida && m_maximoEntrada == m_maximoSaida){
    emit erroAlteracao("Saída deve ser diferente da entrada");
    return;
  }
  if(not QFileInfo{ m_caminhoArquivo }.exists()){
    emit erroAlteracao("Arquivo deve existir");
    return;
  }

  QtConcurrent::run([&]{
    emit alteracaoIniciou();

    QElapsedTimer timer{ };
    timer.start();

    salva();



    const QString caminhoArquivoSaida{ QFileInfo{ m_caminhoArquivo }.dir().path() + "/" + QFileInfo{ m_caminhoArquivo }.baseName() + "_alterado." + QFileInfo{ m_caminhoArquivo }.completeSuffix() };

    QFile arquivoEntrada{ m_caminhoArquivo };
    QFile arquivoSaida{ caminhoArquivoSaida };

    const qint64 tamanhoTotal{ arquivoEntrada.size() };

    if(tamanhoTotal > 0){
      arquivoEntrada.open(QIODevice::ReadOnly | QIODevice::Text);
      arquivoSaida.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text);

      arquivoSaida.write(m_cabecalho.toUtf8());
      if(not m_cabecalho.isEmpty() and not m_cabecalho.endsWith("\n")){
        arquivoSaida.write("\n");
      }
      while(arquivoEntrada.bytesAvailable()){
          QString linha{ arquivoEntrada.readLine() };

          const int tamanhoLinha{ linha.size() };

          auto extraiNumero = [&](const QString& letra, auto callback) -> bool {
            int posicaoInicio{ linha.indexOf(letra) };
            if(posicaoInicio != -1){
              int posicaoFim{ linha.indexOf(QRegularExpression{"[^0-9\\.]"},posicaoInicio + 1) };
              if(posicaoFim == -1){
                  posicaoFim = linha.length();
              }
              if(posicaoFim > posicaoInicio + 1){
                  QString valor{ linha.mid(posicaoInicio + 1,posicaoFim - (posicaoInicio + 1)) };
                  double numero{ valor.toDouble() };
                  callback(numero);
                  linha.replace(posicaoInicio + 1,posicaoFim - (posicaoInicio + 1),QString::number(numero));
                  return true;
              }
            }
            return false;
            /*
            int posicaoInicio{ 0 };
            while(posicaoInicio < linha.size()){
              posicaoInicio = linha.indexOf(letra,posicaoInicio);
              if(posicaoInicio == -1){
                break;
              }
              int posicaoFim{ linha.indexOf(QRegularExpression{"[^0-9\\.]"},posicaoInicio + 1) };
              if(posicaoFim == -1){
                  posicaoFim = linha.length();
              }
              if(posicaoFim > posicaoInicio + 1){
                  QString valor{ linha.mid(posicaoInicio + 1,posicaoFim - (posicaoInicio + 1)) };
                  double numero{ valor.toDouble() };
                  callback(numero);
                  linha.replace(posicaoInicio + 1,posicaoFim - (posicaoInicio + 1),QString::number(numero));
              }
              posicaoInicio = posicaoFim;
              */
          };

          extraiNumero("S",[&](auto& numero){
            numero = mapeia(static_cast<long>(numero));
          });

          if(m_substituirG0){
            if(linha.startsWith("G0")){
              linha.replace(0,2,"G1");

              if(not extraiNumero("S",[](auto){ /* NADA */ })){
                int posicaoFim{ linha.indexOf("[\\r\\n]") };
                if(posicaoFim == -1){
                    posicaoFim = linha.length();
                }
                linha.insert(posicaoFim - 1," S" + QString::number(m_minimoSaida));
              }
            }
          }

          if(m_substituirM5){
            if(linha.startsWith("M5")){
              linha.replace(0,2,"M3");

              if(not extraiNumero("S",[](auto){ /* NADA */ })){
                int posicaoFim{ linha.indexOf("[\\r\\n]") };
                if(posicaoFim == -1){
                    posicaoFim = linha.length();
                }
                linha.insert(posicaoFim - 1," S" + QString::number(m_minimoSaida));
              }
            }
          }

          arquivoSaida.write(linha.toUtf8());

          emit alteracaoProgrediu(static_cast<double>(tamanhoLinha)/static_cast<double>(tamanhoTotal));
      }
      arquivoSaida.write(m_rodape.toUtf8());

      arquivoEntrada.close();
      arquivoSaida.close();
    }

    emit alteracaoConcluiu(timer.elapsed());
  });
}

template < typename T >
T EditorGCode::mapeia(T x){
  return mapeia<T>(x,m_minimoEntrada,m_maximoEntrada,m_minimoSaida,m_maximoSaida);
}

template < typename T >
T EditorGCode::mapeia(T x, T inMin, T inMax, T outMin, T outMax){
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}
