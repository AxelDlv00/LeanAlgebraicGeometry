---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.span_range_gen
file: AlgebraicJacobian/Picard/EntriesIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.span_range_gen
type: lean
updated: '2026-07-29T15:31:46'
---
lemma span_range_gen : Submodule.span R (Set.range (gen R M)) = ⊤ :=
  (Module.Finite.exists_fin (R := R) (M := M)).choose_spec.choose_spec

variable {M} {N : Type u} [AddCommGroup N] [Module R N]
variable (S : Type u) [CommRing S] [Algebra R S]