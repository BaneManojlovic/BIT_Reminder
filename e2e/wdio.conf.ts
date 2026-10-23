import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { generate } from 'multiple-cucumber-html-reporter';
import cucumberJson from 'wdio-cucumberjs-json-reporter';

// Built by `npm run build:app`. Override with APP_PATH to test a different build.
const appPath =
    process.env.APP_PATH ??
    path.resolve(__dirname, 'build/Build/Products/Debug-iphonesimulator/BIT Reminder.app');

const deviceName = process.env.IOS_DEVICE_NAME ?? 'iPhone 17';
const platformVersion = process.env.IOS_PLATFORM_VERSION ?? '26.2';

// Each run writes Cucumber JSON to reports/json, which is turned into one HTML
// report in reports/html-reports (report.html, plus a page per feature).
const REPORTS_DIR = path.resolve(__dirname, 'reports');
const JSON_DIR = path.join(REPORTS_DIR, 'json');
const HTML_DIR = path.join(REPORTS_DIR, 'html-reports');
const REPORT_FILE = path.join(HTML_DIR, 'report.html');
const REPORT_TITLE = 'BIT Reminder - E2E Automation Test Report';
// Open the report in the browser after each local run. Skipped on CI, or with E2E_OPEN_REPORT=false.
const SHOW_IN_BROWSER = !process.env.CI && process.env.E2E_OPEN_REPORT !== 'false';

export const config: WebdriverIO.Config = {
    runner: 'local',
    tsConfigPath: './tsconfig.json',

    specs: ['./features/**/*.feature'],
    maxInstances: 1,

    capabilities: [
        {
            platformName: 'iOS',
            'appium:automationName': 'XCUITest',
            'appium:deviceName': deviceName,
            'appium:platformVersion': platformVersion,
            'appium:app': appPath,
            // Start every session from a fresh install so no user is logged in.
            'appium:noReset': false,
            'appium:newCommandTimeout': 240,
            // Shown as the device and platform in the HTML report.
            'cjson:metadata': {
                device: `${deviceName} Simulator`,
                platform: { name: 'ios', version: platformVersion },
            },
        },
    ],

    logLevel: 'info',
    waitforTimeout: 10000,
    connectionRetryTimeout: 120000,
    connectionRetryCount: 3,

    // Starts the local Appium 2 server from node_modules for the test run.
    services: [['appium', { logPath: './logs' }]],

    framework: 'cucumber',
    reporters: [
        'spec', // Keeps the readable terminal output
        // Records results for the HTML report built in onComplete.
        ['cucumberjs-json', { jsonFolder: JSON_DIR, language: 'en' }],
    ],
    cucumberOpts: {
        require: ['./step-definitions/**/*.ts'],
        timeout: 60000,
        failFast: false,
        snippets: true,
        source: true,
        strict: false,
        tags: 'not @ignore',
    },

    // Start each run with an empty reports folder so old results don't mix in.
    onPrepare: () => {
        fs.rmSync(REPORTS_DIR, { recursive: true, force: true });
    },

    // Attach a screenshot to any failed step so it shows in the HTML report.
    afterStep: async (_step, _scenario, result) => {
        if (!result.passed) {
            cucumberJson.attach(await browser.takeScreenshot(), 'image/png');
        }
    },

    onComplete: () => {
        generate({
            jsonDir: JSON_DIR,
            reportPath: HTML_DIR,
            pageTitle: REPORT_TITLE,
            reportName: REPORT_TITLE,
            displayDuration: true,
            customData: {
                title: 'Run info',
                data: [
                    { label: 'App', value: 'BIT Reminder (Debug, simulator)' },
                    { label: 'Device', value: `${deviceName}, iOS ${platformVersion}` },
                    { label: 'Finished', value: new Date().toLocaleString() },
                ],
            },
        });
        // The generator always names its page index.html; keep a copy under the agreed name.
        fs.copyFileSync(path.join(HTML_DIR, 'index.html'), REPORT_FILE);
        if (SHOW_IN_BROWSER) {
            spawn('open', [REPORT_FILE], { detached: true, stdio: 'ignore' }).unref();
        }
    },
};
