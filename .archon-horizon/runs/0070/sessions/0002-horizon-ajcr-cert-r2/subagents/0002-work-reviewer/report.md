Both inbox items filed. Report follows.

## 1. Is the widening real, or was the old typing smuggled back in?

**CONFIRMED SOUND.** `AffCoverData` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean:145-154`) has exactly four fields: `m`, `pieces : Fin m → Opens`, `isAffineOpen`, `cover : (⨆ j, pieces j) = ⊤`. No `π` argument, no `h₀`/`h₁`/`a₀`/`a₁`/`partition₀`/`partition₁`, no `Sum` index, nothing referring to `relCover`/`relPinnedChart`.

`ChartTyping` (`:204-208`) is a separate structure and is referenced by nothing except its own constructor `FinCoverData.toChartTyping` (`:255`). `AffAdaptation` (`DivisorFamilyAffAdaptation.lean:75`), `AffAdaptation.IsCertified` (`:252`), `IsLocallyCertifiedAff` (`DivisorFamilyAffZar.lean:100`), `DivFamZarAff` (`:163`), and every lemma in `DivisorFamilyAffPerPiece.lean` take `D : AffCoverData C R` with no `ChartTyping` and no `IsAffineHom π` in scope. `π` does not occur in the type of any per-piece or certificate declaration. The only chart mentions in the six files are inside `pinnedChartOfSide`/`ChartTyping`/`toAffCoverData`/`toChartTyping`, i.e. the migration and the optional Θ datum.

## 2. Is `flat_sections_of_flat_hom` true and proved?

**CONFIRMED SOUND, non-vacuous.** `DivisorFamilyAffCover.lean:87-104`. The factorisation is against the real `Scheme.overAlgebraMap` (`AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:193`, defined as `(ΓSpecIso.inv ≫ (X ↘ Spec k).appTop ≫ presheaf.map (homOfLE le_top).op).hom` — which is literally `ΓSpecIso.inv` composed with `appLE ⊤ V`, so the `rfl` at `:101` is honest, not a coincidence of a wrong definition). `HasRingHomProperty.appLE` has the signature `(H : P f) (U : Y.affineOpens) (V : X.affineOpens) (e) : Q (f.appLE U V e).hom` (mathlib `Morphisms/RingHomProperties.lean:290`), and the call supplies `⟨⊤, isAffineOpen_top⟩` and `⟨V, hV⟩` — `Spec (.of K)` is affine, so `⊤` being affine is real content, not a vacuous instance. The conclusion is transferred by `RingHom.flat_algebraMap_iff`, so `Module.Flat K Γ(X,V)` is about the actual algebra structure.

`instFlatRelCurveHom` (`:116-118`) concludes the right leg. `IsStableUnderBaseChange.of_isPullback` is `(sq : IsPullback f' g' g f) (hg : P g) : P g'` (mathlib `MorphismProperty/Limits.lean:110-111`), and `Over.isPullback_left C (overSpec k R) : IsPullback (fst).left (snd).left C.hom (overSpec k R).hom` (`AlgebraicJacobian/Cohomology/SectionsBaseChange.lean:85`). Matching: `g = C.hom`, `g' = (snd C (overSpec k R)).left`. The flat input is `C.hom` (via `flat_hom_over_field`, `Picard/Separatedness.lean:72`, morphism to a field spectrum) and the conclusion is the second projection — which is definitionally `relCurve C R ↘ Spec (.of R)` (`relCurve.instOver := .ofHom (snd C (overSpec k R)).left`, `Cohomology/RelativeTwoCover.lean:118`; the alignment is pinned by `baseChange_over_eq_snd_left := rfl`, `Curve/BaseChangeInstances.lean:83`). Correct leg, correct direction.

## 3. Are the two obligations discharged, or moved somewhere invisible?

**CONFIRMED SOUND** on placement.

(i) No field of `AffCoverData`, `AffAdaptation`, or `IsCertified` amounts to finite support. It enters as `hfib` in `DivisorFamilyAffAssemble.lean:74-78` and in `flat_colength_of_forall_tmul_residueField` (`DivisorFamilyAffPerPiece.lean:250`), both explicit hypotheses.

(ii) `exists_mem_pieces` (`Cover.lean:166`) is `D.cover` plus `Opens.mem_iSup` — nothing else. `flat_sections_pieces` (`:178`) routes through `flat_sections_isAffineOpen` → `flat_sections_of_flat_hom`, no chart. `SwallowedBy` (`Swallow.lean:75-77`) is honestly stated: `∃ j₀, supportLocus ⊆ pieces j₀ ∧ ∀ j ≠ j₀, Disjoint supportLocus (pieces j)`, and is a hypothesis at all three use sites (`:89`, `:99`, `:113`, and `Assemble.lean:73`). Not a field anywhere.

One caveat: `flat_sections_pieces_inf` (`Cover.lean:185`) takes affineness of the overlap as an *argument* (`hinf`), where the old `FinCoverData.flat_sections_pieces_inf` (`DivSchemeCertOverlapFinite.lean:65`) proved it. That is an honest weakening, correctly signposted, but the docstring (`:182`) claims "piece overlaps are affine (the relative curve is separated over Spec R, being proper)" while the lemma does not prove it — mathlib's `IsAffineOpen.inf` needs `IsAffineHom (pullback.diagonal (terminal.from X))`, which is not instantiated here.

## 4. Did anything get weaker without being said?

**PROBLEM — not in `IsCertified`, but in the assembler.**

`IsCertified` itself is clean: all seven clauses of `DivisorAdaptation.IsCertified` (`DivisorFamily.lean:426-441`) appear in `AffAdaptation.IsCertified` (`DivisorFamilyAffAdaptation.lean:252-267`) with identical statements — `finite_colength`, `projective_colength`, `finite_glued`, `projective_glued`, `rankAtStalk_glued`, `flat_coker_incl`, `flat_coker_diff`. Nothing dropped, nothing weakened.

The weakening is one level up. The old lane has a *light* certificate assembler, `DivisorAdaptation.isCertified_of_separated` (`DivSchemeCertZarSep.lean:277`), which **proves** (c2)finite/(c2)proj/(c3)/(c4) from the single hypothesis "off-diagonal overlap colengths vanish" (`gluedSubmodule_eq_top_of_separated'` `:84`, `flat_coker_incl_of_separated` `:115`, `flat_coker_diff_of_separated` `:129`). That file imports only `DivSchemeCertZarKerSpan` and its collapse lemmas touch no chart — the only chart-using declarations in it are the scope-guard refutation at `:201`/`:257`. It transports.

`isCertified_of_swallowedBy` (`DivisorFamilyAffAssemble.lean:72-97`) instead **assumes** all five:

```
    (hfinite_glued : Module.Finite R A.Glued)
    (hproj_glued : Module.Projective R A.Glued)
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk A.Glued p = n)
    (hflat_incl : Module.Flat R (A.chartProd ⧸ A.gluedSubmodule))
    (hflat_diff : Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight)))
```

and the docstring (`:24-26`, `Collapse.lean:25-27`) justifies this by citing I-0340: the diagonal of `deltaLeft - deltaRight` vanishes identically, so "(c4) can never be free". That inference does not apply here. Under `SwallowedBy`, every off-diagonal overlap contains a missing piece, so `subsingleton_ovlColength_of_disjoint` (`Collapse.lean:95`) gives `hsep` immediately; the surviving diagonal factors are the swallowing piece's own colength (covered by (c1)) and subsingletons. A refutation of "free for an arbitrary adaptation" is not a refutation of "free under `SwallowedBy`". So the widened lane's assembler is strictly weaker than the old one, in the one case it was built for, and the docstring presents that as a mathematical necessity.

## 5. Any dependence on the refuted chart machinery?

**CONFIRMED SOUND.** `subset_chart₀_or_disjoint_chart₀`, `subset_chart₁_or_disjoint_chart₁`, `supportLocus_subset_chart_of_isPreconnected` appear in the six files only as prose in `DivisorFamilyAffAdaptation.lean:22-23` and `DivisorFamilyAffPerPiece.lean:40-41`, both saying they must not be used. No code reference. The imports of the six files are `DivisorFamily`, `Separatedness`, `SupportTube`, `SupportTubeFinite`, `DivisorFamilyZar`, `DivSchemeCertZarPointwise` — none of which is `DivSchemeCertZarSwallow` or `DivSchemeCertZarConn`.

## 6. Sorry / axiom audit

**CONFIRMED SOUND.** No `sorry`, `admit`, `axiom`, or `native_decide` in any of the seven files. The only hits for "sorry" are prose: `DivisorFamilyAffZar.lean:128` ("sorry-free") and `:132` ("rather than hiding behind a `sorry`"). All seven `.olean` files are newer than their sources and contain zero `sorryAx` occurrences; so do the transitive project imports (`SupportTube`, `SupportTubeFinite`, `DivisorFamilyZar`, `DivSchemeCertZarPointwise`, `Separatedness`, `DivisorFamily`, `DivSchemeCertZarSeed`).

## 7. The one admitted gap

**CONFIRMED SOUND on the characterisation and on the cover half; PROBLEM on "nothing downstream needs it".**

The description at `DivisorFamilyAffZar.lean:132-139` is accurate: (c1) transports pointwise, (c2)/(c3)/(c4) are statements about `gluedSubmodule ⊆ ∀ j : index, colength j` and need an equalizer transport along `Fin m₀ ⊕ Fin m₁ ≃ Fin (m₀+m₁)` commuting with `deltaLeft`/`deltaRight`, plus `rankAtStalk` invariance. `FinCoverData.toAffCoverData` (`Cover.lean:224-247`) is genuinely sorry-free and genuinely proves the joint cover from `relCover_sup` + the two chart covers.

Your claim that nothing downstream needs it is *technically* true and *practically* misleading: nothing downstream needs it because nothing downstream exists. `DivFamZarAff` and `IsLocallyCertifiedAff` occur only in `DivisorFamilyAffZar.lean` and `DivisorFamilyAffAssemble.lean`. `AffCoverData` has no producer other than `toAffCoverData`; no `AffAdaptation` is built except by `ofAnchors`; `SwallowedBy` has no witness. Meanwhile 32 files still consume the old `DivFamZar`, and `partition₀`/`partition₁` still has 33 hits across 10 files, including `DivisorThetaDatum.lean:397-401`. The comparison is the *only* bridge from the landed old certificates to the new predicate, so it is the gate on the migration I-0492 clause 3 asked for.

Two docstring phantoms: `DivisorFamilyAffZar.lean:37` says "see `IsFibrewiseFiniteSupport` below" (zero hits in the tree), and `:49`/`:52` list `isLocallyCertifiedAff_of_isLocallyCertified` and `DivFamZar.toAff` under Main declarations (zero hits each) — the same file's body at `:127-143` correctly says the first is not landed.

## MOST SERIOUS ISSUE

`isCertified_of_swallowedBy` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffAssemble.lean:79-84`) assumes five clauses that the old lane's `isCertified_of_separated` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeCertZarSep.lean:277`) proves from a hypothesis that `SwallowedBy` implies in one line, and it cites the I-0340 refutation as if that were impossible. The refutation is about arbitrary adaptations; the theorem is about swallowed ones. This is the one place where the review found a claim in a docstring that a reader would take as a mathematical limit and that is not one.

## IS THE DECISION EXECUTED

**Partially — yes on the shape, no on the migration.**

Yes: the carrier is genuinely widened. `AffCoverData` types no piece into a chart, the partitions are absent from it, `ChartTyping` is correctly quarantined, the per-piece layer is restated for a bare open set (`DivisorFamilyAffPerPiece.lean:142`, `:160`), the covering hypothesis enters in exactly one place in its weak joint form (`:100-105`), both relocated obligations are visible in signatures, and the one new commutative-algebra input is a true statement with a correct proof. Zero sorries, all kernel-checked. Clause 5 is respected — no chart-avoid, no fixed-pair confinement, no retry of the rejected joint-cover leaf (that leaf was about relaxing `FinCoverData`'s partition *fields* while keeping the piece type; this changes the piece type, which is R2).

No: clause 3's operative sentence — "removing them will break consumers, repair the consumers deliberately" — was not executed. Nothing was removed and no consumer was repaired. Seven new files were added beside the old tower; the old chart-typed `DivFamZar` is still the live functor value for all 32 of its consumers, the 33 partition references are untouched, and the single bridge that would let existing certificates reach the widened predicate is the piece explicitly not landed. `ADDENDUM 5` (`informal/spec-dd-r.md:895`) says "R2 IS EXECUTED" and §5.1 says the partitions are "**deleted**" — they are deleted from `AffCoverData`, which never had them, not from the tree. That wording overstates the state.
