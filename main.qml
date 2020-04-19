import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import EditorGCode 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Universal 2.2

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Editor GCode")

    EditorGCode {
        id: editorGCode

        onAlteracaoIniciou: {
            columnLayoutPrincipal.enabled = false
            labelAlteracao.color = "#000000"
            labelAlteracao.text = "Alterando..."
            progressBarAlteracao.value = 0
        }
        onAlteracaoConcluiu: {
            progressBarAlteracao.value = 1
            labelAlteracao.color = "#000000"
            labelAlteracao.text = "Concluido (" + milisegundos + " ms)"
            columnLayoutPrincipal.enabled = true
        }
        onAlteracaoProgrediu: {
            progressBarAlteracao.value += porcento
        }
        onErroAlteracao: {
            labelAlteracao.color = "#FF0000"
            labelAlteracao.text = mensagem
        }
    }

    ColumnLayout {
        id: columnLayoutPrincipal
        x: 8
        y: 8
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        spacing: 8
        anchors.fill: parent


        ColumnLayout {
            id: columnLayout
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: false
            Layout.fillWidth: true

            Label {
                id: label1
                text: qsTr("Arquivo")
                z: 1
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: false
            }

            RowLayout {
                id: rowLayout
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.fillHeight: true
                spacing: 0
                Layout.fillWidth: true

                TextField {
                    id: textFieldArquivo
                    height: 30
                    hoverEnabled: true
                    visible: true
                    Layout.maximumHeight: 30
                    Layout.fillWidth: true
                    selectByMouse: true
                    text: editorGCode.caminhoArquivo
                }

                Button {
                    id: buttonArquivo
                    height: 30
                    text: qsTr("")
                    z: 1
                    display: AbstractButton.IconOnly
                    Layout.maximumWidth: 30
                    Layout.maximumHeight: 30
                    Layout.fillWidth: true
                    onClicked: fileDialogArquivo.open()

                    Image {
                        id: imageArquivo
                        width: 16
                        height: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        visible: true
                        fillMode: Image.PreserveAspectFit
                        source: "Imagens/OpenFolder_16x.png"
                    }
                }



            }


        }


        ColumnLayout {
            id: columnLayout1
            width: 100
            height: 100
            Layout.fillHeight: false
            Layout.fillWidth: true

            Label {
                id: label5
                text: qsTr("Velocidade Spindle / Potência Laser")
            }

            RowLayout {
                id: rowLayout4
                width: 100
                height: 100
                Layout.fillHeight: false
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    id: rectangle2
                    width: 200
                    height: 120
                    border.color: "#bdbdbd"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        id: columnLayout5
                        anchors.rightMargin: 8
                        anchors.leftMargin: 8
                        anchors.bottomMargin: 8
                        anchors.topMargin: 8
                        anchors.fill: parent

                        Label {
                            id: label8
                            text: qsTr("Entrada / Original")
                            Layout.fillWidth: false
                        }

                        GridLayout {
                            id: gridLayout
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            columnSpacing: 8
                            rowSpacing: 8
                            rows: 2
                            columns: 2

                            Label {
                                id: label
                                text: qsTr("Mínimo")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.maximumHeight: 30
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                            }

                            SpinBox {
                                id: spinBoxMinimoEntrada
                                height: 73
                                editable: true
                                Layout.maximumHeight: 30
                                to: 999999
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                value: editorGCode.minimoEntrada
                            }

                            Label {
                                id: label2
                                text: qsTr("Máximo")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: false
                                Layout.fillHeight: false
                                Layout.maximumHeight: 30
                            }

                            SpinBox {
                                id: spinBoxMaximoEntrada
                                editable: true
                                Layout.maximumHeight: 30
                                to: 999999
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                value: editorGCode.maximoEntrada
                            }
                        }
                    }
                }

                Image {
                    id: image
                    width: 50
                    height: 49
                    Layout.maximumHeight: 50
                    Layout.maximumWidth: 50
                    Layout.topMargin: 8
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    source: "Imagens/SyncArrow_256x.png"
                }

                Rectangle {
                    id: rectangle3
                    width: 200
                    height: 120
                    border.color: "#bdbdbd"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        id: columnLayout6
                        anchors.rightMargin: 8
                        anchors.leftMargin: 8
                        anchors.bottomMargin: 8
                        anchors.topMargin: 8
                        anchors.fill: parent


                        Label {
                            id: label9
                            text: qsTr("Saída / Alterado")
                        }

                        GridLayout {
                            id: gridLayout1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            flow: GridLayout.LeftToRight
                            rowSpacing: 8
                            layoutDirection: Qt.LeftToRight
                            columnSpacing: 8
                            rows: 2
                            columns: 2
                            Label {
                                id: label3
                                text: qsTr("Mínimo")
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: false
                            }

                            SpinBox {
                                id: spinBoxMinimoSaida
                                height: 73
                                editable: true
                                Layout.fillWidth: true
                                to: 999999
                                Layout.maximumHeight: 30
                                Layout.fillHeight: true
                                value: editorGCode.minimoSaida
                            }

                            Label {
                                id: label4
                                text: qsTr("Máximo")
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: false
                            }

                            SpinBox {
                                id: spinBoxMaximoSaida
                                editable: true
                                Layout.fillWidth: true
                                to: 999999
                                Layout.maximumHeight: 30
                                Layout.fillHeight: true
                                value: editorGCode.maximoSaida
                            }
                        }
                    }
                }



            }

        }



        ColumnLayout {
            id: columnLayout7
            width: 100
            height: 100
            z: 1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: false
            Layout.fillWidth: true
            Label {
                id: label10
                text: qsTr("Opções Spindle / Laser")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: false
                z: 1
            }

            ColumnLayout {
                id: columnLayout8
                width: 100
                height: 100
                Layout.fillHeight: false
                Layout.fillWidth: true

                CheckBox {
                    id: checkBoxSubstituirG0
                    height: 30
                    text: qsTr("Substituir todos os G0 (desligado) por G1 (mínimo da saída)")
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    checked: editorGCode.substituirG0
                }

                CheckBox {
                    id: checkBoxSubstituirM5
                    height: 30
                    text: qsTr("Substituir todos os M5 (desligado) por M3 (minimo da saída)")
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    checked: editorGCode.substituirM5
                }
            }
        }

        ColumnLayout {
            id: columnLayout3
            width: 100
            height: 100
            Layout.rowSpan: 1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true


            Label {
                id: label6
                text: qsTr("Cabeçalho")
                Layout.fillWidth: false
            }

            Rectangle {
                id: rectangle1
                Layout.fillHeight: true
                Layout.fillWidth: true
                border.color: "#bdbdbd"

                TextArea {
                    id: textAreaCabecalho
                    anchors.fill: parent
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    selectByMouse: true
                    text: editorGCode.cabecalho
                }
            }


        }

        ColumnLayout {
            id: columnLayout4
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Label {
                id: label7
                text: qsTr("Rodapé")
            }

            Rectangle {
                id: rectangle
                Layout.fillHeight: true
                Layout.fillWidth: true
                border.color: "#bdbdbd"

                TextArea {
                    id: textAreaRodape
                    anchors.fill: parent
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    selectByMouse: true
                    text: editorGCode.rodape
                }
            }

        }


        RowLayout {
            id: rowLayout1
            width: 100
            height: 100
            spacing: 8
            Layout.fillWidth: true

            Button {
                id: buttonAltera
                height: 30
                text: qsTr("Alterar")
                display: AbstractButton.TextBesideIcon
                Layout.rowSpan: 1
                Layout.fillHeight: false
                Layout.maximumHeight: 30
                Layout.maximumWidth: 100
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    editorGCode.caminhoArquivo = textFieldArquivo.text
                    editorGCode.minimoEntrada = spinBoxMinimoEntrada.value
                    editorGCode.maximoEntrada = spinBoxMaximoEntrada.value
                    editorGCode.minimoSaida = spinBoxMinimoSaida.value
                    editorGCode.maximoSaida = spinBoxMaximoSaida.value
                    editorGCode.cabecalho = textAreaCabecalho.text
                    editorGCode.rodape = textAreaRodape.text
                    editorGCode.substituirG0 = checkBoxSubstituirG0.checked
                    editorGCode.substituirM5 = checkBoxSubstituirM5.checked
                    editorGCode.altera()
                }
            }

            ColumnLayout {
                id: columnLayout2
                width: 100
                height: 100
                spacing: 8

                Label {
                    id: labelAlteracao
                    text: qsTr("Aguardando")
                }

                ProgressBar {
                    id: progressBarAlteracao
                    to: 1
                    indeterminate: false
                    Layout.minimumHeight: 0
                    Layout.maximumHeight: 65535
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    value: 0
                }

            }
        }





        FileDialog {
            id: fileDialogArquivo
            title: "Selecione um arquivo"
            folder: shortcuts.home
            onAccepted: {
                editorGCode.caminhoArquivo = fileDialogArquivo.fileUrl
            }
        }


    }
}





















/*##^## Designer {
    D{i:1;anchors_height:100;anchors_width:100;anchors_x:109;anchors_y:94}D{i:6;anchors_height:16;anchors_width:16}
D{i:8;anchors_height:100;anchors_width:100;anchors_x:"-12";anchors_y:40}D{i:7;anchors_height:16;anchors_width:16}
D{i:3;anchors_height:100;anchors_width:100;anchors_x:"-12";anchors_y:40}D{i:10;anchors_height:100;anchors_width:100}
D{i:16;anchors_height:100;anchors_width:100}D{i:17;anchors_height:100;anchors_width:100}
D{i:18;anchors_height:100;anchors_width:100}D{i:19;anchors_height:100;anchors_width:100}
D{i:13;anchors_height:100;anchors_width:100}D{i:20;anchors_height:100;anchors_width:100}
D{i:22;anchors_height:100;anchors_width:100}D{i:11;anchors_height:100;anchors_width:100}
D{i:9;anchors_height:100;anchors_width:100}D{i:32;anchors_height:25;anchors_x:0;anchors_y:164}
D{i:31;anchors_height:200;anchors_width:200}D{i:29;anchors_height:100;anchors_width:100}
D{i:36;anchors_height:25;anchors_x:0;anchors_y:118}D{i:35;anchors_height:200;anchors_width:200}
D{i:33;anchors_height:100;anchors_width:100}
}
 ##^##*/
