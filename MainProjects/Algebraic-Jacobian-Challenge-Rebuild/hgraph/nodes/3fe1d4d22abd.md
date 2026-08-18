---
author: sync
content_type: lemma
created: '2026-08-02T04:08:39'
decl: AlgebraicGeometry.chi_relCurve_affWindowGen
file: AlgebraicJacobian/Picard/DivisorFamilyAffWindowGen.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.chi_relCurve_affWindowGen
type: lean
updated: '2026-08-18T20:51:01'
---
private lemma chi_relCurve_affWindowGen (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (K : Type u) [Field K] [Algebra k K] :
    Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ) := by
  haveI : IsProper (baseChangeBundle C K).hom := instIsProperSndLeft C K
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C K).hom :=
    instSmoothOfRelativeDimensionSndLeft C K
  haveI : GeometricallyIrreducible (baseChangeBundle C K).hom :=
    instGeometricallyIrreducibleSndLeft C K
  have h1 : Sheaf.chi ((relCurve C K).moduleKSheaf K)
      = 1 - (genus (baseChangeBundle C K) : ℤ) := chi_moduleKSheaf (baseChangeBundle C K)
  have h2 : genus (baseChangeBundle C K) = genus C := genus_baseField C K
  have h3 : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (genus C : ℤ) := chi_moduleKSheaf C
  have h4 : (genus C : ℤ) = (g : ℤ) := by rw [h3] at hχ; linarith
  rw [h1, h2, h4]

variable (R) in