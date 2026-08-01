---
author: sync
content_type: definition
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.VV
file: scratch_p4r6_audit/p13_scheme_ce.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.VV
type: lean
updated: '2026-08-01T11:45:16'
---
noncomputable def VV : (XX R).Opens := (coprod.inl : Spec R ⟶ XX R).opensRange

#check @Scheme.Hom.opensRange
example : IsOpenImmersion (coprod.inl : Spec R ⟶ XX R) := inferInstance
example : IsReduced (XX R) := inferInstance
example : (XX R).IsSeparated := inferInstance