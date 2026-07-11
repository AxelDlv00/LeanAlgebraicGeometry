# Wave-3 design spec — the Picard-functor lane

*2026-07-11, Fable-5 Wave-3 design session. **Binding** for route-decision §4 items 8–10 and for
the interfaces Waves 4/5/7 consume. Inputs, all read in full or in the cited sections:
`informal/route-decision.md`, `informal/wave3-mathlib-survey.md`,
`informal/old-draft-picard-recon.md`, `AlgebraicJacobian/Challenge.lean` (frozen),
`AlgebraicJacobian/Cohomology/TwoCover.lean` (landed API), and Kleiman, *The Picard Scheme*
(`references/kleiman-picard-src/kleiman-picard.tex`, TeX source; reading log in §11).
Numbering of Kleiman items is reconstructed by counting numbered environments per section and
cross-checked against the known anchors (2.5 = `th:cmp`, 4.8 = `th:main`, 4.18.3 = `cor:algsch`,
5.1 = `lem:agps`); every citation below also gives the TeX `\label` so it is checkable
independently of the count.*

Lean signatures below are **intended signatures**: binding in shape (carrier types, universes,
variance, what is data vs Prop), lane-owned in spelling (final names follow mathlib conventions;
defeq-level plumbing may adjust). Anything marked **OPEN-n** is an undecided sub-point with its
closing criterion in §9.

---

## 0. Decisions at a glance

| # | Decision | Section |
|---|----------|---------|
| D1 | Definitional Pic = Čech H¹ of the units presheaf on the small Zariski site: **pointed covers** (one open per point), built **on mathlib's `PresheafOfGroups.H1`** fixed-family layer, refinement colimit as a sigma-type quotient, everything in `Type u`. | §2 |
| D2 | Group structure **multiplicative**, `CommGroup` carriers, `CommGrpCat.{u}`-valued functors. | §2.4 |
| D3 | Relative functor = H_T-coset quotient `Pic((C ⊗ T).left) ⧸ range(snd-pullback)` on `(Over (Spec k))ᵒᵖ`, `CommGrpCat.{u}`-valued. Never the absolute `Pic(C×T)`. | §3 |
| D4 | Étale sheafification = **hand-rolled one-step plus** over *presented* affine étale covers, on **affine** test schemes; extended to all of `Over (Spec k)` by the canonical limit over affine opens (dense-subsite Kan extension). One plus suffices because `relPic` is étale-separated (Kleiman 2.5(1) recast; hypothesis discharged by `ex:gc&r`). Option (iii) "representability becomes the definition" is **rejected as a definition** and retained as the Wave-4 **proof strategy**; the functor `J` represents is construction-canonical. | §4 |
| D5 | `JacobianData C` = structure with fields `J`, the `RepresentableBy` **datum** for the degree-0 functor, and `LocallyOfFiniteType` + `QuasiCompact` certificates. Consumed as a section variable; discharged by a Wave-4 *def* `jacobianData C`, never `Nonempty` + choice, never a sorried instance. | §5 |
| D6 | Degree defined over fields via the divisor/χ ledger owned by Wave 2 (interface pinned here, B4 pushforward-rank shape as the normalization `deg 𝒪(D) = finrank`); `Pic⁰` = subfunctor of classes with degree 0 at **every field-valued point** of the test scheme. | §6 |
| D7 | `baseChangeIso` will consume degree-invariance under field extension (χ-ledger), **not** identity-component theory; `lem:agps`(3) remains needed only for `GeometricallyIrreducible`. Deviation from route Wave-7 item 20 wording, justified in §10. | §6.3, §10 |
| D8 | 12 new Lean files (§7), 5 immediately parallel lanes, keystone = the `GrpObj`-derivation dry-run compile against the frozen `instGrpObj` shape. | §7 |

---

## 1. Standing conventions

- **Universe discipline: everything at `u`.** `Scheme.{u}`, test category `Over (Spec (.of k))`
  with hom-types in `Type u`, all Pic carriers in `Type u`, all functors valued in
  `CommGrpCat.{u}`. This is forced by `GrpObj.ofRepresentableBy`
  (`Mathlib/CategoryTheory/Monoidal/Cartesian/Grp.lean:35`), which couples the universe of the
  representing object's homs with the functor's value universe (survey "Universe landmines").
  `JacobianData C` itself lives in `Type (u+1)` (it contains a scheme); that is harmless.
- **Hypothesis bundle.** Every file uses the frozen variable block
  `{k : Type u} [Field k] (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]`, plus the Wave-1 derived instance
  `GeometricallyIntegral C.hom` (route Wave-1 item 2) whenever integrality is used.
- **Product language.** All products of test objects are the cartesian-monoidal product in
  `Over (Spec (.of k))` (`CategoryTheory/Monoidal/Cartesian/Over.lean:34`,
  `Over.cartesianMonoidalCategory`, chosen via `Limits.pullback`): `C ⊗ T`, projections
  `fst C T`, `snd C T`, whiskering `C ◁ g`. This is the vocabulary of the frozen file
  (`𝟙_ (Over (Spec (.of k)))`, `η[·]`, `Functor.LaxMonoidal.ε`). Descents to `Scheme`-level
  pullbacks (`(C ⊗ T).left`) happen only inside cocycle constructions, with the bridge lemmas
  confined to `Picard/RelFunctor.lean`. Known wall: `Over.pullback` instance opacity — use the
  route rule 9 fixes (point-level `congrArg` calc chains, `erw [Category.comp_id]`).
- **Verification bar** (route rule 7): `lake build <Module>` kernel check, then `lean_verify`
  axiom audit (`propext, Classical.choice, Quot.sound` only) on each keystone. LSP advisory only.
- Category names verified in the v4.31 checkout: bundled concrete categories are `GrpCat`,
  `CommGrpCat`, `CommMonCat` (e.g. `CommMonCat.units : CommMonCat.{u} ⥤ CommGrpCat.{u}`,
  `Mathlib/Algebra/Category/Grp/Adjunctions.lean:202`); bundled group *objects* are
  `CategoryTheory.Grp C` (`Mathlib/CategoryTheory/Monoidal/Grp.lean:82`), the challenge's
  `Grp (Over (Spec (.of k)))`.

---

## 2. (A) The definitional Pic carrier

**Semantic pin.** For any scheme `X`, the Picard group *of record* is the Čech cohomology
`Ȟ¹(X, 𝒪_X^*)` on the small Zariski site: covers by opens, unit-valued 1-cocycles modulo
coboundaries, colimit over refinement. This is recon lesson 1 verbatim, and it is Kleiman's own
remark `rk:coh` (§2.11): "for any ringed space `R`, there is a natural isomorphism
`Pic(R) = H¹(R, 𝒪_R^*)`" (his eq. 2.11.2 = `eq:2b`, citing Hartshorne III Ex. 4.5).

**Semantic-honesty remark (record in the blueprint chapter).** The frozen `Challenge.lean` never
mentions `Pic`, line bundles, or invertible sheaves; the only consumers of the carrier are the
functors and elements defined in this spec. Therefore the comparison
"`CechPic X ≃ {invertible 𝒪_X-modules}/≅`" is **Phase-2 optional** (a `ForMathlib` PR
candidate), and no Wave depends on it. What is **Phase-1 mandatory** is that `𝒪(D)`-classes of
relative effective divisors be constructible as explicit cocycles from local equations, because
`ofCurve` is pinned as `t ↦ [𝒪(Γ_t − P_T)]` (route §3). §2.6 pins that constructor.

### 2.1 Index discipline: pointed covers, arbitrary opens

```lean
/-- A pointed open cover of a scheme: one open per point, containing it. -/
structure Scheme.PointedCover (X : Scheme.{u}) : Type u where
  opens : X → X.Opens
  mem_opens : ∀ x, x ∈ opens x
```

with the refinement preorder `𝒱 ≤ 𝒰 ↔ ∀ x, 𝒱.opens x ≤ 𝒰.opens x`.

Decision rationale (each alternative was weighed):

- **Not finite covers, not affine covers, not `Set X.Opens`.** Pointed covers give:
  (a) *smallness for free* — the index type is the fixed carrier `X : Type u`, so the sigma type
  in §2.3 stays in `Type u`; (b) *canonical refinement maps* — a refinement `𝒱 ≤ 𝒰` refines
  **indexwise** (`𝒱.opens x ≤ 𝒰.opens x`), so the cocycle-restriction map needs no choice of a
  reindexing function and no "independence of the refinement map" lemma at the carrier level;
  (c) *directedness by pointwise `⊓`* (`(𝒰 ⊓ 𝒱).opens x := 𝒰.opens x ⊓ 𝒱.opens x`), so the
  refinement colimit is filtered; (d) *clean pullback* — for `f : X ⟶ Y` the pulled-back cover is
  `x ↦ f ⁻¹ᵁ (𝒰.opens (f x))`, again pointed, again indexed by the carrier. Affineness
  constraints would break (d) (preimages of affines are not affine); `Set`-indexing breaks (b)
  (pullback collapses indices).
- Affine or finite covers re-enter as *cofinality lemmas*, not as carrier structure: every
  pointed cover is refined by a pointed affine cover (`x ↦` an affine open neighbourhood inside
  `𝒰.opens x`; the choice lives inside a `Prop`, so no data escapes). This is where the
  2-cover computations of the χ-ledger and the T₀ engine plug in.

### 2.2 The cocycle layer: build on `PresheafOfGroups.H1`

**Decision: build on mathlib's fixed-family layer**, not hand-rolled. Instantiation:

```lean
/-- The units presheaf of a scheme, on its small Zariski site. -/
def Scheme.unitsPresheaf (X : Scheme.{u}) : (X.Opens)ᵒᵖ ⥤ CommGrpCat.{u} :=
  X.presheaf ⋙ forget₂ CommRingCat CommMonCat ⋙ CommMonCat.units
-- (OPEN-4: if the `forget₂ CommRingCat CommMonCat` path is absent in v4.31, a ~20-line
-- bespoke functor replaces the composition; the statement shape is unchanged.)

abbrev Scheme.unitsCocycle (X : Scheme.{u}) (𝒰 : X.PointedCover) :=
  PresheafOfGroups.OneCocycle (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat) 𝒰.opens
```

Here the site category is the poset `X.Opens`, the family is `𝒰.opens : X → X.Opens`, and
mathlib's `OneCochain/OneCocycle/OneCohomologyRelation/IsCohomologous/H1` + `One (H1 G U)`
(`Mathlib/CategoryTheory/Sites/NonabelianCohomology/H1.lean:58–197`) come for free. On a poset
with infima, the `ev (i j) (a : T ⟶ U i) (b : T ⟶ U j)`-style cochain is *equivalent* to the
classical pair data `g x y ∈ 𝒪ˣ(𝒰x ⊓ 𝒰y)` with the cocycle condition on triple infima: homs
are subsingletons, so `ev` is determined by its value at `T = 𝒰x ⊓ 𝒰y` via `ev_precomp`, and
`ev_trans` at the triple infimum is the classical condition. **Binding ergonomic requirement**:
`Picard/CechH1.lean` must provide the two-way bridge so lane agents never touch `ev` directly:

```lean
/-- Build a 1-cocycle over a poset with binary infima from classical pair data. -/
def PresheafOfGroups.OneCocycle.ofPairs
    (g : ∀ x y, G.obj (op (𝒰.opens x ⊓ 𝒰.opens y)))
    (hg : ∀ x y z, /- restrictions to the triple infimum satisfy g x y · g y z = g x z -/) :
    OneCocycle G 𝒰.opens
lemma ev_inf (γ : OneCocycle G 𝒰.opens) (x y) : γ.ev x y ⋯ = ⋯   -- extraction at the infimum
```

Additions ours to make (all in `Picard/CechH1.lean`, stated generically over any `Cᵒᵖ ⥤
CommGrpCat.{w}` — a mathlib-PR candidate, their file's TODO list asks for exactly this):

- `Mul/Inv/CommGroup (OneCocycle Gc U)` when the presheaf is commutative-group-valued (the
  product of cocycles satisfies `ev_trans` only using commutativity), and the descended
  `CommGroup (H1 Gc U)` via `Quot.map₂` (compatibility of `IsCohomologous` with products again
  uses commutativity).
- Restriction along an indexwise refinement `res : H1 G 𝒰 →* H1 G 𝒱` for `𝒱 ≤ 𝒰`
  (on cocycles: restrict values along the inclusions; strictly functorial:
  `res_res : res h₂ ∘ res h₁ = res (h₁.trans h₂)` holds on the nose at cochain level).

### 2.3 The refinement colimit

```lean
/-- The definitional Picard group: Čech H¹ of the units presheaf, colimit over pointed covers. -/
def Scheme.CechPic (X : Scheme.{u}) : Type u :=
  Quot (fun p q : (Σ 𝒰 : X.PointedCover, PresheafOfGroups.H1 ⋯ 𝒰.opens) =>
    ∃ 𝒲, ∃ (h₁ : 𝒲 ≤ p.1) (h₂ : 𝒲 ≤ q.1), res h₁ p.2 = res h₂ q.2)
```

- The relation is an equivalence *because the poset is directed* (common refinement by pointwise
  `⊓`) and `res` strictly composes; the standard filtered-colimit argument is elementary and
  choice-free.
- Universe accounting: `X.PointedCover : Type u`, each `H1 … : Type u` (index `X : Type u`,
  values in `Type u`), the sigma is `Type u`, the quotient is `Type u`. **No `ULift` anywhere.**
- `CommGroup (X.CechPic)`: multiplication of classes represented on a common refinement;
  well-definedness from §2.2's `CommGroup (H1 …)` + `res` being a group hom.
- Constructor/eliminator API: `CechPic.mk (𝒰) (γ : OneCocycle …) : X.CechPic`,
  `CechPic.ind`, `CechPic.mk_eq_mk_iff_of_refines`, and the "sanity gate"
  `CechPic (Spec (.of K)) ≃* PUnit`-style triviality for fields (one-point space, one cover,
  `ev_refl` kills every cocycle) — this is Lane 1's cheap end-to-end test.

### 2.4 Group structure: multiplicative, `CommGrpCat`-valued

**Decision: multiplicative.** Justification (each item load-bearing):

1. The cocycle values are *units of rings*; their native structure is multiplicative, and
   `tensor product of line bundles = pointwise multiplication of transition units`,
   `dual = pointwise inverse` — recon lesson 1's entire point. An additive carrier would
   re-introduce a translation layer at exactly the spot the old draft burned.
2. `GrpObj.ofRepresentableBy` takes `F : Cᵒᵖ ⥤ GrpCat.{w}` — multiplicative — and
   `forget₂ CommGrpCat GrpCat` is the canonical bridge. The old draft's
   `AddCommGrpCat.{u+1}` choice cost both a universe bump and an additive/multiplicative
   mismatch at the representability gate.
3. Mathlib's `PresheafOfGroups.H1` layer (§2.2) is multiplicative.

The `ℤ`-valued *degree* (§6) is additive; the interface between the multiplicative Pic and the
additive degree is a single `→ ℤ` map with `deg (a * b) = deg a + deg b` — pinned as such, no
`Multiplicative ℤ` gymnastics in consumer-facing statements.

### 2.5 Functoriality: pullback of cocycles

```lean
def Scheme.CechPic.map {X Y : Scheme.{u}} (f : X ⟶ Y) : Y.CechPic →* X.CechPic
theorem Scheme.CechPic.map_id (X) : CechPic.map (𝟙 X) = MonoidHom.id _
theorem Scheme.CechPic.map_comp (f : X ⟶ Y) (g : Y ⟶ Z) :
    CechPic.map (f ≫ g) = (CechPic.map f).comp (CechPic.map g)
```

On representatives: pull the cover back pointwise through `f.base` (`x ↦ f ⁻¹ᵁ 𝒰.opens (f x)`),
pull the units back through `f.app`, restrict. `map_comp` compares the covers
`(f ≫ g) ⁻¹ᵁ 𝒰 (g (f x))` and `f ⁻¹ᵁ (g ⁻¹ᵁ 𝒰 (g (f x)))` — equal opens
(`Scheme.preimage_comp`), with the value comparison through `Scheme.Hom.app_comp`; if defeq
friction appears, prove it through the refinement relation (both sides restrict to a common
refinement) rather than `eqToHom` surgery.

### 2.6 Divisor classes as cocycles: the `𝒪(D)` constructor

Three constructors, in dependency order. Sign convention (route §3, audited in §8):
a local-equation system `(fᵢ)` for an effective `D` produces the class of `𝒪(D)` with
transition units `g x y = f x / f y` on overlaps (trivialization of `𝒪(D)` on `𝒰x` by
multiplication by `f x`).

**(a) Local-equation data → class** (`Picard/DivisorClass.lean`):

```lean
/-- Local equations for an effective Cartier divisor, adapted to a pointed cover. -/
structure Scheme.LocalEquations (X : Scheme.{u}) : Type u where
  cover : X.PointedCover
  eqn : ∀ x, Γ(X, cover.opens x)
  regular : ∀ x, /- eqn x is a nonzerodivisor in every stalk over cover.opens x -/
  ratio_isUnit : ∀ x y, IsUnit (/- (eqn x)/(eqn y) as a section on the overlap, i.e.
      ∃ u : unit on 𝒰x ⊓ 𝒰y, (eqn x)|∩ = u * (eqn y)|∩ -/)

def Scheme.LocalEquations.picClass (d : X.LocalEquations) : X.CechPic
  -- the class of the cocycle (x,y) ↦ the unit u x y with (eqn x)|∩ = u x y • (eqn y)|∩
```

with: uniqueness of `u x y` (regularity makes the ratio unit unique — this is why `regular` is
part of the data), the cocycle identity for `u` (from associativity of the ratios),
*independence*: two `LocalEquations` cutting out the same closed subscheme (or related by
unitwise rescaling) have equal `picClass`; *multiplicativity*: pointwise product of equations ↦
product of classes; *pullback compatibility*: for `f : X' ⟶ X` such that the pulled-back
equations are still regular (guaranteed in the relative situation below),
`(d.pullback f).picClass = CechPic.map f d.picClass`.

**(b) The two geometric instances** (`Picard/GraphDivisor.lean`):

- *Point divisor.* For a `k`-point `P : 𝟙_ (Over (Spec (.of k))) ⟶ C`, the image of `P` is an
  effective Cartier divisor on `C.left`: the local ring at the image point is a DVR
  (`Curve/StalksDVR.lean`, Wave 1), so a uniformizer spreads to a local equation, and away from
  the point the equation `1` works. Output: `pointDivisor P : C.left.LocalEquations` (cover:
  a distinguished pointed cover; the choice of uniformizer is data *inside* the construction,
  with `picClass`-level independence proven — see the choice-discipline note in §4.4).
- *Graph divisor.* The diagonal `Δ ⊂ (C ⊗ C).left` is a relative effective divisor over the
  **second** factor: `pr₂|Δ` is an isomorphism onto the base, in particular finite flat of rank
  1, and smoothness of `C/k` of relative dimension 1 makes the conormal module invertible, so
  the ideal of `Δ` is locally one regular equation. Deliverable:

  ```lean
  def graphLocalEquations (t : T ⟶ C /- in Over (Spec k) -/) :
      ((C ⊗ T).left).LocalEquations   -- local equations for Γ_t := (C ◁ t)-pullback of Δ ⋯
  theorem graphLocalEquations_base_change ⋯  -- Γ_{t ∘ g} equations = pullback of Γ_t equations
  ```

  The base-change stability is *by construction*: `Γ_t` is the pullback of the universal `Δ`
  along `C ◁ (t ≫ ⋯)`, and (a)'s pullback compatibility applies because `Δ` is a *relative*
  divisor over the test factor (fibers never contain a component of `C`), so regularity
  survives every base change. Rank certificate: `𝒪_{Γ_t} ≅ 𝒪_T` as `T`-algebras, so the
  finite-flat rank of `Γ_t → T` is 1 — the input for the degree of `abelElement` (§6).
  This mathematics is Kleiman `ex:DivC` (§3.8: `X₀ = Div¹_{X/S}` for the smooth locus) and
  `rmk:Jac` (§5.26: "Given `t : T → X`, its graph subscheme `Γ_t ⊂ X × T` is a relative
  effective divisor"); both read.

**(c) The meromorphic bridge** (`Picard/MeromorphicTrivialization.lean`; needed by the degree,
see §6.1): for `X` *integral*, every `CechPic` class is a divisor class. Cocycle proof shape:
every nonempty open contains the generic point; fix a base index `x₀` and localize the cocycle
values `g x x₀` into the function field; these are meromorphic local equations for a Cartier
divisor whose class is the given one. (Classical statement: Kleiman quotes it in the proof of
`th:qpp&p` (§5.4): "Since `X × T` is integral, there is a divisor `D` such that `𝒪(D) = 𝓛`
by [Hartshorne, Ex. II 6.15]".) This file also pins `divisorClass` for *differences*
`D₁ − D₂` of effective data as `picClass D₁ * (picClass D₂)⁻¹`.

---

## 3. (B) The relative functor

Recon lesson 3 is binding: the **certified false-axiom trap** (inbox I-0061) is wiring anything
to the absolute `Pic(C ×ₖ T)`; the honest functor is the H_T-coset quotient — Kleiman
`df:Pfs` (§2.2): "`Pic_{X/S}(T) := Pic(X_T)/Pic(T)`". Kleiman's `df:aPf` discussion (§2.1,
read) is the semantic audit anchor for *why* the absolute functor "is never representable".

```lean
variable (C : Over (Spec (.of k)))

/-- The relative Picard group of `C/k` at a test object `T`: line-bundle classes on `C ⊗ T`
modulo classes pulled back from `T`. -/
def relPic (T : Over (Spec (.of k))) : Type u :=
  (C ⊗ T).left.CechPic ⧸ (Scheme.CechPic.map (CartesianMonoidalCategory.snd C T).left).range
-- CommGroup instance: QuotientGroup on the CommGroup of §2.3.

/-- The relative Picard functor. -/
def relPicFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}
```

- **Exact quotient relation**: `[L] = [L']` in `relPic T` iff
  `L * L'⁻¹ ∈ (CechPic.map (snd C T).left).range` — i.e. iff `L ≅ L' ⊗ pr_T^* N` for some class
  `N` on `T`, which in the cocycle model is literally a range condition; no `Nonempty (≅)`
  propositions anywhere.
- **Evaluation and restriction.** For `g : T' ⟶ T` in `Over (Spec (.of k))`, the map
  `relPicFunctor.map g.op` is descent of `CechPic.map ((C ◁ g).left)` to the quotients;
  well-defined by the monoidal naturality `(C ◁ g) ≫ snd C T = snd C T' ≫ g`. Functor laws
  from `CechPic.map_id/map_comp` plus `QuotientGroup.map` functoriality.
- **Universe target**: `CommGrpCat.{u}`, per §1. The functor category
  `(Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}` is legitimate (`Over (Spec k) : Type (u+1)` with
  `Type u` homs, `CommGrpCat.{u} : Type (u+1)` with `Type u` homs).
- Also provided here (consumed by §4 and Wave 7): naturality in the curve,
  `relPicMapCurve (g : C' ⟶ C) : relPicFunctor C ⟶ relPicFunctor C'` (pullback along
  `g ▷ T`), strictly functorial in `g`; and the statement of the **base-field shuffle**: for
  `L/k` and `T' : Over (Spec (.of L))`, a canonical iso
  `relPic (C_L) T' ≃* relPic C ((Over.map (Spec.map _)).obj T')` induced by the scheme
  isomorphism `(C_L ⊗_L T').left ≅ (C ⊗_k T'ₖ).left` (`pullbackAssoc`-type; the survey's
  `AlgebraicGeometry/Pullbacks.lean` toolkit), compatible with the H-quotients on both sides.

---

## 4. (C) Étale sheafification, concretely

### 4.1 What Kleiman actually provides (all read; quotes abridged, labels exact)

- **Theorem 2.5 (`th:cmp`, Comparison).** Hypothesis: "`𝒪_S ≅ f_*𝒪_X` holds universally".
  Part 1: "the natural maps are injections
  `Pic_{X/S} ↪ Pic_{(X/S)zar} ↪ Pic_{(X/S)ét} ↪ Pic_{(X/S)fppf}`."
  Part 2: "All three maps are isomorphisms if also `f` has a section; … and the last map is an
  isomorphism if also `f` has a section locally in the étale topology."
  Proof ingredients, each read: `lm:fff` (§2.7, `𝒩 ↦ f*𝒩` fully faithful with characterized
  essential image), `df:rgd`/`lm:idn` (§2.8/2.9, rigidified pairs ↔ `Pic_{X/S}(T)`), `lm:aut`
  (§2.10, rigidified pairs have no automorphisms), and the descent assembly in the proof of
  Part 2 (the `v₁₃⁻¹v₂₃v₁₂` automorphism is trivial by `lm:aut`, "hence `(𝓛',u')` descends").
- **`ex:gc&r` (§3.11).** "Assume `f : X → S` is proper and flat, and its geometric fibers are
  reduced and connected. Show `𝒪_S ≅ f_*𝒪_X` holds universally." Our `C/k` qualifies
  (proper, flat over a field, geometrically integral). This discharges 2.5's hypothesis.
- **Theorem 4.8 (`th:main`, Main).** "Assume `f : X → S` is projective Zariski locally over
  `S`, and is flat with integral geometric fibers. (1) Then `Pic_{X/S}` exists, is separated
  and locally of finite type over `S`, and represents `Pic_{(X/S)ét}`." I read the full proof:
  the `P^φ` decomposition by Hilbert polynomial (`eq:phi`), the `P^φ_m` vanishing strata
  (`eq:4b/4c`), the Abel map `Z := P₀^{φ₀} ×_P Div` with `LinSys = ℙ(𝒬)` (`th:LinSys`
  statement `df:LinSys` §3.12 read), smooth-cover sections via EGA IV 17.16.3, and the quotient
  Lemma `lm:qt` (§4.9, flat proper equivalence relation on a quasi-projective scheme is
  effective, via `Hilb`). **On-route consequence:** for our `C/k` (projective once Wave-4's N2
  lands, flat, geometrically integral), the étale-sheafified functor is the representable one —
  the étale topology is the *correct* sheafification level for the route's pin; fppf is not
  needed (4.18.3/`cor:algsch`, read, gives the fppf statement for merely complete `X` but
  through `th:genrep`/`th:rrep` machinery — Oort dévissage, nonflat descent — explicitly
  off-route).
- **`prp:lft` (§4.17).** Locally-of-finite-type from representing `Pic_fppf`, via the
  EGA IV 8.14.2 limit criterion. Read; **rejected as a proof route** for us (spreading-out
  grade); instead the lft certificate is *stored* in `JacobianData` (§5), produced by the
  Wave-4 construction itself.
- **`ex:bschg` (§4.4).** "`Pic_{X_{S'}/S'} = Pic_{X/S} ×_S S'`" — the semantic anchor for
  `baseChangeIso`.

### 4.2 The three options, weighed

**(i) Hand-rolled plus-construction.** Define
`PicEt(T) := colim_{étale covers T'→T} ker(relPic T' ⇉ relPic (T' ×_T T'))` (equalizer form —
the plus needs no triple-overlap condition). One plus yields a sheaf iff the input presheaf is
separated; `relPic` **is** étale- (even fppf-) separated by Kleiman 2.5(1), whose hypothesis
holds by `ex:gc&r`. Cost: the separatedness proof (a genuine descent argument, §4.4), cover
smallness/indexing, colimit plumbing. Benefit: construction-canonical, evaluates concretely,
`relPic → PicEt` is a unit map usable everywhere, and over test schemes where a section exists
the unit is bijective *as a theorem* (2.5(2) recast) — exactly what Wave 4 needs over `k'`.

**(ii) Define `PicEt` only via 2.5-comparison where sections exist + descent data elsewhere.**
Rejected. A piecewise definition is either non-canonical (it depends on which case a test
scheme falls into, and for `baseChangeIso` the case-split differs between `C/k` and `C_L/L`)
or secretly equal to (i) with the plus spelled out by hand. Every interface (group law, degree,
functoriality in `C`, base-field shuffle) would need case-coherence lemmas. The *content* of
(ii) — the comparison bijections — survives as the pair of theorems (C1), (C2) in §4.4.

**(iii) Representability over `k'` + Galois descent, with `PicEt := the functor J represents`.**
Rejected **as a definition**, retained **as the Wave-4 proof strategy**. The blocker is
exactly the one the route anticipates: `baseChangeIso` must compare `(J_C)_L` with `J_{C_L}`,
and both must be recognized as representing *the same construction-canonical functor* over `L`.
If `PicEt_k` is defined as `Hom(−, J)`, the `RepresentableBy` datum is a tautology carrying no
information, and the comparison of `(J_C)_L` with `J_{C_L}` has no common third functor to
factor through — one would have to smuggle the construction back in, per-instance, at every
coherence. **Resolution (binding):** the functor is defined by construction (option (i)); the
`k'`-plus-descent argument is how Wave 4 *produces* the `RepresentableBy` datum; after Wave 4,
nothing downstream ever unfolds `J`, only the datum.

### 4.3 The decision, in two layers

**Layer 1 — affine tests, presented covers** (`Picard/EtaleCovers.lean`, `Picard/PicEtAff.lean`).

For `T` with `T.left` affine (`A := Γ(T.left, ⊤)`), an étale cover index is a *presentation*:

```lean
/-- A presented affine étale cover of `Spec A`: a chosen finite presentation of an étale,
faithfully flat `A`-algebra. -/
structure EtCover (A : CommRingCat.{u}) : Type u where
  n m : ℕ
  relations : Fin m → MvPolynomial (Fin n) A
  -- carrier B := (MvPolynomial (Fin n) A) ⧸ (span of relations)
  etale : Algebra.Etale A B
  surjective : /- Spec B → Spec A surjective (with étale + fp this gives faithful flatness) -/
```

- `Type u`-small by construction, choice-free, and closed under the operations the plus needs:
  a *refinement* of covers is a `T`-morphism `Spec B' → Spec B`; *directedness* via
  `B ⊗[A] B'` (which has an explicit presentation); *base change* along `A → A'` re-presents
  with the same polynomials.
- Descent classes and the one-step plus, equalizer form:

```lean
def descentClasses (E : EtCover A) : Subgroup (relPic C (T' E)) :=
  -- ker of (pullback along pr₁) / (pullback along pr₂) into relPic C (T' E ⊗_T T' E)
def PicEtAff (T /- affine -/) : Type u :=
  -- Σ (E : EtCover A), descentClasses E, quotiented by refinement, CommGroup
def picEtAffUnit : relPic C T →* PicEtAff C T   -- classes with the tautological descent datum
```

- *Refinement-map independence* (the lemma that makes the colimit canonical): two `T`-morphisms
  `h₁ h₂ : Spec B'' → Spec B'` induce the same map on `descentClasses`, because
  `(h₁, h₂) : Spec B'' → Spec B' ×_T Spec B'` pulls the descent-datum equation
  `p₁^*λ = p₂^*λ` back to `h₁^*λ = h₂^*λ`. One line, but it is the keystone of
  well-definedness; pin it as a named lemma.
- Zariski refinements are included automatically: a standard affine cover
  `Spec (∏ᵢ A_{fᵢ}) → Spec A` is a presented étale cover, so the plus also performs the
  Zariski sheafification on affines — needed for `relPic`-vs-`PicEt` comparisons to be honest.
- Over a *field* base `Spec K`, single-factor refinement works (any factor field of an étale
  `K`-algebra already covers the point), so **field-extension covers are cofinal** — pin this
  lemma; it makes `PicEtAff C (Spec K) = colim_{K'/K fin. sep.} (Galois-stable part of
  relPic over K')`, the form the degree (§6) and Wave 4 consume.

**Layer 2 — all test objects** (`Picard/PicEt.lean`).

`GrpObj.ofRepresentableBy` forces the functor to be defined on **all** of `Over (Spec (.of k))`
(the frozen `instGrpObj` leaves no choice), while the plus is only well-behaved on affines. The
extension is the canonical right-Kan-style limit over affine opens:

```lean
def picEt (T : Over (Spec (.of k))) : Type u :=
  -- lim over the poset of affine opens U ≤ T.left of PicEtAff C (T restricted to U),
  -- i.e. compatible families (λ_U)_U; CommGroup pointwise
def picEtFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}
def picEtUnit : relPicFunctor C ⟶ picEtFunctor C
theorem picEt_affine_iso (hT : IsAffine T.left) : picEt C T ≃* PicEtAff C T ⋯
```

For affine `T`, `T.left` is the top of its own affine-opens poset, so the limit collapses to
`PicEtAff C T` (canonical iso, not defeq — one lemma). Functoriality in `T` maps a family
`(λ_V)_V` over `T` to the family `(res λ_V)` indexed by pairs `U ⊆ f⁻¹V` — the comma-limit
construction. `picEt` is a Zariski sheaf by construction; the étale sheaf sequence is claimed
(and needed) **only for affine `T` with presented covers** — this is recorded as the honest
semantic pin in the blueprint: "`picEtFunctor` restricted to affine tests *is* the étale
sheafification of `relPicFunctor` there (one plus of a separated presheaf), and is its canonical
Zariski-continuous extension elsewhere." **OPEN-1**: whether Layer 2 is implemented as this
bespoke limit or through mathlib's dense-subsite machinery
(`AlgebraicGeometry/Sites/Affine.lean`: `isCoverDense_toOver_Spec` + `IsCoverDense` sheaf
extension); closing criterion in §9.

Also in `Picard/PicEt.lean`, stated at this level because Wave 7 consumes them:

- `picEtMapCurve (g : C' ⟶ C) : picEtFunctor C ⟶ picEtFunctor C'` with `mapCurve_id/comp`
  (descend `relPicMapCurve` through the plus and the limit; pullback preserves descent data).
- The **base-field shuffle**, étale level: for `L/k` and `T' : Over (Spec (.of L))`,
  `picEtBaseField : picEt (C_L) T' ≃* picEt C (T'ₖ)` — descends from §3's `relPic` shuffle
  because an étale cover of `T'` is *the same thing* over `L` and over `k` (étaleness and
  presentations are `T'`-intrinsic; this is precisely why the plus is indexed by covers **of
  the test scheme**, never of the base). Natural in `T'`, compatible with units and with
  `picEtMapCurve`.

### 4.4 Why one plus suffices: the separatedness ledger

**(C1) Separatedness** (`Picard/Separatedness.lean`): for affine `T` and a presented étale
cover `E`, the map `relPic C T → relPic C (T' E)` is injective. This is Kleiman 2.5(1)
restricted to what we consume, recast on cocycles. Proof ledger (all pieces named because they
are shared bricks):

1. `sectionsBaseChange` (`Cohomology/SectionsBaseChange.lean`): for `V ⊆ C.left` affine open
   and a `k`-algebra `A`, `Γ((C ⊗ Spec A).left, V_A) ≅ Γ(C.left, V) ⊗[k] A`, naturally.
   *Shared with*: the T₀ dual-numbers engine (`A = k[ε]`, recon lesson 7) and the χ-ledger over
   field extensions (`A = K`). One brick, three consumers.
2. `universalSections` (`Picard/UniversalSections.lean`): `Γ((C ⊗ Spec A).left, ⊤) = A` for
   every `k`-algebra `A` — the two-cover H⁰ slice: the complex
   `Γ(V₀) ⊕ Γ(V₁) → Γ(V₀ ⊓ V₁)` has `H⁰ = k` (Wave 1), stays exact under the flat `⊗[k] A`
   by 1. This is our discharge of Kleiman's `ex:gc&r` hypothesis in the form actually consumed.
3. `prPullback_injective`: `CechPic.map (snd C T).left` is injective for affine `T` — a unit
   cocycle on `C ⊗ T` trivializing must have come from `T`, because
   `𝒪ˣ((C ⊗ V).left) = Γ(V)ˣ` by 2 (applied on an affine pointed cover of `T`). Hence the
   H_T-quotient loses nothing it shouldn't, and "which `N`" in a `pr^*N`-equation is unique.
4. `Descent/InvertibleModule.lean` (pure algebra, PR-candidate): along a faithfully flat ring
   map `A → B`, an invertible `B`-module with a descent datum descends to an invertible
   `A`-module, uniquely up to canonical isomorphism. (Survey: this exists **nowhere** in
   mathlib — "no effective descent of modules"; it is the honest algebraic core of both (C1)
   and (C2).)
5. Assembly (Kleiman's 2.5(1) argument recast): a class `λ ∈ relPic C T` dying on the cover
   gives, via 3 applied over `T'` and `T' ×_T T'`, a line-bundle class `n'` on `T'` with a
   descent datum along `Spec B → Spec A`; by 4 it descends to `n` on `T`, and `λ = pr^* n`
   follows from 3 again. Hence `λ = 0` in the quotient.

**Choice discipline (binding).** Constructions like 4's descended module and §2.6(b)'s
uniformizers may use `Classical.choice` *internally*, provided the resulting `CechPic`/`relPic`
**class** is proven independent of the choices (the allowed axiom set is `propext,
Classical.choice, Quot.sound`). What remains forbidden (route rule 3/4) is storing mere
existence (`Nonempty`) where downstream needs data — in particular the `JacobianData` fields.

**(C2) Comparison under a section** (`Picard/Rigidification.lean`; statement Wave 3, proof may
slip to Wave 4 — OPEN-2): if `C ⊗ T → T` has a section `σ` (equivalently `T ⟶ C ⊗ T` over
`T`), then `picEtAffUnit : relPic C T → PicEtAff C T` is bijective. This is Kleiman 2.5(2)
recast; ledger: `lm:idn` (rigidified pairs = relPic, cocycle form: normalize a cocycle so that
`σ`-pullback is 1), `lm:aut` (no automorphisms: a unit on `C ⊗ T` restricting to 1 along σ is
1, by `universalSections`), then effectivity of the rigidified descent datum by Zariski-locally
reducing to brick 4 on an affine pointed cover of `C ⊗ T` (the datum's cocycle coherence comes
free from the equalizer + rigidification, per Kleiman's triple-product argument, read). Wave 4
consumes (C2) **only** over `k'`-bases where `C(k') ≠ ∅` supplies the section.

### 4.5 What Wave 4 must prove (the exact obligations)

Given this spec, Wave 4's deliverable is a **def** (not instance, not `Nonempty`):

```lean
noncomputable def jacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    JacobianData C
```

whose internal milestones (the campaign map, unchanged by this spec) are: projectivity of `C`
(N2, from the Wave-2 χ-ledger); the closed-point-with-separable-residue-field brick giving a
finite separable `k'` with `C(k') ≠ ∅`; representability of `relPic` restricted to
degree-0 over `k'` (Div^g/Grassmannian route, Σ-opens, Stacks 01JJ gluing — Kleiman 4.8's
skeleton with the Hilbert-polynomial strata replaced by the curve-specific degree strata, per
recon §4's judged D3 plan); the (C2) bridge identifying the represented functor with
`pic0Functor (C_{k'})` on affine `k'`-tests and Layer-2 extension; Speiser semilinear descent of
the scheme *and* transport of the `RepresentableBy` datum along `picEtBaseField` +
Galois-invariance; and the lft/qc certificates read off the construction (quasi-projective
pieces over `k'`, descent along the finite `k'/k`).

### 4.6 Datum flow for each frozen target (route rule 4: ONE pinned datum)

All six functorial targets consume **only** `jacobianData` instantiations plus the
construction-level natural maps of §§2–4; none unfolds `J`.

| Frozen target | Pinned inputs | Argument shape |
|---|---|---|
| `Jacobian C` | `(jacobianData C).J` | definition |
| `instGrpObj` | `(jacobianData C).rep` | `GrpObj.ofRepresentableBy J (pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) rep` |
| `ofCurve P` | `rep` + `abelElement P` (§6.2) | `rep.homEquiv.symm (abelElement P)` |
| `comp_ofCurve` | same + `abelElement_map_point` | `homEquiv_comp` naturality reduces it to `(pic0Functor C).map P.op (abelElement P) = 1`, a divisor-class computation (§2.6(b): graph pulled along the point = point divisor; classes cancel); `η[J] = rep-image of 1` by the `ofRepresentableBy` unit formula |
| `functor k` | `jacobianData` at every `X : Curve k` + `picEtMapCurve` + degree-0 preservation (§6.2) | `map g.op := rep_C.homEquiv.symm ((pic0MapCurve g).app _ (rep_{C'}.homEquiv (𝟙 _)))`; `map_id/map_comp` from `mapCurve_id/comp` + `RepresentableBy` uniqueness/ext |
| `baseChangeIso k L C` | `jacobianData C`, `jacobianData (C_L)`, `picEtBaseField`, `Over.mapPullbackAdj` | `(J_C)_L` carries the transported datum for `pic0Functor (C_L)` (adjunction ∘ shuffle); `J_{C_L}` carries its own; `Functor.RepresentableBy.uniqueUpToIso` (Yoneda.lean:343) gives the iso; group-hom-ness via the `yonedaGrpObjIsoOfRepresentableBy` pattern (survey §2) |
| `baseChangeIso_id`, `baseChangeIso_comp` | the same data, nothing new | both sides intertwine the same pinned universal elements; equality by `RepresentableBy.ext` (Yoneda.lean:358, "equality from value on `𝟙`") after `homEquiv_comp` unfolding |
| `baseChange_ofCurve` | `abelElement_baseField` (§6.2) | naturality of `rep` + shuffle-compatibility of the graph divisor (`graphLocalEquations_base_change`) |

Wave-7 prerequisite bricks *outside* this wave (flagged, not owned here): the
finite-or-constant dichotomy for morphisms of our curves (for degree-0 preservation under
`picEtMapCurve`, §6.2 — proper + quasi-finite ⇒ finite is the mathlib ZMT gift; the dichotomy
itself is a small `Curve/` brick), and `finrank` multiplicativity for finite flat composites.

---

## 5. (D) `JacobianData`

```lean
/-- The pinned representability datum for the degree-0 étale-sheafified relative Picard
functor of the curve `C`. Produced (once, by explicit construction) in Wave 4; consumed as a
section variable everywhere else. NEVER a sorried instance, NEVER `Nonempty` + choice. -/
structure JacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Type (u + 1) where
  /-- The representing object (the Jacobian-to-be). -/
  J : Over (Spec (.of k))
  /-- The pinned universal datum: `Hom(T, J) ≃ Pic⁰ét(T)`, naturally. -/
  rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J
  /-- Certificate from the construction (Kleiman 4.8(1) shape); NOT re-derived via the
  EGA limit criterion (`prp:lft` §4.17, audited and rejected as a proof route). -/
  locallyOfFiniteType : LocallyOfFiniteType J.hom
  /-- Certificate from the construction (degree-0 part descends from a quasi-projective
  `k'`-scheme). Feeds `IsProper` (Wave 5) via `finite type = qc + lft`. -/
  quasiCompact : QuasiCompact J.hom
```

The typing of `rep` is chosen so that `GrpObj.ofRepresentableBy` applies **verbatim** with
`F := pic0Functor C ⋙ forget₂ CommGrpCat GrpCat` (its signature, verified in the checkout:
`(F : Cᵒᵖ ⥤ GrpCat.{w}) (α : (F ⋙ forget _).RepresentableBy X)`). `Picard/Witness.lean` also
provides:

```lean
noncomputable def JacobianData.grpObj (d : JacobianData C) : GrpObj d.J :=
  .ofRepresentableBy d.J _ d.rep
def JacobianData.homEquiv (d) : (T ⟶ d.J) ≃ (pic0 C T)      -- Type-valued massage
noncomputable def JacobianData.uniqueIso (d d' : JacobianData C) : d.J ≅ d'.J
  -- Functor.RepresentableBy.uniqueUpToIso; plus its intertwining property
```

(The `forget₂ ⋙ forget` vs `forget CommGrpCat` defeq massage is a known landmine; `Witness.lean`
owns the single bridging definition so no consumer ever meets it.)

**What is deliberately NOT stored** (derivable, keep the gate thin): separatedness of `J.hom`
(Wave 5 derives it group-theoretically: Kleiman `lem:agps`(1) §5.1, read — diagonal =
`α⁻¹(e)` for `α(g,h) = gh⁻¹`, `e` closed; mathlib's `IsClosedImmersion η[G].left` is the
survey's gift); `GeometricallyIntegral` etc. of `J` (Wave 5's theorems); any smoothness or
properness data (Waves 5's own mountains; they consume `rep` + the certificates only).

**Consumption pattern** (binding header for Waves 5/6/7 files):

```lean
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
variable (d : JacobianData C)
attribute [local instance] JacobianData.grpObj   -- or `letI := d.grpObj` per proof
```

Statements are phrased about `d.J`; cross-curve statements (Wave 7) take a family
`(D : ∀ X : Curve k, JacobianData X.carrier)` and instantiate it pointwise.

**Final discharge, without choice.** Wave 4's `jacobianData` is a plain (noncomputable) def.
Then, in the sorry-discharge of the frozen file:

```lean
noncomputable def Jacobian (C : Over (Spec (.of k))) ⋯ : Over (Spec (.of k)) :=
  (jacobianData C).J
noncomputable instance instGrpObj : GrpObj (Jacobian C) := (jacobianData C).grpObj
```

— definitional unfolding (`Jacobian C ≡ (jacobianData C).J`) makes every section-variable
theorem instantiate by `exact theorem_x … (jacobianData C)`. No `Classical.choice` extraction
of a witness occurs at any gate; `sorryAx` cannot appear because no field is ever sorried
(recon lesson 5: a typed-sorry datum poisons every consumer).

---

## 6. (E) Degree and `Pic⁰`

### 6.1 Degree: division of labour with the Wave-2 χ-ledger

**Primary home:** `RiemannRoch/Degree.lean` (Wave-2-owned file; interface pinned here).
For a field `K` over `k` write `C_K := C ⊗ Spec K` viewed over `K` (via the second projection;
`[X.Over (Spec (.of K))]` instance), with its base-changed affine 2-cover `V₀ᴷ, V₁ᴷ` (Wave 1's
`MapToP1` cover, base-changed; affine and covering by construction).

The route pin (Wave-2 item 7) is `deg L := χ(L) − χ(𝒪)`; recon lesson 6 pins "degree via
finite-flat pushforward rank (B4), never Hilbert polynomials". These are reconciled — and an
**audited false pin is rejected** on the way (route rule 2):

- *Rejected pin:* "χ(L) := Euler characteristic of the 2-cover complex twisted by a cocycle of
  `L` **on the pinned 2-cover**, for all `L`." FALSE as stated: a class need not trivialize on
  the pinned 2-cover (`Pic` of an affine Dedekind chart is nonzero — recon lesson 1's
  parenthesis; blueprint gets the counterexample). χ via the 2-cover applies only to classes
  *presented with* a 2-cover trivialization.
- *Honest ledger:* every class over a field is a divisor class (`Picard/
  MeromorphicTrivialization.lean`, §2.6(c), using integrality of `C_K` — geometric integrality
  of `C/k` is exactly what makes this uniform in `K`). Degree is then anchored on divisors:

**The pinned interface** (statements Wave 2 must deliver; shapes binding):

```lean
-- (E-i) normalization, the B4 pushforward-rank shape:
theorem deg_divisorClass_effective (D : effective divisor datum on C_K) :
    deg (divisorClass D) = /- finrank of the finite flat D → Spec K, i.e. dim_K Γ(𝒪_D) -/
-- (E-ii) hom property: deg : Pic (C_K) → ℤ with deg (a * b) = deg a + deg b
-- (E-iii) χ-connection (RR-lite, gives the route's `deg = χ − χ(𝒪)` where χ is defined):
theorem chi_divisorClass (D effective) : χ (divisorClass D) = χ_𝒪 + deg (divisorClass D)
-- (E-iv) invariance under field extension K ↪ K′ (χ-ledger base change; uses
--         sectionsBaseChange + exactness of ⊗ over a field)
```

Well-definedness of (E-ii) across presentations is Wave-2's "principal divisors have degree 0".
Whether Wave 2 *defines* `deg` via χ (with the moving step through `𝒪(n·π^*(hyperplane))`
twists and the Riemann inequality) or via local colengths (StalksDVR orders) is Wave-2
internal; consumers see only (E-i)–(E-iv). The 2-cover χ computations run through the landed
general-coefficients carrier `Scheme.twoCoverH1LinearEquiv` (TwoCover.lean:91): feed it the
**equalizer-presented twisted sheaf** `F_g(W) := {(s₀, s₁) | s₀ = g·s₁ on W ⊓ V₀ ⊓ V₁}` for a
2-cover cocycle `g`; the required `Subsingleton (HModule' F Vᵢ 1)` instances transport along
`F_g|Vᵢ ≅ 𝒪|Vᵢ` — which holds *by construction* of `F_g`, so **no new affine-vanishing
engine is needed**. (Coordination note to Wave 2; verified against the TwoCover hypotheses,
which demand nothing but the two vanishing instances and `U₀ ⊔ U₁ = ⊤`.)

### 6.2 `Pic⁰` as the degree-kernel subfunctor

`Picard/DegreeZero.lean`:

```lean
/-- Degree of an étale Picard class at a field-valued point of the test scheme. -/
def degAt (λ : picEt C T) {K : Type u} [Field K] [Algebra k K]
    (t : Over.mk (Spec.map ⋯) ⟶ T /- a `Spec K`-point of `T` over `k` -/) : ℤ
  -- restrict λ along t into picEt C (Spec K); field-extension covers are cofinal there
  -- (§4.3), so λ|_{Spec K} is represented over some finite separable K′/K; take deg over K′
  -- ((E-ii) applied over K′); well-defined by (E-iv).

/-- The degree-0 subfunctor — the functor the Jacobian represents. -/
def pic0Functor (C) ⋯ : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}
  -- T ↦ {λ : picEt C T | ∀ K t, degAt λ t = 0}, a subgroup; restriction maps restrict
  -- because a field point of T′ composes to a field point of T (this is WHY the definition
  -- quantifies over all field-valued points rather than points of the space: subfunctor
  -- stability is definitional).
```

Audit: this matches Kleiman's fiberwise-strata pattern (his `P^φ` in the proof of 4.8 is cut
out by a fiberwise-χ condition `eq:phi` "for all `t ∈ T`", well-defined "because cohomology
commutes with flat base change" — our (E-iv)). Degree-*constancy* in families (local constancy
of `t ↦ degAt`) is **not needed for the definition** and is deliberately deferred: it needs the
rigid two-term pushforward engine (Mumford AV II.5) and belongs to Wave 4/5.

**The Abel element** (`Picard/AbelElement.lean`), test scheme `T := C`:

```lean
def abelElement (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : pic0 C C :=
  -- picEtUnit of [𝒪(Δ)] * [𝒪(fst⁻¹ P)]⁻¹ on (C ⊗ C).left  (graph of 𝟙 minus constant-P),
  -- degree-0 certificate: at a field point t, deg 𝒪(Γ_t) = 1 (graph has finite-flat rank 1,
  -- §2.6(b), via (E-i)) and deg 𝒪(P_K) = 1 (P is a k-point; (E-i) again). 1 − 1 = 0.
theorem abelElement_map_point : (pic0Functor C).map P.op (abelElement P) = 1
theorem abelElement_baseField ⋯   -- shuffle ∘ base-change of abelElement = abelElement of ε ≫ P_L
```

Then `ofCurve P := d.rep.homEquiv.symm (abelElement P)` realizes route §3's
`t ↦ [𝒪(Γ_t − P_T)]`: for any `t : T ⟶ C`, naturality gives
`t ≫ ofCurve P = homEquiv.symm ([𝒪(Γ_t)] * [𝒪(P_T)]⁻¹)` — the pin, verbatim.

Degree-0 preservation under `picEtMapCurve g` (needed so `pic0MapCurve` exists for Wave 7's
`functor`): at a field point, `g` base-changes to a morphism of curves over `K`; it is constant
(pullback class trivial since `Pic(Spec κ) = 1`) or finite (then `deg (g^*L) = (deg g)·(deg L)`
via `finrank` multiplicativity on divisor classes); either way degree 0 is preserved. The
dichotomy brick is flagged in §4.6.

### 6.3 Relation to the scheme-side identity component (Wave-5 interface)

`J` is *defined* to represent the degree-0 subfunctor (route §3). The statement
"`J = (Pic scheme)⁰` as identity component" is **internal to Wave 5**, needed there only for
`GeometricallyIrreducible (Jacobian C).hom`. Interface notes, so Wave 5 does not re-derive
Wave-3 design:

- Kleiman `lem:agps`(3) (§5.1, read, proof included): `G⁰` is an open and closed subgroup
  scheme of finite type, geometrically irreducible, and its formation commutes with field
  extension. Wave 5 applies it to `J_{k̄}` **once it knows `J` is connected**.
- Connectedness of `J` (equivalently: degree-0 classes over `k̄` form one component) has two
  available routes, Wave-5's choice: (a) the `C^{(g)} ↠ Pic⁰` surjection over `k̄` (image of an
  irreducible scheme; shared with Wave 6/4 — Kleiman `ex:jac` §5.23 context); (b) χ/degree
  local-constancy in flat families + finiteness of components (needs the Wave-4 pushforward
  engine). Route (a) is expected cheaper given Sym^g lands for Albanese anyway.
- **`baseChangeIso` does NOT go through identity components** in this design: the degree-0
  condition is manifestly stable under the base-field shuffle by (E-iv), so
  `pic0Functor (C_L) ≅ (pic0Functor C)`-shuffled directly. This *simplifies* route Wave-7
  item 20 ("`(Pic⁰)_L = (Pic_L)⁰` from #15" becomes unnecessary for `baseChangeIso`);
  `lem:agps`(3) remains a Wave-5-only input. Recorded as a deviation-in-wording in §10.

---

## 7. (F) File layout, lanes, keystones

All files ≤ 500 lines (route rule 6), namespace `AlgebraicGeometry`, blueprint chapter
`blueprint/` per directory with 1-to-1 nodes, `\source{kleiman-picard}` anchors only on
statements §11 covers.

### 7.1 Files (dependency order within lanes)

| # | File | Contents (≈ size) | Depends on |
|---|------|--------------------|-----------|
| 1 | `Picard/UnitsPresheaf.lean` | `unitsPresheaf`, app/naturality lemmas (~150) | — |
| 2 | `Picard/CechH1.lean` | CommGroup on cocycles/H1, `ofPairs`/`ev_inf`, refinement `res`, `res_res` (~450, generic, PR-candidate) | 1 |
| 3 | `Picard/Pic.lean` | `PointedCover`, `CechPic`, CommGroup, `map`, `map_id/comp`, field sanity (~450) | 2 |
| 4 | `Picard/DivisorClass.lean` | `LocalEquations`, `picClass`, independence, mult., pullback (~400) | 3 |
| 5 | `Picard/GraphDivisor.lean` | point divisor (StalksDVR), diagonal as relative divisor, `graphLocalEquations`, base-change, rank-1 certificate (~450) | 4, `Curve/StalksDVR` |
| 5b | `Picard/MeromorphicTrivialization.lean` | integral case: every class is a divisor class (~250) | 4, `Curve/Basic` |
| 6 | `Picard/RelFunctor.lean` | `relPic`, `relPicFunctor`, `relPicMapCurve`, relPic base-field shuffle, `(C ⊗ T).left` bridge lemmas (~400) | 3 |
| 7 | `Cohomology/SectionsBaseChange.lean` | `Γ(V_A) ≅ Γ(V) ⊗[k] A` (~350) | Wave-1 cohomology stack |
| 8 | `Picard/UniversalSections.lean` | `Γ(C_A) = A` universal, `prPullback_injective` (~300) | 7, `Cohomology/TwoCover` |
| 9 | `Descent/InvertibleModule.lean` | ff descent of invertible modules over rings (~450, pure algebra, PR-candidate) | — |
| 10 | `Picard/EtaleCovers.lean` | `EtCover`, refinement/directedness/base change, refinement-map independence, field-cofinality (~400) | 6 |
| 11 | `Picard/PicEtAff.lean` | descent classes, one-plus, CommGroup, unit, affine functoriality (~450) | 10 |
| 12 | `Picard/PicEt.lean` | Layer-2 extension, `picEtFunctor`, `picEtUnit`, `picEt_affine_iso`, `picEtMapCurve`, `picEtBaseField` (~500; split if over) | 11 |
| 13 | `Picard/Separatedness.lean` | (C1) + "one-plus is a sheaf on affines" corollary (~400) | 8, 9, 11 |
| 14 | `Picard/Rigidification.lean` | (C2) statement (+ proof if slack; OPEN-2) (~150 stmt / ~450 proved) | 13 |
| 15 | `RiemannRoch/Degree.lean` | **Wave-2-owned**; interface (E-i)–(E-iv) pinned in §6.1 | Wave-2 ledger, 5b |
| 16 | `Picard/DegreeZero.lean` | `degAt`, `pic0Functor`, `pic0MapCurve` (+ deg-0 preservation statement) (~350) | 12, 15-interface |
| 17 | `Picard/Witness.lean` | `JacobianData`, `grpObj`, `homEquiv`, `uniqueIso`, consumption header doc (~250) | 16 |
| 18 | `Picard/AbelElement.lean` | `abelElement`, `abelElement_map_point`, `abelElement_baseField` (~350) | 5, 16 |

### 7.2 Lanes and parallelism

Immediately parallel start (no mutual deps): **L1** = files 1–3; **L3** = files 7–8; **L5** =
file 9. Then: **L2** = 4, 5, 5b (after L1); **L4** = 6 (after L1); **L6** = 10–12 (after L3,
L4); **L7** = 13–14 (after L5, L6); **L8** = 16 (+15 interface, after L4/L6 and Wave-2
signature freeze); **L9** = 17–18 (17 as soon as 12+16 *signatures* freeze; 18 after L2, 16).

| Lane | Keystone | Verification bar |
|------|----------|------------------|
| L1 | `CechPic.map_comp` (functoriality) | kernel build; `CechPic (Spec K)` trivial; axiom audit |
| L2 | `graphLocalEquations` + base-change lemma | kernel build; `picClass` of the trivial datum = 1; pullback-compat kernel-checked |
| L3 | `Γ(C_A) = A` universal | instantiation at `A := k` reproduces Wave-1's `Γ(C,𝒪) ≅ k` (consistency gate) |
| L4 | `relPicFunctor` laws | kernel build |
| L5 | descent equivalence for invertible modules | kernel build; axiom audit (pure algebra, no scheme imports) |
| L6 | `picEtFunctor` + `picEtUnit` + `picEtBaseField` (statement-complete) | kernel build; `picEt_affine_iso` proved |
| L7 | (C1) separatedness | unit injectivity at `T = Spec K` as smoke test |
| L8 | `pic0Functor` | kernel build |
| L9 | **the wave keystone**: with `variable (d : JacobianData C)`, `d.grpObj : GrpObj d.J` elaborates and kernel-checks | this is the dry-run of the frozen `instGrpObj` discharge; it catches every universe/`forget`-defeq landmine while they are still cheap. Run it before L6/L7 are finished (17 needs only signatures). |

Recon lesson 8 applies to every lane: **kernel-verify every claimed closure** (`lake build` +
`lean_verify`), never trust an LSP-green file.

**L9 keystone status (run 0025, session 0002): dry-run PASSED.** With
`F : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}`, `J : Over (Spec (.of k))` and
`rep : ((F ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J`, all of the
following elaborate against full Mathlib v4.31 with axioms exactly the standard three and **no
universe or `forget`-defeq walls**: `GrpObj.ofRepresentableBy J (F ⋙ forget₂ CommGrpCat GrpCat)
rep`; the unit formula `η[J] = rep.homEquiv.symm 1` **by `rfl`** (the `comp_ofCurve` reduction);
`rep.uniqueUpToIso rep'` (the `baseChangeIso` vehicle); `(.mk J : Grp (Over (Spec (.of k))))`
under the derived instance. Two operational notes: (a) `JacobianData.grpObj` must carry
`@[implicit_reducible]` (linter requirement for defs of class type); (b) the dry-run ran under
`lake env lean` — advisory per route rule 7; re-confirm under `lake build` when `Witness.lean`
lands (expected no-op, the shape has no synth-depth pressure).

**Lane status (run 0027, session 0006).** Landed kernel-green and axiom-clean: file 4
(`Picard/DivisorClass.lean`, L2 — pullback compatibility deferred, everything else including
rescale/refinement/multiplicativity invariance closed), file 10 (`Algebra/EtaleCover.lean`,
L6 — placed under `Algebra/` as pure ring theory, no scheme imports; includes field
cofinality, see OPEN-3 closure in §9), the algebra-map face `Picard/RelPicAlgebra.lean`
(`overSpecMap`/`relPicAlgMap` with strict functor laws; the honest-lemma recipe applies to
`Spec.map`-level equalities — state them at `Spec (CommRingCat.of _)` endpoints, `ext : 1`
then `exact`), and file 11 (`Picard/PicEtAff.lean`, L6): descent classes as a
`MonoidHom.eqLocus`, `descentMap` transport, **`descentMap_congr`** (refinement-map
independence — the keystone; also what makes `inv_mul_cancel` and same-cover multiplication
work), the plus carrier as a sigma-quotient with `CommGroup`, and the unit with tautological
descent data. Elaboration notes for file 11: (i) applying `relPicAlgMap` to homs into tensor
carriers needs the target pinned (`(B := E.Carrier ⊗[A] E.Carrier)`) — the unifier cannot
invert `CommRing.toSemiring`-projections against `Algebra.TensorProduct.instSemiring` when
`B` is still a metavariable; (ii) never let goals mention sigma-literal projections
(`⟨…, …⟩.snd`): define `Mul` by `Quotient.liftOn₂` into `mk`-equalities proved via
`mk_eq_mk_iff`, not `Quotient.map₂` against setoid literals; (iii) prove `mul_assoc`/
`mul_comm` by re-representing all factors on one cover (`← mk_descentMap` with explicit
inclusion maps, then `mk_mul_mk_same` + the group law) — no simp on `descentMap` nests;
(iv) the transport calc chains are heartbeat-hungry (only `mulLift_compat` needs a scoped
4M-heartbeat budget after s0010's repair; everything else fits the default).

**Lane status (run 0027, session 0010).** File 11 repaired and kernel-green (the committed
`PicEtAff.lean` had a whnf-timeout in `mulLift_compat` hidden by the elaborator's error
recovery — I-0138, closed) and wired into the library root.  The `descentMap_congr`
keystone was generalized to **`relPicAlgMap_congr`** (a descent class restricts equally
along any two `A`-algebra maps out of the cover carrier into *any* compatible test algebra),
and the L6 functoriality item landed on top of it: `Picard/PicEtAffMap.lean` provides
`descentBaseChange`, `PicEtAff.map` (base extension as `[Algebra A A'] [IsScalarTower k A A']`
instances), unit naturality `map_unit`, functor laws `map_id`/`map_map` (both are instances
of `relPicAlgMap_congr`), and the explicit-algebra-map face `mapAlg` with its laws.  All
axiom-clean.  Still open in L6: the Layer-2 extension (file 12), now gated on file 13's
sheaf-on-affines corollary — see the revised OPEN-1 in §9.

### 7.3 Semantic-audit checklist (route rule 2)

Every pinned statement gets this audit before a proof is attempted; the blueprint node cites
the anchor. "K §x.y (`label`)" = Kleiman TeX, read (§11).

| Pin | Source anchor | Audit note |
|-----|---------------|------------|
| `CechPic = Ȟ¹(𝒪ˣ)` semantics | K §2.11 (`rk:coh`), eq (`eq:2b`); Hartshorne III Ex 4.5 cited there | definitional; sheaf-module comparison Phase-2 |
| `relPic := Pic(C×T)/Pic(T)` | K §2.2 (`df:Pfs`) | never the absolute functor — K §2.1 (`df:aPf`) + I-0061 certified trap |
| separatedness (C1) | K §2.5 (`th:cmp` part 1) + §2.7 (`lm:fff`) | hypothesis via K §3.11 (`ex:gc&r`); recast proof uses ring-level descent (file 9) instead of `f_*` sheaf-language |
| comparison under section (C2) | K §2.5 part 2 + §2.8–2.10 (`df:rgd`, `lm:idn`, `lm:aut`) | needed only over `k'` with `C(k') ≠ ∅`; NOT stated with `HasRationalPoint C` over `k` (the challenge takes no point) |
| one-plus = sheafification | standard plus lemma + (C1) | claimed on affine tests only; Layer 2 is the canonical Zariski extension (honesty note in blueprint) |
| representability target | K §4.8 (`th:main`) | our hypotheses: projective (Wave-4 N2) + flat + geometrically integral over `k`; étale level is the pinned one — fppf (K §4.18.3 `cor:algsch`) not needed, its machinery (`th:genrep`/`th:rrep`, Oort dévissage) off-route |
| lft certificate stored, not derived | K §4.17 (`prp:lft`) | deviation justified: EGA 8.14.2 limit criterion is a multi-week detour; construction knows lft directly |
| base change of the Pic scheme | K §4.4 (`ex:bschg`) | our `baseChangeIso` = degree-0 version via shuffle + (E-iv), see D7 |
| graph divisor / Abel map | K §3.8 (`ex:DivC`), §5.26 (`rmk:Jac`), §4.13 (`ex:Abel`) | **sign**: Kleiman's `A_𝓛(t)` uses `𝓛_T ⊗ 𝒪(−Γ_t)`; route pins `[𝒪(Γ_t − P_T)]` = its inverse. Both satisfy the frozen statements (`P ↦ 0`, Albanese); route's sign kept; blueprint notes the discrepancy |
| `Pic⁰` fiberwise-condition pattern | K §4.8 proof (`eq:phi`, "for all `t ∈ T`") | degree replaces Hilbert polynomial (recon lesson 6); constancy-in-families deliberately NOT part of the definition |
| identity-component interface | K §5.1 (`lem:agps`), §5.3 (`prp:pic0`), §5.4 (`th:qpp&p`) | Wave-5 consumers; connectedness of `J` is an obligation (two routes, §6.3), not a freebie |
| tangent/smoothness context | K §5.11 (`thm:tgtsp`), §5.13 (`cor:sm`) | Wave-5; recorded so `T₀J = H¹(𝒪)` is stated against the étale-representing functor, as Kleiman does |
| REJECTED: 2-cover-only χ for all L | recon lesson 1 (Dedekind-chart counterexample) | replaced by the meromorphic bridge + divisor-anchored ledger (§6.1) |
| REJECTED: absolute-Pic representability | K §2.1 discussion ("never representable") | counterexample (`T := ℙ¹_X`, `𝒩 := 𝒪(1)`) goes in the blueprint |

---

## 8. What Wave 3 does NOT do (scope fence)

No representability proof (Wave 4). No smoothness/properness/irreducibility of `J` (Wave 5).
No Sym^g, no rational-map extension (Wave 6). No discharge of any frozen `sorry` (final
assembly). No monoidal structure on sheaf categories, no `Scheme.Modules`-carried line bundles,
no Quot schemes, no general `R^i f_*` (route rule 5; recon lessons 1–2). No genus-0 fork
(route rule 8): every statement here is uniform in `g`.

---

## 9. Open sub-decisions

- **OPEN-1 (Layer-2 vehicle). PARTIALLY CLOSED (run 0027, session 0010): both named
  vehicles as stated hit the same wall, and the wall is file 13's corollary — so the lane
  order is 13 → 12.** Analysis: (i) the *bespoke limit over the affine-opens poset* of
  `T.left` is `Type u`-small and gives `picEt_affine_iso` cheaply (`⊤` is terminal in the
  poset of an affine `T`), but functoriality along `f : T' ⟶ T` requires evaluating a
  family at the affine test `U' ⊆ T'.left`, whose image need not lie in **any** affine open
  of `T.left`; the evaluation must be *glued* from a finite cover of `U'` by basic opens
  refining `f⁻¹(affines)` — i.e. it needs exactly "the one-plus is a Zariski sheaf on
  affines" (file 13's corollary to (C1) separatedness plus descent).  (ii) the *comma-category
  Ran formula* (`lim` over all affine tests `(A, g : Spec A ⟶ T)`) has composition-only
  functoriality but a `Type (u+1)` index with no small cofinal subfamily for general `T`
  (images of affines need not factor through affine opens; fg-algebras are not cofinal
  in all test algebras), and the presented-test smallness trick fails because
  `Fin n`-presentations only reach fg algebras while `Γ(U)` is not fg in general.
  (iii) mathlib v4.31's `Sites/Affine.lean` (`isCoverDense_toOver_Spec`) lives on the
  small `P`-site (`MorphismProperty.CostructuredArrow`), and the `IsCoverDense` sheaf
  extension would require the sheaf property on affines anyway, plus an opaque
  `ran`-extension to compute through.  *Resolution:* land file 13's
  "one-plus is a Zariski sheaf on affines" first, then implement Layer 2 as the bespoke
  affine-opens limit with glue-based functoriality (choice-independence of the gluing from
  sheaf uniqueness).  Prerequisite landed (s0010): `PicEtAff.map`/`mapAlg` functoriality in
  the test algebra with unit naturality and functor laws (`Picard/PicEtAffMap.lean`).
  Owner: L7 then L6.
- **OPEN-2 (Rigidification proof scheduling).** (C2)'s statement is Wave-3 (file 14); its proof
  is Wave-4-critical-path but not Wave-3-blocking. *Close by:* L7 capacity after (C1) lands;
  if L7 finishes (C1) with slack, prove (C2) now.
- **OPEN-3 (étale cover index). CLOSED (run 0027, session 0006): presentations, kernel-ideal
  realization.** `Algebra.EtaleCover A` = `(n : ℕ, ideal : Ideal (MvPolynomial (Fin n) A),
  étale, Spec-surjective)` — the ideal is arbitrary (finite generation is *implied* by
  étale ⇒ finitely presented, never stored), and every operation goes through the
  choice-based constructor `of B hB` (= `ofSurjective` at a chosen `FiniteType`
  presentation) plus its carrier equiv `ofEquiv`. This kills the anticipated
  relation-concatenation fiddle: directedness = `of (B ⊗[A] B')` with étale/faithfully-flat
  instances (`Etale.baseChange` + `Etale.comp`; `FaithfullyFlat.trans` + the FF base-change
  instance + `PrimeSpectrum.comap_surjective_of_faithfullyFlat`), base change =
  `of (A' ⊗[A] B)`, all under 300 lines total including the **field-cofinality theorem**
  (proved immediately via mathlib's `Algebra.Etale.iff_exists_algEquiv_prod`).
  `Refines` is a mere-existence `Prop`, per the §4.4 choice discipline;
  `descentMap_congr` (refinement-map independence, landed in `Picard/PicEtAff.lean`)
  is what makes any chosen map usable.
- **OPEN-4 (units-presheaf factoring).** Existence of the `forget₂ CommRingCat CommMonCat`
  composition path in v4.31; otherwise a bespoke 20-line functor. *Close by:* first hour of L1.
- **OPEN-5 (`degAt` quantification).** Pinned: quantify over all `K : Type u` field points
  (subfunctor stability definitional). The optional lemma "enough to check residue fields of
  points of `T`" is nice-to-have, not consumed by any pinned target; drop it if idle.

---

## 10. Route compliance and deviations

Compliant by construction: rules 1 (keystone funnels per lane, §7.2), 3/4 (datum-carrying
gate, one pinned universal element, §5, §4.6), 5 (scope fence §8), 6 (file sizes, blueprint
obligations), 7 (verification bars), 8 (no genus fork), 9 (walls catalogued at the spots they
will bite: `Over.pullback` opacity §1, `forget` defeq §5, `eqToHom` on covers §2.5).

Deviations, each flagged and justified:

1. **Wave-7 item 20 wording** ("`baseChangeIso` … + `(Pic⁰)_L = (Pic_L)⁰` from #15"): in this
   design `baseChangeIso` consumes degree-invariance under field extension (E-iv) instead of
   identity-component theory, because `Pic⁰` is *defined* by the degree kernel (route §3's own
   pin: "the degree-0 part of the étale-sheafified relative Picard functor"). Item 15 remains
   the input for `GeometricallyIrreducible` only. Net effect: strictly fewer obligations on
   the `baseChangeIso` path; no semantic change to any pin.
2. **Route Wave-3 item 9** says "on affine test schemes"; the frozen `instGrpObj` forces the
   functor to exist on all of `Over (Spec k)`, hence the two-layer design (§4.3). The étale
   content still lives entirely on affine tests, which is what item 9 intends.
3. **`prp:lft` not proven** (certificate stored, §5) — justified in the audit table.
4. Kleiman's Hilbert-polynomial strata (`P^φ`) are replaced by degree strata (recon lesson 6);
   this is a Wave-4-internal deviation already adopted by the route (§4 item 12 endorses the
   D3 campaign decomposition; `lm:qt`'s Hilbert-scheme quotient machinery stays off-route).

Nothing in this spec contradicts a route §3 semantic pin or a §5 binding rule.

---

## 11. Kleiman reading log (basis for every citation above)

Read in `references/kleiman-picard-src/kleiman-picard.tex` (TeX source; no transcription needed,
none produced; manifest untouched):

- **§2 complete** (L1266–1694): `df:aPf` (2.1), `df:Pfs` (2.2), `ex:Alr` (2.3), `ex:Pfs` (2.4),
  `th:cmp` (2.5) with both proofs, `ex:gpts` (2.6), `lm:fff` (2.7) with proof, `df:rgd` (2.8),
  `lm:idn` (2.9) with proof, `lm:aut` (2.10) with proof, `rk:coh` (2.11) incl. `eq:2b`–`eq:2e`.
- **§3 partial**: `th:repDiv` (3.7) with proof, `ex:DivC` (3.8), `rmk:symprod` (3.9), `sb:Q`
  header (3.10), `ex:gc&r` (3.11), `df:LinSys` (3.12) and the surrounding discussion.
- **§4**: opening through `lm:qt` (4.1 `df:Psch`, 4.2 `ex:0sec`, 4.3 `ex:univshf`, 4.4
  `ex:bschg`, 4.5 `ex:schpts`, 4.6 `dfn:Abel`, 4.7 `ex:PQ-Abel`, 4.8 `th:main` **with full
  proof**, 4.9 `lm:qt` with proof, 4.10 `ex:epi` opening); `ex:Abel` (4.13); `eg:Mumford`
  (4.14, opening); `ex:PE` (4.15); `ex:PfsCtd` (4.16); `prp:lft` (4.17) with proof; the whole
  `rk:exist` block (4.18, incl. 4.18.1 `th:Mumford`, 4.18.2 `th:genrep`, 4.18.3 `cor:algsch`,
  4.18.4 `th:flatten`, 4.18.5 `th:rrep`, 4.18.6 `th:algsp`).
- **§5**: opening; `lem:agps` (5.1) with full proof; `rk:Gred` (5.2); `prp:pic0` (5.3);
  `th:qpp&p` (5.4) with proof; `cor:Poincare` (5.5, statement + proof opening); `thm:tgtsp`
  (5.11, statement + proof opening); `rmk:tgtsp` (5.12); `cor:sm` (5.13) with proof;
  `cor:ch0` (5.14); `rmk:Igusa` (5.15, opening); `ex:jac` (5.23); `rmk:Ablsch` (5.24);
  `rmk:Alb` (5.25); `rmk:Jac` (5.26); `rmk:Jacsp` (5.27).

Not read (and therefore not cited anywhere above): §3's `lm:ctn`/`th:LinSys` proofs, §4.10–4.12
answer details, §5.6–5.10 and 5.16–5.22 bodies, §6 (`sc:Pictau`) beyond its introduction, the
appendices. Any future pin resting on those must read them first (references skill rule).
