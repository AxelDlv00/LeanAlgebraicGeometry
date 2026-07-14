# Brick deg-D4 (`graphLocalEquations`) — Stage-0 feasibility recon (`AJCR.picard.degree`)

*Read-only recon, 2026-07-14. Produced by the deg-D4 implementation session after the mandatory
Stage-0 feasibility gate (charter of gap G-D4, `degree-pic0-recon.md` §3; design §2.6(b) of
`wave3-picard-design.md`). Nothing in the Lean tree was edited. Every signature below is verbatim
with `file:line`; Mathlib paths are under
`.lake-packages/mathlib/Mathlib/`, project paths under `AlgebraicJacobian/`.*

---

## 0. Verdict — RECON-LANDED (gate not passed)

**`graphLocalEquations` is a campaign, not a bounded brick.** The mathematical heart the charter
names — *"a section of a smooth morphism of relative dimension 1 into a separated scheme is an
effective Cartier divisor, locally cut by ONE regular equation"* — has **zero scheme-level support in
Mathlib v4.31** and no in-tree substrate beyond the point-divisor case (which is a curve-over-a-field
DVR argument that does **not** transfer to the relative situation). Specifically, grep-verified this
session:

- **No `EffectiveCartierDivisor`** anywhere in Mathlib (`grep -rln EffectiveCartierDivisor` empty).
  The project's own `Scheme.LocalEquations` (`Picard/DivisorClass.lean:112`) *is* the ad-hoc stand-in;
  there is no Mathlib theory to lean on.
- **No `RegularImmersion` / `IsRegularImmersion`** anywhere in Mathlib (`grep` empty). The classical
  route "section of smooth ⇒ regular immersion of codimension = relative dimension ⇒ Cartier" has no
  first step.
- **No scheme-level relative differentials / conormal / cotangent module.** `Mathlib/AlgebraicGeometry`
  has no `*differ*`, `*cotangent*`, `*conormal*`, `*Kahler*` file (`find` empty). The conormal-of-the-
  section-is-invertible fact — the engine that makes the ideal locally principal — cannot be stated,
  let alone proved, without first building this substrate.
- **`LocalEquations.pullback` / `picClass_pullback` do not exist** (grep of `Picard/` empty; only the
  *cover*-level `PointedCover.pullback` and `pullbackUnitsCocycle`/`pullbackUnitsH1` exist,
  `UnitsCocycle.lean:137,249,345`). The base-change deliverable `graphLocalEquations_base_change`
  therefore has no substrate lemma either; and (see §4) the naive pullback lemma is **false without a
  flatness/regularity side-condition** — exactly the subtlety the design flags.

The route to the one-regular-equation statement needs **far more than two bounded lemmas of real
substance**: it is a new scheme-level "effective Cartier divisor / regular immersion of a section"
theory built on the ring-level Kähler substrate, or an equivalent hands-on standard-smooth-chart
campaign (§4). Per the charter gate ("if it smells like a campaign — the project has twice seen 'one
lemma' balloon — STOP and write the recon"), this session lands the recon. **The Lean tree was not
touched; it remains green.** deg-D1 (`pointDivisor`, `divisorClass`) *did* land since the parent
recon (`Picard/PointDivisor.lean`, imported at `AlgebraicJacobian.lean:35`) and is a useful template
for the gluing (§4, step 4) but not for the hard core.

---

## 1. The precise mathematical statement needed

Standing context (the curve bundle; `k` the base field, `C : Over (Spec (.of k))` with
`[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible/Reduced C.hom]`,
`T : Over (Spec (.of k))` an arbitrary test object). Write `p := (C ⊗ T).left` for the total space of
the product, `snd C T : C ⊗ T ⟶ T` the projection, and for `t : T ⟶ C`

```
Over.sectionOfPoint t : T ⟶ C ⊗ T,   sectionOfPoint t ≫ snd C T = 𝟙 T
```
(`Picard/Rigidification.lean:85,93` — **landed**). The **graph** `Γ_t` is the image of
`(sectionOfPoint t).left : T.left ⟶ p`; it is a closed subscheme of `p` because `snd C T` is
separated (`C/k` proper ⇒ `snd` separated by base change) and a section of a separated morphism is a
closed immersion.

**Deliverable target (charter, design §2.6(b)):**

```lean
def graphLocalEquations (t : T ⟶ C) : ((C ⊗ T).left).LocalEquations           -- Γ_t, locally 1 eqn
theorem graphLocalEquations_base_change (g : T' ⟶ T) (t : T ⟶ C) : … -- Γ_{g ≫ t} = pullback of Γ_t
-- (deferrable) rank-1 certificate: 𝒪_{Γ_t} ≅ 𝒪_T   (deg 𝒪(Γ_t) = 1 downstream, via E-i)
```

To produce a `Scheme.LocalEquations` value (`DivisorClass.lean:112`) one must supply, **verbatim**:
`cover : p.PointedCover`; `eqn : ∀ x, Γ(p, cover.opens x)`; `regular` (the germ of `eqn x` at *every*
point of `cover.opens x` is a nonzerodivisor in the stalk); `ratio_isUnit` (on every overlap the two
equations differ by a unit). The mathematical content is entirely in producing, **for each point
`z ∈ Γ_t`**, an open `V ∋ z` and a single section `f ∈ Γ(p, V)` such that:

1. **(generation)** `f` generates the ideal sheaf of `Γ_t` on `V` — `Γ_t ∩ V = V(f)` scheme-
   theoretically; and
2. **(regularity)** the germ of `f` is a nonzerodivisor in `𝒪_{p,y}` for every `y ∈ V`.

Off the graph, `eqn = 1` (as in `pointDivisor`). (1)+(2) together are precisely *"`Γ_t` is an
effective Cartier divisor"* — the statement with no Mathlib support.

**Why the point-divisor template does not reach it.** `pointDivisor` (`PointDivisor.lean:167`) works
because its ambient `X` is a curve **over a field** `K`, so `𝒪_{X,x}` is a **DVR**
(`isDiscreteValuationRing_stalk`) and a uniformizer is directly a local generator, regular because a
DVR is a domain. In `graphLocalEquations` the ambient `p = (C ⊗ T).left` is a curve **over `T`** (`T`
arbitrary, e.g. `T = C` for `abelElement`), so stalks along `Γ_t` are **not** DVRs and there is no
uniformizer to reach for. The generator must come from *relative* geometry (the conormal of the
section, rank 1), and its regularity from *relative flatness* — both absent.

---

## 2. What exists — Mathlib substrate (ring level only)

The **only** relevant Mathlib support is ring-theoretic (Kähler differentials and standard-smooth
cotangent), one level below what is needed:

```lean
-- RingTheory/Kaehler/Basic.lean
abbrev KaehlerDifferential.ideal : Ideal (S ⊗[R] S) :=                                          -- :63
  RingHom.ker (TensorProduct.lmul' R : S ⊗[R] S →ₐ[R] S)     -- the diagonal ideal I; Ω[S⁄R] = I/I²
-- RingTheory/Smooth/StandardSmoothCotangent.lean  (SubmersivePresentation P of S/R)
noncomputable def basisCotangent : Basis σ S P.toExtension.Cotangent                            -- :144
instance free_cotangent : Module.Free S P.toExtension.Cotangent                                 -- :156
noncomputable def basisKaehler : Basis {…} S Ω[S⁄R]                                              -- :225
theorem rank_kaehlerDifferential [Nontrivial S] [Finite ι] : … = #σ                             -- :246
theorem IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential (n) : … = n                -- :313
```

For **relative dimension 1** the index set `σ` is a singleton, so `Ω[S⁄R]` and the conormal `I/I²` of
the diagonal are **free of rank 1** — this is the algebraic seed of "one equation." But it is a
statement about `I/I²`, *not* about `I` being principal (that needs Nakayama + local finiteness), and
says nothing about regularity of a generator (that needs flatness / a regular-sequence argument). And
it is a **ring/module** statement; lifting it to the sheaf `p = (C⊗T).left` requires either
scheme-level differentials (absent) or a per-chart hands-on argument (§4).

```lean
-- AlgebraicGeometry/Morphisms/Smooth.lean
class SmoothOfRelativeDimension : Prop where                                                    -- :135
  exists_isStandardSmoothOfRelativeDimension : ∀ (x : X), ∃ (U : Y.Opens) (_ : IsAffineOpen U)
    (V : X.Opens) (_ : IsAffineOpen V) (_ : x ∈ V) (e : V ≤ f ⁻¹ᵁ U),
    IsStandardSmoothOfRelativeDimension n (f.appLE U V e).hom
```
This is what `Curve/StalksDVR.lean` and `Curve/DedekindSections.lean` consume; it is the entry point
for any chart-based route, but it produces charts of `X/Y`, and for the graph one needs charts of the
**product** `(C ⊗ T)/T` — obtained by base-changing a chart of `C/k` along `T`, itself plumbing.

**Absent in Mathlib (grep-verified):** `EffectiveCartierDivisor`, `RegularImmersion`,
`IsRegularImmersion`, any `AlgebraicGeometry` differentials/conormal/cotangent file, "section of
smooth is a regular immersion", "diagonal of smooth is regular immersion of codim = rel dim",
"conormal of a section is invertible."

## 2′. What exists — in-tree substrate

```lean
-- Picard/DivisorClass.lean   (the LANDED (a)-constructor, 466 lines)
structure Scheme.LocalEquations (X : Scheme.{u})                                                -- :112
noncomputable def LocalEquations.picClass (d) : X.CechPic                                        -- :238
def LocalEquations.restrict / mul / rescale  (+ picClass_* simp lemmas)                          -- :260,333,413
-- Picard/PointDivisor.lean   (deg-D1, LANDED since the parent recon — the gluing TEMPLATE)
noncomputable def Scheme.pointDivisor (K) … {x} (hx : x ≠ genericPoint X) : X.LocalEquations     -- :167
noncomputable def Scheme.divisorClass (K) (D : X.CurveDivisor) : X.CechPic                       -- :279
-- Picard/Rigidification.lean   (the section machinery, LANDED)
noncomputable def Over.sectionOfPoint (σ : T ⟶ C) : T ⟶ C ⊗ T                                    -- :85
lemma Over.sectionOfPoint_snd / _fst / _naturality                                              -- :88,93,99
-- Picard/Pic.lean / RelPic.lean   (the class-level targets)
def CechPic.map (f : X ⟶ Y) : Y.CechPic →* X.CechPic                                             -- Pic.lean:198
def picFromBase (T) : Subgroup ((C ⊗ T).left.CechPic)  ;  relPicMk (T) : … →* relPic C T          -- RelPic.lean:54,70
-- Picard/UnitsCocycle.lean   (cover/cocycle-level pullback — NOT LocalEquations-level)
def PointedCover.pullback (f : X ⟶ Y) (𝒰 : Y.PointedCover) : X.PointedCover                       -- :137
def pullbackUnitsCocycle / pullbackUnitsH1                                                       -- :249,345
```

`sectionOfPoint`, `sectionOfPoint_naturality`, and `CechPic.map` are exactly the pieces the
**assembly and base-change** steps consume once the hard divisor is built. They are landed. The hard
divisor is not.

---

## 3. The gap, precisely

`graphLocalEquations` = **build an effective Cartier divisor from a section of a smooth-rel-dim-1
morphism**, then package it as `LocalEquations`. The gap is the entire chain, none of which exists:

- **G-D4.a — the conormal/generation fact.** On an affine chart of `(C ⊗ T)/T` through a graph point,
  the ideal `I(Γ_t)` is locally principal, generated by one element `f`. *Seed:* `I/I²` free rank 1
  (`basisCotangent`, rel-dim 1). *Missing:* Nakayama descent `I/I² free rank 1 ⇒ I principal near the
  section`, executed on the actual chart ring; **no scheme-level version exists**, and the ring-level
  version is not packaged either.
- **G-D4.b — regularity of the generator.** The germ of `f` is a nonzerodivisor in every stalk on the
  chart. *Classical reason:* `p → T` is flat and the graph is a relative divisor (fibres never
  contain a component), so `f` is a nonzerodivisor. *Missing:* no "section of flat + fibrewise regular
  ⇒ regular" lemma; would be a fresh regular-sequence/flatness argument.
- **G-D4.c — the pullback lemma `LocalEquations.pullback` + `picClass_pullback`.** Needed both to
  realise `Γ_t` as the pullback of the universal diagonal `Δ ⊂ (C ⊗ C).left` and to get
  `graphLocalEquations_base_change` for free from `CechPic.map` naturality. *Missing entirely*, and
  **not true in the naive form**: pulling back a regular equation along an arbitrary `f : X ⟶ Y` does
  **not** preserve `regular` (a nonzerodivisor can pull back to a zerodivisor). It is true only with a
  side-hypothesis (`f` flat, or the pulled-back germs assumed regular) — the design's parenthetical
  "regularity survives … *because Δ is a relative divisor*" is doing real work here.
- **G-D4.d — assembly + base change.** Glue the per-chart `(V, f)` (and `eqn = 1` off `Γ_t`) into a
  `PointedCover`-indexed `LocalEquations` (the `pointDivisor` bookkeeping template applies), then
  prove `graphLocalEquations_base_change` from `sectionOfPoint_naturality` + `picClass_pullback`.
- **G-D4.e — (deferrable) rank-1 certificate `𝒪_{Γ_t} ≅ 𝒪_T`.** As the charter permits, **defer**:
  it needs the E-i degree wiring and the closed-immersion/pushforward substrate (the section is an iso
  onto its image, `snd`-projecting isomorphically to `T`), which is a separate concern from the
  divisor construction and pulls in machinery this brick should not. Flag for a later brick.

---

## 4. Proposed brick decomposition

Two viable routes; both exceed the two-lemma budget. **Recommended: Route B (charts), no new
scheme-level differentials.**

**Route A — scheme-level "regular immersion / effective Cartier divisor of a section" theory.** Build
`AlgebraicGeometry`-level relative differentials + conormal, prove "conormal of a section of a smooth
morphism is locally free of rank = rel dim", specialise to rank 1 ⇒ ideal invertible ⇒ Cartier, then
extract `LocalEquations`. *This is a multi-file Mathlib-scale contribution* (it is the reason Mathlib
has neither yet). **Not recommended** for this project; huge blast radius.

**Route B — hands-on standard-smooth charts (mirrors `StalksDVR`/`pointDivisor` in spirit).**

1. **brick deg-D4a `LocalEquations.pullback`** (χ-independent, bounded): define
   `LocalEquations.pullback (f : X ⟶ Y) (d : Y.LocalEquations) (hreg : ∀ …, germ of pulled-back eqn ∈
   nonZeroDivisors) : X.LocalEquations` taking the regularity as an explicit hypothesis, with
   `picClass_pullback : (d.pullback f hreg).picClass = CechPic.map f d.picClass` from the landed
   `pullbackUnitsCocycle`/`pullbackUnitsH1`. **This is the one genuinely bounded, safe, reusable
   sub-lemma** — it can and should land first, on its own. (~120 lines.)
2. **brick deg-D4b `diagonalLocalEquations : (C ⊗ C).left.LocalEquations`** — the hard core. On a
   base-changed standard-smooth chart, take the étale coordinate `u` of the chart and set
   `f = u∘fst − u∘snd`; prove (G-D4.a) it generates `I(Δ)` locally via `basisCotangent` rank 1 +
   Nakayama, and (G-D4.b) regularity via flatness of the chart over the base. **Campaign-scale**:
   several substantial ring-level lemmas (diagonal ideal of a standard-smooth-rel-dim-1 algebra is
   principal + regular near the diagonal), plus the base-change plumbing to put the chart on
   `(C ⊗ C)/C`, plus the off-diagonal `eqn = 1` gluing. Spec **worksheet-first**. (~400+ lines,
   likely split further.)
3. **brick deg-D4c `graphLocalEquations` + base change** — realise `Γ_t` as the pullback of `Δ` along
   `(fst, t ∘ snd) : C ⊗ T ⟶ C ⊗ C` (so `Γ_t = preimage of the diagonal`), apply deg-D4a to
   deg-D4b, and derive `graphLocalEquations_base_change` from `sectionOfPoint_naturality`. Bounded
   **once deg-D4a/b land**. (~200 lines.)

Dependency: deg-D4a ⟂ (independent, land now) ; deg-D4b (hard core) ; deg-D4c needs both. The
downstream consumer `abelElement` needs only `graphLocalEquations` on `T = C` and its `picClass`;
the rank-1 certificate (G-D4.e) is a separate deferred brick keyed to E-i.

---

## 5. Risk

This is the exact ballooning shape the charter warns of, and the recon's §5 hazard list already
flagged it ("whether the diagonal `Δ ⊂ (C⊗C).left` being a relative effective divisor is a short
mathlib-gift or a build — I could not verify from reading"). It is a **build**, and a large one:

- **The hard core (deg-D4b) is a genuine theorem, not a lemma.** "Diagonal ideal of a smooth-rel-dim-1
  algebra is locally principal and regular" is the local form of "smooth ⇒ diagonal is a regular
  immersion of codim = rel dim" — a real result. Mathlib's absence of `RegularImmersion` and
  scheme-level differentials is direct evidence it is not a one-liner. The rank-1 cotangent basis
  (`basisCotangent`) gives `I/I²`, but the jump to `I` principal (Nakayama, and pinning the generator
  to the *explicit* `u∘fst − u∘snd` rather than an abstract lift) and to regularity (flatness) are
  each their own substantial argument, on chart rings that must first be produced by base change.
- **The pullback lemma has a truth-condition, not just a proof-cost.** `LocalEquations.pullback`
  cannot be stated as "pull back and stay a `LocalEquations`" unconditionally — regularity fails for
  non-flat `f`. The relative situation supplies flatness, but only *because* `Δ` is a relative
  divisor; encoding that hypothesis correctly is part of the design, not an afterthought. A careless
  spec here would produce a false lemma.
- **Base-change plumbing is nontrivial even where the math is easy.** Putting a standard-smooth chart
  of `C/k` onto `(C ⊗ C)/C` (or `(C ⊗ T)/T`), and matching the section `sectionOfPoint t` to the
  diagonal preimage, is the kind of `⊗`/`Over`/`appLE` bookkeeping that has repeatedly been the
  time sink in this project (cf. the `SectionsBaseChange`/`UniversalSections` effort).

**Mitigations (recommended launch order).** (i) Land **deg-D4a `LocalEquations.pullback`** now as
standalone, safe, χ-independent infrastructure — it is the only bounded piece and unblocks D4c
mechanically. (ii) Spec **deg-D4b worksheet-first** (per the (C2) lesson), scoping the ring-level
"principal + regular diagonal ideal" lemmas explicitly before any Lean, and budget it as a
multi-brick campaign, not a single file. (iii) Keep the **rank-1 certificate deferred** to a post-E-i
brick. (iv) Do **not** attempt Route A (scheme-level differentials) inside this project.

*Net: `graphLocalEquations` as a single brick is infeasible under the two-lemma gate; the honest core
`diagonalLocalEquations` is a worksheet-first campaign. The one safe immediate win is
`LocalEquations.pullback`. Tree left untouched and green; deg-D1 (`pointDivisor`/`divisorClass`)
already landed and is the gluing template, not the core.*

---

*End of recon. Stage-0 gate outcome: RECON-LANDED (route to the one-regular-equation statement is a
campaign — no Mathlib `EffectiveCartierDivisor`/`RegularImmersion`/scheme differentials, and the
hands-on core `diagonalLocalEquations` alone busts the two-lemma budget).*
