---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular
docstring: "**A dimension computation entirely in cotangent currency.** A uniform\
  \ bound\n`dim_κ (m_z/m_z²) ≤ d` at every point, together with **one** point `z₀`\
  \ that is\nregular and has cotangent dimension exactly `d`, gives `dim X = d`.\n\
  \nThe asymmetry between the two hypotheses is the mathematics, not an artefact:\n\
  \n* the `≤` half is unconditional (`ringKrullDim_le_finrank_cotangentSpace`);\n\
  * the `≥` half needs `z₀` **regular**, since it converts an embedding dimension\
  \ into\n  a lower bound on the Krull dimension, and without regularity that is false\
  \ — at a\n  cusp the embedding dimension exceeds the dimension.\n\nFor `Pic⁰_{C/k}`\
  \ the distinguished point is the identity, where the tangent-space\nidentity of\
  \ this chapter supplies `d = g(C)`."
file: AlgebraicJacobian/Picard/EmbeddingDimensionBound.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular
type: lean
updated: '2026-07-29T04:25:58'
---
theorem topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular
    (X : Scheme.{u}) [IsLocallyNoetherian X] (d : ℕ)
    (h : ∀ z : X, Module.finrank (ResidueField (X.presheaf.stalk z))
      (CotangentSpace (X.presheaf.stalk z)) ≤ d)
    (z₀ : X) (hreg : IsRegularLocalRing (X.presheaf.stalk z₀))
    (hz₀ : Module.finrank (ResidueField (X.presheaf.stalk z₀))
      (CotangentSpace (X.presheaf.stalk z₀)) = d) :
    topologicalKrullDim X = (d : WithBot ℕ∞) :=
  le_antisymm (topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le X d h)
    (le_topologicalKrullDim_of_finrank_cotangentSpace X d z₀ hreg hz₀)