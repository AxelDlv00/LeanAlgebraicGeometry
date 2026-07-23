---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.sliceOversEquiv
docstring: The slice equivalence `Over Uᵢ ≌ Over Vᵢ` (`Vᵢ = φ.inv⁻¹ᵁ Uᵢ`).
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sliceOversEquiv
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def sliceOversEquiv :
    CategoryTheory.Over Ui ≌ CategoryTheory.Over (φ.inv ⁻¹ᵁ Ui) :=
  CategoryTheory.Over.postEquiv Ui (opensEquivOfIso φ)