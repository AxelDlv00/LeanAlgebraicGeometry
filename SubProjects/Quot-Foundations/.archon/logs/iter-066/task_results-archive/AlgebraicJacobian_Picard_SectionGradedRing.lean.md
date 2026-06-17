# AlgebraicJacobian/Picard/SectionGradedRing.lean (iter-066, SNAP lane)

## ztensor_whisker_localIso (was L984) + isIso_sheafification_whiskerRight_unit (was L1035)

### Attempt 1 — stalkwise route (blueprint literal)
- **Approach considered:** stalk-of-tensor ≅ tensor-of-stalks via filtered colimits, per the
  blueprint proof sketch.
- **Result:** NOT ATTEMPTED in Lean — requires a module/abelian presheaf stalk-tensor
  commutation theory absent from Mathlib (route (c) of the iter-052 handoff, known blocked).

### Attempt 2 — Mathlib `GrothendieckTopology.W.whiskerRight` via `ModuleCat (ULift ℤ)` — **RESOLVED**
- **Approach:** Mathlib's `Sites/Monoidal.lean` proves exactly "J.W is closed under pointwise
  monoidal whiskering on `Cᵒᵖ ⥤ A`" for `A` braided monoidal closed (Day reflection:
  `GrothendieckTopology.W.whiskerRight`). Two transfers bridge it to the relative-tensor
  statement:
  1. **Universe/category bridge.** `Ab` has no tensor-monoidal structure in the pin, and the
     `ModuleCat` monoidal instance requires ring and modules in the SAME universe. Solution:
     work in `A := ModuleCat.{u} (ULift.{u} ℤ)` (all instances resolve: monoidal closed,
     braided, `HasFunctorEnrichedHom`), and transfer `J.W` across the carrier-preserving
     equivalence `modToAb := restrictScalars (ULift.ringEquiv.symm) ⋙ forget₂ (ModuleCat ℤ) Ab`.
     An equivalence is a left adjoint both ways ⟹ `J.PreservesSheafification` both ways
     (`Sheaf.preservesSheafification_of_adjunction` + `asEquivalence.toAdjunction`); gives the
     iff `W_whiskerRight_modToAb_iff`.
  2. **Relative-vs-ℤ tensor bridge.** The DONE coequalizer presentation
     (`relativeTensorCoequalizerIso`) exhibits `toPresheaf.map (f ▷ R)` as the map induced on
     coequalizer points by the ℤ-whiskered rows `tripWhisker`/`domWhisker`; `presheafToSheaf J Ab`
     preserves colimits, the rows become isos (their `J.W` from step 1), so the induced map is an
     iso (`IsColimit.coconePointsIsoOfNatIso`), i.e. `J.W` via `GrothendieckTopology.W_iff`.
- **Result:** RESOLVED — both sorries closed; `isIso_sheafification_whiskerRight_unit` is a
  one-liner through `isIso_sheafification_map_iff` + `localIso_toPresheaf_map_unit`.

### Key infrastructure added (all `private`, in `section ZTensorWhisker`)
- `toULiftIntLinearMap` — AddMonoidHom → `ULift ℤ`-linear (ULift smul is defeq `c.down • x`).
- `compatibleSMul_int_uliftInt` instance + `uTensorEquiv`/`uTripleEquiv` —
  `M ⊗[ULift ℤ] N ≃ₗ[ℤ] M ⊗[ℤ] N` via `TensorProduct.equivOfCompatibleSMul` (tmul ↦ tmul, rfl).
- `uModPresheaf`/`uModRingPresheaf`/`uModHom` — `ModuleCat (ULift ℤ)`-valued presheaves on the
  `objRestrict` carriers (id/comp laws reuse `objRestrict_id/comp`).
- `modToAb` + `IsEquivalence` instance + `W_whiskerRight_modToAb_iff`.
- `uModForgetIso`, `uDomIso`, `uTripIso` — comparison NatIsos onto `toPresheaf.obj P`,
  `relTensorDomainPresheaf`, `relTensorTriplePresheaf`.
- `domWhisker`/`tripWhisker` (iso-conjugates of the pointwise whiskering), `W_uModHom`,
  `W_domWhisker`, `W_tripWhisker`, and the three squares `actL_domWhisker`/`actR_domWhisker`/
  `proj_domWhisker`.
- New imports: `Sites.PreservesSheafification`, `Sites.Adjunction`,
  `ModuleCat.Monoidal.Closed`, `ModuleCat.Monoidal.Symmetric`, `ModuleCat.ChangeOfRings`,
  `Grp.ZModuleEquivalence`.

### Load-bearing tricks (for future provers in this file)
- **`PreservesSheafification` instance search TIMES OUT** even at 80k heartbeats; supply it
  explicitly via `Sheaf.preservesSheafification_of_adjunction J F.asEquivalence.toAdjunction`
  (and `.symm.toAdjunction` for the inverse direction).
- **`ModuleCat` monoidal = same-universe only** ⟹ `ULift.{u} ℤ`; `ULift.module'` makes every
  AddCommGroup a `ULift ℤ`-module with smul DEFEQ to `c.down • x`.
- **`TensorProduct.equivOfCompatibleSMul`** is the Mathlib-present bridge
  `⊗[ULift ℤ] ≃ ⊗[ℤ]` — both directions are `rfl` on elementary tensors; only the
  `CompatibleSMul ℤ (ULift ℤ)` instance had to be provided (one line, `smul_tmul c.down`).
- **simp/rw CANNOT fire `map_zero`/`map_add`/`ha`/`hb`** on `(AddCommGrpCat.Hom.hom φ) x`
  applications whose element comes from `TensorProduct.induction_on` over a defeq-but-wrapped
  carrier (the `of`-carrier vs tensor-type instance mismatch). Defeq-tolerant TERM forms work:
  `exact (map_zero _).trans (map_zero _).symm`,
  `refine ((map_add _ a b).trans ?_).trans (map_add _ a b).symm; exact congrArg₂ (fun x y => x + y) ha hb`,
  and `congrArg _ (TensorProduct.tmul_zero _ m)` / `(TensorProduct.tmul_add m a b)` for the
  inner cases.
- **Plain `rfl` fails on `hom ((α ≫ β).app U) z` tmul leaves** (functor-category comp blocks
  the whnf path) but each FACTOR's application IS rfl: prove `have t_i : hom (γ.app U) (tmul) =
  <value> := rfl` stepwise and assemble with `congrArg`/`.trans` (all defeq-tolerant). This
  closed all three squares.
- **`whiskerRight_twice` now carries associators** in the pin — avoid; build the equivalence-
  unit arrow-iso directly with `NatIso.ofComponents (fun U => e.unitIso.symm.app (F.obj U))`.
- **Functor whiskering is `Functor.whiskerRight`** (no `CategoryTheory.whiskerRight` alias);
  `set_option ... in` must precede the docstring, not sit between it and the decl.
- `uTripIso` needs `set_option maxHeartbeats 800000 in` (triple-tensor defeq).

### Blueprint
- `lem:snap_ztensor_whisker_localIso` (chapter L716) is stated as a ℤ-tensor statement, but the
  scaffolded (and now proven) Lean decl is the RELATIVE-tensor whiskering statement (which is
  what the crux needs). The chapter prose and the `\uses` of both lemmas should be updated by
  the plan agent to reflect the actual route: Mathlib `W.whiskerRight` over
  `ModuleCat (ULift ℤ)` + `modToAb` transfer + coequalizer descent (NOT stalks). I did not
  touch the chapter (prover write-permissions).
- `sync_leanok` will pick up both decls automatically.

## Summary
- Sorry count: **2 → 0** (file now sorry-free).
- Closed: `ztensor_whisker_localIso`, `isIso_sheafification_whiskerRight_unit` — the SNAP crux.
- Still open in file: none.
- Adjacent sorries: none exist in this file. The downstream `tensorObjAssoc` / `tensorPowAdd`
  (next SNAP steps) are NOT yet scaffolded in this file (per plan, they are iter-067 ramp);
  I did not add new public decls beyond the assigned scope.
- Axiom check: `lean_verify` + real `lake build` run (see below); all helpers are `private`,
  no new public API except the two target lemmas' proofs.

## Why I stopped
`Real progress`: closed both assigned sorries (2 → 0), axiom-clean route through existing
Mathlib machinery (no axioms, no new sorries, ~330 lines of new infrastructure). Stopped after
verifying the full file compiles with a real `lake build` (LSP can hide kernel timeouts).
