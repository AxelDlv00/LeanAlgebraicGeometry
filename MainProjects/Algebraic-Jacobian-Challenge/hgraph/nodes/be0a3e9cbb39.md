---
author: sync
content_type: lemma
created: '2026-07-27T19:08:27'
decl: chart_smul_baseMap_res
file: AlgebraicJacobian/Picard/RigidPushforwardAffineDescent.lean
generated: lean
lean_status: lean_ok
title: chart_smul_baseMap_res
type: lean
updated: '2026-07-27T19:08:27'
---
   lemma chart_smul_baseMap_res {f' : X' ⟶ Y'} {g' : X' ⟶ X} (M : X.Modules)
       {W W₀ : X.Opens} {W'' : X'.Opens}
       (hWW₀ : W₀ ≤ W) (hW'' : W'' ≤ g' ⁻¹ᵁ W₀) (hle : W'' ≤ g' ⁻¹ᵁ W)
       (b : Γ(Y', ⊤)) (x : Γ(M, W)) :
       (((((Scheme.Modules.pullback g').obj M).presheaf.map (homOfLE hle).op).hom
           ((f'.appLE (⊤ : Y'.Opens) (g' ⁻¹ᵁ W) le_top).hom b •
             pullback_app_isoTensor_baseMap g' M (le_refl (g' ⁻¹ᵁ W)) x)) :
           Γ((Scheme.Modules.pullback g').obj M, W'')) =
         (f'.appLE (⊤ : Y'.Opens) W'' le_top).hom b •
           pullback_app_isoTensor_baseMap g' M hW''
             ((M.presheaf.map (homOfLE hWW₀).op).hom x)
   ```

   Both are the affine-base-change analogues of bricks already proved for fibres; the first is
   Stacks 02KG in degree `0` on a single affine chart, the second its restriction naturality.

4. **Dependency warning.**  This route puts the `baseChange` field *downstream* of the
   `IsIntegral (ℙ¹_k)` leaf of `Picard/RigidPushforwardFrontier.lean`: step 1 consumes the
   engine's **global** surjectivity of the Čech differential `d`, not merely the fibrewise
   `h¹ = 0` hypothesis that the gate carries.  Global surjectivity comes out of
   `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing`, whose `H⁰`-finiteness anchor is exactly
   that leaf.  So the two fields of the gate are not independent along this route.

## Vacuity audit

`RigidPushforwardGammaBaseChange` is of the shape `∃ s, (value of s on simple tensors) ∧
Function.Bijective s`.  This cannot be discharged by choosing a convenient `s`: simple tensors
generate `Γ(Spec A', ⊤) ⊗_{Γ(Spec A, ⊤)} Γ(q_* L, ⊤)` as an abelian group, and `s` is required
to be additive, so the prescribed values on simple tensors determine `s` **uniquely**.  The
existential is therefore a genuine bijectivity assertion about the canonical base-change map,
not an unconstrained choice.

Sources: Stacks 01I8 (quasi-coherent modules on an affine scheme), Stacks 02KG (cohomology and
base change), Mumford, *Abelian Varieties*, II §5; EGA III 7.9.9; Hartshorne III 12.11.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct

namespace AlgebraicGeometry

open Scheme Scheme.Modules

/-! ## §1. Affine-target descent -/

-- The `calc` step identifying `e.hom` with a composite is `rfl` only below reducible
-- transparency, since `Iso.trans`/`asIso`/`Functor.mapIso` must all unfold.
set_option backward.isDefEq.respectTransparency false in