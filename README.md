go-patch-unusedvar.nvim
---

Run `:GoPatchUnusedVar` to patch [super annoying UnusedVar error](https://github.com/golang/go/issues/43729)

```
x := 3 // Unused variable x
```

```
x := 3; _ = x 
```

Requires neovim native lsp client with gopls.

