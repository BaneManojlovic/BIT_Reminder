import path from 'node:path';

// Built by `npm run build:app`. Override with APP_PATH to test a different build.
const appPath =
    process.env.APP_PATH ??
    path.resolve(__dirname, 'build/Build/Products/Debug-iphonesimulator/BIT Reminder.app');

export const config: WebdriverIO.Config = {
    runner: 'local',
    tsConfigPath: './tsconfig.json',

    specs: ['./features/**/*.feature'],
    maxInstances: 1,

    capabilities: [
        {
            platformName: 'iOS',
            'appium:automationName': 'XCUITest',
            'appium:deviceName': process.env.IOS_DEVICE_NAME ?? 'iPhone 17',
            'appium:platformVersion': process.env.IOS_PLATFORM_VERSION ?? '26.2',
            'appium:app': appPath,
            // Start every session from a fresh install so no user is logged in.
            'appium:noReset': false,
            'appium:newCommandTimeout': 240,
        },
    ],

    logLevel: 'info',
    waitforTimeout: 10000,
    connectionRetryTimeout: 120000,
    connectionRetryCount: 3,

    // Starts the local Appium 2 server from node_modules for the test run.
    services: [['appium', { logPath: './logs' }]],

    framework: 'cucumber',
    reporters: ['spec'],
    cucumberOpts: {
        require: ['./step-definitions/**/*.ts'],
        timeout: 60000,
        failFast: false,
        snippets: true,
        source: true,
        strict: false,
        tags: 'not @ignore',
    },
};
