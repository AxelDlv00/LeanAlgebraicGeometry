---
author: sync
content_type: theorem
created: '2026-07-19T14:31:14'
decl: AlgebraicGeometry.divQProj
docstring: '**`divQProj`** (worksheet §4.1): the quasi-projectivity bundle of `DivScheme
  g`,

  assembled — the single citable certificate for DAT-G''s quasi-projective charts

  (§4.2 consumer row, with the §4.1 Plücker boundary note).'
file: AlgebraicJacobian/Picard/DivSchemeQProj.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divQProj
type: lean
updated: '2026-07-31T20:14:46'
---
theorem divQProj : DivQProjBundle k A B g r₁ r₂ b₁ b₂ where
  isClosedImmersion_ι := isClosedImmersion_divSchemeι k A B g r₁ r₂ b₁ b₂
  finite_atlasIndex := finite_grPairCover_index k g r₁ g r₂
  isAffine_atlas ij := isAffine_grPairCover_X k g r₁ g r₂ ij
  quasiCompact_pairStructMap := quasiCompact_grPairStructMap k g r₁ g r₂
  locallyOfFiniteType_pairStructMap := locallyOfFiniteType_grPairStructMap k g r₁ g r₂
  isSeparated_pairStructMap := isSeparated_grPairStructMap k g r₁ g r₂
  quasiCompact_hom := quasiCompact_divSchemeOverHom k A B g r₁ r₂ b₁ b₂
  locallyOfFiniteType_hom := locallyOfFiniteType_divSchemeOverHom k A B g r₁ r₂ b₁ b₂
  isSeparated_hom := isSeparated_divSchemeOverHom k A B g r₁ r₂ b₁ b₂