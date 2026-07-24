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
updated: '2026-07-24T18:32:28'
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