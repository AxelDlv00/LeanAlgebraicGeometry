## Per-file / per-declaration feature map

Legend: (a) openness only, (b) affineness, (c) joint cover `⨆ pieces = ⊤`, (d) chart-wise cover (`cover₀`/`cover₁`/`partition₀`/`partition₁`), (e) pieces are basic opens (`basicOpen_le`, `pieces_inl/inr`, `h₀/h₁`), (f) two-sided `Sum` index structure.

### DivSchemeCertZarConn.lean (182 L)
| decl | line | features | note |
|---|---|---|---|
| `subset_or_disjoint_of_isPreconnected_of_supportLeak` | 98 | (a) | only `(A.pieces j).isOpen` + closed trace; index-agnostic |
| `forall_subset_or_disjoint_of_isPreconnected` | 128 | (a) | pointwise wrapper |
| `supportLocus_subset_chart_of_isPreconnected` | 149 | (d) via `subset_chart₀_or_disjoint_chart₀`, + `relCover_sup` | inherits the chart dichotomy's dependence |
| `not_forall_supportLeak_eq_empty_of_isPreconnected` | 173 | (d) inherited | contrapositive of the above |

### DivSchemeCertZarC1.lean (140 L)
| decl | line | features | note |
|---|---|---|---|
| `IsAffineOpen.isClosed_zeroLocus_inter_of_finite_quotient` | 75 | — | abstract, takes `hV : IsAffineOpen V`; no `FinCoverData` at all |
| `supportLeak_eq_empty_of_finite_colength` | 105 | (b) only — `isAffineOpen_pieces` at :110 | survives widening verbatim |
| `supportLeak_eq_empty_iff_finite_colength` | 123 | (b) | |
| `supportLocus_subset_chart_of_isCertified` | 131 | (d) inherited from Conn | |

### DivSchemeCertZarVerdict.lean (75 L)
`not_isCertified_of_isPreconnected_of_witnesses` :62 — (d) inherited only; no piece-level reasoning of its own.

### DivSchemeCertZarSwallow.lean (187 L)
| decl | line | features | note |
|---|---|---|---|
| `subsingleton_colength_of_disjoint_supportLocus` | 83 | (a) | germ/unit argument, index-agnostic |
| `supportLeak_eq_empty_of_subset_or_disjoint` | 100 | (a) | |
| `forall_noLeak_of_forall_subset_or_disjoint` | 115 | (a) | |
| `forall_finite_colength_of_forall_subset_or_disjoint` | 134 | (a)+(b) | via `finite_colength_of_supportLeak_eq_empty` |
| `subset_chart₀_or_disjoint_chart₀` | 156 | **(d)+(e)+(f)** | `Fin A.m₀`, `Sum.inl`, `basicOpen_le (A.h₀ j)` at :162-168 |
| `subset_chart₁_or_disjoint_chart₁` | 171 | **(d)+(e)+(f)** | mirror, :177-183 |

### DivSchemeCertZarChartTrace.lean (178 L)
| decl | line | features | note |
|---|---|---|---|
| `supportLocus_inter_chart₀_eq_iUnion` | 80 | **(d)+(e)+(f)** | `⊆` is `cover₀` (:85), `⊇` is `basicOpen_le (A.h₀ j)` (:88) |
| `supportLocus_inter_chart₁_eq_iUnion` | 91 | **(d)+(e)+(f)** | :96, :99 |
| `isClosed_supportLocus_inter_chart₀_…` | 106 | (d)(f) inherited | quantifies over `Fin A.m₀` |
| `isClosed_supportLocus_inter_chart₁_…` | 115 | (d)(f) | |
| `isClosed_supportLocus_inter_chart_of_forall_noLeak` | 129 | (d)(f) | splits `hleak` through `Sum.inl/inr` |
| `not_forall_noLeak_of_not_isClosed_chart₀` / `_chart₁` | 157/167 | (d)(f) inherited | |

This file is the epicentre: every declaration in it is chart-wise.

### DivSchemeCertZarChartPair.lean (200 L)
| decl | line | features | note |
|---|---|---|---|
| `chartPairCoverData` | 76 | **(d)+(e)+(f)** | literally `m₀=m₁=1`, `h=1`, `partition₀/₁ := by simp` |
| `chartPairCoverData_pieces_inl/inr` | 87/94 | **(e)(f)** | `pieces_inl` + `basicOpen_one` |
| `chartPairCoverData_pieces_eq` | 101 | (f) | `cases j` |
| `ofChartPair`, `ofChartPair_pieces_eq_chart` | 116/130 | **(e)(f)** | built on `chartPairCoverData` |
| `forall_subset_or_disjoint_of_pieces_eq_chart` | 154 | — | stated against the *shape* `pieces j = V₀ ∨ V₁`; index-agnostic |
| `forall_noLeak_of_pieces_eq_chart` | 170 | (a) | |
| `forall_finite_colength_of_pieces_eq_chart` | 187 | (a)+(b) | |

Note the design: the three `…_of_pieces_eq_chart` theorems are hypothesis-driven and survive widening; only the *constructor* `chartPairCoverData` needs (d)(e)(f) — and under widening it becomes trivially easier (V₀, V₁ are themselves affine opens, so the two-piece datum is direct, no `basicOpen_one`).

### DivSchemeCertZarConfine.lean (228 L)
| decl | line | features | note |
|---|---|---|---|
| `DivEq.unitLocus_eq`, `DivEq.supportLocus_eq` | 84/110 | — | pure `LocalEquations`, no pieces |
| `supportLocus_subset_of_forall_fibre` | 126 | — | |
| `exists_opens_supportLocus_subset_chartInter` | 136 | — | uses `V₀ ⊓ V₁` as a bare open, not as pieces |
| `isOpen_setOf_fibre_subset_chartInter` | 154 | — | |
| `isClosed_supportLocus_inter_chart_of_isCertified` | 191 | **(d)(f)** at :195-198 | `hc.finite_colength (Sum.inl j)` / `(Sum.inr j)` feeding the ChartTrace lemmas |
| `not_isCertified_of_not_isClosed_inter_chart₀` | 202 | (d)(f) inherited | |
| `not_isCertified_of_divEq_of_isPreconnected_of_witnesses` | 215 | (d) inherited | |

### DivSchemeCertZarPointwise.lean (196 L) — clean
`exists_fin_span_eq_top_of_forall_prime` :57, `isLocallyCertified_of_forall_prime_exists_away` :98, `ThetaGeneratorSeed.isLocallyCertified_of_forall_prime_away_certified` :141, `…_exists_certified_adaptation` :162, `divFamZar_of_forall_prime_away_certified` :181 — **no feature at all**. Zero occurrences of `pieces`, `cover₀`, `Sum.inl`, `m₀`. Pure base-side quasi-compactness + `IsLocallyCertified` plumbing.

### DivSchemeCertZarKerSpan.lean (149 L) — clean
`isCertified_of_noLeak_of_forall_liftQ_injective` :63 and `ThetaGeneratorSeed.divisorAdaptation_isCertified_of_noLeak_liftQ_degree` :123 use `A.index` and `A.pieces j` **abstractly only** (as an index type and an open). No (d)(e)(f).

### DivSchemeCertZarSeed.lean (158 L) — clean
`isLocallyCertified_of_forall_exists_away` :77, `ThetaGeneratorSeed.isLocallyCertified_of_forall_away_certified` :115, `divFamZar_of_forall_away_certified` :132, `isLocallyCertified_of_isCertified` :150 — no piece features.

### DivSchemeCertZarSep.lean (307 L)
| decl | line | features | note |
|---|---|---|---|
| `toOvlLeft_self_eq_toOvlRight_self'` | 74 | — | `rfl` |
| `gluedSubmodule_eq_top_of_separated'` | 84 | — | index-agnostic (`by_cases i = j`) |
| `deltaLeft_eq_deltaRight_of_separated` | 99 | — | |
| `gluedTopEquiv'` | 108 | — | |
| `flat_coker_incl_of_separated` / `flat_coker_diff_of_separated` | 116/129 | — | |
| `subsingleton_ovlColength_of_disjoint_supportLocus` | 148 | (a) | germ argument on `pieces i ⊓ pieces j` |
| `forall_subsingleton_ovlColength_of_unique_support_piece` | 167 | — | |
| `supportLocus_disjoint_chart_inter_of_separated` | 201 | **(d)+(f)** at :208-211, :221 | `cover₀`/`cover₁` to land in a chart-0 and a chart-1 piece; `Sum.inl ≠ Sum.inr` is what makes them distinct |
| `not_exists_unique_support_piece` | 257 | (d)(f) inherited | |
| `isCertified_of_separated` | 277 | — | needs only `Fintype A.index` |

### DivSchemeCertZarTransport.lean (87 L) — clean
`germ_pullbackEqn_eq_stalkMap` :47, `unitLocus_pullback` :60, `supportLocus_pullback` :81 — no `FinCoverData` reference whatsoever.

### DivSchemeCertZarFibreAvoid.lean (442 L) — clean of piece features
No `pieces`, `cover₀`, `Sum.inl`, `m₀` anywhere. All declarations (`supportLocus_finite_on_curve` :46, `mem_supportLocus_iff_mem_presentationDivisor_support` :80, `genericPoint_not_mem_supportLocus` :101, `supportLocus_eq_image_presentationDivisor_support` :116, `supportLocus_ncard_eq_presentationDivisor_support_card` :139, `supportLocus_ncard_le_deg` :153, `range_relCurveMap_residueField` :179, `fibre_supportLocus_finite_of_pullback_support_eq` :202, `fibre_supportLocus_finite_of_forall_self` :247, `exists_matrix_fibre_subset_twisted_chartInter` :278, `exists_matrix_opens_supportLocus_subset_twisted_chartInter` :298/:355, `…_of_forall_self` :319, `PointwiseAchiever.supportLocus_ncard_…_le` :408) work with `twistedRelCover C R π M`.V₀ ⊓ V₁ as bare opens. **This is the R1/GL₂ file** — it is the one file whose content the I-0492 decision deprioritises, but it does not *break*; it just becomes unnecessary. Its useful residue for R2: `supportLocus_finite_on_curve`, `supportLocus_ncard_le_deg`, `fibre_supportLocus_finite_of_forall_self` (a finite support fibre, which is exactly the input an affine-avoidance lemma would want).

### DivisorFamilyPullbackMap.lean, `FinCoverData` section
| decl | line | features | note |
|---|---|---|---|
| `exists_mem_pieces` | 82 | **(d)(f)** | proof: `relCover_sup` then `cover₀`/`cover₁`; **statement is exactly (c)** — it *is* the joint cover in pointwise form |
| `isAffineOpen_pieces` | 97 | **(e)(f)** in the proof | `cases j; (relCover_isAffineOpen₀ …).basicOpen _` — see item (3) below |
| `pieceTermBaseChange` | 105 | **(e)(f)** hard | `pieceTermBaseChangeAlg` is stated for `(relCurve C R).basicOpen h` of a chart (DivisorFamilyPullback.lean:204-206); the localization-Away identification *is* the basic-open-ness |
| `pieceTermBaseChange_one_tmul` | 122 | **(e)(f)** | same |
| `eqn_mem_nonZeroDivisors` | 147 | — | sheaf-theoretic |
| `pulledEqn_mem_nonZeroDivisors` | 165 | (e)(f) via `pieceTermBaseChange` | |
| `germ_pullbackEqn_mem_nonZeroDivisors` | 185 | (b)+(c) directly (`exists_mem_pieces` :193, `isAffineOpen_pieces` :209), (e)(f) transitively via `pulledEqn_mem_nonZeroDivisors` | |

### SupportTube.lean, `FinCoverData` section
`flat_sections_pieces` :226 — **(e)(f)**: `cases j; flat_sections_basicOpen R (relCover_isAffineOpen₀ …) (flat_sections_relPinnedChart …) (D.h₀ j)`. Needs `Γ(piece)` to be a *localization* of a flat chart ring.

`DivisorAdaptation` lemmas in the same file: `isUnit_germ_eqn_iff` :245, `mem_basicOpen_eqn_iff_mem_unitLocus` :259, `basicOpen_eqn_le_unitLocus` :266, `supportLocus_inter_pieces` :285 — all (a) only. `iSup_basicOpen_eqn_eq_unitLocus` :274 — (c) only (via `exists_mem_pieces`).

### SupportTubeFinite.lean:291 area
`finite_colength_of_isClosed_supportLocus_inter` :287 — (b) only, `isAffineOpen_pieces` at :291. Its three wrappers `finite_colength_of_supportLeak_eq_empty` :296, `finite_colength_of_forall_fibre_closure_subset` :306, `finite_colength_of_supportLocus_subset` :320 — (b) only.

---

## (1) Requested signatures

```lean
-- DivisorFamilyPullbackMap.lean:185 (namespace AlgebraicGeometry.DivisorAdaptation)
theorem germ_pullbackEqn_mem_nonZeroDivisors
    (hproj : ∀ j, Module.Projective R (A.colength j))
    (y z : relCurve C R')
    (hz : z ∈ (d.cover.pullback (relCurveMap C R R')).opens y) :
    ((relCurve C R').presheaf.germ
        ((d.cover.pullback (relCurveMap C R R')).opens y) z hz).hom
        (Scheme.LocalEquations.pullbackEqn (relCurveMap C R R') d y)
      ∈ nonZeroDivisors ((relCurve C R').presheaf.stalk z)
-- implicit context: {C R} (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R']
-- [IsScalarTower k R R'] {π} [IsAffineHom π] {d} (A : DivisorAdaptation C R π d)

-- DivSchemeCertZarC1.lean:131
theorem supportLocus_subset_chart_of_isCertified {n : ℕ}
    (hconn : _root_.IsPreconnected d.supportLocus) (hc : A.IsCertified n) :
    d.supportLocus ⊆ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R))
      ∨ d.supportLocus ⊆ ((relCover C R (fiberTwoCover π)).V₁ : Set (relCurve C R))
-- context: [Field k] {C} [IsProper C.hom] {R} [CommRing R] [Algebra k R] {π} [IsFinite π]
--          {d} (A : DivisorAdaptation C R π d)

-- DivSchemeCertZarVerdict.lean:62
theorem not_isCertified_of_isPreconnected_of_witnesses {n : ℕ}
    (hconn : _root_.IsPreconnected d.supportLocus)
    {x y : relCurve C R} (hx : x ∈ d.supportLocus) (hy : y ∈ d.supportLocus)
    (hx₀ : x ∉ ((relCover C R (fiberTwoCover pi)).V₀ : Set (relCurve C R)))
    (hy₁ : y ∉ ((relCover C R (fiberTwoCover pi)).V₁ : Set (relCurve C R))) :
    ¬ A.IsCertified n

-- DivSchemeCertZarC1.lean:123
theorem supportLeak_eq_empty_iff_finite_colength (j : A.index) :
    d.supportLeak (A.pieces j) = ∅ ↔ Module.Finite R (A.colength j)
```

Main statements of **DivSchemeCertZarSwallow.lean** (no single "the" theorem; the file's spine):
```lean
theorem supportLeak_eq_empty_of_subset_or_disjoint (j : A.index)          -- :100
    (h : d.supportLocus ⊆ (A.pieces j : Set (relCurve C R))
      ∨ Disjoint d.supportLocus (A.pieces j : Set (relCurve C R))) :
    d.supportLeak (A.pieces j) = ∅

theorem forall_noLeak_of_forall_subset_or_disjoint                        -- :115
    (h : ∀ j : A.index, d.supportLocus ⊆ (A.pieces j : Set (relCurve C R))
      ∨ Disjoint d.supportLocus (A.pieces j : Set (relCurve C R))) :
    ∀ (j : A.index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) ⊆
        (A.pieces j : Set (relCurve C R))

theorem subset_chart₀_or_disjoint_chart₀ (h : …swallow-or-miss…) :        -- :156
    d.supportLocus ⊆ (V₀ : Set (relCurve C R)) ∨ Disjoint d.supportLocus (V₀ : …)
```

## (2) Affine-open-containing-a-finite-over-R-closed-set: DOES NOT EXIST

Searched by name (`exists_isAffineOpen*`, `IsAffineOpen` + `Finite`, `0B8B`, avoidance) and semantically (four Lean-Finder queries: "affine open containing a closed subset finite over the base", "finite set of points lies in a single affine open", "affine open whose complement is the support of an effective divisor", "affine open neighbourhood of a closed subscheme finite over the base ring"). Nothing in AJCR, AJC, or mathlib.

What exists and is adjacent:
- `AlgebraicGeometry.exists_isAffineOpen_mem_and_subset` (mathlib) — **one point** at a time, not a set.
- `AlgebraicJacobian.GaloisDescent.exists_basicOpen_le_of_finite` — **AJC only** (`MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/StableAffineCover.lean`), signature: given `hU : IsAffineOpen U`, finitely many points `y : ι → X` all in `U` and all in `V`, produces `s : Γ(X,U)` with all `y i ∈ X.basicOpen s` and `X.basicOpen s ≤ V`. This is the closest existing tool, but it needs the finite set **already inside one affine open `U`** — it does not create the affine open. Not ported to AJCR.
- `P1.exists_matrix_finite_subset_chartInter` (`AlgebraicJacobian/Curve/P1Aut.lean:460`) — the R1/GL₂ route, forbidden by I-0492.
- `Scheme.IsQuasiAffine.isBasis_basicOpen` / `IsQuasiAffine.of_forall_exists_mem_basicOpen` (mathlib `AlgebraicGeometry/QuasiAffine.lean`) — the only mathlib machinery in this direction; would still need the quasi-affine hypothesis supplied.

So the widening will have to either (i) build this avoidance lemma, or (ii) take the affine open as *data* in the widened `FinCoverData` (which is what "arbitrary affine opens" per I-0492 suggests) and push existence onto the atlas.

## (3) `isAffineOpen_pieces` under an arbitrary-affine-open field

It is currently proved **from basic-open-ness of an affine chart** (`DivisorFamilyPullbackMap.lean:97-100`: `(relCover_isAffineOpen₀ C R (fiberTwoCover π)).basicOpen _`). But it **survives trivially** under widening: if the field carries `isAffine : ∀ j, IsAffineOpen (pieces j)` as a structure field, `isAffineOpen_pieces` becomes that field's projection. No consumer of it (`DivSchemeCertZarC1.lean:110`, `SupportTubeFinite.lean:291`, `DivisorFamilyPullbackMap.lean:209`, `DivSchemeMonoBridge.lean:303/317`, `DivSchemeCertOverlapFinite.lean:185`) sees the difference.

The genuinely basic-open-dependent siblings are `flat_sections_pieces` and `pieceTermBaseChange` (see below).

---

## WHAT BREAKS UNDER WIDENING

Needs (d) chart-wise cover — the union of chart-`b` pieces equals `V_b`. Under a joint-cover-only field these lose their `⊆` direction:
- `DivSchemeCertZarChartTrace.lean:80` `supportLocus_inter_chart₀_eq_iUnion` and `:91` `…_chart₁_…` — root cause; both directions break (`⊆` needs (d), `⊇` needs (e)).
- `DivSchemeCertZarChartTrace.lean:106, 115, 129, 157, 167` — all downstream of the above; also (f).
- `DivSchemeCertZarSwallow.lean:156, 171` — chart dichotomies, use `cover₀/₁` implicitly through `supportLocus_inter_chart₀_eq_iUnion` plus (e) directly.
- `DivSchemeCertZarSep.lean:201` `supportLocus_disjoint_chart_inter_of_separated` and `:257` `not_exists_unique_support_piece` — `cover₀ hz₀` / `cover₁ hz₁` at :208-209 are load-bearing: without a chart-indexed cover there is no reason two *distinct* pieces both contain `z`.
- `DivisorFamilyPullbackMap.lean:82` `exists_mem_pieces` — proof breaks, **statement is exactly the new (c) field**; becomes a projection.
- Transitive verdict chain: `DivSchemeCertZarConn.lean:149, 173`; `DivSchemeCertZarC1.lean:131`; `DivSchemeCertZarVerdict.lean:62`; `DivSchemeCertZarConfine.lean:191, 202, 215`.

Needs (e) pieces are basic opens of a chart:
- `DivSchemeCertZarSwallow.lean:164, 179` — `(relCurve C R).basicOpen_le (A.h₀ j)`, i.e. `piece ≤ V₀`. Under widening a piece need not lie in either chart, so "some piece swallows the support ⟹ support ⊆ V₀" is simply **false**. This is the hardest break: it is not a proof-repair, the conclusion changes.
- `DivSchemeCertZarChartTrace.lean:88, 99` — same `basicOpen_le`.
- `DivSchemeCertZarChartPair.lean:76, 87, 94, 116, 130` — `chartPairCoverData` construction; **repairable and simpler** post-widening (V₀/V₁ are affine opens, feed them directly; `basicOpen_one` disappears).
- `SupportTube.lean:226` `flat_sections_pieces` — needs `Γ(piece)` = localization of a flat chart ring. For an arbitrary affine open of `relCurve C R` the replacement is flatness of `relCurve C R ↘ Spec R` + `flat_sections_of_coherentSheafFlat_id` / `flat_gamma_appLE_of_flat`-style argument. **Real work.** Consumers: `flat_colength_of_forall_tmul_residueField` (SupportTube.lean:313), `projective_colength_of_forall_tmul_residueField` (:329).
- `DivisorFamilyPullbackMap.lean:105, 122` `pieceTermBaseChange` / `_one_tmul` — `pieceTermBaseChangeAlg` (DivisorFamilyPullback.lean:204) is stated for `basicOpen h` of a chart and proved via `IsLocalization.Away`. For an arbitrary affine open the replacement is `Over.sectionsBaseChangeOfIsAffineOpen` (`Cohomology/SectionsBaseChange.lean:295`), which already exists in the right generality. **Repairable, this is the port to make.** Consumers: `pulledEqn_mem_nonZeroDivisors` :165, `germ_pullbackEqn_mem_nonZeroDivisors` :185.

Needs (f) two-sided `Sum` index:
- `DivSchemeCertZarChartTrace.lean:82, 93, 107, 116, 142-144`; `DivSchemeCertZarConfine.lean:196, 198`; `DivSchemeCertZarSep.lean:210-211, 221`; `DivSchemeCertZarSwallow.lean:162, 168, 177, 183`; `DivSchemeCertZarChartPair.lean:87-106`; `DivisorFamilyPullbackMap.lean:82, 97, 105, 122`; `SupportTube.lean:226`. `thetaOvlUnit` (DivisorFamilyTheta.lean:149, four-case `Sum` match) is (f)-critical for the theta/datum lane but **is not touched by any file in this survey** — no `DivSchemeCertZar*` file mentions it.

Untouched by the widening (no repair needed): the whole of `DivSchemeCertZarPointwise.lean`, `DivSchemeCertZarSeed.lean`, `DivSchemeCertZarKerSpan.lean`, `DivSchemeCertZarTransport.lean`, `DivSchemeCertZarFibreAvoid.lean`; in `DivSchemeCertZarSep.lean` everything except :201/:257 (including `isCertified_of_separated` :277); in `DivSchemeCertZarConn.lean` :98/:128; `DivSchemeCertZarC1.lean` :75/:105/:123; `DivSchemeCertZarSwallow.lean` :83/:100/:115/:134; `DivSchemeCertZarChartPair.lean` :154/:170/:187; all of `SupportTubeFinite.lean`'s adaptation corollaries; `DivSchemeCertZarConfine.lean` :84-167.
