# BagBrother Maintenance & Development Rules

This document outlines the architecture, coding standards, testing procedures, and rules for maintaining and contributing to the **BagBrother** addon codebase.

---

## 1. Codebase Architecture & Structure

BagBrother serves as the backend engine, database cache, and core component library for both Bagnon and Bagnonium addons.

*   **/core**: The main backend logic.
    *   `/api`: Common interfaces for events, settings, frames, filters (rules), skinning, and sorting.
    *   `/classes`: Base UI components (item slots, bag slots, money frames, tabs) using the Poncho OOP model.
    *   `/features`: System features such as cross-character inventory/currency caching, tooltips, and slash commands.
    *   `/localization`: Localization dictionaries.
*   **/frames**: Specific layouts and views for the four main UI interfaces:
    *   `/inventory`: Character bags.
    *   `/bank`: Bank slots, reagent bank, and account-wide warband banks.
    *   `/guild`: Guild vaults/banks and log tabs.
    *   `/vault`: Character void storage.
*   **/libs**: External library modules linked as Git submodules. Crucial shared utility libraries include `Poncho-2.0`, `Sushi-3.2`, `C_Everywhere`, `MutexDelay-1.0`, and `ItemSearch-1.3`.

---

## 2. Formatting & Development Rules

To maintain codebase consistency and compatibility, all changes must follow these guidelines:

### Indentation and Formatting
*   **Use Tabs:** Use tabs (`\t`) for indentation. Do not mix spaces and tabs.
*   **Whitespace:** Keep clean spacing around logical conditions and functions.

### File Registrations & Load Order
*   **XML Manifests:** WoW client load ordering is strictly managed via nested XML manifests. 
    *   Do not list new `.lua` files in `.toc` files directly.
    *   Always register new scripts in the appropriate local XML manifest (e.g., `core/api/api.xml`, `core/classes/classes.xml`, or `frames/bank/bank.xml`) using the `<Script file="filename.lua"/>` tag.

### Multi-Expansion Support
*   BagBrother supports Mainline (Retail), Cataclysm Classic, and Vanilla Classic.
*   **Avoid Raw Version-Specific API Calls:** Use the unified wrapper library **C_Everywhere** (`LibStub('C_Everywhere')`) to bridge expansion API gaps.
*   **Conditional Checks:** Use flags like `Addon.IsRetail`, `Addon.IsClassic`, or expansion level constants to guard version-specific features.

### Class and OOP Definitions
*   Always inherit from the Poncho-2.0 base class when creating new components:
    ```lua
    local Base = Addon:NewModule('ClassName', LibStub('Poncho-2.0')())
    ```

---

## 3. Testing and Verification

*   **In-Game Verification:** Automated CLI test suites are not supported. All logic and layout changes must be manually verified inside the World of Warcraft client.
*   **Error Reporting:** Enable script error displays during development:
    ```
    /console scriptErrors 1
    ```
    (Using error catching addons like *BugSack* & *BugGrabber* is highly recommended).
*   **Unit Tests:** Unit tests for shared libraries (submodules under `libs/`) are defined in `Tests.lua` files. These run in-game using the **WoWUnit** addon.
*   **SavedVariables Migrations:** When updating data cache patterns (like `BrotherBags`), always verify that schema updates are safely migrated in `Settings:Upgrade` within `core/api/settings.lua`.

---

## 4. Release Packaging & Submodules

*   **Git Submodules:** Keep all submodules in sync. Before committing or building, verify submodules are initialized and updated recursively:
    ```bash
    git submodule update --init --recursive
    ```
*   **Release Packaging (`.upconfig`):**
    *   The release package is generated automatically using the BigWigsMods WoW packager.
    *   Any test files, visual mockup assets, or source files that should be ignored during packaging must be specified under the `[ignore]` block in `.upconfig` in the root directory.
