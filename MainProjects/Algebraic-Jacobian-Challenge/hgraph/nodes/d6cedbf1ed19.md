---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.universalMatrix_map_chartMorphism
docstring: '**The chart morphism pulls the universal matrix back to the presenting
  matrix**

  (`φ_I^* X^I = M^I`): the `Γ`-image of the universal matrix along `appTop (chartMorphism)`

  is the chart matrix. Ring-level form of the defining property of the chart morphism.

  Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMatrix_map_chartMorphism
type: lean
updated: '2026-07-24T03:02:11'
---
lemma universalMatrix_map_chartMorphism {T : Scheme.{0}} (d r : ℕ) (x : RankQuotient r d T)
    (I : Finset (Fin r)) (hI : I.card = d) :
    ((universalMatrix d r I hI).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).inv)).map
      ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop (chartMorphism d r x I hI)))
    = chartMatrix x I hI := by
  -- the `appTop` of the chart morphism, through `ΓSpecIso` naturality
  have happ : Scheme.Hom.appTop (chartMorphism d r x I hI)
      = (Scheme.ΓSpecIso (CommRingCat.of
          (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).hom ≫
        CommRingCat.ofHom (MvPolynomial.aeval (R := ℤ)
          (fun pq : Fin d × {q : Fin r // q ∉ I} =>
            chartMatrix x I hI pq.1 pq.2.1)).toRingHom := by
    rw [chartMorphism, Scheme.Hom.comp_appTop, Scheme.toSpecΓ_appTop]
    exact Scheme.ΓSpecIso_naturality _
  rw [Matrix.map_map]
  -- the composed entry map is `aeval` of the chart-matrix entries
  -- at the morphism level the composite collapses by `Iso.inv_hom_id`; taking `⇑(·.hom)`
  -- keeps the composition unapplied so `CommRingCat.hom_comp` fires
  have hmor : (Scheme.ΓSpecIso (CommRingCat.of
        (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).inv ≫
        Scheme.Hom.appTop (chartMorphism d r x I hI)
      = CommRingCat.ofHom (MvPolynomial.aeval (R := ℤ)
          (fun pq : Fin d × {q : Fin r // q ∉ I} =>
            chartMatrix x I hI pq.1 pq.2.1)).toRingHom :=
    (Iso.inv_comp_eq _).mpr happ
  have hfun : ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop (chartMorphism d r x I hI))) ∘
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).inv)
      = ⇑(MvPolynomial.aeval (R := ℤ)
          (fun pq : Fin d × {q : Fin r // q ∉ I} =>
            chartMatrix x I hI pq.1 pq.2.1)).toRingHom := by
    have h := congrArg (fun m => ⇑(CommRingCat.Hom.hom m)) hmor
    simp only [CommRingCat.hom_comp, RingHom.coe_comp, CommRingCat.hom_ofHom] at h
    exact h
  -- `rw`/`simp` cannot match the `g ∘ f` term (a hidden coercion-instance mismatch), so
  -- feed `hfun` through `congrArg` and reconcile `chartMatrix = presentedMatrix` separately
  calc (universalMatrix d r I hI).map
        (⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop (chartMorphism d r x I hI))) ∘
          ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
            (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).inv))
      = (universalMatrix d r I hI).map
          ⇑(MvPolynomial.aeval (R := ℤ)
            (fun pq : Fin d × {q : Fin r // q ∉ I} =>
              chartMatrix x I hI pq.1 pq.2.1)).toRingHom :=
        congrArg ((universalMatrix d r I hI).map) hfun
    _ = chartMatrix x I hI := by
        rw [chartMatrix_eq_presentedMatrix]
        exact universalMatrix_map_presentedMatrix x (chartLocus x I hI).ι I hI