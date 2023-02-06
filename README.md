# telescope-git-ex.nvim
---


Telescope picker of previous commits to the current file. Opens the chosen commit in a new split view.


## Example:
---

![Demo gif](/assets/demo.gif)


## Installation
---

```lua
use {
  'Pyons/telescope-git-ex.nvim'
}
```


```lua
require('telescope').load_extension('git_ex')

```

## Usage
---


```viml
:Telescope git_ex compare
```
