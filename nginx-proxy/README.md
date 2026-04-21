# Custom nginx-proxy Image

Esta es una imagen personalizada de `jwilder/nginx-proxy` que incluye optimizaciones para procesos largos y subidas de archivos grandes.

## Características

- Base: `jwilder/nginx-proxy:alpine`
- **Configuraciones incluidas:**
  - `client_max_body_size 0;` (Sin límite de tamaño de subida)
  - `proxy_read_timeout 600s;`
  - `proxy_connect_timeout 600s;`
  - `proxy_send_timeout 600s;`

## Build y Push

Para construir y subir la imagen al registro:

```bash
# Definir el nombre y tag de la imagen
IMAGE_NAME="jefecito/nginx-proxy"
TAG="latest"

# Construir la imagen
docker build -t ${IMAGE_NAME}:${TAG} .

# Subir la imagen
docker push ${IMAGE_NAME}:${TAG}
```

## Uso

En tu `docker-compose.yml`, simplemente utiliza la imagen:

```yaml
services:
  nginx-proxy:
    image: jefecito/nginx-proxy:latest
    # ... resto de la configuración
```
