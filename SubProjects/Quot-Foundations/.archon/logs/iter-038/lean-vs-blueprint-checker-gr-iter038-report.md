# Lean ↔ Blueprint Check Report

## Slug
gr-iter038

## Iteration
038

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration (iter-038 targets)

### `\lean{AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq}`
(no blueprint block — see Red flags / Unreferenced)
- **Lean target exists**: yes (line 1866, public `theorem`)
- **Signature matches**: N/A — no blueprint block to compare against
- **Proof follows sketch**: N/A
- **notes**: The blueprint's proof of `lem:gr_existence_lift` (lines 2465–2480 of the .tex) covers this content informally under "Top triangle", but does not promote it to a named, `\lean{...}`-tagged lemma. The Lean code factored it out as a public theorem. No sorry; proof complete.

---

### `\lean{AlgebraicGeometry.Grassmannian.existence_lift}` (E4, `lem:gr_existence_lift`)
- **Lean target exists**: yes (line 1920, `noncomputable def`)
- **Signature matches**: yes — returns `sq.LiftStruct` over the valuative square (`CommSq i₁ (Spec.map (algebraMap R K)) (toSpecZ d r) i₂`), exactly as the blueprint's LEAN SIGNATURE annotation and prose describe: "The filler is `Spec.map g' ≫ ι_J`; assemble a `CommSq.LiftStruct`."
- **Proof follows sketch**: yes — `fac_left` uses `existence_chart_kpoint_eq` (the K-point identity from the blueprint's "top triangle"), `fac_right` uses `specZIsTerminal.hom_ext` (the blueprint's "bottom triangle free by terminality"). Term-mode composition is used throughout, matching the comment that `Category.assoc`/`rw` are blocked by the Scheme-category instance diamond.
- **notes**: `\leanok` is present in the blueprint block. No sorry anywhere in the body.

---

### `liftToBaseOfMemRange` + `algebraMap_comp_liftToBaseOfMemRange` (private)
- **Lean target exists**: yes (lines 1977 and 1990, both `private`)
- **Signature matches**: N/A — no blueprint block; private declarations
- **Proof follows sketch**: N/A
- **notes**: These are implementation helpers for assembling `g'` in step E5. Both are `private`, so no blueprint coverage is required. Bodies are complete (no sorry). The compositional lemma `algebraMap_comp_liftToBaseOfMemRange` correctly characterises `(algebraMap R K) ∘ liftToBaseOfMemRange φ hmem = φ`, which is the only property used in `valuativeExistence_toSpecZ`.

---

### `\lean{AlgebraicGeometry.Grassmannian.valuativeExistence_toSpecZ}` (E5, `lem:gr_valuativeExistence_toSpecZ`)
- **Lean target exists**: yes (line 2017, `theorem`)
- **Signature matches**: yes — `ValuativeCriterion.Existence (toSpecZ d r)`, matching the blueprint: "every commutative square from a valuation ring R (with fraction field K) admits a diagonal filler."
- **Proof follows sketch**: yes — E1: `existence_chart_factorization`; E2: `existence_minimal_valuation`; E3: `existence_factor_through_valuationRing` corestricted via `liftToBaseOfMemRange`; E4: `existence_lift`. Exactly the four steps the blueprint describes at lines 2507–2517.
- **notes**: `\leanok` is present. No sorry.

---

### `\lean{AlgebraicGeometry.Grassmannian.isProper}` (E6, `lem:gr_proper`)
- **Lean target exists**: yes (line 2042, `theorem`)
- **Signature matches**: yes — `IsProper (toSpecZ d r)`, matching the blueprint: "The structure morphism π : Gr(r,d) → Spec ℤ is proper."
- **Proof follows sketch**: yes — single line `isProper_of_valuativeExistence d r (valuativeExistence_toSpecZ d r)`, exactly as the blueprint proof at lines 2584–2606 describes: feed the existence half into the reduction lemma.
- **notes**: `\leanok` is present. No sorry.

---

## Red flags

### Missing `\lean{...}` reference for a public declaration
- `existence_chart_kpoint_eq` (line 1866): a public `theorem` with a full, self-contained statement and docstring. It is the "K-point identity" sub-step of E4. The blueprint's proof sketch for `lem:gr_existence_lift` describes the same content informally (lines 2465–2480), but never promotes it to a `\lean{...}`-tagged lemma block. A blueprint-author action is needed to add a lemma block for it, or to clearly mark it as a private/helper-only step (in which case it should be changed to `private` in Lean).

No other red flags found:
- **No `:= sorry`** in any declaration across the 2046-line file.
- **No axiom declarations** introduced.
- **No excuse-comments** ("TODO replace with real def", "temporary", etc.).
- **No suspect bodies** (`:= True`, trivially wrong definitions).

---

## Unreferenced declarations (informational)

The following public declarations in the Lean file have no `\lean{...}` block in the blueprint. All except `existence_chart_kpoint_eq` are clearly project-internal helpers (named accordingly and marked `private` or sufficiently described as non-blueprint targets in their docstrings):

- `mul_submatrix_col` — listed in blueprint as `lem:gr_mul_submatrix_col` with `\lean{}`. ✓ (Already covered.)
- `awayPullbackIso_inv_fst`, `awayPullbackIso_inv_snd` — covered in blueprint as `lem:gr_awayPullbackIso_inv_fst`, `lem:gr_awayPullbackIso_inv_snd`. ✓
- `awayMulCommEquiv`, `awayMulCommEquiv_comp_algebraMap`, `awayMulCommEquiv_comp_awayInclLeft` — covered in blueprint. ✓
- `chartTransition'`, `chartTransition'_ringIdentity`, `chartTransition'_fac`, `chartTransition'_cocycle` — covered. ✓
- `cocyclePhiId` — covered (`lem:gr_cocycle_phi_id`). ✓
- `pullbackιIso`, `pullbackιIso_inv_fst`, `pullbackιIso_inv_snd` — covered. ✓
- `toSpecZ`, `ι_toSpecZ` — covered. ✓
- `isSeparatedToSpecZ`, `isSeparated` — covered (`lem:gr_separated_toSpecZ`, `lem:gr_separated`). ✓
- `compactSpace_scheme`, `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`, `quasiSeparated_toSpecZ`, `valuativeUniqueness_toSpecZ`, `isProper_of_valuativeExistence` — all covered in the properness section. ✓
- `transitionPreMap_minorDet_mul` — covered (`lem:gr_transitionPreMap_minorDet_mul`). ✓
- `existence_chart_factorization` — covered (`lem:gr_existence_chart_factorization`). ✓
- `existence_minimal_valuation` — covered (`lem:gr_existence_minimal_valuation`). ✓
- `exists_minorDet_eq_free_entry` — covered (`lem:gr_free_entry_eq_signed_minor`). ✓
- `existence_factor_through_valuationRing` — covered (`lem:gr_existence_factor_through_valuationRing`). ✓
- `existence_lift_transitionPreMap_minorDet_mul` — covered (`lem:gr_existence_lift_transitionPreMap_minorDet_mul`). ✓
- **`existence_chart_kpoint_eq`** — **NOT COVERED** (see above). This is the only gap.
- `liftToBaseOfMemRange`, `algebraMap_comp_liftToBaseOfMemRange` — `private`; no blueprint coverage required.

---

## Blueprint adequacy for this file

- **Coverage**: All 5 blueprint-pinned iter-038 target declarations are correctly `\lean{...}`-referenced and carry `\leanok`. The only unreferenced substantive public declaration is `existence_chart_kpoint_eq`.
- **Proof-sketch depth**: **adequate** for all iter-038 targets. The E4 lemma (`lem:gr_existence_lift`) proof sketch is detailed and matches the Lean proof closely: the "top triangle" description aligns with `existence_chart_kpoint_eq`'s logic; the "bottom triangle free" description matches `specZIsTerminal.hom_ext`. The E5 assembly (`lem:gr_valuativeExistence_toSpecZ`) proof sketch lists exactly the four steps (E1–E4) implemented in Lean. The E6 (`lem:gr_proper`) proof sketch is a one-liner correctly reflected in the single-call Lean proof.
- **Hint precision**: **precise** — all `\lean{...}` references name the exact Lean identifiers that were formalized.
- **Generality**: **matches need** — no parallel API was needed.
- **Recommended chapter-side actions**:
  1. Add a `\begin{lemma}...\end{lemma}` block for `existence_chart_kpoint_eq` (the K-point identity sub-step of E4) with `\label{lem:gr_existence_chart_kpoint_eq}` and `\lean{AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq}`. The informal statement is: for `K`-point `f : R^I → K` with `P^I_J` a unit, the transported map `g := f' ∘ θ̃_{I,J}` presents the same `K`-point through chart `J` as `f` does through chart `I`: `Spec(g) ≫ ι_J = Spec(f) ≫ ι_I`. Alternatively, the plan agent may choose to make this declaration `private` in the Lean source if it is regarded as purely internal scaffolding.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major** (1):
  - Blueprint missing `\lean{AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq}` block: public theorem with no `\lean{...}` blueprint reference. The blueprint describes the content informally inside the proof of `lem:gr_existence_lift`, but does not pin it as a named lemma. Blueprint coverage is incomplete for this one public non-private declaration.
- **minor**: none.

**Overall verdict**: All five iter-038 blueprint-pinned declarations (`existence_lift`, `valuativeExistence_toSpecZ`, `isProper`, and the two `private` helpers) are formalized axiom-clean with no sorries, matching the blueprint's statements and proof sketches; one major gap is that the public helper `existence_chart_kpoint_eq` lacks a `\lean{...}` blueprint reference.
