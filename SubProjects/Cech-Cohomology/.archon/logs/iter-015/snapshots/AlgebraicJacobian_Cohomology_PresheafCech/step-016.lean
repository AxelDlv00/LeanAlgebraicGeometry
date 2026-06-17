/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage

/-!
# Presheaf-level Čech machinery (P3b bridge)

This file is the home of the presheaf-level Čech machinery that bridges the
injective-acyclicity argument (P3b) to the main Čech–higher-direct-image comparison.
See `analogies/p3b-presheafcech.md` and `blueprint/src/chapters/
Cohomology_CechHigherDirectImage.tex` §"Presheaf-level Čech machinery" for the full
design rationale.

Declarations to be built (in order):
- `sectionCechComplex`             — `\lean{AlgebraicGeometry.sectionCechComplex}`
- `cechFreePresheafComplex`        — `\lean{AlgebraicGeometry.cechFreePresheafComplex}`
- `cechComplex_hom_identification` — `\lean{AlgebraicGeometry.cechComplex_hom_identification}`
- `cechFreeComplex_quasiIso`       — `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`
- `injective_cech_acyclic`         — `\lean{AlgebraicGeometry.injective_cech_acyclic}`
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
Planner strategy (P3b presheaf-Čech bridge; see analogies/p3b-presheafcech.md +
blueprint §Presheaf-level Čech machinery):

The goal is to prove that injective `O_X`-modules have trivial positive-degree Čech
cohomology with respect to any open cover.  The strategy avoids `presheafModules_
enoughInjectives` and `cech_delta_functor_presheaves` (decisions 4–5 in the analogy
file are expensive Mathlib gaps and are NOT on the critical path).  The build order is:

─────────────────────────────────────────────────────────────────────────────────
Step 1 — `sectionCechComplex`
─────────────────────────────────────────────────────────────────────────────────
Type: given a scheme `X`, an open cover `𝒰 : X.OpenCover`, an open `U : Opens ↥X`,
and a presheaf of modules `F : X.PresheafOfModules`, produce the section Čech
cochain complex

    Č•(𝒰, F, U) : CochainComplex (ModuleCat (X.ringCatSheaf.val.obj (op U))) ℕ

whose degree-`p` term is the product `∏_{(i₀,…,iₚ) : Fin (p+1) → 𝒰.J}
  F.obj (op (𝒰.U i₀ ⊓ … ⊓ 𝒰.U iₚ ⊓ U))`, equipped with the alternating restriction
differential.

THIS OBJECT IS DISTINCT from `CechComplex` in `CechHigherDirectImage.lean`:
`CechComplex` lives in `S.Modules` (pushforward along `f`) and is a relative complex.
`sectionCechComplex` is a plain cochain complex of `R`-modules where `R = O_X(U)`.

Key Mathlib hooks:
- `PresheafOfModules` — the category `X.PresheafOfModules =
  PresheafOfModules X.ringCatSheaf.val`.
- `PresheafOfModules.evaluation R (op V) : PresheafOfModules R ⥤ ModuleCat (R.obj (op V))`
  — the exact "sections over `V`" functor; use it to extract `F.obj (op V)`.
- `CochainComplex.of` or `HomologicalComplex.mk` — assemble the complex from
  degree-`p` objects and differentials.

─────────────────────────────────────────────────────────────────────────────────
Step 2 — `cechFreePresheafComplex`
─────────────────────────────────────────────────────────────────────────────────
Type: given `X` and `𝒰`, produce the chain complex of presheaves of modules

    K(𝒰)_• : ChainComplex X.PresheafOfModules ℕ

whose degree-`p` term is the direct sum `⨁_{(i₀,…,iₚ) : Fin (p+1) → 𝒰.J}
  (PresheafOfModules.free _).obj (yoneda.obj (𝒰.U i₀ ⊓ … ⊓ 𝒰.U iₚ))`.

DO NOT introduce a bespoke extension-by-zero functor `j_!`.  The blueprint's
`(j_{i₀…iₚ})_! (O_X|_{U_{i₀…iₚ}})` is canonically identified with
`(PresheafOfModules.free _).obj (yoneda.obj U_…)`: on sections over `V`, this is
the free `R(V)`-module on `Hom(V, U_…)` — which is `R(V)` when `V ⊆ U_…` and `0`
otherwise, matching extension-by-zero of `O_X|_{U_…}` exactly.

The differentials are `(PresheafOfModules.free _).map` of the representable maps
`yoneda.obj (U_{i₀⊓…⊓U_{iₚ₊₁}}) → yoneda.obj (U_{i₀⊓…⊓̂ᵢⱼ⊓…⊓U_{iₚ₊₁}})` induced
by the inclusion of opens `𝒰.U i₀ ⊓ … ⊓ 𝒰.U iₚ₊₁ ≤ 𝒰.U i₀ ⊓ … ⊓̂ᵢⱼ ⊓ …`, with
the standard alternating sign.

Key Mathlib hooks:
- `PresheafOfModules.free R : (Cᵒᵖ ⥤ Type u) ⥤ PresheafOfModules R` — the free
  presheaf-of-modules functor.
- `PresheafOfModules.freeAdjunction R : free R ⊣ toPresheaf R ⋙ whiskeringRight … (forget Ab)`
  — the adjunction; `freeObjDesc` / `freeHomEquiv` give the universal property
  `Hom(free(P), F) ≅ NatTrans P (F ∘ forget)` used in step 3.
- `yoneda : Opens ↥X ⥤ (Opens ↥X)ᵒᵖ ⥤ Type u` — the Yoneda embedding.
- Use `Finset.univ`-indexed direct sums; `ChainComplex.of` or `HomologicalComplex.mk`
  to assemble.

─────────────────────────────────────────────────────────────────────────────────
Step 3 — `cechComplex_hom_identification`
─────────────────────────────────────────────────────────────────────────────────
Type: a natural isomorphism of cochain complexes of abelian groups (or
`O_X(U)`-modules):

    Hom_{X.PresheafOfModules}(K(𝒰)_•, F)  ≅  Č•(𝒰, F, U)

i.e., the complex of hom-sets out of `K(𝒰)_•` is the section Čech cochain complex.

Strategy:
- At degree `p`, term-by-term: use the adjunction iso
  `(PresheafOfModules.freeAdjunction _).homEquiv` to identify
  `Hom_{PMod}(free(yoneda(U_I)), F)  ≅  NatTrans (yoneda(U_I)) (toPresheaf F)`
  and then Yoneda (`yonedaEquiv`) to get `≅  (toPresheaf F).obj (op U_I) = F.obj (op U_I)`.
  The product over multi-indices matches the degree-`p` term of `Č•(𝒰, F, U)`.
- Check that the differential intertwines: the differential on `Hom(K_•, F)` induced
  by pre-composition with the alternating-sign `free.map` maps matches the alternating
  restriction differential of `Č•(𝒰, F, U)`.
- Build as a cochain-complex isomorphism using `HomologicalComplex.Hom.isoOfComponents`.

Key Mathlib hooks:
- `PresheafOfModules.freeAdjunction` — the core adjunction.
- `yonedaEquiv` — the Yoneda natural bijection.
- `PresheafOfModules.evaluation` — sections extraction.

─────────────────────────────────────────────────────────────────────────────────
Step 4 — `cechFreeComplex_quasiIso`
─────────────────────────────────────────────────────────────────────────────────
Type: the augmented complex `K(𝒰)_• → O_𝒰[0]` (augmentation = "sheaf restricted to
the cover") is a quasi-isomorphism, i.e., `K(𝒰)_•` is a free resolution of `O_𝒰`.

Strategy (Mathlib has no packaged Čech contractibility lemma; build it directly):
- Homology of presheaves of modules is computed objectwise
  (limits/colimits in `PresheafOfModules R` are objectwise; see `HasColimits`
  instance). So it suffices to show that for each open `V : Opens ↥X`,
  the complex `K(𝒰)_•(V)` of `R(V)`-modules is contractible.
- The sectionwise complex `K(𝒰)_•(V)` is:
  degree `p` = `⨁_{I : Fin(p+1)→J} R(V)` when `V ⊆ U_{I(0)} ⊓ … ⊓ U_{I(p)}`, else `0`.
- Fix any index `i_fix` such that `V ⊆ 𝒰.U i_fix` (if no such index, the complex is
  `0` and trivially exact). The contracting homotopy `h : K_p(V) → K_{p+1}(V)` is:
      `h(s)_{i₀,i₁,…,iₚ} = (i₀ = i_fix) · s_{i₁,…,iₚ}`
  (extend the multi-index by prepending `i_fix`). Check: `dh + hd = id` at each degree.
- Assemble using `Homotopy` / `HomotopyEquiv` from Mathlib (`HomologicalComplex.Homotopy`
  in `Mathlib.Algebra.Homology.Homotopy`). From the chain homotopy conclude
  `HomotopyEquiv` and hence quasi-isomorphism.
- Do NOT route through `ExtraDegeneracy` (it has a different index convention and is
  not directly applicable here).

Key Mathlib hooks:
- `HomologicalComplex.Homotopy` — chain homotopy type.
- `HomotopyEquiv.toQuasiIso` (or `Homotopy.toQuasiIso`) — chain homotopy ⟹ quasi-iso.

─────────────────────────────────────────────────────────────────────────────────
Step 5 — `injective_cech_acyclic`
─────────────────────────────────────────────────────────────────────────────────
Type: for an injective `I : X.Modules` and an open cover `𝒰 : X.OpenCover`, the
positive-degree Čech cohomology `Ȟ^p(𝒰, I) = 0` for all `p > 0`.

Strategy (two independent parts; does NOT need decisions 4–5):

Part (a) — Injective sheaf ⟹ injective presheaf:
- Apply `CategoryTheory.Injective.injective_of_adjoint` to the adjunction
  `PresheafOfModules.sheafificationAdjunction α` where `α = 𝟙` for the scheme `X`.
  This adjunction is `sheafification α ⊣ (forget R) ⋙ restrictScalars α`, i.e.
  sheafification is left adjoint to the inclusion `toPresheafOfModules`.
- The left adjoint `sheafification` is exact (it is exact as a colimit of
  sheafification-endofunctors over a Grothendieck topology), hence in particular
  `PreservesMonomorphisms`. So `Injective.injective_of_adjoint` gives:
  `I` injective in `X.Modules` ⟹ `Scheme.Modules.toPresheafOfModules.obj I`
  is injective in `X.PresheafOfModules`.
- Relevant Mathlib names:
  `PresheafOfModules.sheafificationAdjunction`,
  `CategoryTheory.Injective.injective_of_adjoint`,
  `Functor.preservesInjectiveObjects_of_adjunction_of_preservesMonomorphisms`,
  `Adjunction.map_injective`.

Part (b) — Vanishing of positive Čech cohomology:
- By step 4, `K(𝒰)_• → O_𝒰[0]` is an exact augmented complex (quasi-iso from step 4).
- Since `I_pshf := toPresheafOfModules.obj I` is injective in `X.PresheafOfModules`
  (by part (a)), the functor `Hom_{PMod}(-, I_pshf)` is exact.
- Applying `Hom_{PMod}(-, I_pshf)` to the exact augmented complex `K(𝒰)_• → O_𝒰` and
  using step 3 (`cechComplex_hom_identification`) to identify the resulting complex
  with `Č•(𝒰, I, U)`, conclude that `Č•(𝒰, I, U)` is exact in positive degrees, i.e.
  `Ȟ^p(𝒰, I) = 0` for `p > 0`.
- This is the Stacks-project proof of `lemma-injective-trivial-cech` (Stacks tag
  0BKP and surrounding; see `references/stacks-cohomology.md`).

─────────────────────────────────────────────────────────────────────────────────
Verified Mathlib API summary (LSP-checked in this project):
  PresheafOfModules
  PresheafOfModules.free
  PresheafOfModules.freeAdjunction
  PresheafOfModules.evaluation
  PresheafOfModules.sheafificationAdjunction
  CategoryTheory.Injective.injective_of_adjoint
  yoneda
─────────────────────────────────────────────────────────────────────────────────
-/

/-! ## Project-local Mathlib supplement — PresheafCech (injective transfer) -/

variable {X : Scheme.{u}}

/-- **An injective sheaf of `O_X`-modules is injective as a presheaf of modules.**

This is Part 1 of the {\v C}ech-acyclicity of injectives (blueprint
`lem:injective_cech_acyclic`, Stacks `lemma-injective-trivial-cech`): the inclusion
`Scheme.Modules.toPresheafOfModules X : X.Modules ⥤ X.PresheafOfModules` is the right
adjoint of the (exact) sheafification functor, so it carries injective objects to
injective objects.

Project-local because Mathlib has no packaged "injective sheaf of modules ⟹ injective
presheaf of modules" statement; it is obtained here by feeding
`PresheafOfModules.sheafificationAdjunction (𝟙 _)` (whose left adjoint
`sheafification` preserves monomorphisms) to `Injective.injective_of_adjoint`. The
right adjoint of that adjunction is *definitionally* `toPresheafOfModules X`
(`SheafOfModules.forget _ ⋙ restrictScalars (𝟙 _)`). -/
theorem injective_toPresheafOfModules (I : X.Modules) [Injective I] :
    Injective ((Scheme.Modules.toPresheafOfModules X).obj I) := by
  -- the left adjoint of `toPresheafOfModules X` is `sheafification (𝟙 _)`, which is
  -- exact and in particular preserves monomorphisms
  haveI : (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).PreservesMonomorphisms :=
    inferInstance
  -- realign the ambient category instance so the `Injective` instance is found cheaply
  haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›
  exact Injective.injective_of_adjoint
    (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)) I

/-- **Free–Yoneda representability (per-term bijection).**

For an open `V : Opens X` and a presheaf of `O_X`-modules `F`, the morphisms out of the
free presheaf of modules on the representable `yoneda V` are exactly the sections of
`F` over `V`:
```
  Hom_{PMod(O_X)}(free(yoneda V), F) ≃ F(V).
```
This is the free–forgetful adjunction (`PresheafOfModules.freeHomEquiv`) composed with
the Yoneda bijection (`yonedaEquiv`). It is the single-multi-index core of the
{\v C}ech complex hom-identification (blueprint `lem:cech_complex_hom_identification`,
Stacks `lemma-cech-map-into`): taking the product over multi-indices turns this into
`Hom(K(𝒰)_p, F) = Č^p(𝒰, F)`.

Project-local because Mathlib packages the two halves separately but not their
composite as the corepresentability of evaluation by `free(yoneda V)`. The target
`(F.presheaf ⋙ forget Ab).obj (op V)` is the underlying set of the section group
`F(V)`. -/
noncomputable def freeYonedaHomEquiv (V : TopologicalSpace.Opens X)
    (F : X.PresheafOfModules) :
    ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj V) ⟶ F) ≃
      (F.presheaf ⋙ forget Ab).obj (Opposite.op V) :=
  PresheafOfModules.freeHomEquiv.trans yonedaEquiv

section Scratch3
open PresheafOfModules Limits
#check @CategoryTheory.Limits.Sigma.homEquiv
#check @CategoryTheory.Limits.Cofan.IsColimit.homEquiv
#check @CategoryTheory.Limits.coproductHomEquiv
example {C : Type*} [Category C] {ι : Type} (A : ι → C) (F : C) [HasCoproduct A] :
    (∐ A ⟶ F) ≃ ∀ i, (A i ⟶ F) :=
  ⟨fun f i => Sigma.ι A i ≫ f, fun g => Sigma.desc g, by intro f; ext i; simp,
    by intro g; ext i; simp⟩
end Scratch3

end AlgebraicGeometry
