import AlgebraicJacobian.Picard.Pic0ChartLocalSurjectivity

set_option autoImplicit false
set_option maxSynthPendingDepth 3
set_option maxHeartbeats 1000000

universe u
open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

-- Is the BOTTOM sieve ever Zariski-covering? If yes for a NONEMPTY T, the whole
-- local-surjectivity antecedent is vacuous and the seam proves nothing.
-- Expected: covering iff T is empty. Probe the nonempty direction.
example (T : Scheme.{u}) (t : ↥T) (h : (⊥ : Sieve T) ∈ Scheme.zariskiTopology T) : False := by
  obtain ⟨𝒰, hle⟩ := Scheme.mem_grothendieckTopology_iff.mp h
  obtain ⟨i, y, hy⟩ := 𝒰.exists_eq t
  exact (hle (𝒰.X i) (𝒰.f i) (Presieve.ofArrows.mk i)).elim

end AlgebraicGeometry
