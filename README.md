<div align="center">

# Rewrite Themes

The official editor themes for Rewrite.

From landing page snippets to everyday coding, keep the Rewrite palette close in Zed, Visual Studio Code, and Neovim with matching dark and light modes.

[Zed README](./zed/README.md) • [Visual Studio Code README](./vscode/README.md) • [Neovim README](./nvim/README.md) • [Website](https://rewritetoday.com) • [Dashboard](https://dash.rewritetoday.com)

<img src="https://cdn.rewritetoday.com/assets/banners/theme.jpeg" width="100%" alt="Rewrite Banner"/>

## Pick your editor

Each editor has its own installation flow, usage notes, and editor-specific details.

</div>

- [Zed](./zed/README.md)
- [Visual Studio Code](./vscode/README.md)
- [Neovim](./nvim/README.md)

<div align="center">

## Themes

`Rewrite Night` keeps the darker Rewrite atmosphere close to the landing page code previews.  
`Rewrite Day` keeps the same hierarchy, the same amber accent, and the same editorial feel in a warmer light mode.

## Contribute

Want to refine token colors, improve contrast, or keep every editor package visually aligned? This repository is split by target on purpose: `zed/` owns the Zed extension package, `vscode/` owns the Visual Studio Code extension package, `nvim/` holds the Neovim documentation, and the Neovim runtime itself lives at the repository root in `colors/` and `lua/` so plugin managers can install it directly from GitHub.

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
3. Update the Neovim runtime in `colors/` and `lua/`.
4. Test both variants locally: `Rewrite Night` and `Rewrite Day`.
5. Rebuild the VS Code package with `cd vscode && bun install && bun run package`.
6. Use the scripts in `scripts/` when you want to validate or publish release flows.

<div align="center">

The goal is always the same: one Rewrite visual language, mirrored cleanly across both editors.

Made with love by the Rewrite team. <br/>
SMS the way it should be.

</div>
