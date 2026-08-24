# Wave-7 reconnaissance — functoriality and base change of fields (`AJCR.w7-functor`)

*Read-only recon, 2026-07-17, produced by the parallel recon lane (w7-recon). This worksheet is
RECON for the future Wave-7 design pass: it maps ground truth and stakes out candidate bricks and
risks; it makes **NO binding design decisions** — all route choices flagged below (the θ
comparison strategy, the E-v proof route, brick cuts, sequencing) are candidates reserved to the
design pass. Every landed-name claim carries `file:line`, re-verified this session against the
tree at ledger commit `4861d8a27` (HEAD at recon time; the tree moves under this document) and
the pinned mathlib checkout (`.lake-packages/mathlib`, v4.31.0, `fabf563a7c95...`). Three claims
were additionally **machine-checked** through `lean_run_code` against the live build (§2.0). No
file outside `informal/` was touched; no lake build was run; the lake mutex was never taken.
Paper citations carry my own READ/UNREAD flags (§6). Trust the ledger and the files over any
prose here.*

Wave 7 = the four frozen clusters of `Challenge.lean` (READ verbatim this session, never edited):
`functor` (`:153-158`), `baseChangeIso` (`:244-248`) with its two coherence laws
(`baseChangeIso_id :253-259`, `baseChangeIso_comp :262-272`), and `baseChange_ofCurve`
(`:278-283`). Protected names per `archon-protected.yaml` (all four clusters listed, plus the
genuinely-proved statement vocabulary `Curve`/`baseChange`/`idIso`/`compIso`/`congr`).

---

## 0. Headline

- **What Wave 7 actually requires** (frozen signatures read precisely, §2.1): (i) a single
  contravariant functor `(Curve k)ᵒᵖ ⥤ Grp (Over (Spec (.of k)))` whose object action is pinned
  to `.mk (Jacobian X.unop.carrier)` — so `map` sends an arbitrary carrier morphism `f : X ⟶ Y`
  of bundled curves to a **group-scheme morphism `Jacobian Y ⟶ Jacobian X`** ("pullback of line
  bundles", docstring `:149-152`), with the laws inside the `Functor` fields; (ii) for every pair
  of fields `k, L : Type u` and **every** `[Algebra k L]` (no finiteness/separability), an iso
  `(baseChange k L).mapGrp.obj (.mk (Jacobian C)) ≅ .mk (Jacobian C_L)` **in
  `Grp (Over (Spec (.of L)))`** — a group iso, not a scheme iso; (iii) identity and cocycle
  coherence of these isos over towers `k → L → M` `[IsScalarTower k L M]`, stated through
  `Jacobian.congr`, which is **derived from `functor`** (`:233-240`) — so the coherence laws
  gate on `functor`; (iv) Abel–Jacobi compatibility, consuming Wave-6's `ofCurve` on both sides
  and the lax-monoidal unit `Functor.LaxMonoidal.ε (baseChange k L)`.
- **The biggest gap is a double one, and it belongs to `functor`, not `baseChangeIso`**:
  (i) **E-v, degree multiplicativity under pullback along a morphism of curves** — the fact that
  `g^*` of a degree-0 class is degree-0 needs `deg(g^*λ) = m·deg(λ)` per field point, which
  needs the constant-or-finite dichotomy plus a chart-level `Σ e·f = rank` splice into the
  colength dictionary. **No wave is producing this** (grep: nothing in the tree compares degrees
  across two different curves; route-decision item 19's `[S-tedious]` tag silently assumes it,
  §1.1). Softening: mathlib v4.31 has Zariski's Main Theorem
  (`IsFinite.of_isProper_of_locallyQuasiFinite`, `ZariskisMainTheorem.lean:371`) and the
  fundamental identity `Σ e·f = finrank` for finite flat algebras
  (`RingTheory/RamificationInertia/Basic.lean:72`) — the deep algebra is gifted; the dichotomy,
  fiber-finiteness, generic-rank and ord↔factor-multiplicity legs are project bricks (§3.2).
  (ii) **Curve-variable functoriality of the whole picEt stack**: the tree's transport is
  test-variable only (`picEtMap`, `mapAlg`) — `relPic`/`PicEtAff`/`picEt` have **zero**
  curve-crossing maps (grep `(C C' : Over` over `Picard/`: no hits); only the raw
  `Scheme.CechPic.map` (`Picard/Pic.lean:198`) crosses schemes. Both `functor` and
  `baseChangeIso` sit on this plumbing campaign.
- **The biggest asset** is that the `baseChangeIso` *mechanism* is essentially fully staged:
  the designated engine `JacobianData.uniqueUpToIso` + `homEquiv_uniqueUpToIso_hom` is landed
  (`Picard/JacobianData.lean:134,139`, commit `c641ef211`); the adjunction-transport step is a
  **verbatim mathlib term** (`(Over.mapPullbackAdj σ).representableBy J` — machine-checked this
  session, §2.0 probe 2); E-iv-alg and the transition-square toolkit are landed exactly with the
  Wave-7 general form promised by deg-d5b §3 (`Curve/BaseFieldTransition.lean:76,109`;
  `RiemannRoch/DegreeBaseFieldInvariance.lean:462`); X3's `genus_baseField` consumes at the
  frozen `baseChange` spelling **with zero massage** (probe 3); and the feared spelling seam
  between the frozen `baseChange` and the degree lane's `(C ⊗ overSpec k K)` stack is **`rfl`**
  (probe 1). What remains of `baseChangeIso` is one genuinely new comparison natiso θ (§3.3 B-4)
  plus `classDeg_map_iso` (planned for Wave 7 by deg-d5b §3, still absent — grep zero hits) and
  a group-structure coherence glue with no mathlib gift (§3.3 B-6).
- **Sequencing surprise worth stating up front**: `baseChangeIso` itself does not need
  `functor`, but **both coherence laws do** (via `congr`), and `baseChange_ofCurve` needs
  Wave-6's `ofCurve` pinned. Meanwhile the heavy Wave-7 mathematics (E-v, the transport chain,
  θ) is **ungated today** — none of it touches `JacobianData` producers. The early-warning list
  for the orchestrator is §5-EW.

---

## 1. Staleness / context audit — what the binding docs say about Wave 7, and what moved

### 1.1 `route-decision.md` §4, Wave-7 items 19–21 (route-decision.md:180-184) — one tag optimistic, one clause superseded

Verbatim (re-read this session): item 19 — "`functor` (pullback of line bundles = precomposition
on represented functors; laws by uniqueness) [S-tedious]"; item 20 — "`baseChangeIso` (étale-site
base-change formal identity + `(Pic⁰)_L = (Pic_L)⁰` from #15) [S]"; item 21 — "coherences +
`baseChange_ofCurve` (uniqueness of isos intertwining pinned universal elements) [R–S given the
pin]".

Staleness findings:
1. **Item 19's `[S-tedious]` hides a mountain.** "Pullback of line bundles" is not
   precomposition in any variable that exists in the landed carrier: `pic0Functor C` is a
   functor in the *test*, and the curve is a parameter. The honest content is (a) a
   curve-variable transport chain through the plus construction (three layers, §3.2 F-1..F-3)
   and (b) the degree-0 preservation E-v (§3.2 F-4/F-5) — the latter is real mathematics
   (`deg g^* = (deg g)·deg`) that no other wave produces and the item's tag does not budget.
   "Laws by uniqueness" survives: with `yonedaGrp` fully faithful (§2.7) the functor laws do
   reduce to naturality of the pullback transformation.
2. **Item 20's "`(Pic⁰)_L = (Pic_L)⁰` from #15" was already superseded** by the Wave-3 design's
   own D7 (`wave3-picard-design.md:31` and §6.3 `:770-790`, both re-read verbatim this session):
   `baseChangeIso` does **not** go through identity components; the degree-0 condition is
   E-iv-stable under the shuffle directly, and the deviation is recorded in design §10. The
   deg-d5b worksheet then pinned the concrete route (§1.3 below). Item 20's `[S]` is roughly
   right *for the mechanism* (it is now largely landed + mathlib-gifted) but does not count θ's
   plumbing or the group-coherence glue.
3. **Item 21's "uniqueness of isos intertwining pinned universal elements" is exactly the landed
   `homEquiv_uniqueUpToIso_hom`** (`Picard/JacobianData.lean:139-144`) — this clause aged well;
   the remaining coherence cost is θ's own cocycle and eqToIso bookkeeping (§3.4), plus the
   unbudgeted fact that the laws consume `congr`, hence `functor` (§2.1).

### 1.2 `wave3-picard-design.md` D7 + §6.3 — intact and binding-in-spirit

Re-read `:770-790`: "**`baseChangeIso` does NOT go through identity components** in this design:
the degree-0 condition is manifestly stable under the base-field shuffle by (E-iv), so
`pic0Functor (C_L) ≅ (pic0Functor C)`-shuffled directly." Nothing landed contradicts this; the
E-iv keystone the clause anticipated is landed (§2.3). The recon adopts this as the working
frame for θ (candidate, not decided — §3.3).

### 1.3 `deg-d5b-worksheet.md` §3/§4/§5 — the designed-for-inheritance plan, now largely LANDED

The worksheet (re-read in full) designed the base-field shuffle *for Wave-7 inheritance*:

- **§3 D3** "shuffle-as-square, never shuffle-as-iso" for the degree campaign, with the explicit
  Wave-7 pin: "The iso form is deferred to Wave-7, and designed here so Wave-7 inherits" — for
  each test `T ∈ Over (Spec L)` the iso `(C_L ⊗_L T).left ≅ (C ⊗_k T).left` via pasted
  `IsPullback` squares + `IsPullback.isoIsPullback`, CechPic transport as a `MulEquiv`,
  `picFromBase`/`descentClasses` compatibility ("étale covers live on the test *algebra*,
  identical on both sides"), and degree-0 stability = E-iv-alg + **one new Wave-7 lemma
  `classDeg_map_iso`**. Field-point matching: "every k-field-point of an L-test object is
  canonically an L-field-point".
- **§4 consumption map**: "Wave-7's `baseChangeIso` inherits SB-1 (state `IsPullback` inputs
  generally), SB-2's engine, SB-5's E-iv-alg and CechPic-of-field-triviality, and owns the iso
  family + `classDeg_map_iso` + picEt transport."
- **What landed of it** (re-verified this session): SB-1 in `Curve/BaseFieldTransition.lean`
  with the promised general form — `Over.isPullback_whiskerLeft_left` `:76` is stated for an
  arbitrary test morphism `t : T' ⟶ T` "so that Wave-7's `baseChangeIso` can re-instantiate it
  at arbitrary test objects" (docstring `:27-29`) — **but over a COMMON base `S`**; the Wave-7
  comparison crosses the two slices `Over (Spec L)` / `Over (Spec k)`, so a cross-base pasted
  variant is still needed (small, §3.3 B-1). SB-2 landed
  (`Cohomology/TransitionSectionsBaseChange.lean`, incl. `baseChangeBundle :116`). SB-5's
  keystone landed (`classDeg_cechPicMap_baseFieldTransition`,
  `RiemannRoch/DegreeBaseFieldInvariance.lean:462`). SB-3's colength dictionary landed
  (`RiemannRoch/ChartColength.lean`, §2.3 — also E-v's engine). **`classDeg_map_iso`: still
  zero hits in the tree** (grep this session), exactly as §5.5 planned ("Wave-7-owned; only its
  *existence* is planned for here").
- **§2 D2's scope note** ("the χ half … genus invariance … is a Wave-5/ζ concern") has since
  resolved in Wave 7's favor: W5-X3 landed it (§2.4).

### 1.4 `w4-datum-worksheet.md` §1.4 consumption row — Wave 7's gate, stated

Re-read verbatim (`:146-ish`, the table row): "`functor` `:153`, `baseChangeIso` `:244` +
coherences `:253,:262`, `baseChange_ofCurve` `:278` | Wave 7, consuming **`jacobianData` at
every curve** + the deg-d5b §3 inheritance (`isPullback_baseFieldTransition` inputs stated
generally, `classDeg_map_iso` planned there)". Two consequences the Wave-5 consumption header
does not cover:
1. `functor` quantifies over **all** curves `X : Curve k` — a single section variable
   `(d : JacobianData C)` cannot state it. Wave-7 statements need a **datum family**
   (e.g. `(dfam : ∀ X : Curve k, JacobianData X.carrier)`) or the producer itself.
2. `baseChangeIso` needs data **over two different base fields** (`C` over `k`, `C_L` over `L`)
   — the family must be uniform in the base field. The producer's signature is field-generic
   (every Wave-4 statement takes an arbitrary `[Field k]`), so this is an idiom decision, not a
   mathematical gap — but it is an **orchestrator decision** (early warning EW-4).
`JacobianData` itself is landed as interface-only (`Picard/JacobianData.lean`, `c641ef211`);
the producer `jacobianData` has **zero Lean-tree hits** outside doc-comments (grep this
session) — DAT-J property, in flight in the Wave-4 fleet.

### 1.5 Waves 5/6 state at recon time (roadmap re-read this session)

- **W5** (`AJCR.w5-av`, 8/16): landed and Wave-7-relevant — `data` (the datum interface),
  **X3** (`Cohomology/H1BaseFieldInvariance.lean`: the any-`k`-algebra CBC ladder +
  `genus_baseField`, §2.4), X1/X2 (group-scheme separatedness + translation — Wave-5-internal;
  Wave 7 consumes neither directly), the conditional P2/P3/G1 package on `AbelSourceData`
  (§2.5 — again not a Wave-7 input). Pending: T-chain, S-cluster, P1 (cross-wave gate).
- **W6** (`AJCR.w6-albanese`, 5/9): the port-ext/port-alg lanes are done (Milne 3.1/3.2 with 3.3
  as named hypothesis); `ofCurve` is **fed by the degree lane, not Wave-6-owned**:
  `ofCurve P := rep.homEquiv.symm (abelElement P)` (w6-albanese-port-recon §1.1, re-read), and
  **`abelElement` is LANDED** (`Picard/AbelElement.lean:126`, with the functor-point formula
  `abelElement_map :149` and the pointing law `abelElement_map_point :160`) — so
  `baseChange_ofCurve`'s Wave-6-side input is concretely pinned today even though the frozen
  `ofCurve` sorry waits for DAT-J.

---

## 2. Exact API map (verbatim signatures + `file:line`; LANDED only unless marked)

Paths under `…/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/` unless prefixed. Tags:
**[landed]** = in the Rebuild tree, re-verified this session; **[mathlib]** = pinned checkout
v4.31.0, re-verified this session; **[PROBE ✓]** = machine-checked via `lean_run_code` this
session.

### 2.0 Machine-checked probes (this session; live tree + pinned mathlib; all three green)

```lean
-- Probe 1 [PROBE ✓]: the frozen Challenge spelling IS the degree-lane spelling, definitionally.
example … : (baseChange k L).obj C = baseChangeBundle C L := rfl
-- Probe 2 [PROBE ✓]: mathlib's adjunction-representability transports the datum verbatim.
noncomputable example … (J : Over (Spec (.of k))) :
    ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op ⋙
      yoneda.obj J).RepresentableBy ((baseChange k L).obj J) :=
  (Over.mapPullbackAdj (Spec.map (CommRingCat.ofHom (algebraMap k L)))).representableBy J
-- Probe 3 [PROBE ✓]: X3's genus invariance is consumable at the FROZEN spelling, zero massage.
example … : genus ((baseChange k L).obj C) = genus C := genus_baseField C L
```

Probe 1 kills the feared spelling seam: `(baseChange k L).obj C` unfolds to
`Over.mk (pullback.snd C.hom (Spec.map …))` (mathlib `Over.pullback` obj,
`Comma/Over/Pullback.lean:63-64`) and `baseChangeBundle C L`
(`Cohomology/TransitionSectionsBaseChange.lean:116`) to
`Over.mk (snd C (overSpec k L)).left` = the same term (`snd_left` rfl,
`Monoidal/Cartesian/Over.lean:79`; `overSpec_hom` rfl, `Cohomology/SectionsBaseChange.lean:104`).
Caveat carried from the JacobianData η-defeq verdict (`Picard/JacobianData.lean:41-55`):
**instance search keys syntactically** — the landed instance stacks are keyed on the
`(C ⊗ overSpec k K).left` spelling, so consumers at the frozen spelling may need one ascribed
`letI` per instance, owned once in one file (risk R4).

### 2.1 The frozen targets, read precisely (Challenge.lean, 18 sorries total; W7 owns 7)

```lean
structure Curve (k : Type u) [Field k] where carrier : Over (Spec (.of k))
  [isProper …] [smoothOfRelativeDimension …] [geometricallyIrreducible …]      -- :67-72; attribute [instance] :74
instance : Category (Curve k) where Hom X Y := X.carrier ⟶ Y.carrier …          -- :76-82 (ARBITRARY Over-morphisms)

noncomputable def functor (k : Type u) [Field k] :
    (Curve k)ᵒᵖ ⥤ Grp (Over (Spec (.of k))) where
  obj X := .mk (Jacobian X.unop.carrier)   -- pinned; group structure = the frozen instGrpObj
  map _ := sorry ; map_id := sorry ; map_comp := sorry                           -- :153-158 ★
```
Variance: for `f : X ⟶ Y` in `Curve k`, `functor.map f.op : .mk (Jacobian Y.carrier) ⟶
.mk (Jacobian X.carrier)` — contravariant. `map` produces a morphism in `Grp (Over …)`
(underlying morphism + `IsMonHom`), for **every** carrier morphism including non-dominant ones.
`Jacobian.congr e` (`:233-240`, genuinely defined, frozen) = `functor.mapIso j.symm.op`, i.e.
`Jac C ≅ Jac C'` realized as pullback along `e.inv` — **so both coherence laws below consume
`functor`**.

```lean
noncomputable def baseChangeIso (k L : Type u) [Field k] [Field L] [Algebra k L] (C : …) […] :
    (baseChange k L).mapGrp.obj (.mk (Jacobian C)) ≅ .mk (Jacobian ((baseChange k L).obj C))    -- :244-248 ★
theorem baseChangeIso_id (C) […] : baseChangeIso k k C =
    (Functor.mapGrpNatIso (baseChange.idIso k)).app _ ≪≫ (Functor.mapGrpIdIso …).app _
      ≪≫ Jacobian.congr ((baseChange.idIso k).app C).symm                                        -- :253-259 ★
theorem baseChangeIso_comp (k L M) […] [IsScalarTower k L M] (C) :
    baseChangeIso k M C ≪≫ Jacobian.congr ((baseChange.compIso k L M).app C) =
      (Functor.mapGrpNatIso (baseChange.compIso k L M)).app _ ≪≫ (Functor.mapGrpCompIso …).app _
        ≪≫ (baseChange L M).mapGrp.mapIso (baseChangeIso k L C)
        ≪≫ baseChangeIso L M ((baseChange k L).obj C)                                            -- :262-272 ★
theorem baseChange_ofCurve (C) […] (P : 𝟙_ … ⟶ C) :
    (baseChange k L).map (ofCurve P) ≫ (baseChangeIso k L C).hom.hom.hom =
      ofCurve (Functor.LaxMonoidal.ε (baseChange k L) ≫ (baseChange k L).map P)                  -- :278-283 ★
```
Quantification pinned: `baseChangeIso` takes two **arbitrary same-universe fields** with any
`[Algebra k L]` (a field embedding — no finiteness, no separability, no algebraic-ness). The
iso lives in `Grp (Over (Spec (.of L)))`; the LHS group structure is `mapGrp`'s transport
(mathlib `grpObjObj`: `ι ↦ F.map ι`, `Monoidal/Grp.lean:607`), the RHS is the frozen
`instGrpObj` at the L-curve (→ future `(jacobianData C_L).grpObj`). `.hom.hom.hom` peels
Grp-hom → Mon-hom → `Over (Spec L)`-morphism. The genuinely-proved frozen scaffolding: the
`baseChange` functor `:170-172` (= `Over.pullback (Spec.map (ofHom (algebraMap k L)))`), the
stability instances `:174-208` (incl. the `(𝟭 _).obj`/`(⋙).obj` spellings the coherences
mention), `idIso :211-215` and `compIso :218-226` (both `eqToIso`-cored — the coherence proofs
will meet these eqToIso's).

### 2.2 The landed `baseChangeIso` mechanism — the Wave-4/5 datum seam (`c641ef211`)

```lean
structure JacobianData (C) […] where J; rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat)
  ⋙ forget GrpCat).RepresentableBy J; locallyOfFiniteType; quasiCompact       -- Picard/JacobianData.lean:87-100
noncomputable def grpObj (d) : GrpObj d.J := GrpObj.ofRepresentableBy …        -- :113
def homEquiv (d) : (T ⟶ d.J) ≃ pic0Subgroup C T                                -- :119-121
theorem homEquiv_comp (d) (f : T' ⟶ T) (g : T ⟶ d.J) :
    d.homEquiv (f ≫ g) = pic0Map C f (d.homEquiv g)                            -- :126-129
noncomputable def uniqueUpToIso (d d' : JacobianData C) : d.J ≅ d'.J           -- :134  ← THE designated mechanism
theorem homEquiv_uniqueUpToIso_hom (d d') (f : T ⟶ d.J) :
    d'.homEquiv (f ≫ (d.uniqueUpToIso d').hom) = d.homEquiv f                  -- :139-144 (the intertwining law)
```
Note `uniqueUpToIso` compares two data **for the same curve over the same field** — the Wave-7
use is: build a *transported* datum on `(baseChange k L).obj d.J` for the curve `C_L` over `L`
(§3.3 B-5), then `uniqueUpToIso` against the native `jacobianData C_L`. The η-defeq verdict
(`:41-55`) and smoke tests (`:158-184`) carry over.

### 2.3 Degree-lane inheritance — landed exactly as deg-d5b §3 promised

```lean
theorem Over.isPullback_whiskerLeft_left (X : Over S) {T T' : Over S} (t : T' ⟶ T) :
    IsPullback ((X ◁ t).left) ((snd X T').left) ((snd X T).left) t.left        -- Curve/BaseFieldTransition.lean:76 (general form, same-base)
theorem isPullback_baseFieldTransition (φ : K₁ →ₐ[k] K₂) : IsPullback …        -- :109 (+ flat :145 / affine :152 / surjective :160 instances)
theorem genericPoint_eq_of_surjective … ; Scheme.Hom.functionFieldMap …        -- :173,:209 (+ germ naturality :217, units :240)
theorem classDeg_cechPicMap_baseFieldTransition (φ : K₁ →ₐ[k] K₂) (L : ….CechPic) :
    classDeg K₂ (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L) = classDeg K₁ L
                                                                                -- RiemannRoch/DegreeBaseFieldInvariance.lean:462 (E-iv-alg keystone)
-- the E-v-reusable colength dictionary (SB-3, landed):
theorem isDedekindDomain_section (hη : genericPoint X ∈ V) : IsDedekindDomain Γ(X, V)  -- RiemannRoch/ChartColength.lean:126
theorem finrank_quotient_primeIdealOf … ; toAdd_ordZ_eq_count_factors …               -- :199,:278
theorem finrank_quotient_span_section …                                               -- :411
-- degree carriers:
def PicEtAff.degAff : PicEtAff C K → ℤ                                          -- Picard/DegreeZero.lean:263 (degAff_unit :314)
def degAt … ; degAt_picEtMap … ; pic0Subgroup :107 ; pic0Map :132 ; pic0Functor :151 ; pic0Inclusion :176
                                                                                -- Picard/Pic0Functor.lean:54,:87,…
def CechPic (X : Scheme) ; def CechPic.map (f : X ⟶ Y) : Y.CechPic →* X.CechPic -- Picard/Pic.lean:60,:198 (map_id/map_comp; ARBITRARY scheme morphisms — the only curve-crossing transport in the tree)
-- cover index is base-field-free:
Algebra.EtaleCover A  (presented étale covers of A — no reference to k)         -- Algebra/EtaleCover.lean:~58
EtaleCover.baseChange :238 ; baseChangeInclude :248 ; exists_finiteSeparableField_algHom :287 ; ofField :311
-- Abel element (baseChange_ofCurve's substrate):
def abelElement (P) : pic0Subgroup C C  ; abelPicEt_map :140 ; abelElement_map :149 ; abelElement_map_point :160
                                                                                -- Picard/AbelElement.lean:126,…  (+ degAt_relPicToPicEt :69)
theorem graphLocalEquations_base_change …                                        -- Curve/GraphDivisor.lean:263 (graph classes base-change; the θ↔abelElement bridge)
```
Key structural fact for θ (§3.3): `picEt C T` is the **affine-opens limit** valued in
`PicEtAff C Γ(T.left, U)` (`Picard/PicEt.lean` module docstring) — the test enters only through
its section *algebras*, and `EtaleCover A` is indexed by the algebra alone. So the k-vs-L
comparison at a test `T ∈ Over (Spec L)` collapses layer by layer to
`PicEtAff C A ≃* PicEtAff (C_L) A` over literally shared cover indices, then to `relPic`
comparison = `CechPic.map` of the shuffle iso. This is why deg-d5b §3's plan is credible.

### 2.4 X3 + curve substrate — the k→K cohomology story, landed

```lean
noncomputable def curveH1BaseChange : R ⊗[k] H¹(C,𝒪) ≃ₗ[R] H¹(C_R,𝒪)           -- Cohomology/H1BaseFieldInvariance.lean:272 (ANY commutative k-algebra R — the dual-numbers lane shares it)
noncomputable def h1BaseFieldEquiv / h0BaseFieldEquiv                            -- :328,:336 (field form, keyed on (C ⊗ overSpec k K).left)
theorem finrank_h1_baseField :344 ; finrank_h1_baseField_eq_genus :364
theorem genus_baseField : genus (baseChangeBundle C K) = genus C                 -- :373  [PROBE ✓ consumable at the frozen spelling]
-- base-change instance stack for C_K (any K/k):
instOverBaseChange / instSmoothOfRelativeDimensionSndLeft / instIsProperSndLeft / … / instIsIntegralBaseChange
                                                                                -- Curve/BaseChangeInstances.lean (doc :34-46)
noncomputable abbrev baseChangeBundle (K) : Over (Spec (.of K))                  -- Cohomology/TransitionSectionsBaseChange.lean:116
```
Wave-7 relevance: `genus_baseField` is what makes the two sides of `baseChangeIso` have the
same `genus` numeral in downstream statements; the any-`R` CBC ladder is *adjacent* (Wave-5
tangent lane), not a Wave-7 input. The instance stack + probe 1 give the frozen file's L-curve
its degree theory for free.

### 2.5 Wave-5 group-scheme layer — landed; Wave 7 consumes almost none of it directly

`isSeparated_of_isClosedImmersion_one` (`AbelianVariety/GroupSeparated.lean:96`),
`isSeparated_of_grpObj` (`:108`), `JacobianData.isSeparated` (`:115`); `pointTranslation`
(`AbelianVariety/Translation.lean:75`), `pointTranslationIso` (`:96`); `AbelSourceData` +
P2/P3/G1 (`AbelianVariety/AbelSource.lean:90,113,126,139`). Role for Wave 7: none of the four
frozen targets consumes these — they are recorded here because the *design idiom* (honest
generalities over `(G : Over …) [GrpObj G]` + datum corollaries, w5-worksheet D2) is the model
Wave-7 statements should follow, and because `AbelSource.lean`'s probe notes verified
`MorphismProperty.IsStableUnderBaseChange @Surjective` (mathlib `PullbackCarrier.lean:431`,
relayed from that file's docstring — not re-greped here).

### 2.6 DAT-6 slice trick — what the landed Σ-machinery contributes

```lean
noncomputable abbrev pic0TypeFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u        -- Picard/Pic0SigmaSheaf.lean:58 (the forget₂⋙forget massage, owned once)
noncomputable abbrev pic0SigmaFunctor : Scheme.{u}ᵒᵖ ⥤ Type u                   -- :76 (Σ-extension to the BIG site)
theorem pic0SigmaFunctor_isSheaf :90 ; pic0SigmaSheaf :147 ; pic0RepresentableByOfCharts :161
def Over.sigmaExtension :125 ; overSlice :235 ; sigmaExtension_map_mk_eq_iff :176 -- Picard/OverSigmaExtension.lean
```
Contribution to Wave 7: (i) `pic0TypeFunctor` is the canonical Type-valued carrier every
Wave-7 `RepresentableBy` manipulation should be phrased against (it is what probe 2's chain
composes with); (ii) the `sigmaExtension`/`overSlice` calculus is the in-house precedent for
"transport `RepresentableBy` across a change of ambient category" — the same discipline θ's
Step-2/Step-4 transports need; (iii) the Σ-extension itself is over `Spec k` and does **not**
directly provide the k→L comparison (the L-slice of `pic0SigmaFunctor C` is not
`pic0TypeFunctor (C_L)`) — do not mistake it for θ.

### 2.7 Mathlib gifts (all re-verified this session against the pinned checkout)

```lean
-- Grp category + transport (Mathlib/CategoryTheory/Monoidal/Grp.lean):
structure Grp :82 ; hom_ext (f.hom.hom = g.hom.hom → f = g) :122 ; homMk [IsMonHom f] :135
def mkIso' :433 ; abbrev mkIso (e : G.X ≅ H.X) (one_f) (mul_f) : G ≅ H :442     -- forward-direction η/μ compat only
abbrev grpObjObj [F.Monoidal] : GrpObj (F.obj G) :607 ; def mapGrp [F.Monoidal] : Grp C ⥤ Grp D :628
def mapGrpIdIso :673 ; mapGrpCompIso :680 ; mapGrpNatTrans :688 ; mapGrpNatIso :694
-- representably-grouped objects (Mathlib/CategoryTheory/Monoidal/Cartesian/Grp.lean):
def GrpObj.ofRepresentableBy :35 ; yonedaGrpObj :76
def yonedaGrpObjIsoOfRepresentableBy (F) (α) : yonedaGrpObj X ≅ F :100           -- the homEquiv-as-group-iso packaging
def yonedaGrp : Grp C ⥤ Cᵒᵖ ⥤ GrpCat :115 ; yonedaGrpFullyFaithful :126          -- ★ functor.map's packaging gift: build the natural transformation of group presheaves, take .preimage; laws by faithfulness
-- Over/pullback (Mathlib/CategoryTheory/Comma/Over/Pullback.lean):
def pullback (obj g := Over.mk (pullback.snd g.hom f)) :63 ; mapPullbackAdj :74  -- Over.map f ⊣ Over.pullback f
def pullbackId :105 ; pullbackComp :109
-- monoidal structure (Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean):
tensorObj_left (rfl) :60 ; snd_left (rfl) :79 ; instance : (Over.pullback f).Braided :199
lemma η_pullback_left :202 ; ε_pullback_left :206 ; μ_pullback lemmas :213-241   -- computable ε/μ components for the mapGrp coherence glue
-- representability transport (Mathlib/CategoryTheory/Yoneda.lean, Adjunction/Basic.lean):
structure RepresentableBy :284 ; ofIso :301 ; uniqueUpToIso :343 ; ofIsoObj :432 ; equivOfIsoObj :449 ; toIso :399
def Adjunction.representableBy (Y : D) : (F.op ⋙ yoneda.obj Y).RepresentableBy (G.obj Y) -- Adjunction/Basic.lean:326 [PROBE ✓ on mapPullbackAdj]
noncomputable def IsPullback.isoIsPullback :…                                     -- Limits/Shapes/Pullback/IsPullback/Defs.lean:166
-- the E-v algebra stack:
lemma IsFinite.of_isProper_of_locallyQuasiFinite                                  -- AlgebraicGeometry/ZariskisMainTheorem.lean:371 (proper + quasi-finite ⇒ FINITE; Zariski's Main Theorem is IN mathlib)
lemma IsProper.of_comp [IsProper (f ≫ g)] [IsSeparated g] : IsProper f            -- Morphisms/Proper.lean:118 (instance :109)
class LocallyQuasiFinite … ; locallyQuasiFinite_iff_finite_preimage_singleton     -- Morphisms/QuasiFinite.lean:~70 (doc :36-38: finite type ⇒ qf ⟺ finite fibers)
lemma Scheme.Hom.finite_appTop [IsFinite f] : f.appTop.hom.Finite                 -- Morphisms/Finite.lean:157 (+ stability :53,:57; IsFinite → IsIntegralHom :106)
theorem Ideal.sum_ramification_inertia_eq_finrank
    [IsDomain R] [Module.Finite R S] [Module.Flat R S] [Fintype (p.primesOver S)] :
    ∑ q : p.primesOver S, e·f = Module.finrank R S                                -- RingTheory/RamificationInertia/Basic.lean:72 (+ fiber form :44)
theorem Ideal.sum_ramification_inertia (Dedekind fraction-field form)             -- NumberTheory/RamificationInertia/Basic.lean:596
theorem IsDedekindDomain.flat_iff_torsion_eq_bot                                  -- RingTheory/Flat/TorsionFree.lean:138 (flat = torsion-free over Dedekind — g's flatness)
```

### 2.8 Load-bearing ABSENCES (grep-verified this session; each is a Wave-7 debt or design fact)

1. **No curve-variable functoriality of `relPic`/`PicEtAff`/`picEt`/`pic0` anywhere in the
   tree** (grep `(C C' : Over`, `{C C' : Over` over `Picard/`: zero hits). Only
   `Scheme.CechPic.map` (`Pic.lean:198`) crosses schemes. F-cluster is greenfield plumbing.
2. **`classDeg_map_iso`: zero hits** — the deg-d5b-planned Wave-7 lemma is still to be written.
3. **No pseudofunctor packaging of slice base change in mathlib**: `Pseudofunctor` hits under
   `CategoryTheory/Comma/` = none; under `AlgebraicGeometry/` only `Modules/Sheaf.lean:315`
   (sheaves of modules). The coherence laws must be proved against the concrete
   `pullbackId/pullbackComp` + eqToIso composites the frozen file fixed — no abstract transport
   is available (and none is needed: the statements are already concrete).
4. **No mathlib bridge between `Functor.grpObjObj` (monoidal transport of a group object) and
   `GrpObj.ofRepresentableBy` of an adjunction-transported datum** — nothing in
   `Monoidal/Cartesian/Grp.lean` mentions monoidal functors or adjunctions. The B-6 coherence
   glue is project work.
5. **No Grp-level `uniqueUpToIso`**: `RepresentableBy.uniqueUpToIso` is Type-valued; upgrading
   the iso of representing objects of *group*-valued functors to a `Grp`-iso goes through
   `yonedaGrp`/`Grp.mkIso` by hand (small, but no one-liner exists).
6. **No "morphism of proper curves is constant or finite" dichotomy**, no "proper closed subset
   of an integral curve is finite" at scheme level, in mathlib or the tree (searched
   `Morphisms/`, `Curve/`). ZMT (§2.7) reduces the dominant leg to *finite fibers*; the
   dichotomy itself and the fiber-finiteness are project bricks (F-4).
7. `Functor.RepresentableBy` transport along an adjunction EXISTS (`Adjunction.representableBy`,
   §2.7) — the w5-era question "RepresentableBy transport along functors" is answered
   positively for the adjunction case Wave 7 needs; the iso-of-functors and iso-of-objects
   transports also exist (`ofIso :301`, `ofIsoObj :432`). No absence here.

---

## 3. What each target needs — gap list in dependency order

Legend: **[S]/[M]/[L]** size guess (≤150 lines / one ≤500-line file / multi-file campaign);
**[RISK]** = §5 entry. Everything below is stateable today against a datum family (§3.0);
NOTHING in F-1..F-5, B-1..B-4, A-1 touches the frozen file or the DAT-J gate.

### 3.0 Shared idiom gap

- **G-W7-0 [decision, not code]** — the datum-FAMILY consumption idiom: Wave-7 statements need
  `jacobianData` uniformly in the curve (for `functor`) and in the base field (for
  `baseChangeIso`). Candidate: section variable
  `(dfam : ∀ {k : Type u} [Field k] (X : Curve k), JacobianData X.carrier)` or per-file pairs
  `(d : JacobianData C) (dL : JacobianData ((baseChange k L).obj C))`. Needs an orchestrator
  ruling extending the w4/w5 binding consumption header (EW-4). The frozen `functor`'s fields
  can only be discharged at DAT-J time either way.

### 3.1 Target `functor` — the F-cluster

Dependency chain: F-1 → F-2 → F-3 (transport), F-4 → F-5 (degree), then F-6 (packaging).

- **G-W7-F1 [S/M]** — `relPic` functoriality in the curve: for `g : D ⟶ E` in
  `Over (Spec (.of k))`, `CechPic.map ((g ▷ T).left)` (landed, `Pic.lean:198`) descends to
  `relPic E T →* relPic D T`: classes pulled from the test stay pulled from the test
  (`(g ▷ T) ≫ snd E T = snd D T`, whisker naturality — cheap), `map_id`/`map_comp`.
- **G-W7-F2 [M]** — `PicEtAff` functoriality in the curve: `PicEtAff E A →* PicEtAff D A` over
  the **shared** cover index `EtaleCover A` (§2.3): descent classes map to descent classes
  (cover-wise F-1 commutes with `descentMap`/`relPicAlgMap`), `mk`/`ind`/`mk_eq_mk_iff`
  transport, compatibility with `mapAlg` (test-side). Mirror of the landed `PicEtAffMap`
  test-variable campaign — pattern exists, volume real [RISK R2].
- **G-W7-F3 [S/M]** — `picEt`/`pic0` bundling: the affine-opens limit is componentwise
  (`PicEt.lean` vehicle), so F-2 lifts to `picEtPullback g : picEt E T →* picEt D T` natural in
  `T` (against `picEtMap`); bundle as `picEtFunctor`-level natural transformation.
- **G-W7-F4 [M, WORKSHEET-FIRST] [RISK R1]** — the dichotomy: a morphism `h : D_K ⟶ E_K` of
  proper smooth geometrically irreducible curve bundles over a field `K` is either
  (a) **finite** or (b) factors through a point. Route: image closed (h proper via
  `IsProper.of_comp` `Proper.lean:118`, `h ≫ E.hom = D.hom` by `Over.w`) + irreducible; if
  image = everything: fibers are proper closed subsets of an integral 1-dim scheme ⇒ finite
  (NEW brick: "proper closed subsets of a curve bundle are finite" — adjacents:
  `ChartColength`'s finite-vanishing machinery, `StalksDVR`, `ClosedPoint`), then
  `locallyQuasiFinite_iff_finite_preimage_singleton` + **ZMT**
  `IsFinite.of_isProper_of_locallyQuasiFinite` (`ZariskisMainTheorem.lean:371`). If image =
  one closed point `x`: factor through `Spec κ(x)` (reduced-source factorization — mathlib
  support UNVERIFIED, probe `Scheme.fromSpecResidueField` adjacents), and then the pulled class
  is pulled from the test side, dying in `relPic` (m = 0 leg; note `κ(x)`-point pullback
  factors through `toUnit D ▷ T`, so F-1's picFromBase compat closes it).
- **G-W7-F5 [M/L, WORKSHEET-FIRST, THE HEART] [RISK R1]** — **E-v, degree multiplicativity**:
  for finite `h` as above and every field point, `deg(h^* λ) = n·deg(λ)` with
  `n = [K(D_K) : K(E_K)]`. Chart route (all engines named): Dedekind charts
  (`isDedekindDomain_section :126`), `B_E → B_D` finite (`finite_appTop :157`) and injective
  (dominant + integral), flat (`IsDedekindDomain.flat_iff_torsion_eq_bot :138`), so
  `Module.finrank B_E B_D = n` (generic-rank leg: NEW — constancy of the rank and its
  identification with the function-field degree, via localization at the generic prime);
  per closed point `Σ e·f = n` (`sum_ramification_inertia_eq_finrank :72`); splice into the
  colength dictionary exactly as E-iv-alg's (†) — **the proof template is literally
  `DegreeBaseFieldInvariance.lean`** (single-point reduction along `picClass` generators
  `:462`'s ladder, `ord`↔factor-multiplicity via `toAdd_ordZ_eq_count_factors :278`). Output:
  `classDeg`-level multiplicativity + the `degAt`/`pic0` corollary "pullback preserves
  degree-0" (per-K, no cross-field uniformity needed — the m in `m·0 = 0` may vary).
- **G-W7-F6 [S/M]** — packaging: membership (F-4/F-5) makes F-3 restrict to
  `pic0Pullback g : pic0Functor E ⟶ pic0Functor D` (CommGrp-valued); then
  `functor.map := yonedaGrpFullyFaithful.preimage` of
  `(yonedaGrpObjIsoOfRepresentableBy … d_E.rep).inv ≫ (whisker of pic0Pullback) ≫
  (yonedaGrpObjIsoOfRepresentableBy … d_D.rep).hom` (`Cartesian/Grp.lean:100,126`) — the
  `IsMonHom` obligation is discharged by construction; `map_id`/`map_comp` by `yonedaGrp`
  faithfulness + F-1..F-3 functoriality. Stated against the datum family; discharged at DAT-J.

### 3.2 Target `baseChangeIso` — the B-cluster

Let `σ := Spec.map (CommRingCat.ofHom (algebraMap k L))`, `d : JacobianData C`,
`J_L := (baseChange k L).obj d.J`.

- **G-W7-B1 [S]** — the cross-base pasted square: for `T ∈ Over (Spec L)`,
  `(C_L ⊗_L T).left ≅ (C ⊗_k (Over.map σ).obj T).left` naturally in `T`, via pasting the landed
  squares + `IsPullback.isoIsPullback` (`IsPullback/Defs.lean:166`). The landed
  `Over.isPullback_whiskerLeft_left :76` is the same-base template; the cross-base variant is
  new but small (its affine-test special case is morally `isPullback_baseFieldTransition :109`
  with `K₁ := L`).
- **G-W7-B2 [M]** — the affine comparison: `PicEtAff C A ≃* PicEtAff (C_L) A` for `A` an
  L-algebra (as k-algebra via `restrictScalars`), natural in `A`: `relPic` comparison =
  `CechPic.map` of B-1's iso at `T = overSpec L A` (a `MulEquiv` — iso case, two-sided),
  `picFromBase` + `descentClasses` compat over the **literally shared** `EtaleCover A` index.
  Shares its skeleton with F-2 — the design pass should consider building F-2 curve-variable
  transport in enough generality that B-2 is an instantiation at an iso [candidate, not
  decided].
- **G-W7-B3 [S/M]** — **`classDeg_map_iso`**: `classDeg` is invariant under `CechPic.map` of an
  iso of curve bundles over the same field (deg-d5b §3's named Wave-7 lemma; "lighter sibling
  of E-iv-alg: ord/residueDeg transport along stalk isos, no colength"). Zero hits today.
  Note: if F-5 lands first with `n = 1` for isos, B-3 is its corollary — a sequencing option
  for the design pass.
- **G-W7-B4 [M]** — θ assembly: `θ : pic0TypeFunctor (C_L) ≅ (Over.map σ).op ⋙
  pic0TypeFunctor C` from B-1/B-2 through the affine-opens limit, plus the **field-point
  matching lemma**: k-field-points of `(Over.map σ).obj T` ↔ L-field-points of `T` (the
  composite `Spec K → T.left → Spec L` supplies the L-structure; the ring-level tower
  bookkeeping is the fiddly part [RISK R5]), and degree matching via B-3 (+ E-iv-alg `:462`
  where finite-separable refinement enters through `degAff`).
- **G-W7-B5 [S]** — the transported datum: probe-2's verbatim mathlib chain —
  `(Over.mapPullbackAdj σ).representableBy d.J` (`Adjunction/Basic.lean:326`), then
  `RepresentableBy.ofIso` (`Yoneda.lean:301`) along `d.rep.toIso` whiskered and along θ ⇒
  `pic0TypeFunctor (C_L).RepresentableBy J_L`; certificates `lft`/`qc` by base-change
  stability (the frozen file's own `MorphismProperty.baseChange_obj` pattern `:174-187`).
  Package as `JacobianData (C_L)` with `J := J_L`.
- **G-W7-B6 [M] [RISK R3]** — group-structure coherence + packaging: (a) the `mapGrp` structure
  on `J_L` (`grpObjObj :607`) agrees with `ofRepresentableBy` of B-5's transported rep — a
  finite diagram chase through `Adjunction.homEquiv` naturality + the computable
  `ε/μ_pullback` components (`Cartesian/Over.lean:206,:213-241`); **no mathlib gift** (§2.8
  #4); (b) `uniqueUpToIso (B-5 datum) (jacobianData C_L)` (`JacobianData.lean:134`) +
  `homEquiv_uniqueUpToIso_hom :139` ⇒ the underlying iso intertwines the two group-valued
  `homEquiv`s ⇒ `IsMonHom`, package with `Grp.mkIso` (`Grp.lean:442`, forward-direction η/μ
  only). Output: the frozen `baseChangeIso` term shape.

### 3.3 Coherence laws — the K-cluster (GATED on `functor` via `congr`)

- **G-W7-K1 [M/L, WORKSHEET-FIRST] [RISK R3]** — `baseChangeIso_id` and `baseChangeIso_comp`.
  Reduction discipline (candidate): `Grp.hom_ext :122` + functor-of-points — compare both
  sides through `homEquiv` after composing with arbitrary test morphisms; the equalities then
  follow from (i) θ's own identity/cocycle coherence over towers (the genuinely new content —
  θ_{k,M} vs θ_{k,L} ∘ θ_{L,M} across `Over.pullbackComp`), (ii) `homEquiv_uniqueUpToIso_hom`
  (both sides are "the unique iso intertwining pinned universal elements" — route-decision
  item 21's clause, now backed by the landed lemma), (iii) `mapPullbackAdj` unit/counit
  coherence over composites. The eqToIso cores of the frozen `idIso :213-215` /
  `compIso :221-226` (`Algebra.algebraMap_self`, `IsScalarTower.algebraMap_eq` rewrites) enter
  through `Functor.mapGrpNatIso` — Prop-level but bookkeeping-heavy. E-iv/degree side of the
  cocycle is trivial (equalities of integers).

### 3.4 `baseChange_ofCurve` — the A-gap (gated on Wave-6's `ofCurve` + B-cluster)

- **G-W7-A1 [M]** — reduce by `homEquiv` injectivity to `pic0` classes: LHS = θ-transport of
  `abelElement P` restricted along the base-changed test; RHS = `abelElement` (over L) at
  `ε ≫ σ^*P`. Content: **θ maps the Abel class across the shuffle** — the graph factors
  base-change by `graphLocalEquations_base_change` (`GraphDivisor.lean:263`) +
  `cechPicMap_abelCechClass` (`AbelElement.lean:99`); the `Functor.LaxMonoidal.ε` bookkeeping
  has computable components (`ε_pullback_left`, `Cartesian/Over.lean:206`). With `ofCurve :=
  rep.homEquiv.symm (abelElement P)` pinned (§1.5), this is a naturality computation, not new
  geometry.

Dependency-order summary: F-1/F-2/F-3 and B-1/B-2/B-3 are launchable NOW (no gate at all — not
even the datum structure); F-4/F-5 and B-4 are the two worksheet-first mountains; B-5/B-6 and
F-6 are packaging against the datum family (statement-level now, discharge at DAT-J); K-1 waits
for `functor` + B; A-1 waits for B + W6's pin (already concrete).

---

## 4. Candidate brick decomposition — **CANDIDATE ONLY; cuts and sequencing reserved to the design pass**

House format: name — inputs ⇒ outputs; size class; notes.

**Cluster F (functor; ungated):**
- **W7-F1 `relpic-curve-map`** — `CechPic.map` + whisker naturality ⇒ `relPicCurveMap g :
  relPic E T →* relPic D T` + laws. [S/M]
- **W7-F2 `picetaff-curve-map`** — F1 + descentMap compat over shared covers ⇒
  `PicEtAff.curveMap g : PicEtAff E A →* PicEtAff D A`, natural vs `mapAlg`. [M]
- **W7-F3 `picet-curve-map`** — F2 + the affine-opens limit ⇒ `picEtPullback g` natural in `T`.
  [S/M]
- **W7-F4 `curve-dichotomy`** — proper-image + fiber-finiteness + ZMT ⇒ "constant or finite".
  [M, **WORKSHEET-FIRST**] — probe the reduced-factorization and fiber-finiteness supports
  before speccing.
- **W7-F5 `e-v-multiplicativity`** — F4 + Dedekind charts + `sum_ramification_inertia_eq_finrank`
  + ChartColength ⇒ `classDeg (CechPic.map h L) = n · classDeg L`, corollary: pullback preserves
  `pic0Subgroup`. [M/L, **WORKSHEET-FIRST**, the heart] — model file:
  `DegreeBaseFieldInvariance.lean`.
- **W7-F6 `functor-packaging`** — F3+F5 + `yonedaGrp` FF + datum family ⇒ the three `functor`
  fields as theorems. [S/M, statement-gated on G-W7-0]

**Cluster B (baseChangeIso; ungated except B5/B6's datum phrasing):**
- **W7-B1 `cross-base-square`** — pasted squares + `isoIsPullback` ⇒ the natural iso family. [S]
- **W7-B2 `picetaff-shuffle`** — B1 + shared covers ⇒ `PicEtAff C A ≃* PicEtAff (C_L) A`. [M —
  consider unifying with F2's generality]
- **W7-B3 `classdeg-map-iso`** — ord/residueDeg transport along isos ⇒ `classDeg_map_iso`. [S/M]
- **W7-B4 `theta`** — B1+B2+B3 + field-point matching + E-iv-alg ⇒
  `θ : pic0TypeFunctor (C_L) ≅ (Over.map σ).op ⋙ pic0TypeFunctor C`. [M]
- **W7-B5 `transported-datum`** — probe-2 chain + θ + certificates ⇒ `JacobianData (C_L)` on
  `J_L`. [S]
- **W7-B6 `grp-coherence`** — mapGrp-vs-rep square + `uniqueUpToIso` + `Grp.mkIso` ⇒ the frozen
  `baseChangeIso` shape. [M]

**Cluster K (coherences; gated on F + B):**
- **W7-K1 `theta-cocycle` + `coherence-assembly`** — θ id/cocycle + `homEquiv_uniqueUpToIso_hom`
  + adjunction tower coherence ⇒ `baseChangeIso_id`, `baseChangeIso_comp`. [M/L,
  **WORKSHEET-FIRST**]

**Cluster A (gated on B + W6):**
- **W7-A1 `abel-compat`** — θ vs `abelElement` (graph base-change landed) ⇒
  `baseChange_ofCurve`. [M]

Sequencing suggestion (non-binding): F1/B1/B3 immediately (pure plumbing on landed API, zero
gates); F4/F5 worksheet next (the long pole — start EARLY, §5 EW-1); F2/B2 as one
generality decision; θ (B4) after B1-B3; B5/B6 and F6 once G-W7-0 is ruled; K1 last, after
`functor`.

---

## 5. Honest risks + the early-warning list

### Early warnings for the orchestrator (things Wave 7 needs that Waves 4–6 are NOT producing)

- **EW-1 — E-v (W7-F4/F5) is genuinely new degree mathematics with no owner.** Nothing in the
  tree compares degrees across two curves; route-decision item 19's tag never budgeted it. The
  deep algebra is mathlib-gifted (ZMT `:371`, `sum_ramification_inertia_eq_finrank :72`,
  Dedekind flatness `:138`) and the assembly template exists (E-iv-alg), but the dichotomy,
  fiber-finiteness, constant-leg factorization, and generic-rank legs are unowned project
  bricks. It is UNGATED — it can and should start before Wave 5/6 finish.
- **EW-2 — the curve-variable picEt transport (W7-F1..F3) is a real plumbing campaign** through
  the plus construction that no other wave touches; volume comparable to the landed
  test-variable `PicEtAffMap` campaign. Also ungated.
- **EW-3 — `classDeg_map_iso` (W7-B3)** was explicitly deferred to Wave 7 by deg-d5b §3/§5 and
  is still absent; it must appear in the Wave-7 plan or θ has no degree leg.
- **EW-4 — the datum-family consumption idiom (G-W7-0)** is not covered by any binding header:
  `functor` needs data at every curve, `baseChangeIso` at two base fields. Needs a small
  binding ruling + confirmation that DAT-J's producer stays base-field-generic (its signatures
  are; watch for `k`-specific shortcuts creeping into the producer).
- **EW-5 — `functor` GATES both coherence laws** (`congr := functor.mapIso`, frozen `:233-240`)
  — a sequencing constraint invisible in the wave numbering: `baseChangeIso` itself can land
  before `functor`, but `baseChangeIso_id/_comp` cannot.
- **EW-6 — the mapGrp-vs-representable group coherence (W7-B6(a)) has no mathlib gift** (§2.8
  #4) and sits on `baseChangeIso`'s critical path. Small but must be planned, not discovered.
- **De-risked this session (NOT warnings):** the frozen-vs-degree-lane spelling seam is `rfl`
  (probe 1); the adjunction transport is verbatim mathlib (probe 2); X3's `genus_baseField`
  consumes at the frozen spelling (probe 3); Milne II.5-style semicontinuity is nowhere needed
  by Wave 7 (the whole wave is functor-of-points + degree bookkeeping — the W5 descope boundary
  is not approached).

### Risks (ranked)

- **R1 — E-v balloon (W7-F4/F5).** Three probe-unresolved legs: (i) the constant-leg
  factorization through `Spec κ(x)` (mathlib support unverified); (ii) fiber-finiteness =
  "proper closed subsets of an integral curve bundle are finite" (no landed statement; the
  ChartColength vanishing machinery is adjacent, not identical); (iii) generic-rank constancy
  `finrank B_E B_D = [K(D):K(E)]` uniform across chart pairs. Each has the (C2)/deg-W3
  precedent shape: a step the paper reads as one breath. Worksheet-first; budget a
  campaign-scale fallback.
- **R2 — plus-transport bookkeeping volume (F2/B2).** Three layers × (`mk`/`ind`/setoid/
  `descentMap_congr`) with the K-explicit RiemannRoch conventions on one side and the
  Challenge-file spellings on the other. Bounded by the landed patterns (`PicEtAffMap`,
  `EffectivityClose`'s `AlgHom.ext fun _ => rfl` idiom) but big; opaque defs + named simp
  lemmas, never unfold covers.
- **R3 — coherence eqToIso friction (K1, B6).** The frozen `idIso`/`compIso` are
  eqToIso-composites over `Spec.map`/`algebraMap` rewrites, and `Grp`-valued equalities of isos
  multiply the layers (`.hom.hom.hom`). Mitigation pinned by the evidence: reduce EVERYTHING
  through `Grp.hom_ext` + `homEquiv` to element-level equalities in `pic0Subgroup` FIRST; never
  diagram-chase in `Grp (Over …)` directly.
- **R4 — instance keying at the frozen spelling.** Probe 1 gives defeq, but the landed
  degree/X3 instances are keyed on `(C ⊗ overSpec k K).left`; consumers at
  `((baseChange k L).obj C).left` will need ascribed `letI`s (the JacobianData η-defeq caveat
  pattern, `JacobianData.lean:41-55`). Own the keying once, in one Wave-7 seam file — not in
  every consumer.
- **R5 — the field-point matching quantifier trap (B4).** `pic0Subgroup C T` quantifies over
  `K : Type u` fields **over k**; `pic0Subgroup (C_L) T` over fields **over L**. The bijection
  needs the `Spec`-affine correspondence (scheme point ⇒ ring map ⇒ `[Algebra L K]` +
  `IsScalarTower k L K`) in both directions with `degAt` matching — honest lemmas, easy to get
  subtly wrong (universe-fixed `Type u` on both sides makes it *possible*; the tower coherence
  makes it *fiddly*). Also note the L-side quantifier is over `Algebra L K` for the SAME
  universe-u field types — no smallness issue, verified against `pic0Subgroup :107-109`.
- **R6 — statement-audit debt on `functor.map`'s value.** The challenge pins only the TYPE of
  `map`; the docstring pins "pullback of line bundles". Any construction (yonedaGrp-preimage of
  the pic0 pullback) satisfying the laws discharges the sorry — but `congr`, the coherences,
  and `baseChange_ofCurve` all consume the *value*, so the design pass must pin ONE
  construction and audit that the coherence statements are provable against it before any lane
  proves anything (the "one pinned universal element" rule, route-decision §5.4).

---

## 6. Sources (READ/UNREAD, honest)

- **Milne, Abelian Varieties (slug `abelian-varieties`)**: transcribed pages = 14-15 (I §1
  rigidity) and 107-110 (III §§5-6) per the manifest. **READ this session: `page-0110.tex`**
  (III §6): Prop 6.1 (Albanese universal property), Cor 6.2, **Cor 6.3 — `Hom(J₁,J₂)` ↔
  divisorial correspondences between pointed curves**. Verdict for Wave 7: Milne's own
  functoriality treatment is **pointed** (needs rational points `P₁, P₂`) and runs through the
  Albanese property — it does NOT model the challenge's point-free contravariant `functor`;
  the honest route is direct Picard pullback (E-v), for which Milne III §6 is context, not a
  proof source. The rest of Milne III (§§1-4, 7+) is UNTRANSCRIBED; any blueprint node citing
  it queues a page-transcriber task.
- **Kleiman, The Picard Scheme (slug `kleiman-picard`, full tex in-workspace)**: grepped this
  session for functoriality — the "functorial" hits (tex 2000, 5166, 5208) are all
  test-variable; flat-base-change remarks at tex 2194-2292. **No dedicated
  Jacobian-functoriality or curve-variable section found by grep; not read end-to-end this
  session** — the design pass should not expect a Kleiman anchor for E-v.
- **E-v's classical source** (degree of pullback along a finite morphism of curves,
  `deg f^*D = deg f · deg D`): standard function-field theory — Hartshorne (in-workspace,
  slug `hartshorne-algebraic-geometry`, **UNREAD for this purpose**; the relevant statement is
  in II.6/IV — verify and transcribe before blueprinting) or the Stacks divisors chapter. No
  new fetch needed; a page-transcriber task will be.
- **Mumford II.5**: not needed by Wave 7 (no semicontinuity/Exchange anywhere in §3).

---

*End of recon. §0 headline in one line: `baseChangeIso`'s mechanism is landed-plus-mathlib
(three probes green) and its remaining math is θ + `classDeg_map_iso`; `functor` hides the
wave's real mountain (E-v + the curve-variable picEt transport), which nobody upstream is
building and which is ungated TODAY; the coherence laws gate on `functor`; §4 cuts are
candidates only — the design pass decides.*
