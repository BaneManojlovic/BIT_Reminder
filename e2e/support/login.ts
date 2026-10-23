import { $ } from '@wdio/globals';
import { dismissKeyboard } from './keyboard';

// Static account registered through the app, so it has a profiles row.
// Override with E2E_EMAIL / E2E_PASSWORD to use a different account.
export const TEST_ACCOUNT = {
    email: process.env.E2E_EMAIL ?? 'testingone@gmail.com',
    password: process.env.E2E_PASSWORD ?? 'Password123!',
};

// Signs in from the Login screen and waits for Home.
export async function loginWithTestAccount(): Promise<void> {
    await $('~login_title_label').waitForDisplayed({ timeout: 20000 });
    await $('~login_email_input').setValue(TEST_ACCOUNT.email);
    await $('~login_password_input').setValue(TEST_ACCOUNT.password);
    await dismissKeyboard();
    await $('~login_submit_button').click();
    await $('~home_screen_container').waitForDisplayed({ timeout: 20000 });
}
