Read-only follow-up complete; no shared files were edited.

The current file now bypasses `gluingOverlapIso_pre_snd_snd` with a direct second-projection calculation. The remaining expensive operation is the first branch’s `simpa [Category.assoc]`. Recommended replacement:

```lean
  · exact gluingOverlapIso_pre_snd_fst
      (C := C) (P := P) (U := U) (V := V)
```

Scratch timings showed full elaboration remains dominated by the enormous dependent theorem statement:

- Original: still active after `151.91s`.
- Transparency-disabled variant: over `120s`.
- Explicit named-argument `simpa`: over `120s`.
- Bare `exact`: reached only standalone scratch instance-resolution errors after `247.08s`, with no equality mismatch.

If `exact` fails in the real module context, copy the already-proved direct first-projection calculation into the consumer, matching the new direct second branch. That avoids cross-module unification of the inferred equality types entirely.
