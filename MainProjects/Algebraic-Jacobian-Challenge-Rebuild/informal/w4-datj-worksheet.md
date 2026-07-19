# W4-DAT-J WORKSHEET — the JacobianData assembly: the terminal datum-tail packaging, qc via the Abel image, and the frozen `Jacobian`/`instGrpObj` discharge

*2026-07-19, Opus design lane (`AJCR.w4-rep.datum.dat-j`, worksheet-first, DESIGN only —
no Lean edited, no lake, no LSP; grep + direct read; local-search index EMPTY).  BINDING
parents: `informal/w4-datum-worksheet.md` §1.1 (the frozen `JacobianData` shape), §1.4
(the Challenge.lean consumption map), §4 DAT-J row, §5 risk 6 (the `pic^d`-coset trap);
`informal/w4-datglue-worksheet.md` §0/§1.1/§3.2/§3.4 (the `PicRepDatum k'` handoff + the
qc image argument at `K_s`); `informal/w4-datc-worksheet.md` §4.2 (the ε⁺ ledger, where
the shift lives); `informal/w5-worksheet.md` §1 D3 (the properness/`AbelSourceData` split).
Inbox absorbed: I-0245 (DD-Q bundle + the `AbelSourceData.isProper` universal-closedness
flag), I-0249 (C5 Abel layer landed), I-0255/I-0256 (tower-diamond wall + DAT-glue verdict),
I-0236…I-0258 gotcha lists (hazards respected below).  Every `file:line` was verified by
DIRECT READ this pass.  This worksheet pins DAT-J so the terminal assembly is
cold-launchable the moment `divRep` (F5–F7) + coverage (DAT-B/DAT-C) + descent (DAT-glue →
DAT-G) land.*

## §0 Verdicts up front

### §0.1 The one-line verdict

**The `JacobianData` INTERFACE that DAT-J "assembles into" is, mechanically, ALREADY
LANDED end-to-end** — the structure (`Picard/JacobianData.lean:87-100`), the group-object
discharge route `grpObj` (`:113-114`), the whole consumer API
(`homEquiv`/`homEquiv_comp`/`uniqueUpToIso`/`homEquiv_uniqueUpToIso_hom`, `:119-144`), the
η-defeq smoke tests (`:167-182`, machine-checked), the entire Wave-7 base-change transport
(`Picard/JacobianDataBaseChange.lean`: `baseChange` `:59`, `grpObjObj_baseChange_eq` `:199`,
`baseChangeIsoOfData` `:227`) and the Abel-Jacobi base-change compatibility
(`Picard/JacobianDataBaseChangeAbel.lean`, axiom-clean modulo one **externalised** `hCore`
that is W7-K1's, not DAT-J's).  **Just like DAT-glue's 01JJ engine, the receptacle exists;
DAT-J does not build it.**  DAT-J's own new mathematics is exactly THREE things (§0.3): the
**producer** `jacobianData C : JacobianData C`, its **`quasiCompact` field** via the Abel
image of `Div^g`-lite, and the **definitional discharge** of the two frozen `Challenge.lean`
def-sorries `Jacobian`/`instGrpObj`.  All three are bounded assembly of landed keystones
plus ONE genuinely new but small brick (the qc surjectivity), gated only on the descent
output of DAT-G (hence on `divRep` + coverage).  **There is no XL inside DAT-J.**

### §0.2 The already-assembled interface (the highest-value finding; supersedes the datum-worksheet §4 DAT-J row)

The datum-worksheet §4 pinned DAT-J as "[M, Opus, deps: DAT-G] — assembly + discharge …
`Picard/JacobianData.lean` consumers and the frozen `Jacobian`/`instGrpObj` discharge."
**Every "consumer" it named is now LANDED** (verified verbatim this pass):

| piece | shape | file:line | status |
|---|---|---|---|
| the frozen datum `structure JacobianData C` (`J`/`rep`/`lft`/`quasiCompact`) | receptacle | `JacobianData.lean:87-100` | **LANDED** (w5-av.data done) |
| `JacobianData.grpObj := GrpObj.ofRepresentableBy …` (the `instGrpObj` route) | `:113-114` | **LANDED** |
| `homEquiv` / `homEquiv_comp` (the `forget₂⋙forget` massage, once) | `:119-129` | **LANDED** |
| `uniqueUpToIso` / `homEquiv_uniqueUpToIso_hom` | `:134-144` | **LANDED** |
| η-defeq smoke tests (`Over.mk d.J.hom ≡ d.J`; `smooth_of_grpObj` fires; `η[d.J].left` closed imm.) | `:167-182` | **LANDED, machine-checked** |
| `JacobianData.isSeparated` (X1, group-theoretic separatedness of `d.J`) | `GroupSeparated.lean:115-119` | **LANDED** (w5-av.x1 done) |
| Wave-7 datum base change `JacobianData.baseChange` + `baseChangeIsoOfData` | `JacobianDataBaseChange.lean:59,227` | **LANDED** |
| Abel-Jacobi base-change compat (reduced to `hCore`, W7-K1's) | `JacobianDataBaseChangeAbel.lean:143` | **LANDED** modulo `hCore` |
| the ε⁺ transport tool `representableByOfShift` | `ThetaShift.lean:225-229` | **LANDED** (NOT on DAT-J's mainline — §1.4) |
| the `Jacobian.functor` map/laws discharge kit (`pullbackHom` + `_id`/`_comp`) | `Pic0PullbackGrp.lean:41-58` | **LANDED** |

**So DAT-J's job is NOT interface construction.**  It is a small producer + one qc brick +
a definitional wiring.  This is the DAT-glue-01JJ finding for the datum tail: **say it
loudly — the endgame is much shorter than "DAT-J [M]" reads.**

### §0.3 What DAT-J genuinely owns (exactly three)

1. **The producer `jacobianData C : JacobianData C`** — a 4-field packaging.  `J`, `rep`,
   `lft` come *verbatim* from DAT-G's `k`-level descent output (the `PicRepDatum k k C`
   shape, §0.9); `quasiCompact` is #2.  NOT landed (grep: no `def jacobianData`;
   `Challenge.lean:96` is `sorry`).  **S–M** packaging brick, gated on DAT-G.
2. **The `quasiCompact` field** — the node's headline mechanism: `|J|` is the image of the
   quasi-compact `DivScheme g` under the Abel map, image of compact is compact
   (`JacobianData.lean:97-98` docstring, verbatim).  **M** brick; the abstract half is
   launchable NOW (§2.4), the surjectivity half is `divRep`-gated (§2.3).
3. **The discharge of the frozen `Jacobian` and `instGrpObj`** (the node title's "…" tail,
   §3) — `Jacobian C := (jacobianData C).J`, `instGrpObj := (jacobianData C).grpObj`, both
   DEFINITIONAL (`JacobianData.lean:26-28`).  **S** brick, edits `Challenge.lean` bodies
   only (the sanctioned discharge of the two archon-protected def-sorries; §3.4 constraint).

### §0.4 The qc-via-Abel-image mechanism vs the Wave-5 properness route (the boundary)

Two DIFFERENT Abel-image arguments run on the SAME morphism; **do not conflate them** (the
whole point of "where the properness boundary sits"):

| target | needs of the source `D` | landed substrate | who | field |
|---|---|---|---|---|
| **`QuasiCompact d.J.hom`** (DAT-J's field) | `D` **quasi-compact** (`CompactSpace D.left`) + `Surjective abel.left` | `compactSpace_divScheme` (`DivSchemeQProj.lean:194`) — LANDED | **DAT-J** | stored in `JacobianData` |
| **`UniversallyClosed`/`IsProper d.J.hom`** (Wave-5) | `D` **proper** (`IsProper D.hom`) + `Surjective abel.left` | `AbelSourceData.isProper` — **NOT delivered by DD-Q** (`DivSchemeQProj.lean:44-51`), a NEW brick | **Wave-5** (`AbelSource.lean`), gate `w5-av.p1` **BLOCKED** | NOT in `JacobianData` |

The boundary sits **exactly at the `JacobianData` field list** (`JacobianData.lean:96-100`):
it stores `locallyOfFiniteType` + `quasiCompact` and NOTHING else.  Separatedness of `d.J`
is derived group-theoretically off-datum (`JacobianData.isSeparated`, done);
universal-closedness/properness is derived off-datum by Wave-5's `isProper_of_abelSource`
(`AbelSource.lean:126`, done — *conditional* on the blocked `AbelSourceData` producer P1).
**DAT-J's qc is the LIGHT half** (compact source, DD-Q delivers); **Wave-5's properness is
the HEAVY half** (proper source = universal-closedness of the Grassmannian/`Div^g`, the
I-0245 boundary brick nobody has built).  DAT-J MUST route its qc through a *light* qc-Abel
source (compact `D` + surjective `abel`), NEVER through `AbelSourceData` (which drags in the
blocked properness).  This asymmetry is the single most important design pin of the node.

### §0.5 THE import-cycle constraint (the "genus-cycle"; producer must be Challenge-free)

**Found this pass, HIGH-VALUE, no prior worksheet records it.**  `Jacobian` and
`instGrpObj` are **`def`/`instance` sorries** (`Challenge.lean:96,107`), not `theorem`
sorries: a `def` body cannot be "proved elsewhere" — the discharge MUST edit `Challenge.lean`
and therefore **`Challenge.lean` must import the producer `jacobianData`**.  For that import
to typecheck, the producer's entire transitive cone must NOT contain `Challenge.lean`.  But:

* `riemann_inequality_curve` (`ChiCurve.lean:183`) — the *natural* effectivity export — is
  spelled with the frozen `genus`, and **`ChiCurve.lean` imports `Challenge.lean`**
  (`ChiCurve.lean:11`, verified).  A producer whose qc argument used it would create the
  cycle `Challenge → jacobianData → … → ChiCurve → Challenge`.
* **Resolution (BINDING for the qc brick):** DAT-J's surjectivity MUST use the
  **Challenge-free** effectivity `exists_effective_of_picClass` (`FLVClass.lean:208`, whose
  engine is the *genus-free* `riemann_inequality`, `FLVClass.lean:205/214`), and the
  fiberTwist degree shifter (`FiberTwist.lean:301`, `classDeg_fiberTwist:393`, **no rational
  point needed**).  `FLVClass.lean` and its cone are Challenge-FREE (verified: imports
  `FLVVanishing`/`ClassCohomology`/`ChiLedger`/`ChiSlice`/`MapToP1`/`FinitenessP1`).  The
  producer must also avoid `Cohomology/H1BaseFieldInvariance.lean` (the one Picard/Cohomology
  file that imports `Challenge`, verified).

**Corollary asymmetry with Wave-5:** Wave-5's P1 (`AbelSourceData` discharge) is a
*consumer* (downstream of `Challenge`, takes `d : JacobianData C`), so it MAY use
`riemann_inequality_curve`.  DAT-J's qc field is *upstream* of `Challenge` (imported by it),
so it may NOT.  Same surjectivity, opposite side of the `genus` cut.  **This constrains the
qc brick's spelling and is the node's #2 risk (§5).**

### §0.6 Transcription vs honest new work (the house scoreboard)

| piece | status | where |
|---|---|---|
| the whole `JacobianData` interface + consumer/base-change/group machinery | **LANDED** | §0.2, §1 |
| the ε⁺ shift tool `representableByOfShift` (NOT on the mainline) | **LANDED, unused here** | §1.4 |
| the qc substrate `compactSpace_divScheme` / `quasiCompact_divSchemeOverHom` (DD-Q) | **LANDED** | §2.2 |
| the effectivity + fiberTwist surjectivity substrate (Challenge-free) | **LANDED** | §2.3 |
| the abstract "compact surjective image ⇒ qc" lemma | **S, launchable NOW** | §2.4 |
| the qc field proper (Abel morphism surjective onto `\|J\|`) | **M**, `divRep`-gated (needs the descended `rep`) | §2.2–§2.3 |
| the producer `jacobianData C` (4-field packaging from DAT-G) | **S–M**, gated on DAT-G | §1.1, §4 |
| the frozen `Jacobian`/`instGrpObj` discharge (definitional) | **S**, gated on the producer | §3 |
| the `Jacobian.functor` map/laws discharge (bonus, via `pullbackHom`) | **S**, kit LANDED | §3.3 |

### §0.7 Launchability

* **Pre-divRep (launchable NOW):** (a) the abstract qc lemma DJ-0 (§2.4) — pure scheme
  topology, no `rep`; (b) the packaging skeleton DJ-2 *statement* — `PicRepDatum k k C`
  (`+` a qc proof) `→ JacobianData C`, typed against the landed `PicRepDatum`/`JacobianData`
  structs (`PicRepDatum.lean:89`, defeq `rep`-field confirmed `PicRepDatum.lean:144`); (c)
  the Challenge-free spelling audit of the effectivity/fiberTwist surjectivity chain (§2.3),
  no proof.  Nothing else — because everything else DAT-J would "assemble" is already
  landed.
* **Post-divRep / post-DAT-G (the assembly proper):** the qc field's surjectivity (DJ-1,
  needs the descended `rep` to build the Abel morphism `rep.homEquiv.symm`), the producer
  DJ-2 proof, and the discharge DJ-3 — all fire the day DAT-G hands over the `k`-level
  descent datum (itself `divRep` + coverage + DAT-glue/DAT-G0 gated).

### §0.8 Risks, ranked (details §5)

1. **The import-cycle / genus-cut constraint (high, structural).**  §0.5 — the qc argument
   must be spelled Challenge-free; a slip routes through `ChiCurve` → cycle at discharge.
2. **The whole producer is DAT-G-gated (high impact, externalised).**  DAT-G (pending,
   worksheet-unwritten) → DAT-glue/DAT-G0 → coverage → `divRep`.  DAT-J fires last.
3. **The properness boundary is NOT DAT-J's but is easily mis-scoped (medium).**  qc must
   use the LIGHT compact source, never `AbelSourceData` (blocked heavy source) — §0.4.
4. **The DAT-G handoff shape is not yet frozen (medium).**  §0.9 pins it as `PicRepDatum
   k k C`; DAT-G co-signs.  A shape drift moves DJ-2's one packaging line.
5. **Tower-diamond / universe-whnf bookkeeping at any residue-field instantiation (medium).**
   I-0255 (native `k`-algebra tower instances only, never a composite `letI`) / I-0249 —
   bites the surjectivity's field-point argument.

### §0.9 Standing context and the DAT-G handoff (the interface DAT-J consumes)

Standing pack: `{k}[Field k]`, `C : Over (Spec (.of k))`, `[SmoothOfRelativeDimension 1
C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` — exactly the `JacobianData C`
binder block (`JacobianData.lean:87-88`).  DAT-J consumes ONE handoff: **DAT-G's `k`-level
descent datum**, the finite-Galois/Speiser descent (`k' → k`, DAT-G charter) of DAT-glue's
`PicRepDatum k' C_{k'}`.  Its shape is exactly `PicRepDatum k k C` (`PicRepDatum.lean:89-100`
at `k' = k`, `C' = C`): fields `J : Over (Spec (.of k))`, `rep : (pic0TypeFunctor C
).RepresentableBy J`, `lft : LocallyOfFiniteType J.hom` — i.e. **`JacobianData C` MINUS the
`quasiCompact` field** (`PicRepDatum.lean:82-86` module note, verbatim).  The defeq is
machine-checked: `(pic0TypeFunctor C).RepresentableBy J` IS the `JacobianData.rep`-field
type with **no massage** (`PicRepDatum.lean:144-146` smoke test; `JacobianData.lean:93` =
`pic0TypeFunctor` def).  **DAT-J adds one field (qc) and packages.**  Whether DAT-G literally
outputs `PicRepDatum k k C` or an unbundled `(J, rep, lft)` triple is a DAT-G choice; either
way DAT-J's consumption is a named interface — pin it as **DJ-IN** and co-sign with DAT-G.

---

## §1 THE JacobianData ASSEMBLY STATEMENT PINS (verbatim, against the landed struct)

### §1.1 The structure and its four fields (`JacobianData.lean:87-100`, verbatim)

```lean
structure JacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Type (u + 1) where
  J : Over (Spec (.of k))
  rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J
  locallyOfFiniteType : LocallyOfFiniteType J.hom
  quasiCompact : QuasiCompact J.hom
```

The producer target (DJ-2):

```lean
-- DJ-2 (packaging; gated on DAT-G's DJ-IN handoff + DJ-1 qc):
noncomputable def jacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    JacobianData C where
  J   := (datGDatum C).J          -- DAT-G descent output (DJ-IN, = PicRepDatum k k C)
  rep := (datGDatum C).rep        -- defeq to JacobianData.rep (PicRepDatum.lean:144)
  locallyOfFiniteType := (datGDatum C).lft
  quasiCompact := quasiCompact_jacobian C   -- DJ-1, §2
```

Every symbol on the RHS except `datGDatum` (DAT-G) and `quasiCompact_jacobian` (DJ-1) is
landed.  The `rep :=` line needs NO adapter (§0.9 defeq).

### §1.2 The consumer API is landed — DAT-J adds nothing to it

`grpObj` (`:113-114`, `GrpObj.ofRepresentableBy d.J (pic0Functor C ⋙ forget₂ CommGrpCat
GrpCat) d.rep`), `homEquiv` (`:119-121`, `(T ⟶ d.J) ≃ pic0Subgroup C T`), `homEquiv_comp`
(`:126-129`), `uniqueUpToIso` (`:134-135`), `homEquiv_uniqueUpToIso_hom` (`:139-144`).
These are the Wave-5/6/7 consumption surface; the JacobianData.lean docstring (`:29`) freezes
extensions as **additive only**.  **DAT-J does not touch this file** except (if needed) an
additive lemma — and none is needed: the producer only *supplies* a `JacobianData C`, it does
not re-derive the accessors.

### §1.3 The Wave-7 base-change transport is landed (records that DAT-J's output flows straight into Wave 7)

`JacobianData.baseChange` (`JacobianDataBaseChange.lean:59-76`), `grpObjObj_baseChange_eq`
(`:199`), `baseChangeIsoOfData` (`:227-253`); the Abel-Jacobi compat
`baseChange_ofCurve_data_of_core` (`JacobianDataBaseChangeAbel.lean:143`) reduced to the
externalised `hCore` (`:108-113`, the base-field θ-shuffle-on-graph, **W7-K1's debt, NOT
DAT-J's**, `informal/w7-k1-worksheet.md` §3 Leg 4).  Consequence: once `jacobianData C`
exists, the frozen Wave-7 `baseChangeIso`/`baseChange_ofCurve` (`Challenge.lean:244,278`)
discharge by instantiating these at `d := jacobianData C`, `dL := jacobianData C_L`
(`JacobianDataBaseChangeAbel.lean:140-141`, definitional).  **This is Wave-7's discharge, not
DAT-J's — but DAT-J's producer is its sole missing input.**  Flag it so the endgame reads
correctly: `jacobianData C` unblocks four frozen Wave-7 declarations at once.

### §1.4 The ε⁺-shift is NOT on DAT-J's mainline (risk-6 discharge; record to prevent double-shift)

Datum-worksheet §5 risk 6 and §2.4 warned that a `pic^d`-coset spelling would poison
`ofRepresentableBy`.  It does not, because **the shift lives inside DAT-C's `chartValue`,
not at assembly**: `chartValue` already lands in `pic0Subgroup` directly
(`chartValue_mem_pic0Subgroup`, `DivSchemeAbel.lean:382-387`, verified — the three degrees
`n + deg Z − m·d₁` net to 0 under the chart-index constraint).  So the 01JJ output is
`pic0TypeFunctor.RepresentableBy` verbatim (datglue §1.4), DAT-G descends *that*, and DAT-J's
`rep` field is already degree-0.  **`representableByOfShift` (`ThetaShift.lean:225-229`) is
NOT consumed by DAT-J** — it remains a fallback tool only.  Record: **DAT-J does no shifting.**
(If a future spelling ever fed DAT-J a `picDegLayerFunctor`-shaped rep, `representableByOfShift
C L₀ m` transports it — but the landed chart architecture does not.)

---

## §2 THE qc-VIA-ABEL-IMAGE MECHANISM (the node headline)

### §2.1 Why `d.J` is NOT quasi-compact from the glue

`d.J.left` is 01JJ's `(glueData hf).glued` over the **infinite** `ChartIndex C = (m, Σ)`
(`Type u`; datglue §3.2, datc §3.2).  An infinite open cover glues to a non-compact space in
general — qc is **not** free from the assembly.  It is a posteriori, exactly as the datum
storing `quasiCompact` as a *field* (not deriving it structurally) signals.

### §2.2 The a-posteriori argument (compact `Div^g` + surjective Abel; the field docstring, verbatim)

`JacobianData.lean:97-98` freezes the mechanism: *"a posteriori: `|J|` is the image of a
quasi-compact divisor scheme under the Abel map."*  Precisely, to prove `QuasiCompact J.hom`
with affine base `Spec (.of k)` it suffices to prove `CompactSpace J.left` (the in-tree
pattern `HasAffineProperty.iff_of_isAffine.mpr`, used verbatim at
`DivSchemeQProj.lean:86-88` for `grPair`).  Then:

1. **The source is compact.**  `compactSpace_divScheme` (`DivSchemeQProj.lean:194-195`,
   LANDED, I-0245) — `DivScheme g` is a closed subscheme of the finite-affine-atlas
   Grassmannian pair, hence `CompactSpace`.  (qc of its structure map:
   `quasiCompact_divSchemeOverHom` `:188-190`.)
2. **The Abel map is a morphism `Div^g → J`.**  `abel := d.rep.homEquiv.symm (μ)` where `μ`
   is the universal degree-`g` divisor-family class shifted into `pic0Subgroup` by the
   fiberTwist shifter (§2.3).  Its underlying `abel.left : DivScheme.left → J.left` is
   continuous (`Scheme.Hom.continuous`).
3. **The Abel map is surjective on points** (§2.3).  `Surjective abel.left`.
4. **Image of compact under continuous surjective is compact** — so `CompactSpace J.left`
   (DJ-0, §2.4).  Hence `QuasiCompact J.hom`.

### §2.3 The surjectivity: effectivity + fiberTwist, spelled Challenge-FREE (the honest brick DJ-1)

Every field point of `J.left` is (via a residue-field point through `homEquiv`) a degree-0
class `λ ∈ pic0Subgroup C (overSpec k K)`.  Shift it by `fiberTwist`:

* `fiberTwist π n` (`FiberTwist.lean:301`), `classDeg_fiberTwist` (`:393`) — degree scales
  linearly, **no `k`-rational point required** (AbelSource docstring `:62`).  Choose `n`
  large so `deg(λ·θ^n) = n·d₁ ≥ g`.
* `exists_effective_of_picClass` (`FLVClass.lean:208`) — a class of degree `≥` the
  genus-free bound has an **effective** representative (its engine is `riemann_inequality`,
  `FLVClass.lean:205/214`, the **genus-FREE** spelling).  The effective representative is a
  point of `Div^g`-lite hitting `λ·θ^n`, hence (un-shifting) `λ` is in the Abel image.
* **Challenge-free (BINDING, §0.5):** use `exists_effective_of_picClass`/`riemann_inequality`
  (FLVClass, Challenge-free cone), **NEVER** `riemann_inequality_curve`
  (`ChiCurve.lean:183`, which imports `Challenge.lean:11`).  This is the SAME surjectivity
  Wave-5's `AbelSourceData.surjective` field uses (`AbelSource.lean:60-69`) — but Wave-5 may
  spell it with `genus` (it is a consumer); DAT-J may not (it is upstream of `Challenge`).
* Base-change of surjectivity to every field is FREE: `MorphismProperty.IsStableUnderBaseChange
  @Surjective` (mathlib `PullbackCarrier.lean:431`, cited `AbelSource.lean:41`).

**DJ-1 is the node's one honest (but small, M-sized) new brick.**  It is *lighter* than
Wave-5's P1: it needs only `compactSpace_divScheme` + surjectivity, never the proper source.

### §2.4 The abstract qc lemma (DJ-0 — launchable NOW, no `rep`)

The reusable core, pure scheme topology, no `divRep`:

> **DJ-0.**  For `f : X ⟶ Y` of schemes with `[CompactSpace X] (hf : Function.Surjective
> f.base)`, `CompactSpace Y`.  (Then, for `g : Y ⟶ Spec (.of k)` with `Y` affine base:
> `QuasiCompact g` via `HasAffineProperty.iff_of_isAffine.mpr`, the `DivSchemeQProj.lean:88`
> pattern.)

Route: `IsCompact.image` / `CompactSpace` of a continuous surjective image (mathlib
`Topology/*`); the in-tree twin for the irreducible analogue is `Function.Surjective.
irreducibleSpace` (`Topology/Irreducible.lean:540`, used `AbelSource.lean:157`) and the qc
analogue `QuasiCompact.compactSpace_of_compactSpace` (used `DivSchemeQProj.lean:82,145`).
**DJ-0 is a `≤ 60`-line mathlib-only brick; write it cold today** as the qc field's engine.

### §2.5 The light-vs-heavy split, restated as the discipline

`quasiCompact` (DAT-J) ← `compactSpace_divScheme` (DD-Q, LANDED) + DJ-1 surjectivity.
`IsProper` (Wave-5) ← `AbelSourceData` whose `isProper` field needs universal-closedness of
`Div^g`/`grPair` — **NOT delivered by DD-Q** (`DivSchemeQProj.lean:44-51`, I-0245 boundary),
a NEW Wave-5 brick, gate `w5-av.p1` **BLOCKED**.  **DAT-J must never import that debt into
its qc field** (§5 risk 3).

---

## §3 THE "…" TAIL: DISCHARGE OF THE FROZEN `Jacobian` AND `instGrpObj`

### §3.1 What the "…" is (read from the roadmap node + the datum worksheet)

The roadmap node title (verbatim JSON): *"DAT-J: JacobianData assembly — quasi-compactness
via the Abel image of Div^g-lite; discharge of the frozen `Jacobian` and `instGrpObj`."*
So the truncated tail is **"the frozen `Jacobian` and `instGrpObj`"** — the two
archon-protected def/instance sorries of `Challenge.lean`:

* `Jacobian (C) … : Over (Spec (.of k)) := sorry` — `Challenge.lean:96-99`.
* `instGrpObj : GrpObj (Jacobian C) := sorry` — `Challenge.lean:107-108`.

(datum-worksheet §1.4 consumption map, verbatim: `Jacobian` "discharged: `(jacobianData
C).J` (definitional)"; `instGrpObj` "discharged: `(jacobianData C).grpObj = GrpObj.
ofRepresentableBy`.")

### §3.2 The discharge is definitional (DJ-3)

```lean
-- Challenge.lean:96-99  (body edit; signature FROZEN, archon-protected)
noncomputable def Jacobian (C : …) … : Over (Spec (.of k)) := (jacobianData C).J

-- Challenge.lean:107-108
noncomputable instance instGrpObj : GrpObj (Jacobian C) := (jacobianData C).grpObj
```

With `Jacobian C := (jacobianData C).J`, `(jacobianData C).grpObj : GrpObj (jacobianData
C).J` is DEFINITIONALLY `GrpObj (Jacobian C)` (`JacobianData.lean:26-28`; the η-defeq smoke
tests `:167-182` are the machine-checked guarantee that `Over.mk d.J.hom ≡ d.J` and that the
group instance keys at the frozen spelling).  **No transport lemma, no choice, no `Nonempty`**
— the JacobianData.lean docstring `:82-83` freezes this ("NEVER a sorried instance, NEVER
`Nonempty` + choice").

### §3.3 The `Jacobian.functor` discharge (bonus; the kit is LANDED)

Although the node title names only `Jacobian`/`instGrpObj`, the *same producer* discharges
`Jacobian.functor`'s `map`/`map_id`/`map_comp` sorries (`Challenge.lean:153-158`) — the kit
is already built (`Pic0PullbackGrp.lean:41-58`, LANDED): `map f := pullbackHom (jacobianData
X.unop.carrier) (jacobianData Y.unop.carrier) f.unop`, `map_id := pullbackHom_id …`,
`map_comp := pullbackHom_comp …`.  **Record it in DJ-3's scope** (it is "pure instantiation",
Pic0PullbackGrp docstring `:41-58`): the producer unblocks it for free.  The remaining frozen
`Challenge.lean` sorries — `smoothOfRelativeDimension_genus` (`:112`, Wave-5 s3),
`instIsProper` (`:116`, Wave-5 p3), `instGeometricallyIrreducible` (`:120`, Wave-5 g1),
`ofCurve`/`comp_ofCurve` (`:125,130`, degree/Wave-6), `exists_unique_ofCurve_comp` (`:141`,
Wave-6), `baseChangeIso`/`_id`/`_comp`/`baseChange_ofCurve` (`:244-283`, Wave-7) — are
**explicitly NOT DAT-J's** (they consume `jacobianData C` but are owned by the named waves;
datum-worksheet §1.4).  DAT-J owns the definition; the waves own the properties.

### §3.4 The import-cycle constraint restated (BINDING for DJ-2/DJ-3 file placement)

`Challenge.lean` currently imports only `Mathlib` + `Cohomology/ModuleKSheaf` (`:6-7`).  DJ-3
adds `import AlgebraicJacobian.Picard.<jacobianData file>`.  For this to typecheck the
producer's whole cone must be **Challenge-free** (§0.5).  Verified feasible: the interface
files `JacobianData.lean`, `PicRepDatum.lean`, `ThetaShift.lean`, `DivSchemeAbel.lean`,
`DivSchemeQProj.lean`, `FLVClass.lean` are all Challenge-free; the ONLY landed
`Picard`/`Cohomology` file that imports `Challenge` is `H1BaseFieldInvariance.lean` (Wave-5
X3) — the producer must not need it.  **Place `jacobianData` in a new Challenge-free file
`Picard/JacobianDataProducer.lean`** (§4); do the discharge in `Challenge.lean`.  **A single
`ChiCurve` import anywhere in the producer cone breaks the discharge** — this is risk #1.

---

## §4 FILE PLAN, SIZES, GATES, LANE ORDER

Discipline inherited in full (`informal/protocol-concurrent-lanes.md` §1 private-index+CAS,
own paths only; mkdir lake mutex; `≤ 500 L`; one heavy declaration per unit; `lean_verify`
on keystones = `[propext, Classical.choice, Quot.sound]`; no sorried instances, no
`Nonempty`-smuggling — the producer is a plain `def`).  Gotcha lists REQUIRED READING before
any heavy proof: **I-0255 tower-diamond wall** (native `k`-algebra tower instances only;
bites the §2.3 field-point argument), **I-0249 universe-whnf**, I-0236(c)/I-0237(a)
(term-mode over `rw` on glueData/cover composites).

| # | file (new) | contents | size | gated by | launchable-when |
|---|---|---|---|---|---|
| DJ-0 | `Picard/CompactImageQc.lean` | §2.4: `CompactSpace`-of-surjective-image + `QuasiCompact` corollary over an affine base (mathlib-only, Challenge-free) | S (`≤ 60L`) | none | **NOW** |
| DJ-1 | `Picard/JacobianQuasiCompact.lean` | §2.2–§2.3: the Abel morphism `rep.homEquiv.symm` of the fiberTwist-shifted universal class + Challenge-free surjectivity (`exists_effective_of_picClass`) + qc of `J` via DJ-0 | M | DJ-0; DAT-G handoff (`rep`); DD-Q (LANDED) | statement NOW; proof post-DAT-G |
| DJ-2 | `Picard/JacobianDataProducer.lean` | §1.1: `jacobianData C : JacobianData C` — 4-field packaging (`J`/`rep`/`lft` from DJ-IN, `quasiCompact` from DJ-1).  **Challenge-free cone (§3.4).** | S | DJ-1; DAT-G (DJ-IN) | statement NOW; proof post-DAT-G |
| DJ-3 | `Challenge.lean` (body edits only) | §3.2/§3.3: discharge `Jacobian := (jacobianData C).J`, `instGrpObj := …grpObj`, `functor.{map,map_id,map_comp}` via `pullbackHom` (kit LANDED) | S | DJ-2; import wiring (§3.4) | post-DJ-2 |

**Lane order.**  `DJ-0` (now) ∥ [DJ-2 packaging *statement* + DJ-IN co-sign with DAT-G, now]
→ `[divRep F5–F7] → [DAT-C C9 + DAT-B B-6] → [DAT-glue → DAT-G0 → DAT-G descent]` →
`DJ-1 proof → DJ-2 proof → DJ-3 discharge`.  **Only DJ-0 and the DJ-2/DJ-IN statements are
launchable pre-divRep**; the assembly proper is a bounded transcription the day DAT-G hands
over the `k`-level datum.

**Consumption map (who cites what).**

| DAT-J deliverable | consumer |
|---|---|
| `jacobianData C` (DJ-2) | frozen `Jacobian`/`instGrpObj`/`functor` (DJ-3); Wave-5 P1/s3/p3/g1; Wave-6 Albanese; Wave-7 `baseChangeIso`/`baseChange_ofCurve` (via the landed `JacobianDataBaseChange*`) |
| the qc field (DJ-1) | `JacobianData.quasiCompact` (stored); Wave-5 `IsProper` (as the qc constituent, `AbelSource.lean:126` "quasi-compactness is implied") |
| DJ-0 (compact-image qc) | DJ-1; reusable infrastructure |

---

## §5 HONEST RISKS — ranked, with the Wave-5 properness boundary

1. **⚠ The import-cycle / genus-cut constraint (high, structural — §0.5/§3.4).**  The
   producer must be Challenge-FREE (the `Jacobian`/`instGrpObj` def-sorries force
   `Challenge.lean` to import it).  A single `ChiCurve`/`riemann_inequality_curve`/
   `H1BaseFieldInvariance` in the producer cone → cycle at discharge.  **Mitigation:** the
   qc surjectivity uses `exists_effective_of_picClass`/`riemann_inequality` (FLVClass,
   Challenge-free, verified); DJ-2 lives in a fresh Challenge-free file; audit the cone
   before the DJ-3 edit.  This is the one risk unique to DAT-J and nobody's scoreboard
   carried it.
2. **⚠ The whole producer is DAT-G-gated (high impact, externalised).**  DAT-G (pending,
   worksheet-unwritten) → DAT-glue/DAT-G0 (the XL mountain, datglue §3.3) → coverage
   (DAT-B B-6) + charts (DAT-C C9) → `divRep` (F5–F7, NOT landed).  DAT-J fires last of the
   datum tail.  **Mitigation:** DJ-0 + the DJ-2/DJ-IN statements are `divRep`-free and
   type-check against landed structs today; the DAT-G handoff is frozen as `PicRepDatum k k
   C` (§0.9) so DAT-J and DAT-G can co-sign before either builds.
3. **⚠ The properness/universal-closedness boundary — NOT DAT-J's, but easily mis-scoped
   (medium).**  **`JacobianData` stores only `lft` + `quasiCompact`** (`JacobianData.lean:96-100`).
   Separatedness of `d.J` is off-datum (`JacobianData.isSeparated`, LANDED).
   **Universal-closedness → properness is Wave-5's**, via `AbelSourceData` +
   `isProper_of_abelSource` (`AbelSource.lean:126`, LANDED-conditional) — and its producer
   P1 needs the source `Div^n` to be **proper** (`AbelSourceData.isProper` field,
   `AbelSource.lean:94`), i.e. **universal closedness of the Grassmannian/`Div^g`, which
   DD-Q does NOT deliver** (`DivSchemeQProj.lean:44-51`, I-0245) — a NEW brick, gate
   `w5-av.p1` **BLOCKED**.  **The boundary:** DAT-J's qc uses the LIGHT source (compact
   `Div^g`, DD-Q LANDED); Wave-5's properness uses the HEAVY source (proper `Div^g`, unbuilt).
   Same Abel morphism, same surjectivity, different source-strength.  **DAT-J must route qc
   through a light qc-Abel source (compact + surjective), NEVER through `AbelSourceData`**
   (which drags in the blocked properness).  Record: the properness sorry `Challenge.lean:116`
   is Wave-5 p3's, downstream of both DAT-J's `jacobianData` AND the blocked P1.
4. **The DAT-G handoff shape is unfrozen (medium).**  §0.9 pins DJ-IN = `PicRepDatum k k C`
   (= JacobianData-minus-qc, defeq `rep` field confirmed).  A DAT-G output-shape drift moves
   DJ-2's `J`/`rep`/`lft` lines only — bounded.  Co-sign with the (unwritten) DAT-G worksheet.
5. **Tower-diamond / universe bookkeeping (medium).**  The §2.3 surjectivity argument forms
   residue-field points `overSpec k K` over towers — **I-0255**: native `k`-algebra tower
   instances only, never a composite `letI RingHom.toAlgebra` (whnf non-termination at 1e6
   heartbeats); **I-0249** universe-whnf.  Mitigation: reuse the DAT-B collapse's native-tower
   instances (`PicEtAffFieldCollapse.lean`, I-0255).
6. **The ε⁺ double-shift trap (low, discharged).**  §1.4 — the shift is inside DAT-C's
   `chartValue` (`DivSchemeAbel.lean:382`); DAT-J does NO shifting; `representableByOfShift` is
   a fallback tool only.  Record to prevent a second shift at packaging.
7. **Scope guard (recorded to prevent creep).**  NOT DAT-J's: the interface / consumer API /
   base-change transport / group structure (ALL LANDED, §0.2 — consumed, never rebuilt); the
   `hCore` Leg-4 identity (W7-K1); properness/universal-closedness/`AbelSourceData` producer
   (Wave-5 p1); smoothness (Wave-5 s-chain); the Albanese universal property (Wave-6);
   `ofCurve`/Abel-Jacobi (degree lane / Wave-6); the 01JJ glue, `PicRepDatum`, DAT-G0
   transfer, finite-Galois descent (DAT-glue/DAT-G); the chart `chartValue`/effectivity
   coverage (DAT-C/DAT-B); `divRep` (F5–F7).

---

*End of worksheet.  Deliverable of record for `AJCR.w4-rep.datum.dat-j`.  To echo to the
orchestrator: (1) the `JacobianData` INTERFACE + its consumer/base-change/group machinery are
ALL LANDED (§0.2) — DAT-J is a small producer + one qc brick + a definitional discharge, NOT
"M assembly"; (2) the node's "…" tail is the two archon-protected def-sorries `Jacobian`/
`instGrpObj` (`Challenge.lean:96,107`), discharged definitionally as `(jacobianData C).J`/
`.grpObj` (§3), and the producer ALSO unblocks `Jacobian.functor` (kit landed) and four Wave-7
declarations for free; (3) the qc field is the LIGHT Abel-image argument (compact `Div^g` +
surjectivity), strictly weaker than Wave-5's blocked properness (proper `Div^g`) — the
properness/universal-closedness boundary sits exactly at the `JacobianData` field list, and
`AbelSourceData.isProper` is the I-0245 unbuilt brick; (4) the qc surjectivity MUST be spelled
Challenge-FREE (`exists_effective_of_picClass`, not `riemann_inequality_curve`) or the
`def`-sorry discharge cycles through `ChiCurve → Challenge` — the node's #1 risk; (5) DJ-0
(compact-image qc) and the DJ-2/DJ-IN statements are launchable cold today; the assembly
proper is bounded the day DAT-G descends the `k`-level datum (divRep + coverage + DAT-glue/
DAT-G0 gated).*
