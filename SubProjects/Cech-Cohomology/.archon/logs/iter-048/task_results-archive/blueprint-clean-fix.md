# blueprint-clean report — iter-048 fix pass

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Changes made

Six targeted edits across the four blocks named in the directive.

### `lem:isLocalizedModule_of_exact` proof (lines 5031–5058)

Three occurrences of Lean typeclass field names removed from the diagram-chase argument:

1. `(the \operatorname{map\_units} clause of b)` parenthetical deleted from item (i); the mathematical
   fact ("s·- is bijective on B'") was already stated inline, making the parenthetical redundant.

2. Item (ii): `\operatorname{exists\_of\_eq} clause of c` → `since c is a localisation map there exists
   t ∈ S with t · p(w) = 0`. Mathematical statement preserved, Lean field name gone.

3. Item (iii): `\operatorname{exists\_of\_eq} clause of b` → `since b is a localisation map there exists
   s ∈ S with …`. Same fix.

### `lem:qcoh_section_kernel_comparison` proof (line 5083)

Lean method name `, via \operatorname{IsLocalizedModule.iso}` removed from the parenthetical citing
`lem:isLocalizedModule_linearEquiv_mathlib`; the reference to the Mathlib lemma is sufficient.

### `% NOTE:` on `lem:qcoh_section_kernel_comparison` (was lines 5065–5069)

Replaced five-line comment containing:
- `` `IsLocalizedModule.iso ρ_f`, derived in one line from … ``
- `Mathlib \`IsLocalizedModule.iso\`/\`.linearEquiv\` packaging`
- "this block is now the short downstream corollary"

With a four-line mathematical summary: corollary of keystone, two dependencies named, chase lives in
keystone proof.

### `% NOTE:` on `lem:qcoh_section_isLocalizedModule` (was lines 5096–5114)

Replaced nineteen-line comment containing:
- `kernel_comparison := IsLocalizedModule.iso ρ_f` (Lean assignment syntax)
- `the \uses edge runs keystone → corollary, not the reverse` (stale planner-inversion narrative)
- `The \lean{} pin names the declaration; the IsLocalizedModule of the section-restriction map …`
  (Lean-implementation narrative)
- `rho_f is IsLocalizedModule(powers f)` (Lean notation)
- `built on B4 +` (internal block-reference)

With a thirteen-line mathematical summary covering: direct proof strategy, route structure,
non-circularity argument. All mathematical content preserved; Lean/planner-narrative stripped.

## Protected items — untouched

- `\leanok` markers: unchanged (lines 5060, 5078–5079, 5089, 5142–5143)
- `\lean{}` pins: unchanged on all four lemmas
- `\uses{}` lists: unchanged on all four lemmas
- `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks: unchanged (lines 5109–5120)

## LaTeX environment balance

All edits are pure text / comment replacements; no `\begin{…}` / `\end{…}` pairs added or removed.
Balance is preserved.

## Residual scope note

Two other occurrences of `\operatorname{IsLocalizedModule.iso}` exist at lines 634 and 980 (in
different, earlier lemma blocks). These are outside the four blocks named in the directive and were
not touched.

## Status

DONE — chapter is syntactically and semantically clean for the four target blocks.
