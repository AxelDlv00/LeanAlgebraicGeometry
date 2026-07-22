---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.gluedEquivVanishing
docstring: '**THE JUNCTION EQUIVALENCE** (`informal/spec-dd-r.md` §3 item 4, the probed
  seam):

  the global sections of the theta-ideal datum sheaf are `R`-linearly the vanishing

  submodule `K_a(d) = H⁰(𝒪(Θᵃ − d))` — DD-1''s carrier vocabulary meets the engine''s
  glued

  sheaf, mutually inverse by uniqueness of cofactors over the regular equations.'
file: AlgebraicJacobian/Picard/DivSchemeCertificateEngine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedEquivVanishing
type: lean
updated: '2026-07-17T16:57:13'
---
noncomputable def gluedEquivVanishing :
    A.ThetaIdealSections a ⊤ ≃ₗ[R]
      ↥(d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
        (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a)) :=
  { gluedToVanishingₗ A a with
    invFun := vanishingToGlued A a
    left_inv := vanishingToGlued_gluedToVanishing
    right_inv := gluedToVanishing_vanishingToGlued }

variable (A a) in