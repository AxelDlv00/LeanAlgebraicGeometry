# AlgebraicJacobian/Picard/SectionGradedRing.lean

## Summary
- **Declarations added (1, axiom-clean):** `relTensorDomainPresheaf` (the objectwise `ℤ`-tensor
  presheaf `U ↦ Γ(U,P) ⊗_ℤ Γ(U,Q)` as a functor `(Opens X)ᵒᵖ ⥤ Ab`, with restriction maps the
  `ℤ`-tensors of the underlying restriction maps). This is the verified **Step-1 brick** of the
  presheaf promotion `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`).
- **Hygiene:** fixed the two unused-section-var warnings on `actRmap_tmul` / `actLmap_tmul`
  via `omit [Module S M] in` / `omit [Module S N] in`. File now compiles **warning-free**.
- **Declarations blocked (0 added):** the triple-tensor presheaf `T = Γ(-,P) ⊗_ℤ R₀ ⊗_ℤ Γ(-,Q)`,
  the action/projection natural transformations, the colimit lift, the apex identification, and
  the crux `isIso_sheafification_whiskerRight_unit` — NOT added (no `sorry`); see friction below.
- **sorry count:** 0 → 0 (file stays 0-sorry).
- **Module build:** `lake build AlgebraicJacobian.Picard.SectionGradedRing` ✔ green (2436 jobs).

## KEY UNBLOCKING DISCOVERY — the CommRing routing for the apex (was the central unknown)

The promotion was previously feared blocked because `CommRing ↑(X.ringCatSheaf.obj.obj U)` is
**NOT** synthesizable (the structure sheaf at the `RingCat` level only carries `Ring`). RESOLVED:
`Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean` (L31) declares

```
instance (X : Cᵒᵖ) : CommRing ((R ⋙ forget₂ _ RingCat).obj X) := inferInstanceAs (CommRing (R.obj X))
```

for `R : Cᵒᵖ ⥤ CommRingCat`. So **phrase the apex with the `R ⋙ forget₂` form**, i.e. with
`R := X.sheaf.obj` and `R₀ := R ⋙ forget₂ CommRingCat RingCat` — which is exactly the file-local
`MonoidalPresheaf X` carrier. In that phrasing `CommRing (R₀.obj U)` fires, and the apex tensor
`(PresheafOfModules.Monoidal.tensorObj P Q).obj U = P.obj U ⊗[R₀.obj U] Q.obj U`
(`tensorObj_obj`) uses **this same** `CommRing`, so the objectwise `RelativeTensorCoequalizer.cofork`
instantiated at `S := R₀.obj U` matches the apex with no instance diamond.
**Do NOT** hand-roll a competing `inferInstanceAs (CommRing ↑(X.sheaf.obj.obj U))` instance on the
`ringCatSheaf` carrier — that creates a Module-instance diamond (`Module ↑S ↑(P.obj U)` then fails
to synthesize). Use the `R ⋙ forget₂` spelling throughout and let Mathlib's instance fire.

## relTensorDomainPresheaf (added, axiom-clean)
- **Approach:** functor with `obj U := AddCommGrpCat.of (P.obj U ⊗[ℤ] Q.obj U)`,
  `map f := AddCommGrpCat.ofHom (TensorProduct.map (P.presheaf.map f).hom.toIntLinearMap
  (Q.presheaf.map f).hom.toIntLinearMap).toAddMonoidHom`; functor laws by `TensorProduct.induction_on`
  with `| tmul => simp; rfl`. Needs `open scoped TensorProduct` (the `⊗[ℤ]` notation is NOT in scope
  at the file's top-level — it was only `open`ed inside the `RelativeTensorCoequalizer` namespace).
- **Result:** RESOLVED — `#print axioms` = `{propext, Classical.choice, Quot.sound}`.

## Triple-tensor presheaf `T` (NOT added — heartbeat wall)
- **Approach 1 (element induction):** same shape as `relTensorDomainPresheaf` but
  `obj U := AddCommGrpCat.of (P.obj U ⊗[ℤ] ((X.ringCatSheaf.obj.obj U) ⊗[ℤ] Q.obj U))`, restriction
  `TensorProduct.map P(f) (TensorProduct.map R₀(f).toAddMonoidHom.toIntLinearMap Q(f))`. The nested
  triple tensor makes the per-element `tmul => simp; rfl` closing step hit a **200k-heartbeat `whnf`
  timeout**, and the outer `| zero => simp` did not close (`(map …).toAddMonoidHom 0 = AddMonoidHom.id … 0`).
- **Approach 2 (linear-map-equality, `LinearMap.toAddMonoidHom_injective` + `map_id`/`map_comp`):**
  metavar stuck — `Module ?m ?m` (the injectivity lemma's motive is under-determined before the rw).
- **Next step:** budget `set_option maxHeartbeats 800000 in` AND avoid the `; rfl` whnf blow-up — close
  the `tmul` cases with `tensorObj_map_tmul`-style explicit `simp only [...]` lemma lists (not bare
  `simp; rfl`), OR build `T` as `relTensorDomainPresheaf` of `(P) ⊗ (R₀-as-module ⊗ Q)` re-using the
  Step-1 functor twice rather than a hand-rolled triple. Mirror the OPAQUE-immersion discipline from
  memory `quot-gap1-closed-opaque-immersion`: keep the restriction maps from being whnf-unfolded.

## Full remaining recipe for `relativeTensorCoequalizerIso` + the crux (verified ingredients)
All ingredients below were verified to EXIST in the pin during this session:
1. **`T` presheaf** (above) — the only piece with real perf friction.
2. **Three natural transformations** `aLnat, aRnat : T ⟶ relTensorDomainPresheaf P Q` and
   `piNat : relTensorDomainPresheaf P Q ⟶ (toPresheaf X).obj (tensorObj P Q)` whose components at `U`
   are `RelativeTensorCoequalizer.{aL,aR,piMor} (R₀.obj U) (P.obj U) (Q.obj U)`. Naturality:
   - `piNat` square = `PresheafOfModules.Monoidal.tensorObj_map_tmul` (proven in Monoidal.lean,
     `m⊗n ↦ P(f)m ⊗ Q(f)n`) + `projL_tmul`. NO semilinearity needed for `piNat`.
   - `aLnat`/`aRnat` squares = the **semilinearity** `P.map_smul` / `Q.map_smul` (`M.map f (s•m) =
     R₀(f)s • M.map f m`), exactly the property `tensorObjMap` is built from in Monoidal.lean.
3. **Colimit lift:** `CategoryTheory.Limits.evaluationJointlyReflectsColimits` (verified present;
   also `PresheafOfModules.evaluationJointlyReflectsColimits`) lifts the objectwise
   `RelativeTensorCoequalizer.isColimitCofork` (DONE) to a colimit of the presheaf cofork
   `aLnat, aRnat ⇒ relTensorDomainPresheaf P Q → (toPresheaf).obj (tensorObj P Q)`.
4. **Apex iso** `relativeTensorCoequalizerIso : (presheaf coequalizer) ≅ (toPresheaf).obj (P ⊗_p Q)` —
   immediate once the apex of the cofork IS taken to be `(toPresheaf).obj (tensorObj P Q)`
   (objectwise `tensorObj_obj`).
5. **Crux `isIso_sheafification_whiskerRight_unit`:** with the iso, `toPresheaf.map (η_P ▷ Q)` is the
   coequalizer map induced by whiskering the two rows by `η_P ⊗_ℤ (-)`. Abelian sheafification
   `presheafToSheaf J Ab` (left adjoint) preserves the coequalizer; the two ℤ-whiskered rows are
   inverted by it (each is `η_P ⊗_ℤ id`, and `η_P ∈ J.W` via the DONE `localIso_toPresheaf_map_unit`);
   hence the induced map ∈ `J.W`, and `(isIso_sheafification_map_iff _).mpr` closes it (DONE reduction).
   NOTE: the ℤ-whiskered-row inversion is the one step still needing care — `GrothendieckTopology.W.monoidal`
   is for the **Day-convolution** monoidal structure on `Cᵒᵖ ⥤ Ab`, NOT the pointwise ℤ-tensor here, so
   it does NOT apply directly. The clean substitute on a topological space: `η_P ⊗_ℤ id` is a **stalkwise
   iso** (abelian presheaf stalks `TopCat.Presheaf.stalk` DO exist — distinct from the absent module-sheaf
   stalks), and stalkwise iso ⟹ inverted by abelian sheafification. This stalk bridge is the last
   genuinely-new sub-brick; budget it explicitly next iter.

## Why I stopped
- **Real progress:** 1 axiom-clean declaration — `relTensorDomainPresheaf` (line ~448), the Step-1
  domain functor — plus the **CommRing-routing discovery** that de-risks the entire promotion (was the
  central unknown), plus warning-cleanup. File 0-sorry, module green.
- **Partial progress / precise blocker:** the next brick `T` (triple-tensor presheaf) hit a genuine
  **200k-heartbeat `whnf` timeout** on the naive element-induction functor laws (a perf wall, not a
  math gap). The construction is FEASIBLE (CommRing routing solved, all categorical ingredients verified
  present) but is a multi-step ~150-line build with pervasive ModuleCat/AddMonoidHom coercion + heartbeat
  friction at every step — not completable in one iter at this budget.
- **Not a Mathlib-absence block:** unlike the prior handoff's worry, nothing here is missing from the
  pin except the final stalkwise-iso bridge (step 5 note), for which abelian presheaf stalks exist.
- **Escalation flag (per planner fallback):** the promotion is constructible but heavy; recommend the
  planner either (a) give this lane a dedicated multi-iter budget with `maxHeartbeats` headroom and the
  recipe above, or (b) split it into 2–3 sub-objectives (T-presheaf; nat-transes+lift+iso; crux+stalk-bridge).

## Needs blueprint entry
- **`relTensorDomainPresheaf`** (`AlgebraicJacobian/Picard/SectionGradedRing.lean`) — new non-private
  `def`, currently a `lean_aux` node with no blueprint block. It is the objectwise `ℤ`-tensor presheaf
  `U ↦ Γ(U,P) ⊗_ℤ Γ(U,Q)`; its proof relies only on `TensorProduct.map` functoriality
  (`TensorProduct.map_id`/`map_comp` morally; closed by `induction_on`). Suggested label:
  add as an ingredient of `lem:relativeTensor_as_coequalizer` (`def:relTensorDomainPresheaf`), the
  Step-1 domain presheaf of the presheaf-promoted coequalizer.
