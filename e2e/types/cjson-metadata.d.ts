// Lets wdio.conf.ts pass report metadata to wdio-cucumberjs-json-reporter.
export {};

declare global {
    namespace WebdriverIO {
        interface Capabilities {
            'cjson:metadata'?: {
                device?: string;
                platform?: { name?: string; version?: string };
            };
        }
    }
}
