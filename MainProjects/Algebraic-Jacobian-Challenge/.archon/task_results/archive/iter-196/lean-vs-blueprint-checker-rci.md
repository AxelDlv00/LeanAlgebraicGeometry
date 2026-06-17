# Lean ↔ Blueprint Check Report

## Slug
rci

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections}` (chapter: `lem:morphism_to_p1_from_global_sections`)
- **Lean target exists**: yes (line 218)
- **Signature matches**: partial — the blueprint prose states the input as "an invertible sheaf ℒ and two global sections s₀, s₁ ∈ H⁰(X, ℒ)"; the Lean signature takes a graded ring hom `f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤)` plus `_halg` + `_hf`. The blueprint's own proof text explicitly documents this reduction (§2 of the proof, lines 128–144), so the shape divergence is intentional and documented, not a mismatch.
- **Proof follows sketch**: partial — the blueprint proof (line 141–144) states the body "chains `Proj.fromOfGlobalSections` with the chart-restriction-and-glue pattern of `Scheme.Cover.glueMorphisms`." The actual Lean body (lines 234–258) uses `Over.homMk (Proj.fromOfGlobalSections …)` with a direct section-condition proof; it does NOT invoke `Scheme.Cover.glueMorphisms`. The mathematical result is identical, but the proof route diverges from the blueprint description at the tactic level.
- **notes**: Blueprint `\leanok` present on both statement (L83) and proof (L112). No sorry in body. The `Scheme.Cover.glueMorphisms` reference in the blueprint is a stale description of the intended approach; the Lean uses the cleaner `Over.homMk` direct wrap. Minor documentation drift.

---

### `\lean{AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor}` (chapter: `lem:degree_via_pole_divisor`)
- **Lean target exists**: yes (line 691)
- **Signature matches**: yes — the blueprint states "there exists D ∈ Div(C) such that D = φ^∗[∞] and deg(D) = [K(C):k̄(ℙ¹)]"; the Lean output type is `∃ (D : C.left.WeilDivisor), D = Scheme.Hom.poleDivisor φ ∧ Scheme.WeilDivisor.degree D = (Module.finrank … : ℤ)`, matching precisely. The convention note in the blueprint (lines 199–214) explicitly identifies `Scheme.Hom.poleDivisor φ` as the Lean name for φ^∗[∞].
- **Proof follows sketch**: yes — the Lean body (lines 712–718) is a 3-line assembly `⟨Scheme.Hom.poleDivisor φ, rfl, Hom.poleDivisor_degree_eq_finrank φ _hφ_non_const⟩`, reducing to the named helper `Hom.poleDivisor_degree_eq_finrank`. The blueprint proof (lines 248–286) describes this reduction to a multiplicativity-of-degree identity, consistent with the `WeilDivisor.degree_positivePart_principal_eq_finrank` chain used in the helper.
- **notes**: Blueprint `\leanok` on statement (L162) and proof (L250). Own proof body is sorry-free; sorry is inside `Hom.poleDivisor_degree_eq_finrank` → `localParameterAtInfty_uniformiser_witness`. Per project `\leanok` convention (direct body only), marking is correct.

---

### `\lean{AlgebraicGeometry.Scheme.iso_of_degree_one}` (chapter: `lem:degree_one_morphism_iso`)
- **Lean target exists**: yes (line 1032)
- **Signature matches**: yes — the blueprint states "non-constant morphism φ: C → C' with [K(C):K(C')] = 1 → φ is an isomorphism"; the Lean output is `Nonempty (C ≅ C')` with inputs `(_hφ_non_const : ∀ Q, φ ≠ toUnit C ≫ Q)` + `[Algebra C'.left.functionField C.left.functionField]` + `(_hφ_deg : Module.finrank C'.left.functionField C.left.functionField = 1)`. Blueprint explicitly specifies the `Nonempty (C ≅ C')` form at line 423.
- **Proof follows sketch**: yes — the blueprint 4-step chain (lines 415–429: quasi-finite → finite → toNormalization iso → fromNormalization iso → assemble) maps exactly onto the Lean body assembly (lines 1067–1109). Steps (c) and (d) remain sorry via private helpers, as documented.
- **notes**: Blueprint `\leanok` on statement (L315) and proof (L375). The Lean body is sorry-free at its own level, delegating to helpers (a) and (d) which carry sorries. Correct per project convention.

---

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `thm:genus_zero_curve_iso_p1`)
- **Lean target exists**: yes — in `AbelianVarietyRigidity.lean:290`, not in this file. Blueprint and Lean file header explicitly document this cross-file pin (Lean file §0, lines 137–161; blueprint L434–458).
- **Signature matches**: N/A for this file (out-of-file declaration).
- **Proof follows sketch**: N/A (sorry body in AbelianVarietyRigidity.lean; that file is not in scope).
- **notes**: Cross-reference correctly documented in both blueprint and Lean file.

---

## Red flags

### Placeholder / suspect bodies

Three private helper theorems carry `:= sorry` bodies:

- `localParameterAtInfty_uniformiser_witness` at line 463: body is `:= sorry`. Blueprint does NOT directly `\lean{...}`-reference this private helper. The sorry is a named typed-sorry with a 3-step documented closure path (docstring lines 426–460); the directive confirms this is "unchanged (3-step substrate gap documented in iter-195)." Classification: **not a must-fix** — private helper, named typed sorry, known substrate gap.

- `phi_left_locallyQuasiFinite_of_finrank_one` at line 873 (sorry at line 919): body is partially substantive (derives `IsProper φ.left`, `LocallyOfFiniteType φ.left`, applies `LocallyQuasiFinite.of_finite_preimage_singleton`) then hits `sorry` for `(φ.left ⁻¹' {x}).Finite`. Private helper for `iso_of_degree_one`. Documented Mathlib gap ("smooth-dim-1 ⟹ 0-dim fibre"). Classification: **not a must-fix** — private helper, partial proof with named gap, Mathlib substrate absent.

- `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` at line 962 (sorry at line 976): body is `:= sorry`. Private helper for `iso_of_degree_one`. Documented Mathlib gap (`IsNormalScheme` substrate absent). Directive confirms "unchanged (gated on `IsNormalScheme` Mathlib substrate)." Classification: **not a must-fix** — private helper, known substrate gap.

No axiom declarations, no `Classical.choice` on non-trivial claims, no `:= True` or `:= rfl` on substantive claims.

### Excuse-comments

None found. All comments on sorry'd helpers honestly document substrate gaps with closure paths. No "wrong but works for now" language.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` reference in the blueprint chapter:

| Declaration | Status | Note |
|---|---|---|
| `localParameterAtInfty` (line 304) | private, substantive body | Substrate for `Hom.poleDivisor`; described in blueprint as "t_∞ ∈ K(ℙ¹)" prose, not pinned. Acceptable. |
| `localParameterAtInfty_uniformiser_witness` (line 463) | private, sorry | Substrate for `Hom.poleDivisor_degree_eq_finrank`; iter-195 named structural lift. Acceptable as private helper. |
| `Hom.poleDivisor` (line 531) | **public** noncomputable def | Appears in the statement of `morphism_degree_via_pole_divisor`; described in blueprint convention note (L199–214) but has NO `\lean{...}` block of its own. **Flagged below.** |
| `Hom.poleDivisor_degree_eq_finrank` (line 593) | **public** theorem | Core lemma feeding `morphism_degree_via_pole_divisor`; described in blueprint prose but no `\lean{...}` block. **Flagged below.** |
| `algebraMap_bijective_of_finrank_one` (line 817) | private, axiom-clean | Pure algebra helper. Acceptable. |
| `phi_left_functionField_algEquiv_of_finrank_one` (line 835) | private, axiom-clean | Substrate helper. Acceptable. |
| `phi_left_locallyQuasiFinite_of_finrank_one` (line 873) | private, sorry | Helper (a) for `iso_of_degree_one`. Acceptable. |
| `phi_left_toNormalization_isIso_of_isIntegralHom` (line 933) | private, axiom-clean | Helper (c) for `iso_of_degree_one`. Acceptable. |
| `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (line 962) | private, sorry | Helper (d) for `iso_of_degree_one`. Acceptable. |

`Hom.poleDivisor` and `Hom.poleDivisor_degree_eq_finrank` are public and substantive. The blueprint describes them in prose but does not pin them with `\lean{...}` blocks. Since the project is iterative and these are introduced as sub-lemmas in service of `lem:degree_via_pole_divisor`, omitting dedicated `\lean{...}` blocks is a minor coverage gap, not a critical one.

---

## Blueprint adequacy for this file

### Coverage
3/3 `\lean{...}`-pinned declarations have corresponding blueprint blocks (the 4th, `genusZero_curve_iso_P1`, is cross-file and correctly documented as such). Unreferenced: 2 public substantive declarations (`Hom.poleDivisor`, `Hom.poleDivisor_degree_eq_finrank`) + 7 private helpers (all acceptable). The 2 public unreferenced declarations are discussed in blueprint prose but not pinned.

### Focus-area: iter-196 preimage-finiteness route for `phi_left_locallyQuasiFinite_of_finrank_one`

The directive's primary question is whether the blueprint adequately describes the iter-196 body reformulation of `phi_left_locallyQuasiFinite_of_finrank_one` (lines 873–919): replacing the abstract per-fibre LQF goal with the concrete `(φ.left ⁻¹' {x}).Finite` reduction via `LocallyQuasiFinite.of_finite_preimage_singleton`.

**Formal proof block** (`\begin{proof}` of `lem:degree_one_morphism_iso`, blueprint lines 372–430): does NOT mention `phi_left_locallyQuasiFinite_of_finrank_one`'s internal mechanics at all. The proof sketch describes the high-level 4-step chain: (1) proper + quasi-finite → finite, (2) `toNormalization` iso, (3) `fromNormalization` iso, (4) assemble. The `of_finite_preimage_singleton` tactic and the `(φ.left ⁻¹' {x}).Finite` formulation are not mentioned. Since `phi_left_locallyQuasiFinite_of_finrank_one` is a private helper, this level of omission is acceptable — the blueprint correctly describes Step (1) as "proper + quasi-finite" without needing to name the Mathlib lemma used for the reduction.

**NOTE comment** (blueprint lines 299–312, `% NOTE (iter-194 reviewer)`): this is **stale**. It says "Helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` body was reduced via `LocallyQuasiFinite.of_fiberToSpecResidueField` to a per-fibre LQF statement." The iter-196 Lean body (line 912) uses `LocallyQuasiFinite.of_finite_preimage_singleton` (Mathlib `QuasiFinite.lean:295`), not `of_fiberToSpecResidueField`. The NOTE is a `%`-comment (review annotation), not part of the formal proof sketch, but it will mislead future provers who consult it. This is a **minor** adequacy deficiency.

**Verdict on blueprint adequacy for this focus area**: The formal `\begin{proof}` block is adequate (the private helper's internals need not be described). The stale NOTE comment should be updated by the review agent to reflect the iter-196 change.

### Proof-sketch depth
**Adequate** overall. All three `\lean{...}`-pinned declarations have corresponding `\begin{proof}` blocks with sufficient detail for the formalized argument. No proof in the Lean file embodies mathematical steps the blueprint sketches do not preview at the appropriate level.

### Hint precision
**Precise**. All `\lean{...}` references correctly name the Lean declarations. Signature matches are correct (the `morphismToP1OfGlobalSections` shape divergence is intentional and documented in the blueprint itself).

### Generality
**Matches need**. No narrowness gap detected.

### Recommended chapter-side actions

1. **Update the NOTE comment at lines 299–312** (before `\begin{lemma}` for `lem:degree_one_morphism_iso`): replace the stale iter-194 description `LocallyQuasiFinite.of_fiberToSpecResidueField` with `LocallyQuasiFinite.of_finite_preimage_singleton` and update the residual gap description from "per-fibre LQF statement" to "`(φ.left ⁻¹' {x}).Finite` for all `x : C'.left`." [Minor; review-agent domain: `% NOTE:` annotation update.]

2. *(Optional)* Add a brief `\lean{AlgebraicGeometry.Scheme.Hom.poleDivisor}` block in the blueprint's Pin 2 section to pin the pole-divisor definition explicitly, since it appears in the statement of `lem:degree_via_pole_divisor` and is a substantive public definition. [Minor; blueprint coverage.]

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
  1. Blueprint NOTE comment (L299–312) stale: names `LocallyQuasiFinite.of_fiberToSpecResidueField` but iter-196 Lean uses `LocallyQuasiFinite.of_finite_preimage_singleton`. Does not mislead at the proof-sketch level but will confuse anyone consulting the annotation.
  2. Blueprint proof description of `morphismToP1OfGlobalSections` (L141–144) mentions `Scheme.Cover.glueMorphisms`; the Lean body uses `Over.homMk` directly. Stale proof-approach description.
  3. `Hom.poleDivisor` and `Hom.poleDivisor_degree_eq_finrank` are public substantive declarations with no `\lean{...}` pin in the blueprint (described only in prose convention notes).

**Overall verdict**: The file faithfully implements the blueprint with no signature mismatches or unauthorized sorries on blueprint-pinned declarations; the three minor findings are stale documentation in `%` comment annotations and a coverage gap on two public helper declarations, none blocking this iter.
