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

-- P2a: is (divSchemeOver ...).left literally DivScheme ...?
example : (divSchemeOver k A B g r₁ r₂ b₁ b₂).left = DivScheme k A B g r₁ r₂ b₁ b₂ := rfl

-- P2b: is abelOfPic0Class_left the SAME shape as a pure tautology? Test: does the
-- statement hold with `Eq.refl` for ANY function of rep,lam (i.e. no content used)?
example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)) :
    (abelOfPic0Class rep lam).left
      = ((rep.homEquiv.symm lam : divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J)).left :=
  Eq.refl _

-- P2c: THE REAL CLAIM -- does ofAbelImage accept it as `abel`?
noncomputable example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hs : Function.Surjective (abelOfPic0Class rep lam).left.base) : JacobianData C :=
  JacobianData.ofAbelImage C J rep hlft
    (A := A) (B := B) (g := g) (b₁ := b₁) (b₂ := b₂) (abelOfPic0Class rep lam).left hs

-- P2d: CONVERSE of the headline -- a slice-level abel GIVES a lam, so (lam,hcl) and
-- (slice abel, slice hlift) are the same package, not a discount.
noncomputable example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (abel : divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J) :
    { lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂) //
        abelOfPic0Class rep lam = abel } :=
  ⟨rep.homEquiv abel, by rw [abelOfPic0Class, Equiv.symm_apply_apply]⟩

-- P2e: hcl is INTERDERIVABLE with the morphism-level slice lift (so "classes only" is
-- a change of coordinates, not a weaker hypothesis).
example {J : Over (Spec (.of k))} (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)) (y : J.left)
    (q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂)
    (hmor : q ≫ abelOfPic0Class rep lam = Over.testPoint y) :
    pic0Map C q lam = rep.homEquiv (Over.testPoint y) := by
  rw [← abelOfPic0Class_comp_class rep lam q, hmor]
end Probe
