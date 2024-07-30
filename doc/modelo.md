# Modelo

Se documenta aquí lo más relevante del diseño elegido para la solución.

## Diagrama de clases

![Diagrama de claes](img/diagrama%20de%20clases.png)

### Interpretación

- Un `Donante` puede tener múltiples `Donaciones`. Entre ambas entidades contienen toda la información que se importa al sistema.
  - Una `Donacion` puede tener destino una `Clinica` específica.
- Los `Donantes` pueden tener `Exclusiones`, que representan motivos temporales por los cuales los donantes no pueden donar (por ejemplo, una cirugía).
  - Las `Exclusiones Tipicas` permiten crear las exclusiones más comunes para luego asignarlas a los donantes.
- Una `Comunicacion` consiste de una `Lista` y una `Plantilla`. La lista define a quién se envía y la plantilla define qué se envía.
  - `Automatizacion`: se ejecuta automáticamente todos los días. Se envía una única vez por donante y por donación (cuando un donante dona nuevamente, la automatización vuelve a enviarse a ese donante).
  - `Campania`: se ejecuta manualmente.
- `Plantilla`: representa el contenido de los emails que se envían. Puede contener otras plantillas que se utilizan como encabezado o como firma.
- `Lista`: se encarga de seleccionar a los donantes correspondientes en base a los filtros seleccionados por el usuario.
- Una `Comunicacion` puede tener múltiples `Ejecuciones`, que representan las veces que esa comunicación se envío.
  - A su vez, cada `Ejecucion` puede tener múltiples `Interacciones`, que representan la inclusión de un `Donante` en una `Ejecucion` (es decir, en esa ejecucion se contactó al donante).
- Los `Filtros` consisten de múltiples parámetros seleccionados por el usuario, que luego son interpretados y utilizados para realizar los filtrados correspondientes.
  - Existen cuatro tipos de filtros que pueden utilizarse: `Filtro por atributo` (de donante), `Filtro por ultima donacion`, `Filtro por interaccion` y `Filtro por cumpleaños`.

## Otras entidades importantes

Además del modelo ya comentado, existen otras entidades relevantes en el código de la aplicación.

- `Usuario`: representa a los usuarios administradores del sistema. 
- `Importador`: contiene la lógica de conversión del archivo de entrada.
- `Informes`: contiene las queries para los distintos reportes mostrados en la aplicación.
- `Mailer`: se encarga de consumir la API de emails.

## Jobs asincrónicos

Se utilizan jobs asincrónicos para procesos lentos que bloquearían la ejecución de la aplicación de ejecutarse en el hilo de la aplicación web.

### Programados

Estos jobs corren todos los días automáticamente.

- `ActualizarDonantesJob`: cambia el tipo de donante de "club" a "voluntario" si el donante no dona sangre hace más de un año.
- `EnviarAutomatizacionesJob`: busca todas las `Automatizaciones` activa y llama al método que las envía.

### Ejecutados manualmente

Para que estos jobs se ejecuten hay que llamarlos desde el código.

- `EnviarComunicacionJob`: utilizado para enviar los emails a todos los donantes de una `Ejecución` particular. Por cada donante llama a `EnviarEmailJob`.
- `EnviarEmailJob`: envía el email recibido al donante recibido.

## Integraciones

La aplicación cuenta con dos controllers pensados para recibir webhooks de otros sistemas.

- `InteraccionesController`: recibe avisos de parte de Azure Communication Services sobre el estado del envío de los emails (email entregado, email enviado a spam, etc.).
- `CandidatosController`: recibe notificaciones cuando una persona completa un formulario en la web del Hemocentro indicando interés en ser donante de sangre. Cuando sucede, se crea un `Donante` y se lo marca como "candidato".