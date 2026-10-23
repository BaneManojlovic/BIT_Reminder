# Albums Photo Feature Testing Playbook

## 📸 UI Architecture & Accessibility Identifiers
The Albums workflow is a hybrid feature featuring custom cell components alongside UIKit structures.

### 1. Main Dashboard View (`AlbumsTableViewCell`)
- **Main List Container:** `albums_table_view`
- **Dynamic Table Row Cell:** `albums_cell_row_[index]` (Injected via cellForRowAt)
- **Album Title Label:** `albums_label_title_[index]`
- **Create Album Bar Button:** `albums_btn_create_album` (opens a "Create new album" alert with a text field)

### 2. Gallery Detail View (`AlbumPhotoCollectionViewCell`)
- **Collection Grid Canvas:** `albums_collection_view_grid`
- **Photo Thumbnail Thumb:** `albums_photo_item_[index]`
- **Floating System Photo Action Button:** `albums_btn_trigger_picker`

### 3. Full Screen Render View (`ImageDetails`)
- **Full View Image Asset:** `albums_full_image_viewer`
- **Back Navigation Button:** `albums_btn_back`

---

## 🏃‍♂️ Automation Behavior Rules
1. **Handling System Photo Picker Sheets:** 
   The iOS Photo Picker (opened by the app's `UIImagePickerController` via a "Choose photo from library" action sheet) resides out of the application's binary scope. It runs inside a native Apple system daemon process.
   - To interact with photo slots or confirmation actions inside the picker sheet, do not use our snake_case custom IDs. 
   - Instead, instruct Appium to fall back onto native label searches: `await $('~Photo, Regular, August 8, 11:52 PM')` or tap via general predicates.
2. **Collection Grid View Scrolling:** 
   When testing rows or cells deeper than index 3, verify that the runner executes a scroll action via `browser.execute('mobile: scroll', { direction: 'down' })` before evaluating `.isDisplayed()`.

---

## 📋 Standard Gherkin Sentences Allowed
- `Given the user navigates to the Albums tab`
- `When the user selects the album at index "[index]"`
- `And the user taps the add photo option`
- `Then the full size image element should be rendered`
