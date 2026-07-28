---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicScheme.degree
docstring: 'The **degree map** `Pic_{C/k}(k) → ℤ`.


  Sends a `k`-point `λ ∈ Pic_{C/k}(k)` --- a morphism

  `Spec k ⟶ (PicScheme C).left` --- to the leading coefficient of the

  Hilbert polynomial of a representing invertible sheaf `L` on `C` (relative

  to a fixed degree-one polarisation `O_C(1)`). By Riemann--Roch,

  `χ(C, L ⊗ O_C(n)) = n · deg L + 1 - g`, so the degree is the leading

  coefficient of `Φ_L(n)`, well-defined on the isomorphism class `[L]` and on

  the `k`-point `λ` (because `PicScheme C` represents the étale-sheafified

  relative Picard functor).


  The degree map is a group homomorphism from the additive structure on

  `Pic_{C/k}(k)` (tensor product on `L`) to `(ℤ, +)`; only the underlying

  function is stated here, the homomorphism property and the functoriality in

  `k` being left to separate lemmas.


  ROUTE CHANGE (run 0067). The construction is not the *Quot* obligation the original

  docstring described, and the difference matters because Quot is retained-not-revived
  in this

  project. Representability already transports a `k`-rational point to a relative
  Picard class

  over the base (`classOfSection`, sorry-free), so no Hilbert polynomial and no representing

  sheaf extraction is needed — only a degree homomorphism on those classes, which
  is

  `ClassDegreePinned`.


  **CLOSED (run 0067 r4), and the docstring this replaces was wrong on a point of
  fact.**

  It read: "A total function of that type therefore cannot be built from the Picard
  functor at

  all; it would have to invent a value off the sections." The first clause does not
  follow from

  the second. Inventing a value off the sections is exactly what a total function
  of this type

  is *permitted* to do, and `fun _ => 0` already witnesses that the type is inhabited
  — so

  "cannot be built" was never true, and a `sorry` is not the honest encoding of "the
  domain is

  wrong".


  What IS true is the observation the old note was reaching for: a morphism

  `Spec k ⟶ (PicScheme C).left` need not satisfy `lambda ≫ (PicScheme C).hom = 𝟙`,
  so it need

  not name a `k`-*rational* point, and representability says nothing about it. That
  is a

  statement about which values are *pinned*, not about totality. So the construction
  below

  splits on precisely that condition:


  * on sections it is `degreeOfSectionPinned`, i.e. *the* degree, pinned against the
  Abel map;

  * off them it is `0`, an arbitrary choice that no consumer may rely on.


  `degree_eq_degreeOfSectionPinned` below records the first half as an equation, so
  the value

  on the rational points — the only place the classical degree map is defined — is
  determined

  rather than chosen. Consumers should still prefer `degreeOfSectionPinned`, which
  carries the

  section hypothesis in its type and therefore cannot be misread; `degree` exists
  because

  `kPoints_iff_kerDegree` is stated against it, and it now has a body rather than
  a `sorry`.


  The `[ClassDegreePinned C]` binder is new and is what makes the pinned half meaningful;
  the

  unpinned `ClassDegree` would have permitted the zero homomorphism (see its docstring).'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.degree
type: lean
updated: '2026-07-28T20:09:57'
---
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] [ClassDegreePinned C] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  fun lambda =>
    if h : lambda ≫ (PicScheme C).hom = 𝟙 (Spec (.of k)) then
      degreeOfSectionPinned C lambda h
    else 0