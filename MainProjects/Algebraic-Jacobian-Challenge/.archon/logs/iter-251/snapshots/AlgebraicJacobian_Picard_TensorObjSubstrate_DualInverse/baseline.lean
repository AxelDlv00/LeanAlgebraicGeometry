/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom

/-!
# Dual-inverse parallel lane (A.1.c.SubT §Dual, iter-251)

This file holds the three sorry-body stubs for the **dual-inverse chain** that feeds
`exists_tensorObj_inverse` in `TensorObjSubstrate.lean`:

1. `dual_restrict_iso` — restriction along an open immersion commutes with the sheaf-level
   dual (blueprint `lem:dual_restrict_iso`; the C-bridge).
2. `dual_isLocallyTrivial` — the dual of a locally-trivial module is locally trivial
   (blueprint `lem:dual_isLocallyTrivial`).
3. `homOfLocalCompat` — a compatible family of local `𝒪_X`-module morphisms over an open
   cover glues to a unique global morphism (blueprint `lem:sheafofmodules_hom_of_local_compat`;
   the A-bridge).

All three bodies are `sorry`; no proofs are present.  The prover lane for this file works
**in parallel** with the D1′/D3′/D4′ lane in `TensorObjSubstrate.lean`.

Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## §A. The C-bridge: restriction commutes with the sheaf-level dual -/

/-- **Restriction along an open immersion commutes with the sheaf-level dual (C-bridge).**

Blueprint `lem:dual_restrict_iso` (§`sec:tensorobj_dual_bridge`).  For an open immersion
`f : Y ⟶ X` and `M : X.Modules`, there is a canonical isomorphism of `𝒪_Y`-modules
```
  (dual M).restrict f  ≅  dual (M.restrict f)
```
natural in `M`, between the restriction of the sheaf-level dual and the dual of the
restriction.

/- Planner strategy:
   Blueprint label: lem:dual_restrict_iso (~L5374).

   Proof-sketch (blueprint §5.4):
   The proof runs at the PRESHEAF-OF-MODULES level (Step 3 of the tensorObj_restrict_iso
   H1∘H2 recipe already strips the outer sheafification).  Three ingredients:

   (a) Per-V slice equivalence: for each V ≤ U (= image of f), the opens functor
       `f.opensFunctor` is fully faithful with image = {W ≤ U}, so
       `Over_Y V ≃ Over_X (f.opensFunctor V)`.  This is the per-open shadow of
       `TopologicalSpace.Opens.overEquivalence` (CLOSED in Vestigial.lean via
       `overSliceSheafEquiv`).

   (b) Agreement of codomain: the structure sheaf of Y agrees with that of X under (a).

   (c) Ring-iso transport of module structure:
       `lem:restrictscalars_ringiso_dualequiv` (CLOSED in PresheafInternalHom.lean as
       `restrictScalarsRingIsoDualEquiv`):
         `RingEquiv e → Dual(restrictScalars e.toRingHom A) ≃ restrictScalars e.toRingHom (Dual A)`
       applies sectionwise at each V to transport the `𝒪_X(fV)`-module structure on
       `(dual M)|_f(V)` to the `𝒪_Y(V)`-module structure via the ring iso
       `β_V = (f.appIso V).inv : 𝒪_X(fV) ≅ 𝒪_Y(V)`.

   High-level recipe (mirrors tensorObj_restrict_iso Steps 1–4 with `dual` in place of `⊗`):
   Step 1: `(Scheme.Modules.restrictFunctorIsoPullback f).app (dual M)` — reduce `restrict`
           to abstract pullback.
   Step 2: `SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom` — move pullback
           inside sheafification.
   Step 3: strip the outer sheafification via `(sheafification …).mapIso`.
   Step 4 (the genuine new build):  close the residual presheaf goal
             `pushforward β (PresheafOfModules.dual M.val)
                 ≅ PresheafOfModules.dual ((pushforward β).obj M.val)`
           The ROUTE: sectionwise, at each V ≤ U, the value of the LHS is
           `Hom_{Over_X(fV)}(restr(fV) M.val, restr(fV) 𝟙_X)` and the value of the RHS is
           `Hom_{Over_Y V}(restr V (pushforward β M.val), restr V 𝟙_Y)`.
           The slice equivalence (a) identifies these indexing categories; the agreement (b)
           identifies the codomain `𝟙`; the ring-iso transport (c) via
           `restrictScalarsRingIsoDualEquiv` reconciles the module structures.
           Naturality in V is automatic on the thin poset `Opens X` by `Subsingleton.elim`.

   ⚠ WARM-CONTEXT WARNING (progress-critic pc251):
   The residual presheaf goal (Step 4) is a GENUINE NEW BUILD — NOT covered by
   `overSliceSheafEquiv` (outcome (ii) of the iter-230 C-wiring diagnostic, confirmed by
   live `change`):
     • `overSliceSheafEquiv` is a `Sheaf`-category equivalence; the residual (after Step 3)
       is a `PresheafOfModules`-level iso (different categories).
     • `overSliceSheafEquiv` has a fixed value category `A`; the dual's per-V value uses the
       VARYING ring `𝒪_Y(V)` — a fixed-value-cat site equivalence does NOT transport the
       varying module structure for free.
     • The per-V slice comparison is over a FINER slicing (single open V) than the whole-U
       slice site `(gt X).over U` the root is built over.
   If the sectionwise ring-iso build resists, consult:
     (i)  the iter-230 C-wiring diagnostic in TensorObjSubstrate.lean (~L613–656) for the
          precise decomposition of the missing presheaf+module ingredient;
     (ii) a targeted mathlib-analogist query on the "dual of pushforward along a ring iso"
          pattern (do NOT thrash — this is a genuine new build, not a missing import).

   Named CLOSED base lemmas this stub consumes:
   - `PresheafOfModules.dual` (PresheafInternalHom.lean) — presheaf-level dual.
   - `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207) — sheaf-level dual.
   - `InternalHom.restrictScalarsRingIsoDualEquiv` (PresheafInternalHom.lean ~L234) — the
     ring-iso / dual commutation at the `ModuleCat` level.
   - `Scheme.Modules.restrictFunctorIsoPullback` (Mathlib) — Step 1 iso.
   - `SheafOfModules.sheafificationCompPullback` (Mathlib) — Step 2 iso.
   - `PresheafOfModules.pushforwardPushforwardAdj` (PresheafInternalHom.lean) — H1.
   - `PresheafOfModules.restrictScalarsMonoidalOfBijective` (PresheafInternalHom.lean) — H2
     (not directly needed for `dual`, but the same `β`-bijectivity is used).
-/
-/
noncomputable def dual_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    (dual M).restrict f ≅ dual (M.restrict f) :=
  sorry

/-! ## §B. Local triviality of the dual -/

/-- **The dual of a locally-trivial `𝒪_X`-module is locally trivial.**

Blueprint `lem:dual_isLocallyTrivial` (~L5472).  If `L : X.Modules` satisfies
`LineBundle.IsLocallyTrivial L`, then `dual L` is also locally trivial.

/- Planner strategy:
   Blueprint label: lem:dual_isLocallyTrivial (~L5472).
   Uses (all CLOSED):
     lem:internal_hom_isSheaf  → `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207)
     lem:dual_restrict_iso     → `dual_restrict_iso` (this file, §A above — STUB)
     def:scheme_modules_dual_iso_of_iso → `Scheme.Modules.dualIsoOfIso`
                                          (TensorObjSubstrate.lean ~L218)
     lem:restrictscalars_ringiso_dualequiv → `restrictScalarsRingIsoDualEquiv`
                                             (PresheafInternalHom.lean ~L234)

   Proof-sketch (blueprint §5.4, three-step chain):
   Unpack `hL : LineBundle.IsLocallyTrivial L`:  for each `x : X` choose an affine open
   `U` with `x ∈ U`, `IsAffineOpen U`, and `eL : L.restrict U.ι ≅ SheafOfModules.unit _`.
   It suffices to exhibit `(dual L).restrict U.ι ≅ SheafOfModules.unit _`.
   The three-step chain (blueprint §5.4):

   Step 1 — `dual_restrict_iso U.ι L`:
     `(dual L).restrict U.ι  ≅  dual (L.restrict U.ι)`

   Step 2 — `dualIsoOfIso eL` (contravariant):
     `dual (L.restrict U.ι)  ≅  dual (SheafOfModules.unit (U : Scheme).ringCatSheaf)`

   Step 3 — `dual_unit_iso` (the dual of the unit is the unit):
     `dual (SheafOfModules.unit _)  ≅  SheafOfModules.unit _`
     The dual of `𝒪_U` is `ℋom(𝒪_U, 𝒪_U) ≅ 𝒪_U` via evaluation-at-1; this should be
     derivable from `InternalHom.internalHomEval` (PresheafInternalHom.lean) + the
     presheaf-level left unitor `λ_ (𝟙_)`.

   Composing Steps 1–3 gives the trivialisation of `(dual L)|_U`.
   Since x was arbitrary, `dual L` is locally trivial.

   Implementation note: the pattern is identical to `tensorObj_isLocallyTrivial`
   (TensorObjSubstrate.lean ~L526), with `dual_restrict_iso` playing the role of
   `tensorObj_restrict_iso` and `dualIsoOfIso` the role of `tensorObjIsoOfIso`.
   Use `intro x; obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x` to unpack, then
   `exact ⟨U, hxU, hU_aff, ⟨dual_restrict_iso U.ι L ≪≫ dualIsoOfIso eL ≪≫ dual_unit_iso⟩⟩`.
   The `dual_unit_iso` is a missing sub-lemma; the prover may need to build it inline or
   as a separate declaration (it is a small sorry if needed, NOT blocked).

   Named CLOSED base lemmas:
   - `Scheme.Modules.dualIsoOfIso` (TensorObjSubstrate.lean ~L218).
   - `dual_restrict_iso` (this file §A — must be proved first).
   - `SheafOfModules.unit` (Mathlib).
   - `InternalHom.internalHomEval` (PresheafInternalHom.lean) — for `dual_unit_iso`.
-/
-/
lemma dual_isLocallyTrivial {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    LineBundle.IsLocallyTrivial (dual L) :=
  sorry

/-! ## §C. The A-bridge: compatible local morphisms glue to a global morphism -/

/-- **A-bridge: compatible local `𝒪_X`-module morphisms glue to a global morphism.**

Blueprint `lem:sheafofmodules_hom_of_local_compat` (~L5592).  Let `X` be a scheme,
`M N : X.Modules`, and `{U i}` an indexed open cover of `X`.  If for each `i` we have a
morphism `f i : M.restrict (U i).ι ⟶ N.restrict (U i).ι` in `Scheme.Modules (U i)` such
that for all `i j` the restrictions of `f i` and `f j` to `U i ⊓ U j` are equal (as
morphisms in `Scheme.Modules (U i ⊓ U j)`, compared via `HEq` since the double-restriction
routes give propositionally but not definitionally equal source/target objects), then there
is a unique global morphism `M ⟶ N` in `X.Modules` whose restriction to each `U i` is `f i`.

The compatibility hypothesis `hf` uses `HEq` (heterogeneous equality) to compare the two
restricted morphisms: the LHS `(restrictFunctor (resLE i)).map (f i)` has source
`(M.restrict (U i).ι).restrict (resLE i)` and the RHS has source
`(M.restrict (U j).ι).restrict (resLE j)`, which are propositionally equal (both equal
`M.restrict (U i ⊓ U j).ι` via `restrictFunctorComp`+`restrictFunctorCongr`) but not
definitionally equal.  The prover should establish `HEq` by first proving the types equal
via `congr`+`restrictFunctorComp`, then `heq_of_eq`.

/- Planner strategy:
   Blueprint label: lem:sheafofmodules_hom_of_local_compat (~L5592).
   Uses (all CLOSED):
     def:scheme_modules_homMk → `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598)
     lem:open_immersion_slice_sheaf_equiv → `Vestigial.overSliceSheafEquiv`
                                            (TensorObjSubstrate/Vestigial.lean ~L715)

   Proof-sketch (blueprint §5.4, two-step):

   Step (i) — Glue the underlying ab-sheaf morphism:
   Forget M, N to their underlying sheaves of abelian groups.  The presheaf
   `H(W) = Hom_{Ab-preshvs}(M.val.presheaf|_W, N.val.presheaf|_W)` is a sheaf of TYPES:
   this is `Presheaf.IsSheaf.hom` (Mathlib), consuming the sheaf condition of N.
   Convert each `f i` to a local section `s i ∈ H(U i)` via the open-immersion slice
   transport `overSliceSheafEquiv` (Vestigial.lean):
     - `s i` at a pair `(V, h : V ≤ U i)` is `(f i).val.app` at the corresponding open of
       `(U i : Scheme)`, conjugated by `eqToHom` identifications from the down-set identity
       `ι_i(ι_i⁻¹(V)) = V` for `V ≤ U i`.  The naturality of `s i` in V is the
       section-direction slice of `overSliceSheafEquiv` and is automatic on the thin poset
       `Opens X` by `Subsingleton.elim`.
   Apply `TopCat.Sheaf.existsUnique_gluing` (or `Presheaf.IsSheaf.existsUnique_gluing`) to
   amalgamate the compatible family `(s i)_i` into a unique global section
   `s ∈ H(⊤) = (M.val.presheaf ⟶ N.val.presheaf)`.
   Convert the amalgamated `s` to an ab-presheaf morphism `g : M.val.presheaf ⟶ N.val.presheaf`
   via `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv`.

   Step (ii) — Promote to `𝒪_X`-linear via `homMk`:
   The linearity `g(r • m) = r • g(m)` holds on each `U i` (since `g|_{U i}` comes from
   the module morphism `f i`), and the two sides agree globally because the ambient presheaf
   is separated.  Apply `Scheme.Modules.homMk g (sectionwise-linearity proof)` to produce
   `M ⟶ N` in `X.Modules`.

   Key sub-lemma to build first (most fragile piece):
   The naturality field of `s i` — that the `eqToHom`-conjugated components of `f i` commute
   across morphisms of the slice `Over (U i)` — is dominated by `overSliceSheafEquiv` and
   should be extracted as a standalone axiom-clean lemma before the full gluing assembly.

   Named CLOSED base lemmas:
   - `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598).
   - `Vestigial.overSliceSheafEquiv` (TensorObjSubstrate/Vestigial.lean ~L715).
   - `TopCat.Presheaf.IsSheaf.hom` (Mathlib) — hom into a sheaf is a sheaf.
   - `TopCat.Sheaf.existsUnique_gluing` (Mathlib) — gluing of compatible sections.
   - `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` (Mathlib) — top-section ↔ morphism.

   Implementation note: this is a MULTI-PIECE BUILD dominated by the `s i` naturality field.
   Build `s i` (and its naturality) as a standalone verified lemma FIRST, before assembling
   the full gluing.  The step does NOT invoke any tensor stalk — it is purely about gluing
   morphisms of sheaves.
-/
-/
noncomputable def homOfLocalCompat {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} (U : ι → X.Opens) (hU : ∀ x : X, ∃ i, x ∈ U i)
    (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι)
    (hf : ∀ i j,
        HEq ((Scheme.Modules.pullback
                (Scheme.Hom.resLE (𝟙 X) (U i) (U i ⊓ U j) inf_le_left)).map (f i))
            ((Scheme.Modules.pullback
                (Scheme.Hom.resLE (𝟙 X) (U j) (U i ⊓ U j) inf_le_right)).map (f j))) :
    M ⟶ N :=
  sorry

end Modules

end Scheme

end AlgebraicGeometry
