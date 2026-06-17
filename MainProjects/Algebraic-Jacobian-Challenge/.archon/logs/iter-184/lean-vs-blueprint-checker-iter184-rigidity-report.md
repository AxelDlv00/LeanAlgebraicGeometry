# Lean ↔ Blueprint Check Report

## Slug
iter184-rigidity

## Iteration
184

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: `prop:morphism_P1_to_AV_constant`)
- **Lean target exists**: yes (L523, public `theorem`)
- **Signature matches**: yes — `[IsAlgClosed kbar]`, `{A : Over (Spec (.of kbar))}`, `[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`, `(f : ProjectiveLineBar kbar ⟶ A)`, conclusion `∃ a₀, f = toUnit ℙ¹ ≫ a₀`. Blueprint says "every `f : ℙ¹ → A` is constant = a single `k̄`-point", which is exactly this existential.
- **Proof follows sketch**: yes — Lean outer wrapper does the translation-reduction and calls `morphism_P1_to_grpScheme_const_aux`; aux carries the `𝔾ₘ`-scaling shortcut (Cor 1.5 + `gmScalingP1_collapse_at_zero` + density via `iotaGm_isDominant`). Blueprint proof (lines 1699–1745) accurately describes this structure.
- **notes**: Body carries propagated `sorryAx` through `iotaGm_isDominant` (gated on Lane A's `gmScalingP1` body). Documented honestly; no laundering.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: `prop:rigidity_genus0_curve_to_AV`)
- **Lean target exists**: yes (L590, public `theorem`)
- **Signature matches**: yes — `[IsAlgClosed kbar]`, curve typeclasses `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, `(_hgenus : genus C = 0)`, AV typeclasses `[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`, pointed `(_hf : p ≫ f = η[A])`, conclusion `f = toUnit C ≫ η[A]`. Matches blueprint lines 1799–1814 exactly, including the dropped `[CharZero]`.
- **Proof follows sketch**: yes — iso-transport via `genusZero_curve_iso_P1` + `morphism_P1_to_grpScheme_const` + pinning constant via `toUnit_unique`, matching blueprint proof lines 1818–1829.
- **notes**: Carries `sorryAx` through (a) `genusZero_curve_iso_P1` (RR bridge, deferred) and (b) `morphism_P1_to_grpScheme_const`'s `iotaGm_isDominant` residual. Documented honestly.

---

## Specific check: iter-184 Lane E closure of `iotaGm_onePt_chart1_factor`

`iotaGm_onePt_chart1_factor` (L106) is a **private** helper with no `\lean{...}` pin and no dedicated blueprint block. That is **appropriate**: it is a Lean implementation sub-task feeding `iotaGm_isOpenImmersion` → `iotaGm_range_isOpen` → `iotaGm_isDominant`.

**Does the closure path match?** The 5-step chain in the directive (`Scheme.Hom.coe_opensRange` → `Proj.opensRange_awayι` → `Scheme.Hom.mem_preimage` + `change` → `Proj.fromOfGlobalSections_preimage_basicOpen` → `Scheme.basicOpen_of_isUnit` + `simp`) is accurately described in the Lean docstring (L79–L105) and in the proof body (L132–L162). This is the correct factorisation of `onePt.left` through `Proj.awayι (X 1)` via `IsOpenImmersion.lift`, and the proof closes via `IsOpenImmersion.lift_fac`. Axiom-clean `{propext, Classical.choice, Quot.sound}` as reported.

The chapter's **mathematical content** for this sub-task is covered at the right level of abstraction: the blueprint (lines 1766–1771) documents `iotaGm_isDominant` as the one residual sorry gated on Lane A, and the density of `𝔾ₘ ↪ ℙ¹` that `morphism_P1_to_grpScheme_const_aux` uses (lines 1730–1736) accurately names the dominance handle. The private implementation chain (`onePt_chart1_factor` → `chart1_section` → `chart1_composition_isOpenImmersion` → `range_isOpen` → `isDominant`) is correctly left out of the blueprint as Lean internal scaffolding.

**Blueprint ↔ Lean consistency for `iotaGm_isDominant`:** The blueprint NOTE comment (line 1768) says this remains `sorry` gated on Lane A. The Lean (L347) confirms: body is structural-assembly-clean but calls `iotaGm_range_isOpen`, which in turn calls `iotaGm_isOpenImmersion`, which still carries `iotaGm_chart1_composition_isOpenImmersion`'s `sorry` (L251; iter-184+ target). The chain is honestly documented throughout.

---

## Specific check: `thm:rigidity_genus0_curve_to_AV` label issue (blueprint-doctor finding)

**Finding confirmed from the Lean side.**

The blueprint uses `\cref{thm:rigidity_genus0_curve_to_AV}` at **two locations**:
- Line 69 (introductory prose): `headline \cref{thm:rigidity_genus0_curve_to_AV}`
- Line 270 (`lem:rigidity_eqOn_dense_open` formalization note): `consumers \cref{prop:morphism_P1_to_AV_constant} and \cref{thm:rigidity_genus0_curve_to_AV} (Lean \texttt{rigidity\_genus0\_curve\_to\_grpScheme})`

The **actual label** of the theorem is `\label{prop:rigidity_genus0_curve_to_AV}` (line 1796). There is no `\label{thm:rigidity_genus0_curve_to_AV}` anywhere in this chapter or any other visible chapter. The `thm:` prefix is wrong; it should be `prop:`.

**Lean-side verdict:** The `\cref` mismatch is a **blueprint-only** error. The Lean declaration `rigidity_genus0_curve_to_grpScheme` exists, is correctly pinned via `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` at the `prop:rigidity_genus0_curve_to_AV` block (line 1798), and was never renamed. The dangling `\cref{thm:rigidity_genus0_curve_to_AV}` is a stale label reference (the comment at line 14 also uses the `thm:` prefix, suggesting the theorem was originally drafted with a `thm:` label and then the block was created with `prop:` instead). Fix: replace both `\cref{thm:rigidity_genus0_curve_to_AV}` occurrences with `\cref{prop:rigidity_genus0_curve_to_AV}`.

---

## Red flags

None found in `AlgebraicJacobian/AbelianVarietyRigidity.lean`.

- No `:= sorry` on any declaration the blueprint claims is substantive and closed.
- No excuse-comments; all `sorry` items carry honest status notes and correct tier/gate annotations.
- No `axiom` declarations.
- `iotaGm_chart1_composition_isOpenImmersion` (L225, L251) has `sorry` but is a private Tier-3 helper explicitly documented as iter-184+ target; the blueprint has no block claiming it is done.
- `iotaGm_isDominant` (L347) has `sorry`, documented as gated on Lane A; blueprint NOTE agrees.
- `genusZero_curve_iso_P1` (L565) has `sorry`, documented as RR bridge; blueprint references it as an unformalised prerequisite.

---

## Unreferenced declarations (informational)

All of the following are **private** helpers and their absence from the blueprint is correct:

| Declaration | Status | Note |
|---|---|---|
| `iotaGm_onePt_chart1_factor` | PROVEN axiom-clean (iter-184) | sub-task (b), private |
| `iotaGm_inner_lift_compat` | PROVEN | sub-task (f) compat, private |
| `iotaGm_chart1_section` | noncomputable def | sub-task (f) section, private |
| `iotaGm_chart1_composition_isOpenImmersion` | sorry (iter-184+) | sub-task (f), private |
| `iotaGm_range_isOpen` | kernel-clean modulo upstream | private bridge |
| `iotaGm_isDominant` | sorry (gated Lane A) | private bridge |
| `morphism_P1_to_grpScheme_const_aux` | sorry-free body, propagated sorryAx | private basepoint helper |

Public declaration `genusZero_curve_iso_P1` (L565) has no `\lean{...}` pin **in this chapter**, but its blueprint coverage belongs to `RiemannRoch_RationalCurveIso.tex` (out of scope for this check).

---

## Blueprint adequacy for this file

- **Coverage**: 2/3 public Lean declarations in AVR.lean have `\lean{...}` pins here (`morphism_P1_to_grpScheme_const`, `rigidity_genus0_curve_to_grpScheme`). The third (`genusZero_curve_iso_P1`) is covered by the RiemannRoch chapter.
- **Proof-sketch depth**: **adequate** for the two pinned declarations. The `𝔾ₘ`-scaling shortcut and the iso-transport proof are described in sufficient detail.
- **Hint precision**: **precise** — both `\lean{...}` pins name the exact Lean declarations; the type signatures stated in prose match the Lean signatures.
- **Generality**: **matches need** — the prose correctly notes that `[Smooth A.hom]` and `[GeometricallyIrreducible A.hom]` are carried (blueprint lines 1810–1813), matching the Lean signature.
- **Recommended chapter-side actions**:
  1. Replace `\cref{thm:rigidity_genus0_curve_to_AV}` with `\cref{prop:rigidity_genus0_curve_to_AV}` at lines 69 and 270 (two occurrences).
  2. Optionally: update the `% NOTE` comment at line 14 from `thm:rigidity_genus0_curve_to_AV` to `prop:rigidity_genus0_curve_to_AV` for internal consistency.

---

## Severity summary

### must-fix-this-iter
None.

### major
- **Blueprint cross-reference `\cref{thm:rigidity_genus0_curve_to_AV}` is dangling** (lines 69 and 270): the correct label is `prop:rigidity_genus0_curve_to_AV`. Two occurrences. The blueprint will produce a LaTeX cross-reference error or silently link to nothing. Fix is a two-line s/thm:/prop:/ substitution.

### minor
- The comment at blueprint line 14 (`% ... headline thm:rigidity_genus0_curve_to_AV ...`) also uses the wrong prefix but is a `%`-comment so does not affect the compiled document. Low-priority cleanup.

---

**Overall verdict:** AVR.lean is faithful to the blueprint for the two pinned public declarations; no laundering, no signature drift, no placeholder abuse. The one actionable finding is a **major** dangling `\cref{}` in the blueprint (label prefix mismatch `thm:` vs `prop:`), confirmed from the Lean side as a blueprint-only error — the Lean target was never renamed.
