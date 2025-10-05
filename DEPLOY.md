# UAGro Carnet - Despliegue Automático

## 🌐 URL Pública
**https://app.carnetdigital.space**

## 🤖 CI/CD Automático
- **Trigger**: Push a rama `main`
- **Build**: Flutter Web con backend de Render
- **Deploy**: GitHub Pages con dominio personalizado
- **SPA**: Fallback 404.html para enrutado Flutter

## ⚙️ Configuración DNS
```
Host: app
Type: CNAME  
Value: edukshare-max.github.io
TTL: Auto (300s)
```

## 🧪 Credenciales de Prueba
- **Email**: `ejemplo@gmail.com`
- **Matrícula**: `2025`

## 🔧 Configuración GitHub Pages
1. **Settings** → **Pages**
2. **Source**: GitHub Actions (no "Deploy from a branch")
3. **Custom domain**: `app.carnetdigital.space`
4. **Enforce HTTPS**: ✅

## 📱 Funcionalidades
- ✅ Login JWT con backend
- ✅ Consulta de carnet estudiantil  
- ✅ Visualización de citas médicas
- ✅ Sesión persistente
- ✅ Logout funcional
- ✅ SPA routing completo

## 🛠️ Build Local
```bash
flutter build web --release --dart-define=STUDENT_API_BASE_URL=https://alumno-backend-node.onrender.com
```

## 📊 Monitoreo
- **Backend**: https://alumno-backend-node.onrender.com/_health
- **Frontend**: https://app.carnetdigital.space
- **CI/CD**: GitHub Actions workflow