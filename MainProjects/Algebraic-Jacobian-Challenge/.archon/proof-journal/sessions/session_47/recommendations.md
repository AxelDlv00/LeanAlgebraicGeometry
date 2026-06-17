# Recommendations for the next plan-agent iteration (iter-048)

## Foundation closed iter-047

**Foundational parameterised Čech infrastructure is now in place.** Iter-047 landed four new declarations in `Cohomology/StructureSheafModuleK.lean` (single combined Edit, zero corrective): `cechCochain` and `cechCohomology` parameterised over any sheaf `F : Sheaf J (ModuleCat k)`, plus `rfl`-bridges `cechCochain_OC_eq` and `cechCohomology_OC_eq` to iter-012's structure-sheaf specialisations. Sorry trajectory `9 → 9`. LOC `811 → 865 (+54)`. Kernel-only axioms `[propext, Classical.choice, Quot.sound]` on all four declarations.

**Substantive depth now visible**: the `IsAffineHModuleVanishing k C (toModuleKSheaf C)` producer was originally scoped as a single iter-047 deliverable, then re-scoped as iter-047 (foundational Čech infra) + iter-048 (comparison map) + iter-049 (`IsAcyclicCover` class) + iter-050+ (affine-cover producer instances) + iter-051 (final `IsAffineHModuleVanishing` producer). Phase A iterations-remaining estimate revised UP from ~3 to ~6 (per STRATEGY.md revision).

## Highest-priority track for iter-048

### Track 2A.1 (recommended primary, iter-048 prover lane): comparison map `cechCohomology → HModule'`

**Step 4.6.1 of the genus-`Module.Finite` ladder.** Construct the linear map
```
Scheme.cechCohomologyComparisonMap :
  Scheme.cechCohomology k C F 𝒰 n →ₗ[k] Scheme.HModule' k F n (⨆ᵢ 𝒰 i)
```
This is a project-local construction — Mathlib's `Cech.complex` API does not include the comparison-to-sheaf-cohomology map at the level of generality we need (`HModule'` is the project's sheafified-Ext flavour, not Mathlib's standard derived functor cohomology).

**Plan-agent probe mandate for iter-048**:
1. Search Mathlib for `Cech.toCohomology` / `cechCohomologyComparisonMap` / similar — confirm not present at the iter-047 level of generality.
2. Construct the map by either: (i) precomposition with the augmentation `F → Cˇ(𝒰, F)` cochain, then taking cohomology; or (ii) a direct natural-transformation construction via the Mathlib `cechComplexFunctor` augmentation API.
3. Probe the chosen body via `lean_run_code` end-to-end before proposing.

**Plausible iter-048 outcomes**:
- **Single-iteration close (~30–60 LOC)** if the augmentation-and-take-homology approach drops in cleanly.
- **2-iteration close (~80–150 LOC)** if a project-local naturality lemma is needed.
- **3+-iteration close** if direct construction with manual derived-functor unfolding is required (least likely).

### Track 2A.2 (queued, iter-049): `class IsAcyclicCover`

Once the comparison map exists, introduce the class
```
class IsAcyclicCover (k : Type u) [Field k] (C : Over (Spec (.of k)))
    (F : Sheaf J (ModuleCat.{u} k)) {ι : Type u}
    (𝒰 : ι → Opens C.left.toTopCat) : Prop where
  comparison_isIso : ∀ n, IsIso (Scheme.cechCohomologyComparisonMap k C F 𝒰 n)
```
plus an immediate consumer chaining iter-040's H${}^{>0}$ vanishing through `IsAcyclicCover` to derive `Scheme.HModule' k F n (⨆ᵢ 𝒰 i)` vanishing whenever the Čech complex vanishes in positive degree. ~30–50 LOC.

### Track 2A.3 (queued, iter-050+): `IsAcyclicCover` producers for affine basic-open covers

Substantive multi-iteration: produce `IsAcyclicCover` instances for basic-open covers of affine schemes by way of Serre's classical computation (the alternating-sum complex of localisations is exact in positive degrees). Mathlib probe required for any pre-existing `Cech.cohomology_basic_open_cover_acyclic`-style theorem; if absent, project-local construction. Likely ~150+ LOC over 2–3 iterations.

### Track 2A.4 (queued, iter-051): the final `IsAffineHModuleVanishing` producer

Chain Track 2A.3 with iter-040's `IsAffineHModuleVanishing` consumer to close the H${}^{>0}$ side of the genus-`Module.Finite` ladder.

## Track 2B (alternative warm-up, iter-048 prover lane): finrank corollary of iter-046 producer

A `Module.finrank`-flavoured restatement of iter-046's `instIsHModuleHomFinite_toModuleKSheaf` giving an explicit identity `Module.finrank k (HModule k (toModuleKSheaf C) 0) = Module.finrank k Γ(C, 𝒪_C)`. Plausibly single-iteration ~30–50 LOC. **Track 2B remains a low-risk warm-up** option if iter-048 plan-agent prefers a smaller-surface deliverable while waiting on iter-049 / iter-050 prep work.

## Track 2C (alternative, iter-048 prover lane): sharper Mayer–Vietoris LES consumer

Combine iter-029 LES + iter-035 → iter-039 transports + iter-040 + iter-041 + iter-042 + iter-043 consumers + iter-044 Stein input + iter-045 LinearEquiv + iter-046 producer instance into a four-term LES on `HModule k F (n+1)` for the curve case. Plausibly single-iteration ~30–50 LOC.

## Track 2D (off-Archon side track): Mathlib upstream PRs

The five new `CategoryTheory.*` declarations from iter-046 (`Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv`) remain pure Mathlib gap-fills. Recommendation unchanged from iter-047 recommendations: open Mathlib upstream PRs to merge into `Mathlib/CategoryTheory/Adjunction/Additive.lean` or sibling `Linear.lean`. Once merged, the project-local block can be deleted.

## Continuing-discipline reinforcements (iter-040 → iter-047)

- **`blueprint/lean_decls` clear-as-you-go discipline holds for the eighth iteration in a row** (iter-040 → iter-047). The iter-047 plan-agent appended 4 new entries (L105–L108), bringing the total to 110 entries (iter-046's 106 + 4 = 110). Continue this discipline.
- **Plan-agent pre-marking blueprint `\leanok` markers, with review-side validation** holds for the third iteration in a row (iter-045 pre-marked 4 markers, iter-046 pre-marked 12 markers, iter-047 pre-marked 8 markers). All 8 iter-047 pre-marks verified valid this pass via clean diagnostics + kernel-only axioms on all four declarations. Reduces review-agent surface area to validation only. Continue.
- **Verbatim probe-confirmed body landing** holds: 10 of 13 iterations (iter-035 → iter-047) zero-corrective-Edit, 1 with cosmetic corrective (iter-044), 1 with cosmetic corrective (iter-046). The pattern continues to deliver clean, atomic Edits.
- **`archon-protected.yaml` untouched** for the eighth iteration in a row. Continue.
- **Single combined Edit for multi-declaration packaging holds** *(iter-047 confirms scaling from iter-039/040/041 paired declarations through iter-046's 8-declaration two-block package)*: when probe coverage is exhaustive and the bodies use only transitively-imported Mathlib pieces, a single combined Edit lands cleanly.

## Targets blocked — do NOT assign in iter-048

- All 8 protected sorries (5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`) — gated on Phase C step 4 (FGA representability), `LineBundle` Mathlib refinement, and `noncomputable` user-decisions. **Plan-agent should NOT assign these.**
- `PicardFunctor.representable` — intentionally deferred. **Plan-agent should NOT assign.**
- All closed scaffold sites in `Cohomology/MayerVietoris.lean` and `Cohomology/StructureSheafModuleK.lean` (iter-006 → iter-047).

## Reusable proof patterns from iter-047 (for iter-048+ planning)

1. **Parameterise-and-bridge package** (4 declarations: parameterised def + parameterised def + `rfl`-bridge + `rfl`-bridge) for converting a hardcoded-instance gadget into a general parameterised gadget while preserving downstream consumer compatibility.
2. **`rfl` definitional bridge** when specialised body literally instantiates parameterised body at a fixed argument — no ceremony needed.
3. **Single combined Edit for parameterise-and-bridge** scales the iter-046 multi-block packaging pattern down to a single-block 4-declaration cohort.

## Summary

Iter-047 closed the **foundational parameterised Čech infrastructure**, the groundwork on which iter-048+ will build the substantive Čech-vs-derived comparison theorem and the eventual `IsAffineHModuleVanishing` producer. **Iter-048 should attack Track 2A.1 (comparison map)** as the next genuinely substantive step, with Track 2B (finrank corollary) as the low-risk warm-up alternative.
