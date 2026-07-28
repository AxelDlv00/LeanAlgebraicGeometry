---
author: sync
content_type: theorem
created: '2026-07-28T18:12:19'
decl: CategoryTheory.hasColimit_permDiagram_iff
docstring: '**The obligation is exactly a `HasColimit`.** Supplying the pair the Albanese

  theorems quantify over is equivalent to the diagram having a colimit — so replacing

  "construct `Sym^n C`" by `HasColimit (permDiagram C n)` neither weakens nor strengthens

  the problem.'
file: AlgebraicJacobian/Albanese/SymPowColimit.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.hasColimit_permDiagram_iff
type: lean
updated: '2026-07-28T18:12:19'
---
theorem hasColimit_permDiagram_iff :
    HasColimit (permDiagram C n) ↔
      ∃ D : SymPowData C n, ∀ σ : Equiv.Perm (Fin n),
        MonObj.permAut C σ ≫ D.proj = D.proj := by
  refine ⟨fun _ => symPowData_of_hasColimit C n, fun ⟨D, hproj⟩ => ?_⟩
  exact ⟨⟨⟨D.cocone C n hproj, D.isColimit C n hproj⟩⟩⟩

end ToColimit

end CategoryTheory

/-! ## §4. The trivial witness is genuinely refuted at `n = 2`

`SymPowInterface.lean` keeps `symPowDataTrivial` (`proj := 𝟙`) as its acceptance test and
states that it fails the symmetry hypothesis for `n ≥ 2` "since it would force
`permAut C σ = 𝟙`". That was an *assertion*: nothing in the tree had exhibited a category
and an object where `permAut` at a transposition really differs from the identity, so the
argument for why the interface is not vacuous rested on an unchecked step.

It is checked here, concretely: `K = Type`, `C = Bool`, `n = 2`, `σ = swap 0 1`. Evaluating
both projections at the tuple `(true, false)` separates them. -/

namespace CategoryTheory

open Limits