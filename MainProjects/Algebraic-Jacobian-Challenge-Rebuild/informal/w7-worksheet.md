# Wave-7 worksheet — functoriality + base change of fields (`AJCR.w7-functor`)

**DRAFT — pending orchestrator ratification.** Nothing below is binding: every D-item is a
*recommendation + evidence* (precedent: `w5-t4-worksheet.md`, ratified by addendum). The
orchestrator ratifies §6's points; deviations after ratification go back through the
orchestrator.

*Design pass, 2026-07-17, lane w7-design. Evidence base: `informal/w7-recon.md` (read in
full; landed at `7d450f7e2`; its §2 API map and §5 EW-list are the agenda), the frozen
targets re-read verbatim this session (`AlgebraicJacobian/Challenge.lean:153-158`
(`functor`), `:244-248` (`baseChangeIso`), `:253-272` (coherences), `:278-283`
(`baseChange_ofCurve`), plus the genuinely-proved `baseChange`/`idIso`/`compIso`
scaffolding `:170-226` and `congr :233-240`), the landed interfaces re-read in full
(`Picard/JacobianData.lean`, `Curve/BaseFieldTransition.lean`,
`RiemannRoch/DegreeBaseFieldInvariance.lean` docstring + keystone `:462`,
`Cohomology/H1BaseFieldInvariance.lean` docstring), the house formats
(`w5-worksheet.md`, `w4-datum-worksheet.md` §1.4), and the pinned mathlib checkout
(`Monoidal/Grp.lean`, `Monoidal/Cartesian/Grp.lean` re-read at source this session).
**Four new machine-checked probes** were run this session via `lean_run_code` against the
live tree (§5); no file outside `informal/` touched, no build run, no mutex taken.*

---

## §0 Verdict in one line

Rule the datum idiom as **per-curve explicit `(d : JacobianData C)`-style arguments —
one datum per curve named in the statement, no section-variable family** (the family
form is probe-green and stays the recorded fallback); cut the `baseChangeIso` remainder
into **eight S/M bricks** (B-1..B-6b below, θ CommGrpCat-valued, `classDeg_map_iso`
built now and not via E-v) riding the three machine-checked seams; launch **E-v
(worksheet-first) and the F/B plumbing TODAY** because they are ungated while every
frozen discharge waits on Fleet A's DAT-J anyway; and pin EW-6 as a
**`GrpObj`-structure equality closed by `GrpObj.ext`** (inv-leg free — a mathlib gift
the recon's §2.8 #4 missed), machine-checked to elaborate this session.

---

## §1 D-candidates (recommendation + evidence; orchestrator ratifies)

### D1 (EW-4) — the datum-FAMILY consumption idiom: RECOMMEND per-curve explicit arguments

**Recommendation.** Wave-7 statements take **one explicit datum argument per curve they
name**, in the landed w5-D2 idiom, with the naming convention `d` (the k-curve `C`),
`dL`/`dM` (base-changed curves over `L`/`M`), `dX`/`dY`/`dZ` (curves in the `functor`
cluster). No section-variable family, no bundled family structure. Group structures are
activated per proof by `letI := d.grpObj` (JacobianData.lean:24-28 house rule). Rule of
hygiene: **a statement may not demand data at a curve it does not name** (prevents
hidden coupling). Functor-law statements that DAT-J will instantiate with the producer
at the *same* curve repeat the datum argument (e.g. `map_id` is stated with `dX` at both
ends), so discharge is pure instantiation.

**Evidence.**
1. *Alignment*: `Picard/JacobianData.lean:22-28` (read this session) already binds the
   consumption idiom "downstream files take `(d : JacobianData C)` as a section
   variable"; w5-worksheet D2 is the ratified precedent. Option (b) is its transitive
   extension; options (a)/(c) would fork the idiom mid-campaign.
2. *Sufficiency*: every Wave-7 datum-level statement (§1.2/§2 brick shapes) names at
   most three curves (`baseChangeIso_comp`: `C/k`, `C_L/L`, `C_M/M`; `map_comp`:
   `X, Y, Z`), so explicit arguments stay readable. Arbitrary-pair statements are
   *strictly stronger* than the producer-instantiated ones and remain provable because
   the landed `uniqueUpToIso`/`homEquiv_uniqueUpToIso_hom` (JacobianData.lean:134,139)
   canonicalizes any two data — the "unique iso intertwining pinned universal elements"
   mechanism is exactly arbitrary-pair-shaped.
3. *Feasibility of the alternative recorded* (so the fallback is known-green): probes
   A1–A4 (§5) machine-checked BOTH idioms this session — the field-uniform family
   `(dfam : ∀ (k' : Type u) [Field k'] (X : Curve k'), JacobianData X.carrier)`
   elaborates, and its instantiation at the base-changed curve
   `dfam L ⟨(baseChange k L).obj C⟩` typechecks against
   `JacobianData ((baseChange k L).obj C)` with zero massage (the anonymous `Curve`
   constructor picks up the frozen file's own stability instances `:174-187`). So (b)
   over (a) is a *style ruling with a verified escape hatch*, not a feasibility bet.
4. *Why not (a) anyway*: a family section variable makes every lemma quantify over a
   `Type (u+1)` object it mostly ignores (fatter blueprint/hgraph nodes), invites
   accidental use of data at unrelated curves, and buys nothing before DAT-J — at
   DAT-J the producer `jacobianData` IS the family, and (b)-shaped theorems discharge
   by `exact thm (jacobianData C) (jacobianData C_L)`.

**Watch item (the EW-4 second half — needs an orchestrator action, not a Lean brick).**
The DAT-J producer must stay base-field-generic: `baseChangeIso`'s discharge
instantiates `jacobianData` at an arbitrary `[Field L] [Algebra k L]` with NO
finiteness/separability/perfectness. Fleet A's DAT-G (Galois descent) is the one place
a `k`-specific shortcut could creep in. **Ask Fleet A to confirm** (inbox) that the
producer's final signature is `∀ {k : Type u} [Field k] (C : …) [pack], JacobianData C`
with no extra hypotheses; if DAT-G ever needs one, Wave 7 must know the day it happens,
not at discharge time.

### D2 — the `baseChangeIso` brick cuts (what remains after the three green seams)

Context (recon §0/§2.0, trusted + re-used): the frozen spelling seam is `rfl` (probe 1),
the adjunction transport is verbatim mathlib (probe 2), `genus_baseField` consumes at
the frozen spelling (probe 3). What remains is θ, `classDeg_map_iso`, and the
group-coherence glue. Three sub-rulings, then the cuts.

- **D2-i (θ's value category): RECOMMEND CommGrpCat-valued.** State
  `θ : pic0Functor ((baseChange k L).obj C) ≅ (Over.map σ).op ⋙ pic0Functor C`
  (σ := `Spec.map (CommRingCat.ofHom (algebraMap k L))`) in
  `(Over (Spec (.of L)))ᵒᵖ ⥤ CommGrpCat`, deriving the Type-valued form needed by
  `RepresentableBy.ofIso` by whiskering with `forget₂ ⋙ forget` (the massage is owned
  by the landed `pic0TypeFunctor` abbrev, `Picard/Pic0SigmaSheaf.lean:58` — recon §2.6).
  Evidence: B-2's components are `MulEquiv`s anyway (CechPic transport of an iso), so
  group-valuedness is free at construction time, and B-6a *consumes* it (the
  multiplicativity of θ is exactly what makes the transported `ofRepresentableBy`
  structure comparable with `grpObjObj`). Stating θ Type-valued and re-proving
  multiplicativity later would be strictly more work.
- **D2-ii (F-2/B-2 skeleton sharing): RECOMMEND one parameterized transport core.**
  The recon flagged the candidate (§3.2 B-2). Honest analysis: F-2's input is
  `(g ▷ overSpec k B).left` for a curve morphism `g` over `k`; B-2's input is B-1's
  cross-base comparison family — NOT of whisker form, so B-2 is *not* an instantiation
  of a curve-morphism-indexed F-2. The correct shared generality is one level lower:
  parameterize the `relPic`/`PicEtAff` transport over **a natural family of scheme
  morphisms `h_B : W'_B ⟶ W_B` over the shared étale cover carriers `B`, compatible
  with the second projections** (descent classes ↦ descent classes, `mk`/`ind`/
  `mk_eq_mk_iff` transport, `mapAlg` bilateral naturality — all stated once against
  the family). F-2 instantiates at `fun B => (g ▷ overSpec k B).left`; B-2 at B-1's
  iso family (getting `≃*` from two-sided instantiation). Evidence: R2 (plumbing
  volume) is the wave's named bookkeeping risk; the landed `PicEtAffMap` test-variable
  campaign is the size yardstick and we should pay it once, not twice. **Fallback**
  (if the parameterization fights the landed `PicEtAffMap` conventions in the first
  ~100 lines): fork into two concrete campaigns and accept the duplication — a
  prover-level bail decision, to be reported, not suffered.
- **D2-iii (B-3 timing): RECOMMEND build `classDeg_map_iso` NOW, directly — do not
  derive it from E-v at n = 1.** Evidence: B-3 is ungated and small; θ (B-4) needs it
  early; E-v is the wave's slowest mountain and putting the B-cluster's only degree leg
  on its critical path couples the wave's fast lane to its slow one. The direct route
  is the "lighter sibling of E-iv-alg" (deg-d5b §3): the E-iv-alg ladder
  (`DegreeBaseFieldInvariance.lean` §2 steps 1-5, re-read this session) with the
  transition π replaced by an iso — single-point reduction along `picClass` generators,
  tracked point equations, pullback presentation; every leg degenerates (fiber = one
  point, e = f = 1, ord transport along a stalk iso). When E-v later lands, add the
  one-line compatibility remark, nothing more.

**The cuts (all S/M; exact shapes; gates).** File map in §3.

| Brick | Statement shape (pinned) | Size | Gate |
|---|---|---|---|
| **W7-B1 `cross-base-square`** | (i) `IsPullback`-datum exhibiting `((baseChange k L).obj C ⊗ T).left` as a pullback of `C.left ← Spec k → T.left` (paste `Over.isPullback_left`/`isPullback_whiskerLeft_left`, BaseFieldTransition.lean:76 template, across the two slices); (ii) `crossBaseIso C T : (((baseChange k L).obj C) ⊗ T).left ≅ (C ⊗ (Over.map σ).obj T).left` via `IsPullback.isoIsPullback`; (iii) naturality in `T` (vs `C_L ◁ t` and `C ◁ (Over.map σ).map t`); (iv) the affine matching `(Over.map σ).obj (overSpec L A) ≅ overSpec k A` (restrictScalars seam, one lemma) | S/M | none |
| **W7-B2 `picetaff-shuffle`** | instantiate the D2-ii core at B-1's family: `PicEtAff.baseFieldShuffle : PicEtAff C A ≃* PicEtAff ((baseChange k L).obj C) A` for `A` an `L`-algebra (as `k`-algebra by restriction), natural in `A` vs `mapAlg`, over the literally shared `EtaleCover A` index (recon §2.3: the cover index never mentions the base field) | M | B-1, D2-ii core |
| **W7-B3 `classdeg-map-iso`** | `classDeg K (Scheme.CechPic.map e.hom L) = classDeg K L` for an iso `e : X ≅ Y` of curve bundles over one field `K` (`X Y : Over (Spec (.of K))` + pack; `CechPic.map` contravariant, Pic.lean:198) — deg-d5b §3's named Wave-7 lemma, zero hits today (EW-3 closed by this brick) | S/M | none |
| **W7-B4a `field-point-matching`** | for `T : Over (Spec (.of L))`: k-field-points `overSpec k K ⟶ (Over.map σ).obj T` ↔ (an `[Algebra L K]` + `[IsScalarTower k L K]` structure + `overSpec L K ⟶ T`), both directions, with `degAt` matching through B-3 + E-iv-alg (`classDeg_cechPicMap_baseFieldTransition :462`) — the R5 trap brick, tower pattern of `Picard/DegreeZero.lean:229-239` mandated | S/M | B-3 |
| **W7-B4b `theta`** | assemble `θ : pic0Functor ((baseChange k L).obj C) ≅ (Over.map σ).op ⋙ pic0Functor C` (D2-i shape): B-2 through the affine-opens limit (`picEtAffineEquiv` is the ONLY licensed seam to the limit carrier — w4 discipline echoed), degree-0 restriction via B-4a; Type form by whiskering = the `pic0TypeFunctor` comparison | M | B-1,B-2,B-3,B-4a |
| **W7-B5 `transported-datum`** | `JacobianData.baseChange (d : JacobianData C) : JacobianData ((baseChange k L).obj C)` with `J := (baseChange k L).obj d.J`; `rep :=` probe-2's `(Over.mapPullbackAdj σ).representableBy d.J` transported by `RepresentableBy.ofIso` along (whisker of `d.rep`'s functor iso) then (θ's Type form); `locallyOfFiniteType`/`quasiCompact` := `MorphismProperty.baseChange_obj σ d.J` — **probe D (§5) machine-checked both certificate legs this session, verbatim** | S | B-4b, D1 |
| **W7-B6a `mapgrp-coherence`** | the EW-6 statement, pinned in D4 below | M | B-5 |
| **W7-B6b `grp-packaging`** | `baseChangeIsoOfData (d : JacobianData C) (dL : JacobianData ((baseChange k L).obj C)) : (baseChange k L).mapGrp.obj (.mk d.J) ≅ .mk dL.J` (under `letI := d.grpObj; letI := dL.grpObj`) := `Grp.mkIso` (Grp.lean:442, forward-direction `one_f`/`mul_f` only) on the object iso `(d.baseChange).uniqueUpToIso dL : (baseChange k L).obj d.J ≅ dL.J`; `one_f`/`mul_f` from B-6a (LHS structure = `ofRepresentableBy` of the transported rep) + `homEquiv_uniqueUpToIso_hom` (:139) + one small general lemma "an object iso intertwining the `homEquiv`s of two group-valued `RepresentableBy` data is `IsMonHom` between the `ofRepresentableBy` structures" (via `yonedaGrpObjIsoOfRepresentableBy`, Cartesian/Grp.lean:100, + `yonedaGrp` faithfulness :115/:126). At DAT-J: `baseChangeIso k L C := baseChangeIsoOfData (jacobianData C) (jacobianData C_L)` — definitional against the frozen `Jacobian`/`instGrpObj` | S/M | B-5, B-6a |

### D3 (EW-5) — dependency-honest sequencing: RECOMMEND this launch order

The structural facts (recon §2.1, re-verified against the frozen source this session):
`congr := (Jacobian.functor k).mapIso` (`Challenge.lean:233-240`), so **the frozen
coherence theorems can only close after `functor`'s three fields are discharged** —
which happens at DAT-J assembly (the fields consume the producer). Meanwhile the
mathematical content of everything is datum-level and mostly ungated. Two nuances the
wave numbering hides:

1. **The K-cluster consumes `functor.map` only at isomorphisms** (`congr` is applied at
   `(baseChange.compIso k L M).app C` and `(idIso k).app C` — isos). So K-1's
   *datum-level* content (θ-cocycle + intertwining-uniqueness) needs only iso-grade
   curve transport (B-2/B-3 grade), NOT the E-v mountain. E-v gates only the FULL
   `functor` (arbitrary morphisms), i.e. the frozen closure — not the coherence
   mathematics.
2. **Both the F-cluster's frozen discharge and the B-cluster's frozen discharge wait on
   DAT-J regardless** — so the wave's *internal* pacing should be set by its own
   ungated long pole, which is E-v.

**Recommended order** (∥ = parallel lanes):

- **NOW, zero gates**: {F-1} ∥ {B-1} ∥ {B-3} ∥ {**E-v worksheet + its three probes**
  (§2.1 — the long pole; staff FIRST despite belonging to `functor`)}. The D2-ii core
  spec can be cut as soon as F-1's statement shapes freeze (same session scale).
- **Next**: {F-2 = D2-ii core + curve-morphism instantiation} ∥ {B-2 = D2-ii core +
  B-1 instantiation} ∥ {B-4a}; then {B-4b (θ)}; then {B-5 → B-6a → B-6b} — this
  completes datum-level `baseChangeIso` with `functor` still open, confirming the
  recon's sequencing surprise.
- **In parallel on the F side**: F-3 after F-2; EV-1..EV-4 proving after the E-v
  worksheet ratifies; F-6 (statement-level, probe-C shape) after F-3 + EV-4 + D1.
- **K-1**: the θ-cocycle brick (datum-level: θ_{k,M} vs θ_{k,L}∘θ_{L,M} across
  `Over.pullbackComp`, and θ_{k,k} vs `Over.pullbackId` — CommGrpCat-natiso equalities,
  no Grp(Over) objects in sight) launches when θ lands; K-1's WORKSHEET (mandated,
  recon §3.3) is written against the pinned probe-C `functor.map` construction; the
  frozen `baseChangeIso_id`/`_comp` closures run LAST, after DAT-J + F-6.
- **A-1** (`baseChange_ofCurve`): datum-level after the B-cluster (its W6-side input
  `abelElement` is landed, `Picard/AbelElement.lean:126,149,160` — recon §1.5); frozen
  closure after DAT-J (the frozen `ofCurve` sorry).

**What waits on other fleets**: ONLY the frozen discharges (DAT-J, Fleet A) and the D1
producer-genericity confirmation. No Wave-7 brick above waits on W5's T/S cluster or on
W6.

### D4 (EW-6) — the mapGrp-vs-ofRepresentableBy coherence: pinned statement + size

**Pinned statement (B-6a)** — with `letI := d.grpObj`, and `rep_L` := the B-5
transported datum's `rep`:

```lean
theorem grpObjObj_baseChange_eq (d : JacobianData C) :
    Functor.grpObjObj (F := baseChange k L) (G := d.J) =
      GrpObj.ofRepresentableBy ((baseChange k L).obj d.J)
        (pic0Functor ((baseChange k L).obj C) ⋙ forget₂ CommGrpCat GrpCat) rep_L
```

an **equality of `GrpObj ((baseChange k L).obj d.J)` structures**. Probe B (§5)
machine-checked this session that exactly this Prop elaborates (with a generic `rep'`
standing in for the not-yet-built `rep_L`) — including the `Functor.Monoidal` instance
discovery on `baseChange k L` and the `letI` keying.

**Why equality-of-structures (and why it is smaller than the recon feared).** Two
mathlib gifts sharpen recon §2.8 #4:

1. **`GrpObj.ext` (Grp.lean:342-343, re-read at source this session):**
   `h₁.toMonObj = h₂.toMonObj → h₁ = h₂` — **the inv-leg is free** (inverses are unique
   in cartesian monoidal categories; mathlib already packaged it). So the obligation is
   exactly two diagrams: the `one`s agree and the `mul`s agree.
2. **The proof-pattern precedent exists in mathlib itself**:
   `GrpObj.ofRepresentableBy_yonedaGrpObjRepresentableBy` (Cartesian/Grp.lean:90,
   re-read at source) proves a same-shape structure equality by `ext; change …` down to
   one μ-level equation.

Proof route (pinned discipline, R3): reduce both `one`/`mul` diagrams through
`yonedaGrp` faithfulness / the `homEquiv` characterization to **element-level equalities
in `pic0Subgroup`** — never diagram-chase in `Grp (Over …)`. The inputs are: θ's
multiplicativity (D2-i), naturality of `Adjunction.homEquiv` for `Over.mapPullbackAdj σ`
(the transport is probe-2's verbatim term), and the computable monoidal components of
`Over.pullback` (`ε_pullback_left`, `μ_pullback` cluster, Cartesian/Over.lean:206,
213-241 — recon §2.7). The `grpObjObj` side unfolds to `F.map ι` with `mapGrp`-style
`ε/μ`-conjugated `one`/`mul` (`comp_mapGrp_one/_mul` shapes, Grp.lean, read this
session), which is what the μ/ε computables are for.

**Size: M** (upper bound; the two gifts above may bring it in at S/M, but R3's
eqToIso/`.hom.hom.hom` friction says budget M). **Gate**: B-5. The consumer is B-6b
only. This closes EW-6: planned, statement machine-checked, on `baseChangeIso`'s
critical path with a named file (§3).

---

## §2 Campaign scoping (worksheet-first mandates — scoping, NOT proofs)

### 2.1 EW-1 — E-v: degree multiplicativity under pullback along a curve morphism

**Mandate: WORKSHEET-FIRST.** A dedicated `informal/w7-ev-worksheet.md` must exist and
be ratified before EV-1b, EV-1d, or EV-2 write Lean. Rationale: three probe-unresolved
legs (recon R1), each with the (C2)/deg-W3 precedent shape ("one breath in the paper").
The worksheet lane can start TODAY; so can its probes.

Setting: `h : D ⟶ E` an arbitrary morphism of curve bundles over a field `K` (both with
the standing pack; `Curve k` morphisms are arbitrary Over-morphisms, Challenge.lean:76-82
— non-dominant included). Target output (consumed by F-6 via F-3):

- **(EV-main)** `h` finite ⇒ `classDeg K (Scheme.CechPic.map h Λ) = n · classDeg K Λ`
  with `n` = the function-field degree `[K(D) : K(E)]`;
- **(EV-const)** `h` constant (factors through a field point) ⇒ `CechPic.map h Λ` is
  pulled from the base, i.e. dies in `relPic`;
- **(EV-cor)** corollary: `pic0`-membership is preserved by pullback — *per field
  point, applying the dichotomy over that point's field directly*; the multiplier `n`
  may vary with the field point and never needs cross-field uniformity (`n·0 = 0`).
  This dodge (apply EV-main/EV-const over each `K'` independently, never transport `n`)
  is a scoping decision: it removes any "degree of `h` is stable under base field
  extension" brick from the campaign. The base-changed `h_{K'}` is a legal input by the
  landed `BaseChangeInstances` stack + `IsFinite`-stability is NOT needed — the
  dichotomy is re-derived over `K'` from scratch.

**Decomposition against the mathlib gifts** (ZMT `IsFinite.of_isProper_of_locallyQuasiFinite`,
`ZariskisMainTheorem.lean:371`; `Ideal.sum_ramification_inertia_eq_finrank`,
`RamificationInertia/Basic.lean:72`; `IsDedekindDomain.flat_iff_torsion_eq_bot`,
`Flat/TorsionFree.lean:138` — all recon §2.7):

| Sub-brick | Content | Size | Status/gate |
|---|---|---|---|
| **EV-1a `h-proper`** | `IsProper h`: `h ≫ E.hom = D.hom` (`Over.w`) + `IsProper.of_comp` (Proper.lean:118) with `IsSeparated E.hom` from `IsProper E.hom` | S | mathlib-only, NOW |
| **EV-1b `fiber-finiteness`** | **proper closed subsets of an integral curve bundle over a field are finite**: a closed set avoiding the generic point meets each affine Dedekind chart (`isDedekindDomain_section`, ChartColength.lean:126) in `V(I)`, `I ≠ 0` — finitely many primes over a nonzero ideal of a Dedekind domain; finitely many charts by qc. NEW brick, no mathlib statement (recon §2.8 #6); adjacents: ChartColength vanishing, `StalksDVR`, `ClosedPoint` | M | worksheet; probe the Dedekind finite-primes API first |
| **EV-1c `dichotomy-close`** | image closed (EV-1a) + irreducible source ⇒ image = one closed point or all of `E`; dominant leg: fibers = proper closed subsets (EV-1b) ⇒ finite ⇒ `locallyQuasiFinite_iff_finite_preimage_singleton` + **ZMT** ⇒ `IsFinite h` | S/M | EV-1a, EV-1b |
| **EV-1d `constant-leg`** | image = closed pt `x` ⇒ `h` factors through `Spec κ(x)` (reduced-source factorization — **mathlib support UNVERIFIED**, probe `Scheme.fromSpecResidueField` adjacents FIRST), then the pulled class is pulled from the test side and dies in `relPic` (F-1's `picFromBase` compat: the `κ(x)`-point pullback factors through `toUnit D ▷ T`). **Fallback if the factorization is absent**: class-level dodge — the pulled cocycle datum trivializes on the pullback of any trivializing cover of a neighborhood of `x`; stays in the plus-construction calculus, no scheme factorization | M | worksheet; probe first |
| **EV-2 `generic-rank`** ⚠ | for finite dominant `h` and a Dedekind chart pair `B_E → B_D`: the map is **finite** (`Scheme.Hom.finite_appTop`, Finite.lean:157, on preimage charts — `IsFinite ⇒ IsAffineHom` keeps charts affine), **injective** (dominant + integral: `functionFieldMap_injective` vocabulary, BaseFieldTransition.lean:233), **flat** (torsion-free over Dedekind, :138), hence f.g. projective of **constant rank** (Spec of a domain is connected) `= [K(D) : K(E)] = n` by localization at the generic prime + the fraction-field/functionField dictionary (landed `functionFieldMap` + chart germ seams). **The single hardest leg of the campaign**: the finrank ↔ localization ↔ function-field-degree dictionary crosses three theories; every ingredient exists, no composite does | M | worksheet |
| **EV-3 `fiber-Σef`** | per closed point `y` of a chart of `E`: `Σ_{x over y} e·f = n` via `sum_ramification_inertia_eq_finrank :72` (Fintype `primesOver` from EV-1b; `Module.Finite`/`Flat` from EV-2), spliced into the colength dictionary by `toAdd_ordZ_eq_count_factors` (ChartColength.lean:278) — the E-v mirror of SB-4's fiber-degree identity (†) | M | EV-1c, EV-2 |
| **EV-4 `assembly`** | the E-iv-alg ladder verbatim (**model file: `DegreeBaseFieldInvariance.lean`**, keystone shape re-read this session at :462-486): reduce along surjective `CurveDivisor.picClass` (`exists_picClass_eq`) by `Finsupp.induction`, tracked point equations, `picClass_pullback`, close with EV-3 ⇒ EV-main; EV-const from EV-1d; EV-cor by the per-field-point dodge + F-3 naturality | M | EV-3 + F-3 |

**Can start TODAY**: the EV worksheet; probes for EV-1b (Dedekind primes-over-nonzero
finiteness API), EV-1d (`fromSpecResidueField`/scheme-image factorization), EV-2
(finrank-localization + `Module.rankAtStalk` adjacents); EV-1a. **Must wait**: EV-4's
EV-cor leg needs F-3's naturality shapes (same wave, no foreign fleet). Nothing in E-v
touches `JacobianData`, any datum, or any other fleet's lane. Source debt: the classical
statement is Hartshorne II.6/IV (in-workspace, UNREAD — recon §6); queue a
page-transcriber task before the blueprint node cites it.

### 2.2 EW-2 — the curve-variable picEt transport (F-1..F-3): the maps that must exist

**The campaign** (greenfield: recon §2.8 #1 — zero curve-crossing maps above
`Scheme.CechPic.map` today). Discipline clauses every brick must respect (inherited from
the w4 route discipline, re-stated here because this campaign is the first to cross
curves): (i) **restriction maps stay (C1)-licensed** — all test-side naturality is
stated against the landed `picEtMap`/`pic0Map` API (PicEtMap.lean's licensed maps),
never re-derived; (ii) **never unfold the `picEt` limit carrier** — `picEtAffineEquiv`
is the only seam (w4-datum discipline (1), echoed); (iii) **never unfold the `PicEtAff`
setoid** — everything through `mk`/`ind`/`mk_eq_mk_iff`/`descentMap` (the landed
`PicEtAffMap`/(C2)-lesson conventions); (iv) cross-field degree facts route through
E-iv-alg/B-3 only, never through unpinned scheme isos (deg-d5b D1 echoed).

| Brick | The map + laws | Size | Gate |
|---|---|---|---|
| **W7-F1 `relpic-curve-map`** | `relPicCurveMap (g : D ⟶ E) : relPic E T →* relPic D T` on `CechPic.map ((g ▷ T).left)`: base classes stay base classes (`(g ▷ T) ≫ snd E T = snd D T` whisker naturality), `map_id`/`map_comp`, naturality vs test restriction | S/M | none — NOW |
| **W7-F2 `picetaff-curve-map`** | the D2-ii parameterized core + instantiation at `fun B => (g ▷ overSpec k B).left`: `PicEtAff.curveMap g : PicEtAff E A →* PicEtAff D A` over the shared `EtaleCover A` index; `mk`-compat, `mk_eq_mk_iff` transport, `mapAlg` bilateral square | M | F-1 shapes |
| **W7-F3 `picet-curve-map`** | lift componentwise through the affine-opens limit: `picEtPullback g : picEt E T →* picEt D T`, natural in `T` vs `picEtMap`, `picEtAffineEquiv`-compat at affine tests; functor-level bundling (natural transformation `picEtFunctor E ⟶ picEtFunctor D`) | S/M | F-2 |
| **W7-F6 `functor-packaging`** | `pic0Pullback g` (membership by EV-cor) as a CommGrpCat-level natural transformation; then the **pinned `functor.map` construction — probe C (§5) machine-checked this session**: `yonedaGrpFullyFaithful.preimage ((yonedaGrpObjIsoOfRepresentableBy dY.J _ dY.rep).hom ≫ t ≫ (yonedaGrpObjIsoOfRepresentableBy dX.J _ dX.rep).inv)`; `map_id`/`map_comp` by `yonedaGrp` faithfulness + F-1..F-3 laws, stated with repeated datum arguments per D1 | S/M | F-3, EV-4, D1 |

**Can start TODAY**: F-1 in full. **Same-wave gates only**: F-2 (F-1 shapes + D2-ii),
F-3 (F-2), F-6 (F-3 + EV-4 + D1 ruling). **Foreign gates**: none until the frozen
discharge (DAT-J). B-2 consumes the same D2-ii core (§1.2).

---

## §3 Candidate file map (orchestrator ratifies; all outside other fleets' lanes)

New files only; nothing here touches `Challenge.lean`, any `archon-protected.yaml` name,
the Fleet-A DAT/DD lanes (`Cohomology/GluedSheaf*`, `Cohomology/DatumDescent*`,
`Picard/DivisorFamily*`, `Picard/Grassmannian*`, `Picard/SectionsToDivisors*`, W6
`Albanese/`), or the W5 `Tangent/`/`AbelianVariety/` allocation:

- `Picard/RelPicCurveMap.lean` (F-1); `Picard/PicEtAffCurveMap.lean` (D2-ii core + F-2);
  `Picard/PicEtCurveMap.lean` (F-3); `Picard/Pic0Pullback.lean` (F-6, incl. probe-C
  packaging).
- `Curve/CrossBaseSquare.lean` (B-1); `Picard/PicEtAffBaseFieldShuffle.lean` (B-2);
  `RiemannRoch/ClassDegMapIso.lean` (B-3); `Picard/Pic0Theta.lean` (B-4a+B-4b);
  `Picard/JacobianDataBaseChange.lean` (B-5 + B-6a + B-6b + **sole owner of the R4
  `letI` keying seams** at the frozen spelling).
- `Curve/CurveMorphismDichotomy.lean` (EV-1a..1d); `RiemannRoch/DegreePullback.lean`
  (EV-2..EV-4; splits if > 500L).
- K-1/A-1 files named by their own worksheets (mandated: `informal/w7-k1-worksheet.md`
  before K-cluster code; A-1 spec rides the K-1 worksheet or its own [S] spec note).

Lane protocol: `w5-worksheet.md` §0 verbatim (private-index+CAS commits, mkdir lake
mutex, ≤500-line files, `lean_verify` keystones, zero sorries, no sorried instances,
LSP-first). Blueprint debt rule: each brick's acceptance includes its blueprint node.

---

## §4 Risk register (w5-worksheet style: balloons ⚠ + fallbacks + cross-fleet notes)

- **R-W7-1 ⚠⚠ E-v balloon (EV-1b / EV-1d / EV-2).** The wave's only campaign-scale
  risk. Mitigations: worksheet-first mandate (§2.1) + the three named probes BEFORE
  ratification; EV-1d has a stated class-level fallback; EV-2 is flagged the hardest
  single leg with its dictionary decomposed. **Honest note: there is NO cheap fallback
  for EV-2/EV-3** — any degree-0-preservation statement needs the fiber-sum = constant
  rank identity (even `deg h*([P]−[Q]) = 0` compares two fiber sums against the same
  `n`), so if EV-2 walls, the escalation is a campaign re-scope by the orchestrator,
  not a lane-level dodge. No interaction with any other fleet.
- **R-W7-2 ⚠ plus-transport volume (F-2/B-2, the R2 inheritance).** Mitigation: D2-ii
  single parameterized core; opaque defs + named simp lemmas, never unfold covers;
  the landed `PicEtAffMap` campaign is the yardstick and template. Fallback: fork into
  two concrete campaigns (prover bail decision, reported).
- **R-W7-3 ⚠ K-1 eqToIso/`.hom.hom.hom` friction (R3 inheritance).** The frozen
  `idIso`/`compIso` are eqToIso-cored (`Challenge.lean:211-226`) and `mapGrpIdIso`/
  `mapGrpCompIso` components are `Grp.mkIso (Iso.refl _)` (mathlib source read this
  session — their `.hom.hom.hom` are identities, which HELPS). Pinned mitigation:
  reduce every Grp-iso equality through `Grp.hom_ext` (:122) + `homEquiv` to
  element-level `pic0Subgroup` equalities FIRST; θ-cocycle stated as CommGrpCat-natiso
  equalities over `Over.pullbackComp`/`pullbackId` (no Grp(Over) objects); K-1
  worksheet mandated before code.
- **R-W7-4 instance keying at the frozen spelling (R4 inheritance).** Probe 1's `rfl` +
  probe D's green certificates bound it; ownership pinned: ALL ascribed `letI` seams
  live in `Picard/JacobianDataBaseChange.lean`, never in consumers (JacobianData.lean
  η-verdict pattern).
- **R-W7-5 field-point matching quantifier trap (R5 inheritance, B-4a).** Same-universe
  verified (recon); the tower-instance pattern of `DegreeZero.lean:229-239` is mandated
  in the brick spec; budget line-count, not design.
- **R-W7-6 statement-audit debt on `functor.map`'s value (R6) — PARTIALLY RETIRED.**
  Probe C pins THE construction (yonedaGrp-preimage of the conjugated pic0
  transformation) and machine-checks its type. Residual: the K-1 worksheet must audit
  `baseChangeIso_id`/`_comp`/`baseChange_ofCurve` provability against this pinned value
  BEFORE any K/A lane proves (the "one pinned universal element" rule) — that audit is
  a K-1-worksheet acceptance criterion, named here.
- **R-W7-7 cross-fleet: Fleet A's DAT-G (Γ-equivariance/descent).** Three touchpoints:
  (i) *vocabulary*: DAT-G's functor comparison `pic0(C,T) ≅ pic0(C_{k'},T_{k'})^Γ` is
  the finite-Galois sibling of θ — B-1/B-2 MUST reuse the deg-d5b transition-kit
  spellings (`isPullback_baseFieldTransition`, `TransitionSectionsBaseChange`) so the
  two campaigns stay on one shuffle vocabulary; θ is one-sided (no Γ, no invariants)
  and MUST NOT grow Galois content. (ii) *producer genericity*: the D1 watch item —
  if DAT-G forces any hypothesis on `k`/`k'` into the producer, `baseChangeIso`'s
  arbitrary-`L` discharge breaks; orchestrator to obtain Fleet A's confirmation.
  (iii) *file space*: both fleets write under `Picard/` — the §3 file map should be
  declared to Fleet A by inbox note on ratification.
- **R-W7-8 cross-fleet: W5-S3's descent brick (w5-t4 §5 CodescendsAlong).** No Wave-7
  target needs rel-dim descent — W7 must NOT queue behind it. Shared substrate flows
  the OTHER way: `flat_specMap_algHom`/`surjective_specMap_algHom`
  (BaseFieldTransition.lean:117-134, re-read this session) are the `Spec k̄ → Spec k`-leg
  lemmas S3's `(@Surjective ⊓ @Flat ⊓ @QuasiCompact)` instantiation wants; note to the
  Fleet-C session so it doesn't re-derive them.
- **R-W7-9 B-4b limit assembly.** If naturality-in-`T` fights the affine-opens limit,
  fallback: state θ on affine tests and extend by the sheaf property — Fleet A's DAT-2
  (pic0 is a Zariski sheaf) is the natural helper; watch its landing, don't gate on it.

---

## §5 Machine-checked probes (this session, `lean_run_code` against the live tree; all green)

- **Probe A1-A4 (EW-4)**: both datum idioms elaborate — per-curve
  `(dfam : ∀ X : Curve k, JacobianData X.carrier)` and field-uniform
  `(dfam : ∀ (k' : Type u) [Field k'] (X : Curve k'), JacobianData X.carrier)`; the
  uniform family instantiates at `dfam L ⟨(baseChange k L).obj C⟩ :
  JacobianData ((baseChange k L).obj C)` and `dfam k ⟨C⟩ : JacobianData C` with zero
  massage (anonymous `Curve` constructor + the frozen stability instances).
- **Probe B (EW-6)**: the D4 statement shape —
  `GrpObj.ofRepresentableBy ((baseChange k L).obj d.J) (pic0Functor C_L ⋙ forget₂ …) rep'
  = Functor.grpObjObj (F := baseChange k L) (G := d.J)` under `letI := d.grpObj` —
  elaborates as a Prop (generic `rep'`; `Functor.Monoidal` instance found on
  `baseChange k L`).
- **Probe C (F-6/R6)**: the pinned `functor.map` packaging term
  `yonedaGrpFullyFaithful.preimage ((yonedaGrpObjIsoOfRepresentableBy dY.J _ dY.rep).hom
  ≫ t ≫ (yonedaGrpObjIsoOfRepresentableBy dX.J _ dX.rep).inv) :
  Grp.mk dY.J ⟶ Grp.mk dX.J` typechecks for an arbitrary group-presheaf transformation
  `t` (the future `pic0Pullback`), under the two `letI := d.grpObj` activations.
- **Probe D (B-5 certificates)**: `LocallyOfFiniteType ((baseChange k L).obj d.J).hom`
  and `QuasiCompact ((baseChange k L).obj d.J).hom` both close by
  `MorphismProperty.baseChange_obj σ d.J inferInstance` under the datum's `letI` —
  the frozen file's own pattern, verbatim.

(The recon's probes 1-3 — frozen-spelling `rfl`, `mapPullbackAdj.representableBy`,
`genus_baseField` — are relied on but not re-run; recorded at w7-recon §2.0,
commit `7d450f7e2`.)

---

## §6 Ratification points for the orchestrator

1. **D1** (EW-4 ruling): per-curve explicit datum arguments + naming convention + the
   "no unnamed-curve data" hygiene rule; the family idiom recorded as probe-green
   fallback. **Plus the Fleet-A action**: confirm producer base-field-genericity.
2. **D2-i/ii/iii**: θ CommGrpCat-valued; the F-2/B-2 shared parameterized core (with
   the named prover bail condition); B-3 built now, not via E-v.
3. **D3** (EW-5): the launch order — {F-1 ∥ B-1 ∥ B-3 ∥ E-v-worksheet} now; E-v staffed
   first as the internal long pole; K-1/A-1 frozen closures last, after DAT-J.
4. **D4** (EW-6): the `GrpObj`-equality statement + `GrpObj.ext` route + [M] budget.
5. **§2.1**: the E-v worksheet-first mandate, the EV sub-brick cuts, the per-field-point
   dodge for EV-cor (no cross-field degree-uniformity brick), EV-2 flagged hardest.
6. **§2.2**: the F-cluster discipline clauses (i)-(iv) + brick cuts.
7. **§3**: the file map (then declared to Fleet A by inbox).
8. Worksheet mandates: `w7-ev-worksheet.md` (before EV-1b/1d/2 code) and
   `w7-k1-worksheet.md` (before K-cluster code; includes the R-W7-6 provability audit).

*End of draft. Everything above is recommendation + evidence; the orchestrator ratifies
(w5-t4 precedent). One-line summary: rule per-curve datum arguments, ride the three
green seams with eight S/M B-bricks (θ group-valued, `classDeg_map_iso` now, EW-6 by
`GrpObj.ext`), staff E-v first because it is the wave's only real mountain and it is
ungated today.*
