import AlgebraicJacobian.Albanese.SymPowInvariantsUnder

/-! Check that `hasColimit_singleObj_of_op` is APPLICABLE at the consumer's category.

It was first landed with every universe pinned to `u`, which excludes `Under k`
(`Category.{u, u+1}`) — true but unusable at the one category the Albanese leg needs
(reviewer finding I-0685). This file fails to compile if that regresses. -/

open CategoryTheory Limits AlgebraicGeometry

universe u

-- At `Under k`: the type elaborates, which is what the pinned version could not do.
example (k : CommRingCat.{u}) (G : Type u) [Group G] (F : SingleObj G ⥤ Under k)
    [HasColimit F.op] :
    HasColimit ((Groupoid.invEquivalence (SingleObj G)).functor ⋙ F.op) :=
  hasColimit_singleObj_of_op F

-- And at `(Under k)ᵒᵖ`, the variance the affine statement actually uses.
example (k : CommRingCat.{u}) (G : Type u) [Group G] (F : SingleObj G ⥤ (Under k)ᵒᵖ)
    [HasColimit F.op] :
    HasColimit ((Groupoid.invEquivalence (SingleObj G)).functor ⋙ F.op) :=
  hasColimit_singleObj_of_op F
