import AlgebraicJacobian.Picard.JacobianDataQcFromRep
open AlgebraicGeometry CategoryTheory
universe u
namespace Probe
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
variable {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
variable {A B : X.CurveDivisor} {g r₁ r₂ : ℕ}
variable {b₁ : Module.Basis (Fin r₁) k ↥(Scheme.divisorSections k B ⊤)}
variable {b₂ : Module.Basis (Fin r₂) k ↥(Scheme.divisorSections k (A + B) ⊤)}

-- P3a: CONVERSE: a slice-level abel is abelOfPic0Class of its own class. So the "lam"
-- coordinate and the "slice abel" coordinate carry exactly the same information.
noncomputable example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (abel : divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J) :
    abelOfPic0Class rep (rep.homEquiv abel) = abel :=
  rep.homEquiv.symm_apply_apply abel

-- P3b: FULL round trip: (lam, hcl) <-> (slice abel, slice per-point lift). Both directions.
example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (abel : divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J)
    (hlift : ∀ y : J.left, ∃ q : overSpec k (Over.testPointField y) ⟶
        divSchemeOver k A B g r₁ r₂ b₁ b₂, q ≫ abel = Over.testPoint y) :
    ∀ y : J.left, ∃ q : overSpec k (Over.testPointField y) ⟶
        divSchemeOver k A B g r₁ r₂ b₁ b₂,
      pic0Map C q (rep.homEquiv abel) = rep.homEquiv (Over.testPoint y) := by
  intro y
  obtain ⟨q, hq⟩ := hlift y
  refine ⟨q, ?_⟩
  rw [← abelOfPic0Class_comp_class rep (rep.homEquiv abel) q,
    rep.homEquiv.symm_apply_apply abel] at *
  rw [hq]

-- P3c: does the file's hcl even IMPLY the ofAbelLifts hlift at the SCHEME level, i.e. is
-- the sourced Spec κ(y) the ofAbelLifts source?  (residueField_lift_of_pic0_class claims so)
noncomputable example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hcl : ∀ y : J.left, ∃ q : overSpec k (Over.testPointField y) ⟶
        divSchemeOver k A B g r₁ r₂ b₁ b₂,
      pic0Map C q lam = rep.homEquiv (Over.testPoint y)) : JacobianData C :=
  JacobianData.ofAbelLifts C J rep hlft (abelOfPic0Class rep lam).left
    (residueField_lift_of_pic0_class rep lam hcl)

-- P3d: extension-tolerant vs kappa-pinned: is the tolerant form derivable FROM pinned
-- (claimed), and is the reverse blocked?  Test the reverse is NOT provable by this route:
-- instead check what tolerant gives: does it give any Spec κ(y)-sourced lift? (should fail)
-- P3e: VACUITY at empty J.left: hcl is trivially true, and the conclusion is then also free.
example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hempty : IsEmpty J.left) :
    ∀ y : J.left, ∃ q : overSpec k (Over.testPointField y) ⟶
        divSchemeOver k A B g r₁ r₂ b₁ b₂,
      pic0Map C q lam = rep.homEquiv (Over.testPoint y) :=
  fun y => absurd y hempty.elim
end Probe
