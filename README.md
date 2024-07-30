# Hemoclub

## Descripción

Hemoclub es una aplicación web que permite crear campañas de marketing mediante el envío de emails.
El dominio para el cual fue construida es el de la donación de sangre, ya que fue construida para la Fundación Hemocentro de Buenos Aires.

### Features principales

- Creación de campañas de emails que se envíen de forma automática al cumplirse los parámetros elegidos al momento de su creación.
- Creación de campañas de única vez, que no se repitan automáticamente, por ejemplo para poder comunicar de una colecta externa de sangre a donantes aptos.
- Segmentación de donantes para permitir creación de listas según necesidad, utilizando filtros sobre los datos disponibles de los donantes, sus donaciones y las comunicaciones que se les enviaron.
- Panel de informes con visualizaciones de datos sobre la información que se tiene sobre los donantes, donaciones y comunicaciones enviadas.
- Creación de plantillas de emails para su utilización en campañas, permitiendo personalizar los emails enviados con información del donante.
- Importación masiva de donantes y donaciones.
- Visualización de datos de las campañas enviadas, permitiendo ver si las mismas fueron leidas por los donantes y también si los emails se están entregando correctamente.
- Actualización de información de los donantes mediante links en los emails, para que no sea necesario editar manualmente.

## Ambiente de desarrollo

### Requerimientos

- Docker
- Docker compose

### Correr el proyecto

El proyecto incluye un archivo `docker-compose.yml` para correr el ambiente local. Incluye un servicio `web` para la aplicación web y un servicio `postgres` para la base de datos.

Para correr el proyecto:

1. Correr los servicios: `docker compose up -d`
2. Ingresar al container web: `docker compose exec -it web bash`

Una vez dentro del container, pueden correrse distintos comandos:

- Setup de la base de datos: `bundle exec rake db:setup`
- Correr linter: `rubocop`
- Correr tests: `rake spec`

## Documentación

- [Diseño y modelado](doc/modelo.md)
- [Tecnologías utilizadas](doc/tecnologias.md)
- [Configuraciones productivas](doc/configuracion.md)
- [Manual de usuario](doc/manual%20de%20usuario.md)

## Licencia

[MIT](https://choosealicense.com/licenses/mit/)
