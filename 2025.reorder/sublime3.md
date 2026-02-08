# Sublime3

- https://packagecontrol.io/
- ctrl+shift+p

- Install Package Control

- Install PlainTasks
- Install MarkdownEditing
- Install MarkdownPreview

- View > Syntax > Open all with current extension as .txt

Edit your "Key Bindings - User" file by using the menu items: Preferences > Key Bindings - User (or use the Command Palette).

Add the following entry to your "Key Bindings - User" file. If you have other key bindings in your file, be sure there are commas between them.

```
{ "keys": ["alt+m"], "command": "markdown_preview", "args": {"target": "browser", "parser":"markdown"} }
```

(Optional) If you want to use control+b for the build command, instead of the MarkdownEditing bold command, add the following entry to your "Key Bindings - User" file. If you have other key bindings in your file, be sure there are commas between them.

```
{ "keys": ["ctrl+b"], "command": "build" }
```

