import Mathlib.Data.Nat.Basic

/-!
# Families of curves

This module records the logical content of the Stacks Project definitions of
prestable, semistable, and stable families of curves.  The type of geometric
fibres is kept abstract so that these definitions can be used before the full
algebraic-space moduli-stack API is available.

The definitions correspond to Stacks tags 0E6T, 0E6Z, and 0E75.
-/

namespace StacksPart08

universe u

/-- The data about a family of curves used by the stability definitions.

`GeometricFiber` indexes the geometric fibres.  The first four fields record
the defining conditions of a family of curves; the remaining fields record the
conditions and invariants used to distinguish prestable, semistable, and stable
families.
-/
structure FamilyOfCurves (GeometricFiber : Type u) where
  isFlat : Prop
  isProper : Prop
  isOfFinitePresentation : Prop
  hasRelativeDimensionAtMostOne : Prop
  atWorstNodalOfRelativeDimensionOne : Prop
  pushforwardStructureSheafUniversallyTrivial : Prop
  genus : GeometricFiber → Nat
  hasRationalTail : GeometricFiber → Prop
  hasRationalBridge : GeometricFiber → Prop

/-- The four conditions defining a family of curves. -/
def FamilyOfCurves.SatisfiesFamilyConditions {GeometricFiber : Type u}
    (f : FamilyOfCurves GeometricFiber) : Prop :=
  f.isFlat ∧ f.isProper ∧ f.isOfFinitePresentation ∧
    f.hasRelativeDimensionAtMostOne

/-- A family of curves is prestable when it is at worst nodal of relative
dimension one and the equality `f_* O_X = O_S` holds universally (Stacks tag
0E6T). -/
def Prestable {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) : Prop :=
  f.atWorstNodalOfRelativeDimensionOne ∧
    f.pushforwardStructureSheafUniversallyTrivial

/-- A prestable family is semistable when every geometric fibre has genus at
least one and has no rational tail (Stacks tag 0E6Z). -/
def Semistable {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) : Prop :=
  Prestable f ∧
    ∀ s, 1 ≤ f.genus s ∧ ¬ f.hasRationalTail s

/-- A prestable family is stable when every geometric fibre has genus at least
two and has neither a rational tail nor a rational bridge (Stacks tag 0E75). -/
def Stable {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) : Prop :=
  Prestable f ∧
    ∀ s, 2 ≤ f.genus s ∧
      ¬ f.hasRationalTail s ∧ ¬ f.hasRationalBridge s

theorem prestable_iff {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) :
    Prestable f ↔
      f.atWorstNodalOfRelativeDimensionOne ∧
        f.pushforwardStructureSheafUniversallyTrivial :=
  Iff.rfl

theorem semistable_iff {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) :
    Semistable f ↔
      Prestable f ∧ (∀ s, 1 ≤ f.genus s ∧ ¬ f.hasRationalTail s) :=
  Iff.rfl

theorem stable_iff {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) :
    Stable f ↔
      Prestable f ∧
        ∀ s, 2 ≤ f.genus s ∧
          ¬ f.hasRationalTail s ∧ ¬ f.hasRationalBridge s :=
  Iff.rfl

/-- Every semistable family is prestable. -/
theorem Semistable.prestable {GeometricFiber : Type u}
    {f : FamilyOfCurves GeometricFiber} (hf : Semistable f) : Prestable f :=
  hf.1

/-- Every stable family is prestable. -/
theorem Stable.prestable {GeometricFiber : Type u}
    {f : FamilyOfCurves GeometricFiber} (hf : Stable f) : Prestable f :=
  hf.1

/-- Every stable family is semistable. -/
theorem Stable.semistable {GeometricFiber : Type u}
    {f : FamilyOfCurves GeometricFiber} (hf : Stable f) : Semistable f := by
  refine ⟨hf.prestable, ?_⟩
  intro s
  exact ⟨le_trans (by decide : 1 ≤ 2) (hf.2 s).1, (hf.2 s).2.1⟩

end StacksPart08
