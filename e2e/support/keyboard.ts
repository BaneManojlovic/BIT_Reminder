import { $, browser } from '@wdio/globals';

// Text fields in the app only validate once editing ends, so tests have to close
// the keyboard. hideKeyboard() is tried first; if it can't find a key to press,
// we tap the "Done" button on IQKeyboardManager's toolbar above the keyboard.
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
