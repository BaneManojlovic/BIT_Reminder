# AI Testing Rules for BIT Reminder

## Tech Stack
- Frontend: iOS Native (Swift, UIKit, SwiftUI)
- Test Framework: Appium 2.x + WebdriverIO + Cucumber.js (BDD Gherkin)
- Language: TypeScript

## Automation Rules
- Do NOT write web-based Playwright actions.
- Every UIKit view and SwiftUI view must have explicit `.accessibilityIdentifier("id_name")` tags.
- Selectors must target identifiers natively using `await browser.$('~id_name)`.