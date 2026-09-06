/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioProjectiveGluing

/-!
# Independence of the local-ratio projective morphism

Two covering families of regularized local-ratio charts give the same global
projective morphism when they represent the same homogeneous section values.
The chart opens, denominator indices, and regularizations may all differ.
The proof glues the union of the covers, using the cross-family overlap
identity, and compares each original map with this common gluing.
-/

set_option autoImplicit false

universe u v w

open CategoryTheory Limits TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}
variable {ι : Type v} {κ : Type w}

namespace LocalRatioProjectiveGluing

/-- Gluing the same homogeneous sections is independent of the covering
charts, denominator choices, and regularizations.  Equality of section values
is required both within each family and across the two families. -/
theorem gluedFromOpen_eq_of_sameSectionValues
    (a : ι → LocalRatioCoordinateData D n)
    (r : (i : ι) → LocalRatioRegularization (a i))
    (ha : IsOpenCover fun i => (a i).chart.U)
    (haa : ∀ i j, (a i).SameSectionValues (a j))
    (b : κ → LocalRatioCoordinateData D n)
    (s : (j : κ) → LocalRatioRegularization (b j))
    (hb : IsOpenCover fun j => (b j).chart.U)
    (hbb : ∀ i j, (b i).SameSectionValues (b j))
    (hab : ∀ i j, (a i).SameSectionValues (b j)) :
    gluedFromOpen a r ha haa = gluedFromOpen b s hb hbb := by
  let c : ι ⊕ κ → LocalRatioCoordinateData D n := Sum.elim a b
  let t : (q : ι ⊕ κ) → LocalRatioRegularization (c q) := fun q =>
    match q with
    | Sum.inl i => r i
    | Sum.inr j => s j
  have hc : IsOpenCover fun q => (c q).chart.U := by
    change (⨆ q : ι ⊕ κ, (c q).chart.U) = ⊤
    apply top_unique
    rw [← ha]
    exact iSup_le fun i => le_iSup (fun q : ι ⊕ κ => (c q).chart.U) (Sum.inl i)
  have hcc : ∀ p q, (c p).SameSectionValues (c q) := by
    rintro (i | i) (j | j)
    · exact haa i j
    · exact hab i j
    · exact (hab j i).symm
    · exact hbb i j
  have hleft : gluedFromOpen a r ha haa = gluedFromOpen c t hc hcc := by
    apply Scheme.Cover.hom_ext (chartOpenCover a ha)
    intro i
    rw [chartOpenCover_ι_gluedFromOpen_eq_chartMap]
    symm
    exact chartOpenCover_ι_gluedFromOpen_eq_chartMap c t hc hcc (Sum.inl i)
  have hright : gluedFromOpen b s hb hbb = gluedFromOpen c t hc hcc := by
    apply Scheme.Cover.hom_ext (chartOpenCover b hb)
    intro j
    rw [chartOpenCover_ι_gluedFromOpen_eq_chartMap]
    symm
    exact chartOpenCover_ι_gluedFromOpen_eq_chartMap c t hc hcc (Sum.inr j)
  exact hleft.trans hright.symm

end LocalRatioProjectiveGluing

end
end Hartshorne
