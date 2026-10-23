import { Given, Then, When } from '@wdio/cucumber-framework';
import { $, browser, expect } from '@wdio/globals';
import { registerFreshUser, withTimestamp } from '../support/registration';

// Selectors follow e2e/playbooks/ALBUMS_FEATURE.md.
const ids = {
    albumsTable: 'albums_table_view',
    albumRow: (index: number) => `albums_cell_row_${index}`,
    photoGrid: 'albums_collection_view_grid',
    photoItem: (index: number) => `albums_photo_item_${index}`,
    createAlbumButton: 'albums_btn_create_album',
    addPhotoButton: 'albums_btn_trigger_picker',
    fullImage: 'albums_full_image_viewer',
    backButton: 'albums_btn_back',
};

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

// System UI has no app identifiers, so these use native element types and labels
// (allowed by the playbook for out-of-app screens).
const ALERT_TEXT_FIELD = '-ios class chain:**/XCUIElementTypeAlert/**/XCUIElementTypeTextField';
const PICKER_PHOTO = '-ios predicate string:type == "XCUIElementTypeImage" AND label BEGINSWITH "Photo, "';

async function isShownWithin(id: string, timeout: number): Promise<boolean> {
    return $(`~${id}`).waitForDisplayed({ timeout }).then(() => true, () => false);
}

// Fresh test users start with no albums, so create one when the list is empty.
async function ensureAlbumExists() {
    if (await isShownWithin(ids.albumRow(0), 5000)) return;
    await $(`~${ids.createAlbumButton}`).click();
    await $(ALERT_TEXT_FIELD).setValue(withTimestamp('E2E Album <timestamp>'));
    await $('~Create').click();
    await $(`~${ids.albumRow(0)}`).waitForDisplayed({ timeout: 15000 });
}

// New albums are empty, so upload one of the simulator's sample photos when needed.
async function ensurePhotoExists() {
    if (await isShownWithin(ids.photoItem(0), 5000)) return;
    await $(`~${ids.addPhotoButton}`).click();
    await $('~Choose photo from library').click();
    const photo = $(PICKER_PHOTO);
    await photo.waitForExist({ timeout: 15000 });
    // Picker photos live in another process and ignore element clicks, so tap their center.
    const rect = await browser.getElementRect(await photo.elementId);
    await browser.execute('mobile: tap', {
        x: Math.round(rect.x + rect.width / 2),
        y: Math.round(rect.y + rect.height / 2),
    });
    // The app asks the picker for an edited image, which adds a crop screen.
    // Its "Choose" button can ignore taps while the screen animates in, so retry
    // until the crop screen has closed.
    const choose = $('~Choose');
    await choose.waitForDisplayed({ timeout: 10000 });
    for (let attempt = 0; attempt < 3 && (await choose.isExisting()); attempt++) {
        await choose.click();
        await browser.pause(1500);
    }
    // Upload goes to Supabase storage first, so allow for the network.
    await $(`~${ids.photoItem(0)}`).waitForDisplayed({ timeout: 30000 });
}

// Setup

Given('the user is logged into the application', async () => {
    // A freshly registered user always has a profile row, unlike accounts created
    // in the Supabase dashboard, which caused the 406/409 errors.
    await registerFreshUser();
});

Given('the user navigates to the Albums tab', async () => {
    await $('~tab_album').click();
    await $(`~${ids.createAlbumButton}`).waitForDisplayed({ timeout: 10000 });
});

Given('the user has at least one album', async () => {
    await ensureAlbumExists();
});

Given('the album has at least one photo', async () => {
    await ensurePhotoExists();
});

Given('the user is looking at a full screen image view', async () => {
    await (await revealItem(ids.albumRow(0), 0)).click();
    await ensurePhotoExists();
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
