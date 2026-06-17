# blueprint-writer report — avr-uses-fix (iter-160)

**File edited (only):** `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Edits applied

- **Edit A** — Added `\uses{lem:rigidity_eqOn_dense_open}` to the PROOF block of
  `thm:rigidity_lemma` (adjacent to `\leanok`, line 87). The headline now depends on the
  dense-open lemma.
- **Edit B** — Removed `\uses{thm:rigidity_lemma}` from the STATEMENT of
  `lem:rigidity_eqOn_dense_open` (was line 180). Backward edge / half of 2-cycle gone.
- **Edit C** — Removed `\uses{lem:rigidity_eqOn_dense_open}` from BOTH the statement
  (was line 311) and the proof (was line 337) of `lem:rigidity_eqOn_saturated_open_to_affine`.
  It is now a leaf. Other half of 2-cycle gone.
- **Edit D** — Dropped the `thm:rigidity_lemma` token from the PROOF `\uses` of
  `lem:rigidity_eqOn_dense_open`; it is now exactly
  `\uses{lem:rigidity_eqOn_saturated_open_to_affine}` (line 239).
- **Edit E** — Replaced the half-stale `% TODO` block with a `% NOTE (iter-160):` recording the
  forward chain and the de-laundering (lines ~101–108). `%`-comment only; no graph impact.

No `\leanok`/`\mathlibok` markers touched; no statement/proof prose changed (only the TODO-comment
refresh); cube section and deferred scaffolds untouched; no other chapter edited.

## Final `\uses` edge set of the three chain nodes (statement vs proof)

| Node | Statement `\uses` | Proof `\uses` |
|---|---|---|
| `thm:rigidity_lemma` | (none) | `lem:rigidity_eqOn_dense_open` |
| `lem:rigidity_eqOn_dense_open` | (none) | `lem:rigidity_eqOn_saturated_open_to_affine` |
| `lem:rigidity_eqOn_saturated_open_to_affine` | (none) | (none) — leaf |

## Directionality / acyclicity audit

All edges run FORWARD along the true Lean dependency order:

```
rigidity_lemma  →  rigidity_eqOn_dense_open  →  rigidity_eqOn_saturated_open_to_affine (sorry leaf)
```

- No node `\uses` a node downstream of it.
- The former 2-cycle (`dense_open ↔ saturated_open`) is gone (both backward edges removed).
- The headline `thm:rigidity_lemma` now transitively reaches the lone `sorry` leaf
  `rigidity_eqOn_saturated_open_to_affine`, so the not-proven status will propagate up to both
  `lem:rigidity_eqOn_dense_open` and `thm:rigidity_lemma`. De-laundered.

Confirmed: **no cycle anywhere in the chain.**
