# Blueprint Writer Report

## Slug
cov274-mayervietoris

## Status
COMPLETE — all three listed Lean declarations are now `\lean{}`-matched and wired; the uncovered lean-aux count for both MayerVietoris files is zero.

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Root cause discovered
The three declarations live in `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` under
`open CategoryTheory`, declared with the qualified-name pattern `Abelian.Ext.foo`. leandag
harvests them by their **source-text** names (no `CategoryTheory.` prefix):
- `Abelian.Ext.chgUnivLinearEquiv`
- `Abelian.Ext.chgUniv_add`   (`private lemma`)
- `Abelian.Ext.chgUniv_smul`  (`private lemma`)

`chgUnivLinearEquiv` already had a block (`def:Abelian_Ext_chgUnivLinearEquiv`), but its
`\lean{}` used the fully-qualified `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`, which did
**not** match the harvested short name. Result: leandag listed the block under
`unmatched_lean` while simultaneously leaving the `lean:Abelian.Ext.chgUnivLinearEquiv` aux
node uncovered (and `sync_leanok` had never managed to add `\leanok` to it). The two
`private` helpers had no block at all.

## Changes Made
- **Fixed `\lean{}`** `def:Abelian_Ext_chgUnivLinearEquiv` — changed
  `\lean{CategoryTheory.Abelian.Ext.chgUnivLinearEquiv}` → `\lean{Abelian.Ext.chgUnivLinearEquiv}`
  to match the harvested name (clears the `unmatched_lean` entry and covers the aux node).
- **Added statement-level `\uses{}`** to `def:Abelian_Ext_chgUnivLinearEquiv` —
  `\uses{lem:Abelian_Ext_chgUniv_add, lem:Abelian_Ext_chgUniv_smul}`. This is the real
  dependency: the `LinearEquiv` literal fills `map_add'` from `chgUniv_add` and `map_smul'`
  from `chgUniv_smul`. The hoist is what wires the two new helper blocks into the cone.
- **Added lemma** `\lemma`/`\label{lem:Abelian_Ext_chgUniv_add}`/`\lean{Abelian.Ext.chgUniv_add}`
  — universe-change map is additive on `\Ext`. Proof body: "Proved directly in Lean."
- **Added lemma** `\lemma`/`\label{lem:Abelian_Ext_chgUniv_smul}`/`\lean{Abelian.Ext.chgUniv_smul}`
  — universe-change map is `R`-linear on `\Ext`. Proof body: "Proved directly in Lean."
- **Added one orienting sentence** before the block (no source citation) describing that
  Mathlib's `chgUniv` is only a bare type equivalence and these two lemmas supply the
  algebraic-structure preservation needed for the `LinearEquiv` upgrade.

No `\leanok`/`\mathlibok` added (out of scope). No citation blocks added (internal helpers,
no external source — directive said omit). No undefined macros (`\Ext`, `\mathrm`, `\simeq`
only; the transient `\Equiv` I first typed was removed and reworded to "equivalence of types").

## Cross-references introduced
- `\uses{lem:Abelian_Ext_chgUniv_add}` and `\uses{lem:Abelian_Ext_chgUniv_smul}` in
  `def:Abelian_Ext_chgUnivLinearEquiv` — both labels are defined in this same chapter (the
  two new blocks).

## Verification (leandag)
- `leandag build --json`: `unknown_uses` for these labels = `[]`; `unmatched_lean` containing
  `chgUniv` = `[]`.
- `leandag query --isolated --chapter Cohomology_MayerVietoris`: **0 isolated**.
- Edge check on dag.json:
  - `lem:Abelian_Ext_chgUniv_add` → `def:Abelian_Ext_chgUnivLinearEquiv` → `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (existing in-cone consumer).
  - `lem:Abelian_Ext_chgUniv_smul` → `def:Abelian_Ext_chgUnivLinearEquiv` (same path).
  - `def:Abelian_Ext_chgUnivLinearEquiv`: in-edges 2, out-edge 1 — fully connected, no longer unmatched.
- Uncovered `lean_aux` nodes whose `lean_file` is a MayerVietoris file: **0**.

## References consulted
None — internal project helpers, no external source (per directive). Read only the Lean
source `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (decls + docstrings) and the
existing chapter to state the lemmas faithfully.

## Macros needed
None.

## Notes for Plan Agent
- The fix here was a **`\lean{}` prefix correction**, not purely additive: the existing
  `def:Abelian_Ext_chgUnivLinearEquiv` block carried the `CategoryTheory.`-prefixed name that
  matched neither leandag nor `sync_leanok`. Now that the short name matches, `sync_leanok`
  should add `\leanok` to this block (it is sorry-free in Lean) on its next run — worth
  confirming the marker appears.
- General pattern worth noting for future coverage passes: declarations written under
  `open CategoryTheory` with the `Abelian.Ext.foo` qualified-name pattern must be pinned with
  the **source-text** name in `\lean{}`, not the kernel-resolved `CategoryTheory.Abelian.Ext.foo`.

## Strategy-modifying findings
None.
