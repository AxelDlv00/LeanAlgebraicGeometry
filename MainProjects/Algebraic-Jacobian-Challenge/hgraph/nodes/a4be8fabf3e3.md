---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechNervePointIso
docstring: '**The augmentation point of the {\v C}ech nerve is `F`.** The augmentation

  object `(CechNerve 𝒰 F).left` of the {\v C}ech nerve is `(𝟙 X)_* (𝟙 X)^* F` (the

  push–pull functor applied to the terminal `Over X`-object `⟨X, 𝟙 X⟩`), canonically

  isomorphic to `F` via the unitors `pushforwardId`/`pullbackId`. Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechNervePointIso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def cechNervePointIso (𝒰 : X.OpenCover) (F : X.Modules) :
    (CechNerve 𝒰 F).left ≅ F :=
  (Scheme.Modules.pushforwardId X).app ((Scheme.Modules.pullback (𝟙 X)).obj F) ≪≫
    (Scheme.Modules.pullbackId X).app F