---
author: sync
content_type: theorem
created: '2026-08-01T12:39:19'
decl: AlgebraicGeometry.Scheme.Grassmannian.homEquiv_eq_pullback_universalQuotient
docstring: 'Every point of the chosen representing scheme classifies the pullback
  of

  the universal quotient.  This is the representation-facing universal-family

  identity needed before forming a sheaf on `X ×_S Gr(V,d)`.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.homEquiv_eq_pullback_universalQuotient
type: lean
updated: '2026-08-01T12:39:19'
---
theorem homEquiv_eq_pullback_universalQuotient
    {V : S.Modules} {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank V r)
    (hd : 1 ≤ d) (hdr : d ≤ r)
    {T : Over S} (f : T ⟶ representingScheme hV hd hdr) :
    (representation hV hd hdr).homEquiv f =
      Quotient.mk _ (LocallyFreeQuotient.pullbackAlong f
        (universalQuotient hV hd hdr)) := by
  calc
    (representation hV hd hdr).homEquiv f =
        (Scheme.Grassmannian V d).map f.op
          ((representation hV hd hdr).homEquiv (𝟙 _)) := by
      rw [← (representation hV hd hdr).homEquiv_comp f (𝟙 _),
        Category.comp_id]
    _ = (Scheme.Grassmannian V d).map f.op
          (Quotient.mk _ (universalQuotient hV hd hdr)) := by
      exact congrArg ((Scheme.Grassmannian V d).map f.op)
        (mk_universalQuotient hV hd hdr).symm
    _ = Quotient.mk _ (LocallyFreeQuotient.pullbackAlong f
          (universalQuotient hV hd hdr)) := rfl