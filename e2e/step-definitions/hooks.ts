import { Before } from '@wdio/cucumber-framework';
import { browser } from '@wdio/globals';

let isFirstScenario = true;

// Give every scenario a fresh app. With noReset: false, a new session reinstalls
// the app, so no login session or leftover screen state carries over.
// The first scenario already starts with a brand-new session, so it's skipped.
Before(async () => {
    if (isFirstScenario) {
        isFirstScenario = false;
        return;
    }
    await browser.reloadSession();
});
