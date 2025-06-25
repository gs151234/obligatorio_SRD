# obligatorio_SRD

Indice
Introduccion
Implementación
  Hardening
  WAF - Apache ModSecurity
  SIEM - Wazuh
  Analítica de Usuarios
  Solución de Acceso Administrativo - pfSense

Evidencias
  Ejecución Hardening
      
  WAF
    
  Wazuh
  
  Analítica de Usuarios
  
  Solución de Acceso Administrativo
  
Introduccion
En esta propuesta se nos solicita realizar la implementación de una solución integral de seguridad para la empresa Electronic Security Engineering (ESE). Dada su naturaleza crítica, su acelerado crecimiento y los riesgos inherentes a su actividad, ESE enfrenta amenazas constantes que comprometen tanto su propiedad intelectual como la disponibilidad y reputación de sus servicios. 

Con el objetivo de fortalecer su postura de seguridad frente a estos desafíos, se propone una serie de medidas concretas que abarcan desde el endurecimiento del sistema operativo hasta la implementación de tecnologías avanzadas de monitoreo, control de accesos y análisis de amenazas. La solución considera tanto la defensa perimetral como la detección proactiva de incidentes, haciendo uso de herramientas de código abierto y buenas prácticas de la industria. 

A continuación, se detalla el conjunto de requerimientos a implementar: 

1. Hardening del Sistema Operativo Linux 
Realizar hardening sobre Debian 10, 11 o 12 siguiendo los CIS CSC. 
Acciones mínimas: 
Deshabilitar servicios innecesarios. 
Configurar políticas de contraseñas seguras y autenticación multifactor (MFA). 
Aplicar parches de seguridad y actualizaciones del sistema. 
Configurar firewall local con reglas de acceso estrictas. 
Implementar auditoría de sistema para detectar cambios no autorizados en archivos críticos. 
Automatizar recolección remota de telemetría (procesos, usuarios, conexiones, software instalado, parches). 

2. Implementación de un SIEM (Wazuh) 
Desplegar Wazuh para monitorizar, analizar y correlacionar eventos de seguridad (incluyendo WAF y servidor Linux). 
Se configurará: 
Al menos 3 casos de uso de detección y respuesta automatizada con correlación de eventos no triviales. 
Al menos 3 KPIs clave para visualizar en una consola de mando. 

3. Implementación de un Web Application Firewall (WAF) 
Configuraremos un WAF en modo reverse proxy para proteger el portal web. 
Debe cubrir mínimo las amenazas OWASP Top Ten (SQLi, XSS, tráfico malicioso). 
Requisitos: 
Bloqueo de ataques en tiempo real sin afectar el rendimiento. 
Puede funcionar autónomamente o integrado con el SIEM. 
Crear al menos 3 políticas personalizadas. 
Integrar el WAF con el SIEM para monitoreo centralizado. 

4. Analítica de Autenticación de Usuarios 
Implementaremos en el SIEM analítica de autenticación para: 
Correlacionar actividades sospechosas. 
Detectar y reaccionar ante posibles compromisos de credenciales. 
Bloquear usuarios potencialmente comprometidos. 

5. Solución de Acceso Administrativo 
Configuraremos una VPN de administración para usuarios privilegiados. 
Requisitos: 
Protección con autenticación multifactor. 
Registro completo de autenticaciones y actividades. 
Configurar control de acceso granular con al menos dos roles diferentes.

Implementación
Hardening

Aclaración:
Se realiza la instalación de Debian 12 minimal que viene con SSH server y las standar system utilities. 

IMAGEN DE DEBIAN MINIMAL

Por este motivo no es necesario deshabilitar procesos innecesarios. 

Automatismo - Ansible

Utilizamo Ansible para la autimatización de la tarea y lo ejecutamos desde un servidor bastion.
La estructura es la siguiente
IMAGEN DE TREE ANSIBLE

Creamos claves publica/privadas para los usuarios Sysadmin (con passphrase) que es el administrador de los sistemas y Ansible.

Ejecución

El automatismo parte de un script llamado "deploy_42.sh" que contiene la ejección de 2 playbooks llamados "bootstrap.yml" y "playhard.yml".
Con Sysadmin ejecutamos bootstrap.yml y preparamos el ambiente en el host:
  Crea el usuario Ansible y se le da permisos de sudo sin contraseña.
  Copia las claves publicas de Sysadmin y Ansible.
  Cambia el puerto por defecto de SSH al 61189.
Con Ansible ejecutamos "playhard.yml":
  Se sinconizara la hora para evitar problemas de instalación de paquetes, además de que es un requerimiento para el MFA. 
  Se actualizarán paquetes del sistema (apt update – apt upgadre) 
  Se instalan paquetes necesarios para el resto de las tareas 
  Se deshabilita el login de root por SSH
  Se deshabilitarán módulos de filesystem innecesarios 
  Se aplicarán reglas de Auditd 
  Se agregan reglas de iptables 
  Se aplican políticas de contraseña endureciendo los criterios por defecto 
  Se configura MFA con Google Authenticator (no se aplica para usuarios dentro de un Whitelis preestablecida) 
  Se instalará un agente de wazuh, copiando script que se utilizaran para los puntos 2 y 3 
  Se instalará un agente de velocirraptor para recolectar datos de telemetría 


  WAF - Apache ModSecurity
  SIEM - Wazuh
  Analítica de Usuarios
  Solución de Acceso Administrativo - pfSense
