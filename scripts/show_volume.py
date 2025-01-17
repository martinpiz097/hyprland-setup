#!/usr/bin/env python3

import sys
import os
import psutil
from PyQt5 import QtWidgets, QtCore, QtGui

class VolumeApp(QtWidgets.QWidget):
    def __init__(self, volumen=0):
        super().__init__()
        self.volumen = volumen
        self.init_ui()

    def init_ui(self):
        self.setWindowTitle("Volumen PipeWire")
        # Tamaño fijo de 300x40
        self.setFixedSize(300, 40)

        # Que la ventana esté siempre al frente
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowStaysOnTopHint)

        # Creamos el layout
        layout = QtWidgets.QVBoxLayout()
        layout.setContentsMargins(10, 5, 10, 5)

        # Creamos la barra de progreso
        self.progress_bar = QtWidgets.QProgressBar()
        self.progress_bar.setRange(0, 100)  
        self.progress_bar.setValue(int(self.volumen))
        self.progress_bar.setTextVisible(True)
        self.progress_bar.setFormat("%p%")      # Mostrará el porcentaje
        self.progress_bar.setAlignment(QtCore.Qt.AlignCenter)

        # Fuente en negrita
        font = QtGui.QFont()
        font.setBold(True)
        self.progress_bar.setFont(font)

        layout.addWidget(self.progress_bar)
        self.setLayout(layout)

    def center_window_slightly_lower(self):
        """
        Centra la ventana en la pantalla, pero un poco más abajo
        (por ejemplo, +50 píxeles desde el verdadero centro vertical).
        """
        # Obtenemos el tamaño disponible de la pantalla principal
        screen = QtWidgets.QApplication.primaryScreen()
        geometry = screen.availableGeometry()
        # Calculamos la posición para centrar en X y desplazar en Y
        x = (geometry.width() - self.width()) // 2
        y = (geometry.height() - self.height()) // 2 + 50  # +50 px más abajo
        self.move(x, y)

def kill_previous_instance():
    """
    Mata cualquier instancia previa que esté ejecutando este mismo script,
    excepto el proceso actual.
    """
    current_pid = os.getpid()
    script_name = os.path.basename(__file__)

    for proc in psutil.process_iter(["pid", "name", "cmdline"]):
        if proc.info["pid"] == current_pid:
            # Saltamos nuestro propio proceso
            continue
        # Verificamos que en la línea de comandos figure nuestro archivo
        if proc.info["cmdline"] and script_name in proc.info["cmdline"]:
            proc.kill()

def main():
    # Verificamos que se haya pasado un argumento de volumen
    if len(sys.argv) < 2:
        print("Uso: python volumen_app.py <volumen>")
        sys.exit(1)

    # Parseamos el volumen (aceptamos entero o float)
    try:
        volumen = float(sys.argv[1])
    except ValueError:
        print("Error: el argumento de volumen no es un número válido.")
        sys.exit(1)

    # Iniciamos la aplicación de PyQt
    app = QtWidgets.QApplication(sys.argv)

    # Creamos la ventana
    ventana = VolumeApp(volumen)
    
    # Posicionamos la ventana centrada y un poco más abajo
    ventana.center_window_slightly_lower()

    # (1) Mostramos la nueva ventana de inmediato
    ventana.show()

    # (2) Matamos la instancia anterior en segundo plano después de 200 ms
    QtCore.QTimer.singleShot(200, kill_previous_instance)

    # (3) Cerramos la ventana automáticamente después de 500 ms (0.5 segundos)
    QtCore.QTimer.singleShot(500, ventana.close)

    # Ejecutamos el bucle de eventos
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
