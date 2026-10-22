import { Given, Then, When } from '@wdio/cucumber-framework';
import { $, browser, expect } from '@wdio/globals';

const BUNDLE_ID = 'com.bitnovisad.bitreminder';
const APP_RUNNING_IN_FOREGROUND = 4;

// The login button only enables once a field ends editing, so the keyboard
// has to be closed. hideKeyboard() is tried first; if it can't find a key to
// press, we tap the "Done" button on IQKeyboardManager's toolbar above the keyboard.
export async function dismissKeyboard(): Promise<void> {
    if (!(await browser.isKeyboardShown())) return;
    try {
        await browser.hideKeyboard();
    } catch {
        // Falls through to the toolbar button below.
    }
    if (await browser.isKeyboardShown()) {
        await $('~Done').click();
    }
}

// Background

Given('the user is on the Splash screen', async () => {
    // The splash screen has no identifiers yet, so check that the app is up and in front.
    expect(await browser.queryAppState(BUNDLE_ID)).toBe(APP_RUNNING_IN_FOREGROUND);
});

When('the app finishes loading', async () => {
    // Splash checks the saved session with Supabase before showing Login.
    await $('~login_title_label').waitForDisplayed({ timeout: 20000 });
});

Then('the user should see the Login screen', async () => {
    await expect($('~login_title_label')).toBeDisplayed();
});

// Actions

When('I enter {string} into the email field', async (email: string) => {
    await $('~login_email_input').setValue(email);
});

When('I enter {string} into the password field', async (password: string) => {
    await $('~login_password_input').setValue(password);
    await dismissKeyboard();
});

When('I tap the submit button', async () => {
    // Make sure the keyboard can't cover the button and swallow the tap.
    await dismissKeyboard();
    await $('~login_submit_button').click();
});

// Assertions

Then('the login button is disabled', async () => {
    await expect($('~login_submit_button')).toBeDisabled();
});

Then('I should be redirected to the Home screen dashboard', async () => {
    // Login waits on Supabase, so allow for the loading spinner.
    await $('~home_screen_container').waitForDisplayed({ timeout: 20000 });
});

Then('I should see the email error label with text {string}', async (message: string) => {
    await expect($('~login_email_error')).toHaveText(message);
});
