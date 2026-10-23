import { $ } from '@wdio/globals';
import { dismissKeyboard } from './keyboard';

// Replaces "<timestamp>" with the current time so every run registers a new email,
// e.g. "testingone+<timestamp>@gmail.com" -> "testingone+1761217200000@gmail.com".
export function withTimestamp(value: string): string {
    return value.replace('<timestamp>', String(Date.now()));
}

// Registers a brand-new account through the app, starting from the Login screen.
// The app creates the user's profile row during registration, so later
// album/reminder requests have a valid profile to point to.
export async function registerFreshUser(): Promise<void> {
    await $('~login_title_label').waitForDisplayed({ timeout: 20000 });
    await $('~login_register_button').click();
    await $('~registration_title_label').waitForDisplayed();
    await $('~registration_name_input').setValue('Test User');
    await $('~registration_email_input').setValue(withTimestamp('testingone+<timestamp>@gmail.com'));
    await $('~registration_password_input').setValue('Password123!');
    await $('~registration_repeat_password_input').setValue('Password123!');
    await dismissKeyboard();
    await $('~registration_submit_button').click();
    await $('~home_screen_container').waitForDisplayed({ timeout: 20000 });
}
