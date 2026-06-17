# Lean Audit Report

## Slug
iter018

## Iteration
018

## Scope
- files audited: 9
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import file, 7 lines. Sound. One notable omission: `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean` is absent from the import list (see Major §1).

---

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single declaration `higherDirectImage := ((pushforward f).rightDerived i).obj F`. Correct definition of the right-derived pushforward. Axiom-clean.

---

### AlgebraicJacobian/Cohomology/PresheafCech.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 17–23 (module docstring): lists 5 declarations that it claims "this file is the home of." In fact only `sectionCechComplex` (and its cosimplicial backbone) reside here. `cechFreePresheafComplex` and `cechFreeComplex_quasiIso` live in `FreePresheafComplex.lean`; `cechComplex_hom_identification` and `injective_cech_acyclic` are in `CechBridge.lean`. Four out of five named declarations are in the wrong file according to the docstring. See **Major §2**.
  - Lines 33–195: large planner strategy block. Accurately describes the P3b plan; not stale per se.
  - All implemented declarations (`injective_toPresheafOfModules`, `freeYonedaHomEquiv`, `freeYonedaHomAddEquiv`, `sectionCechCosimplicial`, `sectionCechComplex`) are axiom-clean.
  - `freeYonedaHomAddEquiv.map_add'` (line 281–285): proof is `PresheafOfModules.add_app` + `ModuleCat.hom_add` + `rfl`. Correct.
  - `sectionCechCosimplicial.map_comp` (lines 315–320): `congr 1` as final step; closes by reflexivity of the morphism-of-presheaves equation. Sound.

---

### AlgebraicJacobian/Cohomology/AcyclicResolution.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 924–964: status block titled "Status (iter-006)" claims "TARGET 3 (the acyclic-resolution staircase) remains" and then lists `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` as "REMAINING." But `rightDerivedIsoOfAcyclicResolution` is fully proved at lines 893–922. The comment is stale and contradicts the code directly above it. See **Major §3**.
  - All declarations are axiom-clean. The chain `quasiIso_τ₂` → horseshoe family → `rightDerivedShiftIsoOfAcyclic` → `rightDerivedOneIsoCokerOfAcyclic` → cosyzygy infrastructure → `rightDerivedIsoOfAcyclicResolution` is complete.
  - `Functor.IsRightAcyclic.ofInjective`: correct use of `Functor.isZero_rightDerived_obj_injective_succ`.
  - `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (lines 224–241): the `δIso` construction correctly requires vanishing of `H^{k+1}(G(I_J))` and `H^{k+2}(G(I_J))`, supplied by `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`. Sound.
  - The `stairGen` induction inside `rightDerivedIsoOfAcyclicResolution` is well-formed.

---

### AlgebraicJacobian/Cohomology/CechAcyclic.lean *(focus)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 109**: `sorry` in `CechAcyclic.affine`. Known intentional (per directive). Reported but not treated as new.
  - **Lines 131–133** (minor): comment says private `CombinatorialCech` declarations "exist only to close `CechAcyclic.affine` in this file." Since `CechAcyclic.affine` is currently `sorry`, the comment is aspirational, not factual. See **Minor §1**.
  - **New content — AwayComparison namespace (lines 477–590):** All sound.
    - `Inverts` (line 486): correctly defined as `IsUnit (algebraMap R (Module.End R Mb) a)` — invertibility of scalar action.
    - `Inverts.of_dvd` (lines 492–502): proof via `IsLocalizedModule.map_units` + `hcomm.isUnit_mul_iff`. Correct.
    - `Inverts.isUnit_powers` (lines 513–519): `obtain ⟨n, hn⟩ := x.2; rw [← hn, map_pow]; exact ha.pow n`. Sound.
    - `comparison` (line 525): wraps `IsLocalizedModule.lift`. Correct.
    - `comparison_comp` (lines 567–577): proved by uniqueness (`comparison_unique`). Correct.
  - **New content — CechLocalized namespace (lines 592–780):** All sound.
    - `sprod` (line 605): product of `s` values over multi-index.
    - `cechCoeff` (line 634): correctly `LocalizedModule (Submonoid.powers (s r * sprod s σ)) M`.
    - `cechCoface` / `cechPrepend` (lines 639–665): correctly feed `Inverts.of_dvd` and `Inverts.mul` to `AwayComparison.comparison`.
    - `cechCoeff_transport_eq_comparison` (line 672): bridges dependent-type transport to comparison map via `comparison_self` + `rfl`. Sound.
    - `cech_hu` / `cech_hsh` / `cech_hcomm` (lines 686–759): each concludes via `comparison_comp_apply` chain. All three are sound.
    - `cechLocalized_exact` (lines 770–778): correct assembly of `depDiff_exact` with the concrete coface/prepend maps.
  - **CombinatorialCech.Dependent namespace**: `depHomotopy_spec` proof (lines 340–356) correctly separates the `k = 0` term (reduced by `hu`) and the `k = j.succ` terms (reduced by `hsh`), matching the constant-coefficient structure. `depDiff_comp` uses the same involution as `combDifferential_comp`. Sound.

---

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean *(focus)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (`erw`-fragile proofs)
- **excuse-comments**: none
- **notes**:
  - No `sorry`. All declarations are axiom-clean.
  - `cechFreeSimplicial.map_id` (lines 158–168): uses `Subsingleton.elim` to unify the `homOfLE` with `eqToHom eo.symm`. Correct — morphisms between opens in a preorder are unique.
  - `cechFreeSimplicial.map_comp` (lines 169–182): ends with `congr 2`; both sides reduce to equal presheaf maps. Sound.
  - **Lines 235–238** (`freeYonedaAug_app_freeMk`): uses `erw [PresheafOfModules.freeObj_map, ModuleCat.freeDesc_apply]` to handle definitional-but-not-syntactic equalities. Functional but fragile under Mathlib refactors. See **Minor §2**.
  - **Lines 256–258** (`freeYoneda_map_comp_aug`): uses `erw [ModuleCat.comp_apply, Functor.comp_map, PresheafOfModules.free_map_app, ModuleCat.free_map_apply, freeYonedaAug_app_freeMk]`. Same fragility concern. See **Minor §2**.
  - `cechFree_d_comp_aug` (lines 295–311): the separate `main` sub-have is well-motivated (avoids type mismatch between `.X` and `.obj` forms). Proof is correct.
  - `coverStructurePresheaf` (line 274): defined as `Limits.image (cechFreeAug 𝒰)`. Correct — image presheaf of the augmentation map.
  - `cechFreeComplexAug` (line 332): chain map via `toSingle₀Equiv.symm`. Correct — the cochain-map condition is `cechFree_d_comp_factorThruImage`.

---

### AlgebraicJacobian/Cohomology/CechBridge.lean *(focus)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`erw`-fragile proof)
- **excuse-comments**: none
- **notes**:
  - No `sorry`. All implemented declarations are axiom-clean.
  - **Lines 196–207** (planning comment): says the `cechComplex_hom_identification` naturality proof "was held back this iteration" because FreePresheafComplex.lean was being edited concurrently. This is an honest planning note, not an excuse-comment. Minor concern for clarity. See **Minor §3**.
  - `homCechSectionIsoApp` (lines 137–146): uses `asIso (piComparison (preadditiveYoneda.obj F) ...)`. The `asIso` call requires an `IsIso` instance for `piComparison` on a preadditive Yoneda functor; since the file compiles, this instance exists. Structurally correct.
  - **Line 163** (`homCechSectionIsoApp_hom_π`): uses `erw [piComparison_comp_π_assoc]` — definitional equality workaround. Functional but fragile. See **Minor §2**.
  - `freeYonedaHomAddEquiv_naturality` (lines 179–193): term-mode proof via `PresheafOfModules.freeAdjunction.homEquiv_naturality_left` and `yonedaEquiv_naturality`. Sound.
  - The four planned declarations (`cechComplex_hom_identification`, `injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis`) are not implemented (no sorry stubs either). The file accurately describes them as "to be filled." Minor documentation concern (see **Minor §4**).

---

### AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean *(focus)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No `sorry`. All declarations are axiom-clean.
  - **CRITICAL BUILD ISSUE (orphaned file):** This file is not imported by `AlgebraicJacobian.lean`. All its declarations (`Functor.mapHomologyIso'`, `PresheafOfModules.homologyIsoSheafify`, `higherDirectImage_iso_sheafify_presheafHomology`, etc.) are invisible to downstream files in the build. See **Major §1**.
  - `Functor.mapHomologyIso'` (line 56): lifts `ShortComplex.mapHomologyIso F` to the complex level via `K.sc i`. Correct.
  - `PresheafOfModules.sheafificationAdditive` (line 79): uses `Functor.additive_of_preserves_binary_products`. Correct — sheafification is a left adjoint preserving finite limits.
  - `PresheafOfModules.counitComplexIso` (line 92): assembled from `HomologicalComplex.Hom.isoOfComponents` applied to the counit isomorphism degreewise. Correct.
  - `PresheafOfModules.homologyIsoSheafify` (lines 112–121): composes `homologyFunctor.mapIso (counitComplexIso.symm)` with `sheafification.mapHomologyIso'`. The `PreservesHomology` instance for `sheafification α` is required by `mapHomologyIso'`; since the file compiles, it is found. Sound.
  - `higherDirectImage_iso_sheafify_presheafHomology` (line 158): correct pipeline `isoRightDerivedObj ≪≫ homologyIsoSheafify`.
  - File header honestly acknowledges scope ("handed off step"): the final identification of the presheaf with `V ↦ Hⁿ(f⁻¹V, G)` is deferred.

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- **outdated comments**: 2 flagged (stale planning blocks)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (high `maxHeartbeats`)
- **excuse-comments**: none
- **notes**:
  - **Line 778**: `sorry` in `cech_computes_higherDirectImage`. Known frozen intentional sorry (per directive).
  - **Lines 161–183** (stale planning comment): says `pushPullMap_comp` is "left for a focused follow-up pass" and that "assembling `pushPullFunctor` needs it." But `pushPullMap_comp` IS proved at lines 627–630 and `pushPullFunctor` IS assembled at line 640. See **Major §4**.
  - **Lines 245–293** (stale planning comment): detailed block titled "Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon, **not yet closed**" with an explicit "**Why it is not yet closed** (next-prover dead-ends, all hit this iter)" subsection. In fact `pushPullMap_comp` is proved at lines 627–630 via `rawPushPullMap_comp`. The block actively misrepresents the state of the code. See **Major §5**.
  - `pushPullMap_id` (lines 188–243): proof via `unit_conjugateEquiv` + `pseudofunctor_right_unitality` + `Iso.inv_hom_id_app`. Axiom-clean.
  - `rawPushPullMap_comp` (lines 536–619): key pentagon proof via `pushPull_unit_comp` + `pushPull_pentagon`. Axiom-clean.
  - `pushPullMap_comp` (lines 627–630): two-line proof via `pushPullMap_eq_raw` + `rawPushPullMap_comp`. Axiom-clean.
  - `pushPullFunctor` (lines 640–644): correct functor assembly from the two functor laws.
  - `CechNerve` (lines 698–701): constructed via `CosimplicialObject.Augmented.whiskeringObj` applied to `coverCechNerveOverAug.rightOp`. The construction no longer postulates the nerve; it follows from the now-closed `pushPullFunctor`.
  - `CechComplex` (lines 737–745): defined via `relativeCechComplexOfNerve (CechNerve 𝒰 F)`. Correct.
  - `pushPull_pentagon` (lines 491–531): the pullback pseudofunctor pentagon. Proof via `pseudofunctor_associativity` + `Iso.hom_inv_id_app` iso cancellations. Axiom-clean.
  - **Lines 404, 467**: `set_option maxHeartbeats 1000000` and `set_option maxHeartbeats 4000000`. Performance-heavy proofs; fragile under Mathlib heartbeat budget changes. See **Minor §5**.

---

## Must-fix-this-iter

None. No findings meet the strict must-fix criteria (no excuse-comments on declarations, no weakened-wrong definitions, no unauthorized axioms, no `:= sorry` on substantive claims beyond the two known intentional sorries).

---

## Major

**§1 — Orphaned file: `HigherDirectImagePresheaf.lean` not imported.**
`AlgebraicJacobian.lean:1–7` vs `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean` — The new file `HigherDirectImagePresheaf.lean` is not imported in the root module `AlgebraicJacobian.lean`. Its declarations (`Functor.mapHomologyIso'`, `PresheafOfModules.homologyIsoSheafify`, `higherDirectImage_iso_sheafify_presheafHomology`) are unreachable from the build graph and will silently drift from the rest of the project. The root file must gain `import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf`.

**§2 — Stale module docstring in `PresheafCech.lean`.**
`AlgebraicJacobian/Cohomology/PresheafCech.lean:17–23` — The module docstring claims "This file is the home of the presheaf-level Čech machinery" and lists 5 declarations. Four of the five have been moved to other files: `cechFreePresheafComplex` and `cechFreeComplex_quasiIso` are in `FreePresheafComplex.lean`, and `cechComplex_hom_identification` and `injective_cech_acyclic` are slated for `CechBridge.lean`. Readers and future provers will look in the wrong place.

**§3 — Stale "TARGET 3 remains" block in `AcyclicResolution.lean`.**
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean:924–964` — The `/-! ### Status (iter-006) -/` block asserts "TARGET 3 (the acyclic-resolution staircase) remains" and lists `rightDerivedIsoOfAcyclicResolution` under REMAINING. But `rightDerivedIsoOfAcyclicResolution` is fully proved at lines 893–922, immediately above the comment. The block is a stale progress note from iter-006 that was not removed after TARGET 3 was closed.

**§4 — Stale planning note claiming `pushPullMap_comp` is unfinished (first occurrence).**
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:161–183` — Block comment describing the functor laws says `pushPullMap_comp` is "left for a focused follow-up pass" and warns that `pushPullFunctor` cannot be assembled without it. Both statements are false: `pushPullMap_comp` is proved at line 627 and `pushPullFunctor` is assembled at line 640.

**§5 — Stale "not yet closed" block for `pushPullMap_comp` (second, more detailed occurrence).**
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:245–293` — Detailed comment titled "Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon, **not yet closed**" actively describes the declaration as open, lists "next-prover dead-ends, all hit this iter," and prescribes a route forward. `pushPullMap_comp` is proved at line 627 via `rawPushPullMap_comp`. This is the most actively misleading stale comment in the project: future readers or provers acting on it would waste effort on already-closed work.

---

## Minor

**§1 — Aspirational comment about private `CombinatorialCech` declarations.**
`AlgebraicJacobian/Cohomology/CechAcyclic.lean:131–133` — Comment says the private declarations "exist only to close `CechAcyclic.affine` in this file." `CechAcyclic.affine` is currently `sorry`, so the description is aspirational, not factual. Not wrong in intent, but slightly misleading about the current state.

**§2 — `erw` usage in proofs requiring definitional equalities.**
Multiple locations:
- `FreePresheafComplex.lean:235–238` (`freeYonedaAug_app_freeMk`)
- `FreePresheafComplex.lean:256–258` (`freeYoneda_map_comp_aug`)
- `CechBridge.lean:163` (`homCechSectionIsoApp_hom_π`, `erw [piComparison_comp_π_assoc]`)

All proofs work but rely on `erw` to bridge definitional equalities that are not syntactic. These are fragile under Lean/Mathlib version changes and may silently fail after a refactor.

**§3 — Planning comment about work "held back this iteration."**
`AlgebraicJacobian/Cohomology/CechBridge.lean:196–207` — Comment says the naturality assembly for `cechComplex_hom_identification` "was held back this iteration only because the upstream FreePresheafComplex.lean was being edited concurrently." The comment is honest but references an iteration implicitly; it gives future readers no stable context. Not wrong, but should be updated or removed once the assembly is complete.

**§4 — Module docstring lists unimplemented declarations with no sorry stubs.**
`AlgebraicJacobian/Cohomology/CechBridge.lean:26–43` — Lists `cechComplex_hom_identification`, `injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` as "to be filled." None of these appear in the file at all (no sorry stubs, no skeletons). Minor: the docstring honestly says "to be filled by the prover," but the gap between the header and the actual content is larger than expected for an assembly file.

**§5 — High heartbeat limits in `CechHigherDirectImage.lean`.**
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:404` (`set_option maxHeartbeats 1000000`) and `:467` (`set_option maxHeartbeats 4000000`). These indicate proofs at the margin of Lean's default elaboration budget. They are correct but fragile: any future Mathlib change that slightly increases elaboration cost for the relevant lemmas could break the build silently.

---

## Excuse-comments (always called out separately)

None found. No declaration in the project carries a comment meeting the self-admission-of-wrongness pattern (`-- TODO replace with real def`, `-- placeholder`, `-- temporary wrong def`, `-- will fix later`, etc.).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The iter-018 additions (AwayComparison/CechLocalized in CechAcyclic, augmentation chain map in FreePresheafComplex, bridge scaffolding in CechBridge, and the 01XJ engine in HigherDirectImagePresheaf) are all axiom-clean and mathematically sound; the critical action items are administrative — one orphaned file must be added to the root import, and four stale planning comments spread across AcyclicResolution and CechHigherDirectImage must be updated or removed to prevent misleading future provers about what is already proved.
