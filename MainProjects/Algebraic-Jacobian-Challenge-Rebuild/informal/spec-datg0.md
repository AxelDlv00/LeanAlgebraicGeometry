# SPEC-DAT-G0 — the `K_s → k'` transfer of the representing datum (DAT-glue's mountain)

*2026-07-19, Opus design lane (`AJCR.w4-rep.datum.dat-glue`, feasibility-first mini-spec).
Parent: `informal/w4-datglue-worksheet.md` §3.3 (the frozen spec skeleton), §0.4 (the
ownership decision — DAT-glue owns DAT-G0), §5.1 (the fallback record).  Absorbed:
I-0256 (worksheet landing), I-0248 (WHY `K_s` not `k'`), I-0255 (the tower-diamond wall),
I-0249 (universe whnf).  Frozen handoff: `AlgebraicJacobian/Picard/PicRepDatum.lean`
(DG-0, this pass — the `PicRepDatum k'` shape DAT-G co-signs against).  Every mathlib
`file:line` below was verified by DIRECT READ of the pinned checkout
`.lake-packages/mathlib` (v4.31.0) this pass — grep + read only, no LSP, no lake for the
design.  This spec exists because DAT-G0 is heavy enough (worksheet §0.4 caveat) to
warrant its own mini-spec before proving.*

---

## §0 THE FEASIBILITY VERDICT (the ETA-relevant bit)

### §0.1 One-line verdict

**PROVABLE-IN-TREE, with a pinned route — NOT "needs the orchestrator fallback" as the
primary path.**  The `K_s → k'` transfer factors into five bricks (§3); four have strong
landed / mathlib avatars, and the campaign balloon collapses onto **ONE genuine new brick
with no direct avatar — DG-G0.β, the descent of the representing isomorphism** from `K_s`
to a finite separable stage.  That brick is itself decomposable and rides landed
substrate, but its *exact vehicle* (filtered-colimit descent vs fpqc descent) needs a
**focused probe** whose single pivot is stated in §4.3.  The worksheet's "**L→XL, honest
new mathematics, no landed avatar**" (§0.5) **downgrades to L**: mathlib turns out to hold
the hearts — the full EGA IV.8 spreading machinery, ring-level *and* scheme-level, plus an
fpqc topology that is already subcanonical, plus the separable-closure-as-filtered-colimit
substrate.  This is the SlicingFlatKernel / SupportTubeFinite precedent exactly (mathlib
had the local hearts): **CHECK-before-declaring-XL was right, and it paid off.**

### §0.2 What the hard search actually found (supersedes worksheet §3.3 "no landed avatar")

The worksheet §3.3 flagged all three DAT-G0 steps "**No landed avatar — NEW.**"  This is
**too pessimistic for steps 1 and 3, and partially so for step 2.**  Verified this pass:

| DAT-G0 needs | mathlib status | file:line |
|---|---|---|
| **scheme-level EGA IV.8** — inverse limits w/ affine transition maps; spread schemes, morphisms, covers, affineness, lft, **lfp** to a finite stage | **LANDED** (stacks 01YT/01Z2–01ZC) | `AlgebraicGeometry/AffineTransitionLimit.lean` (whole file) |
| **ring-level EGA IV.8** — `RingHom.FinitePresentation` ⟺ `Hom_R(S,−)` preserves filtered colimits; a hom from f.p. `S` to `colim F` factors through a stage; two homs agreeing at `colim` agree at a stage | **LANDED** | `Algebra/Category/Ring/FinitePresentation.lean:45,81,144,169` |
| **fpqc/fppf topology + subcanonicality + flat descent of properties** | **LANDED** | `AlgebraicGeometry/Sites/Fpqc.lean`; `Morphisms/{FlatDescent,LocalFlatDescent,Descent}.lean` |
| **`K_s` = filtered colimit of finite separable subextensions** | **LANDED substrate** (directed iSup of intermediate fields; separable of an iSup) | `FieldTheory/IntermediateField/Adjoin/Basic.lean:114,124,201`; `FieldTheory/SeparableClosure.lean:256`; `FieldTheory/IsSepClosed.lean` |
| **representability along a colimit** (categorical avatar) | **PARTIAL avatar** — corepresentability of `F ⋙ coyoneda` at a colimit | `CategoryTheory/Adjunction/PartialAdjoint.lean:154` (`corepresentableByCompCoyonedaObjOfIsColimit`) |
| **descent of `RepresentableBy` / iso-of-sheaves along fpqc or a filtered base colimit** | **GENUINE GAP — no avatar** | — |

Only the last row is a true gap.  The morphism-spreading half of DAT-G0 (steps 1, 3) is a
bounded assembly of `AffineTransitionLimit` + DD-Q; the field-index (step δ) is a small
`IntermediateField` assembly.

### §0.3 Honest scoreboard (this node)

| brick | what | size | avatar |
|---|---|---|---|
| **DG-G0.δ** | `K_s = colim_{k''} k''` over the directed poset of finite separable `k''/k` | **S** | `IntermediateField` directed iSup (LANDED) |
| **DG-G0.α** | the finite chart family + glueData is base-changed from a finite stage `k'` | **M** | manifest chart-naturality (mostly landed) + `AffineTransitionLimit` spreading (LANDED) |
| **DG-G0.β** | **descend the representing iso** `rep_{K_s}` to a finite stage | **L** | **none direct**; decomposes onto ring/scheme colimit lemmas + a pic0-colimit brick |
| **DG-G0.γ** | carry lft `K_s → k'` | **S** | DD-Q lft + lft base-change-stable (LANDED) |
| **DG-G0.ε** | choose / enlarge the finite stage `k'` to carry α, β, δ jointly | **S** | finite meet in the directed system (LANDED) |

Net: **one L brick (β) + one M (α) + three S (δ, γ, ε).**  The "XL, no avatar" balloon is
the β sub-brick β1 (pic0 commutes with the base-field colimit), sized **M–L**, probe-gated.

### §0.4 Provable-in-tree vs needs-fallback vs needs-probe — the precise call

* **Steps δ, α, γ, ε: provable-in-tree.**  Strong avatars; bounded assembly.
* **Step β: provable-in-tree *contingent on one probe* (§4.3).**  The probe pivot is
  whether `pic0SigmaSheaf` (equivalently `pic0Functor`) **commutes with the filtered
  colimit `K_s = colim k''` of the base field**.  If YES (the expected answer — Picard
  functors of finite-presentation curves commute with filtered base-colimits, EGA IV.8.5
  shape), β closes with the LANDED ring/scheme colimit lemmas and needs **no** fpqc
  descent of pic0.  If NO / un-formalizable in reasonable cost, β falls back (§4.2).
* **The orchestrator-owned fallback (limit-existence along `k'→K_s`, RE-5 style,
  worksheet §5.1) is AVAILABLE but is NOT the primary route** and should not be taken
  pre-emptively — it is an interface change (a `Nonempty` weakening) and is strictly
  weaker than the pinned route.  **Take it only if the §4.3 probe returns NO.**

**Bottom line for ETA:** DAT-G0 is **L, route-pinned, one probe outstanding** — not the
XL, avatar-less endgame risk it was ranked.  The remaining honest uncertainty is localized
to a single, cheaply-probeable mathematical question (§4.3).

---

## §1 THE STATEMENT SHAPES (verbatim Lean-shaped, against the frozen `PicRepDatum k'`)

The frozen handoff (DG-0, landed this pass, `AlgebraicJacobian/Picard/PicRepDatum.lean`):

```lean
structure PicRepDatum (k k' : Type u) [Field k] [Field k'] [Algebra k k']
    (C' : Over (Spec (.of k'))) [IsProper C'.hom]
    [SmoothOfRelativeDimension 1 C'.hom] [GeometricallyIrreducible C'.hom] :
    Type (u + 1) where
  J   : Over (Spec (.of k'))
  rep : (pic0TypeFunctor C').RepresentableBy J
  lft : LocallyOfFiniteType J.hom
```

with accessors `homEquiv : (T ⟶ d.J) ≃ pic0Subgroup C' T`, `homEquiv_comp` (naturality
against `pic0Map`), `uniqueUpToIso`, and the machine-checked defeq note that
`(pic0TypeFunctor C').RepresentableBy J` **is** the `JacobianData.rep` field type (so
`k'=k` transports with no massage).

**Binder deviation from worksheet §3.3 (RECORDED, forced by elaboration).**  `k` is made
**explicit** (`PicRepDatum k k' C'`), not the ambient `variable {k}` the worksheet froze:
unlike `JacobianData C` where `C : Over (Spec (.of k))` pins `k`, here the explicit data
pin only `k'`, and `k` occurs solely inside `[Algebra k k']`, so `PicRepDatum k' C'` leaves
`k` an undetermined metavariable (`Algebra ?m k'` typeclass stuck) for every consumer.
Making `k` explicit is the minimal change; all fields / instances / math are unchanged.
**DAT-G co-signs against `PicRepDatum k k' C'`.**

### §1.1 The DAT-G0 top-line producer (the co-sign target — frozen)

```lean
-- Standing pack (worksheet §0.8): the w4-datc/w4-datb §0.5/§0.6 instantiation at a
-- separable closure K_s of k, and C_{K_s} := (baseChange k K_s).obj C.
-- Inputs (all divRep-gated via DG-1/DG-2, taken as HYPOTHESES here — I-0243 pattern):
--   dKs   : the K_s-level datum  (DG-1: pic0RepKs + glued lft)
--           i.e. J_{K_s} with rep_{K_s} : (pic0TypeFunctor C_{K_s}).RepresentableBy J_{K_s}
--                and  lft_{K_s} : LocallyOfFiniteType J_{K_s}.hom
--   hqc   : QuasiCompact J_{K_s}.hom  (DG-2: the a-posteriori image-of-DivScheme qc)
noncomputable def datG0Transfer
    (dKs : PicRepDatumKs C K_s) (hqc : QuasiCompact dKs.J.hom) :
    Σ (k' : Type u) (_ : Field k') (_ : Algebra k k') (_ : Algebra.IsSeparable k k')
      (_ : Module.Finite k k') (i : k' →+* K_s),   -- the chosen finite stage
      PicRepDatum k' ((baseChange k k').obj C)
```

*(The Σ-packaging names the produced finite `k'`, its finite-separable-over-`k` witnesses,
and the coherent embedding `k' →+* K_s`; DG-4 unpacks it to `picRepDatumKprime`.  `k'` is
an OUTPUT, chosen large enough — §3.ε — not an input.)*  **Honest producer, no
`Nonempty`-smuggling** (worksheet §4): if β forces the fallback, THIS signature weakens to
`Nonempty (Σ …)` and that weakening is the interface change §4.2 records.

### §1.2 The three transfer faces β needs (frozen shapes, Lean-shaped)

**(β·a) pic0 commutes with the base-field colimit** — the probe pivot (§4.3):

```lean
-- the base-change tower functor along k'' →+* K_s, and the induced restriction of pic0.
-- SHAPE: the colimit of the pic0-values over the directed system {k''} computes the
-- pic0-value at K_s, on every test object that itself descends to a finite stage.
-- Candidate Lean form (test-object–wise), for T over Spec K_s descended from T'' over k'':
theorem pic0Subgroup_isColimit_baseField
    (T'' : Over (Spec (.of k'')))  (…tower data…) :
    Function.Bijective (colimitComparison_pic0 C T'')   -- colim_{k'''≥k''} pic0(C_{k'''}) T''' ≃ pic0(C_{K_s}) T''_{K_s}
```

*(This is the ONE new mathematical statement.  Its avatar-shadow is
`CommRingCat.preservesColimit_coyoneda_of_finitePresentation`
(`Ring/FinitePresentation.lean:144`) lifted through the pic0 sheaf; the categorical
`corepresentableByCompCoyonedaObjOfIsColimit` (`PartialAdjoint.lean:154`) is the pattern.)*

**(β·b) descend one iso to a finite stage** — bounded once (β·a) lands, using the LANDED
colimit lemmas:

```lean
-- Given rep_{K_s} and the colimit-compatibility (β·a), the natural iso
--   yoneda(J_{k'}) ≅ pic0SigmaSheaf(C_{k'})  (after ⊗_{k'} K_s it is rep_{K_s})
-- exists already at a FINITE stage k', by:
--   RingHom.EssFiniteType.exists_comp_map_eq_of_isColimit   (Ring/FinitePresentation.lean:45)
--   RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit (Ring/FinitePresentation.lean:81)
--   Scheme.exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType (AffineTransitionLimit.lean:686, 01ZC)
-- packaged as a RepresentableBy at k':
theorem representableBy_of_colimit_stage … :
    (pic0TypeFunctor ((baseChange k k').obj C)).RepresentableBy J'
```

**(β·c) the represented object descends** — `J_{K_s} = (J')_{k'} ×_{k'} K_s` — via α
(the glued object is the k'-glue of the base-changed finite diagram) or, as a fallback
inside β, via `Scheme.exists_isAffine_of_isLimit` / `exists_π_app_comp_eq_of_lfp`
(`AffineTransitionLimit.lean:1036,1177`).

---

## §2 THE LANDED MATHLIB SUBSTRATE (the hard-search results, verbatim)

### §2.1 Scheme-level EGA IV.8 — `AlgebraicGeometry/AffineTransitionLimit.lean`

Inverse limits of schemes with affine transition maps, "following EGA IV 8 and
stacks 01YT" (file docstring).  The DAT-G0-relevant keystones (all verified by read):

* `Scheme.nonempty_of_isLimit` (`:46`, 01Z2), `Scheme.compactSpace_of_isLimit` (`:366`),
  `isAffineHom_π_app` (`:359`).
* `exists_map_eq_top` (`:180`) — an open that becomes ⊤ in the limit is ⊤ at a finite
  stage (**cover spreading**); `exists_map_preimage_eq_map_preimage` (`:291`, 01Z4(2));
  `exists_preimage_eq` (`:338`, 01Z4(1)); `isBasis_preimage_isAffineOpen` (`:309`).
* **`Scheme.exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType`** (`:686`, 01ZC "inj part
  (1)⇒(3)"): `colim_i Hom_S(D_i, X) ⟶ Hom_S(lim D_i, X)` is **injective** for `X` lft
  over `S` — the UNIQUENESS half of spreading a morphism.  (Companion
  `exists_hom_comp_eq_comp_of_locallyOfFiniteType` `:631`.)
* **`Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`** (`:1177`): a morphism
  `lim D_i ⟶ X` **factors through a finite stage** `D_i ⟶ X` for `X` lfp over `S` — the
  EXISTENCE half.  Together with `:686`: `colim Hom = Hom(lim)` for lfp targets.
* `Scheme.exists_isAffine_of_isLimit` (`:1036`, 01Z6), `exists_isQuasiAffine_of_isLimit`
  (`:982`, 01Z5), `exists_isOpenCover_and_isAffine` (`:1078`),
  `exists_isAffineOpen_preimage_eq` (`:1058`) — **descent of affineness / covers**.

Hypotheses to feed: `[IsCofiltered I]`, `[∀ {i j} (f:i⟶j), IsAffineHom (D.map f)]`,
`[∀ i, CompactSpace (D.obj i)]`, `[QuasiSeparatedSpace]`.  For `K_s = colim k''`: the base
diagram `D i = Spec k''` has affine (indeed `Spec`-of-field) transition maps and compact
(one-point) objects — all hypotheses discharge trivially.  The `divScheme`-charts are qcqs
(DD-Q: `compactSpace_divScheme` `DivSchemeQProj.lean:194`, `isSeparated_…OverHom` `:206`).

### §2.2 Ring-level EGA IV.8 — `Algebra/Category/Ring/FinitePresentation.lean`

The `RingHom.FinitePresentation` + filtered-colimit engine (imports
`Algebra.Category.Ring.FilteredColimits`):

* `RingHom.EssFiniteType.exists_comp_map_eq_of_isColimit` (`:45`): two `R`-homs from an
  ess-finite-type `S` that agree at `S ⟶ colim F` **agree at a finite stage** — i.e.
  `colim_i Hom_R(S, F_i) ⟶ Hom_R(S, colim F)` **injective**.
* `RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit` (`:81`, needs
  `f.hom.FinitePresentation`): an `R`-hom `S ⟶ colim F` from a **finitely presented** `S`
  **factors through a stage** — SURJECTIVE.
* `CommRingCat.preservesColimit_coyoneda_of_finitePresentation` (`:144`) /
  `preservesFilteredColimits_coyoneda` (`:169`) / `isFinitelyPresentable_under` (`:178`):
  `Hom_R(S,−)` preserves filtered colimits for f.p. `S`.

**This is the analytic heart of β·b** — the descent of a morphism / iso to a finite
colimit stage is exactly `exists_comp_map_eq` (uniqueness) + `exists_eq_comp_ι_app`
(existence), applied to the affine pieces of the charts (which are `Spec` of f.p.
`k'`-algebras: DD-Q charts are `Spec (R^I ⊗ R^J)`-cutouts, `DivSchemeQProj.lean:71`).

### §2.3 fpqc topology (the fallback substrate) — `AlgebraicGeometry/Sites/Fpqc.lean`

`Scheme.fppfPrecoverage` (`@Flat ⊓ @LocallyOfFinitePresentation`), `fpqcPrecoverage`
(qc flat surjective), **fpqc is subcanonical by `inferInstance`** (representables are
fpqc-sheaves).  Flat descent of morphism properties: `Morphisms/FlatDescent.lean`,
`LocalFlatDescent.lean`, `Morphisms/Descent.lean`.  `Spec K_s ⟶ Spec k'` is affine +
faithfully flat, hence a single-cover fpqc morphism — this is the substrate for the β
FALLBACK (§4.2), **not** the primary route (the primary avoids needing pic0 an fpqc sheaf).

### §2.4 Separable closure as filtered colimit — `FieldTheory/…`

* `IntermediateField.coe_iSup_of_directed` / `toSubalgebra_iSup_of_directed`
  (`IntermediateField/Adjoin/Basic.lean:114,124`): a **directed** iSup of intermediate
  fields is their union — the "colimit = union" substrate.
* `IntermediateField` finite (finrank) subextensions are directed and their iSup is the
  whole algebraic extension (`:201`, compact-element characterization); `isSeparable_iSup`
  (`SeparableClosure.lean:256`).  For `K_s` sep-closed over `k`: `K_s` is separable
  algebraic over `k` (`IsSepClosed`, `separableClosure`), hence `= colim` of its finite
  separable subextensions `k''/k`.  **This is DG-G0.δ, size S.**

### §2.5 Landed AJCR substrate (the pic0 side of β·a)

* `pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean:161`) — the raw 01JJ output shape;
  its base-field naturality is what β·a must lift.
* pic0 base-change / restriction along morphisms: `pic0Pullback`, `pic0PullbackNat`
  (`Pic0Pullback.lean:164,210`), the pic0 Zariski-gluing / restriction API
  (`PicEtMap.lean`, `Pic0ZariskiSheaf.lean:246`), and the base-CHANGE data
  `JacobianDataBaseChange.lean` / `JacobianDataBaseChangeAbel.lean`.  β·a must upgrade
  these *restriction maps* into a *colimit-preservation* statement (the new content).
* DD-Q lft: `locallyOfFiniteType_divSchemeOverHom` (`DivSchemeQProj.lean:199`) — the γ seed.

---

## §3 THE GAPS AS BRICKS (each sized, with route + fallback; w4-ddr9 §0.2 pattern)

### DG-G0.δ — the index `K_s = colim k''` (S, launchable NOW)

**Route.**  Build the directed diagram `D : {k'' : finite separable /k} ⥤ CommRingCat`
(equivalently the `IntermediateField` directed system), show `colim D ≅ K_s` via
`coe_iSup_of_directed` + `isSeparable_iSup` + `IsSepClosed`/`separableClosure`.  No new
mathematics.  **Fallback: none needed.**  Gotcha: the tower instances MUST be native
`k`-algebra instances (I-0255 diamond wall) — the `IntermediateField` API supplies native
`Algebra k k''` / `IsScalarTower k k'' K_s`, so DO NOT rebuild them as composite
`RingHom.toAlgebra` `letI`s.

### DG-G0.α — the finite chart family + glue is base-changed from `k'` (M)

**Route (primary, "manifest naturality").**  The chart apparatus — `DivScheme`, `VOver`,
the h¹-vanishing opens, `abelDiv`, `sigmaFamily`, `chartValue`, and the chart map `f_c` —
is CONSTRUCTED over an arbitrary base field and commutes with base change (landed
naturality: `abelDiv_overSpec`, `picEtMap_chartValue`, `sigmaFamily_natural`,
I-0249/w4-datc §4).  The finite `Σ_{c_i}` are `k'`-rational by the §3.2 choice.  Hence
each `X_{c_i}/K_s = (X_{c_i}/k') ×_{k'} K_s` and the finite `glueData` (the 01JJ transition
pullbacks) is the base change of the `k'`-diagram.  **Deliverable: a naturality lemma that
the finite subfamily `{f_{c_i}}` is `(f_{c_i}^{k'})` base-changed.**
**Fallback (abstract spreading).**  If manifest naturality is too heavy to thread, spread
the finite diagram to a stage with `Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`
(`AffineTransitionLimit.lean:1177`) + `exists_isOpenCover_and_isAffine` (`:1078`): the
charts are lfp (opens of the lfp `divScheme`), qcqs, so they descend.  Interface-neutral.

### DG-G0.β — descend the representing iso `K_s → k'` (L; THE mountain; probe-gated)

**Sub-brick β1 = β·a (M–L, the ONLY avatar-less mathematics):** `pic0` commutes with the
base-field colimit `K_s = colim k''` (§1.2 β·a).  **Route:** lift
`CommRingCat.preservesColimit_coyoneda_of_finitePresentation`
(`Ring/FinitePresentation.lean:144`) through the pic0 sheaf: pic0 is built from
finite-presentation affine data (relative Picard of the f.p. curve), so its value at
`colim k''` is the colimit of its values — using the LANDED restriction maps
(`PicEtMap`, `Pic0ZariskiSheaf.lean:246`) as the colimit cocone and
`corepresentableByCompCoyonedaObjOfIsColimit` (`PartialAdjoint.lean:154`) as the
categorical pattern.  **Risk:** this is the genuine new statement; if pic0's
sheafification does not commute with the base-colimit cheaply, β1 walls.
**Sub-brick β2 = β·b (M, bounded once β1):** transport `rep_{K_s}` to a finite stage with
`exists_comp_map_eq_of_isColimit` (`:45`) + `exists_eq_comp_ι_app_of_isColimit` (`:81`) +
`exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType` (`AffineTransitionLimit.lean:686`),
packaged as `(pic0TypeFunctor C_{k'}).RepresentableBy J'`.
**Fallback (β, if β1 walls) — two tiers, escalating interface cost:**
1. **fpqc-descent of the iso** (§2.3): make `Spec K_s ⟶ Spec k'` an fpqc cover and descend
   `yoneda(J') ≅ pic0(C_{k'})`.  **Cost:** needs `pic0SigmaSheaf` an **fpqc** sheaf (only
   ZARISKI is landed) — a heavy new brick (étale/fpqc descent of pic0).  Interface-neutral
   for `PicRepDatum` but a big detour.
2. **limit-existence `Nonempty` (worksheet §5.1, RE-5 style, ORCHESTRATOR-OWNED):** state
   `Nonempty (PicRepDatum k')` via a limit argument along `k'→K_s` rather than an explicit
   descent.  **Cost:** weakens §1.1's honest producer to `Nonempty` — an interface change
   at the DAT-glue/DAT-G boundary; **record BEFORE taking it.**

### DG-G0.γ — carry lft `K_s → k'` (S)

**Route.**  §2.3-worksheet's per-chart lft at `K_s` (locality-on-source over the finite
open cover `{X_{c_i}}`) descends: each `X_{c_i}/k'` is lfp (open of `divScheme/k'`, DD-Q
`:199`), lft is stable under base change and Zariski-local on the source, so `J'.hom` is
lft.  Landed avatars only.  **Fallback: none needed** (γ is downstream of α — the base
change is already in hand).

### DG-G0.ε — choose / enlarge the finite stage `k'` (S)

**Route.**  `k'` must simultaneously (i) make every `Σ_{c_i}` rational (§3.2), (ii) carry
the base-changed chart diagram (α), (iii) carry the descended iso stage (β2).  Each is a
finite condition producing a finite subextension; their finite **meet (join in the
directed poset)** is the chosen `k'` (`IsFiltered`/directed `sup_objs_exists`, used already
inside the mathlib colimit lemmas).  **Fallback: none needed.**

---

## §4 ROUTE, FALLBACK, AND THE PINNED PROBE

### §4.1 Primary route (the honest new work)

`δ → α → β1 → β2 → γ → ε`, packaged as §1.1's `datG0Transfer` producing `PicRepDatum k'`.
The only avatar-less mathematics is **β1** (pic0's base-colimit compatibility); everything
else is bounded assembly of `AffineTransitionLimit` + `Ring/FinitePresentation` + DD-Q +
`IntermediateField`.

### §4.2 Fallback ladder (record before descending it)

1. β via **fpqc descent** (needs pic0 fpqc-sheaf — new heavy brick, interface-neutral).
2. β via **limit-existence `Nonempty`** (worksheet §5.1; weakens the producer;
   **ORCHESTRATOR-OWNED interface change** — the DAT-glue/DAT-G boundary moves from a plain
   `PicRepDatum k'` producer to `Nonempty (PicRepDatum k')`; DAT-G's Speiser descent must
   then run under a `Nonempty` — flag to DAT-G's worksheet).

### §4.3 THE PINNED PROBE (the single question that resolves the verdict)

> **Does `pic0SigmaSheaf (C_{k''})` (equivalently `pic0Subgroup (C_{k''}) T''`) commute
> with the filtered colimit `K_s = colim_{k''} k''` of the base field — i.e. is the
> comparison `colim_{k''} pic0(C_{k''})(T'') → pic0(C_{K_s})(T''_{K_s})` a bijection for
> every finite-stage test `T''`?**

* **Probe method (cheap, ~1 focused session, pre-`divRep`):** it touches only landed pic0
  API + mathlib colimit lemmas — no coverage, no `f_c`.  (a) Read whether pic0's value is
  computed from finite-presentation affine data whose `Hom` commutes with base colimits
  (`preservesColimit_coyoneda_of_finitePresentation`, `Ring/FinitePresentation.lean:144`);
  (b) check the pic0 restriction maps (`PicEtMap`, `Pic0ZariskiSheaf.lean:246`) assemble
  into the colimit cocone; (c) `lean_multi_attempt` the comparison bijection on an affine
  test.  **Expected: YES** (finite-presentation Picard functors commute with filtered
  base-colimits, EGA IV.8.5), giving the §4.1 primary route.
* **If YES:** verdict hardens to **provable-in-tree, L, primary route §4.1.**
* **If NO / un-formalizable cheaply:** verdict becomes **needs-fallback**, take §4.2 tier 1
  (fpqc) if pic0's étale/fpqc descent is within reach, else §4.2 tier 2 (Nonempty,
  orchestrator-owned).

### §4.4 Launch order

`DG-0` (frozen shape, LANDED this pass) → **the §4.3 probe (NOW, pre-`divRep`)** →
`δ, ε` (NOW, index assembly) ∥ `[divRep F5–F7] → [C9 + B-6] → DG-1 (rep_{K_s}) → DG-2
(J_{K_s}-qc + k' choice)` → `α, β2, γ` → `DG-4 packaging`.  β1 is launchable the moment the
probe returns YES — it is `divRep`-free (touches only pic0 + colimit API).

---

## §5 RISKS (DAT-G0-local; ranked)

1. **β1 (pic0 base-colimit compatibility) is the sole avatar-less brick.**  Mitigation:
   the §4.3 probe front-loads its single pivot; the ring-level avatar
   (`preservesColimit_coyoneda_of_finitePresentation`) makes YES the strong prior; two
   fallback tiers exist.
2. **Tower-diamond wall (I-0255), binding at every `K_s`/`k''` instantiation.**  Every
   pic0 / base-change over a `K_s` or `k''` tower MUST use NATIVE `k`-algebra instances
   (the `IntermediateField` directed system supplies `Algebra k k''`,
   `IsScalarTower k k'' K_s` natively) — **never** a composite `RingHom.toAlgebra` `letI`
   (whnf non-termination even at 1e6 heartbeats; still bites base-changed étale carriers).
   The δ diagram must be built from `IntermediateField`, not hand-rolled towers.
3. **Universe whnf (I-0249) at the `K_s`/`k''` instantiations.**  Keep every stage a clean
   `Type u` instance hypothesis; avoid `gluedIncl*`-style lemmas that pin `J : Type u`
   against a `Type 0` index.
4. **`divRep` gate (external).**  DG-1/DG-2 (hence `rep_{K_s}`, `J_{K_s}`-qc) wait on
   C9 + B-6 (F5–F7).  Insulation: DG-0, δ, ε, **and the §4.3 probe** are `divRep`-free.
5. **α manifest-naturality vs abstract-spreading choice (medium).**  If the chart
   construction's base-field naturality is only partially landed, fall to the
   `AffineTransitionLimit` spreading (α fallback) — interface-neutral, one-file swap.

### §5.1 Deliberately NOT decided here (owned elsewhere)

* β's exact vehicle (filtered-colimit descent vs fpqc descent) — **the §4.3 probe decides.**
* Whether pic0 is upgraded to an fpqc sheaf (β fallback tier 1) — a separate heavy brick,
  negotiated only if the probe returns NO.
* DAT-G's Speiser consumption of `PicRepDatum k'` (or `Nonempty` thereof if §4.2 tier 2
  fires) — DAT-G's unwritten worksheet; it inherits the frozen §1 shape.
* Properness / universal-closedness of `J` — Wave 5 (DD-Q boundary, worksheet §2.2).

---

*End of mini-spec.  Deliverable of record for DAT-G0 (`AJCR.w4-rep.datum.dat-glue`,
DG-3 scope).  Orchestrator echo: (1) DAT-G0 is **L, route-pinned, NOT XL-no-avatar** —
mathlib holds the hearts (EGA IV.8 ring+scheme spreading `AffineTransitionLimit.lean` +
`Ring/FinitePresentation.lean`, fpqc subcanonical, sep-closure colimit); (2) the sole
avatar-less brick is β1 (pic0 commutes with the base-field colimit), and its verdict is
settled by the ONE pre-`divRep`, `divRep`-free probe of §4.3 — expected YES; (3) the
limit-existence `Nonempty` fallback (worksheet §5.1) is AVAILABLE but is an
orchestrator-owned interface change and is NOT the primary route — take only if the probe
returns NO; (4) DG-0 (`PicRepDatum k'`) is LANDED this pass and the shape is frozen — DAT-G
co-signs against §1 today.*
