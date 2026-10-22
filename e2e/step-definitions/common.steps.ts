import { Then } from '@wdio/cucumber-framework';
import { $, expect } from '@wdio/globals';

// Generic check for any element tagged with an accessibilityIdentifier.
Then('the {string} element is displayed', async (id: string) => {
    await expect($(`~${id}`)).toBeDisplayed();
});
