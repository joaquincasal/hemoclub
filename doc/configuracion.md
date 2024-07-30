# Configuraciones productivas

Se documentan aquí algunas configuraciones que deben realizarse a la hora de correr la aplicación.

## Variables de ambiente

El proyecto incluye la gema `dotenv`, que automáticamente carga las variables de ambiente del archivo `.env`.  
Esto está pensando para facilitar correr el ambiente de desarrollo, para ambientes productivos deberán configurarse usando las opciones que haya en el proveedor cloud.  
Puede encontrarse un archivo `.env.example` a modo de ejemplo de cuales son las variables a configurar. Se describen a continuación:

- `RAILS_ENV`: configuración del ambiente de Rails (development o production).
- `APP_HOST`: URL donde está hosteada la aplicación. Debe incluir el protocolo (http/https).
- `APP_VERSION`: versión actual de la aplicación.
- `WEBHOOK_KEY`: clave que se utiliza para autenticar llamados de integraciones, para las cuales no hay un usuario logeado.
- `MAILER_DELIVERY_METHOD`: configuración de Rails para elegir cómo se envían los emails. Las opciones son `smtp`, `sendmail`, `file` y `tst`. 
- `SMTP_MAILER_*`: variables para configurar la autenticación con un servidor SMTP para el envío de emails.
- `API_MAILER_*`: variables para configurar la autenticación del servicio de envío de emails, mediante API.

Además, hay variables de ambiente que resultan útiles únicamente en ambientes productivos:

- `DATABASE_URL`: Connection string de la base de datos de la aplicación.
- `SECRET_KEY_BASE`: Clave utilizada por Rails para verificaciones criptográficas. Puede generarse con `rake secret`.
- `RAILS_SERVE_STATIC_FILES`: Configuración de Rails que permite servir archivos estáticos.
- `RAILS_LOG_TO_STDOUT`: Configuración de Rails que indica debería logearse a la salida estándar.

## Jobs programados

La aplicación cuenta con dos jobs (Active Jobs) que están pensandos para que corran todos los días y realicen determinadas acciones.  
Debe configurarse la frecuencia con la que corren y el horario. Se hace en el archivo `config/application.rb`. Pueden verse las opciones disponibles en la [documentación](https://github.com/bensheldon/good_job?tab=readme-ov-file#configuration-options).
