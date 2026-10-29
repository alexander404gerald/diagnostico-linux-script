#!/bin/bash

# Define el archivo de salida y el servicio a revisar (por defecto sshd)
LOG_FILE="resultado_diagnostico.md"
SERVICIO=${1:-sshd}
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

# Genera el encabezado
echo "===============================================" > $LOG_FILE
echo " REPORTE DE DIAGNÓSTICO DEL SISTEMA" >> $LOG_FILE
echo " Fecha y Hora: $FECHA" >> $LOG_FILE
echo "===============================================" >> $LOG_FILE
echo "" >> $LOG_FILE

# Sección 1: Disco (filtrado solo para la partición raíz para mayor limpieza)
echo "[1. DISCO] Estado del almacenamiento principal (/):" >> $LOG_FILE
df -h / >> $LOG_FILE
echo "" >> $LOG_FILE

# Sección 2: Memoria RAM
echo "[2. MEMORIA] Uso de RAM y Swap (en MB):" >> $LOG_FILE
free -m >> $LOG_FILE
echo "" >> $LOG_FILE

# Sección 3: CPU y Carga del Sistema (¡Nueva mejora!)
echo "[3. CPU] Tiempo de actividad y carga promedio:" >> $LOG_FILE
uptime >> $LOG_FILE
echo "" >> $LOG_FILE

# Sección 4: Red (¡Nueva mejora!)
echo "[4. RED] Dirección IP interna:" >> $LOG_FILE
hostname -I | awk '{print $1}' >> $LOG_FILE
echo "" >> $LOG_FILE

# Sección 5: Servicios
echo "[5. SERVICIOS] Revisando estado del servicio '$SERVICIO':" >> $LOG_FILE
if systemctl is-active --quiet $SERVICIO; then
    echo "ESTADO: [✔] OK - El servicio $SERVICIO está corriendo perfectamente." >> $LOG_FILE
else
    echo "ESTADO: [✖] ALERTA - El servicio $SERVICIO está detenido o en fallo." >> $LOG_FILE
fi
echo "" >> $LOG_FILE

# Pie de página
echo "===============================================" >> $LOG_FILE
echo " Diagnóstico finalizado exitosamente." >> $LOG_FILE
echo "===============================================" >> $LOG_FILE

echo "¡Reporte generado en $LOG_FILE!"
