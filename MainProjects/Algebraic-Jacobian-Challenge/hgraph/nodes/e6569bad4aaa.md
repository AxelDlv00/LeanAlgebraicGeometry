---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.coordSection
docstring: '**The coordinate global section** `x_j ∈ Γ(Proj ℤ[Xᵢ], O(1))`: the section
  given

  on each chart `D₊(Xᵢ)` by `Xⱼ/Xᵢ`, the image of the degree-one form `Xⱼ` under the

  compatible-family identification `serreTwistSectionsCompatible`.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.coordSection
type: lean
updated: '2026-07-24T03:02:12'
---
def coordSection (j : n₀) : Γ(serreTwist n₀ 1, ⊤) :=
  (serreTwistSectionsCompatible n₀ 1).symm
    ⟨formFamily 1 ⟨X j, X_mem_deg_one n₀ j⟩, formFamily_mem 1 ⟨X j, X_mem_deg_one n₀ j⟩⟩

set_option backward.isDefEq.respectTransparency false in