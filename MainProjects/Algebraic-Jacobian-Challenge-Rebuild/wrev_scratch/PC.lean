import AlgebraicJacobian.Picard.Pic0ChartCoverageSlice
open CategoryTheory Limits Opposite AlgebraicGeometry MonoidalCategory CartesianMonoidalCategory
universe u
namespace WRev
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
noncomputable section

-- C1. The AFFINE hypothesis is a strict INSTANTIATION of the general-test one: trivial way.
example {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s) :
    ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s :=
  fun Y _ s y => h Y s y

-- C2. SATISFIABILITY of the affine-test hypothesis (a surjective chart route).
example {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) (i : ι)
    (hi : ∀ T : Scheme.{u}ᵒᵖ, Function.Surjective ((f i).app T)) :
    ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s := by
  intro Y _ s y
  obtain ⟨x, hx⟩ := hi (op ((⊤ : Y.Opens) : Scheme.{u}))
    ((pic0SigmaSheaf C).1.map ((⊤ : Y.Opens).ι).op s)
  exact ⟨⊤, trivial, i, x, hx⟩

-- C3. THE FAMILY IS CONSTANT: chartsCoverLocally_of_slice's target family does not depend
-- on the index at all, so `Classical.arbitrary` is harmless AND the atlas is homogeneous.
example {ι : Type u} {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) (i j : ι) :
    (fun _ : ι => abelSigmaChart C π n rep m Z hdeg) i
      = (fun _ : ι => abelSigmaChart C π n rep m Z hdeg) j := rfl

-- C4. The "converse" is the PRE-EXISTING lemma with an IGNORED [IsAffine Y].
example {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ChartsCoverLocally C f) (Y : Scheme.{u}) [IsAffine Y]
    (s : (pic0SigmaSheaf C).1.obj (op Y)) :
    affineLocal_of_chartsCoverLocally C f h Y s
      = pointwise_of_chartsCoverLocally C f h Y s := rfl

end
end WRev
