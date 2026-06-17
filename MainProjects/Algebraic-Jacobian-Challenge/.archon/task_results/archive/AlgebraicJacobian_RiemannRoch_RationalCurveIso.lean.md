# AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean — iter-193 Lane RCI Pin 3 Step 2 carving

**Result**: HARD BAR MET. Helper (c) closed AXIOM CLEAN. Helpers (a) and (d) carved as named typed-sorry private theorems with documented closure paths. `iso_of_degree_one` body refactored to assemble through the three helpers, slice-lift inline axiom-clean.

**Build state**: GREEN (`success: true`). Sorries: 3 (1 pre-existing at L521 `Hom.poleDivisor_degree_eq_finrank`'s `?hlp` from iter-193 plan-phase refactor — NOT my concern per PROGRESS directive; 2 new typed sorries at L723 helper (a) + L782 helper (d)).

**Net sorry delta vs entering iter-193 prover phase**: 2 → 3 (+1; planned: helpers (a)+(d) replace monolithic iter-189 `sorry` in `iso_of_degree_one` body; helper (c) is axiom-clean and the assembly chain is axiom-clean).

**Axioms on the axiom-clean helper (c)**: `propext, Classical.choice, Quot.sound` (kernel only — verified via `lean_verify AlgebraicGeometry.Scheme.phi_left_toNormalization_isIso_of_isIntegralHom`). No `sorryAx`.

## Pin 3 Step 2 carving (line 670–795)

### Helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` (line 723)
**Status**: typed sorry. Signature pins `LocallyQuasiFinite φ.left` under finrank-1 hypothesis + smooth-proper-curve typeclass package.

**Closure path (iter-194+)**: fibre-dimension argument via Mathlib `LocallyQuasiFinite.of_fiberToSpecResidueField` (verified to typecheck via `lean_multi_attempt`; `apply LocallyQuasiFinite.of_fiberToSpecResidueField; intro y` reduces to `LocallyQuasiFinite (φ.left.fiberToSpecResidueField y)` per fibre). Each fibrewise step needs "smooth-dim-1 + integral ⟹ fibre 0-dim" wrapper — Mathlib gap. Generic fibre: `Spec K(C)` over `Spec K(C')`, dim `[K(C):K(C')] = 1` by `_hφ_deg`.

**Combined effect**: once closed, chains with existing `[IsProper φ.left]` via `IsFinite.of_isProper_of_locallyQuasiFinite` (Mathlib `ZariskisMainTheorem`, Stacks 02LS) to deliver `[IsFinite φ.left]`, which auto-derives `[IsAffineHom φ.left]` and `[IsIntegralHom φ.left]`.

### Helper (c) `phi_left_toNormalization_isIso_of_isIntegralHom` (line 760) — **AXIOM CLEAN**
**Status**: closed via Mathlib's instance `AlgebraicGeometry.Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` (`Mathlib.AlgebraicGeometry.Normalization` line 281). Body: `inferInstance`. Hartshorne I.6.12 / Stacks 0AVX, Mathlib half.

### Helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (line 782)
**Status**: typed sorry. Signature pins `IsIso φ.left.fromNormalization` under smooth-proper-curve target + finrank-1.

**Closure path (iter-194+)**: smooth ⟹ regular ⟹ normal ⟹ integrally closed; combined with `K(C) = K(C')` from finrank=1, the integral closure of `Γ(C', U)` in `Γ(C, (φ.left)⁻¹ U)` is `Γ(C', U)` itself, so `fromNormalization` collapses to identity on `C'`.

**Mathlib gaps flagged**:
1. No `AlgebraicGeometry.IsNormalScheme` class.
2. No `Smooth.curve_isNormal_at_field` lemma (smooth-curve sections are Dedekind).
3. (For helper (a)) No "smooth-dim-1 morphism ⟹ fibre is 0-dimensional" wrapper.

iter-194 candidate `mathlib-analogist` dispatch on (1)+(2) per PROGRESS Lane M↓ pattern.

## Assembly (line 870–940)

The body of `iso_of_degree_one` (now sorry-free in its own body):
1. Step 1 (axiom-clean, iter-189): function-field iso `K(C') ≃+* K(C)` via `Subalgebra.bot_eq_top_of_finrank_eq_one`.
2. Step 2(b) (axiom-clean, iter-190+): `[IsProper φ.left]`, `[QuasiCompact φ.left]`, `[QuasiSeparated φ.left]`, `[LocallyOfFiniteType φ.left]`.
3. Step 2(a) (via helper a): `[LocallyQuasiFinite φ.left] → [IsFinite φ.left] → [IsIntegralHom φ.left]`.
4. Step 2(c) (axiom-clean via helper c): `[IsIso φ.left.toNormalization]`.
5. Step 2(d) (via helper d): `[IsIso φ.left.fromNormalization]`.
6. Step 2 assembly (axiom-clean): `[IsIso φ.left]` via `Scheme.Hom.toNormalization_fromNormalization` factorisation rewrite.
7. Step 2 slice-lift (axiom-clean): `⟨CategoryTheory.Over.isoMk (asIso φ.left)⟩` — commutation triangle auto-discharged by `cat_disch` via `φ.w`.

## Section structure

Helpers placed BEFORE the `iso_of_degree_one` declaration docstring (after the §3 section header `/-! ## §3 ... -/`). Original docstring (lines 799–852) preserved verbatim and attaches to the theorem on line 853. Required restructure to avoid the docstring-orphaning parse error (`unexpected token '/-!'; expected 'lemma'`) when section header / helpers separated docstring from declaration.

## iso_of_degree_one (line 853, originally line 721)
### Attempt 1 (iter-193 fine-grained)
- **Approach**: carve helpers (a)/(c)/(d), close (c) axiom-clean, assemble through factorisation + slice lift.
- **Result**: RESOLVED — body sorry-free; depends on helpers (a)+(d) typed sorries.
- **Key insight**: Mathlib's `[IsIntegralHom f] : IsIso f.toNormalization` (Normalization.lean L281) is the Mathlib half of Hartshorne I.6.12 / Stacks 0AVX. Combined with `Scheme.Hom.toNormalization_fromNormalization` and `CategoryTheory.Over.isoMk` (slice lift, commutation auto-discharged), the assembly is axiom-clean modulo (a)+(d).
- **Lemmas found**:
  - `AlgebraicGeometry.IsFinite.of_isProper_of_locallyQuasiFinite` (Stacks 02LS / Mathlib `ZariskisMainTheorem.lean:363`).
  - `AlgebraicGeometry.Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` (`Normalization.lean:281`).
  - `AlgebraicGeometry.Scheme.Hom.toNormalization_fromNormalization` (`Normalization.lean:186`).
  - `CategoryTheory.Over.isoMk` + `cat_disch` auto-commutation (`Comma/Over/Basic.lean:137`).
  - `CategoryTheory.Over.forget_reflects_iso` (existence noted but not directly invoked).

## Dead ends + negative results
- Searched for `IsNormalScheme` / `Scheme.IsNormal` in Mathlib — does not exist (only `IsIntegrallyClosed` at ring level, `IsNormal` in field theory / order theory / category theory contexts unrelated to schemes).
- Searched for "smooth-curve is Dedekind" lemma in Mathlib — does not exist.
- Searched for `LocallyQuasiFinite.of_finrank` or similar shortcut — does not exist (Mathlib `LocallyQuasiFinite.of_fiberToSpecResidueField` is the only reduction route; needs per-fibre quasi-finiteness which needs the smooth-curve fibre-dim collapse).
- Tried `IsFinite.of_locallyQuasiFinite` (needs `IsLocallyArtinian Y` — not satisfied for our 1-dim target `C'.left`).
- The "Mathlib gap" verdict in iter-189/192/193 PROGRESS is confirmed: closing helpers (a) and (d) requires non-trivial project-side infrastructure or new Mathlib substrate.

## Blueprint markers
- `lem:degree_one_morphism_iso` (helper for `iso_of_degree_one`): chapter `RiemannRoch_RationalCurveIso.tex` lines 296–347. Statement formalized; body now sorry-free at theorem-decl level. The deterministic `sync_leanok` pass between prover and review will read `sorry`-count via `sorry_analyzer` and emit `\leanok` accordingly — since `iso_of_degree_one` itself is sorry-free at the body but depends on two sorrified private helpers, the `\leanok` decision is `sync_leanok`'s. Do not manually mark.
- New helpers (a), (c), (d) are file-private; not blueprint-pinned, so no `\lean{...}` cross-reference and no `\leanok` decision needed.

## Iter-194 candidate work
1. Close helper (a) via fibre-dimension argument or `mathlib-analogist` consult on "smooth-dim-1 morphism fibre 0-dim".
2. Close helper (d) via project-side `IsNormalScheme` substrate + "smooth-curve sections Dedekind" link, OR direct chase into `Scheme.Hom.normalizationDiagram`.
3. Close `Hom.poleDivisor_degree_eq_finrank ?hlp` at L521 (iter-193 plan-phase refactor punted to iter-194+ per directive; orthogonal to this work).
