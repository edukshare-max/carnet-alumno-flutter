# Carnet Alumno Flutter

Aplicación web para la gestión del carnet de alumno.

## Desarrollo Local

Para ejecutar la aplicación localmente:

```bash
flutter pub get
flutter run -d chrome  # o flutter run -d edge
```

## Despliegue

La aplicación se despliega automáticamente a GitHub Pages cuando se hace push a la rama principal (main/master). El despliegue está configurado para:

1. Construir la aplicación web de Flutter
2. Configurar la URL base correcta para GitHub Pages
3. Configurar la URL del backend
4. Publicar en la rama gh-pages

### URL de la Aplicación

La aplicación está disponible en: https://edukshare-max.github.io/carnet_alumno/

### Configuración SPA

La aplicación está configurada como Single Page Application (SPA) con soporte para rutas en GitHub Pages mediante:

- Configuración de base href en index.html
- Archivo 404.html para manejo de rutas
- Script de redirección SPA

## Backend

La aplicación se conecta al backend desplegado en:
https://alumno-backend-node.onrender.com