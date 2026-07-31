---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.eq_top_of_retraction_of_isDominant
docstring: '**A dense working `V` in a reduced separated ambient scheme is `⊤`.**


  The retraction `r` is a *left* inverse of `V.ι`; to promote it to a two-sided one
  we need

  `r ≫ V.ι = 𝟙 X`, and that follows from mathlib''s agreement principle

  `ext_of_isDominant`: the two morphisms `r ≫ V.ι` and `𝟙 X` agree after precomposition
  with

  the dominant `V.ι`, and `X` is reduced and separated.  An iso open inclusion is
  surjective on

  points, hence `V = ⊤`.


  `IsDominant V.ι` is exactly density of `V` (mathlib''s `IsDominant` is denseness
  of the range).

  **An earlier version of this docstring hedged that "for an irreducible ambient every
  nonempty

  open is dense — so this is not an exotic side condition", i.e. it asserted the bridge
  in prose

  instead of proving it.  That was understated in the file''s own disfavour: the bridge
  is two

  lines** (`isDominant_opens_ι_of_irreducibleSpace` below), so the hypothesis is not
  density at

  all — it is **irreducibility plus nonemptiness**, which is a property of the chart
  source rather

  than of the candidate open.  `eq_top_of_seam_of_irreducible` states it that way.


  The hypotheses `[IsReduced X]`, `[X.IsSeparated]`, `[IsDominant V.ι]` are all load-bearing
  and

  none is about `pic⁰`: this is a general fact about split-mono open immersions.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.eq_top_of_retraction_of_isDominant
type: lean
updated: '2026-07-31T20:15:27'
---
theorem eq_top_of_retraction_of_isDominant {X : Scheme.{u}} [IsReduced X] [X.IsSeparated]
    (V : X.Opens) [IsDominant (V.ι)]
    (r : X ⟶ (V : Scheme.{u})) (hr : V.ι ≫ r = 𝟙 _) :
    V = ⊤ := by
  haveI : IsIso (V.ι) := by
    refine ⟨r, hr, ?_⟩
    refine ext_of_isDominant (X := X) (Y := X) (W := (V : Scheme.{u})) (V.ι) ?_
    rw [← Category.assoc, hr, Category.id_comp, Category.comp_id]
  have hsurj : Function.Surjective (V.ι).base :=
    (TopCat.homeoOfIso (asIso (Scheme.forgetToTop.map (V.ι)))).surjective
  refine top_le_iff.mp fun x _ => ?_
  obtain ⟨y, rfl⟩ := hsurj x
  exact y.2

variable (C) in