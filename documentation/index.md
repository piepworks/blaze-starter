# Blaze.horse Django Starter Kit Documentation

## Installation

```shell
/bin/bash -c "$(curl -fsSL https://blaze.horse/django-starter/install)"
```

Then follow the instructions it gives you.

## Tailwind

We're now shying away from Tailwind and its problematic leadership and trying to get back to our roots in web standards. Because of that, a very simple PostCSS configuration is set up with traditionally Sass-like features (`@imports` and [CSS-spec-compatible] nesting).

However, if you still want to use Tailwind (no judgement), here's how you can do it.

[Setup Tailwind](tailwind.md)

## Deployment

- [Fly](deployment/fly.md)

Why no AWS? We don't believe you should use it. We do our best to not give Amazon any money if we can help it.

## Update Workbox

- `npx workbox-cli copyLibraries static/js/vendor/`
- Update paths in `templates/js/sw.js` as needed.

Further reading:

- [Using Local Workbox Files Instead of CDN](https://developer.chrome.com/docs/workbox/modules/workbox-sw/#using-local-workbox-files-instead-of-cdn)
- [workbox-cli’s copylibraries option](https://developer.chrome.com/docs/workbox/modules/workbox-cli/#copylibraries)
