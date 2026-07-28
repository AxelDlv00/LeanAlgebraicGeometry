---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.descent_smul_eq_zero
docstring: '**Separatedness/torsion field of the section-localization descent.**  Given
  the

  per-cover-element localization data `Hfr` (on each `D(r)` of a finite basic-open
  cover `{D(r)}` of

  `Spec R`, the restriction `Γ(M, D(r)) → Γ(M, D(f) ⊓ D(r))` is a localization at
  `powers f`), any

  global section `x` that restricts to `0` on `D(f)` is killed by a power of `f`.  This
  is the

  `exists_of_eq` engine of `isLocalizedModule_basicOpen_descent`: per cover element
  a power of `f`

  kills `x|_{D(r)}` (`IsLocalizedModule.exists_of_eq` of `Hfr`), the finite sup of
  these powers kills

  every `x|_{D(r)}`, and sheaf separatedness over the cover (`TopCat.Sheaf.eq_of_locally_eq''`)
  lifts

  this to `f^n • x = 0`.  Project-local: the geometric content (`Hfr`) is the gated
  P1 tilde data.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.descent_smul_eq_zero
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma descent_smul_eq_zero {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R)
    (t : Finset R) (hspan : Ideal.span (t : Set R) = ⊤)
    (Hfr : ∀ r ∈ t, IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right :
          PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen r)).op).hom)
    (x : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤)))
    (hx : ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x = 0) :
    ∃ n : ℕ, f ^ n • x = 0 := by
  classical
  have key : ∀ r : {x // x ∈ t}, ∃ k : ℕ, f ^ k •
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom x = 0 := by
    rintro ⟨r, hr⟩
    have e1 := res_comp (modulesSpecToSheaf.obj M)
        (A := ⊤) (B := PrimeSpectrum.basicOpen r)
        (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r) le_top inf_le_right le_top x
    have e2 := res_comp (modulesSpecToSheaf.obj M)
        (A := ⊤) (B := PrimeSpectrum.basicOpen f)
        (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r) le_top inf_le_left le_top x
    have hzero := e1.trans (e2.symm.trans
      ((congrArg (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left :
            PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
              ≤ PrimeSpectrum.basicOpen f)).op).hom) hx).trans
        (map_zero _)))
    obtain ⟨c, hc⟩ := (Hfr r hr).exists_of_eq (hzero.trans (map_zero _).symm)
    obtain ⟨k, hk⟩ := c.2
    have hk' : f ^ k = (c : R) := hk
    refine ⟨k, ?_⟩
    have h2 : c • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom x) = 0 :=
      hc.trans (smul_zero c)
    rw [hk']; exact h2
  choose k hk using key
  refine ⟨Finset.univ.sup k, ?_⟩
  refine TopCat.Sheaf.eq_of_locally_eq' (modulesSpecToSheaf.obj M)
    (fun r : {x // x ∈ t} => (PrimeSpectrum.basicOpen (r:R) : (Spec R).Opens)) ⊤
    (fun r => homOfLE le_top) (le_of_eq (iSup_basicOpen_subtype_eq_top hspan).symm)
    (f ^ Finset.univ.sup k • x) 0 ?_
  intro r
  have hle : k r ≤ Finset.univ.sup k := Finset.le_sup (Finset.mem_univ r)
  set g := ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom with hg
  have hms : g (f ^ Finset.univ.sup k • x) = f ^ Finset.univ.sup k • g x := LinearMap.map_smul g _ x
  have hsplit : f ^ Finset.univ.sup k • g x
      = f ^ (Finset.univ.sup k - k r) • (f ^ (k r) • g x) := by
    rw [← mul_smul, ← pow_add, Nat.sub_add_cancel hle]
  have hzero : g (f ^ Finset.univ.sup k • x) = 0 :=
    hms.trans (hsplit.trans ((congrArg (fun y => f ^ (Finset.univ.sup k - k r) • y) (hk r)).trans
      (smul_zero _)))
  change g (f ^ Finset.univ.sup k • x) = g 0
  rw [hzero, map_zero]