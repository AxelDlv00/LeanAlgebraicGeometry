---
author: sync
content_type: theorem
created: '2026-07-29T06:43:22'
decl: AlgebraicGeometry.Scheme.Pic0.genus_le_topologicalKrullDim_of_isRegular
docstring: "**The genus is a LOWER bound for the dimension of `Pic⁰_{C/k}`** — a\n\
  *reduction*, not an axiom-clean theorem: see the measurement note below.\n\n**MEASURED\
  \ (`#print axioms`, full-root import): this reports `sorryAx`.** It\nconsumes `Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`,\
  \ which is gated on\nthe open cocycle comparison\n`Pic0.semilinearComparison_cotangentSpaceDual_h1Cok`\n\
  (`Picard/Pic0AbelianVariety.lean:805`, front (a) of this chapter). So the honest\n\
  reading is: the dimension inequality needs **nothing beyond** the tangent-space\n\
  identity plus regularity at one point — no new geometry, no quantifier over\npoints\
  \ — but the tangent-space identity is itself not yet closed. Everything in\n`Picard/SchemeKrullDimStalk.lean`\
  \ that this rests on *is* axiom-clean; the leak is\ninherited from front (a) alone.\n\
  \nThis is the half of Milne III.1 Rmk 1.4(e) that the tangent-space computation\n\
  gives away for free, and it needs data at **one** point:\n\n* `Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`\
  \ computes\n  `dim_{κ(e)} m_e/m_e² = dim_k H¹(C, \U0001D4AA_C) = g(C)` at the identity;\n\
  * at a regular point `IsRegularLocalRing.iff_finrank_cotangentSpace` turns that\n\
  \  into `dim \U0001D4AA_{Pic⁰, e} = g(C)`;\n* and a stalk's dimension is at most\
  \ the dimension of the scheme\n  (`ringKrullDim_stalk_le_topologicalKrullDim`, from\n\
  \  `Picard/SchemeKrullDimStalk.lean`).\n\nNote what is *not* needed: no quantifier\
  \ over the points of `Pic⁰`, no smoothness\nof `Pic⁰` (only regularity at `e`),\
  \ and no affine-local presentation — the\nrecorded route through `Algebra.IsStandardSmoothOfRelativeDimension`\
  \ is not\ntaken."
file: AlgebraicJacobian/Picard/Pic0Dimension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.genus_le_topologicalKrullDim_of_isRegular
type: lean
updated: '2026-07-29T06:43:22'
---
theorem genus_le_topologicalKrullDim_of_isRegular {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hreg : IsRegularLocalRing ((Pic0Scheme C).left.presheaf.stalk
      ((identitySection C).base default))) :
    ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞)
      ≤ topologicalKrullDim (Pic0Scheme C).left :=
  le_topologicalKrullDim_of_finrank_cotangentSpace _ _ _ hreg
    (finrank_cotangentSpace_eq_finrank_hModuleOne C)