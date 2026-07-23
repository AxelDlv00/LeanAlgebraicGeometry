---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX
docstring: '**The `f_*`-image of the un-augmented Čech complex on `X` is isomorphic
  to the relative Čech

  complex** (blueprint `lem:pushforward_mapHC_cechComplexOnX`).'
file: AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def pushforward_mapHomologicalComplex_cechComplexOnX
    (f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) :
    ((Scheme.Modules.pushforward f).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (cechComplexOnX 𝒰 F) ≅ CechComplex f 𝒰 F :=
  -- `cechComplexOnX` and `CechComplex` are *definitionally* the alternating coface complexes of
  -- the (un-whiskered, resp. `f_*`-whiskered) underlying cosimplicial object of the Čech nerve,
  -- so the general helper applies on the nose.
  mapAlternatingCofaceMapComplexIso (Scheme.Modules.pushforward f)
    (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))

/-! ## From augmented exactness to the acyclic-resolution input data -/

/- Planner strategy: lem:cechAugmented_to_acyclicResolutionInput ·
From `cechAugmented_exact` (CechAugmentedResolution.lean) we have:
  `∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)`.
The augmented complex has `X 0 = F` and `X (n+1) = (cechComplexOnX 𝒰 F).X n`; its differential at
degree 0 is the augmentation `ε : F → C⁰`.

(1) Exactness of `cechComplexOnX 𝒰 F` at degree `n+1`:  the augmented complex at degree `n+2`
    coincides with the un-augmented complex at degree `n+1`.  Use
    `HomologicalComplex.exactAt_iff_isZero_homology` plus the vanishing from `cechAugmented_exact`.

(2) Iso `e : F ≅ (cechComplexOnX 𝒰 F).cycles 0`:  vanishing of homology at degree 0 gives that
    ε is a monomorphism; vanishing at degree 1 gives that the image of ε equals `ker d⁰ = cycles 0`.
    Hence ε is an iso onto `cycles 0`.  The iso is assembled from the augmentation `cechAugmentation`
    and the exactness data; use `ShortComplex.Exact.isoOfEpiMonoIsZero` or similar.

Both outputs are assembled into a `PProd` (anonymous constructor `⟨e, hexact⟩`; `PProd` rather
than `Prod` because the second component is a `Prop` while the first is an `Iso` in `Type`). -/
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 4000000 in