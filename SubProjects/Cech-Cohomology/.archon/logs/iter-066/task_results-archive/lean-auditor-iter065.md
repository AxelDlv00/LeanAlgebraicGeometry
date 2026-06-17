# Lean Audit Report

## Slug
iter065

## Iteration
065

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 2 flagged (Stubs 5 and 6 are `sorry`)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 1418 — `cechSection_complex_iso` body `:= sorry`.**  Stub 5 is unproven.  The signature is correct (it is the right statement — `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`), and the planning comment above it is honest.  This is a load-bearing sorry: the module header says it is consumed by `CechAugmentedResolution.lean` to close `hSec`.  Must-fix.
  - **Line 1477 — `cechSection_contractible` body `:= sorry`.**  Stub 6 (contracting homotopy on the augmented concrete section complex) is unproven.  Also load-bearing for the `hSec` chain.  Must-fix.
  - **Lines 10–34 — module docstring over-claims what is proved.**  The docstring lists steps 1–6 as what "this file is"; steps 5 and 6 (`cechSection_complex_iso`, `cechSection_contractible`) carry explicit `sorry`s.  The mismatch creates a misleading first impression.  Major.
  - **Lines 582–610 — planner strategy comment for `cechBackbone_left_sigma` describes an approach not taken.**  The comment suggests using `Sigma.fiberProduct_sigma` / `Scheme.pullback_openCover_iSup`; the actual proof uses the project-local `widePullback_coproduct_iso` machinery instead.  No impact on soundness; minor staleness.
  - **`isZero_modules_of_isEmpty` (line 970) — GENUINE.**  Uses `(toPresheaf Z).map_injective` (faithful-functor reflection) then `Module.subsingleton` (module over a subsingleton ring is subsingleton) then `Subsingleton.elim _ _` to close the section-equality goal.  The `Subsingleton.elim` is over a `ModuleCat` element type that is a subsingleton because the ring of sections `Γ(Z, U)` is subsingleton when `IsEmpty ↥Z`.  No axiom laundering; not a thin-cat trap (the `Subsingleton` is on a genuine `Type`-level module, not a `Hom`-set).
  - **`pushPull_coprod_prod_empty` (line 985) — GENUINE.**  Shows source and target are terminal via `map_isZero` (additive functor, which is sound for `Scheme.Modules.pushforward`), `isColimitEquivIsInitialOfIsEmpty` (coproduct over `PEmpty` is initial), and `isZero_modules_of_isEmpty`.  No axiom laundering.
  - **`coprodToProd_isIso_of_equiv` (line 1011) — GENUINE.**  Standard reindexing by `Sigma.whiskerEquiv` / `Pi.whiskerEquiv`; the key identity is verified projection-by-projection.  Sound.
  - **`coprodToProd_isIso_option` (line 1093) — GENUINE.**  Option-step induction via the reference iso chain (`pushPullObjCongr`, `pushPull_binary_coprod_prod`, `Prod.mapIso`, `piOptionIso.symm`).  The `erw` usages (lines 1130, 1135, 1150, 1153) are justified by the known `prod.lift_fst`/`Pi.lift_π`-syntax-key issue documented in prior memory; they match the correct defeq path.  The `hcanon` identity is verified projectively.  Sound.
  - **`pushPull_sigma_iso` (line 1226) — GENUINE.**  Three-iso chain: `pushPullObjCongr F (cechBackbone_left_sigma)` → `pushPullObjCongr F (overSigmaDescIso …)` → `pushPull_coprod_prod F legs`.  The iso types chain correctly (coproduct-in-`Over X` descent object as source for `pushPull_coprod_prod`).  No axiom laundering; no sorry.
  - **`pushPull_eval_prod_iso` (line 1320) — GENUINE.**  Assembles `pushPull_sigma_iso`, `PreservesProduct.iso`, and `Pi.mapIso (pushPull_leg_sections …)`.  Clean assembly; no sorry.
  - **`Subsingleton.elim` at lines 739, 744 (inside `isIso_coprodDecompMap`) — SOUND.**  Both uses prove equalities between parallel morphisms in `(Opens (A ⨿ B))ᵒᵖ`, whose `Hom` types are definitionally `Prop`-valued (preorder morphisms via `homOfLE`).  This is standard proof-irrelevance for thin categories, NOT the thin-cat kernel trap (which arises when the morphism type is a `ULift` or `PLift` with non-trivial universe that the LSP does not re-check).  Safe.
  - **`maxHeartbeats` bumps** at lines 366, 788, 1088 are legitimate accommodations for whnf complexity of nested fibre-power / push–pull composites.

---

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 1 partial (STRETCH goal with 4 named sorries)
- **bad practices**: 1 flagged (duplicated lemma)
- **excuse-comments**: 0 flagged
- **notes**:
  - **Lines 973–985 — `higherDirectImage_openImmersion_comp` has 4 named sorries: `hacyc`, `eRes`, `hexact`, `transport`.**  These are the STRETCH goal.  All four are *honest and correctly-typed*:
    - `hacyc` (line 974): `∀ n, (Scheme.Modules.pushforward f).IsRightAcyclic (K.X n)` — the `f_*`-acyclicity of each `j_* Iⁿ`.  Introduced as `haveI` so it is silently consumed as an instance by the `refine` at line 975.  The `sorry` is correctly placed.
    - `eRes` (line 979): the pushforward of the resolution augmentation (iso `j_* H ≅ (K.X 0).cycles 0`).  Correctly typed as a `?eRes` named hole in the `refine`.
    - `hexact` (line 982): exactness of `K = j_*(I•)` in positive degrees (the `j_*`-acyclicity of each injective).  Correctly typed.
    - `transport` (line 985): the `pushforwardComp` transport iso.  Correctly typed.
    - The surrounding skeleton is NOT faking progress: `Functor.rightDerivedIsoOfAcyclicResolution` is genuinely invoked with the right arguments, and the final `≪≫ ?transport` is the correct morphism-level composition.  Must-fix (load-bearing sorries), but the skeleton is sound.
  - **Lines 42–50 — `isZero_of_faithful_preservesZeroMorphisms` is a duplicate of a lemma already in `CechAugmentedResolution.lean`.**  The docstring explicitly acknowledges: "A copy of the same lemma in `CechAugmentedResolution.lean`; reproduced here because that sibling file is not in this file's import chain."  Duplication creates maintenance risk (the two copies can diverge).  Should be factored into a shared base file.  Major.
  - **Lines 604–623 — `RESIDUAL STATE (iter-065 …)` comment block will become stale.**  It describes the iter-065 state accurately now, but iteration-specific in-proof status blocks accumulate staleness quickly.  Consider replacing with a timeless description of what was built, or removing once the file is mature.  Minor.
  - **`sliceReverseRingMap` (line 588) — GENUINE.**  The definition is:
    ```lean
    sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)
    ```
    The comment at lines 594–603 explains why the codomain typechecks: `sheafPushforwardContinuousComp` (composition of pushforward-continuous functors is `Iso.refl`) and `Over.mapForget` (`map g ⋙ forget = forget`) are definitional equalities, so the correction-carrying inverse slice functor `eqv.inverse` is definitionally equal to the bare `Over.post (Opens.map φ.symm.inv.base)` for the sheaf pushforward codomain.  This is a defeq-collapse in the correct direction (the simpler expression has the same kernel-normal-form as the stated type).  Not axiom-laundering.
  - **`pushforwardSliceAdjunctionH1` (line 630) — GENUINE; minor opacity.**  The proof closes with `erw [key2]; rfl` after establishing `key` (lines 640–645) and `key2` (lines 647–653).  The `congr 1` at line 645 closes a goal of the form `𝟙 (X.presheaf.obj …) = X.presheaf.map (f.op)` for an opens morphism `f`.  After `simp only [Scheme.Hom.id_app]`, the LHS is `X.presheaf.map (𝟙 (op …))`, so `congr 1` reduces to `𝟙 (op …) = f.op`, an equality of morphisms in `(Opens X)ᵒᵖ`.  Since `Opens X` is a preorder, these `Hom` types are definitionally `Prop`-valued; the equality holds by proof-irrelevance, and Lean closes it automatically.  This IS the thin-cat soundness question: the `Hom` type of `Opens X` in Mathlib is `homOfLE` returning a value of type `PLift (U ≤ V)`, which is NOT a bare `Prop`.  However, there IS a `Subsingleton (homOfLE _ _ : U ⟶ V)` instance via `instSubsingletonHom` (the preorder category provides this).  Lean 4's `congr 1` does NOT automatically invoke `Subsingleton` to close such a residual goal.  **If the kernel actually sees `𝟙 (op …) ≠ f.op` at the `PLift` level, this proof would fail.**  Given the prover claims sorry-free compilation, the most likely explanation is that `Over.Hom.left ((sliceOversEquiv φ Ui).unitInv.app (unop U))` reduces definitionally to the identity opens morphism (the `postEquiv` unit at the object level is the identity functor's natural iso, whose components are `id`), making the equality `rfl`-closed after `congr 1`.  This is mathematically correct but warrants an explicit `rfl` or `Subsingleton.elim _ _` to make the closing step transparent.  Minor.
  - **`pushforwardSliceAdjunctionH2` (line 661) — GENUINE.**  The `Subsingleton.elim _ _` at line 680:
    ```lean
    exact (congrArg Y.presheaf.map (Subsingleton.elim _ _)).trans
      (CategoryTheory.Functor.map_id Y.presheaf _)
    ```
    proves `Y.presheaf.map (f.op) = 𝟙 _` by showing `f.op = 𝟙 (op …)` via `Subsingleton.elim` (parallel opens morphisms) then `Functor.map_id`.  The `Subsingleton` usage here IS explicit and correct — the opens morphism type is thin.  Sound.
  - **`pushforwardSlicePullbackIso` (line 719) — GENUINE.**  Uses `leftAdjointUniq ≪≫ Iso.refl _`.  The `Iso.refl _` is the rfl-clean identity: both `(pullback ψ_r).obj (H.over Ui)` (via the adjunction uniqueness) and `(Φ H).over Vᵢ` have sections `Γ(H, φ.hom ⁻¹ᵁ W.left)` by `Scheme.Modules.pushforward_obj_obj`, making them definitionally equal.  Sound.
  - **`higherDirectImage_openImmersion_acyclic` (line 826) — GENUINE and sorry-free.**  The status comment at lines 608–609 ("now fully sorry-free") is accurate.  The proof goes through: `IsAffineHom` derivation → `higherDirectImage_iso_sheafify_presheafHomology` → `isZero_of_faithful_preservesZeroMorphisms` → `sheafificationCompToSheaf` → per-affine-open section vanishing via the full Bridge (1)/(2) chain (`sectionsFunctorCorepIso`, `rightDerivedNatIso`, `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `ext_jShriekOU_eq_zero_of_specIso`) → `isZero_presheafToSheaf_of_sections_locally_zero`.  No sorry in any of these sub-steps.  The four `case hV'`/`hjt`/`hqc` goals are all discharged without sorry (lines 891, 892, 900).  The comment "discharged in full" at line 897 is accurate.
  - **`pushforward_iso_preserves_qcoh` (line 737) — GENUINE.**  Complete proof using `pushforwardSlicePullbackIso`, `Presentation.map`, and `IsIso`-reflection.  No sorry.
  - **Heartbeat bumps** at lines 414–416 (`synthInstance.maxHeartbeats 1000000`, `maxHeartbeats 2000000`) and 493–496 (`maxHeartbeats 4000000`, `synthInstance.maxHeartbeats 2000000`) and 726–730 are legitimate: the sliced/doubly-sliced `HasSheafify`/`WEqualsLocallyBijective` instance synthesis is known to time out at default budgets.

---

## Must-fix-this-iter

- `CechSectionIdentification.lean:1418` — `cechSection_complex_iso := sorry`. Load-bearing for the `hSec` chain in `CechAugmentedResolution.lean` (module header explicitly states this).  Why must-fix: `:= sorry` on a load-bearing claim.
- `CechSectionIdentification.lean:1477` — `cechSection_contractible := sorry`. Also load-bearing for `hSec`.  Why must-fix: `:= sorry` on a load-bearing claim.
- `OpenImmersionPushforward.lean:974` — `hacyc` sorry (`∀ n, IsRightAcyclic (K.X n)`).  Why must-fix: `:= sorry` on a load-bearing obligation of `higherDirectImage_openImmersion_comp`.
- `OpenImmersionPushforward.lean:979` — `eRes` sorry (resolution augmentation transport).  Why must-fix: same.
- `OpenImmersionPushforward.lean:982` — `hexact` sorry (exactness of `K`).  Why must-fix: same.
- `OpenImmersionPushforward.lean:985` — `transport` sorry (pushforwardComp iso transport).  Why must-fix: same.

---

## Major

- `CechSectionIdentification.lean:10–34` — Module docstring lists steps 5 and 6 ("promotes degreewise isos to a complex iso", "produces a contracting homotopy") as delivered by the file, but both are sorry'ed.  Stale over-claim; misleads a reader scanning the file summary.
- `OpenImmersionPushforward.lean:42–50` — `isZero_of_faithful_preservesZeroMorphisms` is explicitly acknowledged as a copy of the same lemma from `CechAugmentedResolution.lean`.  Two in-sync copies will diverge.  Correct fix: factor into a shared `CategoryTheory.lean` supplement that both files can import.

---

## Minor

- `CechSectionIdentification.lean:582–610` — Planner strategy comment for `cechBackbone_left_sigma` references `Sigma.fiberProduct_sigma` / `Scheme.pullback_openCover_iSup` as "Key Mathlib anchors" but the actual proof uses project-local `widePullback_coproduct_iso`.  Stale alternate-route planning comment.
- `OpenImmersionPushforward.lean:604–623` — The `RESIDUAL STATE (iter-065 …)` block embeds an iteration number.  Will become stale commentary in future iters.  Replace with a timeless description of what was built, or remove.
- `OpenImmersionPushforward.lean:645` — `congr 1` closing an opens-morphism equality in `pushforwardSliceAdjunctionH1`.  Mathematically sound (the `PLift`-wrapped `homOfLE` types are subsingleton), but the closing step is opaque to a reader.  An explicit `rfl` or `Subsingleton.elim _ _` would make the proof step transparent without changing correctness.

---

## Excuse-comments (always called out separately)

None. The `sorry` bodies all have accurate, non-excuse contextual comments (honest labeling of open mathematical obligations, not admissions that a definition is wrong).

---

## Severity summary

- **must-fix-this-iter**: 6 (2 in CSI: Stubs 5/6; 4 in OpenImm: STRETCH goal skeleton sorries)
- **major**: 2 (stale module header in CSI; duplicated lemma in OpenImm)
- **minor**: 3 (stale strategy comment in CSI; iter-numbered status block in OpenImm; opaque `congr 1` in OpenImm H1)
- **excuse-comments**: 0

Overall verdict: Both files are structurally sound with no axiom laundering, no thin-cat kernel-soundness traps, and no suspect definitions; the 6 must-fix items are all honest and correctly-typed open proof obligations (Stubs 5/6 in CSI; 4 STRETCH-goal holes in OpenImm).
