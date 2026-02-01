# 🐧 Linux System Administration Lab - Automatic Backup Script

**Author:** Nerea Arce  
**GitHub:** [arcenerea](https://github.com/arcenerea)  
**Date:** 2026

---

## 🎯 Objetivo / Objective

Este proyecto demuestra habilidades básicas de administración de sistemas Linux:

- Automatización de tareas mediante Bash  
- Gestión de archivos y directorios  
- Creación de scripts prácticos para uso diario en Linux  

This project demonstrates basic Linux system administration skills:

- Task automation using Bash  
- File and directory management  
- Creating practical scripts for daily Linux usage  

---

## 📂 Contenido / Project Contents

- `scripts/backup_automatico.sh` – Script de backup automático que copia la carpeta `Documentos` a `/home/backup` con fecha y hora incluida.  
- `docs/` (opcional) – Diagramas o capturas del flujo de backup.  
- `examples/` (opcional) – Ejemplos de salida del script o logs.  

`scripts/backup_automatico.sh` – Automatic backup script that copies your `Documents` folder to `/home/backup` with date and time.  
`docs/` (optional) – Diagrams or screenshots of the backup flow.  
`examples/` (optional) – Example script output or logs.

---

## ⚙️ Cómo usarlo / How to Use

1. Abre una terminal en Linux / Open a terminal in Linux  
2. Da permisos de ejecución al script / Give execute permissions to the script:
   ```bash
   chmod +x scripts/backup_automatico.sh


3. Ejecuta el script / Run the script:

./scripts/backup_automatico.sh


El backup se guardará en /home/backup/YYYY-MM-DD_HH-MM-SS / Your backup will be saved in /home/backup/YYYY-MM-DD_HH-MM-SS

