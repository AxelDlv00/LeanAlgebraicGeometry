# W4-DAT-GLUE WORKSHEET — the 01JJ RepresentableBy assembly: feed the chart family, glue at `K_s`, transfer to `k'`

*2026-07-19, Opus design lane (`AJCR.w4-rep.datum.dat-glue`, worksheet-first).  BINDING
parents: `informal/w4-datum-worksheet.md` §1.2 (site gap 1 / slice trick), §1.3
(the `PicRepDatum k'` intermediate), §4 DAT-glue row + consumption map, §5 risk 7 (the
per-chart-vs-glued lft question, discharged here §2.3);
`informal/spec-dat-6.md` (the slice-trick spec — LANDED, §2.1);
`informal/w4-datc-worksheet.md` §0.2/§3.2/§3.3 (the `f_c`/`hf` shape DAT-glue consumes)
+ §4 (its C9 gate); `informal/w4-datb-worksheet.md` §0.1/§0.3/§1.1/§3 (the
`IsLocallySurjective` feed, the staging decision, and the DAT-G0 flag);
`informal/dat-d-worksheet.md` §4.1/§4.2 (the DD-Q lft/qc bundle row);
`informal/wave3-picard-design.md` §5 (the `JacobianData`/`RepresentableBy` target).
Inbox absorbed: I-0248 (DAT-B staging + DAT-G0 flag), I-0251 (CHART-U(b) co-sign
resolution), I-0249/I-0252/I-0253/I-0255 (landed layers + the tower-diamond and
universe-whnf gotcha lists — REQUIRED READING for the implementation lane).  Every
`file:line` below was verified by DIRECT READ this pass; no Lean edited, no lake, no LSP
(local-search index empty — grep + read only).  This worksheet pins DAT-glue so the
assembly is cold-launchable the moment `divRep` (hence DAT-C C9 + DAT-B B-6) lands.*

## §0 Verdicts up front

### §0.1 The one-line verdict

**The "01JJ RepresentableBy assembly over `k'` (slice trick DAT-6)" of the roadmap title
is, mechanically, ALREADY LANDED** — `pic0RepresentableByOfCharts`
(`Picard/Pic0SigmaSheaf.lean:161-169`), the big-site sheaf certificate
(`pic0SigmaFunctor_isSheaf` `:90`, `pic0SigmaSheaf` `:147`), the whole slice-trick stack
(DAT-6: `Over.sigmaExtension` + `RepresentableBy.overSlice`,
`Picard/OverSigmaExtension.lean:125/:235`), and mathlib's 01JJ engine
(`Scheme.LocalRepresentability.representableBy`, `AlgebraicGeometry/Sites/
Representability.lean:192`) are all in the tree.  Firing them is a **one-line
application** (§1.2) gated only on its two inputs (`f`/`hf` = DAT-C C9; the
`IsLocallySurjective` instance = DAT-B B-6).  **The roadmap title is misleading in one
word: "over `k'`."**  The DAT-B staging finding (§0.3, I-0248) proved coverage is honest
ONLY at a **separably closed** `K_s`, so the 01JJ output is a representation at `K_s`,
NOT at `k'`.  The word "over `k'`" names a SECOND, genuinely-new-mathematics step —
**DAT-G0, the `K_s → k'` finite-level transfer** — which is DAT-glue's ONE mountain and
the real content of this node.  Everything else (the glue itself, the lft certificate)
is bounded assembly of landed keystones.

### §0.2 Landed layers that make the "assembly" trivial (found this pass; supersede the datum-worksheet §4 DAT-glue row)

The datum-worksheet §4 pinned DAT-glue as "[L, Opus from a tight spec]: slice trick
(DAT-6) + `representableBy` … output the `k'`-level `PicRepDatum`."  Three of those four
pieces are now LANDED — verbatim, verified by direct read:

1. **DAT-6 is DONE end-to-end** (spec-dat-6 Route A shipped).  The three-stage stack:
   * `Over.sigmaExtension S F` — the Σ-extension `T ↦ Σ (a : T ⟶ S), F(Over.mk a)`
     (`Picard/OverSigmaExtension.lean:125`); the Σ-descent keystone
     `Functor.RepresentableBy.overSlice` (`:235-236`).
   * `pic0TypeFunctor C := (pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat`
     (`Picard/Pic0SigmaSheaf.lean:58-59`), with `pic0TypeFunctor_obj`
     (`:62`, `rfl`) and `pic0TypeFunctor_map_apply` (`:66-69`, `rfl`).
   * `pic0SigmaFunctor C := Over.sigmaExtension (Spec (.of k)) (pic0TypeFunctor C)`
     (`:76-77`); the big-site sheaf certificate `pic0SigmaFunctor_isSheaf`
     (`:90-142`, `set_option maxHeartbeats 800000`) and its bundle
     `pic0SigmaSheaf C : Sheaf Scheme.zariskiTopology.{u} (Type u)` (`:147-149`).
2. **The 01JJ seam is DONE**: `pic0RepresentableByOfCharts` (`:161-169`) consumes exactly
   the mathlib triple and returns `(pic0TypeFunctor C).RepresentableBy (Over.mk …)` — the
   verbatim `rep`-field type of `JacobianData` (`Picard/JacobianData.lean:93`).  Its body
   is `(Scheme.LocalRepresentability.representableBy hf).overSlice` (`:169`).
3. **The lft substrate is DONE (DD-Q)**: `locallyOfFiniteType_divSchemeOverHom`
   (`Picard/DivSchemeQProj.lean:199-201`), the qc/separated companions (`:188/:206`),
   `compactSpace_divScheme` (`:194`), the bundle `DivQProjBundle`/`divQProj`
   (`:221/:245`).

**So DAT-glue's own new mathematics is NOT the glue.**  It is (a) the finite-level
transfer DAT-G0 (§3.3, the mountain), and (b) two S-bricks: the glued-object lft
assembly (§2.3) and the `PicRepDatum k'` packaging (§3.4).  The "L, Opus from a tight
spec" estimate of the datum-worksheet is now an **S application + one XL sub-brick**.

### §0.3 The staging finding and its consequence for DAT-glue (I-0248 / w4-datb §0.3)

DAT-B decided (parent §5.7 residue): the coverage theorem — hence the 01JJ assembly — is
stated at a **separably closed instantiation `K_s`** of the standing pack, with the FULL
infinite `ChartIndex` `c = (m, Σ)` (`Type u`; 01JJ accepts any `ι : Type u`,
`Representability.lean:57`).  Coverage at a fixed finite separable level is **neither
claimed nor needed** (the parent §2.5(d) genus-2/ℚ obstruction).  Therefore:

* **The 01JJ output is `rep_{K_s} : pic0TypeFunctor(C_{K_s}).RepresentableBy J_{K_s}`**,
  a representation at base `K_s`, NOT at `k'` and NOT at `k`.
* **`J_{K_s}` is quasi-compact a posteriori** (`|J_{K_s}| =` image of the qc
  `DivScheme_{K_s}` under the Abel morphism — `compactSpace_divScheme`
  `DivSchemeQProj.lean:194` + DAT-B's effective-witness export, w4-datb §3.3); a **finite
  chart subfamily** follows topologically; its finitely many `Σ_i` (finitely many
  `K_s`-points of a finite-type scheme) are defined over ONE finite separable `k'/k` —
  which is HOW `k'` is chosen.
* **DAT-G0 — `K_s → k'` transfer of the representing datum** — spreads the finite
  chart/gluing data down to `k'` and descends "`yoneda(J) ⟶ pic0`-sheaf is an iso" from
  `K_s` to `k'`.  This is NEW DEBT nobody's scoreboard carried before I-0248; the
  ownership decision is §0.4.

### §0.4 THE DAT-G0 OWNERSHIP DECISION (the adjudication the parent asked for)

**DECISION: DAT-glue owns DAT-G0.**  DAT-glue's charter deliverable was always
"output the `k'`-level `PicRepDatum`" (datum-worksheet §4 row; consumption map row
"DAT-glue (`PicRepDatum k'`) → DAT-G").  DAT-G0 is *precisely the honest content of that
deliverable* once the path is known to run through `K_s`.  Reasons, binding:

1. **Interface preservation.**  DAT-G's charter (datum-worksheet §4 DAT-G) is *finite
   Galois/Speiser descent `k' → k`* through rigidified pairs (the Hilbert-90 discipline;
   Speiser `k' ⊗_k A^Γ ≅ A`, `RingTheory/Invariant/Basic.lean:67`).  That machinery
   consumes a FINITE Galois group action.  The `K_s → k'` transfer is NOT finite Galois
   descent (`K_s/k'` is infinite, not a finite Galois extension) — it is a
   **spreading-out / filtered-colimit** argument.  Folding it into DAT-G would pollute
   DAT-G's clean finite-Galois interface with an unrelated mountain, and would MOVE the
   `PicRepDatum k'` handoff that the datum-worksheet froze.
2. **Mechanism affinity.**  DAT-G0 operates on the GLUE DATA DAT-glue just produced
   (spread the finite `(X_i, f_i)` and the `glueData` cocycle along the filtered colimit
   `k' → K_s` of finite separable subextensions; fpqc/limit-locality of the sheaf-iso).
   It is the natural continuation of the assembly, not of the orbit structure DAT-G
   builds.
3. **Clean start for the unwritten DAT-G worksheet.**  With DAT-glue owning DAT-G0,
   DAT-G inherits exactly `PicRepDatum k'` — the frozen shape — and never sees `K_s`.

**Caveat (recorded, not a reversal):** DAT-G0 is heavy enough (spreading out finite
presentation + fpqc-locality of representability — no landed avatar) to warrant its OWN
mini-spec before proving.  DAT-glue OWNS it, but it is worksheet-first *inside* DAT-glue:
§3.3 freezes its statement skeleton so DAT-G can be co-signed against the frozen
`PicRepDatum k'` today, while DAT-G0's proof matures.

### §0.5 Transcription vs honest new work (the house scoreboard)

| piece | status | where |
|---|---|---|
| the slice trick DAT-6 (Σ-extension, sheaf, overSlice) | **LANDED** | §2.1 |
| the 01JJ engine + `pic0RepresentableByOfCharts` | **LANDED** | §1.1 |
| the raw 01JJ application at `K_s` (feed `f`/`hf`/inst) | **1-line application**, gated on C9+B-6 | §1.2 |
| lft of the glued `J` from per-chart DD-Q | **S** (locality-on-source) | §2.3 |
| qc of `J` (image-of-DivScheme) + finite subfamily | **S**, consumes DAT-J's image argument at `K_s` | §3.2 |
| **DAT-G0** (`K_s → k'` transfer) | **XL, honest new mathematics, worksheet-first inside DAT-glue** | §3.3 |
| `PicRepDatum k'` packaging | **S** | §3.4 |

### §0.6 Launchability

* **Pre-divRep (statements + the light bricks), launchable NOW**: the `PicRepDatum`
  structure def (§3.4); the lft-assembly lemma *statement* (§2.3); the DAT-G0 spec
  skeleton + co-sign with DAT-G (§3.3).  These touch only landed API (`Pic0SigmaSheaf`,
  `OverSigmaExtension`, DD-Q, mathlib 01JJ) — no `f_c`, no coverage.
* **Post-divRep (the assembly proper)**: the 01JJ application (§1.2) the day DAT-C's C9
  (`f_c`, `hf`) and DAT-B's B-6 (`IsLocallySurjective`) land — both gated on `divRep`
  (F5–F7, NOT landed; landed backward half `divRepClassifyZar`
  `Picard/DivRepClassifyZar.lean:244`, I-0243).  DAT-G0's PROOF is post-application (it
  transfers the produced datum); its spec is pre-everything.

### §0.7 Risks, ranked (details §5)

1. **DAT-G0 (high — the only honest mountain).**  Spreading out + fpqc-locality of
   representability has no landed avatar; the `K_s` colimit is infinite.
2. **The whole assembly is `divRep`-gated through C9 + B-6 (high impact, externalized).**
   Nothing fires until DAT-C C9 and DAT-B B-6 land, both waiting on F5–F7.
3. **The qc/finite-subfamily sequencing (medium).**  `J`-qc feeds DAT-G0's finite
   extraction; the qc argument (DAT-J's) must be instantiable at `K_s` — verify no
   circularity (§3.2 shows there is none: the image argument is direct, not via the
   finite subfamily).
4. **Instance/universe bookkeeping at the `K_s` instantiation (medium).**  The
   `[GeometricallyReduced]` demand of the sheaf (`Pic0SigmaSheaf.lean:79`), the
   tower-diamond wall (I-0255), the universe-whnf hazard (I-0249).
5. **lft base carrier (low-medium).**  The per-chart lft is over the chart's base field;
   the glued `J.hom` lands over `Spec K_s` then `Spec k'` — the DAT-G0 transfer must
   carry lft, not re-derive it (§2.3/§3.4).

### §0.8 Standing context

The instantiation is the w4-datc/w4-datb §0.5/§0.6 pack, at base `K_s` (a separable
closure of `k`, `[IsSepClosed K_s]`; the vocabulary is `Curve/SeparablyClosedPoints.lean`,
`Curve/SepPointsDense.lean`).  `C_{K_s} := (baseChange k K_s).obj C`
(`AlgebraicJacobian/Challenge.lean:170`) is a legal curve over `K_s`: the curve instances
transport by the Challenge.lean stability instances (`IsProper` `:174-176`,
`GeometricallyIrreducible` `:178-180`, `SmoothOfRelativeDimension 1` `:182-185`), and
`GeometricallyReduced` from smoothness (`Curve/GeometricallyReduced.lean:148`).  All four
are exactly the instance block `pic0RepresentableByOfCharts` demands
(`Pic0SigmaSheaf.lean:51-52` + `:79`).  `d₁ := classDeg K_s (thetaCechClass C_{K_s})`
(`Picard/ThetaShift.lean:263`, `1 ≤ d₁` via `one_le_classDeg_thetaCechClass` `:270`).

---

## §1 THE RepresentableBy ASSEMBLY — the statement pins (against `pic0RepresentableByOfCharts`)

### §1.1 The landed final consumer (verbatim, by direct read)

`Picard/Pic0SigmaSheaf.lean:161-169`, the frozen target of Stage C:

```lean
noncomputable def pic0RepresentableByOfCharts
    {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (hf : ∀ i, IsOpenImmersion.presheaf (f i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
    (pic0TypeFunctor C).RepresentableBy
      (Over.mk ((Scheme.LocalRepresentability.representableBy hf).homEquiv
        (𝟙 (Scheme.LocalRepresentability.glueData hf).glued)).1) :=
  (Scheme.LocalRepresentability.representableBy hf).overSlice
```

in the file's variable block (`:50-52`, `:79`): `{k : Type u} [Field k]`,
`(C : Over (Spec (.of k)))`, `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`,
`[GeometricallyIrreducible C.hom]`, `[GeometricallyReduced C.hom]`.

The three mathlib pins under it, verified in the pinned checkout
(`.lake-packages/mathlib`, v4.31.0):

* `Scheme.LocalRepresentability.glueData` (`AlgebraicGeometry/Sites/
  Representability.lean:68`) and `(glueData hf).glued` — 01JJ's glued scheme; variable
  block `:56-58` (`F : Sheaf Scheme.zariskiTopology.{u} (Type u)`, `{ι : Type u}
  {X : ι → Scheme.{u}}`, `f : (i : ι) → yoneda.obj (X i) ⟶ F.1`,
  `hf : ∀ i, IsOpenImmersion.presheaf (f i)`).
* `Scheme.LocalRepresentability.representableBy hf : F.1.RepresentableBy (glueData hf).glued`
  (`:192`), under `[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`
  (`:169`).
* `Presheaf.IsLocallySurjective` (`CategoryTheory/Sites/LocallySurjective.lean:94`),
  `imageSieve_mem` (`:95/:97`), `imageSieve` (`:49`).

**Consequence (the key typing fact).**  `pic0TypeFunctor C` is DEFINITIONALLY the `rep`
field's functor (`(pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat`,
`Pic0SigmaSheaf.lean:58` = `JacobianData.lean:93`).  So the 01JJ output is DIRECTLY a
`JacobianData.rep`-shaped datum — **no `forget₂ ⋙ forget` massage, no ε⁺-shift, at glue
time** (the shift lives inside DAT-C's `chartValue`; §1.4).

### §1.2 The 01JJ application at `K_s` (DECISION: one line, gated on C9 + B-6)

At the `K_s` instantiation (§0.8) with the DAT-C/DAT-B outputs:

```lean
-- inputs (NOT landed — the gates):
--   ChartIndex C_{K_s} : Type u                                    (w4-datc §3.2, dat-d §1.3)
--   f  : ∀ c, yoneda.obj (VOver c).left ⟶ (pic0SigmaSheaf C_{K_s}).1   (DAT-C C9, w4-datc §3.3)
--   hf : ∀ c, IsOpenImmersion.presheaf (f c)                        (DAT-C C9)
--   inst : Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)  (DAT-B B-6, w4-datb §1.1)
noncomputable def pic0RepKs :
    (pic0TypeFunctor C_{K_s}).RepresentableBy (Over.mk (…)) :=
  pic0RepresentableByOfCharts (C := C_{K_s}) f hf
```

The represented object `J_{K_s}` is `Over.mk ((representableBy hf).homEquiv (𝟙
(glueData hf).glued)).1`; its `.left = (glueData hf).glued`, its `.hom =` the universal
element's Σ-component (both DEFINITIONAL, docstring `Pic0SigmaSheaf.lean:153-160`).
**This is the entire "01JJ assembly."**  There is no new mathematics in it; every symbol
is landed except `f`/`hf`/`inst`, which are C9/B-6.

**Sharpening of the `f`/`hf` input, 2026-07-28 (run 0072, lane `ajcr-charts`).**  Two of the
three inputs above are now decomposed, so this section's "gated on C9" can be costed instead
of merely deferred:

* **`f` is available today.**  `abelSigmaChart` (`Picard/Pic0AtlasFromDivRep.lean:198`)
  consumes a `(divFunctor C π n).RepresentableBy`, and `ajcr-divrep` has published
  `DivRepAffinePullback.representableBy` (`Picard/DivRepGlobalClassify.lean:306`, sorry-free,
  rooted) as exactly that.  Restricting it to a chart open is `restrictChart`
  (`Picard/Pic0ChartPair.lean`).
* **`hf` is FACTORED, and only one factor remains.**  The composition half is discharged
  unconditionally (`isOpenImmersion_presheaf_restrictChart`, same file), so `hf` reduces to
  the single statement `IsChartUniv` = CHART-U(c): on the chart locus the Abel map is an open
  immersion because the normalized effective representative is unique there.  Its
  *field-level* input is landed (GAP-2, `RiemannRoch/EffectiveUniqueness.lean:144`); what it
  needs is the relative form plus `divRepClassifyZar`.
* **`chartLocus` itself now exists** (`Picard/Pic0ChartLocus.lean`), in the co-signed
  CHART-U(a) split form, so nothing here waits on the *name* any more.  Its openness carries
  one declared `sorry` and is gated on GAP-1's mul/tensor half.

So the honest reading of §1.2's gate is: **not "nothing fires until C9 lands", but "one
statement (CHART-U(c)) plus GAP-1-mul stand between this section and firing"** — with `inst`
(= B-6, hence COV-1) independent of both.

### §1.3 The `ChartIndex` and the chart maps (frozen by DAT-C/DAT-B; consumed, not built)

`ChartIndex C := (m : ℕ) × {Σ : (C ⊗ overSpec k k).left.CurveDivisor // 0 ≤ Σ ∧
CurveDivisor.deg k Σ = (m : ℤ) * d₁ - g}` — `Type u` (w4-datb §1.1, w4-datc §3.2,
dat-d §1.3, the parent §5.7 discharge).  `X c := (VOver c).left` where
`VOver c := Over.mk ((V c).ι … ≫ divSchemeOver!.hom)` is the h¹-vanishing open of
`DivScheme!` (w4-datc §1.1, GAP-5 open-immersion instance).  `f c` at a scheme `T'`:
`v ↦ ⟨v ≫ VOver.hom, chartValue c (F_v)⟩` — the Σ-component bookkeeping of
`Over.sigmaExtension` (`OverSigmaExtension.lean:118-125`), w4-datc §3.2.
**DAT-glue builds NONE of these** (scope guard §5): they are DAT-C's C9.

### §1.4 Why the glue output is `pic0` DIRECTLY (no ε⁺-shift at assembly; risk-6 discharge)

The datum-worksheet §5 risk 6 warned that a `pic^d`-coset spelling would poison
`ofRepresentableBy`'s typing.  It does not, because **`chartValue` already lands in
degree 0**: `abelDivTrans : divFunctor C π g ⟶ picDegLayerFunctor C g`
(`Picard/DivSchemeAbel.lean:302`, `abelDivTrans_app_coe` `:310`) puts the Abel class in
the degree-`g` layer; `chartValue c F = abelDiv F · sigmaFamily Σ · (thetaFamily^m)⁻¹`
(w4-datc §3.2) then adds `(m·d₁ − g)` and subtracts `m·d₁`, netting degree `0`
(w4-datc §4.2 ledger).  So `f_c` targets `pic0SigmaSheaf` and 01JJ produces
`pic0TypeFunctor.RepresentableBy` verbatim.  **`representableByOfShift`
(`ThetaShift.lean:225-229`) is NOT consumed at glue time** — it remains DAT-J's tool
(w4-datc §4.2, w4-datb §3.2) IF the final packaging ever prefers the layer spelling.
Record to prevent double-shifting: the shift is INSIDE `chartValue`.

---

## §2 THE SLICE TRICK (DAT-6, LANDED) AND THE lft/qc ROWS (DD-Q)

### §2.1 DAT-6 — the mechanism, confirmed landed (spec-dat-6 Route A shipped)

The slice trick bridges `pic0` (a functor on `Over (Spec k)ᵒᵖ`) to mathlib's 01JJ (a big
site on `Scheme`).  Route A (spec-dat-6 §0): NO over-topology sieve calculus; the big-site
sheaf condition reduces to elementwise ∃!-amalgamation on honest open covers via three
mathlib rewrites — `Precoverage.isSheaf_toGrothendieck_iff_of_isStableUnderBaseChange`,
`Scheme.exists_cover_of_mem_pretopology`, `Presieve.isSheafFor_arrows_iff` — visible in
the landed proof (`Pic0SigmaFunctor_isSheaf`, `Pic0SigmaSheaf.lean:92-95`).  The Σ-descent
`overSlice` (`OverSigmaExtension.lean:235-236`) then reads a representation of the
Σ-extension `F̃` back as a representation of `F` on the slice, with the represented object
`Over.mk (α.homEquiv (𝟙 J)).1` — the datum-worksheet §1.2.1 pin, holding definitionally.
**Nothing in DAT-6 is DAT-glue's to build.**  DAT-glue CONSUMES `pic0SigmaSheaf` and
`pic0RepresentableByOfCharts` as its assembly primitives.

### §2.2 The lft/qc/separated substrate (DD-Q, LANDED; dat-d §4.1)

`Picard/DivSchemeQProj.lean`, verified this pass:

* `locallyOfFiniteType_divSchemeOverHom : LocallyOfFiniteType (divSchemeOver …).hom`
  (`:199-201`) — **THE DAT-glue lft certificate** (dat-d §4.2 consumer row).
* `quasiCompact_divSchemeOverHom` (`:188-190`), `compactSpace_divScheme` (`:194-195`),
  `isSeparated_divSchemeOverHom` (`:206-208`), bundle `DivQProjBundle`/`divQProj`
  (`:221/:245`).
* **Honest boundary (BINDING, `:44-51`)**: PROJECTIVITY (Plücker) and UNIVERSAL
  CLOSEDNESS are NOT delivered — `divQProj` is lft + qc + separated only.  So DAT-glue
  can deliver lft; **properness of `J` is Wave-5's problem** (universally-closed `grPair`
  is not on this bundle — consistent with `JacobianData` storing only `locallyOfFiniteType`
  + `quasiCompact`, `JacobianData.lean:96-100`, and NOT separatedness/properness, which
  Wave 5 derives group-theoretically, wave3 §5).

### §2.3 The glued-object lft (risk-7 discharge — DECISION: per-chart → locality-on-source)

Datum-worksheet §5 risk 7 left open "whether DAT-glue's lft certificate is carried
per-chart or re-derived on the glued object."  **DECIDED: per-chart certificate, then a
locality-on-source assembly on the glued `J`.**  Route:

1. Each `X c = (VOver c).left` is an OPEN of `DivScheme!` (w4-datc GAP-5), so its
   structure map to the base field inherits lft from `locallyOfFiniteType_divSchemeOverHom`
   (open immersions are lft; lft closed under composition).
2. `{toGlued hf c : X c ⟶ (glueData hf).glued}` is an OPEN COVER of `J.left`
   (`LocalRepresentability.toGlued` is an open immersion, `Representability.lean:87-91`;
   the ranges cover by `IsLocallySurjective`).
3. `X c ⟶ J.left ⟶ Spec(base) = X c ⟶ Spec(base)` is lft (step 1); lft is
   **Zariski-local on the source**, so `J.hom` is lft.

This is an S-brick; its statement is landable NOW (it needs only DD-Q + mathlib's
locality-on-source lemma for `LocallyOfFiniteType`), its PROOF the day `J` exists (§1.2).
Note the base carrier: at the raw stage lft is over `Spec K_s`; DAT-G0 (§3.3) must CARRY
it to `Spec k'`, not re-derive it.

---

## §3 THE STAGING, THE FINITE SUBFAMILY, AND THE DAT-G0 BOUNDARY

### §3.1 The two levels, made precise

| level | what lives there | who |
|---|---|---|
| `K_s` (sep-closed) | coverage (B-5), `IsLocallySurjective` (B-6), the 01JJ output `rep_{K_s}` (§1.2), `J_{K_s}` lft (§2.3) + qc (§3.2) | DAT-B (feed) + DAT-glue (application) |
| `k'` (finite sep./`k`) | `PicRepDatum k'` = `(J', rep', lft')` at base `k'` | **DAT-glue via DAT-G0** (§3.3–§3.4) |
| `k` (challenge base) | `JacobianData C` (`rep` at base `k`) | DAT-G (finite Galois `k'→k`) → DAT-J |

The word "over `k'`" in the roadmap title is the SECOND row, reached only through DAT-G0.

### §3.2 `J_{K_s}`-qc and the finite chart subfamily (S; sequencing verified — no circularity)

The infinite `ChartIndex` means `J_{K_s}` is NOT qc from the glue.  qc is a posteriori:

* `|J_{K_s}|` is the image of the qc `DivScheme_{K_s}` under the Abel morphism
  (`rep_{K_s}.homEquiv.symm` of the chart-shifted `abelDiv` family, w4-datc §4;
  `compactSpace_divScheme` `DivSchemeQProj.lean:194`), fed by DAT-B's effective-witness
  export `pic0_field_point_effective` (w4-datb §3.3): every degree-`g` class with
  `h⁰ ≥ 1` (free at `χ = 1`) has an effective witness = a `DivScheme`-point.  Image of qc
  is qc.
* **This is DAT-J's image argument** (JacobianData.quasiCompact is documented
  "a posteriori: `|J|` is the image of a quasi-compact divisor scheme under the Abel map",
  `JacobianData.lean:97-98`); DAT-glue CONSUMES it instantiated at `K_s`.
* **No circularity**: the image argument is DIRECT (Abel morphism + `compactSpace_divScheme`
  + effective export), NOT via the finite subfamily.  Once `J_{K_s}` is qc, a **finite
  chart subfamily** `{c_1,…,c_n}` follows topologically (each chart image is open, they
  cover `J_{K_s}`, `J_{K_s}` compact); the finitely many `Σ_{c_i}` are `K_s`-points of a
  finite-type scheme, hence defined over ONE finite separable `k'/k` — the choice of `k'`.

DAT-glue's DG-2 brick states the finite-subfamily extraction; it consumes DAT-J's qc
theorem (instantiated at `K_s`) as a hypothesis, so DG-2 does NOT wait on DAT-J's final
assembly (only on its qc mechanism, which is itself divRep-gated through the effective
export).

### §3.3 DAT-G0 — the `K_s → k'` transfer (DAT-glue's ONE mountain; worksheet-first, spec skeleton FROZEN here)

**Statement skeleton (the frozen boundary DAT-G co-signs against):** given the finite
chart subfamily over `K_s` (§3.2), produce a representation at `k'`:

```lean
-- SPEC SKELETON — the honest new mathematics of DAT-glue; no landed avatar.
structure PicRepDatum (k' : Type u) [Field k'] [Algebra k k']
    (C' : Over (Spec (.of k'))) [IsProper C'.hom]
    [SmoothOfRelativeDimension 1 C'.hom] [GeometricallyIrreducible C'.hom] : Type (u+1) where
  J    : Over (Spec (.of k'))
  rep  : (pic0TypeFunctor C').RepresentableBy J
  lft  : LocallyOfFiniteType J.hom

theorem picRepDatum_of_Ks_transfer … :
    Nonempty (PicRepDatum k' C_{k'})   -- honest def, no Nonempty-smuggling: a plain producer
```

**Route (the honest new work; each sub-step flagged for its landed-avatar status):**

1. **Spread out the finite glue data.**  The finite `{(X_{c_i}, f_{c_i})}` and the
   `glueData` cocycle (`LocalRepresentability.glueData`, `Representability.lean:68`) are
   finite-presentation data over `K_s`; `K_s = colim k''` over finite separable `k''/k'`.
   Spread `X_{c_i}`, the open immersions, and the transition isomorphisms to some finite
   stage `k'` (each `Σ_{c_i}` already `k'`-rational, §3.2).  **No landed avatar** — this
   is EGA IV.8-style spreading of finite-type schemes; the module-algebra shadow is the
   RE-5 spreading (`Cohomology/DatumDescent.lean:514`, `descentRigidEngine` `:547`) but
   at the SCHEME level, not the datum level. NEW.
2. **Descend the sheaf-iso.**  "`yoneda(J') ⟶ pic0SigmaSheaf(C_{k'})` is an iso" is an
   fpqc-local (indeed Zariski/limit-local) statement; it holds at `K_s` (that IS
   `rep_{K_s}`), and `K_s/k'` is a filtered colimit of separable extensions, so it
   descends to `k'`.  Mechanism candidate: `Functor.RepresentableBy` bookkeeping along the
   base-change functor + the compatibility of `pic0SigmaSheaf` with the colimit
   (`pic0` restriction maps, `Picard/PicEtMap.lean:15-23`; the DAT-2 sheaf gluing
   `Picard/Pic0ZariskiSheaf.lean:246`).  **No landed avatar** — NEW.
3. **Carry lft.**  §2.3's lft at `K_s` descends to lft/`k'` along the spreading (open
   immersions of finite-type schemes spread with their lft).  Bounded once step 1 lands.

**Ownership reminder (§0.4): DAT-glue owns this.**  It is worksheet-first INSIDE
DAT-glue: this skeleton is the co-sign handle; a dedicated DAT-G0 mini-spec precedes the
proof.  **DAT-G's interface is `PicRepDatum k'`, unchanged.**

### §3.4 The `PicRepDatum k'` packaging (S; the DAT-glue → DAT-G handoff)

Bundle `(J', rep', lft')` from §3.3 as `PicRepDatum k' C_{k'}` (§3.3 struct).  This is the
frozen output the datum-worksheet §1.3 / §4 consumption-map row named
("DAT-glue (`PicRepDatum k'`) → DAT-G").  qc is NOT stored (it is re-derived at `k'` by
the same image argument, or inherited by DAT-J at `k` — `JacobianData.quasiCompact` is a
posteriori); separatedness/properness are Wave-5's (§2.2 boundary).  DAT-G then runs
finite Galois/Speiser descent `k' → k` on `rep'` through rigidified pairs (its charter),
and DAT-J assembles `JacobianData C` (`JacobianData.lean:87`) + discharges the frozen
`Jacobian`/`instGrpObj` (`Challenge.lean:96/:107`).

---

## §4 FILE PLAN, SIZES, GATES, LANE ORDER

Discipline inherited in full (informal/protocol-concurrent-lanes.md §1 private-index CAS
commits, your `informal/` path only, no root import; mkdir lake mutex; ≤ 500 L; one heavy
declaration per unit; `lean_verify` on keystones; axioms exactly
`[propext, Classical.choice, Quot.sound]`; no sorried instances, no `Nonempty`-smuggling —
`PicRepDatum` producers are plain defs).  Gotcha lists REQUIRED READING before any heavy
proof: **I-0255 the tower-diamond wall** (a fibre extension `L` MUST be supplied via a
NATIVE `k`-algebra tower / residue-field instances, NEVER a composite `letI`
`RingHom.toAlgebra` — whnf non-termination even at 1,000,000 heartbeats; bites every
`K_s`/`k'` instantiation that forms `pic0`/base-change over a tower), **I-0249 universe
whnf**, I-0252/I-0253 (landed-layer gotchas).

| # | file (new) | contents | size | gated by | launchable-when |
|---|---|---|---|---|---|
| DG-0 | `Picard/PicRepDatum.lean` | the `PicRepDatum k'` structure (§3.3/§3.4) + accessors; the `pic0TypeFunctor`-vs-`JacobianData.rep` defeq note | S | none | **NOW** (statements) |
| DG-1 | `Picard/Pic0GlueAssembly.lean` | §1.2: `pic0RepKs` (the 1-line 01JJ application at `K_s`) + §2.3 lft-assembly `locallyOfFiniteType_glued` | S→M | DAT-C **C9** (`f`/`hf`) + DAT-B **B-6** (inst) + DD-Q (lft) | statements NOW; proof post-divRep |
| DG-2 | `Picard/Pic0FiniteSubfamily.lean` | §3.2: `J_{K_s}`-qc (image-of-DivScheme, consumes DAT-J qc mechanism at `K_s`) + finite chart subfamily extraction + the `k'` choice | M | DG-1 + DAT-B §3.3 effective export | post-divRep |
| DG-3 | `Picard/Pic0KsToKprime.lean` | **DAT-G0** (§3.3): spread out finite glue data + descend the sheaf-iso + carry lft → `PicRepDatum k'` | **L→XL** (worksheet-first inside DAT-glue) | DG-1, DG-2; its OWN mini-spec | proof: post everything; spec: NOW |
| DG-4 | `Picard/Pic0RepAssemble.lean` | §3.4: `picRepDatumKprime : PicRepDatum k' C_{k'}` packaging + the DAT-G handoff docstring | S | DG-3 | after DG-3 |

**Lane order.**  `DG-0` (now, statements) ∥ [DG-3 mini-spec + DAT-G co-sign, now] →
`[divRep F5–F7 lands] → [DAT-C C9 + DAT-B B-6 land]` → `DG-1 → DG-2 → DG-3 → DG-4`.
**Only DG-0 and the DG-3 spec are launchable pre-divRep**; the assembly proper is a bounded
transcription the day C9 + B-6 land, and DAT-G0 (DG-3) is the sole XL, worksheet-first
inside the node.

**Consumption map (who cites what).**

| DAT-glue deliverable | consumer |
|---|---|
| `pic0RepKs` + lft (DG-1) | DG-2, DG-3 |
| finite subfamily + `k'` choice (DG-2) | DG-3 (DAT-G0) |
| `PicRepDatum k'` (DG-4) | **DAT-G** (finite Galois `k' → k`) → DAT-J → `JacobianData C` |

---

## §5 HONEST RISKS — with mitigations, and what is deliberately NOT decided

1. **⚠ DAT-G0 (DG-3) is the campaign-region balloon here** — spreading out finite
   presentation + fpqc-locality of representability across an INFINITE `K_s = colim k''`,
   no landed avatar.  Mitigations: it is worksheet-first INSIDE DAT-glue (§0.4 caveat) —
   freeze its mini-spec before proving; the sheaf-iso descent (§3.3 step 2) rides landed
   `pic0` colimit/restriction API (`PicEtMap.lean:15-23`, `Pic0ZariskiSheaf.lean:246`) and
   `RepresentableBy` bookkeeping (no new geometry there); the scheme-spreading (step 1)
   has the RE-5 datum-level spreading as a shape template even though the level differs.
   Fallback if step 1 walls: state the transfer as a `Nonempty (PicRepDatum k')`
   existence via a limit argument along `k' → K_s` (RE-5 style) rather than an explicit
   spread — record BEFORE taking it (it is a DAT-glue/DAT-G interface change, orchestrator
   -owned).
2. **⚠ The assembly is `divRep`-gated through C9 + B-6 (high impact, externalized).**
   `divRep` = F5–F7 (`Picard/DivRep{Pull,Aff,}.lean`), NOT landed; the landed backward
   half is `divRepClassifyZar` (`DivRepClassifyZar.lean:244`, I-0243).  DAT-C's C9 (`f_c`,
   `hf`) and DAT-B's B-6 (`IsLocallySurjective`) both wait on it.  Insulation: DG-0 and
   the DG-3 spec are `divRep`-free; DG-1's *statements* type-check against the landed
   `pic0RepresentableByOfCharts` signature today.
3. **qc/finite-subfamily sequencing (medium).**  `J`-qc feeds DAT-G0; §3.2 verified the
   image argument is direct (no circularity), but it consumes DAT-B §3.3's effective
   export, itself divRep-gated.  Mitigation: DG-2 takes the qc theorem as a HYPOTHESIS
   (characterizing-lemma style, the I-0243 pattern), so a spelling shift in DAT-J's qc
   moves one line.
4. **Instance/universe bookkeeping at `K_s`/`k'` (medium).**  The `[GeometricallyReduced]`
   demand (`Pic0SigmaSheaf.lean:79`, satisfied by smooth `GeometricallyReduced.lean:148`);
   the **tower-diamond wall (I-0255)** — every `pic0`/base-change over a `K_s`/`k'` tower
   MUST use native `k`-algebra instances, never a composite `letI`; the universe-whnf
   hazard (I-0249).  Mitigation: install the same native-tower instance the DAT-B collapse
   uses (`PicEtAffFieldCollapse.lean`, I-0255 keystones); keep every tower a CLEAN instance
   hypothesis.
5. **lft base carrier (low-medium).**  Per-chart lft is over the chart's base; `J.hom`
   lands over `Spec K_s` then `Spec k'`.  Mitigation: §2.3 pins locality-on-source at
   `K_s`; §3.3 step 3 carries it to `k'` — never re-derive lft downstream of the spread.
6. **Deliberately NOT decided here** (owned by named specs/worksheets): DAT-G0's exact
   spreading vehicle vs the limit-existence fallback (§5.1 — DG-3's own mini-spec); the
   `k'`-vs-`K_s` residue-field instance spelling (implementation, I-0255-constrained);
   whether `PicRepDatum` stores qc (currently NO — re-derived, §3.4); DAT-G's Speiser
   vehicle and its consumption of `PicRepDatum k'` (DAT-G's unwritten worksheet — it
   inherits the §3.3 frozen shape).
7. **Scope guard (recorded to prevent creep).**  NOT DAT-glue's: the chart family
   `f_c`/`hf`, mono, CERT-Σ, the `chartLocus` openness (DAT-C); the coverage/
   `IsLocallySurjective` instance (DAT-B B-6); the ε⁺-shift consumption (§1.4 — inside
   `chartValue`, else DAT-J's `representableByOfShift`); the finite Galois/Speiser descent
   `k' → k` (DAT-G); the `JacobianData C` assembly + frozen discharge + a-posteriori qc at
   `k` (DAT-J); properness/universal-closedness (Wave 5, §2.2 boundary); the slice trick /
   sheaf / 01JJ engine (LANDED, §2.1 — consumed, never rebuilt).

---

*End of worksheet.  Deliverable of record for `AJCR.w4-rep.datum.dat-glue`.  To echo to
the orchestrator: (1) the roadmap title's "over `k'`" is achieved by DAT-G0, NOT by a
`k'`-level 01JJ — coverage is `K_s`-only (I-0248); (2) **DAT-G0 is DAT-glue's, not
DAT-G's** (§0.4) — DAT-G's `PicRepDatum k'` interface is unchanged and can be co-signed
today; (3) the slice trick / sheaf / 01JJ engine / lft substrate are ALL LANDED, so the
"assembly" is a 1-line application (§1.2) + one XL sub-brick (DAT-G0); (4) the datum
worksheet §5 risk-7 (per-chart-vs-glued lft) is discharged as per-chart →
locality-on-source (§2.3), and risk-6 (`pic^d`-coset) is discharged — `chartValue`
absorbs the shift, glue output is `pic0` directly (§1.4).  DG-0 and the DG-3 mini-spec are
launchable cold today; the assembly proper is bounded the day divRep (F5–F7) → C9 + B-6
land.*
