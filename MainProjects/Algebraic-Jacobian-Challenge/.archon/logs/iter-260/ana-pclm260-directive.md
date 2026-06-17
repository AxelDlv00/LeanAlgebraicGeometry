# Mathlib-analogist directive — `pushforwardComp_lax_μ` (iter-260)

## Mode: api-alignment

## Context
This is the lone genuine residual of the D3′ lane (`pullbackTensorMap_restrict` /
blueprint `lem:pullback_tensor_map_basechange`). The surrounding mate calculus
(`pullbackComp_δ`) is already PROVEN; only this `ModuleCat` change-of-rings coherence
remains. A prior analogist recipe (`analogies/d3sq2b258.md`) predicted this residual
would close by `rfl` / short `ext` — that prediction was **empirically refuted** by the
iter-259 prover (`rfl`, `ext W x; rfl`, `ext W x; simp`, `dsimp [...]; rfl` all fail).
I need the genuine Mathlib idiom for this coherence so the next prover dispatch has a
concrete route rather than another guess.

## The declaration (current Lean, `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` ~L2143)
```
private lemma pushforwardComp_lax_μ
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶ F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶ G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint]
    [(PresheafOfModules.pushforward ψ).IsRightAdjoint]
    (X Y : PresheafOfModules (T₀ ⋙ forget₂ CommRingCat RingCat)) :
    Functor.LaxMonoidal.μ (PresheafOfModules.pushforward ψ ⋙ PresheafOfModules.pushforward φ) X Y
      = Functor.LaxMonoidal.μ
          (PresheafOfModules.pushforward (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
            (φ ≫ F.op.whiskerLeft ψ)) X Y
```
Informally: **"`PresheafOfModules.pushforward` is monoidal across composition"** — the lax
tensorator μ of the composite `pushforward ψ ⋙ pushforward φ` equals the μ of the single
`pushforward` along the composite ring map. The project's lax-monoidal structure on
`PresheafOfModules.pushforward` is `presheafPushforwardLaxMonoidal` (an instance in the
same file, L1124), built from the right adjoint of `PresheafOfModules.pullback` /
`leftAdjointOplaxMonoidal`. Sectionwise (`ext W x`) the goal reduces to a
`ModuleCat.restrictScalars` / `ModuleCat.extendScalars` base-change associativity statement
for the composite ring hom `(ψ ∘ φ)` versus the two-step composite.

## Questions for you (api-alignment)
1. **Does Mathlib already have this coherence**, in any of these forms?
   - A `restrictScalars` / `extendScalars` "comp" associativity that directly gives the μ
     equality (candidates the prover named: `ModuleCat.restrictScalarsComp`,
     `ModuleCat.extendScalarsComp`, `ModuleCat.homEquiv_extendScalarsComp` — confirm these
     exist with the right signatures and say how they compose to the goal).
   - A general "a composite of (op)lax-monoidal adjoints is (op)lax-monoidal with the
     evident comparison" lemma at the `Functor.LaxMonoidal` / `Adjunction` level
     (e.g. anything analogous to `CategoryTheory.Adjunction.isMonoidal_comp`,
     `Functor.LaxMonoidal.comp`, `OplaxMonoidal` mate transport) that would make this μ
     equality hold structurally rather than by a sectionwise ModuleCat computation.
   - A `PresheafOfModules.pushforward` / `restrictScalars` monoidal-functor instance in
     Mathlib that already proves pushforward is (lax) monoidal and respects composition.
2. **What is the canonical Mathlib PROOF SHAPE** for this — is it (a) a structural
   adjunction-mate/`isMonoidal_comp`-style argument that avoids the sectionwise descent,
   or (b) genuinely a sectionwise `ModuleCat` change-of-rings calculation? If (b), give the
   precise chain of `ModuleCat` lemmas (`restrictScalarsComp` / `extendScalarsComp` /
   `homEquiv_extendScalarsComp` / `extendRestrictScalarsAdj`) and the order to apply them.
3. **Is the `pushforwardComp = Iso.refl` fact** (the project proves `PresheafOfModules.pushforwardComp`
   is `Iso.refl`) enough to make the μ equality reduce to a naturality/`map_comp` of μ — i.e.
   is the residual actually a consequence of `Functor.LaxMonoidal.μ_natural` + the comp-iso
   being the identity, rather than a fresh ModuleCat build?
4. If Mathlib does NOT have it, give the **most economical project-local construction**
   (target ≤ ~150 LOC) and flag whether it should be built upstream of
   `TensorObjSubstrate.lean` (its own file) so it can be consumed without a circular import
   — note that `presheafPushforwardLaxMonoidal` currently lives INSIDE
   `TensorObjSubstrate.lean`.

## Deliverable
Write `analogies/pushforwardcomp-lax-mu260.md` with: the Mathlib citation(s) (or a clear
"absent"), the canonical proof shape, the exact lemma chain, and a concrete recipe the next
D3′ prover can follow. This is the CHURNING corrective for Route 2 — the next D3′ dispatch
will not happen without it.
