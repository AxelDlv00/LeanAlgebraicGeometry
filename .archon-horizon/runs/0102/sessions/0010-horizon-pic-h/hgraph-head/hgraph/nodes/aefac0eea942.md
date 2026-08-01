---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.relSectionsBaseChange_mul_fiberCoord₁
docstring: (Implementation) Chart-1 twin of `relSectionsBaseChange_mul_fiberCoord₀`.
file: AlgebraicJacobian/Cohomology/RigidEngine4Relative.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.relSectionsBaseChange_mul_fiberCoord₁
type: lean
updated: '2026-08-01T09:44:10'
---
private lemma relSectionsBaseChange_mul_fiberCoord₁ [IsAffineHom π] (a : R)
    (s : Γ(C.left, fiberChart₁ π)) :
    relSectionsBaseChange C R (isAffineOpen_preimage_chartOpen π 1).isCompact
        (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated
        (a ⊗ₜ[k] (fiberCoord₁ π * s))
      = relPullbackSection C R (fiberChart₁ π) (fiberCoord₁ π) *
          relSectionsBaseChange C R (isAffineOpen_preimage_chartOpen π 1).isCompact
            (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated (a ⊗ₜ[k] s) := by
  rw [relSectionsBaseChange_tmul, relSectionsBaseChange_tmul, relPullbackSection_mul]
  ring