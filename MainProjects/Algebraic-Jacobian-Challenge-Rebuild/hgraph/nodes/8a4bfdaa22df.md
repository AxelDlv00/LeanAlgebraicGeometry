---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.Scheme.isRegularLocalRing_localization_of_isStandardSmooth_of_bijective_residue
docstring: "**Lane COE Step B.d — Stacks `00TT` at a rational closed point, algebra\n\
  level (this iter).** For a standard-smooth algebra `S` over a field `k`, a\nmaximal\
  \ ideal `m ⊆ S` whose induced residue map `k → κ(m)` is bijective (the\n`k`-rational-point\
  \ condition, automatic over an algebraically closed field by\nthe Nullstellensatz),\
  \ the localisation `Sₘ` is a regular local ring.\n\nThis *closes sub-gap (ii.B)\
  \ at closed points*: the proof combines\n* the iter-199 sub-gap (ii.A) cotangent\
  \ computation\n  `finrank_cotangentSpace_of_bijective_algebraMap_residue`\n  (`finrank\
  \ κ (m/m²) = n`, from formal smoothness + free Kähler differentials\n  of rank `n`),\
  \ with\n* the new `StandardSmoothDimension.lean` dimension lower bound\n  `Algebra.IsStandardSmoothOfRelativeDimension.le_ringKrullDim_of_isLocalization_atPrime`\n\
  \  (`n ≤ ringKrullDim Sₘ`, via the polynomial-ring height computation and\n  Krull's\
  \ height theorem — no transcendence-degree theory needed), through\n* the generic\
  \ glue `IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim`\n  (a Noetherian\
  \ local ring with `dim_κ m/m² ≤ ringKrullDim` is regular).\n\nThe consumer `isRegularLocalRing_stalk_of_smooth`\
  \ quantifies over *all*\npoints `z`; the non-closed points (where the residue field\
  \ is a\ntranscendental extension of `k̄` and the bijectivity hypothesis fails) are\n\
  now handled by the Serre-free arbitrary-prime theorem of\n`Albanese/SmoothPrimeRegularity.lean`,\
  \ so the whole pipeline is `sorry`-free\nwithout Stacks `00OF`. This closed-point\
  \ form is retained as the input to\nStep B.e (`isReduced_of_isStandardSmooth_of_isAlgClosed`).\
  \ Axiom-clean."
file: AlgebraicJacobian/Albanese/CodimOneSmoothReduced.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isRegularLocalRing_localization_of_isStandardSmooth_of_bijective_residue
type: lean
updated: '2026-07-31T20:15:15'
---
theorem isRegularLocalRing_localization_of_isStandardSmooth_of_bijective_residue
    {k : Type u} [Field k]
    {S : Type u} [CommRing S] [Nontrivial S] [Algebra k S]
    [Algebra.IsStandardSmooth k S]
    (m : Ideal S) (hm : m.IsMaximal)
    (Sₘ : Type u) [CommRing Sₘ] [IsLocalRing Sₘ] [Algebra k Sₘ] [Algebra S Sₘ]
    [IsScalarTower k S Sₘ] [IsLocalization.AtPrime Sₘ m]
    (hbij : Function.Bijective (algebraMap k (IsLocalRing.ResidueField Sₘ))) :
    IsRegularLocalRing Sₘ := by
  haveI := hm.isPrime
  -- Noetherian structure: standard-smooth ⟹ finite presentation ⟹ Noetherian
  -- over the base field; localisation preserves Noetherianness.
  haveI : IsNoetherianRing S := Algebra.FiniteType.isNoetherianRing k S
  haveI : IsNoetherianRing Sₘ := IsLocalization.isNoetherianRing m.primeCompl Sₘ ‹_›
  -- Extract the relative dimension n.
  obtain ⟨n, hn⟩ :=
    exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth (R := k) (S := S)
  haveI := hn
  -- Kähler package at the localisation (Stages 4, 5a, 5b).
  haveI : Module.Free S (Ω[S⁄k]) := module_free_kaehlerDifferential_of_isStandardSmooth
  haveI : Module.Free Sₘ (Ω[Sₘ⁄k]) :=
    module_free_kaehlerDifferential_localization m.primeCompl Sₘ
  have hrank : Module.rank Sₘ (Ω[Sₘ⁄k]) = n :=
    rank_kaehlerDifferential_localization_eq_relativeDimension n m.primeCompl Sₘ
  -- Formal smoothness of the localisation over k.
  haveI : Algebra.FormallySmooth S Sₘ := Algebra.FormallySmooth.of_isLocalization m.primeCompl
  haveI : Algebra.FormallySmooth k Sₘ := Algebra.FormallySmooth.comp k S Sₘ
  -- (ii.A): cotangent finrank = n at the k-rational closed point.
  have hcot := finrank_cotangentSpace_of_bijective_algebraMap_residue hbij n hrank
  -- (ii.B): dimension lower bound n ≤ dim Sₘ.
  have hdim :=
    Algebra.IsStandardSmoothOfRelativeDimension.le_ringKrullDim_of_isLocalization_atPrime
      (k := k) n m hm Sₘ
  exact IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim
    (by rw [hcot]; exact_mod_cast hdim)