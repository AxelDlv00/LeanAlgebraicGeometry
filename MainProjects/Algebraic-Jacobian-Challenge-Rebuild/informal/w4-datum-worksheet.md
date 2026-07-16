# Wave-4 w4-6 — the RepresentableBy DATUM: the binding worksheet (`AJCR.w4-rep` / w4-6)

*Written 2026-07-16 (Fable design agent). Route design per the (C2) lesson: decisions
first, provers only from specs derived from this worksheet. Models:
`informal/w4-rigid-engine-worksheet.md`, `informal/w4-flv-worksheet.md`,
`informal/deg-d5b-worksheet.md`. Inputs read in full: `informal/w4-datum-design.md`, the
landed carrier (`Picard/Pic0Functor.lean`, `Picard/DegreeZero.lean`), the landed engine
(`Cohomology/RigidEngine4{Assembly,AEval,Twist,Relative,Engine,BaseChange}.lean`,
`RigidEngine3Duality.lean`), the landed FLV stack (`RiemannRoch/{FLVClass,FLVFiberToolkit,
FiberTwist}.lean`), the closed degree lane (`RiemannRoch/{DegreeBaseChange,
DegreeBaseFieldInvariance,RelPicDegree,ChartColength,Degree}.lean`,
`Curve/BaseFieldTransition.lean`, `Cohomology/TransitionSectionsBaseChange.lean`), the
frozen targets (`AlgebraicJacobian/Challenge.lean`), `informal/w4-cbc-recon.md` §2,
`informal/degree-pic0-recon.md` §2.7, `informal/wave3-picard-design.md` §§4.5–4.6, 5,
6.2, and Kleiman `references/kleiman-picard-src/kleiman-picard.tex` (`sb:Q` 1897–1935,
`th:LinSys` 1963–2030, `th:main` statement 2155–2166 + proof 2168–2366, `lm:qt`
2368–2415). Old-draft campaign map (READ-ONLY lessons, never copied):
`MainProjects/Algebraic-Jacobian-Challenge/informal/pic-representability-campaign.md`
(D′/J/G clusters). GRQ feasibility certificate: `SubProjects/GR-Quot-Closure`
(`PROGRESS.md`: `Grassmannian.represents` sorry-free, axiom-clean — a ROUTE MAP; port,
never import). Mathlib claims verified by grep against the pinned checkout
(`.lake-packages/mathlib`, v4.31.0), cited `file:line`. No Lean edited; no build run.*

**STATE AT WRITING.** Every engine input of the w4-datum design §4 sequence is LANDED
and kernel-green: the carrier `pic0Functor C : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}`
(`Pic0Functor.lean:151`; membership `Iff.rfl` `:121`, `pic0Map_coe` rfl `:140`,
`pic0Inclusion` with `naturality := rfl` `:176`); the rigid engine Level 2 on the pinned
cover (`relTwistRigidEngine` `RigidEngine4Engine.lean:174`, openness `:194`, eq:Q
`:206`, abstract base change `:224`, fibre→pair wrapper `:240`) and the on-the-nose ring
clauses (`relTwistH0BaseChange` `RigidEngine4BaseChange.lean:471`,
`relTwist_subsingleton_h1_baseChange` `:445`); FLV with class form + rank anchor
(`FLVClass.lean:360,412`) and the dominance witness
(`exists_isFinite_isDominant_toP1`, `Curve/MapToP1.lean:125`); the fiber twist
(`FiberTwist.lean:301,306`); the full degree lane (E-iv-alg
`DegreeBaseFieldInvariance.lean:462`, `relPicDeg` `RelPicDegree.lean:61`, colength
dictionary `ChartColength.lean:126,278,411`, `degAff`/`degAff_mk`
`Picard/DegreeZero.lean:263,273`, transitions `Curve/BaseFieldTransition.lean` +
`TransitionSectionsBaseChange.lean:228`). NOT landed (grep-verified this pass): any
m-chart glued constructor (`TwistedSheaf.lean` is 2-chart only), W6-full, a Zariski-sheaf
statement for `picEt`/`pic0` beyond the affine basic-open half
(`PicEtAffZariskiGlue/Sep`), `JacobianData`/`Witness.lean`, `abelElement` (G-D8, degree
lane's next campaign), and every Stage-B/C/D brick below.

**VERDICT IN ONE LINE.** The datum is `JacobianData C` verbatim from design §5 — now
literally stateable on the landed `pic0Functor` — produced by the Milne-style
Σ-chart route run entirely on the landed engine: every chart, stratum, and covering
open on the route is an **H¹-fibrewise-vanishing locus at χ-normalized degree g**
(so `rigidEngine_isOpen_vanishing` is the only openness mechanism, Kleiman's Serre
passage and EGA IV 17.16.3(ii) are both retired), Kleiman's quotient lemma `lm:qt` is
bypassed by the h⁰ = 1 canonical-section charts, gluing is mathlib's 01JJ
`RepresentableBy` engine, and the two honest mountains that remain are Div^g-lite
representability (DAT-D) and the finite-Galois/Speiser descent of the datum (DAT-G) —
each mandated WORKSHEET-FIRST, everything else S/M/L bricks specced here.

---

## §1 THE DATUM SHAPE (obligation 1) — derived from Challenge.lean, verified against the checkout

### 1.1 D1 — `JacobianData C`, verbatim design §5 (DECIDED)

The frozen file never names `RepresentableBy` (its sorries are `Jacobian` at
`Challenge.lean:96–99`, `instGrpObj` `:107`, and consumers), so the constraint is the
§4.6 datum-flow table: `instGrpObj` must be `GrpObj.ofRepresentableBy`, and Waves 5–7
consume `rep` + certificates only. All typing verified against mathlib v4.31.0 this
pass:

```lean
structure JacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Type (u + 1) where
  J : Over (Spec (.of k))
  rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J
  locallyOfFiniteType : LocallyOfFiniteType J.hom
  quasiCompact : QuasiCompact J.hom
```

- `Functor.RepresentableBy` — mathlib `CategoryTheory/Yoneda.lean:284`;
  `RepresentableBy.uniqueUpToIso` `:343` (Wave-7's `baseChangeIso` mechanism).
- `GrpObj.ofRepresentableBy (F : Cᵒᵖ ⥤ GrpCat.{w}) (α : (F ⋙ forget _).RepresentableBy X)`
  — mathlib `CategoryTheory/Monoidal/Cartesian/Grp.lean:35`; applies verbatim with
  `F := pic0Functor C ⋙ forget₂ CommGrpCat GrpCat` (`forget₂ CommGrpCat GrpCat`:
  `Algebra/Category/Grp/Basic.lean:407`).
- The carrier is exactly the §2.7 binding shape (`degree-pic0-recon.md` §2.7, L9 dry-run
  PASSED): contravariant, `CommGrpCat.{u}`-valued, subgroup subfunctor of
  `picEtFunctor C` (`pic0Inclusion`, `Pic0Functor.lean:176`).

File: `Picard/JacobianData.lean` (structure + the `grpObj`/`homEquiv`/`uniqueIso`
consumers of design §5; the `forget₂ ⋙ forget` defeq massage owned there, once). The
final discharge of `Jacobian`/`instGrpObj` is definitional per design §5 — no choice, no
`Nonempty`, no sorried instance.

### 1.2 Universe/site bookkeeping (obligation 1, second half)

- **Smallness is already bought.** `picEt C T` is the Wave-3 affine-opens-limit vehicle
  (`Picard/PicEt.lean:9–36`), a `Type u` carrier; `pic0Subgroup C T`
  (`Pic0Functor.lean:107`) is a subgroup of it with the ∀-field-point membership
  `∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T), degAt lam t = 0`
  (`mem_pic0Subgroup_iff`, `:121`, `Iff.rfl`-transparent). No `Type (u+1)` value ever
  appears; `JacobianData` is `Type (u+1)` only because it stores a functor datum.
- **The gluing engine is mathlib 01JJ, on the big site.**
  `AlgebraicGeometry.Scheme.LocalRepresentability.representableBy`
  (mathlib `AlgebraicGeometry/Sites/Representability.lean:192`; `isRepresentable`
  `:207`) takes `F : Sheaf Scheme.zariskiTopology.{u} (Type u)`, a `Type u`-indexed
  family of relatively-representable open immersions `yoneda.obj (X i) ⟶ F.1`, jointly
  locally surjective — and returns an honest `RepresentableBy` datum (not `Nonempty`).
  Two site gaps to bridge, both pinned here:
  1. **Slice trick (DAT-6).** Our functor lives on `Over (Spec k')ᵒᵖ`. Pin the standard
     bridge: `F̃(T) := Σ (a : T ⟶ Spec k'), F(Over.mk a)` is a `Type u` Zariski sheaf on
     `Scheme.{u}` once F is a Zariski sheaf on the slice; 01JJ represents `F̃` by `J`;
     the universal element's Σ-component is `J.hom`, and `RepresentableBy` for `F` on
     the slice falls out by Σ-bookkeeping. Fallback (probe at spec time, prover's
     choice): hand-roll `Scheme.GlueData` from the chart family — mathlib's own 01JJ
     proof (`glueData`, `:68`) is the template.
  2. **The sheaf input (DAT-2, a real pre-brick).** `pic0Functor` must be certified a
     Zariski sheaf: separation and gluing for arbitrary Zariski covers of arbitrary
     tests. Substrate landed: the affine basic-open halves
     (`PicEtAffZariskiGlue.lean`, `PicEtAffZariskiSep.lean`) and the limit vehicle +
     (C1)-licensed restriction maps (`PicEtMap.lean:15–23`). Degree-0 stability under
     the gluing is free: a field point `t : overSpec k K ⟶ T` topologically lands in
     one member of any open cover, so `degAt` membership is Zariski-local (S-lemma
     inside DAT-2).

### 1.3 The staged equivalents (campaign-internal, not consumer-facing)

The campaign builds `rep` in stages; pin the two intermediate carriers now so brick
specs are stable:

- **(chart datum, Stage B)** per chart index `c = (m, Σ)`: a quasi-projective `k'`-scheme
  `J_c`, a monomorphism of functors `yoneda(J_c) ⟶ pic0Functor (C_{k'})·θ-shift` whose
  fibre products with every test are OPEN subschemes (the 01JJ `hf` shape), plus the
  quasi-projectivity certificate (locally closed in a ported Grassmannian).
- **(k'-level datum, Stage C)** `PicRepDatum k' : J', rep'` for `pic0Functor (C_{k'})`
  — the same `JacobianData` shape instantiated at base `k'` (Challenge.lean's own
  base-change instances `:174–187` make `C_{k'} := (baseChange k k').obj C` a legal
  curve over `k'`), plus the finite Γ-equivariant chart bookkeeping DAT-G consumes.

### 1.4 Consumption map — which frozen declarations this campaign discharges or feeds

| Frozen declaration (`Challenge.lean`) | Relation to the datum |
|---|---|
| `Jacobian` `:96–99` | **discharged**: `(jacobianData C).J` (definitional) |
| `instGrpObj` `:107` | **discharged**: `(jacobianData C).grpObj` = `GrpObj.ofRepresentableBy` |
| `ofCurve` `:125`, `comp_ofCurve` `:130` | **fed**: `rep.homEquiv.symm (abelElement P)`; `abelElement` is G-D8 (degree lane, graph + point classes landed, `Curve/GraphDivisor.lean:242`) — NOT owned here; gates on nothing here beyond `rep` |
| `smoothOfRelativeDimension_genus` `:112`, `IsProper` `:116`, `GeometricallyIrreducible` `:120` | Wave 5, consuming `rep` + the two certificates (properness = qc + lft + separatedness + valuative; separatedness group-theoretic per design §5) |
| `exists_unique_ofCurve_comp` `:141` | Wave 6 (Albanese), consuming `rep` |
| `functor` `:153`, `baseChangeIso` `:244` + coherences `:253,:262`, `baseChange_ofCurve` `:278` | Wave 7, consuming `jacobianData` at every curve + the deg-d5b §3 inheritance (`isPullback_baseFieldTransition` inputs stated generally, `classDeg_map_iso` planned there) |

---

## §2 THE ROUTE (obligations 2, 5) — four stages, one openness mechanism

### 2.1 The architecture (DECIDED) and what is bypassed

**Milne-style Σ-charts, exactly the route-decision Wave-4 pin** (route-decision.md item
12; old-draft judged D3 map, D′/J/G clusters — lessons only). Kleiman's own endgame —
`Z ×_P Z = ℙ(Q)` and the quotient lemma `lm:qt` (tex 2359–2366, 2368–2415: flat proper
equivalence relations effective via `Hilb`, AK80 2.9) — is **bypassed**: the charts are
loci where the Abel fibration has a *canonical section* (h⁰ = 1 normalization), so no
quotient of an equivalence relation is ever formed. Stages:

- **Stage A (relative engine on arbitrary classes — pre-bricks, launchable NOW).**
  The m-chart glued constructor + its engine discharge (DAT-1), the seams (DAT-2..5),
  the twist normalization closure (DAT-0b), P5-uniform (DAT-0a), sections↦divisors
  (DAT-A), separably-closed points (DAT-P).
- **Stage B (charts over a field).** Div^g-lite (DAT-D, worksheet-first), the Σ-charts
  and their open-subfunctor certificates (DAT-C), coverage + injectivity (DAT-B).
- **Stage C (glue).** 01JJ assembly over a finite separable `k'` (DAT-glue).
- **Stage D (descent + assembly).** Finite-Galois/Speiser descent of the datum (DAT-G,
  worksheet-first), `JacobianData` assembly + qc certificate + frozen discharge (DAT-J).

**The one-openness-mechanism discovery (binding).** Every open condition on this route
is the fibrewise H¹-vanishing locus of a glued sheaf whose fibre degree is normalized to
`g` (where `χ = 1`, so `h⁰ = 1 ⟺ h¹ = 0` by the landed ledger): the Σ-chart opens, the
`P^φ_m`-strata (tex 2249–2306), and the coverage opens are all instances of the landed
openness export (`Scheme.TwoCoverPairData.rigidEngine_isOpen_vanishing`,
`RigidEngine4Assembly.lean:441` — Noetherian-free). Consequences, each retired risk
recorded: (i) Kleiman's Serre-finiteness openness passage (tex 2298–2306) is replaced —
the `∀ n ≥ m` tail of eq. 4.8.4b collapses to the single `n = m` condition because
adding an effective fibre divisor only shrinks h¹ (the landed slice surjection /
`peel_effective`, `FLVClass.lean:292`, fibrewise); (ii) **EGA IV 17.16.3(ii) is never
used** (w4-datum §5.5 retired): étale localization enters only through the plus
construction itself (classes are étale-locally honest cocycles by definition), and
divisor representatives come from *Zariski*-local generators of the finite projective
`H⁰` — no smooth-cover section theorem; (iii) no h⁰-semicontinuity engine and no
Grothendieck-complex re-entry (rigid worksheet §5.6 stays descoped).

### 2.2 (V-rel-A) — the chart scheme, curve-lite LinSys (obligation 2)

Kleiman's `th:LinSys` (tex 1963–2030) in this tree's vocabulary, step by step, with the
landed carrier of each step:

1. **`Q` is the engine's `H⁰`** — no `f_*`, no `sb:Q` module (tex 1897–1904): for a
   cocycle-presented class `L` on `C_R` with fibrewise vanishing,
   `Q := Sheaf.HModule (glued L) 0` is finite projective with base change on the nose
   (`relTwistRigidEngine` `RigidEngine4Engine.lean:174` for the pinned 2-cover twist;
   DAT-1's mirror for m-chart `L`). The `eq:Q` bookkeeping (tex 1902–1904, consumed at
   tex 1985–1998 to turn sections into classifying maps) is the landed
   module-coefficient clause `relTwistH0TensorEquiv` (`:206`,
   `H⁰ ⊗ P ≃ ker(δ.rTensor P)`) plus finite-projective duality
   (`dualTensorHomEquivProjective`, `RigidEngine3Duality.lean:99`).
2. **Sections ↦ divisors is near-definitional (DAT-A).** A global section of the glued
   sheaf *is* a matching family `(s_j)` on the trivializing cover with
   `s_j = g_{jj'} · s_{j'}` — literally a `Scheme.LocalEquations` datum with ratio
   units the cocycle, once the `s_j` are regular. Fibrewise-nonzero ⟹ regular on the
   integral fibre is Kleiman tex 2013–2022; the relative upgrade (fibrewise nonzero ⟹
   germ nonzerodivisor on `C_R`, Kleiman's `lm:ctn` half) is DAT-A2 (§4). Class law:
   `LocalEquations.picClass` (landed, `Picard/DivisorClass.lean`) recovers `[L]` — the
   Abel correspondence.
3. **No `ℙ(Q)` scheme is ever built.** Kleiman forms `ℙ(Q)` to have a smooth cover with
   étale-local sections (tex 2350–2358). Here the only consumers of `ℙ(Q)` are:
   (a) *existence of divisor representatives* — replaced by Zariski-local generators of
   the projective rank-`(d+1−g)` module `Q` (a localization basis element is a
   fibrewise-nonzero section; then DAT-A); (b) *the chart normalization* — replaced by
   the Σ-trick: at fibre degree `g` with `h⁰ = 1`, `Q` is an invertible `R`-module and
   its Zariski-local generator gives THE canonical divisor family (old-campaign J2,
   with the closed-equalizer gift now in mathlib in Over-form:
   `isClosedImmersion_equalizer_ι_left`, `AlgebraicGeometry/Morphisms/Separated.lean:273`).
4. **The chart scheme.** All charts are opens of ONE scheme: `V ⊆ Div^g`-lite, the
   fibrewise-h¹-vanishing open of the universal degree-`g` divisor family (openness =
   the engine export on the universal ring). Chart index `c = (m, Σ)`: `m` the stratum
   (twist exponent), `Σ` an effective `k'`-rational divisor of degree `d_m − g`
   (`d_m := classDeg (Θ^{N·m})`); the chart functor sends a `V`-point `D` to the class
   `[D + Σ]·θ^{-shift}` in the pic0-shifted functor. Mono-ness of the chart functor =
   uniqueness of the h⁰ = 1 representative (Kleiman tex 1979–1985 `N` determined via
   `lm:fff` — landed as `Over.universalSections`, `Picard/UniversalSections.lean`; tex
   2024–2027 `D` unique — engine rank-1 + DAT-A). Transition maps between charts
   `(m,Σ) → (m',Σ')` are the canonical-divisor normalization on the overlap open —
   again an h¹-vanishing open.
5. **Div^g-lite (DAT-D) is the one genuinely new representability input**: the functor
   of degree-`g` relative effective divisor families (LocalEquations-families with a
   colength-`g` finite-locally-free certificate — the landed colength dictionary
   `ChartColength.lean:278,411` is the fibre engine), embedded in a ported Grassmannian
   of rank-`g` quotients of the fixed `H⁰(𝒪(Θ^M))` (uniform twist from DAT-0a; the GRQ
   subproject's green `Grassmannian.represents` is the route map — PORT the statement
   architecture, never import). Locally-closed carving is DAT-D's own worksheet
   question (§5 risk 1).

**Strata bookkeeping (obligation 2, last clause).** The 01JJ chart family ranges over
ALL `(m, Σ)` simultaneously — the increasing unions of tex 2296–2301 dissolve into the
index set of the gluing; no nested-union scheme construction exists on this route.
Exhaustion (joint local surjectivity) = FLV class form pointwise
(`exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1`,
`FLVClass.lean:360`, fed `1 ≤ classDeg θ` by DAT-0b) + the P4(c) h⁰-drop with DAT-P
points + the étale-image openness descent (Kleiman tex 2204–2244 pattern: the condition
is checked on the étale cover, its image is open because étale maps are open).

### 2.3 (V-rel-B) — homEquiv surjectivity at arbitrary tests (obligation 3, route half)

The quantifier is w4-datum §1.2's honest maximum: a point of `pic0` over affine
`T = Spec A` is a plus class `PicEtAff.mk C E x` (`Picard/PicEtAff.lean:218,224`) — an
arbitrary `relPic`/`CechPic` class on `C_B`, `B` a presented étale `A`-algebra, no
presentation control. The pinned chain:

1. **Extraction** (front half of DAT-1): `C_B` is quasi-compact (affine base, proper
   curve), so every `CechPic` class refines to a cocycle on a FINITE cover by basic
   opens of the two pinned charts `V₀ᴮ, V₁ᴮ` — the DAT-1 constructor's input shape
   ("cocycle datum", §3.2). Bounded [PLUMB/M]; the refinement calculus is the landed
   `CechPic` colimit vocabulary (w4-datum §5.2's plausibility, now a spec).
2. **Noetherian descent (RE-5, §3.2)**: the cocycle datum descends to a finitely
   generated (hence Noetherian) `k`-subalgebra `B₀ ⊆ B`.
3. **Fire the engine over `B₀`** on the glued sheaf of `λ·θ^m·(−Σ-shift)` at fibre
   degree `g`; strata opens from the openness export; membership at enough fibres from
   FLV + DAT-4 degree bookkeeping (`λ ∈ pic0` ⟹ fibre degree of `λθ^m` is `d_m`
   exactly — this is where degree-zero-ness is spent).
4. **Transport along `B₀ → B` on the nose**: DAT-1's mirrors of
   `relTwistH0BaseChange`/`relTwist_subsingleton_h1_baseChange`
   (`RigidEngine4BaseChange.lean:471,445`) — the universal ring-map clause is exactly
   why RE-5 is sound (rigid worksheet §2.4, echoed binding).
5. **Chart membership ⟹ a `J_c`-point Zariski-locally on `T`**: canonical divisor
   family (2.2.3b) + the chart functor's open fibre products; glue the local maps by
   the Zariski-sheaf property of `Hom(−, J)` and injectivity (landed separatedness
   lane: (C1) étale separatedness + `PicEtAffZariskiSep`; w4-datum §1.3.3 unchanged).

### 2.4 The Θ/twist normalization (obligation 5) — pinned

- **Θ := `fiberTwist π 1`** (`RiemannRoch/FiberTwist.lean:301`), with `π, hdom, hπ`
  from `exists_isFinite_isDominant_toP1` (`Curve/MapToP1.lean:125` — note `hπ : π ≫
  P1.structureMap k = C.hom` is an equation, no Over instance needed). The relative
  cocycle the engine eats is `relUnitCocycle` (`Cohomology/TwistedSheaf.lean:469`) of
  `fiberCocycle π n` (`FiberTwist.lean:306`) on the pinned `fiberTwoCover π`
  (`RigidEngine4Relative.lean:75`); base change of the cocycle is
  `relCocycleBaseChange` (`RelativeH1BaseChange.lean:325`).
- **Which n**: per stratum `m`, the twist is `Θ^{N·m}` with `N` fixed once (any `N ≥ 1`
  works; the strata absorb per-class non-uniformity). `d₁ := classDeg k Θ`.
- **`deg Θ₁ = deg π` is NOT load-bearing** (retires the `FiberTwist.lean:384–392`
  frontier for this campaign): the route only needs `1 ≤ d₁`, which is DAT-0b — the
  S-bridge `classDeg K (fiberTwist π 1) = CurveDivisor.deg K (fiberWeilDivisor π) > 0`
  via `LocalEquations.presentation_picClass` (`MeromorphicPresentation.lean:215`),
  `CurveDivisor.picClass_presentationDivisor` (`DivisorClassMeromorphic.lean:111`),
  E-i (`classDeg_picClass`, `Degree.lean:157`), an `ordZ`-computation identifying the
  presentation divisor of `fiberDivisor 1` (`FiberTwist.lean:240`) with
  `fiberWeilDivisor` (`FLVFiberToolkit.lean:292` — both are ord-of-`t₀` data), and
  `zero_lt_deg_fiberWeilDivisor` (`FLVClass.lean:179`).
- **The shift ε⁺** (Kleiman tex 2311–2321): DAT-5 packages `θ_T ∈ picEt C T` — the
  image of Θ under pullback along the projection — natural in `T`, and the
  multiplication-by-`θ_T` natural isomorphism `pic0Functor ≅ pic^{d}`-layer (as
  Type-valued functors; the group structure lives only on the `pic0` side, which is all
  `ofRepresentableBy` needs).

### 2.5 Routes weighed and rejected (the honest costs)

- **(a) Port `lm:qt`** (flat proper equivalence relations effective, AK80 via `Hilb`).
  REJECTED: the route-decision explicitly bans it (Quot/Hilb off-route, rule 5); the
  Σ-section charts deliver the same scheme with no quotient.
- **(b) Plan-B (Sym^g / Weil symmetric products)**. Not fired: it is the RED fallback
  of the cbc recon §3 and nothing on this pass moved toward RED; recorded only as the
  escape if DAT-D's carving walls (§5 risk 1).
- **(c) Represent `pic^d` for every `d` and take a disjoint union** (Kleiman
  tex 2246–2255 / old G4). REJECTED: Challenge.lean needs only the degree-0 component;
  one shifted copy suffices; no coproduct assembly.
- **(d) Build the datum directly over `k`** (skip descent). IMPOSSIBLE in general: the
  Σ-normalization needs rational points the ground field may lack (the old J4 audit's
  genus-2/ℚ counterexample); a chart family indexed by non-rational Σ has no canonical
  `k`-structure on its loci. Descent stays; DAT-G owns it.
- **(e) Uniform sharp vanishing via duality** to kill the strata. REJECTED (FLV
  worksheet §2.4(d) — a mountain, and the strata cost is already sunk into the chart
  index).

---

## §3 THE SEAMS — W6-full, RE-5, and the degree seam (obligations 3, 4)

### 3.1 W6-full (obligation 4): DECIDED — its own pre-brick (DAT-3), after DAT-1, cbc-lane owned

The FLV worksheet §3.2 pinned the shape; the engine files pinned the consumption point
(`hfib` in complex form, `RigidEngine4Assembly.lean:53–56`). The discharge chain the
datum runs at a fibre `p` of a test ring `R`, none of it landed past step (b):

- (a) `H¹(pair) ⊗ κ(p) ≃ H¹(pair over κ(p))`: right-exactness of ⊗ on the cokernel +
  the CBC-1 term identifications at `R → κ(p)` (`relTwistTermBaseChange₀/₁`,
  `relTwistOverlapBaseChange`, `RelativeH1BaseChange.lean:332,345,359`; DAT-1 supplies
  the m-chart mirrors);
- (b) `H¹(pair over κ(p)) ≃ Sheaf.HModule (fibre glued sheaf) 1`: the landed carrier
  `TwoCoverPairData.h1Equiv` (`RigidEngine4Assembly.lean:382–383`) at `κ(p)`;
- (c) **W6-full proper (DAT-3, NEW)**: for a field-level cocycle datum `P` (a
  `MeromorphicPresentation`, `Picard/MeromorphicPresentation.lean:123`), a sheaf iso
  `glued(P) ≅ divisorSheaf K (presentationDivisor K P)` — components `s ↦ f_i·s`
  chartwise (the `mulEquivDivisorSheaf` mechanism), plus the m-chart "cohomologous
  cocycles ⟹ isomorphic glued sheaves" transport (the `congrCoeff` pattern,
  `RelativeTwoCover.lean:87`, generalized). Both sheaves carry `QcohOn` already
  (`divisorSheaf.instQcohOn`, `RiemannRoch/FLVQcoh.lean:357`; DAT-1 for the glued side);
- (d) FLV class form + rank anchor on the witness (`FLVClass.lean:360,412`), witness
  from (S) (`DivisorClassMeromorphic.lean:118`), degree from DAT-4.

**Decision**: DAT-3 is scheduled immediately after DAT-1 in the cbc lane (it is the
port's third discharge family, not a datum sub-brick) — but its SPEC is frozen here and
binding, because it unlocks `hfib` and `rigidEngine_rank` for every Stage-B/C brick.
FLV itself never gates on it (FLV worksheet §3.2 division of labour unchanged).

### 3.2 RE-5 pinned (obligation 3): the cocycle-datum spelling (BINDING for the RE-5 brick spec)

The rigid worksheet §2.4/risk 7 deferred exactly this. Pin:

> **Cocycle datum over a `k`-algebra `B`** (the DAT-1 constructor input, and the object
> RE-5 descends): a finite index `J = J₀ ⊕ J₁`; for `j ∈ Jᵢ` an element
> `h_j ∈ Γ(Vᵢᴮ, 𝒪)` with partition witnesses `1 = Σ_j a_j·h_j` in `Γ(Vᵢᴮ, 𝒪)` (the
> basic opens `D(h_j)` cover the affine chart `Vᵢᴮ`); transition units on the pairwise
> basic-open overlaps given with explicit inverse witnesses; the cocycle identities as
> equalities in the overlap section rings. Every carrier ring is `Γ(W, 𝒪_{C_B})` for
> `W` a pinned-chart open or a basic open thereof.

**RE-5 statement**: such a datum descends to a finitely generated `k`-subalgebra
`B₀ ⊆ B` — a cocycle datum over `B₀` whose DAT-1 base change along `B₀ → B` is the
given one; consequently (DAT-1's class law + CBC-1) the classes correspond under
`CechPic.map`, and the engine's output over `B₀` transports to `B` by the universal
ring-map clauses. **Mechanism**: `Γ(Vᵢᴮ, 𝒪) ≅ Γ(Vᵢ, 𝒪) ⊗_k B` on the nose
(`Over.sectionsBaseChange`, `Cohomology/SectionsBaseChange.lean`, qcqs chart opens),
`Γ(V) ⊗_k −` commutes with the filtered colimit `B = colim B₀`; each datum element is a
finite sum of pure tensors and each identity an equality of finitely many elements —
all descend to a finite stage; localization rings `Γ(D(h_j))` are `Away`-localizations
of the tensor ring, handled by clearing denominators into the chart rings first (that
is why the datum is normalized to BASIC opens). The pair-free differential vocabulary
for the transport is `relTwistDiff`/`relTwistDiff_apply`
(`RigidEngine4BaseChange.lean:198,213`), generalized verbatim by DAT-1. **Consumers**:
(V-rel-B)/DAT-B only; the chart legs run over finite-type-over-field rings and never
need it (rigid worksheet §2.4 echoed).

### 3.3 The degree seam (DAT-4, NEW — the FLV worksheet's "hypothesis-supplier" debt)

The strata/coverage arguments need: for a cocycle-presented class over `B` and a field
point `p` of `B`, **`degAt` of the plus class at `p` = `classDeg κ(p)` of the fibre
cocycle's class**. Route: the restriction of the class along `t : overSpec k κ(p) ⟶ T`
collapses through `picEtAffineEquiv_naturality` (`Picard/PicEtMap.lean:354`) and
`PicEtAff.mapAlg` to the unit of the fibre cocycle class; then `degAff_unit`
(`Picard/DegreeZero.lean:314`) and `relPicDeg_relPicMk` (`RelPicDegree.lean:75`) read
`classDeg`. Corollaries: `degAt (θ_T) = d₁` at every field point (with DAT-0b and
E-iv-alg `DegreeBaseFieldInvariance.lean:462` for the `k → K` leg), and for
`λ ∈ pic0Subgroup`: the fibre degree of `λ·θ^m` is `m·N·d₁` on the nose — the FLV
threshold input and the rank normalization `rank Q = d_m + 1 − g` (through
`h0_eq_deg_add_chi_of_subsingleton_hModule_one`, `FLVClass.lean:412`).

---

## §4 SUB-BRICKS — sizes, delegability, dependency order, staged fallbacks, consumption

Sizes per recon convention (S ≤ ~150 lines, M ~150–350, L ~350–500, XL = own campaign).
Kernel discipline per the standing handoff amendments. **Balloon candidates flagged ⚠
per the (C2) lesson.**

**Stage 0 — pre-bricks (all launchable NOW; ∥ = parallel):**

- **DAT-0a [S, Opus, deps: none] — P5-uniform.** `∃ b, ∀ D : CurveDivisor, b ≤ deg D →
  Subsingleton H¹(𝒪(D))` over every field of the standing pack. Proof on landed API
  only: FLV-fiber at `D₀ = 0` gives `n₁` with `H¹(𝒪(nF)) = 0` for `n ≥ n₁`; for
  `deg D` large pick `n ≥ n₁` with `deg D − n·deg F ∈ [1−χ, deg F−χ]`, take an
  effective witness `E` of `[D]·[F]^{-n}` (`exists_effective_of_picClass`,
  `FLVClass.lean:208`), then `H¹(𝒪(nF + E)) = 0` by `peel_effective` (`:292`) and
  transport by W6-lite (`ClassCohomology`). This collapses the old campaign's P5 gate
  to an S-brick; consumed by DAT-D's uniform Grassmannian twist.
- **DAT-0b [S, Opus, deps: none] — Θ-positivity** (§2.4): `classDeg` of `fiberTwist π 1`
  equals `deg (fiberWeilDivisor π) > 0`; plus the `k → K` fibre transport via E-iv-alg.
- **DAT-1 [L→XL staged, FABLE spec + Opus provers, deps: none] ⚠ — the m-chart glued
  constructor.** The single biggest missing engine input (grep: no m-chart constructor
  exists; `twistSheaf` is 2-chart). Deliverables, staged: (1a) the constructor: glued
  sheaf of a cocycle datum (§3.2) as a sheaf of `R`-modules, trivializations on the
  basic-open pieces; (1b) `QcohOn` on both PINNED charts ((P1) componentwise; (P2) by
  `IsLocalization.Away` composition — the basic-open normalization makes this pure
  localization algebra), `TwoCoverPairData` (`RigidEngine4Assembly.lean:207`; the
  coordinate actions through `QcohOn.qsmul` need nothing new); (1c) chart AEval'
  finiteness (RE-4b m-chart: trivializing pieces are `𝒪`-sections;
  `Module.Finite.of_localizationSpan_finite'`, mathlib
  `RingTheory/Localization/Finiteness.lean:191`) and `R`-flat/projective section
  modules (invertible over the chart ring + chart ring `R`-free through
  `free_relSections` (`RigidEngine4Relative.lean:452`) ⟹ `R`-projective); (1d) the
  fired keystones mirroring `RigidEngine4Engine/BaseChange` (engine, openness, eq:Q,
  `H⁰`/`H¹` base change on the nose, `relCocycleBaseChange`-style datum base change);
  (1e) the class law: the constructor's `CechPic` class is the cocycle's, natural in
  `R`; (1f) presentation extraction (§2.3.1). Templates: `TwistedSheaf.lean` +
  `RelativeH1BaseChange.lean` + `RigidEngine4*` (the 2-chart lane, ~1.9k lines — the
  m-chart lane repeats its shapes with finite products). Staged fallback: land
  (1a)–(1c) + engine only (openness + rank can trail); the 2-chart keystones already
  serve every Θ-only consumer meanwhile.
- **DAT-2 [M, Opus, deps: none] — pic0 is a Zariski sheaf** (§1.2.2): separation +
  gluing for arbitrary covers of arbitrary tests on the landed limit vehicle;
  degree-0-membership Zariski-locality (field points factor through cover members).
- **DAT-3 [M, Opus, deps: DAT-1] — W6-full** (§3.1, spec frozen here; cbc-lane owned).
- **DAT-4 [S→M, Opus, deps: none] — the degree seam** (§3.3).
- **DAT-5 [S→M, Opus, deps: DAT-4] — the shift ε⁺** (§2.4): `θ_T` natural family,
  multiplication iso, `degAt θ_T = d₁`.
- **DAT-A [M, Fable spec, deps: DAT-1(1a)] — sections ↦ divisor families** (§2.2.2):
  fibrewise-nonzero `H⁰`-elements ⟹ `LocalEquations` with the right class; includes
  **DAT-A2**: fibrewise-nonzero ⟹ germ-regular on `C_R` (the `lm:ctn` slicing half;
  check mathlib flatness/local-criterion gifts at spec time — the fallback is a
  chart-lattice argument on the free `𝒪`-section modules).
- **DAT-P [M→L, Opus, deps: none] — points over separably closed fields.** Every
  nonempty open of the curve over a separably closed `K` has a `K`-point (density
  form). Route: standard-smooth chart (the `MapToP1.lean` construction's own step-1
  vocabulary) is étale over an affine space; at a `K`-point of the base with unit
  discriminant the fibre is a finite separable `K`-algebra, which splits over
  separably closed `K`. Grep-verified absent from the tree; the old design §4.5's
  "closed point with separable residue field" brick is subsumed by this one.

**Stage B — the charts (over a field `K` with the standing pack; instantiated at
finite separable levels via Challenge.lean's baseChange instances):**

- **DAT-D [XL, FABLE, WORKSHEET-FIRST, deps: DAT-0a, DAT-1, DAT-A, colength dictionary]
  ⚠⚠ — Div^g-lite representability.** The degree-`g` divisor-family functor, its
  Grassmannian embedding at the uniform twist `Θ^M` (DAT-0a), the ported Grassmannian
  (GRQ route map: `SubProjects/GR-Quot-Closure/AlgebraicJacobian/Picard/
  {GrassmannianCells,GrassmannianQuot}.lean`, `represents` green — port the chart/GL_d
  architecture in this tree's vocabulary), the locally-closed carving, quasi-projectivity
  certificate. Its worksheet must decide the carving spelling (the D3′-analogue — THE
  balloon of the campaign) and the divisor-functor pin (LocalEquations-families +
  colength certificate). **Nothing else in Stage B may start proving before DAT-D's
  worksheet exists.**
- **DAT-C [L, Fable, deps: DAT-D, DAT-1, DAT-3, DAT-4, DAT-5] — the Σ-charts.**
  `V ⊆ Div^g`-lite h¹-vanishing open (engine openness on the universal ring); canonical
  section/normalization (invertible `H⁰` + DAT-A); chart functors, mono-ness
  (`universalSections` + rank-1 uniqueness), transition opens/isos; the
  open-fibre-product certificates (01JJ `hf` shape) — Kleiman tex 2343–2350 recast with
  `Q = H⁰`.
- **DAT-B [L, Fable, deps: DAT-C, DAT-P, RE-5] — coverage + injectivity.** Local divisor
  presentation of an arbitrary functor point (projective-generator argument, §2.2.3a);
  P4(c)-drop with DAT-P points over `k^s`-levels; finite Σ-subcover from qc of the
  Div-lite scheme; étale-image openness descent; homEquiv injectivity from the landed
  separatedness lane. **RE-5 [M, Opus]** (§3.2) is scheduled here, in the rigid-engine
  lane, per its frozen spec.

**Stage C/D:**

- **DAT-glue [L, Opus from a tight spec, deps: DAT-2, DAT-B, DAT-6] — the 01JJ
  assembly** over `k'`: slice trick (**DAT-6 [S→M]**, §1.2.1) + mathlib
  `LocalRepresentability.representableBy` (`AlgebraicGeometry/Sites/
  Representability.lean:192`); output the `k'`-level `PicRepDatum` (§1.3) with the lft
  certificate (Zariski-local on quasi-projective charts).
- **DAT-G [XL, FABLE, WORKSHEET-FIRST, deps: DAT-glue; design can start after DAT-C's
  shapes freeze] ⚠⚠ — Galois/Speiser descent of the datum.** Γ-semilinear action on the
  chart family (Γ permutes `(m, Σ)`); orbit-in-affine on quasi-projective charts;
  `Spec(A^Γ)`-gluing; Speiser `k' ⊗_k A^Γ ≅ A` (mathlib seed spot-checked:
  `Algebra.isInvariant_of_isGalois`, `RingTheory/Invariant/Basic.lean:67`; old-draft
  Speiser "landed cleanly — re-derive" per route-decision item 12); the functor
  comparison `pic0(C, T) ≅ (pic0(C_{k'}, T_{k'}))^Γ` **through rigidified pairs only**
  (the Hilbert-90 discipline; landed keystones `relPic.exists_isRigidified_rep`,
  `IsRigidified.eq_of_relPicMk_eq`, `IsRigidified.cechPicMap_congr`,
  `Picard/Rigidification.lean`) on the transition kit
  (`Curve/BaseFieldTransition.lean`, `TransitionSectionsBaseChange.lean:228`,
  E-iv-alg); transport of `rep'` along it (`RepresentableBy` bookkeeping, no new
  geometry). Its worksheet inherits deg-d5b §3's iso-route design.
- **DAT-J [M, Opus, deps: DAT-G] — assembly + discharge.** `jacobianData C`; the qc
  certificate a posteriori: every degree-`g` class is effective (`riemann_inequality`,
  landed), so `|J|` is the image of the qc Div^g-lite scheme under the Abel morphism
  (`rep.homEquiv.symm` of the universal family) — image of qc is qc; then
  `Picard/JacobianData.lean` consumers and the frozen `Jacobian`/`instGrpObj`
  discharge (§1.4).

**Launch order.**
`{DAT-0a ∥ DAT-0b ∥ DAT-1 ∥ DAT-2 ∥ DAT-4 ∥ DAT-P} → {DAT-3, DAT-5, DAT-A, DAT-6, RE-5}`
with the **DAT-D worksheet** written in parallel from day one; then
`DAT-D → DAT-C → DAT-B → DAT-glue → DAT-G (worksheet early) → DAT-J`.
The engine lane (DAT-1/3, RE-5) and the functor lane (DAT-2/4/5/6) never block each
other; Stage B is the first synchronization point.

**Consumption map (who cites what):**

| Deliverable | Consumer |
|---|---|
| DAT-1 keystones (m-chart engine + base change + class law) | DAT-C charts, DAT-B coverage (V-rel-B), DAT-3, RE-5 transport |
| DAT-3 (W6-full) | `hfib` discharge + `rigidEngine_rank` for every engine firing in DAT-C/B (Kleiman 3.10 (v)⟹(i) at fibres) |
| DAT-4 + DAT-5 | strata degrees, FLV thresholds, rank normalization, the ε⁺-shift of the final `rep` |
| DAT-0a | DAT-D's uniform Grassmannian twist |
| DAT-0b | FLV's `1 ≤ classDeg θ` at every fibre |
| DAT-D + DAT-C + DAT-B | DAT-glue's 01JJ input family |
| DAT-glue (`PicRepDatum k'`) | DAT-G |
| DAT-G + DAT-J (`jacobianData C`) | frozen `Jacobian`, `instGrpObj`; Waves 5/6/7 per §1.4 |

---

## §5 HONEST RISKS — with mitigations, and what is deliberately NOT decided

1. **⚠⚠ DAT-D's locally-closed carving is the campaign's balloon #1** (the old D3′ was
   L with flattening machinery behind it; we have none and want none). Mitigations:
   worksheet-first mandate; the GRQ certificate bounds the Grassmannian half; the
   carving condition on a curve is colength bookkeeping (`ChartColength` engine) rather
   than Hilbert polynomials; if the carving walls, the recorded escape is the cbc-recon
   §3 RED protocol (plan-B Sym^g) — invoke only by orchestrator decision.
2. **⚠⚠ DAT-G is balloon #2** (the old G-cluster was XL). Mitigations: worksheet-first;
   the rigidified-pairs discipline is landed API, not new theory; Speiser has a
   landed-clean old-draft precedent to re-derive; the transition kit and E-iv-alg — the
   two inputs the old draft lacked — are green. The Hilbert-90 trap ("invariant classes
   vs equivariant objects") is the named hazard: every DAT-G statement routes through
   `IsRigidified` representatives, never through `Pic(C_{T'})^Γ`.
3. **⚠ DAT-1's CBC-1 bookkeeping is balloon #3**: the 2-chart twisted δ-naturality
   square alone cost ~490 lines with heartbeat overrides
   (`RigidEngine4BaseChange.lean:226–230`). Mitigations: the finite-product structure
   is uniform (no new mathematics per chart); the staged fallback §4(1); spec
   inherits the landed lane's opaque-def/spelling discipline verbatim.
4. **Mathlib gaps taken on faith at S-fallback size** (each spot-checked for
   *adjacent* API this pass, exact lemma unverified): the slicing/`lm:ctn` regularity
   criterion (DAT-A2), the separable-fibre splitting pieces of DAT-P, orbit-in-affine
   (DAT-G). Spec-writers must `lean_local_search`/loogle before pinning proofs; each
   has a bounded hand-rolled fallback on Dedekind chart rings.
5. **Quantifier discipline on the chart index.** The per-class `n₀` (FLV) forces the
   `(m, Σ)` double index; the openness-mechanism collapse (§2.1) keeps each chart's
   membership a single fibrewise condition, but specs must never let a `∀ n ≥ m` tail
   reappear in a statement (it is provable-equivalent to `n = m` by peel monotonicity
   — state the collapsed form only).
6. **The pic^d-coset spelling.** `pic^d` (degree-`d` layer) is not a subgroup functor;
   DAT-5 must keep it Type-valued (`RepresentableBy` needs no group structure there).
   Getting this wrong would poison `ofRepresentableBy`'s typing at assembly.
7. **Deliberately NOT decided here** (owned by the named sub-worksheets/specs):
   DAT-D's divisor-functor pin and carving spelling; DAT-G's Speiser vehicle and the
   `k^s`-vs-finite-level staging of the coverage statement; the DAT-6 slice-trick vs
   hand-rolled GlueData choice (probe); the chart index `Type u` spelling; `N` (the
   base twist exponent); whether DAT-glue's lft certificate is carried per-chart or
   re-derived on the glued object.
8. **Blueprint debt** (inherited from the 07-16 addendum): RE-0/2/3, w4-2, RigidEngine4,
   the degree-lane close, and everything this campaign lands are unblueprinted; each
   DAT brick's acceptance includes its blueprint node per house rule.

## Discipline (inherited, binding)

All standing kernel/elaboration rules (handoff 2026-07-14/15, both protocol sections;
lake mutex; explicit binders; opaque-insertion; files ≤ 500 lines; `lean_verify` on
keystones; axioms exactly `[propext, Classical.choice, Quot.sound]`; no sorried
instances, no `Nonempty`-smuggling — the datum is a def). Campaign-specific: (1) any
proof in Stage B/C that unfolds `picEt`'s limit carrier instead of going through
`picEtAffineEquiv`/`pic0Map_coe` has left the route — stop and restate; (2) every
openness claim must name the glued sheaf whose H¹-vanishing locus it is (§2.1's single
mechanism — a second openness mechanism appearing is a design regression, flag it);
(3) `degAt`/`classDeg` cross the base field only through E-iv-alg and DAT-4 — never
through an unpinned scheme iso (deg-d5b D1 discipline); (4) DAT-G statements route
through `IsRigidified` representatives only.

---

*End of worksheet. Deliverable of record for the `AJCR.w4-rep` w4-6 design obligation
(w4-datum-design §4.1); binding for the DAT-* and RE-5 brick specs — brick specs derive
from this document; the DAT-D and DAT-G worksheets are mandated before their stages
prove; §3.1's W6-full spec is to be handed to the cbc lane and §3.2's RE-5 spec to the
rigid-engine lane; the §1.4 consumption map and the §2.1 retired risks (EGA 17.16.3,
Serre-openness, `lm:qt`, `deg Θ₁ = deg π`) to be echoed on the roadmap by the
orchestrator.*
