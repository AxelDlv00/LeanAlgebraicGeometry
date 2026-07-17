# K-1 worksheet — the θ-cocycle coherence (`AJCR.w7-functor.k1`)

**DRAFT — PENDING ORCHESTRATOR RATIFICATION.** Decisions-first, machine-probed. This is
the worksheet the ratified `w7-worksheet.md` §D3/§3 mandates before any K-cluster code
lane launches; it also discharges the R-W7-6 provability audit named there (the "one
pinned universal element" rule for `baseChangeIso_id`/`_comp`/`baseChange_ofCurve`
against the F-6 construction). It pins the **datum-level θ-cocycle** — NOT the frozen
`baseChangeIso_id`/`_comp` closures, which run LAST (after DAT-J + F-6).

*Design-probe lane w7-k1-worksheet, 2026-07-17 (relaunched; runs on Opus 4.8). Evidence
base, read in full this session: the ratified `w7-worksheet.md` (D3's K-1 paragraph, D4,
R-W7-3/6; §3 file map), `w7-recon.md` §3.3/§3.4, the house model `w7-ev-worksheet.md`.
Landed Lean interfaces re-read at source: `Picard/Pic0ThetaAssembly.lean` (θ, B-4b,
`3a1c9f1f4`), `Picard/PicEtCrossBase.lean` (the shuffle lift, `25e797e2c`),
`Picard/Pic0Pullback.lean` + `Picard/Pic0PullbackGrp.lean` (F-6, `2a925515f`+`11ab343be`),
`Picard/JacobianData.lean` (the datum interface), `Picard/JacobianDataBaseChange.lean`
(B-5 only, committed `2671178e1` — B-6a/B-6b uncommitted at writing, see §3),
`Picard/AbelElement.lean` (A-1 input), `Challenge.lean` (the frozen targets). Inbox
I-0212 (F-6's DAT-J recipe + the pinned universal element), I-0216 (θ consumer notes for
K-1 + the R4/R5 elaboration lessons), I-0206. **Five machine-checked probes** were run
via `lean_run_code` against the live tree (§6); no production file created or modified, no
build, no mutex.*

---

## §0 Verdict in one line

The K-1 θ-cocycle is **two fully-probed `CommGrpCat`-natiso equalities** at the landed
`pic0Theta` spelling — `pic0Theta k k C = cocycleIdRHS` (identity) and
`pic0Theta k M C = cocycleRHS` (cocycle) — whose right-hand sides assemble from three
already-landed ingredients (**iso-grade curve transport** `pic0PullbackNat` at
`baseChange.idIso`/`compIso`, the **σ-side `Over.mapComp`/`mapId` reassociation** mirroring
the frozen vehicles, and **θ itself**); both equations **elaborate end-to-end with zero
errors this session** (probes K-c, K-d). The genuinely new content is one section-ring
identity — the base-field shuffle is a **cocycle over the tower** `k→L→M` — reduced to by
the `rfl`-grade component anchors (`pic0Theta_hom_app`, `pic0Pullback_coe`,
`picEtCrossBase_val`); everything else is `Iso.ext`/`Subtype.ext` bookkeeping. **A-1
rides this worksheet** as a spec (statement probed modulo B-6b's not-yet-committed
`baseChangeIsoOfData`). No E-v, no Grp(Over) diagram chase, no foreign-fleet gate beyond
B-56's B-6b landing.

---

## §1 The pinned Lean statements (all elaboration-probed, §6)

**Value category (D2-i, ratified).** θ is `CommGrpCat`-valued and lands as
`pic0Theta k L C : pic0Functor ((baseChange k L).obj C) ≅ (Over.map σ_{kL}).op ⋙ pic0Functor C`
with `σ_{kL} := Spec.map (CommRingCat.ofHom (algebraMap k L))`
(`Pic0ThetaAssembly.lean:203`). Its `hom`/`inv` components are the degree-zero subgroup
comparison `pic0CrossBaseEquiv` **by `rfl`** (`pic0Theta_hom_app` :217,
`pic0Theta_inv_app` :226, both `@[simp] rfl`), whose underlying class transport is
`picEtCrossBaseInv`/`picEtCrossBase` **by `rfl`** (`pic0CrossBaseEquiv_apply_coe` :172,
`_symm_apply_coe` :182). These four `rfl` anchors are the reduction spine of every route
below.

**The K-1 mandate names two equalities.** Both are equalities of isomorphisms in the
functor category `(Over (Spec (.of M)))ᵒᵖ ⥤ CommGrpCat` (resp. over `Spec k`) — "no
Grp(Over) objects in sight", exactly as D3 demands. Both RHSs are pinned against the
**frozen vehicles** `baseChange.idIso`/`baseChange.compIso` (`Challenge.lean:211,218`) so
the θ-cocycle plugs into `baseChangeIso_id`/`_comp` without a second bookkeeping pass
(the R-W7-6 alignment, §5-R6).

### 1.1 K-1a — the θ identity coherence (θ over `Over.pullbackId`), probe K-d green

Setting: `k : Type u [Field k]`, `C : Over (Spec (.of k))` with the standing pack.

```lean
-- the iso-grade curve transport at the identity base change (pic0PullbackNat of idIso)
noncomputable def eCurveId : pic0Functor ((baseChange k k).obj C) ≅ pic0Functor C where
  hom := pic0PullbackNat ((baseChange.idIso k).app C).inv
  inv := pic0PullbackNat ((baseChange.idIso k).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

-- the σ-side collapse: σ_{kk} = 𝟙, via Over.mapId
noncomputable def mIdσ :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k))) ≅ 𝟭 (Over (Spec (.of k))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 _ by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]]) ≪≫ Over.mapId _

noncomputable def σkkCollapse :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C
      ≅ pic0Functor C :=
  Functor.isoWhiskerRight (NatIso.op (mIdσ k)).symm (pic0Functor C)
    ≪≫ Functor.leftUnitor (pic0Functor C)

noncomputable def cocycleIdRHS :
    pic0Functor ((baseChange k k).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C :=
  eCurveId k C ≪≫ (σkkCollapse k C).symm

-- THE pinned K-1a statement
theorem pic0Theta_id : pic0Theta k k C = cocycleIdRHS k C := …
```

*Content:* θ at `k → k` is the trivial comparison — the base-changed curve collapses to
`C` (via `baseChange.idIso`, i.e. `Over.pullbackId` under the `algebraMap k k = id`
rewrite) and the pushed test collapses to the test (`σ_{kk} = 𝟙`, `Over.mapId`). Probe
K-d confirms `pic0Theta k k C = cocycleIdRHS k C : Prop` elaborates with **zero errors**.

### 1.2 K-1b — the θ cocycle coherence (θ over `Over.pullbackComp`), probe K-c green

Setting: `k L M : Type u` fields, `[Algebra k L] [Algebra L M] [Algebra k M]
[IsScalarTower k L M]`, `C : Over (Spec (.of k))` with the pack. Write
`C_L := (baseChange k L).obj C`, `σ_{XY} := Spec.map (CommRingCat.ofHom (algebraMap X Y))`.

```lean
-- iso-grade curve transport at the tower composite (pic0PullbackNat of compIso)
noncomputable def eCurve :
    pic0Functor ((baseChange k M).obj C)
      ≅ pic0Functor ((baseChange k L ⋙ baseChange L M).obj C) where
  hom := pic0PullbackNat ((baseChange.compIso k L M).app C).inv
  inv := pic0PullbackNat ((baseChange.compIso k L M).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

-- σ-side reassociation: the Over.mapComp mirror of baseChange.compIso, on σ_{kM}
noncomputable def σMapCompIso :
    Over.map σ_{kM} ≅ Over.map σ_{LM} ⋙ Over.map σ_{kL} :=
  eqToIso (by rw [show σ_{kM} = σ_{LM} ≫ σ_{kL} by
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, ← IsScalarTower.algebraMap_eq]]) ≪≫
    Over.mapComp _ _

-- op-side bridge: (σ_{LM}).op ⋙ (σ_{kL}).op = (σ_{LM} ⋙ σ_{kL}).op is DEFEQ (eqToIso rfl)
noncomputable def αOp :
    (Over.map σ_{LM}).op ⋙ (Over.map σ_{kL}).op ≅ (Over.map σ_{kM}).op :=
  eqToIso rfl ≪≫ (NatIso.op (σMapCompIso k L M))

noncomputable def cocycleRHS :
    pic0Functor ((baseChange k M).obj C) ≅ (Over.map σ_{kM}).op ⋙ pic0Functor C :=
  eCurve k L M C
    ≪≫ pic0Theta L M ((baseChange k L).obj C)
    ≪≫ Functor.isoWhiskerLeft (Over.map σ_{LM}).op (pic0Theta k L C)
    ≪≫ (Functor.associator _ _ _).symm
    ≪≫ Functor.isoWhiskerRight (αOp k L M) (pic0Functor C)

-- THE pinned K-1b statement
theorem pic0Theta_comp : pic0Theta k M C = cocycleRHS k L M C := …
```

*Content:* `θ_{k,M} = θ_{k,L} ∘ θ_{L,M}` read across `Over.pullbackComp`. The RHS reads:
transport the source `pic0Functor C_M` to `pic0Functor C_{L,M}` (the curve compIso, an
**iso** — hence F-3-grade `pic0PullbackNat`, never E-v), apply `θ_{L,M}`, whisker
`θ_{k,L}` through `(Over.map σ_{LM}).op`, then reassociate the two σ-pushes into the single
`σ_{kM}`-push (the `Over.mapComp` mirror of the frozen `compIso`, on the covariant `Over.map`
side). Probe K-c confirms `pic0Theta k M C = cocycleRHS k L M C : Prop` elaborates with
**zero errors** — including the `eqToIso rfl` in `αOp`, so `(F).op ⋙ (G).op = (F ⋙ G).op`
is definitional (one less friction point than R-W7-3 feared).

### 1.3 Design ruling to ratify — bundled statement, component proof

**RECOMMEND: pin the two headline equalities in bundled `CommGrpCat`-natiso form (§1.1,
§1.2, both probed green) as the K-1 deliverables**, and prove each by reduction to
element-level equalities (Leg 1–4, §2) — never a `Grp (Over …)` diagram chase (R-W7-3).
The auxiliary isos `eCurve`/`eCurveId`, `σMapCompIso`/`mIdσ`, `αOp` are pinned as named
defs in the K-1 file. Stating the RHSs through `baseChange.idIso`/`compIso` (not ad-hoc
`Over.pullback` isos) is deliberate: it is the exact shape the frozen
`baseChangeIso_id`/`_comp` consume (§5-R6).

**Datum idiom (D1).** The θ-cocycle is stated on the **curve `C` alone**, no `JacobianData`
argument — θ is a functor comparison, the datum enters only at DAT-J. This respects D1's
"no data at unnamed curves". (Contrast A-1, §3, which does take data.)

---

## §2 Route pins — leg-by-leg, with `file:line` evidence and size grades

Both headline equalities reduce the same way. Discipline (R-W7-3, ratified): reduce the
natiso equality to per-test-object components **before** touching any group structure, via
`NatTrans.ext`/`Iso.ext`; unfold θ through its `rfl` anchors; land in `pic0Subgroup`;
`Subtype.ext` to underlying `picEt` classes; then the content is a `picEt`/section-ring
identity. All seam-crossing steps **term-mode** (`congrArg`/`Eq.trans`), never `rw` across
a pushed-test spelling (I-0216 elaboration notes 1–4; I-0206 lesson).

| Leg | What it closes | Landed anchors (`file:line`) | Size |
|---|---|---|---|
| **Leg 1 — bundle→components** | reduce `pic0Theta … = …RHS` to per-`T` component equalities of the `hom` maps (`inv` is free by `Iso.ext` one-sidedness) | `pic0Theta` is `NatIso.ofComponents` (`Pic0ThetaAssembly.lean:203-211`); components `pic0Theta_hom_app` :217 (`rfl`); `NatTrans.ext`/`CommGrpCat` `hom_ext` | **S** |
| **Leg 2 — curve-side transport** | `eCurve`/`eCurveId` `hom` = `pic0PullbackNat` of the (id/comp)Iso; its component on classes is `pic0Pullback` = `picEtPullback` | `pic0PullbackNat_app` (`Pic0Pullback.lean:217`, `@[simp]`), `pic0Pullback_coe` :175 (`@[simp] rfl`); functoriality `pic0PullbackNat_id` :224 / `_comp` :231 (used already in `eCurve`) | **S** |
| **Leg 3 — σ-side reassoc** | `σMapCompIso`/`mIdσ` + `αOp` + `NatIso.op` + `associator`/`leftUnitor` components reduce to `picEtMap` of the mediating **test** iso; the `Over.mapComp`/`mapId` component spellings | mathlib `Over.mapComp`/`Over.mapId`; `Over.pullbackComp`/`pullbackId` are the frozen `compIso`/`idIso` cores (`Challenge.lean:215,226`); `picEtMap_picEtCrossBase(Inv)` (`PicEtCrossBase.lean:352,371`) for moving classes across the pushed test | **S/M** (R4/R5 spelling friction) |
| **Leg 4 — the cocycle atom** ⭐ | the genuinely new content: the base-field shuffle is a **cocycle over the tower** — `picEtCrossBase`/`Inv` for `k→M` = the two-step `k→L` then `L→M`, i.e. `sectionShuffle` composes: `sectionShuffle k M ≈ sectionShuffle L M ∘ sectionShuffle k L` at each affine section ring, the `restrictScalars` tower identity | `sectionShuffle` (`PicEtCrossBase.lean:142`), `Over.isScalarTower_sections_map` :119, `mapAlg_sectionShuffle` :174, `appLE_sectionShuffle` :242; `picEtCrossBase_val` :288 (`rfl`); reuse per I-0216: the two-family + `picEtAffHom_picEtAffHom` collapse (`PicEtAffTransport.lean:266`) via `picEtCrossBaseEquiv` :316 | **M** |

**Leg 4 is the whole mathematical cost.** It is a `restrictScalars`-tower identity on the
section-ring shuffle `sectionShuffle` — the componentwise atom of `picEtCrossBase`. I-0216
records the reuse path explicitly: *"composed shuffles at towers `k → L → M` are legal …
I-0208's two-family + `picEtAffHom_picEtAffHom` pattern reusable at the picEt level via
`picEtCrossBaseEquiv`"*. The degree layer needed for any degree bookkeeping in the cocycle
is `degAff_baseFieldShuffle` (`Pic0ThetaAssembly.lean:67`) and
`degAt_pushFieldPoint_picEtCrossBase` :98 — both already stated for **arbitrary**
`[Field L] [Algebra k L]`, no finiteness/separability, so the tower instantiation is legal
(the θ file's own closing note, `:43-45`).

**Legality of the tower (probe K-a).** All three thetas `pic0Theta k L C`,
`pic0Theta L M C_L`, `pic0Theta k M C` and the iso-grade transports
`pic0PullbackNat ((baseChange.compIso k L M).app C).hom/.inv` typecheck simultaneously
(§6). The B-5 datum `JacobianData.baseChange` (`JacobianDataBaseChange.lean:48`,
committed `2671178e1`) provides the datum at `C_L` when DAT-J needs it.

**Hardest sub-step:** Leg 3's pushed-test spelling hygiene — `Γ(T.left,U)` vs
`Γ(((Over.map σ).obj T).left,U)` are defeq only at default transparency; every `letI` for
the pushed structure must be type-ascribed at the `T.left` spelling
(`Over.isScalarTower_sections_map`, :119), and seam crossings must be term-mode or
`rw`/`kabstract` dies with "target not type-correct under instances transparency" (I-0216
notes 1–2, from the θ author who paid exactly this). **Bail (recorded):** if Leg 3's
functor-category associativity/`op` bookkeeping balloons, prove the equalities in the
**reversed `.symm`/inv orientation** the frozen `baseChangeIso` actually consumes (I-0216:
"you want its `.symm` face"), which shortens the mediating-iso chain; a prover reorientation,
reported not suffered.

---

## §3 The A-1 spec rider — `baseChange_ofCurve` at the datum level

**Decision: RIDE A-1 in this worksheet** (statement + route + size), **gated on B-56's
B-6b `baseChangeIsoOfData`** (not committed at writing — only B-5 landed, `2671178e1`;
B-6a/B-6b in flight, §5-R7). Rationale: A-1 is a naturality computation, not new geometry
(recon §3.4), and shares the θ / `homEquiv` / graph substrate with K-1, so co-locating the
spec is efficient; but the *code* lane cannot start until B-6b lands. (Alternative offered:
split into its own [S] spec note — declined as redundant with this section unless the
orchestrator wants A-1 tracked separately.)

**Pinned statement (datum level, against the B-6b spec `baseChangeIsoOfData`,
w7-worksheet §1.2 B-6b row).** With `d : JacobianData C`,
`dL : JacobianData ((baseChange k L).obj C)`, `P : 𝟙_ ⟶ C`:

```lean
theorem baseChange_ofCurve_data (d : JacobianData C)
    (dL : JacobianData ((baseChange k L).obj C)) (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    (baseChange k L).map (d.homEquiv.symm (abelElement C P))
        ≫ (baseChangeIsoOfData d dL).hom.hom.hom
      = dL.homEquiv.symm
          (abelElement _ (Functor.LaxMonoidal.ε (baseChange k L) ≫ (baseChange k L).map P)) := …
```

The frozen `ofCurve P = rep.homEquiv.symm (abelElement P)` (AbelElement docstring `:123`,
`Challenge.lean:125`); `baseChangeIsoOfData` (B-6b) is the datum-level shape of the frozen
`baseChangeIso` (`Challenge.lean:244`, `.hom.hom.hom : (baseChange k L).obj d.J ⟶ dL.J`).
At DAT-J the frozen `baseChange_ofCurve` (`Challenge.lean:278`) instantiates this at
`d := jacobianData C`, `dL := jacobianData C_L`.

**Probe A (§6, green):** the RHS point `ε ≫ (baseChange k L).map P : 𝟙_ (Over (Spec L)) ⟶ C_L`,
its `abelElement`, `dL.homEquiv.symm` of it, and the LHS
`(baseChange k L).map (d.homEquiv.symm (abelElement C P))` all typecheck. Only the middle
`≫ (baseChangeIsoOfData d dL).hom.hom.hom` awaits B-6b.

**Route.** Reduce by `dL.homEquiv` injectivity (both sides land in `dL.J`; apply
`dL.homEquiv` and use its naturality) to a `pic0Subgroup C_L C_L` equality; the content is
**θ carries the Abel class across the shuffle**. Anchors: `abelElement_map` /
`abelPicEt_map` (`AbelElement.lean:149,140`, the functor-point graph formula),
`cechPicMap_abelCechClass` :99, `graphLocalEquations_base_change` (`GraphDivisor.lean:263`,
per recon §3.4), and the pinned universal element `homEquiv_comp_pullbackHom`
(`Pic0PullbackGrp.lean:178`) for the `map`-side; the `Functor.LaxMonoidal.ε` components are
computable (`ε_pullback_left`, `Cartesian/Over.lean:206`, recon §3.4). **Size: M.** **Gate:**
B-6b `baseChangeIsoOfData` committed; then A-1 shares the K-1 file's imports.

---

## §4 File map (checked free this session; outside every running/foreign lane)

- **`Picard/Pic0ThetaCocycle.lean`** (K-1a + K-1b): the two headline θ-cocycle equalities
  and their auxiliary isos (`eCurve`/`eCurveId`, `σMapCompIso`/`mIdσ`, `αOp`,
  `cocycleRHS`/`cocycleIdRHS`). Imports `Picard/Pic0ThetaAssembly` (θ) and
  `Picard/Pic0Pullback` (`pic0PullbackNat`) — both transitively import `Challenge`
  (via `Curve/CrossBaseSquare`), so `baseChange.idIso`/`compIso`, `Over.pullbackComp`/
  `pullbackId`, `Over.mapComp`/`mapId` are all in scope (verified: the probes import
  exactly this and compile).
- **`Picard/JacobianDataBaseChangeAbel.lean`** (A-1, if riding): imports
  `Picard/JacobianDataBaseChange` (for `baseChangeIsoOfData`, once B-6b lands) +
  `Picard/AbelElement`. **Kept separate from** `Picard/JacobianDataBaseChange.lean`
  (B-56's file, do not touch).

**Collision check (this session):** `Pic0ThetaCocycle.lean`,
`JacobianDataBaseChangeAbel.lean` are **free**. Occupied and NOT to be reused:
`Pic0Theta.lean` (B-4a), `Pic0ThetaAssembly.lean` (B-4b), `PicEtCrossBase.lean` (B-4b),
`Pic0Pullback.lean`/`Pic0PullbackGrp.lean` (F-6), `JacobianDataBaseChange.lean` (B-56,
RUNNING), `Curve/CrossBaseSquare.lean` (B-1). Root wiring (`AlgebraicJacobian.lean`):
add only the K-1 (and A-1) import line, per protocol §4 (HEAD-blob + own line).

Lane protocol on execution: `protocol-concurrent-lanes.md` verbatim (private-index+CAS
commits, mkdir lake mutex, ≤500-line files, `lean_verify` keystones, zero sorries,
LSP-first). Blueprint debt: each brick's acceptance includes its blueprint node.

---

## §5 Risk register + ratification points

**Risks.**

- **R-K1-1 (was R-W7-3) — eqToIso/`.hom.hom.hom` friction — DOWNGRADED to [S/M].** The
  recon feared the frozen `idIso`/`compIso` eqToIso cores would fight. Findings this
  session: (a) both headline equalities elaborate green with the eqToIso cores riding
  inside `eCurve`/`σMapCompIso`/`mIdσ` (probes K-c/K-d); (b) `αOp`'s `eqToIso rfl` proves
  `(F).op ⋙ (G).op = (F ⋙ G).op` is definitional — no `op`-of-composite lemma needed;
  (c) the R3 discipline (reduce to components via the `rfl` anchors before any group
  structure) is confirmed available (Leg 1–2 all `rfl`/`@[simp]`). Residual friction is
  Leg 3's pushed-test spelling hygiene (R4/R5 flavor), bounded by I-0216 notes 1–4.
- **R-K1-2 — Leg 4 tower atom is the real cost [M].** No mathlib gift; it is the
  `restrictScalars`-tower identity on `sectionShuffle`. Mitigation: reuse I-0208's
  two-family + `picEtAffHom_picEtAffHom` collapse via `picEtCrossBaseEquiv` (I-0216).
  Bail: the `.symm`/inv reorientation (§2).
- **R-K1-3 — A-1 gated on B-56's B-6b (uncommitted at writing).** Only B-5
  (`JacobianData.baseChange`, `2671178e1`) is in HEAD; `baseChangeIsoOfData` (B-6b) and the
  `GrpObj.ext` coherence (B-6a) are in flight. **The A-1 statement (§3) is pinned against
  the w7-worksheet §1.2 B-6b spec, not a committed interface** — if B-6b's landed signature
  of `baseChangeIsoOfData` differs from `(baseChange k L).mapGrp.obj (.mk d.J) ≅ .mk dL.J`
  (e.g. argument order, or a `d.baseChange L`-specialized form), A-1's statement must be
  re-pinned at K-1 ratification-check time. The K-1a/K-1b θ-cocycle statements have **no
  such dependency** (θ + `pic0PullbackNat` + mathlib only — all committed).
- **R-K1-4 — spurious staged deletions in the shared index.** `git status` shows
  `JacobianDataBaseChange.lean` as `D` + `??` (B-56's file, staged-deleted then untracked)
  — cosmetic, per protocol §1; NOT to be "fixed". Commit via private index (§ commit).
- **R-K1-5 — cross-fleet (Fleet A DAT-G).** θ is one-sided (no Γ, no invariants); the
  K-1 cocycle must NOT grow Galois content. No touchpoint beyond the shared `Picard/` file
  space (declared in §4).

**R-W7-6 provability audit (the mandated K-1-worksheet acceptance criterion).** The
"one pinned universal element" rule holds against the F-6 construction: `functor.map` is
`JacobianData.pullbackHom` (`Pic0PullbackGrp.lean:77`), whose value on functor points is
pinned by `homEquiv_comp_pullbackHom` :178
(`dX.homEquiv (f ≫ (pullbackHom dX dY g).hom.hom) = pic0Pullback g T (dY.homEquiv f)`) and
`comp_pullbackHom` :165. The frozen `baseChangeIso_id`/`_comp` (`Challenge.lean:253,262`)
apply `congr = (functor).mapIso` at **isos** (`compIso`/`idIso`.app) — so they consume
`functor.map` only through this pinned universal element, and the K-1a/K-1b θ-cocycle is
exactly the datum-level fact that makes the two frozen closures' `homEquiv`-reductions
agree (both closures reduce, by `Grp.hom_ext` + functor-of-points, to θ's identity/cocycle
over `pullbackId`/`pullbackComp` — recon §3.3, now the pinned §1.1/§1.2). **Audit verdict:
the frozen closures are provable from {K-1a, K-1b, F-6's `homEquiv_comp_pullbackHom`,
B-6b's `baseChangeIsoOfData`}** — no additional universal element needed. `baseChange_ofCurve`
(A-1) consumes the same pinned element plus the Abel functor-point formula (§3).

**Ratification points (orchestrator).**

1. **§1.3 statement form:** pin the two θ-cocycle equalities in bundled `CommGrpCat`-natiso
   form (both probed green), RHSs through the frozen `baseChange.idIso`/`compIso` vehicles;
   prove by component reduction (Leg 1–4), never a Grp(Over) chase.
2. **§2 route + sizes:** Leg 1–3 [S]/[S]/[S-M], Leg 4 [M] (the tower atom); the `.symm`/inv
   reorientation bail.
3. **§3 A-1:** RIDE (vs split); the statement pin gated on B-6b, re-check at K-1 ratify.
4. **§4 file map:** `Picard/Pic0ThetaCocycle.lean` (K-1), `Picard/JacobianDataBaseChangeAbel.lean`
   (A-1) — declared to Fleet A by inbox on ratification.
5. **§5 R-W7-6 audit verdict** accepted (the frozen closures provable from the pinned set).

---

## §6 Machine-checked probes (this session, `lean_run_code`, live tree; all green)

- **Probe K-a (tower legality):** the three thetas `pic0Theta k L C`,
  `pic0Theta L M ((baseChange k L).obj C)`, `pic0Theta k M C`,
  `(baseChange.compIso k L M).app C`, and
  `pic0PullbackNat ((baseChange.compIso k L M).app C).hom :
  pic0Functor C_{L,M} ⟶ pic0Functor C_M` — all `#check` clean.
- **Probe K-b (identity vehicles):** `pic0Theta k k C`, `(baseChange.idIso k).app C :
  (baseChange k k).obj C ≅ (𝟭 _).obj C`, `pic0PullbackNat ((baseChange.idIso k).app C).hom`
  — clean.
- **Probe K-c (K-1b headline):** the full `cocycleRHS` assembly (`eCurve` ≪≫ `θ_{L,M}` ≪≫
  `isoWhiskerLeft θ_{k,L}` ≪≫ `associator.symm` ≪≫ `isoWhiskerRight αOp`) and
  **`pic0Theta k M C = cocycleRHS k L M C : Prop`** — elaborates with **zero errors**
  (incl. `αOp`'s `eqToIso rfl`, so `(F).op ⋙ (G).op = (F ⋙ G).op` is definitional).
- **Probe K-d (K-1a headline):** the full `cocycleIdRHS` assembly (`eCurveId` ≪≫
  `σkkCollapse.symm`, with `mIdσ` via `Over.mapId` and `σ_{kk} = 𝟙`) and
  **`pic0Theta k k C = cocycleIdRHS k C : Prop`** — **zero errors**.
- **Probe A (A-1 shape):** `ε ≫ (baseChange k L).map P : 𝟙_ (Over (Spec L)) ⟶ C_L`,
  `abelElement _ (…)`, `dL.homEquiv.symm (abelElement …)`, and
  `(baseChange k L).map (d.homEquiv.symm (abelElement C P))` all typecheck (only the middle
  `≫ baseChangeIsoOfData` awaits B-6b).

*(The rfl-grade component anchors `pic0Theta_hom_app` :217, `pic0CrossBaseEquiv_apply_coe`
:172, `pic0Pullback_coe` :175, `picEtCrossBase_val` :288, and F-6's
`homEquiv_comp_pullbackHom` :178 are relied on from source, not re-run.)*

---

*End of DRAFT. One-line summary: the K-1 θ-cocycle is two bundled `CommGrpCat`-natiso
equalities — `pic0Theta k k C = cocycleIdRHS`, `pic0Theta k M C = cocycleRHS` — both
elaborate green this session against the frozen `idIso`/`compIso` vehicles; the only real
work is one section-ring tower identity (Leg 4, [M]); A-1 rides as a spec gated on B-56's
B-6b. Ratify the bundled form, the component route, and the A-1 rider.*
