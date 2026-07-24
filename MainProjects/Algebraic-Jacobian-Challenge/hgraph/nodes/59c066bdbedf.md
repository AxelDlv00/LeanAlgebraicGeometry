---
author: sync
content_type: structure
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.QuotFamily
docstring: "A **family of quotients of `E` parametrised by `T`** with Hilbert\npolynomial\
  \ `Φ` (Nitsure §1; the unbundled datum whose equivalence classes\nform the value\
  \ of the Quot functor `def:quot_functor` at `T`):\n\n* a finitely presented sheaf\
  \ of modules `F` on the relative product\n  `X_T = X ×_S T` (the coherence encoding\
  \ of the flattening-stratification\n  input; over the locally noetherian regime\
  \ finite presentation ⟺\n  coherence), flat over `T` and with schematic support\
  \ proper over `T`;\n* an epimorphism `q : E_T ⟶ F` from the pullback of `E` along\
  \ the first\n  projection;\n* at every point `t : T`, the graded Hilbert function\n\
  \  `m ↦ dim_{κ(t)} Γ((X_T)_t, F_t ⊗ L_t^{⊗m})` eventually agrees with `Φ` —\n  by\
  \ `Scheme.hilbertPolynomial_eq_of_eventually` this says exactly that the\n  Hilbert\
  \ polynomial of `F|_{X_t}` relative to `L|_{X_t}`\n  (`def:hilbert_polynomial`)\
  \ *is* `Φ`, and it excludes the junk-value\n  coincidence when no polynomial matches."
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.QuotFamily
type: lean
updated: '2026-07-24T17:02:57'
---
structure QuotFamily (π : X ⟶ S) [LocallyOfFiniteType π] (L E : X.Modules)
    (Φ : Polynomial ℚ) (T : Over S) : Type (u + 1) where
  /-- The quotient sheaf on the relative product `X ×_S T`. -/
  F : (Limits.pullback π T.hom).Modules
  /-- `F` is finitely presented (coherent, in the locally noetherian regime). -/
  isFinitePresentation : F.IsFinitePresentation
  /-- `F` is flat over `T`. -/
  flat : CoherentSheafFlat (pullback.snd π T.hom) F
  /-- The schematic support of `F` is proper over `T`. -/
  properSupport : Modules.HasProperSupport (pullback.snd π T.hom) F
  /-- The quotient map from the pullback of `E`. -/
  q : (Scheme.Modules.pullback (pullback.fst π T.hom)).obj E ⟶ F
  /-- The quotient map is an epimorphism. -/
  epi : Epi q
  /-- At every `t : T`, the graded Hilbert function of the fibre of `F`
  twisted by `L` eventually agrees with `Φ`. -/
  hilb : ∀ t : (T.left : Scheme.{u}), ∃ N : ℕ, ∀ m : ℕ, N < m →
    Φ.eval (m : ℚ) = (hilbertFunction (pullback.snd π T.hom)
      ((Scheme.Modules.pullback (pullback.fst π T.hom)).obj L) F t m : ℚ)

namespace QuotFamily

variable {π : X ⟶ S} [LocallyOfFiniteType π] {L E : X.Modules} {Φ : Polynomial ℚ}

/- The quasi-coherence of the twisting module `L` (part of the line-bundle
hypothesis of `def:quot_functor`) enters only through the base-change
invariance of the fibrewise Hilbert function
(`Scheme.hilbertFunction_quotBaseMap`), i.e. through the pullback action. -/