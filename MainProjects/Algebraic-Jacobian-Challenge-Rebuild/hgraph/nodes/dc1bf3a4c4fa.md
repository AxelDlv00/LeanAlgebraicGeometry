---
author: sync
content_type: theorem
created: '2026-07-30T07:28:28'
decl: AlgebraicGeometry.subsingleton_h1_of_ledger_bound
docstring: '**THE THRESHOLD AT AN ARBITRARY SPLITTING FIELD, PI-FREE AND UNIFORM.**


  Every divisor on `relCurve C L` whose degree is at least

  `windowM_choice π hπ g * windowδ π + g` has vanishing `H¹` — for **every** field
  extension

  `L/k`, with the same bound.


  Read the bound: `windowM_choice π hπ g` and `windowδ π` are ledger constants of
  the *base*

  field, so `L` occurs nowhere in it.  That is what makes this uniform, and it is
  the fact the

  coverage layer''s pricing of its own residue assumed to be unavailable

  (`Pic0ChartCoverageIndexSlack.lean` item 3, `Pic0ChartCoverageNoDrop.lean`''s retraction:
  both

  treat DAT-0a''s threshold at `L` as a per-`L` quantity still to be obtained).


  The route uses **no** `π` at the extension.  **The clause that used to follow here
  — "which is

  why it exists at all: DAT-0a needs a finite dominant `relCurve C L ⟶ P1 L` and this
  tree has

  none" — is RETRACTED** (see the module docstring): the tree does produce one, via

  `exists_isFinite_isDominant_toP1` plus the `baseChangeBundle` instances, so DAT-0a
  *is*

  instantiable at `L` and being π-free is a convenience here rather than a necessity.  See
  also

  the re-derivation notice: this statement is a weaker corollary of the landed

  `subsingleton_h1_of_windowA_le_deg`.  Concretely,

  `subsingleton_hModule_one_of_witness` peels from a single witness, and the witness
  is the

  transported window divisor `windowN C L hπ g` whose vanishing is `subsingleton_h1_windowN`

  and whose degree is `M·δ` (`deg_windowN`).  The χ at `L` is the base normalization

  transported by `chi_relCurve`.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageThreshold.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_h1_of_ledger_bound
type: lean
updated: '2026-07-30T07:40:56'
---
theorem subsingleton_h1_of_ledger_bound {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (L : Type u) [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (D : (relCurve C L).CurveDivisor)
    (hD : (windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ)
      ≤ Scheme.CurveDivisor.deg L D) :
    Subsingleton (Sheaf.HModule ((relCurve C L).divisorSheaf L D) 1) := by
  refine subsingleton_hModule_one_of_witness L (windowN C L hπ g) D
    (subsingleton_h1_windowN C L hπ g) ?_
  rw [deg_windowN, chi_relCurve (n := g) hχ L]
  linarith