# Lean ↔ Blueprint Check Report

## Slug
asv

## Iteration
052

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (Relevant blocks: `lem:affine_serre_vanishing` ~line 3208, `lem:affine_cech_vanishing_qcoh` ~line 6057,
  plus all supporting sub-lemmas for `affineCoverSystem`.)

---

## Per-declaration

### `\lean{AlgebraicGeometry.affine_faces_mem}` (chapter: `lem:affine_faces_mem`)
- **Lean target exists**: yes (line 42)
- **Signature matches**: yes — `{R : CommRingCat.{u}} {ι : Type u} (s : ι → R) {p : ℕ} (σ : Fin (p + 1) → ι) : (⨅ k, D(s(σ k))) ∈ range (D ∘ ·)` matches "every finite intersection of distinguished opens is distinguished"
- **Proof follows sketch**: yes — the proof directly exhibits the witness `∏ k, s (σ k)` using `basicOpen_sprod`, matching the blueprint's "product formula" sketch
- **notes**: none

---

### `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` (chapter: `lem:cover_datum_bridge`)
- **Lean target exists**: yes (line 58)
- **Signature matches**: yes — states `coverOpen (affineOpenCoverOfSpanRangeEqTop s hs).openCover i = D(s i)`, exactly what the chapter says
- **Proof follows sketch**: yes — unfolds `coverOpen`, applies `Spec.map_base`, uses `PrimeSpectrum.localization_away_comap_range`
- **notes**: Blueprint `\leanok` markers are present on both statement and proof blocks

---

### `\lean{AlgebraicGeometry.affine_injective_acyclic}` (chapter: `lem:affine_injective_acyclic`)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — injective Čech-acyclicity for a spanning family over the whole affine, `q > 0 → IsZero (cechCohomology _ _ q)`
- **Proof follows sketch**: yes — bridges via `coverOpen_affineOpenCoverOfSpan` and applies `injective_cech_acyclic` (the X.OpenCover form), exactly as the blueprint says
- **notes**: Blueprint notes that this covers only the whole-affine case; the `affineCoverSystem.injective_acyclic` field is discharged by the more general `injective_cech_acyclicFam` (consistent with Lean)

---

### `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` (chapter: `lem:toSheaf_preservesFiniteColimits`)
- **Lean target exists**: yes (line 119)
- **Signature matches**: yes — `PreservesFiniteColimits (SheafOfModules.toSheaf R)` with the correct hypotheses
- **Proof follows sketch**: partial — the blueprint outlines a 3-clause retract argument (step 1: composite preserves colimits; step 2: `toSheaf R` is a retract of the composite; step 3: retracts of colimit-preserving functors preserve colimits). The Lean proof instead works diagram-by-diagram: for each finite diagram `F` it uses `F ≅ (F ⋙ forget R) ⋙ sheafification`, applies `isColimitOfPreserves` twice, then `preservesColimit_of_iso_diagram`. Mathematical content is equivalent but the structure diverges from the blueprint's abstract retract sketch.
- **notes**: minor divergence; no red flag; the same mathematical inputs are used

---

### `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}` (chapter: `lem:to_sheaf_preserves_epi`)
- **Lean target exists**: yes (line 151)
- **Signature matches**: yes — `(SheafOfModules.toSheaf R).PreservesEpimorphisms`
- **Proof follows sketch**: yes — one-line: gets `PreservesColimitsOfShape WalkingSpan` from `toSheaf_preservesFiniteColimits`, then applies `preservesEpimorphisms_of_preservesColimitsOfShape`, exactly the blueprint's one-sentence proof
- **notes**: none

---

### `\lean{AlgebraicGeometry.standard_cover_cofinal}` (chapter: `lem:standard_cover_cofinal`)
- **Lean target exists**: yes (line 167)
- **Signature matches**: yes — given `D(f) ≤ ⨆ a, W a`, produces `n`, `g : Fin n → R`, `φ : Fin n → α` with `D(f) = ⨆ i, D(gᵢ)` and `D(gᵢ) ≤ W(φ i)`, exactly the blueprint's statement
- **Proof follows sketch**: yes — uses `PrimeSpectrum.isCompact_basicOpen` and `hK.elim_finite_subcover`, matching the blueprint's "quasi-compactness → finite subcover" sketch
- **notes**: none

---

### `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` (chapter: `lem:affine_surj_of_vanishing`)
- **Lean target exists**: yes (line 233)
- **Signature matches**: yes — short exact sequence `S`, vanishing hypothesis for standard covers, element `f : R`; conclusion `Function.Surjective (section map at D(f))`; matches the blueprint's "surjectivity of S₂(D f) → S₃(D f)" statement
- **Proof follows sketch**: yes — three steps match the blueprint exactly: (1) local surjectivity via `toSheaf_preservesEpimorphisms` + sheaf epi criterion, (2) refine to standard cover via `standard_cover_cofinal`, (3) glue via `ses_cech_h1`
- **notes**: proof is detailed and faithful to the blueprint's 3-step outline

---

### `\lean{AlgebraicGeometry.affineCoverSystem}` (chapter: `def:affine_cover_system`)
- **Lean target exists**: yes (line 373)
- **Signature matches**: yes — `noncomputable def affineCoverSystem (R : CommRingCat.{u}) : BasisCovSystem (Spec R)` with `B = range D(·)`, `Cov = standard finite covers`
- **Proof follows sketch**: yes — three fields discharged as blueprint says: `faces_mem` ← `affine_faces_mem`, `surj_of_vanishing` ← `affine_surj_of_vanishing`, `injective_acyclic` ← `injective_cech_acyclicFam` (family-form, consistent with blueprint's note that the family-form is used, not `affine_injective_acyclic`)
- **notes**: blueprint correctly identifies that `injective_acyclic` is discharged by the family-form lemma, not `affine_injective_acyclic`

---

### `\lean{AlgebraicGeometry.affine_cover_span_localizationAway}` (chapter: `lem:affine_cover_span_localizationAway`)
- **Lean target exists**: yes (line 402)
- **Signature matches**: yes — `D(f) = ⨆ i, D(g i) → Ideal.span (range (algebraMap R Rf ∘ g)) = ⊤`, matches the blueprint statement
- **Proof follows sketch**: yes — uses `PrimeSpectrum.iSup_basicOpen_eq_top_iff` and the comap/unit argument described in the blueprint proof
- **notes**: none

---

### `\lean{AlgebraicGeometry.cechCohomology_isZero_of_iso}` (chapter: `lem:cechCohomology_isZero_of_iso`)
- **Lean target exists**: yes (line 422)
- **Signature matches**: yes — `F ≅ G → IsZero (Ȟᵖ(𝒰, F)) → IsZero (Ȟᵖ(𝒰, G))`
- **Proof follows sketch**: yes — uses `sectionCechComplexFunctor.mapIso e` and the homology functor's `mapIso`, one line matching the blueprint's "transport along an isomorphism of cochain complexes" sketch
- **notes**: none

---

### `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh_of_tildeVanishing}` (chapter: `lem:affine_cech_vanishing_qcoh` multi-pin)
- **Lean target exists**: yes (line 437)
- **Signature matches**: yes — takes `F : (Spec R).Modules [IsQuasicoherent]` and an explicit `htilde` hypothesis (positive-degree tilde Čech-vanishing over standard covers of distinguished opens), returns `HasVanishingHigherCech (affineCoverSystem R) F`
- **Proof follows sketch**: yes — extracts the cover datum, transports via `cechCohomology_isZero_of_iso` along `qcoh_iso_tilde_sections`, applies `htilde`; exactly the blueprint's "reduction to tilde case" step
- **notes**: none

---

### `\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh}` (chapter: `lem:affine_cech_vanishing_qcoh` multi-pin)
- **Lean target exists**: yes (line 510) — **unconditional form, now proved in iter-052**
- **Signature matches**: yes — `(F : (Spec R).Modules) [F.IsQuasicoherent] : HasVanishingHigherCech (affineCoverSystem R) F`, no sorry, no axioms
- **Proof follows sketch**: yes — one-liner `affine_cech_vanishing_qcoh_of_tildeVanishing F (affine_tildeVanishing F)`, discharging `htilde` with the now-proved private helper; this is the blueprint's "combining steps 1 and 2" conclusion
- **notes**: **The blueprint `% NOTE` at line 6061–6066 says "The unconditional `affine_cech_vanishing_qcoh` is obtained once that residual is a closed Lean declaration" — this note is now stale; the declaration is proved.** See Blueprint Adequacy section.

---

### `\lean{AlgebraicGeometry.affine_serre_vanishing_of_tildeVanishing}` (chapter: `lem:affine_serre_vanishing` multi-pin)
- **Lean target exists**: yes (line 466)
- **Signature matches**: yes — `[EnoughInjectives (Spec R).Modules] (F : (Spec R).Modules) [IsQuasicoherent] (htilde : ...) (p : ℕ) (hp : 0 < p) (e : Ext (jShriekOU ⊤) F p) : e = 0`; explicit `htilde` and `EnoughInjectives` hypotheses both mentioned in the blueprint (line 3239-3245)
- **Proof follows sketch**: yes — applies `cech_eq_cohomology_of_basis` at `affineCoverSystem R` with `affine_cech_vanishing_qcoh_of_tildeVanishing`, taking `⊤ = D(1)`, exactly the blueprint's "instantiate basis-comparison at the whole affine" argument
- **notes**: none

---

### `\lean{AlgebraicGeometry.affine_serre_vanishing}` (chapter: `lem:affine_serre_vanishing` multi-pin)
- **Lean target exists**: yes (line 521) — **unconditional form, now proved in iter-052**
- **Signature matches**: yes — `[EnoughInjectives] (F : (Spec R).Modules) [IsQuasicoherent] (p : ℕ) (hp : 0 < p) (e : Ext (jShriekOU ⊤) F p) : e = 0`; no sorry, no axioms
- **Proof follows sketch**: yes — one-liner `affine_serre_vanishing_of_tildeVanishing F (affine_tildeVanishing F) p hp e`, fulfilling the blueprint's final "instantiate the basis-comparison criterion and obtain vanishing" conclusion
- **notes**: **The blueprint `% NOTE` at lines 3215–3220 says "The named target `affine_serre_vanishing` is NOT yet a Lean declaration (the `\lean{}` pin is aspirational)" — this is now stale.** See Blueprint Adequacy section.

---

## Red flags

*(none)*

No `:= sorry`, `:= True`, `:= rfl` on non-trivial claims, or `axiom` declarations found.
No excuse-comments ("TODO replace with real def", "placeholder", "wrong but works") found.
The `% NOTE` annotations flagged below are stale *blueprint* comments, not Lean excuse-comments.

---

## Unreferenced declarations (informational)

### `private theorem affine_tildeVanishing` (line 491)

This private theorem is not pinned by any blueprint `\lean{...}` block. It serves as a bridging wrapper: it reshapes `sectionCech_homology_exact_of_localizationAway` (which is `lem:affine_cech_vanishing_tilde_subcover`'s Lean target, living in `CechAcyclic.lean`) from a `Fin n`-indexed statement into the `ULift (Fin n)`-indexed form that both `affine_cech_vanishing_qcoh_of_tildeVanishing` and `affine_serre_vanishing_of_tildeVanishing` consume via their `htilde` hypothesis.

The blueprint's `% NOTE` at `lem:affine_cech_vanishing_tilde_subcover` (line 6264) mentions that `sectionCech_homology_exact_of_localizationAway` is "consumed by the reduced forms", but does not document the `ULift`-reshaping step that makes this consumption work. The step is non-trivial (the index-type universe bump `ULift.{u} (Fin n)` is required to keep everything in `Type u`), and a prover unaware of this need would face a type unification error at the final assembly.

Since `affine_tildeVanishing` is `private`, no blueprint block is strictly required. However, the gap is worth recording because the `_of_tildeVanishing` reduction lemmas publicly carry the `htilde` hypothesis in the `ULift (Fin n)` form — a future reader of the blueprint's proof sketch for `lem:affine_cech_vanishing_qcoh` would not see why the index type must be `ULift (Fin n)`.

---

## Blueprint adequacy for this file

- **Coverage**: 14/15 Lean declarations have a corresponding `\lean{...}` block. The one unreferenced declaration is the private helper `affine_tildeVanishing`, which is acceptable for a private bridging helper (though the indexing step it handles is undocumented; see above).

- **Proof-sketch depth**: **adequate overall, one minor divergence**. All public-declaration proof sketches provided enough detail to guide the formalization. The one non-trivial divergence is `toSheaf_preservesFiniteColimits`: the blueprint outlines an abstract 3-clause retract argument while the Lean proof implements a concrete per-diagram argument using the same mathematical ingredients. The Lean proof is correct; the blueprint sketch is mathematically equivalent but the translation required non-obvious API choices not documented in the blueprint. This is a **minor** adequacy gap; the blueprint's Step 2 ("descent via the counit isomorphism") maps to Lean's `preservesColimit_of_iso_diagram` only if one knows the right API exists.

- **Hint precision**: **precise**. All `\lean{...}` pins use fully-qualified names. Multi-pin entries (e.g. `\lean{affine_serre_vanishing, affine_serre_vanishing_of_tildeVanishing}`) correctly capture both the unconditional and the reduced form. The `lem:affine_cech_vanishing_tilde_subcover` entry pins `sectionCech_homology_exact_of_localizationAway` (in `CechAcyclic.lean`), which is the correct target.

- **Generality**: **matches need**.

- **Recommended chapter-side actions**:
  1. **(major — review-agent action)** Remove or update the stale `% NOTE` in `lem:affine_serre_vanishing` (lines 3215–3220) that says "affine_serre_vanishing is NOT yet a Lean declaration". Replace with a note confirming it was proved unconditionally in iter-052.
  2. **(major — review-agent action)** Remove or update the stale `% NOTE` in `lem:affine_cech_vanishing_qcoh` (lines 6061–6066) that says "The unconditional `affine_cech_vanishing_qcoh` is obtained once that residual is a closed Lean declaration". Replace with confirmation it is now proved.
  3. **(minor — optional)** Add a sentence to the proof sketch of `lem:affine_cech_vanishing_qcoh` (or `lem:affine_serre_vanishing`) noting that the index type of the `htilde` hypothesis is `ULift (Fin n)`, and that the bridge from `sectionCech_homology_exact_of_localizationAway` (which uses plain `ι`) to this shape is handled by a private wrapper. This prevents future formalizers from being surprised by the universe bump.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
  1. Stale `% NOTE` at `lem:affine_serre_vanishing` (blueprint line 3215) falsely states `affine_serre_vanishing` is "NOT yet a Lean declaration"; declaration is proved unconditionally in iter-052.
  2. Stale `% NOTE` at `lem:affine_cech_vanishing_qcoh` (blueprint line 6061) falsely states the unconditional form is not yet proved; declaration is closed in iter-052.
- **minor**: 2
  1. `affine_tildeVanishing` private helper (the `ULift (Fin n)` index-reshaping step) has no blueprint documentation; the gap could surprise future formalizers of the same pattern.
  2. `toSheaf_preservesFiniteColimits` proof strategy diverges from the blueprint's abstract retract sketch (different but equivalent argument; no correctness issue).

**Overall verdict**: Lean file is faithful and complete — all 14 public declarations exist with correct signatures and substantive proofs; zero red flags. Blueprint is structurally adequate but carries two stale `% NOTE` annotations that now misrepresent the state of `affine_serre_vanishing` and `affine_cech_vanishing_qcoh`, and has a minor gap for the private `affine_tildeVanishing` index-reshaping step.
