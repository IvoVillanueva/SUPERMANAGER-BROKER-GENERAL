# 🏀 SuperManager Broker General

**SuperManager Broker General** es un **bot automatizado desarrollado en R** diseñado para extraer, procesar y visualizar datos del juego **SuperManager ACB**, generando informes visuales en formato `.png` para los rankings más relevantes:

- **Top 20 de la jornada**
- **Clasificación general**
- **Ranking Broker**

El sistema está optimizado para funcionar con mínima intervención humana, ofreciendo una solución robusta, reproducible y automatizada para el análisis periódico de datos.

---

## ⚙️ Funcionamiento Técnico

El bot ejecuta de manera automática una serie de scripts que:

- Realizan peticiones a los endpoints del SuperManager ACB.
- Procesan y estructuran los datos obtenidos.
- Generan archivos `.png` con visualizaciones listas para publicación en redes sociales (X/Twitter).
- Ejecutan el flujo completo de forma autónoma, salvo por un único punto de intervención.

> ✅ **Único requerimiento manual:**  
> Actualizar periódicamente el **Bearer token** de autorización cuando expire, necesario para acceder a los endpoints protegidos.

---

## 🎯 Objetivo del Proyecto

- Eliminar tareas manuales recurrentes mediante automatización.
- Facilitar la generación de contenido visual y analítico para usuarios del SuperManager.
- Servir como herramienta de soporte para la toma de decisiones basadas en datos dentro del juego.

---

## 🧩 Requisitos de Mantenimiento

El sistema está diseñado para requerir intervención mínima. Solo es necesario:

- 🔄 **Actualizar el token Bearer** cuando expire.
- 📡 *(Opcional)* Verificar que las rutas y endpoints de la ACB no hayan sido modificados.

---

## 📈 Casos de Uso

- Publicación periódica de rankings en redes sociales.
- Generación de contenido para newsletters, blogs o análisis internos.
- Soporte a creadores de contenido enfocados en el SuperManager.

---

## 🤝 Contribuciones

Contribuciones externas son bienvenidas.  
Puedes proponer mejoras, reportar errores o sugerir nuevos módulos a través de:

- Issues
- Pull Requests

Por favor, asegúrate de seguir buenas prácticas y documentar correctamente cualquier contribución.

---

## 👤 Autor

**Ivo Villanueva**  
📧 Contacto: [@elcheff](https://twitter.com/elcheff)

Proyecto vinculado a **The Clean Shot**, una iniciativa de análisis y visualización avanzada de datos de baloncesto.

---

## 📄 Licencia

Este repositorio se distribuye bajo la **Licencia MIT**.

Puedes usar, modificar y redistribuir este software libremente, siempre que se mantenga la atribución correspondiente al autor original.

---

## 🏷️ Badges

![Language](https://img.shields.io/badge/language-R-blue.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-Autonomous-lightgrey.svg)
