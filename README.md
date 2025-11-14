# 🏀 SUPERMANAGER BROKER GENERAL

**SUPERMANAGER BROKER GENERAL** es un **BOT** desarrollado en **R** que automatiza la extracción de los datos de los usuarios del juego del **SuperManager ACB**. Su objetivo es extraer el **TO20** actualizado de la **jornada, la general, el Broker** y generar un png por ranking.

---

## ⚙️ Funcionamiento general

El bot ejecuta de forma automática los scripts que:

- Obtienen y procesan datos del SuperManager ACB.
- Guardan los resultados en archivos `.png` listos para publicar en **X**.
- Actualizan los datos con mínima intervención humana.

La única tarea de mantenimiento necesaria es **renovar periódicamente el token de autorización (Bearer)**, que permite acceder a los endpoints protegidos del SuperManager.  
Una vez actualizado, el bot continúa funcionando de forma completamente autónoma.

---

## 🧠 Objetivo

Automatizar la extracción de los rankings de los usuarios del **SuperManager**.  
El sistema automatiza el flujo de datos que normalmente se realiza de forma manual
Generar información de apoyo para decisiones de equipo o contenido analítico.

---

🔄 Mantenimiento

El bot no requiere supervisión continua.
Solo es necesario:

Actualizar el Bearer token cuando expire.

(Opcional) Revisar que las rutas y endpoints de la ACB no hayan cambiado.

