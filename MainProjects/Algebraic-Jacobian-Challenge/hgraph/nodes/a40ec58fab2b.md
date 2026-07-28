---
author: sync
content_type: structure
created: '2026-07-28T15:48:27'
decl: is
file: AlgebraicJacobian/RiemannRoch/Ledger/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: is
type: lean
updated: '2026-07-28T23:31:36'
---
  structure is carried by the explicit defs `Scheme.overAlgebraMap`/`Scheme.overModule`
  and, where needed, `attribute [local instance] Scheme.overModule`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace CategoryTheory

namespace Sheaf

variable {C : Type u} [SmallCategory C]

section HModule

variable (J : GrothendieckTopology C) (R : Type u) [CommRing R]
  [HasSheafify J (ModuleCat.{u} R)]