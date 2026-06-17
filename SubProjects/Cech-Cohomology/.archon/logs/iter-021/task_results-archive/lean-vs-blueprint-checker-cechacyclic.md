# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
020

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (1200 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (covers CechAcyclic.lean via `% archon:covers`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: yes — `{R : CommRingCat.{u}} {S : Scheme.{u}} (f : Spec R ⟶ S) [IsAffineHom f] {ι : Type u} [Finite ι] (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤) (F : (Spec R).Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f ...).homology p)`. This matches the blueprint statement (affine vanishing, relative form with `f : Spec R ⟶ S`).
- **Proof follows sketch**: N/A — body is `sorry`; blueprint has no `\leanok` on `lem:cech_acyclic_affine`, confirming this is an authorized unfinished state.
- **notes**: The directive explicitly identifies this sorry as intentional (the "superseded relative-form"). The module-level comment and the inline `-- L1 (STILL MISSING)` comments describe valid in-progress architecture, not claims of completion. No red flag.

### `\lean{AlgebraicGeometry.sectionCech_affine_vanishing}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: no — absent from the Lean file. Closest existing declaration is `CechAcyclic.affine` (superseded relative form) and `SectionCechModule.dDiff_exact` (step (a) of the proof).
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint explicitly notes (`% NOTE:` at line 815–820) that this is a pending re-signing of the top-level target to the section-complex form. No `\leanok` on the block — the absence is an authorized unbuilt state, not a regression.

### `\lean{AlgebraicGeometry.sectionCech_homology_exact}` (chapter: `lem:section_cech_homology_exact`)
- **Lean target exists**: no — entirely absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok` on `lem:section_cech_homology_exact`, confirming the authorized unbuilt state. This is the "step (c)" Ab-product↔pi homology bridge flagged by the prover as needing an effort-break. The companion infrastructure (`qcohSectionsAwayLocalized`, `qcohRestriction_eq_comparison`, `SectionCechModule.dDiff_exact`) is all axiom-clean.

### `\lean{AlgebraicGeometry.qcohSectionsAwayLocalized}` (chapter: `def:qcoh_sections_localized`)
- **Lean target exists**: yes (line 1164)
- **Signature matches**: yes — `{R : CommRingCat.{u}} {ι : Type u} (M : ModuleCat.{u} R) {n : ℕ} (s : ι → R) (σ : Fin n → ι) : IsLocalizedModule (Submonoid.powers (∏ k, s (σ k))) (AlgebraicGeometry.tilde.toOpen M (⨅ k, PrimeSpectrum.basicOpen (s (σ k)))).hom`. Matches the blueprint's "multi-index intersection" claim. Blueprint has `\leanok` on this block. ✓
- **Proof follows sketch**: yes — proof uses `basicOpen_sprod` to rewrite the infimum as the basic open of the product, then infers the Mathlib `IsLocalizedModule (.powers g)` instance.
- **notes**: Clean. Correctly generalises from the single-open Mathlib instance to multi-indices via `basicOpen_sprod`.

### `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact}` (chapter: `lem:section_cech_module_exact`)
- **Lean target exists**: yes (line 1081)
- **Signature matches**: yes — `[Finite ι] (hs : Ideal.span (Set.range s) = ⊤) (m : ℕ) : Function.Exact (dDiff s M (m + 1)) (dDiff s M (m + 2))`. Matches blueprint statement. Blueprint has `\leanok` on statement AND proof blocks. ✓
- **Proof follows sketch**: yes — proof uses `exact_of_isLocalized_span` (L2), `fLoc_isLocalizedModule`, `map_dDiff_eq_locDiff`, and `locDiff_exact` (which is `CechLocalized.cechLocalized_exact`, the dependent combinatorial port). This is precisely the blueprint's "local-to-global via spanning family → identification with locDiff → depDiff_exact" sketch.
- **notes**: Axiom-clean. The `spanIdx`/`spanIdx_spec` bookkeeping for the spanning-set index is correctly handled by `classical` + the opaque helper.

### `\lean{AlgebraicGeometry.AwayComparison.*}` declarations (chapter: `lem:section_cech_homology_exact`)
- **Lean target exists**: yes — all 12 named `AwayComparison` declarations present (lines 486–667): `Inverts`, `Inverts.of_dvd`, `Inverts.mul`, `Inverts.isUnit_powers`, `comparison`, `comparison_apply`, `comparison_comp_structure`, `comparison_unique`, `comparison_self`, `comparison_comp`, `comparison_comp_apply`, `Inverts.smul_pow_cancel`, `comparison_isLocalizedModule`.
- **Signature matches**: yes — each matches its blueprint description.
- **Proof follows sketch**: yes (no sorry in any).
- **notes**: All axiom-clean.

### `\lean{AlgebraicGeometry.CechLocalized.*}` declarations (chapter: `lem:section_cech_homology_exact`)
- **Lean target exists**: yes — all 9 named `CechLocalized` declarations present (lines 683–857): `sprod`, `sprod_cons`, `sprod_succAbove_dvd`, `cechCoeff`, `cechCoface`, `cechPrepend`, `cechCoeff_transport_eq_comparison`, `cech_hu`, `cech_hsh`, `cech_hcomm`, `cechLocalized_exact`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes (no sorry in any).
- **notes**: All axiom-clean. `cechLocalized_exact` correctly instantiates `depDiff_exact` with the concrete `cechCoface`/`cechPrepend` maps and the `hu`/`hsh`/`hcomm` compatibilities.

### `\lean{AlgebraicGeometry.SectionCechModule.*}` declarations (chapter: `def:section_cech_module_complex`)
- **Lean target exists**: yes — all 17 named `SectionCechModule` declarations present (lines 881–1104).
- **Signature matches**: yes.
- **Proof follows sketch**: yes (no sorry in any).
- **notes**: All axiom-clean.

### `\lean{AlgebraicGeometry.CombinatorialCech.*}` declarations (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes — all 20 named `CombinatorialCech` declarations present (lines 143–460), all private.
- **Signature matches**: yes — the private status is consistent with the blueprint's statement that these are helpers bundled under `lem:cech_acyclic_affine`.
- **Proof follows sketch**: yes (no sorry in any).
- **notes**: All axiom-clean.

---

## Red flags

### Placeholder / suspect bodies
*(none beyond the authorized sorry)*

The single `sorry` at line 109 (`CechAcyclic.affine`) is explicitly authorized: `lem:cech_acyclic_affine` carries no `\leanok` in the blueprint, and the directive marks it as the intentional superseded form. No other declaration has a sorry, a trivially-true body, or a `Classical.choice _` on a non-trivial claim.

### Excuse-comments
*(none)*

The inline comments in `CechAcyclic.affine` (lines 79–108) are architectural documentation identifying the L1 bridge as the missing step. They correctly describe what IS available (`CombinatorialCech.*`, `depDiff_exact`) and what IS missing (the categorical→module bridge). These are accurate working notes, not claims that wrong code is right.

### Axioms / Classical.choice on non-trivial claims
*(none)*

No `axiom` declarations. The `classical` tactic in `dDiff_exact` (line 1083) is used only to provide `Classical.decEq`-style instances for `ClassicalDecidableEq` inside `exact_of_isLocalized_span`; this is standard Mathlib practice and does not introduce a new axiom beyond those already in `Mathlib`.

---

## Unreferenced declarations (informational)

The following **non-private** declarations are present in the Lean file but lack a `\lean{...}` entry in the blueprint:

| Declaration | Line | Concern |
|---|---|---|
| `AlgebraicGeometry.basicOpen_sprod` | 1140 | Substantive named lemma used directly by `qcohSectionsAwayLocalized`; should be referenced in `def:qcoh_sections_localized` or `lem:section_cech_homology_exact`. |
| `AlgebraicGeometry.qcohRestriction_eq_comparison` | 1182 | Named target for the "differential brick" of step (c); the blueprint describes its content in `def:qcoh_sections_localized` item (5) but gives no `\lean{}` entry. This is a prerequisite for `sectionCech_homology_exact`. |

Private helpers (`iInf_fin_succ`, `spanIdx`, `spanIdx_spec`, all `CombinatorialCech.*`) are appropriately unlisted.

---

## Blueprint adequacy for this file

### Coverage
- Declarations with a `\lean{...}` entry: 53 of 55 named declarations (all except `basicOpen_sprod` and `qcohRestriction_eq_comparison`).
- Unreferenced non-helpers: 2 (`basicOpen_sprod`, `qcohRestriction_eq_comparison`).
- Unreferenced helpers: private `iInf_fin_succ`, private `spanIdx`/`spanIdx_spec` — acceptable.

### Proof-sketch depth
**Under-specified** at one specific point: `lem:section_cech_homology_exact`.

The blueprint's proof sketch (lines 657–688) identifies the correct mathematical route:
1. Term identification (each intersection is `D(s_σ)`, sections are `M_{s_σ}`) via `def:qcoh_sections_localized`.
2. Differential identification (each face restriction is the localisation map) via item (5) of `def:qcoh_sections_localized`.
3. `IsZero(homology p)` ⟺ `ExactAt` ⟺ `Function.Exact` via `exactAt_iff_isZero_homology` and `ShortComplex.moduleCat_exact_iff`.

However, the blueprint does **not** pin:
- The Lean type of the "section Čech complex" (whether it is a `CochainComplex Ab ℕ`, a `CochainComplex (ModuleCat R) ℕ`, or an `Ab`-complex from `sectionCechComplex` in `PresheafCech.lean`).
- The Lean signature of `sectionCech_homology_exact` itself (iff? two implications? a cochain complex isomorphism object?).
- How to build the cochain complex isomorphism from the degreewise identifications `qcohSectionsAwayLocalized` and `qcohRestriction_eq_comparison` in Lean's `CochainComplex`/`HomologicalComplex` API.

This is the specific "effort-break" the prover flagged: the Lean plumbing for assembling the complex isomorphism from degreewise data is not previewed. A prover must look up the `HomologicalComplex.ext`-type lemmas and the correct form of `ExactAt`-to-`Function.Exact` transfer independently. The mathematical content is correct; the Lean-framework assembly is silent.

All other blueprint blocks — `def:qcoh_sections_localized`, `def:section_cech_module_complex`, `lem:section_cech_module_exact`, and the combinatorial helpers — have adequate or detailed proof sketches; the declarations they cover ARE formalized correctly.

### Hint precision
**Loose** for `lem:section_cech_homology_exact`: the `\lean{...}` block names `sectionCech_homology_exact` but the blueprint text does not give its type signature or whether the statement is an iff or a directed implication.

**Precise** for all other blocks — the `\lean{...}` names match what is in the file and the signatures match the prose.

### Generality
**Matches need** for all blocks except the two unreferenced declarations above, which are present and used but not referenced.

### Recommended chapter-side actions

1. **Add `\lean{AlgebraicGeometry.basicOpen_sprod}` to `def:qcoh_sections_localized`** — it formalises the multi-index intersection `⋂ₖ D(s_{σ k}) = D(s_σ)` and is the first step of `qcohSectionsAwayLocalized`'s proof. Currently neither referenced nor described with a label.

2. **Add `\lean{AlgebraicGeometry.qcohRestriction_eq_comparison}` to `def:qcoh_sections_localized`** — it formalises item (5) of the definition (restriction = localisation comparison) for the `tilde M` case. The blueprint describes its content in prose (`tilde.toOpen_res` gives the restriction compatibility) but gives no `\lean{}` entry and no formal label; this makes it invisible to coverage tracking and to the prover who needs to discharge the differential identification step of `lem:section_cech_homology_exact`.

3. **Expand the proof sketch of `lem:section_cech_homology_exact`** at the Lean-framework level:
   - State the intended Lean signature explicitly (e.g., `lemma sectionCech_homology_exact ... : IsZero (sectionCechComplex ...).homology p ↔ Function.Exact (dDiff ...) (dDiff ...)`).
   - Name the Lean API for building a cochain complex isomorphism from degreewise linear isomorphisms (`HomologicalComplex.isoOfComponents` or `CochainComplex.mk`-style); this is the step the prover was blocked on.
   - Clarify that the section complex (`sectionCechComplex`) lives in `CochainComplex Ab ℕ` (from `PresheafCech.lean`) and `D•` lives in `CochainComplex (ModuleCat R) ℕ`, so the isomorphism needs to go through `ModuleCat.forget₂` or a `forget` functor application; OR confirm the statement is formulated purely in `ModuleCat R` using `SectionCechModule.dDiff_exact` directly.

---

## Severity summary

| Finding | Classification |
|---|---|
| `basicOpen_sprod` lacks `\lean{}` entry in blueprint | **major** |
| `qcohRestriction_eq_comparison` lacks `\lean{}` entry in blueprint | **major** |
| `lem:section_cech_homology_exact` proof sketch under-specified at Lean-framework level (cochain complex isomorphism assembly) | **major** |
| `sectionCech_homology_exact` and `sectionCech_affine_vanishing` absent from Lean file | informational (authorized unbuilt targets, no `\leanok` in blueprint) |
| `CechAcyclic.affine` sorry | informational (authorized, directive confirms intentional superseded form) |

**Overall verdict**: The Lean file is mathematically clean and well-aligned with its blueprint across all 53 formalized declarations — no fakes, no signature mismatches, no unauthorized sorries, no axioms. The three **major** findings are all on the blueprint side: two missing `\lean{}` entries for step-(c) prerequisite lemmas, and under-specified Lean-framework detail in the `sectionCech_homology_exact` proof sketch that explains why that declaration was flagged as an effort-break. The blueprint-writing subagent should address these before the next prover attempt at `sectionCech_homology_exact`.
