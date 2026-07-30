---
author: sync
content_type: theorem
created: '2026-07-30T07:28:29'
decl: ProbeP4R5.stepA
docstring: 'STEP A. Coverage at V, restricted family, in the SINGLE-index case, gives
  for every

  test point a point of `V` whose chart value is the prescribed class.  This is just

  `PointwiseCoverage` unfolded — does it typecheck with the restricted chart?'
file: scratch_p4r5/probe1.lean
generated: lean
lean_status: lean_ok
stale: true
title: ProbeP4R5.stepA
type: lean
updated: '2026-07-30T08:49:48'
---
theorem stepA {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens)
    (hcov : PointwiseCoverage C
      (fun _ : PUnit.{u+1} => restrictChart (abelSigmaChart C π n rep m Z hdeg) V))
    (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T) :
    ∃ (W : T.Opens) (_ : t ∈ W) (x : (W : Scheme.{u}) ⟶ (V : Scheme.{u})),
      (restrictChart (abelSigmaChart C π n rep m Z hdeg) V).app
          (op (W : Scheme.{u})) x
        = (pic0SigmaSheaf C).1.map (W.ι).op s := by
  obtain ⟨W, htW, i, x, hx⟩ := hcov T s t
  exact ⟨W, htW, x, hx⟩