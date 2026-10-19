# Trabajo Práctico: Herramientas de Gestión de Ticket - Incidencias
**Carrera:** Analista Programador Universitario (APU)  
**Cátedra:** Herramientas Informáticas Avanzadas  
**Proyecto Seleccionado:** `mi-app-boletas` (Sistema Web de Facturación - React, Node.js, Firebase)  
**Herramienta de Gestión:** Mantis Bug Tracker (MantisBT) desplegado sobre Docker  

---

## 1. Tipos de Mantenimiento de Software

El mantenimiento de software (según el estándar internacional **ISO/IEC 14764** y las buenas prácticas de ingeniería de software) comprende el conjunto de actividades requeridas para proporcionar soporte eficiente, corregir anomalías, adaptar el sistema a entornos cambiantes y mejorar sus prestaciones una vez que el producto ha sido liberado a producción.

Se clasifican en cuatro tipos fundamentales:

### 1.1. Mantenimiento Correctivo
* **Definición:** Actividades reactivas orientadas a diagnosticar, aislar y reparar fallos, errores o defectos (bugs) no detectados durante las fases de pruebas y que se manifiestan durante la operación real del software.
* **Objetivo:** Restablecer el comportamiento y funcionalidad esperada del sistema en el menor tiempo posible.
* **Ejemplo en `mi-app-boletas`:** 
  > Un error 500 al emitir una boleta cuando el campo de CUIT del cliente contiene guiones, provocando que la API en Node.js falle y no guarde la transacción en Firebase Firestore.

### 1.2. Mantenimiento Adaptativo
* **Definición:** Modificaciones realizadas para que el sistema de software continúe funcionando de manera correcta y eficiente ante cambios en su entorno operativo, tecnológico, normativo o legal (sin alterar su propósito funcional original).
* **Objetivo:** Mantener la vigencia y compatibilidad del software frente a factores externos fuera del control directo de la aplicación.
* **Ejemplo en `mi-app-boletas`:**
  > Actualización obligatoria del SDK de Firebase por deprecación de la versión de autenticación heredada, o adecuación de las alícuotas impositivas y formato de comprobante electrónico según una nueva resolución de AFIP/ARCA.

### 1.3. Mantenimiento Perfectivo
* **Definición:** Acciones proactivas orientadas a incorporar nuevas funcionalidades, optimizar el rendimiento, refinar la experiencia de usuario (UI/UX) o mejorar la mantenibilidad general del código fuente en respuesta a solicitudes de usuarios y clientes.
* **Objetivo:** Elevar el valor del producto y satisfacer nuevas expectativas del negocio.
* **Ejemplo en `mi-app-boletas`:**
  > Añadir un botón en la interfaz de React para descargar el listado de boletas mensuales en formato Excel (XLSX), o implementar un debounce en el buscador de clientes para reducir lecturas innecesarias en la base de datos.

### 1.4. Mantenimiento Preventivo
* **Definición:** Modificaciones ejecutadas de forma anticipada para detectar y corregir problemas latentes antes de que se transformen en fallos operativos reales (también conocido como reingeniería preventiva o reducción de deuda técnica).
* **Objetivo:** Incrementar la fiabilidad, robustez y facilidad de mantenimiento a largo plazo del sistema.
* **Ejemplo en `mi-app-boletas`:**
  > Auditoría de dependencias npm (`npm audit`) para subsanar vulnerabilidades en paquetes de Node.js, reestructuración de índices compuestos en Firestore para evitar degradación de tiempos de consulta a medida que aumente el volumen de facturación, o incorporación de logs estructurados.

---

## 2. Contexto Organizacional y Selección de Herramienta

### 2.1. Diagnóstico del Problema
Una pequeña organización de 10 integrantes ha puesto en producción recientemente el sistema de facturación `mi-app-boletas`. Tras su lanzamiento, los usuarios finales y clientes comenzaron a reportar incidencias mediante canales informales y desordenados (mensajes de WhatsApp, correos no estructurados, llamadas telefónicas). 

Esto provocó:
* Pérdida de trazabilidad de los errores reportados.
* Incapacidad para priorizar urgencias (incidentes críticos mezclados con simples mejoras visuales).
* Duplicación de esfuerzos entre desarrolladores y mesa de ayuda.
* Falta de métricas objetivas sobre la calidad del software en producción.

### 2.2. Recomendaciones de APU
1. **Centralización de incidencias:** Implementar un único canal formal de registro donde cada requerimiento adquiera un identificador único (Ticket ID).
2. **Ciclo de vida formal:** Establecer estados claros (Nuevo $\rightarrow$ Asignado $\rightarrow$ En resolución $\rightarrow$ Resuelto $\rightarrow$ Cerrado).
3. **Ponderación estandarizada:** Separar Severidad (impacto técnico en el sistema) de Prioridad (urgencia de resolución para el negocio).
4. **Adopción de MantisBT:** Se seleccionó **Mantis Bug Tracker** por su naturaleza de código abierto, facilidad de despliegue contenerizado mediante Docker Compose, flexibilidad para definir roles de usuario (desarrollador, mesa de ayuda, informador), soporte nativo de categorización y potente módulo de informes estadísticos.

---

## 3. Gestión de Usuarios y Roles (Actividad 1)

Para reflejar la organización de 10 integrantes, se definieron y dieron de alta en MantisBT los siguientes perfiles con sus respectivos niveles de acceso:

| # | Nombre de Usuario | Nombre Real | Correo Electrónico | Nivel en MantisBT | Rol en la Organización |
|:---:|:---|:---|:---|:---|:---|
| 1 | `carlos.lider` | Carlos Gómez | `carlos@boletas.local` | **Supervisor** | Líder de Proyecto / Product Owner |
| 2 | `lucas.dev` | Lucas Pérez | `lucas@boletas.local` | **Desarrollador** | Desarrollador Fullstack (React/Node) |
| 3 | `martin.front` | Martín Díaz | `martin@boletas.local` | **Desarrollador** | Desarrollador Frontend (React) |
| 4 | `sofia.back` | Sofía Morales | `sofia@boletas.local` | **Desarrollador** | Desarrolladora Backend & DB (Node/Firebase) |
| 5 | `valeria.qa` | Valeria Rojas | `valeria@boletas.local` | **Actualizador** | QA Tester / Control de Calidad |
| 6 | `diego.soporte` | Diego Castro | `diego@boletas.local` | **Actualizador** | Mesa de Ayuda / Soporte Nivel 1 |
| 7 | `ana.soporte` | Ana Fernández | `ana@boletas.local` | **Actualizador** | Mesa de Ayuda / Soporte Nivel 1 |
| 8 | `mariana.fact` | Mariana López | `mariana@boletas.local` | **Informador** | Usuario Final (Operadora de Facturación) |
| 9 | `juan.admin` | Juan Torres | `juan@boletas.local` | **Informador** | Usuario Final (Administración y Cobranzas) |
| 10 | `esteban.ventas` | Esteban Silva | `esteban@boletas.local` | **Informador** | Usuario Final (Ventas) |

---

## 4. Categorización de Incidencias (Actividad 2)

En base a la arquitectura tecnológica de `mi-app-boletas`, se crearon las siguientes 5 categorías:
1. **Autenticación y Sesión:** Problemas con login, tokens expirados, permisos y Firebase Auth.
2. **Frontend / UI:** Defectos en componentes de React, diseño responsivo, botones inoperables o errores visuales.
3. **Backend y API:** Fallos en endpoints Express/Node.js, cálculos de montos e impuestos y validación de datos.
4. **Base de Datos:** Inconsistencias en Firebase Firestore, reglas de seguridad y tiempos de respuesta.
5. **Reportes y Exportación:** Errores en la emisión de comprobantes en PDF y exportaciones a Excel.

---

## 5. Criterio de Ponderación (Actividad 3)

Se estableció una matriz de ponderación bidimensional adaptada a MantisBT:

### 5.1. Severidad (Impacto Técnico en el Sistema)
* **Bloqueo / Caída (*Block / Crash*):** El sistema queda inoperable o la base de datos no responde. Afecta a toda la organización.
* **Mayor (*Major*):** Fallo en una función crítica (ej. no se pueden emitir facturas). No hay solución temporal accesible.
* **Menor (*Minor*):** Mal funcionamiento de una función secundaria o con mecanismo de contingencia (*workaround*).
* **Ajuste / Texto (*Tweak / Text*):** Errores tipográficos, desalineaciones estéticas menores o cambios de texto.
* **Nueva Característica (*Feature*):** Petición de nuevas funcionalidades (mantenimiento perfectivo).

### 5.2. Prioridad (Urgencia de Negocio)
* **Inmediata:** Resolución requerida en el día (paraliza cobros o facturación).
* **Urgente / Alta:** Debe ser atendida en el sprint/iteración en curso.
* **Normal:** Flujo estándar de mantenimiento correctivo/adaptativo.
* **Baja:** Tareas no críticas postergables.

---

## 6. Registro y Progreso de Incidencias (Actividades 4, 5 y 6)

Se registraron 10 incidencias realistas asociadas al ciclo de vida de `mi-app-boletas`. Se simuló el proceso de resolución (asignación de responsables, notas técnicas, trazabilidad de estados y adjuntos), cerrando 8 de ellas y conservando 2 en estado abierto para la defensa del trabajo práctico.

| ID | Categoría | Resumen / Defecto Reportado | Severidad | Prioridad | Asignado | Estado Final |
|:---:|:---|:---|:---:|:---:|:---|:---:|
| **0000001** | Backend y API | Error 500 al emitir boleta cuando el CUIT contiene guiones | Mayor | Urgente | `sofia.back` | **Cerrada** |
| **0000002** | Autenticación y Sesión | Sesión expira a los 5 minutos sin refrescar token en Firebase | Mayor | Alta | `lucas.dev` | **Cerrada** |
| **0000003** | Frontend / UI | Botón "Guardar Cliente" deshabilitado tras corregir email | Menor | Normal | `martin.front` | **Cerrada** |
| **0000004** | Reportes y Exportación | El total en el PDF generado no incluye los decimales de centavos | Mayor | Inmediata | `lucas.dev` | **Cerrada** |
| **0000005** | Base de Datos | Tiempo de respuesta lento (>6s) al consultar historial anual | Menor | Normal | `sofia.back` | **Cerrada** |
| **0000006** | Frontend / UI | En pantallas móviles la tabla de items de boleta se desborda | Ajuste | Baja | `martin.front` | **Cerrada** |
| **0000007** | Autenticación y Sesión | Mensaje de error genérico al intentar acceder sin permisos | Texto | Baja | `lucas.dev` | **Cerrada** |
| **0000008** | Reportes y Exportación | Exportación a Excel falla si el rango supera los 90 días | Menor | Normal | `sofia.back` | **Cerrada** |
| **0000009** | Backend y API | La API no valida stock negativo al confirmar facturación rápida | Bloqueo | Inmediata | `lucas.dev` | **Asignada (Abierta p/ Defensa)** |
| **0000010** | Frontend / UI | Implementar modo oscuro para operadoras de facturación nocturna | Característica | Baja | `martin.front` | **Asignada (Abierta p/ Defensa)** |

### 6.1. Simulación del Ciclo de Vida (Caso Testigo Ticket #0000001)
1. **Nuevo $\rightarrow$ Asignado:** El reporte fue catalogado bajo *Backend y API* y asignado a la desarrolladora `sofia.back`.
2. **Asignado $\rightarrow$ En resolución:** Se reprodujo el fallo en el ambiente local con CUITs formateados `XX-XXXXXXXX-X`.
3. **Registro de Notas Técnicas:** Se incorporó nota formal del desarrollador indicando la corrección en la función de saneamiento y la ejecución de pruebas unitarias.
4. **En resolución $\rightarrow$ Resuelto (Corregido):** Se subió el parche a *Staging* y se validó con QA.
5. **Resuelto $\rightarrow$ Cerrado:** Pase exitoso a producción y cierre formal de la incidencia.

---

## 7. Informes Estadísticos y Métricas (Actividad 7)

A través del módulo **Resumen** (`summary_page.php`) provisto por MantisBT, se extrajeron las métricas operativas del software tras el primer ciclo de mantenimiento:

### 7.1. Distribución de Estados
* **Total de incidencias:** 10
* **Incidencias resueltas/cerradas:** 8 (80%)
* **Incidencias abiertas:** 2 (20%) $\rightarrow$ Tasa de efectividad de mantenimiento del 80%.

### 7.2. Distribución por Categoría y Severidad
* El **40% de los incidentes** se concentraron en las capas críticas del sistema (*Backend y API* y *Base de Datos*), correspondiendo a fallos de severidad *Mayor* y *Bloqueo*.
* El **30% de los incidentes** correspondieron a la interfaz de usuario (*Frontend / UI*), vinculados a ajustes menores de usabilidad y diseño responsivo.
* El **20% de los incidentes** afectaron a la generación de comprobantes (*Reportes y Exportación*).
* El **10% de los incidentes** correspondieron a autenticación y tokens.

### 7.3. Conclusiones para la Mejora del Servicio (Visión APU)
1. **Refuerzo en Pruebas Automatizadas:** Dado que la mayor severidad se concentró en el Backend, se recomienda implementar tests de integración continuos (CI/CD) sobre los endpoints de facturación para evitar que excepciones no controladas lleguen a producción.
2. **Optimización Proactiva de Base de Datos:** La incidencia de latencia en consultas históricas demuestra que el mantenimiento preventivo (creación anticipada de índices compuestos en Firestore) debe planificarse antes de alcanzar volúmenes masivos de registros.
3. **Monitoreo de SLAs:** MantisBT permite auditar el tiempo medio entre la asignación y la resolución de incidentes, estableciendo acuerdos de nivel de servicio (SLA) para diferenciar fallos de bloqueo (resolución < 4 hs) de peticiones de nuevas características (próximo sprint).

---

## 8. Características Avanzadas (Actividad 8)

A continuación se detalla el procedimiento técnico para implementar las cuatro características avanzadas solicitadas por la cátedra:

### 8.1. Personalización de Formularios (Campos Personalizados)
MantisBT permite extender el formulario estándar de reporte incorporando metadatos específicos del negocio:
* **Procedimiento:**
  1. Iniciar sesión como `administrator` e ir a **Administración** $\rightarrow$ **Administrar campos personalizados**.
  2. Crear un nuevo campo, por ejemplo:
     * **Nombre:** `Ambiente_Despliegue`
     * **Tipo:** Lista desplegable (*Enumeración*).
     * **Valores posibles:** `Producción|Staging|Desarrollo Local`
     * **Valor por defecto:** `Producción`
  3. Vincular el campo creado al proyecto `mi-app-boletas` marcando las opciones: *Visualizar al reportar*, *Visualizar al actualizar* y *Requerido al reportar*.
  4. De este modo, al dar de alta un ticket, el usuario debe especificar obligatoriamente en qué entorno ocurrió la falla.

### 8.2. Comunicación entre Participantes mediante Correo Electrónico
Para que MantisBT notifique automáticamente cambios de estado, asignaciones y notas por email:
* **Procedimiento:**
  Editar el archivo de configuración `config/config_inc.php` del contenedor MantisBT incorporando las directivas SMTP:
  ```php
  # --- Configuración de Correo Electrónico (SMTP) ---
  $g_enable_email_notification = ON;
  $g_phpMailer_method          = PHPMAILER_METHOD_SMTP;
  $g_smtp_host                 = 'smtp.gmail.com';  # O servidor SMTP interno
  $g_smtp_port                 = 587;
  $g_smtp_connection_mode      = 'tls';
  $g_smtp_username             = 'notificaciones@boletas.local';
  $g_smtp_password             = 'tu_contraseña_de_aplicacion';
  $g_from_email                = 'soporte@boletas.local';
  $g_from_name                 = 'Mesa de Ayuda - mi-app-boletas';
  $g_return_path_email         = 'admin@boletas.local';
  ```

### 8.3. Posibilidad de Gestionar Tickets Anónimos
Permite que clientes o usuarios externos puedan reportar anomalías o consultar el estado de tickets públicos sin necesidad de registrarse previamente:
* **Procedimiento:**
  1. Ir a **Administración** $\rightarrow$ **Administrar cuentas** $\rightarrow$ **Crear cuenta nueva**.
  2. Crear un usuario llamado `anonymous` con nivel de acceso **Informador** (*Reporter*), correo `anonimo@boletas.local` y protegido contra modificaciones.
  3. En `config/config_inc.php`, añadir las directivas que habilitan el acceso anónimo:
     ```php
     # --- Acceso Anónimo a la Mesa de Ayuda ---
     $g_allow_anonymous_login = ON;
     $g_anonymous_account     = 'anonymous';
     ```
  4. En la pantalla de login aparecerá automáticamente el enlace *"Iniciar sesión anónimamente"* para permitir la carga directa de tickets a usuarios finales.

### 8.4. Restablecimiento de Contraseña
Habilita el autoservicio de recuperación de credenciales mediante tokens seguros temporales enviados por correo electrónico:
* **Procedimiento:**
  1. En `config/config_inc.php`, verificar que las directivas de restablecimiento estén habilitadas:
     ```php
     # --- Restablecimiento de Contraseñas ---
     $g_send_reset_password     = ON;
     $g_lost_password_feature   = ON;
     ```
  2. Con esto activo, en la pantalla de inicio de sesión se habilita el enlace **"¿Olvidó su contraseña?"** (*Lost your password?*).
  3. El usuario ingresa su nombre de usuario y correo registrado; el sistema genera un hash criptográfico de un solo uso y remite un enlace directo al correo con validez por tiempo limitado.
  4. Adicionalmente, el Administrador puede forzar el restablecimiento desde **Administración** $\rightarrow$ **Administrar cuentas** $\rightarrow$ seleccionando al usuario y haciendo clic en **Restablecer contraseña**.

---

## 9. Instrucciones de Despliegue en Docker

Para reproducir este entorno en cualquier máquina con Docker Desktop:
```bash
# 1. Clonar el repositorio
git clone https://github.com/peluk467/TP-Gestion-Tickets-2026.git
cd TP-Gestion-Tickets-2026/docker

# 2. Levantar los contenedores (MantisBT + MariaDB)
docker compose up -d

# 3. Acceder al sistema en el navegador
http://localhost:8989
```
Credenciales iniciales de administración: `administrator` / `root`.


