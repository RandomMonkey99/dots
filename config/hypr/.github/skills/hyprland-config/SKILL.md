---
name: hyprland-config
description: "Use when: editing Hyprland configuration, keybindings, variables, monitors, layouts, plugins, or window rules in a Hyprland Lua setup."
---

# Hyprland Configuration Workflow

Use this skill when changing Hyprland settings in this workspace or a similar Hyprland Lua config. The goal is to keep configuration consistent with the official Hyprland documentation and the repo’s modular structure while minimizing breakage.

## What to read first

Before editing anything, identify the config area:
- Variables and shared defaults: `modules/variables.lua`
- App and window bindings: `modules/keybindings.lua`
- Monitor layout: `modules/monitors.lua`
- Appearance and theme: `modules/appearance.lua`
- Input devices and behavior: `modules/input.lua`
- Plugin setup: `modules/plugins.lua`
- Rules and matching: `modules/rules.lua`
- Autostart apps: `modules/autostart.lua`
- Animation settings: `modules/animations.lua`

This workspace follows a modular pattern: the root `hyprland.lua` loads each module, and each feature stays grouped in its own file instead of mixing unrelated settings in one block.

## Workflow

1. Identify the exact config goal.
   - New hotkey?
   - New variable or app launcher?
   - Monitor layout change?
   - Visual tuning or opacity/gap update?
   - Plugin enablement or rule adjustment?

2. Read the relevant module before touching anything.
   - Prefer the module closest to the feature.
   - Reuse existing patterns rather than introducing a new style.
   - Keep app defaults centralized in `modules/variables.lua` when possible.

3. Follow Hyprland’s canonical configuration patterns.
   - Use `hl.bind(...)` for key bindings.
   - Keep shared values such as `mainMod`, terminal, browser, editor, and file manager in a single variable file.
   - Keep config changes grouped by feature and module.
   - Prefer `hl.config({ ... })` blocks for a named visual or layout preset.

4. Make the minimal change that solves the problem.
   - Add new binds near related sections.
   - Add new variables in the shared variables file.
   - Add rules in `modules/rules.lua` rather than scattering them across the setup.
   - Use `variables.mainMod` instead of hard-coding `SUPER` in multiple places.

5. Validate the change before reloading.
   - Check for Lua syntax issues.
   - Confirm key names and command strings are valid.
   - Confirm the config still matches the expected Hyprland API for the version in use.
   - Check that plugin names, module names, and command execution strings exist.

6. Reload and verify the result.
   - Use `hyprctl reload` or restart the session if required.
   - Test the actual behavior: key press, window focus, app launch, workspace switching, monitor layout, plugin toggle.
   - If the behavior is wrong, revert to the smallest safe change and re-test.

## Decision points

- If the change is a shared app path or modifier, edit `modules/variables.lua`.
- If the change is a hotkey, edit `modules/keybindings.lua` and keep it near the related section.
- If the change is a visual tweak, edit `modules/appearance.lua` or use a `hl.config(...)` block for a specific preset.
- If the change is a monitor/layout issue, review `modules/monitors.lua` and `modules/layout.lua`.
- If the change is a plugin feature, verify the plugin is loaded in `modules/plugins.lua` and its API is used correctly.
- If the change is a matching rule, add it in `modules/rules.lua`.

## Quality bar

A change is complete when all of the following are true:
- The config remains modular and easy to scan.
- Shared values are centralized instead of duplicated.
- Keys are grouped logically by feature.
- The syntax matches the Hyprland Lua API used in this repo.
- Reloading the config succeeds without obvious Lua errors.
- The user-visible behavior matches the intended change.

## Concrete examples

- Add a new app launcher: update `modules/variables.lua` and use it in `modules/keybindings.lua`.
- Add a workspace binding: add it to the workspace block in `modules/keybindings.lua`.
- Enable a plugin: edit `modules/plugins.lua` and then configure the plugin in the appropriate module or config block.
- Change margin or border styling: adjust the relevant `hl.config({ ... })` section and verify the effect with a reload.

## Example prompts

- "Add a keybinding to open my notes app with Super+N."
- "Change the main modifier from Super to Alt and update all related binds."
- "Add a floating rule for a specific app window."
- "Tune the gaps and border size for a cleaner desktop look."
- "Enable a plugin and configure its workspace behavior."

## Related notes

This repo’s Hyprland setup is strongly module-based and intentionally avoids putting everything in one monolithic config file. Follow that structure unless a doc or plugin explicitly requires a different pattern. If you are unsure about a setting, prefer the official Hyprland documentation first, then mirror the existing pattern in this workspace.
