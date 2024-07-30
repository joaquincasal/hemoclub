# Documentación técnica

Se documentan aquí las tecnologías utilizadas en el proyecto, el motivo de su elección y algunas decisiones de arquitectura.

## Tecnologías

Ruby on Rails es la tecnología principal: se utiliza tanto para el servidor como para el frontend (mediante templates .erb).

Otras tecnologías utilizadas:

- [Bulma](https://github.com/jgthms/bulma) como framework de CSS.
- [StimulusReflex](https://github.com/stimulusreflex/stimulus_reflex) para interfaces web reactivas. 
- [Good Job](https://github.com/bensheldon/good_job) como cola de jobs asincrónicos.
- [Devise](https://github.com/heartcombo/devise) para autenticación.
- [Tinymce](https://github.com/spohlenz/tinymce-rails) para editor de plantillas html.

### Good job

La aplicación utiliza jobs asincrónicos para procesos lentos que bloquearían la ejecución de la aplicación de ejecutarse en el hilo de la aplicación web.

Al momento de elegir el backend a utilizar con Active Job hay varias opciones bien conocidas: Resque, Sidekiq y Delayed Job, solo por mencionar algunos.  
Una feature que resultó clave para la elección de Good Job es que utiliza Postgres como base de datos, mientra que la mayoría de las otras opciones utilizan Redis. Esto permite simplificar el despliegue de la aplicación, al tener menos dependencias de infraestructura y reducir costos.  
La otra feature que era necesaria era la capacidad de ejecutar jobs asincrónicos de manera programada. Por ejemplo, que todos los días a determinada hora corra un job específico.  
Por último, este tipo de herramientas suelen correr en un proceso worker, separado del proceso de la aplicación web. Good Job ofrece esa opción, pero también el modo de ejecución "async", el cual utiliza hilos del proceso web para la ejecución de los jobs.  
Dada la carga esperada de la aplicación (la aplicación web será utilizada únicamente por dos personas y de forma poco frecuente), se concluyó que esta opción es suficiente y permite no tener un proceso separado.

### StimulusReflex

A partir de Rails 7, Stimulus se incluye por defecto en las aplicaciones Rails. Stimulus es parte del combo [Hotwire](https://hotwired.dev/), cuyo enfoque es escribir poca cantidad de Javascript e igualmente mantener la interactividad de la aplicación.  
Más allá de esto, se decidió también incluir a StimulusReflex en el proyecto. El motivo principal es que permite utilizar websockets para hacer cambios en la vista, sin la necesidad de que haya una request http de por medio (como sí es necesario con Stimulus).
Por defecto, StimulusReflex necesita una instancia de Redis para poder funcionar. Sin embargo, [recientemente](https://github.com/stimulusreflex/stimulus_reflex/pull/703) se documentó que puede utilizarse [Solid Cache](https://github.com/rails/solid_cache) en su lugar.

### Solid Cache

Rails ofrece varias stores para manejar el caché, siendo `Memcache store` y `Redis cache store` las opciones más comunes para ambientes productivos.  
La decisión de utilizar `Solid cache` se da por la posibilidad de utilizar StimulusReflex sin una instancia de Redis.

### Base de datos

Las bases de datos por defecto a utilizar en una aplicación Rails suelen ser Postgres o MySql.  
Solid cache funciona con ambas, pero Good Job funciona específicamente con Postgres, por lo cual la aplicación usa una base de datos Postgres.  
Otra posibilidad podría ser utilizar [Solid queue](https://github.com/rails/solid_queue) en lugar de Good Job. Al momento del desarrollo, Solid Queue era muy nueva y no tenía las features necesarias ya mencioandas. Sin embargo, una vez que sea más estable podría considerarse una migración para no atarse a una única base de datos.

## Infraestructura

Por las decisiones ya mencionadas, la aplicación puede correr con todos sus componentes utilizando únicamente un servidor web Rails y una base de datos Postgres.  
Esto permite reducir costos de infraestructura, lo cual era un requerimiento central de este proyecto.

Para el envío de los emails se utiliza la API de Azure Communication Services, que permite la configuración de dominios propios y remitentes personalizados.

### Despliegue

Se cuentan con dos ambientes: uno de testing y otro de producción. El ambiente de testing utiliza Heroku y el de producción usa Azure.  
El proyecto cuenta con Github Actions para el despliegue automático a ambos ambientes.  
El despliegue a testing se desencadena al generar un tag. El despliegue a producción se desencadena al generar un release.

Para el despliegue de ambos ambientes se utiliza una imagen docker. Al realizar el despliegue a testing, se genera una imagen y se guarda en Dockerhub. Luego, al realizar el despliegue a producción se reutiliza esa misma imagen.
