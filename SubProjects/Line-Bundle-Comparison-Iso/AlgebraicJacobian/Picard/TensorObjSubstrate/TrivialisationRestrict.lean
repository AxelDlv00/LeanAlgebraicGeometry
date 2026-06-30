/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorMapIso

/-!
# Restriction-reindex infrastructure (monster-free leaf)

This file holds the restriction-reindex helpers that `TensorObjInverse.lean`
needs for the keystone Seam-1/Seam-2 chart-chase, extracted to a separate
monster-free leaf so that the Lean LSP works here.

The parent file `TensorObjInverse.lean` imports the 12.8M-HB monster
`PresheafDualPullback`, which kills the LSP there.  By splitting out these
pure restrict/pullback glue declarations (none of which need the monster),
we keep an LSP-alive workspace for the remaining chart-chase proofs.

**HARD CONSTRAINT**: this file must NOT (transitively) import
`DualInverse.PresheafDualPullback` or `DualInverse.PresheafDualUnitPullback`.
-/

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## Cocycle-A helpers for `exists_tensorObj_inverse`

`trivialisation_restrict_compat` reduces the sectionwise overlap equation
(residual-A step 1) from the `(U i).ι⁻¹`-vs-`(U j).ι⁻¹` form to a single-open-`V`
equation, enabling `tensorObj_unit_self_duality_collapse` to close the `g·g⁻¹ = 1`
cancellation (step 2). -/

/-- **Reindexing iso `ρ_A` (the keystone identification).** For the chart `j : V ⟶ U` with
`j ≫ U.ι = V.ι`, the `V`-restriction of an `X`-module `A` is canonically the `j`-restriction of its
`U`-restriction: `A.restrict V.ι ≅ (A.restrict U.ι).restrict j`.  Built from the keystone
`restrictFunctorComp j U.ι` (`Mathlib`) post-composed with the `j ≫ U.ι = V.ι` congruence
`restrictFunctorCongr`.  This is the `ρ` of the blueprint S2–S4c squares, on both flanks of each. -/
noncomputable def restrictCompReindex {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) (A : X.Modules) :
    A.restrict V.ι ≅ (A.restrict U.ι).restrict j :=
  (restrictFunctorCongr hjι).symm.app A ≪≫ (restrictFunctorComp j U.ι).app A

/-! ### Step A — atomic per-leg conjugate computations for the B2 telescope

The natural-transformation identity `hNat` of `restrictFunctorIsoPullback_comp_compat_hom`
is proved by conjugating both sides onto the common right adjoint `pushforward V.ι` and
distributing leg-by-leg via `conjugateEquiv_comp`.  Each per-leg conjugate value is one of
the following atomic claims (blueprint `lem:conjugateequiv_*`). -/

/-- **c₅ (blueprint `lem:conjugateequiv_pullbackcomp_hom`): conjugate of the pullback-composition
hom.** Mirror of Mathlib's `conjugateEquiv_pullbackComp_inv`: applying `conjugateEquiv` (in the
swapped adjunction order, so it accepts `.hom : L₁ ⟶ L₂`) to `(pullbackComp f g).hom` gives the
*inverse* of the pushforward-composition iso.  Obtained from `conjugateEquiv_pullbackComp_inv` by
the `conjugateEquiv_comm` cancellation `hom ; inv = 𝟙`. -/
lemma conjugateEquiv_pullbackComp_hom {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z)
    [IsOpenImmersion f] [IsOpenImmersion g] :
    conjugateEquiv (pullbackPushforwardAdjunction (f ≫ g))
        ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
        (pullbackComp f g).hom
      = (pushforwardComp f g).inv := by
  have hcomm := conjugateEquiv_comm
    ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
    (pullbackPushforwardAdjunction (f ≫ g))
    (α := (pullbackComp f g).inv) (β := (pullbackComp f g).hom)
    (Iso.hom_inv_id _)
  rw [conjugateEquiv_pullbackComp_inv] at hcomm
  -- hcomm : (pushforwardComp f g).hom ≫ conjugateEquiv … (pullbackComp f g).hom = 𝟙
  rw [← cancel_epi (pushforwardComp f g).hom, hcomm, Iso.hom_inv_id]

/-- **LHS of the B2 telescope: the conjugate of `restrictFunctorIsoPullback f` is the identity.**
`restrictFunctorIsoPullback f = leftAdjointUniq (restrictAdjunction f) (pullbackPushforwardAdjunction f)`,
both adjoint to the common `pushforward f`; the conjugate of a `leftAdjointUniq` hom onto the shared
right adjoint is the identity. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_hom {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] :
    conjugateEquiv (pullbackPushforwardAdjunction f) (restrictAdjunction f)
        (restrictFunctorIsoPullback f).hom
      = 𝟙 (pushforward f) := by
  rw [Equiv.apply_eq_iff_eq_symm_apply]
  simp only [restrictFunctorIsoPullback, Adjunction.leftAdjointUniq, Iso.symm_hom,
    conjugateIsoEquiv_symm_apply_inv, Iso.refl_inv]

/-- **c₃ (blueprint `lem:conjugateequiv_restrictfunctorisopullback_whiskerright`): conjugate of the
`f`-comparison whiskered by `restrict j`.** The leg `whiskerRight (restrictFunctorIsoPullback f).hom
(restrictFunctor j)`, conjugated through the composite adjunctions `(pPA f).comp (rA j) →
(rA f).comp (rA j)`, is the identity: by `conjugateEquiv_whiskerRight` it becomes
`whiskerLeft (pushforward j)` of the (identity) conjugate of `restrictFunctorIsoPullback f`. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_whiskerRight {X Y Z : Scheme.{u}}
    (f : Y ⟶ X) (j : Z ⟶ Y) [IsOpenImmersion f] [IsOpenImmersion j] :
    conjugateEquiv ((pullbackPushforwardAdjunction f).comp (restrictAdjunction j))
        ((restrictAdjunction f).comp (restrictAdjunction j))
        (Functor.whiskerRight (restrictFunctorIsoPullback f).hom (restrictFunctor j))
      = 𝟙 _ := by
  rw [conjugateEquiv_whiskerRight, conjugateEquiv_restrictFunctorIsoPullback_hom,
    Functor.whiskerLeft_id']

/-- **c₄ (blueprint `lem:conjugateequiv_restrictfunctorisopullback_whiskerleft`): conjugate of the
`j`-comparison whiskered into `pullback f`.** The leg `whiskerLeft (pullback f)
(restrictFunctorIsoPullback j).hom`, conjugated through `(pPA f).comp (pPA j) → (pPA f).comp (rA j)`,
is the identity: by `conjugateEquiv_whiskerLeft` it becomes `whiskerRight` of the (identity)
conjugate of `restrictFunctorIsoPullback j`. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_whiskerLeft {X Y Z : Scheme.{u}}
    (f : Y ⟶ X) (j : Z ⟶ Y) [IsOpenImmersion f] [IsOpenImmersion j] :
    conjugateEquiv ((pullbackPushforwardAdjunction f).comp (pullbackPushforwardAdjunction j))
        ((pullbackPushforwardAdjunction f).comp (restrictAdjunction j))
        (Functor.whiskerLeft (pullback f) (restrictFunctorIsoPullback j).hom)
      = 𝟙 _ := by
  rw [conjugateEquiv_whiskerLeft, conjugateEquiv_restrictFunctorIsoPullback_hom,
    Functor.whiskerRight_id']

/-- Sectionwise value of `(restrictFunctor f).map`: pushforward along an open immersion acts on a
morphism `φ` by reindexing its components through `f ''ᵁ -`.  Holds by `rfl`; project-local because
it is only used to drive the sectionwise reduction in
`conjugateEquiv_restrictFunctorComp_inv`. -/
private lemma restrictFunctor_map_app' {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    {M N : Y.Modules} (φ : M ⟶ N) (U : X.Opens) :
    ((restrictFunctor f).map φ).app U = φ.app (f ''ᵁ U) := rfl

set_option maxHeartbeats 1600000 in
-- The sectionwise reduction below traverses the `SheafOfModules.pushforward` carrier diamond
-- (`restrict_map`/`erw` past defeq-not-syntactic `≫`), which needs a raised heartbeat budget.
set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
/-- **Restrict-side conjugate of the restriction-composition isomorphism.**
The conjugate of `(restrictFunctorComp f g).hom` across the composite restrict-adjunction equals
`(pushforwardComp f g).hom`.  Public so the terminal file can consume it.  (Ported from the v4.30
root `TensorObjSubstrate.lean` tail, which was dropped in the file-split migration.) -/
lemma conjugateEquiv_restrictFunctorComp_inv {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z)
    [IsOpenImmersion f] [IsOpenImmersion g] :
    conjugateEquiv ((restrictAdjunction g).comp (restrictAdjunction f))
        (restrictAdjunction (f ≫ g)) (restrictFunctorComp f g).hom
      = (pushforwardComp f g).hom := by
  rw [show (restrictFunctorComp f g).hom
      = (Adjunction.leftAdjointCompIso (restrictAdjunction g) (restrictAdjunction f)
          (restrictAdjunction (f ≫ g)) (pushforwardComp f g)).inv from ?_]
  · exact Adjunction.conjugateEquiv_leftAdjointCompIso_inv _ _ _ _
  · ext M U : 3
    rw [restrictFunctorComp_hom_app_app]
    simp only [Adjunction.leftAdjointCompIso, conjugateIsoEquiv_symm_apply_inv,
      Iso.symm_inv, conjugateEquiv_symm_apply_app, Adjunction.comp_unit_app, Hom.comp_app,
      restrictFunctor_map_app', pushforwardComp_hom_app_app]
    erw [Hom.comp_app, restrictAdjunction_unit_app_app, pushforward_map_app,
      restrictAdjunction_unit_app_app, restrictAdjunction_counit_app_app]
    simp only [Functor.comp_obj, restrict_map]
    erw [Category.id_comp, ← M.presheaf.map_comp, ← M.presheaf.map_comp]
    all_goals first
      | rfl
      | (congr 1; exact Subsingleton.elim _ _)

/-- **General B2 (`.hom`/NatTrans level): `restrictFunctorIsoPullback` pseudonaturality across a
LITERAL composite `f ≫ g`.**  The dual-flank analogue of `restrictFunctorIsoPullback_comp_compat_hom`
for general composable open immersions `f : Z ⟶ Y`, `g : Y ⟶ X` (arbitrary schemes), with NO
`restrictFunctorCongr`/`pullbackCongr` congruence legs (the composite is literal, so those collapse).
Same conjugate-telescope proof: `conjugateEquiv` injectivity onto `pushforward (f ≫ g)`, distribute
leg-by-leg via `← conjugateEquiv_comp`, then the keystone `conjugateEquiv_restrictFunctorComp_inv`
(c₂ ↦ `(pushforwardComp).hom`) + `conjugateEquiv_pullbackComp_hom` (c₅ ↦ `(pushforwardComp).inv`)
+ the two whisker-conjugates (c₃/c₄ ↦ 𝟙) telescope to `𝟙`. -/
private lemma restrictFunctorIsoPullback_comp_general_hom {X Y Z : Scheme.{u}} (f : Z ⟶ Y)
    (g : Y ⟶ X) [IsOpenImmersion f] [IsOpenImmersion g] (A : X.Modules) :
    (restrictFunctorIsoPullback (f ≫ g)).hom.app A
      = (restrictFunctorComp f g).hom.app A
          ≫ (restrictFunctor f).map ((restrictFunctorIsoPullback g).hom.app A)
          ≫ (restrictFunctorIsoPullback f).hom.app ((pullback g).obj A)
          ≫ (pullbackComp f g).hom.app A := by
  -- Same leg-by-leg conjugate telescope as the chart version `restrictFunctorIsoPullback_comp_compat_hom`,
  -- but for the LITERAL composite `f ≫ g` (no `restrictFunctorCongr`/`pullbackCongr` flank legs, so
  -- only the 4 inner legs survive and they telescope directly to `𝟙`).
  have hNat : (restrictFunctorIsoPullback (f ≫ g)).hom
      = (restrictFunctorComp f g).hom
          ≫ Functor.whiskerRight (restrictFunctorIsoPullback g).hom (restrictFunctor f)
          ≫ Functor.whiskerLeft (pullback g) (restrictFunctorIsoPullback f).hom
          ≫ (pullbackComp f g).hom := by
    apply (conjugateEquiv (pullbackPushforwardAdjunction (f ≫ g))
      (restrictAdjunction (f ≫ g))).injective
    rw [conjugateEquiv_restrictFunctorIsoPullback_hom]
    rw [← conjugateEquiv_comp (pullbackPushforwardAdjunction (f ≫ g))
          ((restrictAdjunction g).comp (restrictAdjunction f)) (restrictAdjunction (f ≫ g)),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction (f ≫ g))
          ((pullbackPushforwardAdjunction g).comp (restrictAdjunction f))
          ((restrictAdjunction g).comp (restrictAdjunction f)),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction (f ≫ g))
          ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
          ((pullbackPushforwardAdjunction g).comp (restrictAdjunction f))]
    rw [conjugateEquiv_restrictFunctorComp_inv, conjugateEquiv_pullbackComp_hom,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerRight,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerLeft]
    simp only [Category.id_comp, Category.comp_id, Iso.inv_hom_id]
  have happ := congr_app hNat A
  -- v4.31: `simpa using` runs at reducible transparency; normalise `happ` then close by `exact`.
  simp only [NatTrans.comp_app, Functor.whiskerRight_app, Functor.whiskerLeft_app] at happ
  exact happ

/-- **General B2 (iso level): `restrictFunctorIsoPullback` pseudonaturality across a LITERAL
composite `f ≫ g`.**  The dual-flank analogue of `restrictFunctorIsoPullback_comp_compat` for general
composable open immersions, with `restrictFunctorComp f g` (NOT `restrictCompReindex`) as the head and
NO `pullbackCongr` tail.  Both sides are isos `(restrictFunctor (f ≫ g)).obj A ≅ (pullback (f ≫ g)).obj A`;
pinned by the `leftAdjointUniq` characterisation as in the chart version, the residual `.hom`-naturality
being `restrictFunctorIsoPullback_comp_general_hom`. -/
lemma restrictFunctorIsoPullback_comp_general {X Y Z : Scheme.{u}} (f : Z ⟶ Y)
    (g : Y ⟶ X) [IsOpenImmersion f] [IsOpenImmersion g] (A : X.Modules) :
    (restrictFunctorIsoPullback (f ≫ g)).app A
      = (restrictFunctorComp f g).app A
          ≪≫ (restrictFunctor f).mapIso ((restrictFunctorIsoPullback g).app A)
          ≪≫ (restrictFunctorIsoPullback f).app ((pullback g).obj A)
          ≪≫ (pullbackComp f g).app A := by
  apply Iso.ext
  apply (restrictAdjunction (f ≫ g)).homEquiv _ _ |>.injective
  conv_lhs => rw [show ((restrictFunctorIsoPullback (f ≫ g)).app A).hom
    = ((restrictAdjunction (f ≫ g)).leftAdjointUniq
        (pullbackPushforwardAdjunction (f ≫ g))).hom.app A
    from rfl, Adjunction.homEquiv_leftAdjointUniq_hom_app]
  rw [Adjunction.homEquiv_unit]
  simp only [Iso.trans_hom, Functor.mapIso_hom, Functor.map_comp, Iso.app_hom]
  rw [show (pullbackPushforwardAdjunction (f ≫ g)).unit.app A
      = (restrictAdjunction (f ≫ g)).unit.app A
          ≫ (pushforward (f ≫ g)).map ((restrictFunctorIsoPullback (f ≫ g)).hom.app A)
      from (Adjunction.unit_leftAdjointUniq_hom_app (restrictAdjunction (f ≫ g))
        (pullbackPushforwardAdjunction (f ≫ g)) A).symm]
  congr 1
  rw [restrictFunctorIsoPullback_comp_general_hom f g A, Functor.map_comp, Functor.map_comp,
    Functor.map_comp]

/-- **Unit-restriction identification.** For an open immersion `f : Y ⟶ X`, the restriction of the
global unit `𝒪_X` to `Y` is `𝒪_Y`: `(𝒪_X).restrict f ≅ 𝒪_Y`.  This is `uι(f)` of the blueprint
(`(restrictFunctorIsoPullback f).app 𝒪_X ≪≫ pullbackUnitIso f`); also the unit identification used
on the chart-scheme side of S4a/S4b. -/
noncomputable def unitRestrictIso {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] :
    restrict (SheafOfModules.unit X.ringCatSheaf) f ≅ SheafOfModules.unit Y.ringCatSheaf :=
  (restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf) ≪≫ pullbackUnitIso f

/-- **Keystone Seam-1 identity: `restrictIsoUnitOfLE` is the reindexed `restrict j`-image of the
trivialisation.**  For the chart `j : V ⟶ U` (`j ≫ U.ι = V.ι`) and a trivialisation
`e : M|_U ≅ 𝒪_U`, the refined trivialisation `restrictIsoUnitOfLE hVU e : M|_V ≅ 𝒪_V` factors as the
reindex `restrictCompReindex j hjι M`, the `restrict j`-image `(restrictFunctor j).mapIso e`, and the
unit-restriction comparison `unitRestrictIso j`.  This is the `e ↦ (restrict j) e` identification the
blueprint Seam-1 split rests on (`restrictIsoUnitOfLE hVU e = (restrict j) e` modulo the unit
identifications).  It mirrors the definitional chart-chase of `restrictIsoUnitOfLE` itself, where the
internal chart morphism is exactly `j = Scheme.Hom.resLE (𝟙 X) U V hVU`. -/
lemma restrictIsoUnitOfLE_eq_restrict {X : Scheme.{u}} {M : X.Modules} {U V : X.Opens}
    (hVU : V ≤ U) (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    restrictIsoUnitOfLE hVU e
      = restrictCompReindex j hjι M
          ≪≫ (restrictFunctor j).mapIso e
          ≪≫ unitRestrictIso j := by
  -- `restrictIsoUnitOfLE hVU e` (unfolded) is the pullback-world chart-chase
  --   `RFIP(V.ι) ≪≫ pullbackCongr(hjι.symm) ≪≫ (pullbackComp j U.ι).symm
  --      ≪≫ (pullback j)(RFIP(U.ι).symm) ≪≫ (pullback j) e ≪≫ asIso (pullbackObjUnitToUnit j)`.
  -- The RHS unfolds `restrictCompReindex = (restrictFunctorCongr hjι).symm ≪≫ restrictFunctorComp j U.ι`
  -- and `unitRestrictIso j = RFIP(j).app 𝒪_U ≪≫ pullbackUnitIso j`.  The two presentations agree once
  -- `restrictFunctorComp`/`restrictFunctorCongr` are pushed into the pullback world by
  -- `restrictFunctorIsoPullback_comp_general` (the same RFIP-bridge S2/S4c use); the trailing
  -- `pullbackObjUnitToUnit j` matches `pullbackUnitIso j` definitionally.
  -- After `Iso.ext` the residual goal is the `.hom`-level chart-chase reconciliation
  --   `(restrictIsoUnitOfLE hVU e).hom
  --      = (restrictCompReindex j hjι M ≪≫ (restrictFunctor j).mapIso e ≪≫ unitRestrictIso j).hom`.
  -- BLOCKER: the `restrictFunctorComp ↔ pullbackComp` reconciliation through the `pullbackCongr`/
  -- `restrictFunctorCongr` shim needs build-driven `trace_state` stepping (LSP dead on this
  -- monster-importing file); re-break candidate per the no-grind guard.
  apply Iso.ext
  sorry

/-- **Telescope seam 2 (blueprint `lem:trivialisation_telescope_assemble`): generic
`ρ`-cancellation assembly of the five restriction-naturality squares.**

Work in an arbitrary category `C` (sibling of `dual_scp_assemble` / `unit_assemble` /
`hcore_assemble`).  Given the five `restrict j`-image constituents `dU₁,…,dU₅` (the
`(restrict j)`-images of the `U`-built chain constituents `c^U_k`) and their `V`-built counterparts
`cV₁,…,cV₅`, with the six reindexing isos `ρ₀,…,ρ₅`, suppose each constituent satisfies its
restriction-naturality square
`dU_k = ρ_{k-1}.hom ≫ cV_k ≫ ρ_k.inv`
(so the target reindex `ρ_k` of square `k` is the source reindex of square `k+1`).  Then composing
the five squares in order, the internal reindexings `ρ₁,…,ρ₄` cancel telescopically:
`dU₁ ≫ ⋯ ≫ dU₅ = ρ₀.hom ≫ (cV₁ ≫ ⋯ ≫ cV₅) ≫ ρ₅.inv`,
leaving only the two outer reindexings `ρ₀ = hobjU` and `ρ₅ = hobjV`.  Pure `Category.assoc`
cocycle collapse; the statement lives over an abstract `[Category C]` and is applied to the concrete
`SheafOfModules ≫` chain by `exact`/`refine` (defeq unification), NEVER by a keyed `rw`/`ext` on a
conjugate-headed goal — this is what confines all seam-crossing. -/
lemma trivialisation_telescope_assemble {C : Type*} [Category C]
    {O0 O1 O2 O3 O4 O5 P0 P1 P2 P3 P4 P5 : C}
    {dU1 : O0 ⟶ O1} {dU2 : O1 ⟶ O2} {dU3 : O2 ⟶ O3} {dU4 : O3 ⟶ O4} {dU5 : O4 ⟶ O5}
    {cV1 : P0 ⟶ P1} {cV2 : P1 ⟶ P2} {cV3 : P2 ⟶ P3} {cV4 : P3 ⟶ P4} {cV5 : P4 ⟶ P5}
    (ρ0 : O0 ≅ P0) (ρ1 : O1 ≅ P1) (ρ2 : O2 ≅ P2) (ρ3 : O3 ≅ P3) (ρ4 : O4 ≅ P4) (ρ5 : O5 ≅ P5)
    (h1 : dU1 = ρ0.hom ≫ cV1 ≫ ρ1.inv)
    (h2 : dU2 = ρ1.hom ≫ cV2 ≫ ρ2.inv)
    (h3 : dU3 = ρ2.hom ≫ cV3 ≫ ρ3.inv)
    (h4 : dU4 = ρ3.hom ≫ cV4 ≫ ρ4.inv)
    (h5 : dU5 = ρ4.hom ≫ cV5 ≫ ρ5.inv) :
    dU1 ≫ dU2 ≫ dU3 ≫ dU4 ≫ dU5
      = ρ0.hom ≫ (cV1 ≫ cV2 ≫ cV3 ≫ cV4 ≫ cV5) ≫ ρ5.inv := by
  subst h1 h2 h3 h4 h5
  simp only [Category.assoc, Iso.inv_hom_id_assoc]

end Modules

end Scheme

end AlgebraicGeometry
