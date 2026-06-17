# AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## sectionCechAugV_π (was line 370) — **RESOLVED, axiom-clean**

### Attempt 1
- **Approach:** Exactly the planner's degree-0 seam route, realized as five helper bricks +
  a term-chained main assembly:
  1. `coreIso_objIso 𝒰 F 0 V ≫ Pi.π σ` unwound through `pushPull_eval_prod_iso`
     (three definitional `rfl`-decompositions `hcoreDef`/`hevalDef`/`hmapiso1`/`hmapiso2` —
     `Iso.trans`/`Pi.mapIso`/`eqToIso` are all projection-`rfl`) and π-extracted with
     `Limits.Pi.map_π`, `Limits.PreservesProduct.iso_hom`, `Limits.piComparison_comp_π`,
     then the PROVED Base seam `pushPull_sigma_iso_π`.
  2. `cechAugmentation_pushPullMap` (new): `cechAugmentation ≫ pushPullMap F g =
     pullbackPushforwardAdjunction-unit` for **any** `g : Y ⟶ Y₀` in `Over X` — the
     augmentation factors through the terminal `Over.mk (𝟙 X)`, so
     `pushPullMap F aug₀ ≫ pushPullMap F g = pushPullMap F (g ≫ aug₀)` (`pushPullMap_comp`)
     and the composite collapses by `pushPullMap_eq_raw` + a new mate-calculus brick
     `rawPushPullMap_unit` (`η^{p₁} ≫ rawPushPullMap a p₁ p₂ w F = η^{p₂}`, proof: `subst w`,
     `rawPushPullMap_self`, `pushPull_unit_comp`, strictness of pushforward via
     `Scheme.Modules.hom_ext; intro U; rfl`). The nerve-point identification is the
     identity-adjunction unit (`cechNervePointIso_inv_eq_unit`, via `unit_conjugateEquiv` +
     `conjugateEquiv_pullbackId_hom` + naturality — same toolkit as `pushPullMap_id`).
     Key rfl: `(CechNerve 𝒰 F).hom.app ⦋0⦌ = 𝟙 _ ≫ pushPullMap F (aug-hom.app (op ⦋0⦌))`.
  3. `unit_pushPull_leg_sections` (new): the unit reads through `pushPull_leg_sections` as
     the plain restriction. Crux: Mathlib's `restrictAdjunction_unit_app_app` is **rfl**
     (the restriction-adjunction unit IS `F.presheaf.map (homOfLE (image_preimage_le)).op`
     on sections), and `restrictFunctorIsoPullback = leftAdjointUniq restrictAdjunction
     pullbackPushforwardAdjunction` definitionally, so
     `Adjunction.unit_leftAdjointUniq_hom_app` conjugates the pullback unit to the
     restriction unit; the `pushPull_leg_sections` decomposition (`hdec`) and the
     section-evaluation of the restriction unit (`hunit`) are both **rfl**.
  4. Transports: `stubEqToHomRestr` (new) converts any `eqToHom` between `P.obj (op ·)`
     section groups into `P.map (homOfLE ·).op`; parallel restriction chains collapse by
     `Subsingleton.elim` on `Opens`-homs.
- **Result:** RESOLVED. `lake env lean` EXIT=0, `lake build` green,
  `#print axioms sectionCechAugV_π = [propext, Classical.choice, Quot.sound]` — axiom-clean.
- **Key insight (for Lane 2 / `coreIso_comm_leg`):** `rw` SYSTEMATICALLY FAILS on these goals
  because substituting one factor of a composite leaves the `CategoryStruct.comp` implicit
  middle-object in a different (defeq-but-not-syntactic) presentation than the next lemma's
  pattern (`E.obj (j_* pb F)` vs `P.obj (op (j''ᵁ j⁻¹V))` etc.); rw/kabstract matches only up
  to reducible transparency. **Every association/fusion step must be a term-mode
  `Eq.trans`/`congrArg` chain** (full-defeq unification at `exact`-level absorbs the
  presentation mismatches); `refine Eq.trans (congrArg (fun m => m ≫ _) h) ?_` with
  goal-inferred underscores keeps this tolerable. Also: `eqToHom p₁ = eqToHom p₂` is free by
  definitional proof irrelevance, so transports can be re-canonicalized to `congrArg`-form
  inside a single `rfl`-`have` (this is how `hdec` swallows the `eqToIso (by change ...; rw ...)`
  inside `pushPull_leg_sections` without ever touching its opaque proof term).
- **Other gotchas:** `Limits.evaluation_preservesLimitsOfShape`/`comp_preservesLimitsOfShape`
  need the Base-style explicit `@`-application + `haveI` chain (synthesis fails otherwise);
  `set_option synthInstance.maxHeartbeats 1000000` needed for the `HasLimit (Discrete.functor
  fun τ => pushPullObj …)` product instance.

### Dead ends
- `rw [← pushPullMap_comp]`, `rw [Category.assoc]`, `rw [hLAU]` etc. on composites with
  substituted factors — all fail with "pattern not found" despite the pattern being visibly
  present (middle-object presentation mismatch, see key insight). Do not retry rw-chains here.
- `simp only [Adjunction.id_unit, …, Category.id_comp] at star` does not remove the `𝟙 F ≫`
  (heterogeneous `𝟙` typed at `(𝟭 _).obj F`); chain `(Category.id_comp _).symm.trans star`
  instead.

## Needs blueprint entry
All five are `private` helpers for `lem:sectionCechAugV_π`; suggest bundling their names into
that lemma's `\lean{…}` list (house convention for private helpers):
- `AlgebraicGeometry.stubEqToHomRestr` — eqToHom-to-restriction transport killer.
  Uses: `eqToHom_refl`, `Subsingleton.elim` on Opens-homs.
- `AlgebraicGeometry.rawPushPullMap_unit` — `η^{p₁} ≫ rawPushPullMap a p₁ p₂ w F = η^{p₂}`.
  Uses: `rawPushPullMap_self`, `pushPull_unit_comp`, `Scheme.Modules.hom_ext`.
- `AlgebraicGeometry.cechNervePointIso_inv_eq_unit` — `(cechNervePointIso 𝒰 F).inv =
  (pullbackPushforwardAdjunction (𝟙 X)).unit.app F`. Uses: `unit_conjugateEquiv`,
  `Scheme.Modules.conjugateEquiv_pullbackId_hom`.
- `AlgebraicGeometry.cechAugmentation_pushPullMap` — augmentation ≫ push–pull of any
  backbone map = adjunction unit (terminal-object collapse). Uses: `pushPullMap_comp`,
  `pushPullMap_eq_raw`, the two bricks above.
- `AlgebraicGeometry.unit_pushPull_leg_sections` — unit through `pushPull_leg_sections` =
  plain restriction. Uses: `Adjunction.unit_leftAdjointUniq_hom_app`,
  `Scheme.Modules.restrictAdjunction_unit_app_app` (rfl), `Scheme.Hom.
  image_preimage_eq_opensRange_inf`, `Scheme.Opens.opensRange_ι`, `stubEqToHomRestr`.

## Summary
- Sorry count: **1 → 0** in `CechSectionIdentification.lean`.
- Closed: `sectionCechAugV_π` (the assigned PARTIAL-BAR leaf; satisfies the
  progress-critic convergence watch-flag).
- Consequence: the whole Stub-6 block (`cechSection_comm_zero`, `cechSection_comm_one`,
  `cechSection_succ_step`, `cechSection_contractible`) is now sorry-free **in this file**;
  `cechSection_complex_iso`/`cechSection_contractible` still inherit `sorryAx` solely
  through `coreIso_comm_leg` (Lane 2, `CechSectionIdentificationLeg.lean:68`). Once Lane 2
  closes, CSI is fully sorry-free and `CechAugmentedResolution.hSec` (229) is wireable.
- Verification: `lake env lean` EXIT=0; `lake build AlgebraicJacobian.Cohomology.
  CechSectionIdentification` green (8324 jobs); `#print axioms` on `sectionCechAugV_π` =
  kernel axioms only.
- Adjacent sorries: none left in my file; the only nearby sorry (`coreIso_comm_leg`) is in
  another prover's assigned file (not editable from this lane). The "key insight" +
  "dead ends" sections above are directly transferable to that lane (same seam-unwinding,
  degree p+1 with coface combinatorics on top).
- Housekeeping: module header status comment updated (0 sorries).

## Why I stopped
`Real progress`: closed 1 sorry — `sectionCechAugV_π`, the assigned objective (sorry count
1 → 0; file build-green and axiom-clean). No other sorry exists in my assigned file; the
adjacent open leaf belongs to the parallel Lane-2 file which I am not permitted to edit.
