#!/usr/bin/env node

const { chromium } = require("playwright");

const url = process.argv[2] || "http://local-www.weboftomorrow.com/";

(async () => {
  const browser = await chromium.launch({
    headless: true,
  });
  const context = await browser.newContext();
  const page = await context.newPage();

  page.setDefaultNavigationTimeout(5000);
  page.setDefaultTimeout(2000);

  const navigationPromise = page.waitForNavigation();

  await page.goto(url);

  await page.setViewportSize({ width: 1920, height: 982 });

  // TODO: Use data-test selectors to verify each page as needed. The below was
  // simply recorded using Headless Recorder chrome plugin.
  await page.waitForSelector(
    ".wot-Base > .wot-Base-bottom > .wot-Base-footer > .wot-Base-content > .wot-BottomFooter"
  );
  await page.click(
    ".wot-Base > .wot-Base-bottom > .wot-Base-footer > .wot-Base-content > .wot-BottomFooter"
  );

  await page.waitForSelector(
    ".wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1) > .wot-ListItem-description"
  );
  await page.click(
    ".wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1) > .wot-ListItem-description"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(1)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(1)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-img"
  );
  await page.click(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-img"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1) > .wot-ListItem-description"
  );
  await page.click(
    ".wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1) > .wot-ListItem-description"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(2)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(2)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-img"
  );
  await page.click(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-img"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(3)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(3)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-caption"
  );
  await page.click(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-caption"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(1)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > section > nav > .wot-ListItem:nth-child(4) > .wot-ListItem-description"
  );
  await page.click(
    ".wot-Base-content > section > nav > .wot-ListItem:nth-child(4) > .wot-ListItem-description"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-caption"
  );
  await page.click(
    ".wot-Base-content > .wot-Top > .wot-Top-logo > .Logo > .Logo-caption"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(2)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > .wot-Toc > nav > .wot-ListItem:nth-child(2)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(1)"
  );
  await page.click(
    ".wot-Base-main > .wot-Base-content > section > nav > .wot-ListItem:nth-child(1)"
  );

  await navigationPromise;

  await page.waitForSelector(
    ".wot-Base-header > .wot-Base-content > .wot-Top > .wot-Top-logo > .Logo"
  );
  await page.click(
    ".wot-Base-header > .wot-Base-content > .wot-Top > .wot-Top-logo > .Logo"
  );

  await navigationPromise;

  await browser.close();
})().catch((err) => {
  console.log("error", err);
  process.exit(1);
});
