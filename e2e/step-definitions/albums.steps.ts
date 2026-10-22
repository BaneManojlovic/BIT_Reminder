import { Given, Then, When } from '@wdio/cucumber-framework';
import { $, browser, expect } from '@wdio/globals';
import { dismissKeyboard } from './login.steps';

// Selectors follow e2e/playbooks/ALBUMS_FEATURE.md.
const ids = {
    albumsTable: 'albums_table_view',
    albumRow: (index: number) => `albums_cell_row_${index}`,
    photoGrid: 'albums_collection_view_grid',
    photoItem: (index: number) => `albums_photo_item_${index}`,
    addPhotoButton: 'albums_btn_trigger_picker',
    fullImage: 'albums_full_image_viewer',
    backButton: 'albums_btn_back',
};

// Test account with at least one album that contains at least one photo.
const TEST_EMAIL = process.env.E2E_EMAIL ?? 'testuser@example.com';
const TEST_PASSWORD = process.env.E2E_PASSWORD ?? 'Password123!';

// Playbook rule: rows/cells deeper than index 3 need a scroll before the visibility check.
const SCROLL_THRESHOLD = 3;
const MAX_SCROLLS = 5;

async function revealItem(id: string, index: number) {
    const item = $(`~${id}`);
    if (index > SCROLL_THRESHOLD) {
        for (let i = 0; i < MAX_SCROLLS && !(await item.isDisplayed()); i++) {
            await browser.execute('mobile: scroll', { direction: 'down' });
        }
    }
    await item.waitForDisplayed();
    return item;
}

// Setup

Given('the user is logged into the application', async () => {
    await $('~login_title_label').waitForDisplayed({ timeout: 20000 });
    await $('~login_email_input').setValue(TEST_EMAIL);
    await $('~login_password_input').setValue(TEST_PASSWORD);
    await dismissKeyboard();
    await $('~login_submit_button').click();
    await $('~home_screen_container').waitForDisplayed({ timeout: 20000 });
});

Given('the user navigates to the Albums tab', async () => {
    // The playbook defines no ID for the tab bar, so this uses the tab's visible label.
    await $('~Album').click();
    await $(`~${ids.albumsTable}`).waitForDisplayed({ timeout: 10000 });
});

Given('the user is looking at a full screen image view', async () => {
    await (await revealItem(ids.albumRow(0), 0)).click();
    await (await revealItem(ids.photoItem(0), 0)).click();
    await $(`~${ids.fullImage}`).waitForDisplayed();
});

// Actions

When('the user selects the album at index {string}', async (index: string) => {
    const i = Number(index);
    await (await revealItem(ids.albumRow(i), i)).click();
});

When('the user selects the photo item at index {string}', async (index: string) => {
    const i = Number(index);
    await (await revealItem(ids.photoItem(i), i)).click();
});

When('the user taps the add photo option', async () => {
    // Opens the system photo picker. Per the playbook, anything inside the picker
    // is found by its native labels, not our IDs.
    await $(`~${ids.addPhotoButton}`).click();
});

When('the user taps the back navigation button', async () => {
    await $(`~${ids.backButton}`).click();
});

// Assertions

Then('the {string} element should be visible', async (id: string) => {
    await expect($(`~${id}`)).toBeDisplayed();
});

Then('the full size image element should be rendered', async () => {
    await expect($(`~${ids.fullImage}`)).toBeDisplayed();
});

Then('the gallery grid canvas {string} should be displayed again', async (id: string) => {
    await expect($(`~${id}`)).toBeDisplayed();
});
