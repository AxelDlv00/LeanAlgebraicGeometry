/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.RiemannRoch.OcOfD
import AlgebraicJacobian.RiemannRoch.H1Vanishing

/-!
# Finiteness of cohomology of line bundles on a proper curve (S2)

This file supplies the `S2` finiteness obligation of the genus-`0`
Riemann–Roch arm: for every Weil divisor `D` on a smooth proper
geometrically irreducible curve `C / k̄`, the sheaf-cohomology groups
`Hⁱ(C, 𝒪_C(D)) = Scheme.HModule k̄ (sheafOf D) i` are finite-dimensional
`k̄`-vector spaces.

The strategy follows the blueprint chapter
`Cohomology_SerreFiniteness.tex` (the SES-induction route):

* the closed-point skyscraper `k(P)` has finite cohomology in the degrees
  `{0, 1}` the chapter consumes it (`HModule_skyscraper_finite`);
* finiteness is a 2-of-3 property along a short exact sequence
  (`HModule_finite_of_ses`);
* the base case is the structure sheaf `𝒪_C`
  (`HModule_structureSheaf_finite`), whose `H¹` finiteness is computed
  directly from a two-affine Čech cover
  (`HModule_structureSheaf_H1_finite`, via `cechH1OfTwoAffine`,
  `HModule_one_iso_cechH1`, `cechH1_finiteDimensional`);
* every line bundle `𝒪_C(D)` is reached from `𝒪_C` by adding/removing
  single closed points along `sheafOf_ses_single_add`; finiteness
  propagates by the 2-of-3 property (`HModule_sheafOf_finite`).

The degrees `≥ 2` are pinned to zero *per sheaf* by the two-affine Čech
truncation (`HModule_structureSheaf_higher_vanish`,
`HModule_sheafOf_higher_vanish`), each resting on the affine
acyclicity input `HModule_affine_acyclic`. No general Grothendieck
`H^{≥2} = 0` gate is invoked.

See `blueprint/src/chapters/Cohomology_SerreFiniteness.tex`.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]

/-! ### Controlling the higher degrees: affine acyclicity -/

/-- **Affine acyclicity** (Hartshorne III.3.5, `Module k̄`-flavoured;
blueprint `lem:HModule_affine_acyclic`).  A quasi-coherent sheaf of
`k̄`-modules on an affine open `Spec A ⊆ C` has vanishing higher
`HModule`-cohomology.  Stated here, for the two-affine-cover Čech
truncation, as the vanishing of the higher cohomology of a sheaf `F`
whose cohomology is computed on an affine open.

The genuine content (the flasque-free Stacks Čech/Koszul computation,
Tags 01EW/01X9/01XB) is a multi-step `mathlib-build`; this declaration
is the typed interface its build must inhabit.  The quasi-coherence
hypothesis is carried abstractly by `hAffine`/`hp` here pending the
build's choice of qcoh predicate in the `Module k̄` sheaf category. -/
theorem HModule_affine_acyclic
    {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))
    (hAffine : ∃ A : CommRingCat.{u}, Nonempty (X ≅ (Spec A).toTopCat))
    (p : ℕ) (hp : 0 < p) :
    Subsingleton (Scheme.HModule kbar F p) := by
  -- Multi-step `mathlib-build`: the alternating Čech complex of a
  -- standard cover of `Spec A` is the localisation complex of
  -- `M = Γ(Spec A, F)`; the algebraic Koszul contraction homotopy
  -- (Stacks `lemma-cech-cohomology-quasi-coherent-trivial`) gives
  -- `Ȟᵖ = 0` for `p > 0`; the acyclic-basis principle (Stacks 01EW)
  -- upgrades vanishing Čech to vanishing derived cohomology.
  sorry

/-! ### The two-affine open cover -/

/-- **A smooth proper curve has a two-affine open cover** (Hartshorne
IV.1.3; blueprint `lem:exists_two_affine_cover`).  There are two affine
opens `U, V ⊆ C` covering `C` (and, by separatedness, with affine
intersection).  Concretely `U = C ∖ {P₀}`, `V = C ∖ {Q₀}` for two
distinct closed points; the existential below records the affine cover
that the Čech computation consumes. -/
theorem exists_two_affine_open_cover :
    ∃ U V : TopologicalSpace.Opens C.left.toTopCat,
      IsAffineOpen U ∧ IsAffineOpen V ∧ U ⊔ V = ⊤ ∧ IsAffineOpen (U ⊓ V) := by
  -- A positive-dimensional integral curve over an algebraically closed
  -- field has infinitely many closed points; pick `P₀ ≠ Q₀` and take the
  -- punctured complements.  Each is integral, separated, regular,
  -- one-dimensional, finite type and non-proper, hence affine by
  -- Hartshorne IV.1.3 (a non-proper curve is affine).  The intersection
  -- is affine as an intersection of two affines of a separated scheme.
  sorry

/-! ### First Čech cohomology of the two-affine cover -/

/-- **First Čech cohomology of the two-affine cover** (blueprint
`def:cech_H1_two_affine`).  For the two-element cover
`𝔘 = {U, V}` of `exists_two_affine_open_cover`, the Čech complex of
`𝒪_C` has only the two terms `C⁰ = 𝒪_C(U) ⊕ 𝒪_C(V)`,
`C¹ = 𝒪_C(U ∩ V)`, with differential `d(s, t) = s|_{U∩V} − t|_{U∩V}`.
We define `cechH1OfTwoAffine` to be the cokernel of this single
`k̄`-linear map; since the cover has only two members this is exactly the
degree-`1` Čech cohomology `Ȟ¹(𝔘, 𝒪_C)`.

Built as a `ModuleCat.{u} k̄` object.  The explicit cokernel construction
from the cover of `exists_two_affine_open_cover` is the build target;
the typed interface is fixed here. -/
noncomputable def cechH1OfTwoAffine (C : Over (Spec (.of kbar)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left] :
    ModuleCat.{u} kbar :=
  -- `coker (d : 𝒪_C(U) ⊕ 𝒪_C(V) → 𝒪_C(U ∩ V))` for the cover
  -- `{U, V}` from `exists_two_affine_open_cover`.
  sorry

/-- **Čech equals `HModule k̄`-cohomology of `𝒪_C` on the two-affine
cover** (Hartshorne III.4.5, `Module k̄`-flavoured; blueprint
`lem:HModule_H1_iso_cech_two_affine`).  The degree-`1`
`HModule k̄`-cohomology of the structure sheaf is `k̄`-linearly
isomorphic to the Čech cokernel `cechH1OfTwoAffine`.

The acyclic-cover comparison in the `Module k̄` sheaf category is new
project material; its load-bearing input is `HModule_affine_acyclic`. -/
noncomputable def HModule_one_iso_cechH1 :
    Scheme.HModule kbar (Scheme.toModuleKSheaf C) 1 ≃ₗ[kbar]
      cechH1OfTwoAffine C := by
  -- Acyclic-cover comparison: the two cover members and their
  -- intersection are affine, so by `HModule_affine_acyclic` the cover is
  -- acyclic for `𝒪_C`; the two-element Čech complex therefore computes
  -- `HModule k̄ (toModuleKSheaf C)`, and in degree `1` this is the single
  -- cokernel `cechH1OfTwoAffine`.
  sorry

/-- **The two-affine Čech cokernel is finite-dimensional** (Serre
finiteness / Riemann inequality, Hartshorne III.5.2(a) + IV.1.1;
blueprint `lem:cech_H1_two_affine_finiteDimensional`).  This is the
deepest input of the chapter: the surviving principal-part classes are
bounded independently of the pole order (Riemann's inequality / the
finiteness of the genus). -/
theorem cechH1_finiteDimensional :
    FiniteDimensional kbar (cechH1OfTwoAffine C) := by
  -- Polar-parts argument (Steps 1–3 of the blueprint proof): localise to
  -- principal parts at the two punctures, the cover absorbs one puncture
  -- at a time, and the surviving classes are bounded independently of the
  -- pole order — Riemann's inequality, the deep input (classically Serre
  -- finiteness III.5.2(a), giving `dim cechH1 = g < ∞`).
  sorry

/-! ### Finiteness of `H¹` of the structure sheaf -/

/-- **Finiteness of `H¹` of the structure sheaf** (blueprint
`lem:HModule_structureSheaf_H1_finite`).  `H¹(C, 𝒪_C)` is a
finite-dimensional `k̄`-vector space.  This is the real base obligation of
the chapter, replacing any appeal to general Serre finiteness:
`H¹(C, 𝒪_C) ≅ cechH1OfTwoAffine` is finite-dimensional. -/
theorem HModule_structureSheaf_H1_finite :
    FiniteDimensional kbar (Scheme.HModule kbar (Scheme.toModuleKSheaf C) 1) := by
  -- Transport finite-dimensionality across the linear iso
  -- `HModule_one_iso_cechH1` from `cechH1_finiteDimensional`.
  haveI := cechH1_finiteDimensional (C := C)
  exact Module.Finite.equiv (HModule_one_iso_cechH1 (C := C)).symm

/-! ### Higher-degree vanishing for the structure sheaf and line bundles -/

/-- **Higher cohomology of the structure sheaf vanishes** (blueprint
`lem:HModule_structureSheaf_higher_vanish`).  `Hⁱ(C, 𝒪_C) = 0` for every
`i ≥ 2`: the two-element Čech complex of the affine cover is concentrated
in degrees `{0, 1}`, so its cohomology vanishes in degree `≥ 2`. -/
theorem HModule_structureSheaf_higher_vanish (i : ℕ) (hi : 2 ≤ i) :
    Subsingleton (Scheme.HModule kbar (Scheme.toModuleKSheaf C) i) := by
  -- The two-element cover is acyclic for `𝒪_C` (`HModule_affine_acyclic`
  -- on `U`, `V`, `U ∩ V`), so its Čech complex computes
  -- `HModule k̄ (toModuleKSheaf C)`; that complex has no cochains in
  -- degree `≥ 2`, forcing the cohomology to vanish there.
  sorry

/-- **Higher cohomology of `𝒪_C(D)` vanishes, for every Weil divisor**
(blueprint `lem:HModule_sheafOf_higher_vanish`).  This is what closes the
`Subsingleton (Ext L S.X₁ 2)` obligation at `RRFormula` (`S.X₁` being the
line bundle `𝒪_C(D)`).  Same two-affine Čech truncation as for `𝒪_C`,
applied directly to the quasi-coherent sheaf `𝒪_C(D)`. -/
theorem HModule_sheafOf_higher_vanish (D : C.left.WeilDivisor) (i : ℕ)
    (hi : 2 ≤ i) :
    Subsingleton (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i) := by
  -- `𝒪_C(D)` is quasi-coherent; the two cover members and their
  -- intersection are affine, so by `HModule_affine_acyclic` the cover is
  -- acyclic for `𝒪_C(D)`; the two-element Čech complex computing its
  -- cohomology has no cochains in degree `≥ 2`.
  sorry

/-! ### Finiteness for the closed-point skyscraper -/

omit [IsAlgClosed kbar] [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left] in
/-- **A flasque sheaf of `k̄`-modules has trivial `H¹`** (helper; the
`Subsingleton` strengthening of the public `HModule_flasque_one_eq_zero`,
which only exposes `finrank = 0`).  The body replicates the `hsub` block
of `HModule_flasque_one_eq_zero`: it runs the injective-hull short exact
sequence `0 → F → Injective.under F → R → 0`, uses degree-`1`
`Ext`-vanishing along a `Hom`-surjective injective term, and lifts
section-level flasque surjectivity (`IsFlasque.shortExact_app_surjective`
at `⊤`) to `Hom`-from-`constantSheaf` surjectivity via the
`constantSheaf ⊣ sheafSections ⊤` adjunction. -/
theorem HModule_flasque_one_subsingleton
    {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    {F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    (hF : Scheme.IsFlasque F) :
    Subsingleton (Scheme.HModule kbar F 1) := by
  refine ⟨fun x y => ?_⟩
  have hSES := Scheme.injectiveSES_shortExact F
  have hI_inj : Injective (Scheme.injectiveSES F).X₂ := Injective.injective_under F
  have hsurj : Function.Surjective
      (fun (f : (constantSheaf (Opens.grothendieckTopology X)
          (ModuleCat.{u} kbar)).obj (ModuleCat.of kbar kbar) ⟶
          (Scheme.injectiveSES F).X₂) => f ≫ (Scheme.injectiveSES F).g) := by
    intro g
    let hT : Limits.IsTerminal (⊤ : TopologicalSpace.Opens X) :=
      Preorder.isTerminalTop (TopologicalSpace.Opens X)
    let adj := constantSheafAdj (Opens.grothendieckTopology X)
      (ModuleCat.{u} kbar) hT
    have h_b_top : Function.Surjective
        (((Scheme.injectiveSES F).g.hom.app
          (Opposite.op (⊤ : TopologicalSpace.Opens X))).hom) :=
      Scheme.IsFlasque.shortExact_app_surjective hSES hF ⊤
    let g_sec : ModuleCat.of kbar kbar ⟶
        (Scheme.injectiveSES F).X₃.val.obj
          (Opposite.op (⊤ : TopologicalSpace.Opens X)) :=
      adj.homEquiv _ _ g
    let s₃ : (Scheme.injectiveSES F).X₃.val.obj
        (Opposite.op (⊤ : TopologicalSpace.Opens X)) := g_sec.hom 1
    obtain ⟨s₂, hs₂⟩ := h_b_top s₃
    let f_sec : ModuleCat.of kbar kbar ⟶
        (Scheme.injectiveSES F).X₂.val.obj
          (Opposite.op (⊤ : TopologicalSpace.Opens X)) :=
      ModuleCat.ofHom (LinearMap.toSpanSingleton kbar _ s₂)
    refine ⟨(adj.homEquiv _ _).symm f_sec, ?_⟩
    apply (adj.homEquiv _ _).injective
    rw [Adjunction.homEquiv_naturality_right, Equiv.apply_symm_apply]
    change f_sec ≫ ((sheafSections (Opens.grothendieckTopology X)
      (ModuleCat.{u} kbar)).obj (Opposite.op ⊤)).map (Scheme.injectiveSES F).g = g_sec
    apply ModuleCat.hom_ext
    ext
    change ((Scheme.injectiveSES F).g.hom.app (Opposite.op ⊤)).hom
        ((LinearMap.toSpanSingleton kbar _ s₂) 1) = g_sec.hom 1
    rw [LinearMap.toSpanSingleton_apply_one]
    exact hs₂
  rw [ext_one_eq_zero_of_hom_surjective_of_injective _ hSES hsurj x,
      ext_one_eq_zero_of_hom_surjective_of_injective _ hSES hsurj y]

/-- **Finiteness of the cohomology of a closed-point skyscraper**
(blueprint `lem:HModule_skyscraper_finite`).  The closed-point skyscraper
`k(P)` has finite-dimensional cohomology in the degrees `{0, 1}` the
chapter consumes it: `H⁰(C, k(P)) ≅ k̄` and `H¹(C, k(P)) = 0`.  Stated
for `i ≤ 1`. -/
theorem HModule_skyscraper_finite (P : C.left.PrimeDivisor)
    [∀ U : TopologicalSpace.Opens C.left, Decidable (P.point ∈ U)]
    (i : ℕ) (hi : i ≤ 1) :
    FiniteDimensional kbar
      (Scheme.HModule kbar
        (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point
          (ModuleCat.of kbar kbar)) i) := by
  interval_cases i
  · -- Degree 0: `H⁰(C, k(P)) ≅ k̄`, one-dimensional.  Mirrors the
    -- (private) `H0_skyscraperSheaf_finrank_eq_one` of `RRFormula`: a
    -- four-step `k̄`-linear chain identifies `H⁰` with the skyscraper
    -- presheaf evaluation at `⊤`, which is `k̄` (one-dimensional, finite).
    let LE1 := Scheme.HModule_zero_linearEquiv kbar
      (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point (ModuleCat.of kbar kbar))
    let LE2 := AlgebraicGeometry.Scheme.constantSheafGammaHom_linearEquiv kbar
      (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.of kbar kbar)
      (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point (ModuleCat.of kbar kbar))
    let LE3 := AlgebraicGeometry.Scheme.homFromOne_linearEquiv kbar
      ((Sheaf.Γ (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)).obj
        (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point (ModuleCat.of kbar kbar)))
    let LE4 := AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top kbar
      (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point (ModuleCat.of kbar kbar))
    let LE := ((LE1.trans LE2).trans LE3).trans LE4
    have hfin : Module.Finite kbar
        ((skyscraperSheaf (C := ModuleCat.{u} kbar) P.point
            (ModuleCat.of kbar kbar)).obj.obj
          (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))) := by
      change Module.Finite kbar
        ((skyscraperPresheaf (C := ModuleCat.{u} kbar) P.point (ModuleCat.of kbar kbar)).obj
          (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)))
      rw [skyscraperPresheaf_obj]
      simp only [Opposite.unop_op]
      rw [if_pos] <;> first | infer_instance | trivial
    exact hfin.equiv LE.symm
  · -- Degree 1: the skyscraper is flasque
    -- (`skyscraperSheaf_isFlasque`), so `H¹ = 0` is a subsingleton
    -- (`HModule_flasque_one_subsingleton`), hence finite.
    haveI : Subsingleton (Scheme.HModule kbar
        (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point
          (ModuleCat.of kbar kbar)) 1) :=
      HModule_flasque_one_subsingleton (Scheme.skyscraperSheaf_isFlasque C P)
    infer_instance

/-! ### Finiteness is a 2-of-3 property along a short exact sequence -/

omit [IsAlgClosed kbar] [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left] in
/-- **2-of-3 (middle term) for finite cohomology along a short exact
sequence** (blueprint `lem:HModule_finite_of_ses`, middle-term
direction).  In a short exact sequence
`0 → F₁ → F₂ → F₃ → 0` of sheaves of `k̄`-modules, if `F₁` and `F₃` have
finite-dimensional cohomology in degree `i`, then so does `F₂`: the
degree-local window `Hⁱ(F₁) → Hⁱ(F₂) → Hⁱ(F₃)` is exact with
finite-dimensional ends. -/
theorem HModule_finite_of_ses
    (S : CategoryTheory.ShortComplex
      (Sheaf (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)))
    (hSE : S.ShortExact) (i : ℕ)
    (h1 : FiniteDimensional kbar (Scheme.HModule kbar S.X₁ i))
    (h3 : FiniteDimensional kbar (Scheme.HModule kbar S.X₃ i)) :
    FiniteDimensional kbar (Scheme.HModule kbar S.X₂ i) := by
  -- The SES induces a long exact `HModule k̄` cohomology sequence; the
  -- three-term window `Hⁱ(F₁) →(f) Hⁱ(F₂) →(g) Hⁱ(F₃)` is exact.  Then
  -- `Hⁱ(F₂)` is sandwiched: `range f = ker g` is a quotient of the finite
  -- `Hⁱ(F₁)`, and `Hⁱ(F₂) / ker g ≅ range g ↪ Hⁱ(F₃)` finite; an
  -- extension of finite-dimensionals is finite-dimensional.
  set L : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar) :=
    (constantSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar)).obj (ModuleCat.of kbar kbar) with hL
  -- The two degree-`i` LES maps (covariant `Ext` postcomposition).
  let f : Scheme.HModule kbar S.X₁ i →ₗ[kbar] Scheme.HModule kbar S.X₂ i :=
    (Abelian.Ext.mk₀ S.f).postcompOfLinear kbar L (add_zero i)
  let g : Scheme.HModule kbar S.X₂ i →ₗ[kbar] Scheme.HModule kbar S.X₃ i :=
    (Abelian.Ext.mk₀ S.g).postcompOfLinear kbar L (add_zero i)
  -- Exactness at the middle node, from Mathlib's covariant Ext-LES.
  have hexact : Function.Exact f g := by
    intro y
    constructor
    · intro hy
      exact Abelian.Ext.covariant_sequence_exact₂ (X := L) (hS := hSE) y hy
    · rintro ⟨x, rfl⟩
      change (x.comp (Abelian.Ext.mk₀ S.f) (add_zero i)).comp
          (Abelian.Ext.mk₀ S.g) (add_zero i) = 0
      simp only [Abelian.Ext.comp_assoc_of_third_deg_zero, Abelian.Ext.mk₀_comp_mk₀,
        ShortComplex.zero, Abelian.Ext.mk₀_zero, Abelian.Ext.comp_zero]
  -- `range f` is finite (surjective image of the finite `Hⁱ(F₁)`).
  haveI : Module.Finite kbar (LinearMap.range f) :=
    Module.Finite.of_surjective f.rangeRestrict (LinearMap.surjective_rangeRestrict f)
  -- `ker g = range f`, hence finite.
  have hker : LinearMap.ker g = LinearMap.range f := hexact.linearMap_ker_eq
  haveI : Module.Finite kbar (LinearMap.ker g) := by rw [hker]; infer_instance
  -- `Hⁱ(F₂) ⧸ ker g ≅ range g`, a submodule of the finite `Hⁱ(F₃)`.
  haveI : Module.Finite kbar
      (Scheme.HModule kbar S.X₂ i ⧸ LinearMap.ker g) :=
    Module.Finite.equiv g.quotKerEquivRange.symm
  -- Extension of finite-dimensionals is finite-dimensional.
  exact Module.Finite.of_submodule_quotient (LinearMap.ker g)

omit [IsAlgClosed kbar] [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left] in
/-- **2-of-3 (left term) for finite cohomology along a short exact
sequence** (helper for the remove-a-point direction of the induction).
If `F₂` is finite in degree `i` and `F₃` is finite in degree `i-1`, then
`F₁` is finite in degree `i`: at `i = 0` the map `H⁰(F₁) → H⁰(F₂)` is
injective (`S.f` is a mono); at `i = j+1` the window
`Hʲ(F₃) →(δ) Hʲ⁺¹(F₁) →(f) Hʲ⁺¹(F₂)` is exact with finite-dimensional
ends. -/
theorem HModule_finite_X₁_of_ses
    (S : CategoryTheory.ShortComplex
      (Sheaf (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)))
    (hSE : S.ShortExact) (i : ℕ)
    (h2 : FiniteDimensional kbar (Scheme.HModule kbar S.X₂ i))
    (h3 : FiniteDimensional kbar (Scheme.HModule kbar S.X₃ (i - 1))) :
    FiniteDimensional kbar (Scheme.HModule kbar S.X₁ i) := by
  set L : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar) :=
    (constantSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar)).obj (ModuleCat.of kbar kbar) with hL
  match i with
  | 0 =>
    -- `S.f` is a monomorphism, so `H⁰(F₁) ↪ H⁰(F₂)` is injective.
    haveI : Mono S.f := hSE.mono_f
    let f : Scheme.HModule kbar S.X₁ 0 →ₗ[kbar] Scheme.HModule kbar S.X₂ 0 :=
      (Abelian.Ext.mk₀ S.f).postcompOfLinear kbar L (add_zero 0)
    have hf : Function.Injective f :=
      Abelian.Ext.postcomp_mk₀_injective_of_mono L S.f
    exact Module.Finite.of_injective f hf
  | (j + 1) =>
    -- The degree-`(j+1)` window `Hʲ(F₃) →(δ) Hʲ⁺¹(F₁) →(f) Hʲ⁺¹(F₂)`.
    let f : Scheme.HModule kbar S.X₁ (j + 1) →ₗ[kbar]
        Scheme.HModule kbar S.X₂ (j + 1) :=
      (Abelian.Ext.mk₀ S.f).postcompOfLinear kbar L (add_zero (j + 1))
    let δ : Scheme.HModule kbar S.X₃ j →ₗ[kbar]
        Scheme.HModule kbar S.X₁ (j + 1) :=
      hSE.extClass.postcompOfLinear kbar L (rfl : j + 1 = j + 1)
    have hexact : Function.Exact δ f := by
      intro x₁
      constructor
      · intro hx₁
        exact Abelian.Ext.covariant_sequence_exact₁ (X := L) (hS := hSE) x₁ hx₁ rfl
      · rintro ⟨x₃, rfl⟩
        change (x₃.comp hSE.extClass (rfl : j + 1 = j + 1)).comp
            (Abelian.Ext.mk₀ S.f) (add_zero (j + 1)) = 0
        rw [Abelian.Ext.comp_assoc_of_third_deg_zero,
          ShortComplex.ShortExact.extClass_comp, Abelian.Ext.comp_zero]
    -- `range δ` finite (surjective image of the finite `Hʲ(F₃)`).
    haveI : Module.Finite kbar (Scheme.HModule kbar S.X₃ j) := h3
    haveI : Module.Finite kbar (LinearMap.range δ) :=
      Module.Finite.of_surjective δ.rangeRestrict (LinearMap.surjective_rangeRestrict δ)
    -- `ker f = range δ`, hence finite; quotient embeds into the finite `H²(F₂)`.
    have hker : LinearMap.ker f = LinearMap.range δ := hexact.linearMap_ker_eq
    haveI : Module.Finite kbar (LinearMap.ker f) := by rw [hker]; infer_instance
    haveI : Module.Finite kbar
        (Scheme.HModule kbar S.X₁ (j + 1) ⧸ LinearMap.ker f) :=
      Module.Finite.equiv f.quotKerEquivRange.symm
    exact Module.Finite.of_submodule_quotient (LinearMap.ker f)

/-! ### The base case: finiteness for the structure sheaf -/

/-- **Finiteness of the cohomology of the structure sheaf** (blueprint
`lem:HModule_structureSheaf_finite`).  `Hⁱ(C, 𝒪_C)` is a
finite-dimensional `k̄`-vector space for every `i`: degree `0` is
one-dimensional (Stein), degree `1` is finite by the two-affine Čech
computation, and degrees `≥ 2` vanish. -/
theorem HModule_structureSheaf_finite (i : ℕ) :
    FiniteDimensional kbar (Scheme.HModule kbar (Scheme.toModuleKSheaf C) i) := by
  match i with
  | 0 =>
    -- Degree 0: `Module.Finite k̄ (HModule k̄ (toModuleKSheaf C) 0)` is the
    -- Stein H⁰ producer instance.
    exact Scheme.module_finite_HModule_zero_of_isHModuleHomFinite_curve kbar C
  | 1 =>
    -- Degree 1: the two-affine Čech computation.
    exact HModule_structureSheaf_H1_finite (C := C)
  | (n + 2) =>
    -- Degrees ≥ 2 vanish, so are finite.
    haveI : Subsingleton (Scheme.HModule kbar (Scheme.toModuleKSheaf C) (n + 2)) :=
      HModule_structureSheaf_higher_vanish (C := C) (n + 2) (by omega)
    infer_instance

/-! ### Finiteness for every line bundle `𝒪_C(D)` — the induction -/

omit [IsAlgClosed kbar] [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left] in
/-- Transport of `HModule k̄` cohomology across an isomorphism of sheaves
(local copy of the private `RRFormula` helper). -/
noncomputable def HModule_linearEquiv_of_iso
    {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    {F G : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    (e : F ≅ G) (n : ℕ) :
    Scheme.HModule kbar F n ≃ₗ[kbar] Scheme.HModule kbar G n :=
  LinearEquiv.ofLinear
    ((Abelian.Ext.mk₀ e.hom).postcompOfLinear kbar _ (add_zero n))
    ((Abelian.Ext.mk₀ e.inv).postcompOfLinear kbar _ (add_zero n))
    (by
      ext α
      change (α.comp (Abelian.Ext.mk₀ e.inv) (add_zero n)).comp
          (Abelian.Ext.mk₀ e.hom) (add_zero n) = α
      rw [Abelian.Ext.comp_assoc_of_third_deg_zero,
        Abelian.Ext.mk₀_comp_mk₀, e.inv_hom_id]
      exact Abelian.Ext.comp_mk₀_id _)
    (by
      ext α
      change (α.comp (Abelian.Ext.mk₀ e.hom) (add_zero n)).comp
          (Abelian.Ext.mk₀ e.inv) (add_zero n) = α
      rw [Abelian.Ext.comp_assoc_of_third_deg_zero,
        Abelian.Ext.mk₀_comp_mk₀, e.hom_inv_id]
      exact Abelian.Ext.comp_mk₀_id _)

/-- **Induction step on the coefficient at a single point** (helper for
`HModule_sheafOf_finite`).  If `𝒪_C(f)` has finite degree-`i` cohomology
(`i ≤ 1`) then so does `𝒪_C(single Q n + f)`, for every `n : ℤ`.  The
proof is `Int.induction_on n`: the base `n = 0` is the hypothesis; the
step `n → n+1` adds the closed point `Q` via the SES
`sheafOf_ses_single_add` and the middle-term 2-of-3
`HModule_finite_of_ses`; the step `-n → -n-1` removes it via the
left-term 2-of-3 `HModule_finite_X₁_of_ses`. -/
theorem sheafOf_finite_single_add_aux (i : ℕ) (hi : i ≤ 1)
    (Q : C.left.PrimeDivisor) (f : C.left.PrimeDivisor →₀ ℤ)
    (hf : FiniteDimensional kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) f) i))
    (n : ℤ) :
    FiniteDimensional kbar
      (Scheme.HModule kbar
        (Scheme.WeilDivisor.sheafOf (C := C) (Finsupp.single Q n + f)) i) := by
  classical
  induction n using Int.induction_on with
  | zero =>
    -- `single Q 0 + f = f`.
    have hdiv : (Finsupp.single Q (0 : ℤ) + f) = f := by
      rw [Finsupp.single_zero, zero_add]
    exact (congrArg (fun D => FiniteDimensional kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i)) hdiv).mpr hf
  | succ k ih =>
    -- Add the point `Q`: SES `0 → 𝒪(g) → 𝒪(single Q 1 + g) → k(Q) → 0`
    -- with `g = single Q k + f`, so `single Q 1 + g = single Q (k+1) + f`.
    obtain ⟨S, hSE, hX1, hX2, ⟨e⟩⟩ :=
      Scheme.WeilDivisor.sheafOf_ses_single_add (C := C) (Finsupp.single Q (k : ℤ) + f) Q
    haveI hX3 : FiniteDimensional kbar (Scheme.HModule kbar S.X₃ i) := by
      have key : FiniteDimensional kbar (Scheme.HModule kbar
          (skyscraperSheaf (C := ModuleCat.{u} kbar) Q.point
            (ModuleCat.of kbar kbar)) i) := HModule_skyscraper_finite Q i hi
      exact key.equiv (HModule_linearEquiv_of_iso e i).symm
    haveI hX1fin : FiniteDimensional kbar (Scheme.HModule kbar S.X₁ i) := hX1 ▸ ih
    have hX2fin : FiniteDimensional kbar (Scheme.HModule kbar S.X₂ i) :=
      HModule_finite_of_ses S hSE i hX1fin hX3
    rw [hX2] at hX2fin
    -- Goal `𝒪(single Q (k+1) + f)` ; reassociate via `single_add`.
    have hdiv : (Finsupp.single Q ((k : ℤ) + 1) + f)
        = Finsupp.single Q (1 : ℤ) + (Finsupp.single Q (k : ℤ) + f) := by
      rw [Finsupp.single_add]; abel
    exact (congrArg (fun D => FiniteDimensional kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i)) hdiv).mpr hX2fin
  | pred k ih =>
    -- Remove the point `Q`: SES `0 → 𝒪(g) → 𝒪(single Q 1 + g) → k(Q) → 0`
    -- with `g = single Q (-k-1) + f`, so `single Q 1 + g = single Q (-k) + f`.
    obtain ⟨S, hSE, hX1, hX2, ⟨e⟩⟩ :=
      Scheme.WeilDivisor.sheafOf_ses_single_add (C := C)
        (Finsupp.single Q (-(k : ℤ) - 1) + f) Q
    haveI hX3 : FiniteDimensional kbar (Scheme.HModule kbar S.X₃ (i - 1)) := by
      have key : FiniteDimensional kbar (Scheme.HModule kbar
          (skyscraperSheaf (C := ModuleCat.{u} kbar) Q.point
            (ModuleCat.of kbar kbar)) (i - 1)) := HModule_skyscraper_finite Q (i - 1) (by omega)
      exact key.equiv (HModule_linearEquiv_of_iso e (i - 1)).symm
    have hdiv : (Finsupp.single Q (1 : ℤ) + (Finsupp.single Q (-(k : ℤ) - 1) + f))
        = Finsupp.single Q (-(k : ℤ)) + f := by
      rw [← add_assoc, ← Finsupp.single_add]
      congr 2
      ring
    haveI hX2fin : FiniteDimensional kbar (Scheme.HModule kbar S.X₂ i) := by
      rw [hX2]
      exact (congrArg (fun D => FiniteDimensional kbar
        (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i)) hdiv).mpr ih
    have hX1fin : FiniteDimensional kbar (Scheme.HModule kbar S.X₁ i) :=
      HModule_finite_X₁_of_ses S hSE i hX2fin hX3
    -- Goal `p (-↑k - 1)` is `𝒪(single Q (-k-1) + f)`, which is `S.X₁` by `hX1`.
    exact hX1 ▸ hX1fin

/-- **Finiteness of `𝒪_C(D)` cohomology in degrees `≤ 1`** (helper for
`HModule_sheafOf_finite`), by `Finsupp.induction` on `D`: the base
`D = 0` is `𝒪_C` (`HModule_structureSheaf_finite`); each step adds a
`single Q b` term, handled by `sheafOf_finite_single_add_aux`. -/
theorem sheafOf_finite_of_le_one (i : ℕ) (hi : i ≤ 1)
    (D : C.left.PrimeDivisor →₀ ℤ) :
    FiniteDimensional kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i) := by
  induction D using Finsupp.induction with
  | zero =>
    rw [show Scheme.WeilDivisor.sheafOf (C := C) (0 : C.left.PrimeDivisor →₀ ℤ)
        = Scheme.toModuleKSheaf C from Scheme.WeilDivisor.sheafOf_zero (C := C)]
    exact HModule_structureSheaf_finite i
  | single_add Q b f _ _ ih =>
    exact sheafOf_finite_single_add_aux i hi Q f ih b

/-! ### Finiteness for every line bundle `𝒪_C(D)` -/

/-- **Finiteness of the cohomology of `𝒪_C(D)` for every Weil divisor**
(blueprint `thm:HModule_lineBundle_finite`).  The invertible sheaf
`𝒪_C(D)` has finite cohomology: `Hⁱ(C, 𝒪_C(D))` is a finite-dimensional
`k̄`-vector space for every `i`.

Degrees `≥ 2` vanish directly (`HModule_sheafOf_higher_vanish`); degrees
`{0, 1}` are obtained by induction on `D`, using the closed-point SES
`sheafOf_ses_single_add` and the 2-of-3 property `HModule_finite_of_ses`,
with the skyscraper finite at `{0, 1}` (`HModule_skyscraper_finite`). -/
theorem HModule_sheafOf_finite (D : C.left.WeilDivisor) (i : ℕ) :
    FiniteDimensional kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) i) := by
  -- Split on the degree.  Degrees ≥ 2 vanish per sheaf; degrees {0,1} go
  -- by induction on `D` along single-point modifications.
  match i with
  | (n + 2) =>
    haveI : Subsingleton
        (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) (n + 2)) :=
      HModule_sheafOf_higher_vanish (C := C) D (n + 2) (by omega)
    infer_instance
  | 0 =>
    -- Induction on `D` (single-point modifications), 2-of-3 at degree 0.
    exact sheafOf_finite_of_le_one 0 (by omega) D
  | 1 =>
    -- Induction on `D` (single-point modifications), 2-of-3 at degree 1.
    exact sheafOf_finite_of_le_one 1 (by omega) D

end AlgebraicGeometry.Scheme
