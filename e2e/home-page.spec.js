// @ts-check
import { test, expect } from '@playwright/test';

test('logged in home page / light mode', async ({ page }) => {
  await page.goto('./');
  await page.emulateMedia({ colorScheme: 'light' });
  await expect(page).toHaveScreenshot('home-page-light.png', {
    fullPage: true,
  });
});

test('logged in home page / dark mode', async ({ page }) => {
  await page.goto('./');
  await page.emulateMedia({ colorScheme: 'dark' });
  await expect(page).toHaveScreenshot('home-page-dark.png', { fullPage: true });
});
