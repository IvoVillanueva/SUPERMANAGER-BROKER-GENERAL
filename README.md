# 🏀 SUPERMANAGER BROKER GENERAL

**SUPERMANAGER BROKER GENERAL** es un bot desarrollado en **R** que automatiza el seguimiento y análisis del mercado de jugadores del **SuperManager ACB**.  
Su objetivo es mantener actualizados los datos del juego y generar información útil para analizar tendencias de precios, rendimiento y oportunidades de mercado.

---

## ⚙️ Funcionamiento general

El bot ejecuta de forma automática los scripts que:

- Obtienen y procesan datos del SuperManager ACB.
- Calculan variaciones de precio y rendimiento por jornada.
- Guardan los resultados en archivos `.csv` listos para su uso en otras aplicaciones o paneles (por ejemplo, una app Shiny o dashboard externo).
- Actualizan los datos con mínima intervención humana.

La única tarea de mantenimiento necesaria es **renovar periódicamente el token de autorización (Bearer)**, que permite acceder a los endpoints protegidos del SuperManager.  
Una vez actualizado, el bot continúa funcionando de forma completamente autónoma.

---

## 🧠 Objetivo

Simplificar la gestión y análisis del mercado de jugadores del SuperManager.  
El sistema automatiza el flujo de datos que normalmente se realiza de forma manual, ayudando a:

- Detectar subidas y bajadas de precios.
- Identificar jugadores infravalorados o sobrevalorados.
- Generar información de apoyo para decisiones de equipo o contenido analítico.

---

## 📦 Estructura del proyecto


