Inventory complete. All names below are the exact fully-qualified constants (cross-checked against the compiled `.ilean` declaration tables in `.lake/build/lib/lean/AlgebraicJacobian/`, so they are exactly as Lean sees them); `file:line` is the line of the `theorem`/`def`/`instance` keyword.

Root: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/`

## Cone 6 — Headline (`AlgebraicJacobian/Jacobian.lean`, `AbelJacobi.lean`)

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.IsAlbanese` | Jacobian.lean:71 | no (def) | — |
| `AlgebraicGeometry.IsAlbanese.unique` | Jacobian.lean:102 | no | — |
| `AlgebraicGeometry.JacobianWitness` | Jacobian.lean:147 | no (structure) | — |
| `AlgebraicGeometry.picardJacobianWitness` | Jacobian.lean:186 | **BODY `sorry`** (line 189) — the single root sorry of the headline | — |
| `AlgebraicGeometry.nonempty_jacobianWitness` | Jacobian.lean:199 | via `picardJacobianWitness` | — |
| `AlgebraicGeometry.Jacobian` | Jacobian.lean:222 | via witness | — |
| `AlgebraicGeometry.Jacobian.instGrpObj` / `.smoothOfRelativeDimension_genus` / `.instIsProper` / `.instGeometricallyIrreducible` | Jacobian.lean:233 / 237 / 241 / 244 | all via witness | — |
| `AlgebraicGeometry.Jacobian.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp` | AbelJacobi.lean:60 / 71 / 91 | pure projections of the witness | — |

Everything in `AbelJacobi.lean` and all four `Jacobian.*` instances are `sorryAx`-tainted only through `picardJacobianWitness`.

## Cone 1 — Picard representability

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.Scheme.instHasPicScheme` | Picard/FGAPicRepresentability.lean:259 | **BODY `⟨sorry⟩`** (line 263) — file's only sorry; an `instance` | needs `[HasRationalPoint C]` |
| `AlgebraicGeometry.Scheme.PicScheme.picSharp` | …:150 | no | — |
| `AlgebraicGeometry.Scheme.PicScheme.representable` | …:576 | no; extracts from `HasPicScheme` | `[HasPicScheme C]` `[PicSharpRepresentable C]` (both have producers) |
| `AlgebraicGeometry.Scheme.PicScheme.groupSchemeStructure` | …:630 | no | `[HasPicScheme C]` |
| `AlgebraicGeometry.Scheme.PicScheme.abelMapWitness` | …:404 | no (proved: `abelKernelNatTrans ≫ picNeg`) | — |
| `AlgebraicGeometry.Scheme.PicScheme.abelMap_app_mk` | …:444 | no (`rfl`) | — |
| `AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient` | …:514 | no (extracts conclusion) | **`[HasSmoothProperQuotient α]` — deliberately instance-free gate** |
| `AlgebraicGeometry.Scheme.PicScheme.HasSmoothProperQuotient` | …:494 (class) | — | no producer anywhere (by design; Hironaka counterexample) |
| `AlgebraicGeometry.Scheme.PicScheme.isSeparated` / `.instPicSchemeLocallyOfFiniteType` | …:700 / 669 | no; `choose_spec` of the sorried existential | `[HasPicScheme C]` |

Supporting keystones in the same cone (all `sorry`-free bodies):
- `AlgebraicGeometry.Scheme.representable_of_openCover` — Picard/ZariskiDescentRepresentability.lean:1353 (Zariski descent of representability).
- `AlgebraicGeometry.Scheme.Grassmannian.representable` — Picard/GrassmannianRepresentability.lean:595; `…Grassmannian.isZariskiSheaf` :582; `…representable_restrict` :559.
- `AlgebraicGeometry.Scheme.QuotScheme` — Picard/QuotRepresentability.lean:73 — **BODY `sorry`** (line 79), the single tracked Quot leaf.
- `AlgebraicGeometry.Scheme.pushforward_locallyFree_of_h1_vanishing` — Picard/RigidPushforward.lean:390; `…pushforward_baseChange_of_h1_vanishing` :408; `…pushforward_isLocallyTrivial_of_h1_vanishing` :486. All three take **`[HasRigidPushforward C]`**, class at Picard/RigidPushforward.lean:373, **no producer anywhere** (confirmed by grep) — so these are gate-conditional, not sorried.
- `AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_of_p1` — Picard/RigidPushforward.lean:699 (ℙ¹ reduction, `sorry`-free, takes `hP1 : P1RigidPushforwardStatement k A` as an explicit hypothesis).
- `AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_of_p1Engine` — Picard/RigidPushforwardTransfer.lean:1391 (all four transfer hypotheses discharged; still consumes `hP1` explicitly). Transfer legs: `…pushforward_finiteMapToP1BaseChange_isFinitePresentation` :371, `…_coherentSheafFlat` :523, `…_fiberH0` :1242, `…_fiberH1` :1366; general engine `AlgebraicGeometry.isIso_pushforwardBaseChangeMap_of_isPullback` :1108.
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` — Picard/TensorObjInverse.lean:3279 (`lemma`, proved).
- `AlgebraicGeometry.Scheme.isIso_snd_appTop` — Picard/StructureSheafPushforward.lean:260; `…bijective_snd_appTop_baseChange` :80; `…instHasStructureSheafPushforwardIso` :308; `…eq_one_of_section_of_restrict_eq_one` :375.
- `AlgebraicGeometry.Scheme.instHasTrivialConstants` — Picard/SectionRingUniversal.lean:328 (unconditional); `…isField_globalSections` :102, `…finiteDimensional_globalSections` :127, `…globalSectionsAlgEquivBase` :151.
- `AlgebraicGeometry.Scheme.PicSharp.exists_rigidification_relPicRel` — Picard/RigidifiedPic.lean:86 (Kleiman `lm:fff`); `…rationalPointSection` :120.
- `AlgebraicGeometry.Scheme.PicScheme.abelDeg` — Picard/DivDegree.lean:678; `…abelDeg_eq` :701; `…divFunctorDeg_sigma_bijective` :587; `…divFunctorDeg_sigma_bijective_of_gate` :639 takes gate `AlgebraicGeometry.Scheme.HasLocallyConstantDivDeg` (:629, no producer). DivDegree.lean is sorry-free.
- Galois quotient lane: `AlgebraicJacobian.GaloisDescent.isGaloisQuotient_spec` — Picard/FiniteGaloisQuotientAffine.lean:473 (affine case, proved); `…affineGaloisQuotientHomEquiv` — Picard/FiniteGaloisQuotient.lean:532; gates `…HasGaloisQuotient` (FiniteGaloisQuotient.lean:393, **no producer**) and `…HasStableAffineCover` (:203, producer exists); `…hasStableAffineCover_of_orbitsInAffineOpen` — Picard/StableAffineCover.lean:279 (instance, proved); `…SemilinearGalAction.exists_stable_affineOpen_of_orbitsInAffineOpen` — StableAffineCover.lean:193.
- Descent heart: `AlgebraicJacobian.GaloisDescent.SemilinearAction.descentAlgEquiv` — Picard/GaloisDescent/SemilinearAlgebras.lean:171; `…invariantAlgHomEquiv` :363; `…SemilinearAction.descentMap_bijective` — GaloisDescent/SemilinearModules.lean:360, `…descentEquiv` :367, `…finrank_invariants` :377.
- `AlgebraicGeometry.Scheme.PicSharp.relPresheaf` — Picard/RelPicFunctor.lean:855; `…relFunctorial` :802; `…etSheaf` :948; `…etSheaf_group_structure` :991.

## Cone 2 — Pic⁰ as abelian variety

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso` | Picard/Pic0AbelianVariety.lean:768 | body proved, but consumes sorried `finrank_cotangentSpaceDual_eq_finrank_h1Cok` | `[HasPicScheme C]` `[PicScheme.PicSchemeLocallyOfFiniteType C]` (both have producers, the former sorried) |
| `AlgebraicGeometry.Scheme.Pic0.smooth` | …:800 | **BODY `sorry`** (806) | same |
| `AlgebraicGeometry.Scheme.Pic0.proper` | …:820 | **BODY `sorry`** (826) | same |
| `AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible` | …:843 | no (from `IdentityComponent.isFiniteTypeGeometricallyIrreducible`) | same |
| `AlgebraicGeometry.Scheme.Pic0.isAbelianVariety` | …:874 | assembly only; inherits `smooth`/`proper` sorries | same |
| `AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety` | …:893 | = `Pic0.isAbelianVariety` | same |
| `AlgebraicGeometry.Scheme.Pic0.finrank_cotangentSpaceDual_eq_finrank_h1Cok` | …:657 | **BODY `sorry`** (672) — the reduced Kleiman §5 Thm 5.11 core | same |
| `AlgebraicGeometry.Scheme.Pic0.grpObj` | …:248 | no | same |

Also: `AlgebraicGeometry.Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` (:693, proved from the core), `AlgebraicGeometry.Scheme.Pic0.tangentSpaceCotangentDual` (:569, proved).

In `Picard/IdentityComponent.lean`:
- `AlgebraicGeometry.Scheme.Pic0Scheme` — :1385 (def, no sorry)
- `AlgebraicGeometry.Scheme.PicScheme.degree` — :1427 — **BODY `sorry`** (1432)
- `AlgebraicGeometry.Scheme.Pic0Scheme.finrank_eq_genus` — :1469 — **BODY `sorry`** (1475)
- `AlgebraicGeometry.Scheme.Pic0Scheme.kPoints_iff_kerDegree` — :1495 — **BODY `sorry`** (1504)
- `AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme` :286, `.isSubgroupHomomorphism` :736, `.baseChangeIso` :1115, `.isFiniteTypeGeometricallyIrreducible` :1342 — all sorry-free.
- There is **no** `PicScheme.representable` in this file; it lives at `AlgebraicGeometry.Scheme.PicScheme.representable` (FGAPicRepresentability.lean:576).

## Cone 3 — Cohomology

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.cech_computes_higherDirectImage` | Cohomology/CechToHigherDirectImage.lean:111 | no | `[HasInjectiveResolutions X.Modules]`, `hres` explicit |
| `AlgebraicGeometry.cechHigherDirectImage` | Cohomology/CechHigherDirectImageUnconditional.lean:82 | no (def) | — |
| `AlgebraicGeometry.pullback_preservesFiniteLimits` | …Unconditional.lean:161 | **BODY `sorry`** (162) — an `instance`, `[Flat g]` | — |
| `AlgebraicGeometry.cech_flatBaseChange` | …Unconditional.lean:1799 | assembly proved; depends on the sorried instance + `cechComplex_baseChange_iso` | — |
| `AlgebraicGeometry.cechComplex_baseChange_iso` | …Unconditional.lean:1752 | inherits from the two natIsos below | — |
| `AlgebraicGeometry.cech_pushforward_baseChange_natIso` | …Unconditional.lean:1590 | **`sorry` in `naturality` field** (1634) | — |
| `AlgebraicGeometry.twisted_cech_nerve_iso` | …Unconditional.lean:1656 | **`sorry` in `naturality` field** (1705) | — |
| `AlgebraicGeometry.Scheme.subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen` | Cohomology/StructureSheafModuleK/AffineDegreeOneVanishing.lean:714 | no — the degree-1 affine vanishing keystone, sorry-free | — |

Also: `AlgebraicGeometry.pushforwardBaseChangeMap` — Cohomology/FlatBaseChange.lean:81; `AlgebraicGeometry.affinePushforwardPullbackBaseChange` :765; `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis` :130 (all sorry-free). QC sibling keystone: `AlgebraicGeometry.Scheme.subsingleton_hModule'_one_of_isAffineOpen_of_isQuasicoherent` — Cohomology/StructureSheafModuleK/QuasicoherentDegreeOneVanishing.lean:719.

## Cone 4 — Riemann-Roch

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.Adelic.instModuleFiniteHModuleOne` | RiemannRoch/Adelic/GenusUnconditional.lean:408 | no — unconditional genus finiteness, an `instance` | none (all gates derived) |
| `AlgebraicGeometry.Adelic.module_finite_hModule_one` | …:381 | no | `[HasFiniteMapToP1 C]` `[P1HasLaurentChartData k]` (both have producers) |
| `AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cok_curve` | …:348 | no — gate-free `H¹ ≃ Ȟ¹` | — |
| `AlgebraicGeometry.Scheme.AffineCoverMVSquare.chi_unit_eq_one_sub_genus` | RiemannRoch/CohomologyKit.lean:532 | no | — |
| `AlgebraicGeometry.Scheme.AffineCoverMVSquare.h1_unit_eq_genus` | …:481 | no | — |
| `AlgebraicGeometry.Scheme.AffineCoverMVSquare.h0_unit_eq_one` | …:521 | no | — |
| `AlgebraicGeometry.Scheme.WeilDivisor.degree` | RiemannRoch/WeilDivisor.lean:973 | no (def); `…degree_hom` :988 | — |
| `AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero` | …:1161 | **`sorry` in the non-constant branch** (1194) — the one open leaf | — |

`RiemannRoch/CurveBaseChange.lean` is sorry-free; headline `AlgebraicGeometry.Scheme.baseChangeField` :250 plus the instance battery :256/265/277/285/294/300/308 and `AlgebraicGeometry.Scheme.AffineCoverMVSquare.baseChangeField` :340.

## Cone 5 — Albanese

| name | file:line | sorry | gates |
|---|---|---|---|
| `AlgebraicGeometry.Pic0.albanese_universal_property` | Albanese/AlbaneseUP.lean:590 | assembly proved; inherits the five sorries below | — |
| `AlgebraicGeometry.Pic0.abelJacobi` | …:333 | **BODY `sorry`** (335) | — |
| `AlgebraicGeometry.Pic0.SymmetricPower` | …:377 | **BODY `sorry`** (382) | — |
| `AlgebraicGeometry.Pic0.symmetricPowerAVMap` | …:411 | **BODY `sorry`** (416) | — |
| `AlgebraicGeometry.Pic0.symmetricPowerToJacobian` | …:450 | **BODY `sorry`** (453) | — |
| `AlgebraicGeometry.Pic0.descentThroughBirationalSigma` | …:488 | **BODY `sorry`** (496) | — |
| `AlgebraicGeometry.Pic0.albanese_eq_iff_symmetricPower_eq` | …:524 | **BODY `sorry`** (533) | — |
| `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` | Albanese/Thm32RationalMapExtension.lean:228 | body proved; consumes sorried `indeterminacy_pure_codim_one_into_grpScheme` | — |

Supporting: `AlgebraicGeometry.Pic0.bundle` / `.jacobianScheme` — AlbaneseUP.lean:259 / 275 (sorry-free, but carry `instHasPicScheme`'s taint). `AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme` — Albanese/CodimOneExtension.lean:1691, **BODY `sorry`** (1751, Milne Lemma 3.3 substeps 2–4b); `…existsUnique_hom_of_indeterminacyLocus_eq_empty` :1636 and `…codimOneFree_of_smooth_of_complete` :1570 and `AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one` :1355 are sorry-free. `Albanese/DifferenceMap.lean` and `Albanese/Milne33Substeps.lean` are entirely sorry-free (`AlgebraicGeometry.Scheme.RationalMap.differenceRationalMap` :185, `…le_domain_differenceRationalMap` :316, `…reconstruct_precomp_fst` :335, `…le_domain_precomp_fst_of_difference` :368; `AlgebraicGeometry.Scheme.exists_specializes_coheight_eq_one_of_mem_maximalIdeal` — Milne33Substeps.lean:220).

## Every `sorry`-bodied *instance* in the whole AlgebraicJacobian tree

Exactly two. I inspected the enclosing declaration of all 26 code-level `sorry` occurrences (the other ~100 grep hits are prose in docstrings/comments):

1. `AlgebraicGeometry.Scheme.instHasPicScheme` — `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:259` (body `⟨sorry⟩` at 263). `noncomputable instance`, conditional on `[HasRationalPoint C]`.
2. `AlgebraicGeometry.pullback_preservesFiniteLimits` — `AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean:161` (`:= sorry` at 162). `instance`, conditional on `[Flat g]`.

All other code-level sorries sit in `theorem`/`def` bodies (or in a `NatIso.ofComponents` naturality field): Jacobian.lean:189, Pic0AbelianVariety.lean:672/806/826, IdentityComponent.lean:1432/1475/1504, QuotRepresentability.lean:79, SerreFiniteness.lean:79 (`AlgebraicGeometry.sectionGradedModule_fg`) / 262 (`AlgebraicGeometry.gradedHilbert_fiber`), QuotFunctorDef.lean:460 (`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso`) / 715 (`AlgebraicGeometry.Scheme.gammaFiber_finrank_baseChange_field`), CechHigherDirectImageUnconditional.lean:1634/1705, WeilDivisor.lean:1194, AlbaneseUP.lean:335/382/416/453/496/533, CodimOneExtension.lean:1751.

Two notes for your `#print axioms` run: (a) no `axiom` declarations exist in the tree — the only taint vector is `sorryAx`; (b) `AlgebraicJacobian/Picard/LineBundlePullback.lean:136` docstrings still describe `Scheme.LineBundle.OnProduct` as a "typed `sorry` carrier", but the current body is an honest subtype (`{ M // IsLocallyTrivial M }`), so that comment is stale.
