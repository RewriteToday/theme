<div align="center">

# Rewrite Themes

The official editor themes for Rewrite.

From landing page snippets to everyday coding, keep the Rewrite palette close in Zed and Visual Studio Code with matching dark and light modes.

[Zed README](./zed/README.md) • [Visual Studio Code README](./vscode/README.md) • [Website](https://rewritetoday.com) • [Dashboard](https://dash.rewritetoday.com)

</div>

<div align="center">

## Pick your editor

Each package owns its own installation flow, usage notes, and editor-specific details.

</div>

- [Zed](./zed/README.md)
- [Visual Studio Code](./vscode/README.md)

<div align="center">

## Themes

`Rewrite Night` keeps the darker Rewrite atmosphere close to the landing page code previews.  
`Rewrite Day` keeps the same hierarchy, the same amber accent, and the same editorial feel in a warmer light mode.

</div>

<div align="center">

## Contribute

Want to refine token colors, improve contrast, or keep both editor packages visually aligned? This repository is split by target on purpose: `zed/` owns the Zed extension package, `vscode/` owns the Visual Studio Code extension package, and `scripts/` holds the shared release helpers.

</div>

```bash
git clone https://github.com/RewriteToday/theme.git
cd theme
```

<div align="center">

When you contribute, keep the workflow simple and consistent:

</div>

1. Update the source theme file in `zed/themes/rewrite.json`.
2. Update the matching source file in `vscode/themes/`.
3. Test both variants locally: `Rewrite Night` and `Rewrite Day`.
4. Rebuild the VS Code package with `cd vscode && bun install && bun run package`.
5. Use the scripts in `scripts/` when you want to validate or publish release flows.

<div align="center">

The goal is always the same: one Rewrite visual language, mirrored cleanly across both editors.

Made with love by the Rewrite team. <br/>
SMS the way it should be.

</div>
