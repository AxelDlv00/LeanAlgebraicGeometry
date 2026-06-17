# Lean Audit Report

## Slug
iter057

## Iteration
057

## Scope
- files audited: 3 (per directive; restricted to prover-touched files)
- files skipped: 0 (within directive scope)

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (thin alias)
- **excuse-comments**: none
- **notes**:
  - **Line 110 (sorry — `CechAcyclic.affine`)**: Honest hole. The goal is `IsZero ((CechComplex f (affineOpenCoverOfSpanRangeEqTop ...).openCover F).homology p)`. The surrounding block of `/-` strategy comments explains exactly what remains (the L1 categorical→module bridge). The sorry is not papered; the type is the actual target.
  - **`maxHeartbeats`/`synthInstance.maxHeartbeats` raises**: Four raises, all with honest explanatory comments attached.
    - Lines 1242–1245 (`dDiff_exact_of_localizationAway`): "change-of-ring ladder repeatedly synthesises `AddMonoidHomClass` over `dCoeff`-abbreviated `LocalizedModule` carriers". The proof is axiom-clean; the budget is for instance search in a heavy ladder proof.
    - Lines 1364–1367 (`dDiff_exact_of_affineCover`): same reason. Proof axiom-clean.
    - Line 1726 (`phiL_naturality`): "the `IsLocalizedModule.ext` reduction over the heavy `modulesSpecToSheaf` section types is defeq-intensive". Proof axiom-clean.
    - Line 1848 (`phi_naturality`): "feeds `phiL_naturality` through the same defeq-heavy section types via `restr_bridge`". Proof axiom-clean.
    - None of these raises sit on a broken proof. All are genuine.
  - **`sectionCech_homology_exact_of_affineOpen` (lines 2162–2212) — `letI`/`haveI` instance constructions**: The proof constructs `Algebra Γ(V) Γ(D(a))` as `.toAlgebra` of the restriction ring map, and `IsScalarTower R Γ(V) Γ(D(a))` via `IsScalarTower.of_algebraMap_eq (fun _ => rfl)`. This is sound: the scalar tower is definitionally `rfl` because `algebraMap R Γ(D(a)) = algebraMap Γ(V) Γ(D(a)) ∘ algebraMap R Γ(V)` by construction. The concluding `IsLocalization.isLocalization_of_algEquiv (Submonoid.powers a) (eAlg.restrictScalars R)` is also sound: it requires `[IsLocalization (Submonoid.powers a) Γ(D(a))]` (as `R`-algebra), which should be synthesised from the canonical structure-sheaf instance `IsLocalization.Away a Γ(D(a))` for a basic open of `Spec R`; `eAlg` then transports this to the target `Localization (Submonoid.powers ā)`.
  - **`dDiff_exact_of_affineCover` (lines 1382–1480)**: Non-vacuous. The hypothesis `hloc` genuinely requires `IsLocalization` at every Čech multi-index; it is not trivially satisfiable. The proof uses `isLocalizedModule_baseChange_away` (proved, line 977) and `Function.Exact.of_ladder_addEquiv_of_exact`. Mathematically correct.
  - **`isLocalizedModule_baseChange_away` (line 977)**: Non-vacuous. The heavy typeclass list (`IsScalarTower R S Aloc`, `IsLocalization (powers a) Aloc`, etc.) all appear genuinely necessary; the proof uses `IsBaseChange.comp` + `isLocalizedModule_iff_isBaseChange`. Sound.
  - **`basicOpen_algMap_section` (line 2140)**: Non-vacuous; proved via `basicOpen_eq_of_affine` + `basicOpen_res`. Clean.
  - **Minor — thin alias**: `sectionCech_affine_vanishing` (lines 2042–2047) is definitionally identical to `sectionCech_homology_exact` — its body is `sectionCech_homology_exact M s hs p hp`. This is pure naming redundancy. No mathematical issue, just unnecessary noise.

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none
- **suspect definitions**: 2 flagged (false statements)
- **dead-end proofs**: 2 flagged (sorry on provably false statements)
- **bad practices**: 1 flagged (fragile `Iso.refl _`)
- **excuse-comments**: 1 critical block flagged (lines 333–366)
- **notes**:
  - **Lines 333–366 (excuse-comment block)**: The in-file section `⚠ PROVER FINDING (iter-056): Stubs 5 and 6 are MIS-SPECIFIED (provably false as written)` explicitly documents that `cechSection_complex_iso` (Stub 5) and `cechSection_contractible` (Stub 6) carry **provably false** type signatures, and that "The original Stub 5/6 `sorry`s below are left untouched (they cannot be closed as stated)." This is an excuse-comment of the most severe kind — an in-file admission that two named, load-bearing declarations are wrong and cannot be proved.
  - **Line 424 (`cechSection_complex_iso := sorry`)**: PROVABLY FALSE statement. The type asserts `D ≅ D'` where `D` is the evaluated *augmented* Čech complex (degree-0 object `Γ(V,F)`) and `D'` is the un-augmented section Čech complex (degree-0 object `∏ᵢ Fp(Uᵢ ⊓ V)`). These are provably non-isomorphic: `D.X 0 = Γ(V,F)` while `D'.X 0 = ∏ᵢ Fp(Uᵢ ⊓ V)`. The sorry cannot be filled as stated. **(MUST-FIX)**
  - **Line 481 (`cechSection_contractible := sorry`)**: PROVABLY FALSE statement. The type asserts `Homotopy (𝟙 D') 0` (contractibility of `D'`). The file's own counterexample (one-member cover with `i_fix`, giving `H⁰(D') = Fp(V) ≠ 0`) proves this is false: a contractible complex has `H⁰ = 0`. The sorry cannot be filled as stated. **(MUST-FIX)**
  - **Lines 189 (`cechBackbone_left_sigma := sorry`) — Stub 1**: Honest hole. The type is non-vacuous: identifies `(coverCechNerveOver 𝒰).obj (op [p])` with `∐ fun σ => Over.mk (ι_{U_σ})`. The planner comment explains the route (distributivity of coproducts over fibre products). Correctly classified as MEDIUM difficulty.
  - **Lines 239 (`pushPull_sigma_iso := sorry`) — Stub 2**: Honest hole. Non-vacuous type: `pushPullObj F Y_p ≅ ∏ᶜ_σ pushPullObj F (Over.mk j_σ)`. Classified HARD (genuine new sheaf infra). The `set_option synthInstance.maxHeartbeats 800000` at line 233 applies to a sorry-body — probably required for heavy type elaboration of the modules-over-scheme type. Not suspicious.
  - **Lines 330 (`pushPull_eval_prod_iso := sorry`) — Stub 4**: Honest hole. Type is non-vacuous; declared LOW difficulty (assembly of Stubs 2+3).
  - **`pushPull_leg_sections` (lines 272–292) — Stub 3**: PROVED axiom-clean. Three-step identification via `restrictFunctorIsoPullback` + `eqToIso` + `image_preimage_eq_opensRange_inf`. Non-vacuous.
  - **`widePullback_openImm_inter` (lines 80–107)**: Non-vacuous iso; proof supplies full `hom`/`inv`/`hom_inv_id`/`inv_hom_id`. The `hom_inv_id` uses `cancel_mono (g j)` on the open-immersion leg, and `inv_hom_id` uses `cancel_mono (⨅ k, ...).ι`. Both are correct: open immersions are monomorphisms. Mathematically sound.
  - **`coverArrowOverIsColimit` (lines 119–135)**: Proved without sorry via `mkCofanColimit`; universality and uniqueness proofs look correct. Non-vacuous.
  - **`cechBackbone_obj_widePullback` (lines 151–155) := `Iso.refl _`**: Claims the `Over X` object `(coverCechNerveOver 𝒰).obj (op [p])` is *definitionally equal* to `Over.mk (WidePullback.base ...)`. The comment says all identifications are definitional. If Lean accepts `Iso.refl _` here it is correct by elaboration; but it is potentially fragile if `@[reducible]` annotations on the relevant defs change. Flag as a minor maintainability concern.

---

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (duplicated declaration)
- **excuse-comments**: none
- **notes**:
  - **Lines 41–50 (`isZero_of_faithful_preservesZeroMorphisms`)**: The comment at line 41 explicitly states this is "A copy of the same lemma in `CechAugmentedResolution.lean`; reproduced here because that sibling file is not in this file's import chain." This is a parallel-API duplication: the same declaration appears verbatim in two files. Per audit criteria this is a **major** finding (parallel API of existing project code — the real fix is extraction to a shared helper file or adding the import).
  - **Line 373 (sorry — `higherDirectImage_openImmersion_acyclic`)**: Honest hole. The residual is the "Bridge 1/2 remainder + Bridge 2 vanishing" — the q-th right derived of `Hom(jShriekOU (j⁻¹W), -)` vanishing on quasi-coherent `H`. The goal is correctly typed; the surrounding scaffolding (`higherDirectImage_iso_sheafify_presheafHomology`, `isZero_presheafToSheaf_of_sections_locally_zero` chain) is axiom-clean. Not papered.
  - **Line 439 (sorry — `higherDirectImage_openImmersion_comp`)**: Honest hole. The residual is the `f_*`-acyclic resolution comparison (`rightDerivedIsoOfAcyclicResolution`). Goal correctly typed, outline in comments. Not papered.
  - **`pushforwardEquivOfIso` (lines 204–212)**: Non-vacuous. The equivalence is built from `pushforward φ.hom` / `pushforward φ.inv` with unit/counit assembled from `pushforwardId`/`pushforwardComp`/`pushforwardCongr`. The coherences are:
    - Unit: `(pushforwardId X).symm ≪≫ pushforwardCongr (φ.hom_inv_id).symm ≪≫ (pushforwardComp φ.hom φ.inv).symm` — correctly witnesses `𝟙 ≅ pushforward φ.hom ⋙ pushforward φ.inv`.
    - Counit: `pushforwardComp φ.inv φ.hom ≪≫ pushforwardCongr φ.inv_hom_id ≪≫ pushforwardId Y` — correctly witnesses `pushforward φ.inv ⋙ pushforward φ.hom ≅ 𝟙`. Sound.
  - **`pushforwardExtAddEquiv` (lines 223–231)**: Non-vacuous. Uses `AddEquiv.ofBijective` with `mapExt_bijective_of_preservesInjectiveObjects` — this requires the equivalence functor to preserve injective objects. An equivalence functor is fully faithful and exact, so it does preserve injectives (Mathlib should have `Equivalence.preservesInjectiveObjects`). With `[EnoughInjectives X.Modules]` explicit and `pushforwardEquivOfIso` an equivalence, this is sound.
  - **`modulesIsoSpecExtTransport` (lines 241–247)**: Thin but non-vacuous wrapper of `pushforwardExtAddEquiv`. Clean.
  - **`pushforwardSectionsFunctor_additive` (lines 295–315)**: The 5-fold composite defeats infer_instance; the explicit `@Functor.instAdditiveComp ... i2` chain at line 314 (passing the tail instance explicitly) is the correct fix for this known instance-search failure mode (see memory `openimm-acyclic-reduced.md`). Sound.
  - **`isZero_presheafToSheaf_of_sections_locally_zero` (lines 71–101)**: Non-vacuous. The proof correctly distinguishes sectionwise-locally-zero (this lemma) from objectwise-zero (the existing `isZero_presheafToSheaf_of_locally_isZero`). The local-injectivity witness via `x - y` is standard. Sound.

---

## Must-fix-this-iter

- `CechSectionIdentification.lean:424` — `cechSection_complex_iso := sorry` where the **type signature is provably false** (`D ≅ D'` fails: `D.X 0 = Γ(V,F)` while `D'.X 0 = ∏ᵢ Fp(Uᵢ ⊓ V)`). The in-file `⚠ PROVER FINDING` block explicitly documents this. Why must-fix: the sorry cannot be filled and the declaration is consumed by `CechAugmentedResolution.lean`; keeping it blocks the downstream correctness argument.

- `CechSectionIdentification.lean:481` — `cechSection_contractible := sorry` where the **type signature is provably false** (`Homotopy (𝟙 D') 0` fails: `H⁰(D') = Fp(V) ≠ 0` by the in-file one-cover counterexample). Why must-fix: same reason — the sorry cannot be filled, and it is the contractibility witness consumed downstream.

---

## Major

- `OpenImmersionPushforward.lean:41–50` — `isZero_of_faithful_preservesZeroMorphisms` is duplicated verbatim from `CechAugmentedResolution.lean`. The comment acknowledges the duplication ("reproduced here because that sibling file is not in this file's import chain"). Parallel API across project files: bridges or imports that depend on both versions will silently diverge if one copy is updated. Should be extracted to a shared helper or the import chain fixed.

---

## Minor

- `CechAcyclic.lean:2042–2047` — `sectionCech_affine_vanishing` is a trivial alias (`= sectionCech_homology_exact M s hs p hp`). Naming redundancy; no mathematical issue.

- `CechSectionIdentification.lean:153–155` — `cechBackbone_obj_widePullback := Iso.refl _` for a non-trivial definitional claim. Correct if Lean accepts it, but fragile under changes to `@[reducible]` or `@[simp]` on `coverCechNerveOver` / `augmentedCechNerve`.

- `CechSectionIdentification.lean:233` — `set_option synthInstance.maxHeartbeats 800000` applied to `pushPull_sigma_iso`, whose body is `sorry`. The raise is likely needed for type elaboration of the heavy `pushPullObj`/`∏ᶜ` type. Not suspicious, but unusual.

---

## Excuse-comments (called out separately)

- `CechSectionIdentification.lean:333–366`: The block beginning `⚠ PROVER FINDING (iter-056): Stubs 5 and 6 are MIS-SPECIFIED (provably false as written)` — attached to the declarations `cechSection_complex_iso` and `cechSection_contractible`, both of which are load-bearing (consumed by `CechAugmentedResolution.lean`). The block explicitly says the sorries "cannot be closed as stated" and are "left untouched." Severity: **critical** (two wrong load-bearing declarations with documented-false types).

---

## Severity summary

- **must-fix-this-iter**: 2 — block downstream correctness in `CechAugmentedResolution.lean` until types are re-specified.
- **major**: 1
- **minor**: 3
- **excuse-comments**: 1 block covering 2 declarations (also counted under must-fix-this-iter; critical because load-bearing).

Overall verdict: `CechAcyclic.lean` and `OpenImmersionPushforward.lean` are structurally honest (one sorry each on correctly-typed holes, all other proofs axiom-clean); `CechSectionIdentification.lean` carries two must-fix declarations whose type signatures are provably false and are explicitly documented as such in-file — these block the Sub-brick A / `CechAugmentedResolution` downstream chain until re-specified per the iter-056 corrected decomposition.
