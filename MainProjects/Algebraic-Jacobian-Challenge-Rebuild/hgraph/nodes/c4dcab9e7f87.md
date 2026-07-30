---
author: sync
content_type: definition
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.Scheme.twistGermSet
docstring: '**The germ set of a set of twisted pairs at a point**: the germs at `z`
  of the chart

  components of the members of `T`, on whichever pinned chart(s) contain `z`.  For

  `T = ` (the image of) a divisor-family window this is the set whose span the DDR-8

  bridge shows to be the full stalk ideal.'
file: AlgebraicJacobian/Picard/DivSchemeMonoBridge.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.twistGermSet
type: lean
updated: '2026-07-30T15:28:03'
---
def Scheme.twistGermSet (T : Set ↥(twistSubmodule A V₀ V₁ gc ⊤)) (z : X) :
    Set (X.presheaf.stalk z) :=
  {a | ∃ (x : ↥(twistSubmodule A V₀ V₁ gc ⊤)) (_ : x ∈ T) (hz₀ : z ∈ ⊤ ⊓ V₀),
      a = (X.presheaf.germ (⊤ ⊓ V₀) z hz₀).hom x.val.1} ∪
  {a | ∃ (x : ↥(twistSubmodule A V₀ V₁ gc ⊤)) (_ : x ∈ T) (hz₁ : z ∈ ⊤ ⊓ V₁),
      a = (X.presheaf.germ (⊤ ⊓ V₁) z hz₁).hom x.val.2}