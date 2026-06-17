# blueprint-clean — tsfix207 — Report

**File:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
**Status:** DONE — all standard-pass and targeted fixes applied.

---

## Standard pass

### Lean leakage / tactic syntax
None found. Lean identifiers used in `\mathtt{...}` and `\texttt{...}` are
legitimate mathematical references to named constructions, not tactic syntax.

### Project-history verbosity — removed (3 items)

1. **Proof of `lem:tensorobj_restrict_iso`, opening paragraph.**
   Removed two sentences: "The earlier framing --- that flatness alone
   produces the isomorphism --- is incorrect: the abstract pullback has no
   sectionwise formula, so there is no map to which flatness could be applied
   until the map has been built." These referenced a superseded route and are
   not mathematical content.

2. **Proof of `lem:tensorobj_restrict_iso`, Step 2.**
   Removed the parenthetical "(This corrects the older claim that
   sheafification does not commute with pullback: it does, and the required
   natural isomorphism is available.)". Pure project-history note.

3. **Consistency-check section (`sec:tensorobj_consistency_check`).**
   Removed "(the prover creates it this iter)" from the bullet on
   `lem:restrictscalars_laxmonoidal`. Loop-management narration.

### Source quotes
Both `% SOURCE:` blocks already have `% SOURCE QUOTE:` entries. No missing
quotes to insert.

### LaTeX validity
Environments checked: all `\begin`/`\end` pairs balanced. All `\cref`
targets referenced in the file are either defined in-chapter or declared
as cross-chapter references to `chap:Picard_LineBundlePullback` and
`chap:Picard_RelPicFunctor`. No orphan refs found. The `\leanok`/`\mathlibok`
markers were not touched.

---

## Targeted consistency fixes

### Fix 1 — `sec:tensorobj_motivation`

**Old:** "But for \emph{line bundles}, which are flat, that compatibility is
\emph{elementary flat-exactness}, not internal-hom machinery."

**New:** "But for line bundles, the comparison map is the oplax $\delta$ of
the left adjoint, produced by `leftAdjointOplaxMonoidal`
(`Mathlib.CategoryTheory.Monoidal.Functor`) applied to the
pullback--pushforward adjunction on presheaves of modules; the sole
project-side ingredient is the sectionwise
`(restrictScalars φ).LaxMonoidal` instance, and flatness of line bundles
then makes $\delta$ an isomorphism."

### Fix 2a — `sec:tensorobj_api_survey` (gap paragraph closing sentence)

**Old:** "and for line bundles it is elementary flat-exactness already
available in Mathlib (`\cref{lem:tensorobj_restrict_iso}`)."

**New:** "and for line bundles, the comparison map is the oplax $\delta$ of
`leftAdjointOplaxMonoidal` applied to the pullback--pushforward adjunction,
with the sole project-side ingredient the sectionwise
`(restrictScalars φ).LaxMonoidal` instance, and flatness of line bundles
then upgrades $\delta$ to an isomorphism (`\cref{lem:tensorobj_restrict_iso}`)."

### Fix 2b — `sec:tensorobj_loc_estimates`, Piece 2 first bullet

**Old:** "via elementary flat-exactness: $\otimes$ is right-exact and
`Module.Flat.lTensor_preserves_injective_linearMap` gives
injectivity-preservation, packaged for invertible modules as
`Module.Invertible.lTensor_bijective_iff` (both in Mathlib); the flatness is
automatic since `Module.Invertible ⇒ Module.Projective ⇒ Module.Flat`"

**New:** "via the oplax $\delta$ of `leftAdjointOplaxMonoidal`
(`Mathlib.CategoryTheory.Monoidal.Functor`) applied to
`PresheafOfModules.pullbackPushforwardAdjunction`, with the sole project-side
ingredient the sectionwise `(restrictScalars φ).LaxMonoidal` instance
(`\cref{lem:restrictscalars_laxmonoidal}`); flatness of line bundles
(`Module.Invertible ⇒ Module.Projective ⇒ Module.Flat`) then upgrades
$\delta$ to an isomorphism via `Module.Invertible.lTensor_bijective_iff`
(`Mathlib.RingTheory.PicardGroup`)"

---

## Summary

Six edits total: three standard-pass cleanup removals and three targeted
consistency rewrites. The section structure, all `\leanok`/`\mathlibok`
markers, and all `% NOTE:` / `% SOURCE QUOTE:` comments were left intact.
The chapter now consistently frames flatness as upgrading the abstract
oplax $\delta$ map (from `leftAdjointOplaxMonoidal`) to an isomorphism,
rather than as an independent elementary closure.
