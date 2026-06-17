# Blueprint-writer directive — SectionGradedRing objectwise coequalizer + presheaf promotion

Target chapter: `blueprint/src/chapters/Picard_SectionGradedRing.tex`.

## Action
(1) Clear the dag coverage debt for the 22 iter-053 objectwise-coequalizer helpers, and (2) flesh the
presheaf-promotion proof of the existing `lem:relativeTensor_as_coequalizer`
(`AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso`) so the next prover has a rigorous,
formalizable chapter for it and the crux `lem:isIso_sheafification_whiskerRight_unit`.

### A. Objectwise coequalizer coverage block (DONE, axiom-clean)
Add `lem:relativeTensor_objectwise_coequalizer` under `sec:sgr_tensor_powers`, headline \lean pin
`AlgebraicGeometry.Scheme.Modules.RelativeTensorCoequalizer.isColimitCofork`, with a multi-name \lean listing
the load-bearing members (use ONE consolidated block, mirror `lem:gr_glueData_bridges`):
`...RelativeTensorCoequalizer.actN, ...actM, ...actLmap, ...actRmap, ...projL, ...projL_surjective,
...projL_comp_act, ...aL, ...aR, ...piMor, ...piMor_epi, ...coeq_condition, ...cofork, ...descHom,
...descMor, ...descFac, ...isColimitCofork` (the pure-`rfl` `*_tmul`/`*_apply` simp lemmas may be omitted —
note in prose they are private implementation glue).
Statement: for a commutative ring `S` and `S`-modules `M, N`, the abelian group `M ⊗[S] N` is the coequalizer
in `AddCommGrpCat` of the two `S`-action maps `M ⊗[ℤ] (S ⊗[ℤ] N) ⇉ M ⊗[ℤ] N` (left- vs right-action). Proof:
the abelian universal property is `TensorProduct.liftAddHom` (an `S`-balanced `f : M →+ N →+ P` factors
through `M ⊗[S] N`); existence via `descHom`, uniqueness via `cancel_epi (piMor …)` (`piMor` epi by
`ConcreteCategory.epi_of_surjective` + `projL_surjective`); packaged by `Cofork.IsColimit.mk`. \uses: the
Mathlib `TensorProduct.liftAddHom` (add a `\mathlibok` anchor `lem:tensorProduct_liftAddHom_mathlib` →
`\lean{TensorProduct.liftAddHom}` if not already present).

### B. Presheaf promotion — make `lem:relativeTensor_as_coequalizer` formalizable
Rewrite/extend the PROOF of the existing `lem:relativeTensor_as_coequalizer` to the verified route (do NOT
change its statement or \lean pin). Steps, with the prover's verified API:
1. Lift the objectwise `isColimitCofork` to `Cᵒᵖ ⥤ AddCommGrpCat` via
   `CategoryTheory.Limits.evaluationJointlyReflectsColimits` (colimits in a functor category are objectwise).
   The `actN`/`actM`/`projL` families must be promoted to NATURAL transformations of `Cᵒᵖ ⥤ AddCommGrpCat`
   (naturality = restriction-compatibility of the module action). Add a `\mathlibok` anchor
   `lem:evaluationJointlyReflectsColimits_mathlib` →
   `\lean{CategoryTheory.Limits.evaluationJointlyReflectsColimits}`.
2. Identify the apex presheaf `U ↦ P(U) ⊗_{R₀(U)} Q(U)` with `(toPresheaf R₀).obj (P ⊗_p Q)` using
   `PresheafOfModules.Monoidal.tensorObj_obj` (`(tensorObj M₁ M₂).obj X = M₁.obj X ⊗ M₂.obj X`). Add a
   `\mathlibok` anchor `lem:presheaf_tensorObj_obj_mathlib` →
   `\lean{PresheafOfModules.Monoidal.tensorObj_obj}`. This yields `relativeTensorCoequalizerIso`.
3. Note the lone risk to verify in prose: which monoidal structure `GrothendieckTopology.W.monoidal`
   (`Sites/Monoidal.lean`) puts on the ℤ-tensor presheaf `P ⊗_ℤ Q`, and that its objectwise value is
   `U ↦ P(U) ⊗_ℤ Q(U)`.

### C. Crux \uses wiring
Update `lem:isIso_sheafification_whiskerRight_unit`'s proof `\uses{}` to include
`lem:relativeTensor_as_coequalizer` (+ `lem:relativeTensor_objectwise_coequalizer`) and the already-built
`lem:localIso_toPresheaf_map_unit` / `lem:isIso_sheafification_map_iff`. The crux argument (already in prose):
`toPresheaf.map (η_P ▷ Q)` is the induced map of coequalizers from whiskering the rows by `η_P ⊗_ℤ (-)`;
abelian sheafification `a` (left adjoint) preserves the coequalizer; `GrothendieckTopology.W` inverts the
ℤ-whiskered rows (`W.monoidal` + `η_P ∈ J.W`); so the map ∈ `J.W` and `(isIso_sheafification_map_iff _).mpr`
closes it.

## Constraints
- Do NOT add `\leanok` (sync_leanok owns it). `\mathlibok` ONLY on the genuine Mathlib anchors named above
  (B.1, B.2, A). No Lean tactic strings in proofs.
- Stay within route (a) (coequalizer/Analogue 1). Do NOT introduce route (b) Day's-closed or (c) stalkwise
  (both need absent Mathlib infra — do-not-pursue).
- `references/**` is in your write-domain as a fallback only; you likely need no new source.
