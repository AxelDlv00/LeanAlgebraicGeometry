---
author: sync
content_type: theorem
created: '2026-07-30T11:09:46'
decl: Pr.uniqueUpToIso_hom_eq
file: probe_p4_mul.lean
generated: lean
lean_status: lean_ok
stale: true
title: Pr.uniqueUpToIso_hom_eq
type: lean
updated: '2026-07-31T02:29:54'
---
theorem uniqueUpToIso_hom_eq {C : Type u} [Category.{u} C] {F : Cᵒᵖ ⥤ Type u} {Y Z : C}
    (e : F.RepresentableBy Y) (e' : F.RepresentableBy Z) :
    (e.uniqueUpToIso e').hom = e'.homEquiv.symm (e.homEquiv (𝟙 Y)) := rfl