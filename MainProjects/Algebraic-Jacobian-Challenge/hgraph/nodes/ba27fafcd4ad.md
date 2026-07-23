---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
docstring: The `Γ`-orbit of a point of `X` under a semilinear action.
file: AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
type: lean
updated: '2026-07-24T03:02:10'
---
def orbit (ρ : SemilinearGalAction K L X f) (x : X) : Set X :=
  Set.range fun γ : L ≃ₐ[K] L => (ρ.act γ).hom.base x

/-- **Orbit-in-affine hypothesis** (campaign `G2`, audit item 8): every `Γ`-orbit is
contained in an affine open.  This hypothesis is **essential** (Hironaka trap — see
the module docstring): without it the quotient exists only as an algebraic space.
For finite Galois `L/K` every orbit is finite, so this is the standard EGA II 4.5.4
hypothesis; it holds e.g. for quasi-projective `X` (finite point sets of
quasi-projective schemes lie in affine opens) and is supplied to the campaign
consumer by the Γ-stable `V_Σ` covers of `J5`. -/
class OrbitsInAffineOpen (ρ : SemilinearGalAction K L X f) : Prop where
  exists_affineOpen (x : X) :
    ∃ U : X.affineOpens, ∀ γ : L ≃ₐ[K] L, (ρ.act γ).hom.base x ∈ U.1