/* {% load static %} */
/* global importScripts, workbox */
importScripts(`{% static 'js/vendor/workbox-v7.1.0/workbox-sw.js' %}`);

workbox.setConfig({
  modulePathPrefix: '{% get_static_prefix %}js/vendor/workbox-v7.1.0',
});

workbox.routing.registerRoute(
  ({ request }) => request.destination === 'image',
  new workbox.strategies.CacheFirst(),
);

workbox.routing.setDefaultHandler(new workbox.strategies.NetworkFirst());

workbox.recipes.offlineFallback({
  pageFallback: `{% url 'offline' %}`,
});

// ---

const strategy = new workbox.strategies.CacheFirst();

const urls = [`{% static 'css/main.css' %}`, `{% url 'index' %}`];

workbox.recipes.warmStrategyCache({ urls, strategy });
