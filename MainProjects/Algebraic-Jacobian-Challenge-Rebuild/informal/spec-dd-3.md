# DD-3 port spec — the Grassmannian in the small submodule spelling — FINAL

*2026-07-16, Fable prover-architect; FINALIZED 2026-07-17 by the successor lane after
the predecessor's quota kill (ledger `8e2c5de6c` preserved this as a draft). BINDING
parent: `informal/dat-d-worksheet.md` (§2.2 the D2 spelling + the port table, §5 DD-3,
§6 risks 3/6/8, Discipline rule 5). Route map (READ-ONLY):
`SubProjects/GR-Quot-Closure/AlgebraicJacobian/Picard/GrassmannianCells.lean` +
`GrassmannianQuot.lean` — port statements and architecture, never copy proofs blind,
never import. Elaboration probe run by the draft pass (scratchpad `ProbeDD3.lean`,
`lake env lean` green); the successor lane RE-VERIFIED every mathlib claim below by
direct source read against the pinned mathlib (v4.31.0) — see the FINALIZATION
CORRECTIONS list at the end. The DD-F probe verdict landed GREEN in the meantime
(`9d0662ebc`): the primary route stands, the consumption map of §1 is unchanged.*

## 0. THE DECISIVE SEARCH FIND (supersedes half of the planned 3b)

The pinned mathlib contains **`Mathlib/RingTheory/Grassmannian.lean`** (Kenny Lau,
2025): `Module.Grassmannian R M k` = `G(k, M; R)` — a structure extending
`Submodule R M` with fields `finite_quotient : Module.Finite R (M ⧸ N)`,
`projective_quotient : Projective R (M ⧸ N)`,
`rankAtStalk_eq : ∀ p, rankAtStalk (M ⧸ N) p = k` — **exactly the D2 small submodule
spelling**: a set of submodules (ext-lemma provided; no setoid — GRQ's
`RankQuotient.Rel` is dissolved by mathlib itself), with

- `Module.Grassmannian.map (f : A →ₐ[R] B) : G(k, A ⊗[R] M; A) → G(k, B ⊗[R] M; B)`
  (spelled as `ker (baseChangeMkQ)`, i.e. the kernel of
  `B ⊗[R] M ≃ B ⊗[A] (A ⊗[R] M) → B ⊗[A] ((A ⊗[R] M) ⧸ N)`; the quotient stays finite
  projective of rank `k` by right-exactness + `rankAtStalk_baseChange` — the ENTIRE
  planned right-exactness campaign of 3b, already landed in mathlib);
- `map_id`, `map_comp` (functor laws), and `Module.Grassmannian.functor :
  CommAlgCat R ⥤ Type (max v w)`.

What mathlib does NOT have (their explicit TODO list): charts, the chart functor,
the scheme, representability. That remains this port's work (3a/3d/3e/3c).

**Consequences.** (i) The D2 carrier is CONSUMED from mathlib, not defined:
no project-owned subtype, no instance-home question (the two certificate fields are
`attribute [instance]` in mathlib; `rankAtStalk_eq` bridges to the worksheet's honest
fibre finrank via `Module.rankAtStalk_eq_finrank_tensorProduct :
rankAtStalk M p = finrank κ(p) (κ(p) ⊗[R] M)` — `FreeLocus.lean:282`, name corrected at
finalization; the free case `rankAtStalk_eq_finrank_of_free` (`:254`) is the gift that
certifies the tautological chart point, whose quotient is free of rank `d`). (ii) 3b shrinks from L to S–M: only the affine-opens VEHICLE at general
tests remains project work. (iii) Orientation: mathlib writes the ambient as
`R ⊗[k'] H` (`TensorProduct k' R H`, algebra factor LEFT — the only orientation with a
mathlib `Module R`-instance). The worksheet's `H ⊗ R` is realized as `R ⊗[k'] H`;
DD-4's on-the-nose identification `H⁰(C_R, Θ^A-glued) ≅ H_A ⊗ R` acquires ONE named
`TensorProduct.comm` seam at the DD-4 boundary (recorded there, not here).

## 1. The (3c) spec-time audit (worksheet §5 DD-3 + risk 8) — VERDICT

Question: does the campaign consume full `represents`
(`(grFunctor H g).RepresentableBy (Gr g H)`), or only the chart lemmas + the inverse
laws run directly on `DivScheme` in DD-R?

Reading of dat-d §3.4 (DD-R) and §4.2 (consumption rows):

- DD-R's output is `divRep : (divFunctor g).RepresentableBy (DivScheme g)` — built by
  the GRQ inverse-law ARCHITECTURE run on `DivScheme` itself (§3.4.3), not by
  restricting a representability of `Gr`. No §4.2 consumer row mentions `Gr`'s own
  representability; they take `DivScheme g + divRep`, `divQProj`, the window ledger.
- What DD-R actually pulls from the Gr side: (a) the **forward direction** — a test
  map `T ⟶ Z(♦) ⊆ GrPair` must yield the pair `(K_M, K_{M+s})` of functor points
  (pullback of the tautological/universal point), naturally: the natural transformation
  `Hom(-, Gr) ⟶ grFunctor`, NOT its invertibility; (b) the **chart lemmas**: the
  tautological point over each chart ring, the frame/unit-determinant classification of
  when a point factors through chart `I`, `Hom(Spec S, affineChart I) ≃` chart-ring
  maps (`MvPolynomial.aeval`'s universal property); (c) `Z(♦)`'s closed-subscheme
  universal property comes from 3e (entries ideal), chart-by-chart, glued on the frame
  atlas — again not from `represents`.
- DAT-C/DAT-B/DAT-glue rows: consume `divRep` and `divQProj` only.

**VERDICT: full `represents` for the ported `Gr` is NOT consumed by the campaign.**
(3c) is re-scoped to: (3c-i) the forward natural map
`grPoint : (T ⟶ Gr) → grFunctor(T)` (pullback of the tautological family) with
naturality — REQUIRED by DD-R; (3c-ii) the chart-side lemmas (tautological chart
points, frame classification) — REQUIRED by DD-R; (3c-iii) the packaged
`RepresentableBy` (both inverse laws on `Gr` itself) — **NOT consumed; trails
everything; built only if the lane has slack** (it remains the GRQ-modelled L→XL
piece; its DD-R value is as a template, and DD-R re-runs the pattern on `DivScheme`
anyway). This sizes DD-3's mandatory scope to (3a)+(3b)+(3e)+(3d)+(3c-i,ii).

## 2. The frozen spellings (probe-verified)

Base: `k : Type u`, `[Field k]` (the campaign instantiates `k := k'`; every file is
stated over an arbitrary field — "standing pack" instantiation is the consumer's job).
Generic Grassmannian parameters `(d r : ℕ)` (the campaign sets `d := g`,
`r := r_A = dim H_A`); charts indexed by `I : Finset (Fin r)`, `hI : I.card = d`.

- **(D2) functor value at a `k`-algebra `R`**: `G(d, R ⊗[k] H; R)`
  (= `Module.Grassmannian R (TensorProduct k R H) d`), for `H : Type u`
  `[AddCommGroup H] [Module k H]` (finite-dimensionality is NOT needed for the functor
  definition; chart/scheme statements take `H := Fin r → k` — see below).
  Map action: `Module.Grassmannian.map (f : R →ₐ[k] R')`. No setoid. `Type u`.
- **Vehicle at a general test** `T : Over (Spec (.of k))`: compatible families
  `s : Π U : T.left.affineOpens, G(d, Γ(T.left, U.1) ⊗[k] H; Γ(T.left, U.1))` with
  `Module.Grassmannian.map (Over.resAlgHom T h) (s V) = s U` for `h : U.1 ≤ V.1` —
  verbatim the `PicEt.lean:9–36` pattern (a subtype of the Π-type, `Type u`); section
  rings are `k`-algebras via the `Over.sectionsAlgebra` LOCAL instance
  (`attribute [local instance]`, the SectionsBaseChange house pattern — consumers must
  activate the same instance; this is the standing rule, not a new decision).
- **Ambient for the scheme side**: the chart/gluing lane is developed for the
  COORDINATE space `H = Fin r → k` exactly as GRQ does over ℤ (their `O^r`); the
  abstract-`H` interface enters through a basis choice at the DD-4 boundary (H_A comes
  with its own presentation; the worksheet's `r_A := dim H_A`). DD-3 exports the
  coordinate form; feeding an abstract finite-dimensional `H` through
  `Module.finBasis` is a named equiv at the consumer seam.
- **Charts** (3a): `affineChart k d r I := Spec (.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) k))`.
  Universal matrix / minors / Cramer / transitions: GRQ `GrassmannianCells.lean:56–282`
  re-derived over `k` with ONE architectural change: every ring map that GRQ carries as
  `→+*` (+ `RingHom.ext_int` for ℤ-constants) is carried as **`→ₐ[k]`** —
  `transitionPreMap` is `MvPolynomial.aeval` (already an AlgHom), `transitionMap` and
  the triple-overlap maps are `IsLocalization.liftAlgHom`, extensionality is
  `IsLocalization.algHom_ext` + `MvPolynomial.algHom_ext` (generators ONLY — the
  constants case disappears; this is a simplification, not a deviation). Scheme-level
  arrows: `Spec.map (CommRingCat.ofHom f.toRingHom)`. `Algebra k (Localization.Away P)`
  and the `IsScalarTower k R^I (Away P)` are mathlib instances (probe P3).
- **Glue data** (3a): mathlib `AlgebraicGeometry.Scheme.GlueData`
  (`Gluing.lean:91`), fields exactly as GRQ `:1141` (index
  `{I : Finset (Fin r) // I.card = d}`); `grScheme k d r := (glueData k d r).glued`.
  **Structure morphism** (new vs GRQ — over ℤ they used terminality): descend
  `fun I => Spec.map (ofHom (algebraMap k R^I))` through the glued scheme's own
  colimit universal property, `Multicoequalizer.desc (glueData k d r).diagram`
  (REFINED at finalization from the draft's `Scheme.Cover.glueMorphisms`, whose
  compatibility is pullback-shaped; the multicoequalizer compatibility is the bare
  triangle `chartIncl I J ≫ s I = (chartTransition I J ≫ chartIncl J I) ≫ s J`, which
  reduces by `Spec.map`/`chartTransition_comp_chartIncl` to the ring identity
  "`θ̃_{I,J}` lies over `k`" — automatic from the AlgHom architecture). Triangle lemma
  `ι_grStructMap` from `Multicoequalizer.π_desc` (`GlueData.ι` IS the multicoequalizer
  `π`, `CategoryTheory/GlueData.lean:168`). `Scheme.OpenCover.glueMorphisms`
  (`Gluing.lean:439`) remains the fallback spelling if the desc route fights.
  Export `grOver k d r : Over (Spec (.of k))`.
- **Separatedness** (3d): `diagonalRingMap` as GRQ `:1202` but with
  `Algebra.TensorProduct.lift` over `k` (`R^I ⊗[k] R^J →ₐ[k] R^I_J`), surjectivity
  verbatim (`:1231`), then `IsSeparated (grStructMap k d r)` by the GRQ patch
  computation (`:1359`, `openCoverOfLeftRight` + `pullbackDiagonalMapIdIso` +
  `IsClosedImmersion.spec_of_surjective`). Quasi-compactness/finite-type of the
  structure map are DD-Q's bundle rows, but the finite-atlas fact they need is 3a's
  glue-data index finiteness — exported here as an instance
  (`Finite (glueData k d r).J`).
- **Frame-atlas exports** (3d, chart PLUMBING per the §3.5 ruling): the chart
  overlaps ARE basic opens by construction (`chartOverlap = Spec (Away P^I_J)`); the
  exports are (i) `Hom(Spec S, affineChart I) ≃ (R^I →ₐ[k] S)` ≃ matrix data
  (aeval universal property, stated once), (ii) the ranges of the glue-data `ι I`
  form a finite affine open cover (mathlib `GlueData.openCover`), (iii) for a
  `grFunctor` point over a ring `S` whose quotient is FREE with a chosen frame, the
  `I`-minor-unit criterion for factoring through chart `I` (feeds DD-R's chart-local
  inverse; the general locally-free case reduces to this over a basic-open cover —
  that reduction is (3c-ii) work).
- **(3e) the entries-ideal gift**, stated REUSABLY (DD-R's (♦) carve consumes it):
  for `M N : Module R` with `M` finite (generators) and `N` finite projective
  (split embedding `Module.Finite.exists_comp_eq_id_of_projective`, probe P4), and
  `φ : M →ₗ[R] N`: an ideal `entriesIdeal φ` with the universal property
  `∀ (S) (f : R →ₐ[k] S)` (equivalently `→+*`): `φ ⊗ S = 0 ↔ entriesIdeal φ ≤ ker f`
  (spelled: the base-changed map `LinearMap.baseChange S φ` vanishes iff …);
  then `vanishingLocus φ := Spec (R ⧸ entriesIdeal φ)` with
  `IsClosedImmersion (Spec.map (ofHom (Ideal.Quotient.mk _)))`
  (`spec_of_surjective`, instance at `ClosedImmersion.lean:113`) and the rep property:
  a ring map `R → S` kills `entriesIdeal φ` iff it factors (uniquely) through the
  quotient. Universal property stated at ring level (module-algebra-only carrier —
  worksheet §1.1 discipline); the scheme-level wrapper is thin.
- **(3e) `grPair k d₁ r₁ d₂ r₂ := pullback (grStructMap k d₁ r₁) (grStructMap k d₂ r₂)`**
  (mathlib `Limits.pullback` in `Scheme`), with its two projections and structure map;
  the campaign instantiates the two windows. Product-of-glued-schemes chart plumbing
  (affine product atlas `openCoverOfLeftRight`) re-exported with names.
- **(3c-i)** `grPoint : (T ⟶ grScheme) → vehicle value` — pullback of the tautological
  family. The tautological family over `grScheme` is delivered CHART-WISE (the
  universal point of `G(d, R^I ⊗[k] (Fin r → k); R^I)` = kernel of the universal-matrix
  presentation) + the GL-cocycle compatibility (GRQ `bundleTransition` lane, re-derived
  in the small spelling as an equality of `Grassmannian.map`-images over the overlap
  rings — no sheaf carrier, no `T.Modules`, so GRQ's L1–L3 transport collapses to
  matrix algebra over rings).

## 3. Module layout (all new files in `AlgebraicJacobian/Picard/`, ≤ 500 lines each,
`set_option autoImplicit false`, explicit binders, universe `u` throughout)

| file | stage | contents (keystones bold) |
|---|---|---|
| `GrassmannianChart.lean` | 3a | chart ring abbrev, `affineChart`, `universalMatrix`, `minorDet`, `universalMinor(+Inv)`, `imageMatrix`, `transitionPreMap` (aeval), self-minor lemmas, `isUnit_transitionPreMap_minorDet`, **`transitionMap`**, **`transitionMap_self`** |
| `GrassmannianCocycle.lean` | 3a | `awayInclLeft/Right` (k-AlgHoms) + comp lemmas, cross-unit lemma, `cocycleΘIJ/JK/IK`, `imageMatrix_map_eq`, **`cocycleCondition`** |
| `GrassmannianPhi.lean` | 3a | `awayMulCommEquiv`, rotation lemma, `transitionInvPair`, **`cocyclePhiId`** |
| `GrassmannianGlue.lean` | 3a | `chartOverlap/Incl/Transition`, `awayPullbackIso` + leg lemmas, `chartTransition'`, `t_fac`, scheme-level cocycle, **`glueData`**, **`grScheme`**, `Finite J` instance |
| `GrassmannianScheme.lean` | 3a | **`grStructMap`** (glued structure morphism over `k`), `ι_grStructMap`, **`grOver`**, chart-immersion plumbing (`pullbackιIso` + legs) |
| `GrassmannianFunctor.lean` | 3b | vehicle: `grSubfunctor`-families over `T.left.affineOpens` valued in `G(d, Γ ⊗[k] H; Γ)`, restriction along test maps deferred to the DD-R seam (only affine-opens compatibility here), affine comparison `grFunctorAffineEquiv` (top-open collapse, PicEt pattern), naturality lemmas |
| `EntriesIdeal.lean` | 3e | **`entriesIdeal`** + universal property (`baseChange_eq_zero_iff`), functoriality |
| `VanishingLocus.lean` | 3e | **`vanishingLocus`** = `Spec (R ⧸ entriesIdeal φ)`, **`isClosedImmersion_vanishingLocusι`**, rep property of ring maps |
| `GrassmannianPair.lean` | 3e | **`grPair`** + projections + structure map + affine product atlas names |
| `GrassmannianDiagonal.lean` | 3d | `diagonalRingMap` (Algebra.TensorProduct.lift over k), left/right evals, **`diagonalRingMap_surjective`** |
| `GrassmannianSeparated.lean` | 3d | **`isSeparated_grStructMap`** (patch computation), frame-atlas export lemmas |
| `GrassmannianTautological.lean` | 3c-i/ii | chart tautological point, GL-cocycle compat, **`grPoint`** + naturality, chart classification (`I`-minor-unit criterion) |
| (trailing, unfunded) | 3c-iii | inverse-law packaging `RepresentableBy` — only if slack |

Root list `AlgebraicJacobian.lean`: append imports in the order above (minimal atomic
edits, re-read immediately before editing, one edit per landed stage).

Namespace: `AlgebraicGeometry.Grassmannian` (no clash: the GRQ tree is a separate
lake project, never imported — Discipline rule 5). Names mirror GRQ's where the
statement is the same mathematics (route-map traceability) and mathlib's where the
object is mathlib's.

## 4. Port table (row-by-row route map, worksheet §2.2 table refined)

| GRQ (their tree) | this port |
|---|---|
| `affineChart d r I` over ℤ (`GrassmannianCells.lean:56`) | `affineChart k d r I` over `k` (`GrassmannianChart.lean`) |
| `universalMatrix/minorDet/...Inv/imageMatrix` (`:78–136`) | verbatim over `k` |
| `transitionPreMap` `→ₐ[ℤ]` + `RingHom` lifts (`:141,:245`) | `→ₐ[k]` + `IsLocalization.liftAlgHom`; ext by `algHom_ext` (NO ℤ-constants case) |
| `cocycleCondition` (`:604`), `cocyclePhiId` (`:1066`) | same telescope, AlgHom form |
| `theGlueData`/`scheme` (`:1141,:1157`) | `glueData`/`grScheme` via mathlib `Scheme.GlueData` |
| `toSpecZ` by terminality (`:1288`) | `grStructMap` by `Cover.glueMorphisms` (Spec k is not terminal) |
| `isSeparatedToSpecZ` (`:1359`) | `isSeparated_grStructMap`, same patch computation |
| properness/valuative lane (`:1484–2047`) | **NOT PORTED** (nothing in §4.1/§4.2 consumes it; Wave-5 takes qc only) |
| `RankQuotient`/`Rel`/`rqSetoid` (`GrassmannianQuot.lean:2258–2292`) | **dissolved**: mathlib `Module.Grassmannian` (§0) |
| `rqPullback` (`:2300`) | mathlib `Module.Grassmannian.map` |
| `functor` `Type 1`-valued (`:2341`) | vehicle families, `Type u` (`GrassmannianFunctor.lean`) |
| `universalQuotient`/`tautologicalQuotient` (`:1835,:2229`) + `T.Modules` diamond | chart-wise tautological `Module.Grassmannian` point + GL-cocycle compat (no sheaf carrier — diamond moot) |
| `isoLocus/chartLocus/chartLocus_isOpenCover` (`:2545–2680`) | `I`-minor-unit criterion at ring level (3d/3c-ii); basic opens by construction |
| `grPointOfRankQuotient` + inverse laws (`:4984,:5024–5588`) | forward `grPoint` + chart classification (3c-i/ii); full inverse packaging = 3c-iii, trails |
| `represents` (`:5600`) | audit verdict §1: NOT consumed; 3c-iii only if slack |
| SNAP/graded lane (`SectionGradedRing.lean`) | NOT PORTED (worksheet order) |

## 5. Stage/commit plan and discipline

Order: 3a (chart → cocycle → phi → glue → scheme; commit per green file-group) →
3b → 3e → 3d → 3c-i/ii → (3c-iii if slack). STAGED FALLBACK (sanctioned): (3a)+(3b)+(3e)
suffice for DD-R statements; land those green with precise WIP messages if stopped.

Keystones get `lean_verify`, axioms exactly `[propext, Classical.choice, Quot.sound]`:
`transitionMap_self`, `cocycleCondition`, `cocyclePhiId`, `grScheme`+`glueData`
(defs — verify their `_fac`/cocycle theorems), `grStructMap` triangle lemma,
`entriesIdeal` universal property, `isClosedImmersion` of the vanishing locus,
`isSeparated_grStructMap`, `grPoint` naturality. Lake mutex on EVERY lake invocation
— the **mkdir DIRECTORY lock** of `informal/protocol-concurrent-lanes.md` §2
(acquire by `mkdir /tmp/claude-1001/ajcr-locks/lake.lock`, release by `rmdir`; a plain
FILE at that path is by definition stale — the draft said `flock` here, which is the
EXACT protocol violation that deadlocked the 07-16 fleet; corrected at finalization).
Ledger commits by the private-index+CAS recipe of that protocol (§1), verified with
`show --stat HEAD`. Files ≤ 500 lines. GRQ `set_option maxHeartbeats`-raises are legitimate to mirror where the same
instance-diamond cost appears (they are elaboration cost, not kernel raises); the
07-14 rule "restructure, don't raise" applies to KERNEL deterministic timeouts.
Windows/numerics: none appear in DD-3 (nothing to route through DD-0).

Roadmap: `AJCR.w4-rep.datum.dat-d.dd3` updated at every landed stage.

## 6. FINALIZATION CORRECTIONS (2026-07-17, successor lane — what changed vs the draft)

Every mathlib claim of §0/§2 re-verified by direct source read this pass:
`Module.Grassmannian` + `map`/`map_id`/`map_comp`/`functor`
(`RingTheory/Grassmannian.lean:68–192`, orientation `A ⊗[R] M` confirmed, ext lemma
`:84`, instance attributes `:73`); `Scheme.GlueData` (`Gluing.lean:91`),
`OpenCover.glueMorphisms`/`ι_glueMorphisms` (`:439,:462`);
`IsClosedImmersion.spec_of_surjective` (`Morphisms/ClosedImmersion.lean:99`, quotient
instance `:113–115`); `IsLocalization.liftAlgHom` (`Localization/Basic.lean:202`, with
`coe_liftAlgHom` bridging to `IsLocalization.lift`, so the `Away.lift`-style rewriting
kit still fires at the function level; no `Away.liftAlgHom` exists — a small
powers-units helper is needed); `IsLocalization.algHom_ext` (`:670`);
`MvPolynomial.algHom_ext` (`Algebra/MvPolynomial/Basic.lean:437`);
`Module.Finite.exists_comp_eq_id_of_projective` (`Finiteness/Projective.lean:30`);
`openCoverOfLeftRight` (`Pullbacks.lean:547`); `rankAtStalk` kit (`FreeLocus.lean:187`,
`:245,:254,:282,:326`). Corrections:

1. **(3c) audit section**: the draft's warning said it might be unfinished — it was in
   fact complete; the verdict was RE-DERIVED this pass against worksheet §3.4/§4.2/§5
   and STANDS as written (§1). The DD-F GREEN verdict does not alter it: DD-R still
   builds `divRep` on `DivScheme` itself and consumes only (3a)+(3b)+(3e)+(3c-i,ii).
2. **Probe P5 name**: `Module.rankAtStalk_eq` does not exist; the fibre-finrank bridge
   is `rankAtStalk_eq_finrank_tensorProduct` (`FreeLocus.lean:282`); free-case gift
   `rankAtStalk_eq_finrank_of_free` (`:254`) added for the tautological point.
3. **Structure morphism route**: `Multicoequalizer.desc` on the glue-data diagram
   (triangle-shaped compatibility, no pullbacks) replaces `Cover.glueMorphisms` as
   primary; the latter demoted to fallback. §2 updated in place.
4. **Lake mutex**: the draft prescribed `flock` — corrected to the BINDING mkdir
   directory lock of `protocol-concurrent-lanes.md` §2; ledger commits via
   private-index+CAS (§1 of the protocol).
5. **House-pattern names confirmed** for 3b against the tree: local instance
   `Over.sectionsAlgebra`, restrictions `Over.resAlgHom T h : Γ(V) →ₐ[k] Γ(U)` for
   `h : U ≤ V` with `resAlgHom_comp`/`resAlgHom_rfl`, affine collapse via
   `Over.overSpecΓTopAlgEquiv` + top affine open (`PicEt.lean` / `PicEtSections.lean`).
