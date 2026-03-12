<div align="center">

# Rewrite Theme for Zed

The official Rewrite theme extension for Zed.

Bring the same palette from the Rewrite landing page code previews into your editor with `Rewrite Night` and `Rewrite Day`.

[Repository](https://github.com/RewriteToday/theme) • [Website](https://rewritetoday.com) • [Dashboard](https://dash.rewritetoday.com)

</div>

<div align="center">

## Install

Start from the Rewrite theme repository on GitHub, clone it locally, and run the installer script from the Zed package.

</div>

```bash
git clone https://github.com/RewriteToday/theme.git
cd theme
./zed/scripts/install.sh night
```

<div align="center">

Use `day` if you want the light variant from the first run:

</div>

```bash
./zed/scripts/install.sh day
```

<div align="center">

The script links the package into Zed, adds the theme file, and updates `settings.json` so the selected variant is already active the next time you open the editor.

</div>

<div align="center">

## What ships in this package

</div>

```text
zed/
├─ extension.toml        # Zed extension manifest
├─ themes/rewrite.json   # Rewrite Night + Rewrite Day
└─ scripts/install.sh    # One-command local install
```

<div align="center">

Made with love by the Rewrite team. <br/>
SMS the way it should be.

</div>
