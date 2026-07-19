/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeSeedUnivBridge
import AlgebraicJacobian.Picard.DivSchemeSeedUnivAssembleKappa
import AlgebraicJacobian.Picard.DivSchemeFamily
import AlgebraicJacobian.Picard.DivSchemeRelDivisor

/-!
# G-4 — the universal theta generator seed `seedUniv` (I-0278 decomposition)

The pointwise assembly of the universal `ThetaGeneratorSeed` over the `Z(♦)`-chart ring
`R_Z = DivCarveChartRing k A B g r₁ r₂ b₁ b₂ i j` at the embedding window `K_univ`.  Per
I-0278, `ThetaGeneratorSeed` has five *pointwise* fields (`side`/`h`/`mem_basicOpen`/`sec`/
`sec_mem`) with no global-consistency constraint, so the seed is a **pointwise
classical-choice construction** over the three geometric sub-lemmas landed here:

* `exists_mem_relPinnedChart` — **(a) the two-chart cover**: every point of the relative
  curve lies in one of the two pinned charts (`relCover_sup`);
* `divUniversalFibreKM_ne_bot_seedPrime` — the fibre window at every seed-base prime is
  nonzero (`finrank_divUniversalFibreKM_add` + `deg N ≥ 2g` Riemann–Roch), the `≠ ⊥`
  input the seed-prime bridge consumes;
* `exists_sec_windowCompare_ne_zero_seedPrime` — **(b) the seed section**: at every prime
  a window vector with nonzero fibre comparison whose window image lies in `K_univ`
  (the landed seed-prime bridge of `Picard/DivSchemeSeedUnivBridge.lean`);
* `exists_h_mem_basicOpen_windowCompare` — **(c) the base→curve shrink**: a chart section
  `h` with `z ∈ D(h)` cut out as the base-open pullback of a `windowCompare`-surviving
  base element (`exists_forall_windowCompare_ne_zero` + `notMem_basePrime_iff`);
* `seedUniv` — the assembled seed via `Classical.choose` per point.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian

/-! ## (a) The two-chart cover of the relative curve -/

section Cover

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π]

/-- **(a) The two-chart cover** (I-0278 sub-lemma (a)): every point of the relative curve
`C_R` lies in one of the two pinned charts `relPinnedChart C R π b` (`b : Bool`).  Immediate
from `relCover_sup` (`V₀ ⊔ V₁ = ⊤`): the pinned charts are exactly `V₀`/`V₁`, and their
join is the whole curve. -/
theorem exists_mem_relPinnedChart (z : relCurve C R) :
    ∃ b : Bool, z ∈ relPinnedChart C R π b := by
  have hz : z ∈ (relPinnedChart C R π false ⊔ relPinnedChart C R π true) := by
    rw [relPinnedChart_false, relPinnedChart_true, relCover_sup]
    exact TopologicalSpace.Opens.mem_top z
  rcases (TopologicalSpace.Opens.mem_sup).mp hz with h | h
  · exact ⟨false, h⟩
  · exact ⟨true, h⟩

end Cover

end AlgebraicGeometry
