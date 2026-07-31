---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEtOfAff
docstring: 'The section of `picEt` over an affine test determined by a plus class
  of the test

  algebra: restrict from the top affine open — the inverse direction of the affine

  comparison.'
file: AlgebraicJacobian/Picard/PicEt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEtOfAff
type: lean
updated: '2026-07-31T20:15:27'
---
def picEtOfAff : PicEtAff C A →* picEt C (overSpec k A) where
  toFun x :=
    ⟨fun U => PicEtAff.mapAlg C
      ((Over.resAlgHom (overSpec k A) le_top).comp
        (Over.overSpecΓTopAlgEquiv k A).symm.toAlgHom) x,
      fun U V h => by rw [← PicEtAff.mapAlg_comp, ← AlgHom.comp_assoc,
        Over.resAlgHom_comp]⟩
  map_one' := picEt.ext fun U => map_one (PicEtAff.mapAlg C _)
  map_mul' x y := picEt.ext fun U => map_mul (PicEtAff.mapAlg C _) x y