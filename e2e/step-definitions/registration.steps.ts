import { Then, When } from '@wdio/cucumber-framework';
import { $, expect } from '@wdio/globals';
import { dismissKeyboard } from '../support/keyboard';
import { withTimestamp } from '../support/registration';

const fieldIds: Record<string, string> = {
    name: 'registration_name_input',
    email: 'registration_email_input',
    password: 'registration_password_input',
    'repeat password': 'registration_repeat_password_input',
};

When('I open the registration screen', async () => {
    await $('~login_register_button').click();
    await $('~registration_title_label').waitForDisplayed();
});

When('I enter {string} into the registration {string} field', async (value: string, field: string) => {
    const id = fieldIds[field];
    if (!id) throw new Error(`Unknown registration field "${field}"`);
    // Typing into a field ends editing on the previous one, which runs the app's validation.
    await $(`~${id}`).setValue(withTimestamp(value));
    // The last field has nothing after it, so close the keyboard to end editing.
    if (field === 'repeat password') await dismissKeyboard();
});

When('I tap the register button', async () => {
    await dismissKeyboard();
    await $('~registration_submit_button').click();
});

Then('the register button is disabled', async () => {
    await expect($('~registration_submit_button')).toBeDisabled();
});

Then('the register button is enabled', async () => {
    await expect($('~registration_submit_button')).toBeEnabled();
});
