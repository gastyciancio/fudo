# API

Esta es una aplicación Rack simple que proporciona una API con autenticación.

## How to Run

Existen dos formas:

1. Sin usar docker:
- Crear un archivo .env en la raiz del proyecto y completar las variables de entorno de acuerdo al archivo .env-example. Los valores de las variables son a gusto del usuario para probar la validacion del usuario.
- Ejecutar 'bundle install'.
- Ejecutar rackup.

2. Usando docker:
- Crear un archivo .env en la raiz del proyecto y completar las variables de entorno de acuerdo al archivo .env-example. Los valores de las variables son a gusto del usuario para probar la validacion del usuario.
- Ejecutar docker build -t app-ciancio-fudo . ('app-ciancio-fudo puede ser cualquier otro nombre que no exista previamente')
- Ejecutar docker run -p 9292:9292 app-ciancio-fudo
