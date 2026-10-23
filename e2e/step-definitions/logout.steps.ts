import { Given, Then, When } from '@wdio/cucumber-framework';
import { $, browser, expect } from '@wdio/globals';
import { loginWithTestAccount } from '../support/login';

const BUNDLE_ID = 'com.bitnovisad.bitreminder';

// Settings rows are built in this order: Profile, Privacy Policy, Logout.
const LOGOUT_ROW = 'settings_cell_row_2';

// Setup

Given('the user is logged in with the test account', async () => {
    await loginWithTestAccount();
});

Given('the user navigates to the Settings tab', async () => {
    await $('~tab_settings').click();
    await $('~settings_table_view').waitForDisplayed({ timeout: 10000 });
});

// Actions

When('the user taps the logout option', async () => {
    await $(`~${LOGOUT_ROW}`).click();
});

// The confirmation is a system alert, so its buttons are found by their labels.
When('the user confirms the logout', async () => {
    await $('~Yes').click();
});

When('the user cancels the logout', async () => {
    await $('~Cancel').click();
});

When('the app is restarted', async () => {
    await browser.terminateApp(BUNDLE_ID);
    await browser.activateApp(BUNDLE_ID);
    // Splash decides between Login and Home based on the saved session.
    await browser.waitUntil(
        async () =>
            (await $('~login_title_label').isDisplayed()) ||
            (await $('~home_screen_container').isDisplayed()),
        { timeout: 20000, timeoutMsg: 'App did not leave the Splash screen after restart' },
    );
});

// Assertions

Then('the logout confirmation {string} is shown', async (message: string) => {
    await expect($(`~${message}`)).toBeDisplayed();
});
