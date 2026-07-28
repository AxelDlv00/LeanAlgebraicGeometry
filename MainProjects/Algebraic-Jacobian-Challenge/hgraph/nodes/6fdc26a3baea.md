---
author: sync
content_type: theorem
created: '2026-07-29T06:43:22'
decl: AlgebraicGeometry.Scheme.Pic0.topologicalKrullDim_eq_genus_of_forall_finrank_cotangentSpace_le
docstring: "**`dim Pic⁰_{C/k} = g(C)` with both halves in cotangent currency.**\n\n\
  The two directions and their genuinely different costs, now visible in one statement:\n\
  \n* `≤` consumes `hle`, a uniform bound on the embedding dimension at every point,\
  \ and\n  converts it with no side conditions at all;\n* `≥` consumes regularity\
  \ of the **single** stalk at the identity, which is\n  irreducible — an embedding\
  \ dimension bounds the Krull dimension from below only at a\n  regular point (at\
  \ a cusp it exceeds it) — together with the tangent-space identity\n  `Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`,\
  \ which supplies the value `g(C)`\n  there and is front (a) of this chapter, still\
  \ open.\n\nCompare `topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le`:\
  \ that version\ncarries `[PerfectField k]`, because it discharges regularity from\
  \ smoothness through\n`Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField`,\
  \ whose own upstream input\ncarries the binder irremovably. This version takes regularity\
  \ at the identity as a\nhypothesis instead and so is stated over an **arbitrary**\
  \ field — which is what the\nstanding owner decision (inbox I-0491) requires of\
  \ this leg. A caller over a perfect\nfield can still discharge `hreg` from smoothness\
  \ by that route.\n\nMEASURE BEFORE QUOTING: like everything downstream of front\
  \ (a), this reports\n`sorryAx` at the full root through the tangent-space identity.\
  \ The dimension\nmachinery it rests on (`Picard/EmbeddingDimensionBound.lean`,\n\
  `Picard/SchemeKrullDimStalk.lean`) is axiom-clean."
file: AlgebraicJacobian/Picard/Pic0Dimension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.topologicalKrullDim_eq_genus_of_forall_finrank_cotangentSpace_le
type: lean
updated: '2026-07-29T06:43:22'
---
theorem topologicalKrullDim_eq_genus_of_forall_finrank_cotangentSpace_le
    {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hle : ∀ z : (Pic0Scheme C).left,
      Module.finrank (IsLocalRing.ResidueField ((Pic0Scheme C).left.presheaf.stalk z))
        (IsLocalRing.CotangentSpace ((Pic0Scheme C).left.presheaf.stalk z))
          ≤ AlgebraicGeometry.genus C)
    (hreg : IsRegularLocalRing ((Pic0Scheme C).left.presheaf.stalk
      ((identitySection C).base default))) :
    topologicalKrullDim (Pic0Scheme C).left
      = ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞) :=
  le_antisymm (topologicalKrullDim_le_genus_of_forall_finrank_cotangentSpace_le C hle)
    (genus_le_topologicalKrullDim_of_isRegular C hreg)