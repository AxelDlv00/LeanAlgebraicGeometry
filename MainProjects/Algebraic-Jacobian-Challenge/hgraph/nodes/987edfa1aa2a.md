---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechTerm_pushforward_acyclic
docstring: '**Each Čech term is right-`(f_*)`-acyclic** (blueprint `lem:cech_term_pushforward_acyclic`;

  Stacks `lemma-relative-affine-vanishing`).


  For a quasi-compact separated morphism `f : X ⟶ S` with `X` separated, **`S` separated**
  (see

  the module docstring: the statement is false without an `S`-side hypothesis), and
  a finite

  affine open cover `𝒰` of `X`, every term `(cechComplexOnX 𝒰 F).X p` of the un-augmented
  Čech

  complex on `X` is right-acyclic for the pushforward functor `f_*`.


  `hres` threads the `HasInjectiveResolutions` instances of the intersection subschemes,
  which

  Mathlib cannot yet synthesize (same gap as the `[HasInjectiveResolutions X.Modules]`
  hypothesis

  of the frozen capstone).'
file: AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechTerm_pushforward_acyclic
type: lean
updated: '2026-07-16T21:14:26'
---
lemma cechTerm_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ)
    (hres : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules) :
    (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p) := by
  -- Step 1: the degree-`p` term is (definitionally) the push–pull object of the backbone.
  have hX : (cechComplexOnX 𝒰 F).X p =
      pushPullObj F ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))) := rfl
  rw [hX]
  -- Step 2: each σ-factor is acyclic (composition formula + affine relative Serre vanishing).
  haveI hfac : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      (Scheme.Modules.pushforward f).IsRightAcyclic
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) := by
    intro σ
    haveI := hres σ
    exact pushPullObj_opens_pushforward_acyclic f (coverInterOpen 𝒰 σ)
      (isAffineOpen_coverInterOpen 𝒰 h𝒰 σ) F
      (isQuasicoherent_pullback_opens (coverInterOpen 𝒰 σ) F hF)
  -- Step 3: a finite product of acyclic objects is acyclic; transport along the σ-product
  -- decomposition `pushPull_sigma_iso`.
  haveI : (Scheme.Modules.pushforward f).IsRightAcyclic
      (∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ =>
        pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) :=
    rightAcyclic_finite_prod (Scheme.Modules.pushforward f) _
  exact isRightAcyclic_of_iso (Scheme.Modules.pushforward f) (pushPull_sigma_iso 𝒰 F p).symm