# Blueprint-clean report — iter-058

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Status: CLEAN

All newly-written/edited blocks pass blueprint purity checks.

---

## Changes applied

### 1. Effort-break section header (line ~7559)
- **Before:** 7-line planner block describing the "Sub-brick-A Stub 1 route", referencing `analogies/stub1-scheme-coproduct.md` and "Archon-original categorical infrastructure".
- **After:** Single-line separator `% ----- Decomposition of lem:coproduct_distrib_fibrePower -----`.

### 2. Analogy reference in `lem:widePullback_overX_eq_prod` proof
- **Removed:** "This step is purely structural and reusable; see `\texttt{analogies/stub1-scheme-coproduct.md}` (Decision C)."
- Proof ends cleanly at the mathematical conclusion.

### 3. Analogy reference in `lem:prod_coproduct_distrib` proof
- **Removed:** "This is the single use of the extensivity hypothesis in the whole chain; see `\texttt{analogies/stub1-scheme-coproduct.md}` (Decision A)."

### 4. Analogy reference in `lem:coproduct_fibrePower_reindex` proof
- **Removed:** "This is pure combinatorial reindexing; see `\texttt{analogies/stub1-scheme-coproduct.md}` (Decision C, `\(\operatorname{sigmaSigmaIso}\)`)."

### 5. Planner comment inside `lem:coproduct_distrib_fibrePower` statement
- **Removed:** Two-line comment "% This is the main Mathlib gap: wide/iterated coproduct distributivity over fibre powers / is not in Mathlib. It is assembled by induction from the sub-lemmas below."
- The `% NOTE: build target` annotation was preserved.

### 6. Need#1 section header (line ~9265)
- **Before:** 5-line narrative "Route-3 decomposition" block referencing "Archon-original categorical infrastructure" and "no external math source".
- **After:** Single-line separator `% ----- Decomposition of lem:modules_isoSpec_ext_transport (transport along a scheme iso) -----`.

### 7. Lean implementation NOTE in `lem:modules_isoSpec_ext_transport` statement
- **Removed:** 3-line `% NOTE:` specifying `Functor.mapExt_bijective_of_preservesInjectiveObjects` (a Lean lemma name) and noting that `EnoughInjectives` must be supplied at the consumer site as a Lean typeclass.

### 8. Lean name leakage in `lem:modules_isoSpec_ext_transport` proof
- **Removed/replaced:** References to `pushforwardEquivOfIso_functor_additive` (Lean declaration name), `Functor.mapExt_bijective_of_preservesInjectiveObjects` (Lean lemma name), `pushforwardExtAddEquiv` (Lean term), and `[EnoughInjectives U.Modules]` (Lean typeclass syntax).
- **Replaced with:** Mathematical prose — "An equivalence is exact and additive, so `\operatorname{Ext.mapExactFunctor}` (Lemma~\ref{lem:ext_mapExactFunctor_mathlib}) applies and yields a map on `\operatorname{Ext}`; since `\Phi.\mathrm{functor}`, being one half of an equivalence, preserves injective objects, its induced `\operatorname{Ext}`-map is bijective (using enough injectives on `U.\mathrm{Modules}`), giving an additive isomorphism."

### 9. Project-planning sentence in `lem:pushforward_iso_preserves_qcoh` proof
- **Removed:** "No off-the-shelf Mathlib instance supplies this transport; it is genuine but bounded infrastructure."
- Proof ends after the mathematical argument.

### 10. Lean file-placement NOTE in `lem:affine_cech_vanishing_general_seed`
- **Removed:** 4-line `% NOTE:` specifying file co-location (`CechAcyclic.lean`), mirroring relationship to another Lean declaration, and a private helper name (`basicOpen_algMap_section`).

### 11. Change-of-ring chain comment block (line ~8929)
- **Before:** 5-line block referencing specific label chains and "The one genuinely-new Mathlib ingredient is the localised base-change comparison."
- **After:** Single-line separator `% ----- Change-of-ring chain for the general-affine-open Čech-vanishing seed -----`.

---

## Validation results

### `\leanok` audit
- No `\leanok` was introduced by hand in any of the newly-written blocks.
- All existing `\leanok` markers in the new area are on pre-formalized blocks (`lem:isZero_presheafToSheaf_of_sections_locally_zero` and nearby `\leanok` blocks) and were added by the `sync_leanok` phase in prior iters.

### `\uses{}` label validation
All `\uses{}` entries in the new blocks reference extant labels:

| Label | Line |
|---|---|
| `lem:widePullbackCone_isLimitOfFan_mathlib` | 8277 |
| `lem:over_mkIdTerminal_mathlib` | 8289 |
| `lem:isIso_sigmaDesc_map_mathlib` | 8251 |
| `lem:sigmaSigmaIso_mathlib` | 8301 |
| `lem:finitaryExtensive_scheme_mathlib` | 8240 |
| `def:jshriek_ou` | 2899 |
| `lem:mod_pmod_adjunction` | 2542 |
| `lem:isoSpec_scheme_mathlib` | 8754 |
| `lem:ext_mapExactFunctor_mathlib` | 8768 |
| `lem:modules_pushforward_mathlib` | 8784 |
| `lem:jshriek_transport_along_iso` | 9324 |
| `lem:pushforward_iso_preserves_qcoh` | 9360 |
| `lem:isAffineOpen_image_of_iso_mathlib` | 9379 |
| `def:absolute_cohomology` | (present) |

### Mathematical content
The mathematical statements and proof arguments of both decompositions (coproduct distributivity and jShriekOU transport) were not altered. Only prose style and comment cleanliness were changed.

### `% NOTE: build target` annotations
All 7 occurrences of `% NOTE: build target` annotations were preserved intact.

### `\mathlibok` marks
All `\mathlibok` marks in the new section (`lem:over_mkIdTerminal_mathlib`, `lem:isAffineOpen_image_of_iso_mathlib`) were preserved.
