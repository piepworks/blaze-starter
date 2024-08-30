/* eslint-disable no-unused-vars */
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker
      .register('/sw.js')
      .then((registration) => {
        // console.log('SW registration', registration);
        navigator.serviceWorker.ready.then((registration) => {
          // console.log('SW is active', registration.active)
        });
      })
      .catch((registrationError) => {
        // console.log('SW registration failed', registrationError);
      });
  });
}
