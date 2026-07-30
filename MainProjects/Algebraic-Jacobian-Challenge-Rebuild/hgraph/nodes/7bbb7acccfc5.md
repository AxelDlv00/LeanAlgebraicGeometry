---
author: sync
content_type: theorem
created: '2026-07-20T02:31:15'
decl: AlgebraicGeometry.isClosed_sdiff_basicOpen_of_closure_subset
docstring: '**The closed-trace from an empty leak**: the trace `V \ D(g)` of the vanishing
  locus of

  a section `g` on an open `V` is closed in the whole scheme as soon as its closure
  stays

  inside `V`.  (The other inclusion, `closure (V \ D(g)) ⊆ (D(g))ᶜ`, is automatic
  since

  `V \ D(g)` already lies in the closed set `(D(g))ᶜ`.)'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivColFin.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isClosed_sdiff_basicOpen_of_closure_subset
type: lean
updated: '2026-07-30T15:28:00'
---
theorem isClosed_sdiff_basicOpen_of_closure_subset {X : Scheme.{u}} {V : X.Opens}
    (g : Γ(X, V))
    (hcl : closure ((V : Set X) \ (X.basicOpen g : Set X)) ⊆ (V : Set X)) :
    IsClosed ((V : Set X) \ (X.basicOpen g : Set X)) := by
  apply isClosed_of_closure_subset
  intro x hx
  refine ⟨hcl hx, ?_⟩
  exact closure_minimal (fun _ h => h.2) (X.basicOpen g).isOpen.isClosed_compl hx