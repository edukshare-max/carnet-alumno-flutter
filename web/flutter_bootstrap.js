{{flutter_js}}
{{flutter_build_config}}

console.log('🚀 Carnet Digital UAGro v3.0 FINAL - JWT AUTH FIXED - BOOTSTRAP METHOD');

// Clear all storage before starting
if (typeof localStorage !== 'undefined') {
  try { localStorage.clear(); } catch(e) {}
}
if (typeof sessionStorage !== 'undefined') {
  try { sessionStorage.clear(); } catch(e) {}
}

// Clear caches
if ('caches' in window) {
  caches.keys().then(function(names) {
    names.forEach(function(name) {
      caches.delete(name);
    });
  });
}

// Create loading indicator
const loading = document.createElement('div');
loading.id = 'flutter_loading';
loading.style.cssText = 'position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); font-family: Arial, sans-serif; text-align: center; z-index: 9999;';
loading.innerHTML = '<div>🚀 Carnet Digital UAGro v3.0 FINAL</div><div>Loading...</div>';
document.body.appendChild(loading);

// Official Flutter loader API with custom bootstrap
_flutter.loader.load({
  config: {
    renderer: 'html'
  },
  onEntrypointLoaded: async function(engineInitializer) {
    if (loading) loading.innerHTML = '<div>🚀 Carnet Digital UAGro v3.0 FINAL</div><div>Initializing engine...</div>';
    
    const appRunner = await engineInitializer.initializeEngine({
      renderer: 'html'
    });
    
    if (loading) loading.innerHTML = '<div>🚀 Carnet Digital UAGro v3.0 FINAL</div><div>Running app...</div>';
    
    await appRunner.runApp();
    
    // Remove loading indicator
    if (loading) loading.remove();
  }
});