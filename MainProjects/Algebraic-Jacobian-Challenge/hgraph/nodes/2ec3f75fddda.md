---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.CoherentSheafFlat.of_isPullback
docstring: '**Flatness over the base is stable under base change** (Stacks 01U9,

  lifted to the coherent-sheaf flatness predicate `Scheme.CoherentSheafFlat`

  along a cartesian square).  Affine-locally this is `Module.Flat.of_isPushout`

  threaded through the quasi-coherent section calculus: on an affine piece

  `g''⁻¹V ⊓ f''⁻¹Ut` of the fibre-product square the pulled-back sections are the

  base change of the sections of `F`, and the affine-pair predicate is

  affine-local for quasi-coherent modules (Stacks 00HT,

  `flat_section_of_affine_cover`).'
file: AlgebraicJacobian/Picard/QuotFlatBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CoherentSheafFlat.of_isPullback
type: lean
updated: '2026-07-24T03:02:11'
---
theorem CoherentSheafFlat.of_isPullback
    {X S X' S' : Scheme.{u}} {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (F : X.Modules) (hqc : F.IsQuasicoherent)
    (hF : CoherentSheafFlat f F) :
    CoherentSheafFlat f' ((Scheme.Modules.pullback g').obj F) := by
  haveI := hqc
  haveI : ((Scheme.Modules.pullback g').obj F).IsQuasicoherent :=
    pullback_isQuasicoherent_hom g' F hqc
  -- Per-point charts: an affine piece of the fibre-product square through the
  -- point, over an affine base chart, with flat pulled-back sections.
  have H : ∀ x : X', ∃ (W : X'.Opens) (Ut : S'.Opens),
      IsAffineOpen W ∧ IsAffineOpen Ut ∧ x ∈ W ∧ ∃ (eW : W ≤ f' ⁻¹ᵁ Ut),
        (letI : Module Γ(S', Ut) Γ((Scheme.Modules.pullback g').obj F, W) :=
          Module.compHom _ (f'.appLE Ut W eW).hom
        Module.Flat Γ(S', Ut) Γ((Scheme.Modules.pullback g').obj F, W)) := by
    intro x
    -- the two composites to `S` agree on `x`
    have hbase : f.base (g'.base x) = g.base (f'.base x) := by
      have h := congrArg (fun φ : X' ⟶ S => φ.base x) sq.w
      simpa using h
    -- affine `U ⊆ S` around the common image point
    obtain ⟨U, hU, hsU, -⟩ := exists_isAffineOpen_mem_and_subset
      (TopologicalSpace.Opens.mem_top (f.base (g'.base x)))
    -- affine `V ⊆ f⁻¹U` around `g'(x)`
    obtain ⟨V, hV, hxV, hVsub⟩ := exists_isAffineOpen_mem_and_subset
      (show g'.base x ∈ f ⁻¹ᵁ U from hsU)
    -- affine `Ut ⊆ g⁻¹U` around `f'(x)`
    obtain ⟨Ut, hUt, hxUt, hUtsub⟩ := exists_isAffineOpen_mem_and_subset
      (show f'.base x ∈ g ⁻¹ᵁ U by
        show g.base (f'.base x) ∈ U
        rw [← hbase]; exact hsU)
    have hUSX : V ≤ f ⁻¹ᵁ U := hVsub
    have hUST : Ut ≤ g ⁻¹ᵁ U := hUtsub
    exact ⟨g' ⁻¹ᵁ V ⊓ f' ⁻¹ᵁ Ut, Ut,
      isAffineOpen_pullback_piece sq hUST hUSX hU hUt hV, hUt, ⟨hxV, hxUt⟩,
      inf_le_right,
      flat_section_pullback_piece sq hUST hUSX F hU hUt hV (hF hU hV hUSX)⟩
  choose Wc Uc hWc hUc hmem eWc hflat using H
  -- assemble: chart flatness on an affine cover gives every affine pair
  intro U' hU' V' hV' e
  exact flat_section_of_affine_cover f' ((Scheme.Modules.pullback g').obj F)
    Wc hWc Uc hUc eWc (fun y => ⟨y, hmem y⟩) hflat hU' hV' e