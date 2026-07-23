---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.comp_slide_three
docstring: '**Generic slide-then-cancel for the merged Sq3/Sq4 core (instance-agnostic).**
  The

  post-`comp_cancel_three_lr` residual of `pullbackTensorMap_restrict` has the form

  `v ≫ q ≫ rtc ≫ s3 ≫ s4 = m3 ≫ m4 ≫ vv ≫ dh ≫ sh3 ≫ sh4 ≫ tf`, where the RHS prefix

  `m3 ≫ m4 ≫ vv` (`= (pullback h).map S3_f ≫ (pullback h).map S4_f ≫ S1_h''''`) equals,
  by the

  naturality of the connecting iso `sheafificationCompPullback h` at the morphism
  `gg`

  (`a_Y.map gg = S3_f ≫ S4_f`), the slid form `v ≫ vtail` with `v = S1_h` (presheaf
  args) and

  `vtail = a_Z.map (Fp_h.map gg)`.  Splicing that equation (`hcomb`) plus the resulting
  folded

  presheaf core (`hcore2`) closes the goal.  Stated generically over one `[Category
  C]` so the

  `subst`/`assoc` algebra never crosses the defeq-but-not-syntactic `SheafOfModules`
  instance

  boundary that whnf-bombs `simp`/`rw`/`erw` on the concrete goal; applied by

  `refine comp_slide_three … hcomb ?_` (assignment-only unification).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.comp_slide_three
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma comp_slide_three {C : Type*} [Category C]
    {a b b3 c1 c2 c3 d1 d2 d3 d4 d5 g : C}
    (v : a ⟶ b) (q : b ⟶ c1) (rtc : c1 ⟶ c2) (s3 : c2 ⟶ c3) (s4 : c3 ⟶ g)
    (m3 : a ⟶ d1) (m4 : d1 ⟶ d2) (vv : d2 ⟶ b3) (dh : b3 ⟶ d3) (sh3 : d3 ⟶ d4)
    (sh4 : d4 ⟶ d5) (tf : d5 ⟶ g) (vtail : b ⟶ b3)
    (hcomb : m3 ≫ m4 ≫ vv = v ≫ vtail)
    (hcore2 : q ≫ rtc ≫ s3 ≫ s4 = vtail ≫ dh ≫ sh3 ≫ sh4 ≫ tf) :
    v ≫ q ≫ rtc ≫ s3 ≫ s4 = m3 ≫ m4 ≫ vv ≫ dh ≫ sh3 ≫ sh4 ≫ tf := by
  rw [hcore2, ← Category.assoc v vtail, ← hcomb]
  simp only [Category.assoc]

/-- **Generic merge-then-slide for the `hcomb` leg (instance-agnostic).** Over an abstract functor
`G`, `G.map s3f ≫ G.map s4f ≫ vv` merges (`Functor.map_comp`) and rewrites by `hg : gmap = s3f ≫ s4f`
to `G.map gmap ≫ vv`, closed by the naturality `hnat`.  Stated generically so the `assoc`/`map_comp`
algebra runs on clean abstract variables, never crossing the defeq-but-not-syntactic `SheafOfModules`