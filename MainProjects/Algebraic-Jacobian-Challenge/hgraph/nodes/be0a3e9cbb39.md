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
updated: '2026-07-27T19:58:33'
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
   that leaf.  So the two fields of the gate are not independent along this route.  (That leaf
   is now proved — `Adelic.instIsIntegralP1OverLeft`, `Picard/RigidPushforwardInstance.lean` —
   so the dependency is discharged, not blocking.)

## Four corrections to that route, from an adversarial re-check

The route above survived an independent verification of §1–§4, but four of its *unproved*
steps were found to be booked at less than they cost.  Recorded so the next session does not
rediscover them:

1. **Take the engine's fourth conjunct directly; do not re-derive it.**  Step 1 above proposes
   feeding global surjectivity of `d` to `bijective_kerBaseChange_of_surjective`
   (`Picard/TwoTermFiniteFree.lean`:392), which then also demands
   `Module.Flat Γ(Spec A, ⊤) Γ(M, U₁ ⊓ U₂)`.  That is unnecessary: the fourth conjunct of
   `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral`
   (`Picard/RigidPushforwardP1Constants.lean`:540-544) is already
   `∀ B, Function.Bijective (TwoTerm.kerBaseChange (…) B)` for *every*
   `Γ(Spec A, ⊤)`-algebra `B`; instantiate `B := Γ(Spec A', ⊤)`.  This deletes the flatness
   obligation entirely, so the intended `Γ`-level statement should take
   `hker : ∀ B …, Function.Bijective (kerBaseChange (𝒰.moduleSectionDiffBase f M) B)` rather
   than a flatness-plus-surjectivity pair.

2. **Get the `letI` binder list right, and elaborate the statement before writing any proof.**
   A `Module Γ(Y, ⊤) Γ(M, ·)` instance exists only through `letI := f.baseSectionsModule M ·`,
   so every hypothesis mentioning `Γ(M, ·)` as a `Γ(Y, ⊤)`-module needs one — *in addition to*
   the `Algebra Γ(Y, ⊤) Γ(Y', ⊤)` binder, which is never replaced.  How many depends on the
   statement, so copy from the closest existing one rather than guessing:
   `surjective_moduleSectionDiffBase_baseChange_residueField`
   (`Picard/RigidPushforwardFiberChart.lean`:508-518) is about the whole Čech complex and
   carries the `Algebra` binder plus **three** `baseSectionsModule` binders (`U₁`, `U₂`,
   `U₁ ⊓ U₂` — there is no `⊤` binder); a statement about a *single* chart needs the `Algebra`
   binder plus **one**, at that chart; and the kernel comparison
   `exists_kerChartTensorEquiv` (`Picard/RigidPushforwardChartBaseChange.lean`) needs **seven**
   — the `Algebra` binder, three on `X`, three on `X'`.  (An earlier draft of this paragraph
   said "four binders, not the `Algebra` binder", which describes none of them; corrected after
   a fresh-context review checked it against the source, and the counts above are measured.)
   Two traps found while writing the seven-binder version: instance search does **not** see
   `g' ⁻¹ᵁ 𝒰.U₁` as `(𝒰.preimage g').U₁`, so the target-side binders must be spelled with
   `(𝒰.preimage g').Uᵢ`; and after `TensorProduct.induction_on` a goal that is syntactically
   `X = X` may still need an explicit `rfl`, because the two sides carry different-but-defeq
   module instances from the `letI` dictionary.  Either way: write the statement with a
   placeholder body and get it to elaborate first — that is where the time goes.

3. **The glue to §3 is not free.**  §3's map lives on the tensor product formed with the
   *native* pushforward module structure (that is what
   `pullback_app_isoTensor_baseMap_sectionLinearEquiv` returns), while the Čech statement
   delivers the `baseSectionsModule` structure.  The tree proves these are only
   propositionally equal: `Scheme.Modules.pushforwardTopEquivBaseSections`
   (`Picard/RigidPushforwardP1Sheaf.lean`:408-421) is the identity on carriers but proves
   `map_smul'` via `Scheme.Hom.appLE_eq_app`.  So the two must be joined by a
   `TensorProduct` transport along that equivalence plus one `appLE_eq_app` rewrite for the
   target-side scalar.

4. **Moving surjectivity from `π_A ≫ p` to `q` needs a lemma.**  The preimage-cover
   observation lands the Čech differential at the family `π_A ≫ p`, and `q` equals it only
   propositionally (`Adelic.finiteMapToP1BaseChange_snd`, `Picard/RigidPushforward.lean`:595,
   proved by `(pullback.lift_snd _ _ _).trans (Category.comp_id _)`).  Since the module
   structures sit inside the *type* of `moduleSectionDiffBase`, a naive `rw` on the morphism
   equality risks a "motive is not type correct" failure; a `subst`-style congruence helper is
   needed.  "Transports by `exact`" is true only within a fixed family.

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