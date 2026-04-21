# Custom nginx-proxy Image

Esta es una imagen personalizada de `jwilder/nginx-proxy` que incluye optimizaciones para procesos largos y subidas de archivos grandes.

## Características

- Base: `jwilder/nginx-proxy:alpine`
- **Configuraciones incluidas:**
  - `client_max_body_size 0;` (Sin límite de tamaño de subida)
  - `proxy_read_timeout 600s;`
  - `proxy_connect_timeout 600s;`
  - `proxy_send_timeout 600s;`

## Build y Push (Multi-plataforma)

Para construir y subir la imagen para múltiples arquitecturas (AMD64, ARM64 de Mac, y Raspberry Pi):

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t jefecito/nginx-proxy:latest \
  --push .
```

### Notas sobre Arquitecturas:
- **`linux/amd64`**: Para equipos con procesadores Intel/AMD (ej. tu Asus con AMD).
- **`linux/arm64`**: Para equipos Apple Silicon (Mac M1/M2/M3/M4) y Raspberry Pi con OS de 64 bits.
- **`linux/arm/v7`**: Para modelos antiguos de Raspberry Pi o sistemas de 32 bits.

> [!TIP]
> Si recibes un error sobre `buildx` no encontrado, consulta la sección de resolución de problemas o asegúrate de tenerlo instalado y configurado como plugin de Docker.


## Uso

En tu `docker-compose.yml`, simplemente utiliza la imagen:

```yaml
services:
  nginx-proxy:
    image: jefecito/nginx-proxy:latest
    # ... resto de la configuración
```
