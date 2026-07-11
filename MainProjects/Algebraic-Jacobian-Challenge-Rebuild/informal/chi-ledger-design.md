# χ-ledger / degree-lane design spec (Wave-2 item 7)

*2026-07-11, Fable-5 χ-design session. **Binding** for route-decision §4 item 7 (the
`RiemannRoch/Degree.lean` lane) and for the consumer interface (E-i)–(E-iv) pinned in
`informal/wave3-picard-design.md` §6.1. Inputs, all read in full or in the cited sections:
`informal/route-decision.md`, `informal/wave3-picard-design.md` (§§0–7, 9–11),
`informal/chi-ledger-notes.md`, `informal/old-draft-picard-recon.md`, the landed Lean modules
(docstrings + main statements: `Cohomology/{ModuleKSheaf,OverOpen,AffineVanishing,MayerVietoris,
TwoCover,Finiteness,FinitenessP1}`, `Curve/{Basic,Sections,StalksDVR,DedekindSections,MapToP1,
P1,P1Charts,RationalToP1}`, `Algebra/TwoLattice` headers, `Challenge.lean`), the Mathlib v4.31
checkout (every API claim below grep-verified, file:line given), and the references listed in
the reading log (§12). Lean snippets are **intended signatures**: binding in shape (carriers,
what is data vs Prop, quantifier structure), lane-owned in spelling. **OPEN-n** items have
closing criteria in §9.*

---

## 0. Decisions at a glance

| # | Decision | Section |
|---|----------|---------|
| X1 | **Carrier of `𝒪(D)`: divisor-first function-field subsheaves.** `𝒪(D)` is the subsheaf of the constant function-field sheaf cut by stalkwise valuation bounds, an object of the landed category `Sheaf (Opens.grothendieckTopology X) (ModuleCat K)`. Never a cocycle twist, never a `Scheme.Modules` object. Confirms chi-ledger-notes option 3; options 1–2 and three further alternatives weighed and rejected in §2. | §2, §4 |
| X2 | **Divisor = `Finsupp` on closed points**; `deg D := Σ n_x·[κ(x):K]` (residue-degree-weighted, *order-first*). The route's `deg L = χ(L) − χ(𝒪)` holds as the theorem (E-iii), not as the definition. Unweighted degree is FALSE over non-closed fields (counterexample §11). | §3 |
| X3 | **Dévissage vehicle: skyscraper short exact sequences in whole-site Ext.** `H¹(sky) = 0` via "skyscraper of an injective module is an injective sheaf" (mathlib `stalkSkyscraperSheafAdjunction` + `Injective.injective_of_adjoint` + the landed `Ext¹`-criterion). **No twisted affine vanishing, no slice-Ext comparison, no Mayer–Vietoris for any sheaf other than `𝒪` — anywhere in the lane.** The wave3 §6.1 coordination note about equalizer-presented twisted sheaves `F_g` is MOOT. | §4 |
| X4 | **Principal divisors have degree 0 via the multiplication isomorphism** `·f : 𝒪(D) ≅ 𝒪(D − div f)` plus χ-invariance plus (E-iii). The classical `[F:K(x)]`-lattice/norm route (cff Thm 12.6, papaioannou Thm 1.11) and the repartition route are REJECTED as proof routes (documented §2.3, §11); the notes' candidate ("two-chart argument over ℙ¹ via the landed π") is **overturned** — the χ-route needs no `π : C → ℙ¹` at all. | §5.4 |
| X5 | **(E-iv) at divisor level through the Dedekind colength formula** `deg(D∣chart) = finrank_K(B⧸(f))` + flat `⊗_K K'`; the χ-level H¹ base change is delivered separately (only for `𝒪`, via the landed structure-sheaf two-cover + `SectionsBaseChange`) to give `h¹(C_K) = genus C`. | §6.4 |
| X6 | The whole ledger is stated **uniformly over an arbitrary base field `K`** carrying the curve bundle hypotheses; `C_K` enters only through a small instance-transport file. `deg` on `CechPic` classes lives in ONE junction file (`RiemannRoch/Degree.lean`) — the only file of the lane touching Wave-3 (L2) carriers. | §1, §6, §7 |
| X7 | 11 new Lean files, 4 immediately parallel lanes; wave keystone = `chi_divisorSheaf` + `deg_div_eq_zero` (§7.2). | §7 |

---

## 1. Standing conventions

- **Hypothesis bundle, generic-base form.** The ledger core is stated for
  `{K : Type u} [Field K] (X : Scheme.{u}) [X.Over (Spec (.of K))]` with the three curve
  instances **on the structure morphism**: `[SmoothOfRelativeDimension 1 (X ↘ Spec (.of K))]`,
  `[IsProper (X ↘ Spec (.of K))]`, `[GeometricallyIrreducible (X ↘ Spec (.of K))]`, plus the
  Wave-1 instances they trigger (`GeometricallyReduced` ⇒ `IsIntegral X` via `Curve/Basic` +
  `Curve/GeometricallyReduced`). Bundle-level corollaries for `C : Over (Spec (.of k))` are
  keyed on **exactly** the Challenge spelling `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`
  (as `Cohomology/Finiteness.lean:387–394` already does), so `χ(𝒪) = 1 − genus C` matches
  `genus` (`Challenge.lean:89–92`) definitionally.
- **Why generic-base.** (E-iv) and `degAt` (wave3 §6.2) evaluate the ledger at every field
  `K/k` at once; stating everything for the abstract bundle makes base change a matter of
  *instance transport* (§6.4, file R9) rather than of restating theorems. The needed stability
  instances are mathlib gifts, verified: `MorphismProperty.IsStableUnderBaseChange` for
  `@GeometricallyIrreducible` (`Geometrically/Irreducible.lean:49`), `@GeometricallyIntegral`
  (`Geometrically/Integral.lean:66`), `@SmoothOfRelativeDimension n` (`Morphisms/Smooth.lean:167`),
  and `IsProper` (standard).
- **Cohomology carrier**: the landed `Sheaf.HModule F n` (whole-site Ext from the constant
  sheaf, `Cohomology/ModuleKSheaf.lean`) at `R := K`, on the site `Opens.grothendieckTopology X`.
  All sheaves of the lane live in `Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} K)`.
  Note `TopCat.Sheaf C X` is **definitionally** `Sheaf (Opens.grothendieckTopology X) C`
  (`Mathlib/Topology/Sheaves/Sheaf.lean:108`), so mathlib's topological skyscraper/stalk API
  applies to our category on the nose.
- **Universe discipline**: single universe `u`, as in the landed cohomology stack. No `ULift`.
- **Noetherianity**: where a file needs `TopologicalSpace.NoetherianSpace X` (finiteness of
  divisor supports), derive it inline exactly as `Curve/RationalToP1.lean:207–210` does:
  `IsLocallyNoetherian X := LocallyOfFiniteType.isLocallyNoetherian _`, then `IsNoetherian X := ⟨⟩`.
- **Verification bar** (route rule 7): `lake build <Module>` kernel check + `lean_verify` axiom
  audit (`propext, Classical.choice, Quot.sound` only) on each keystone. LSP advisory only.
- **Choice discipline** (wave3 §4.4, binding here too): `Classical.choice` may be used inside
  constructions (e.g. `classDeg` picks a bridge presentation) provided the *value* is proven
  choice-independent; `Nonempty`-only data and sorried data remain forbidden.

---

## 2. The carrier decision (task pin 1)

### 2.1 What the consumers actually force

Tracing every pinned consumer (wave3 §6.1–6.2, route item 7, Wave-4 N2):

1. (E-i): a *number* attached to an effective `LocalEquations` datum, equal to
   `dim_K Γ(𝒪_D)` (pushforward-rank / B4 shape).
2. (E-ii): `deg` on `CechPic ((C_K).left)` classes, additive.
3. (E-iii): a χ attached to divisor data, satisfying `χ = χ(𝒪) + deg`.
4. (E-iv): invariance of 2 under `K → K'`.
5. Riemann inequality: `h⁰(𝒪(D)) ≥ deg D + 1 − g` (Wave-4 N2 growth).
6. `χ(𝒪) = 1 − g`, finiteness of all `h⁰/h¹` involved.

No consumer needs: χ of an arbitrary Pic class *presented as a cocycle* (the meromorphic
bridge always supplies a divisor presentation first); tensor products of sheaves; pullback
functoriality of `𝒪(D)` along morphisms other than field-extension projections; Serre duality;
uniform `h¹`-vanishing (Wave-4-owned, route item 12).

### 2.2 Options weighed

| Option | Verdict | Reason |
|---|---|---|
| (a) **Cocycle twists `F_g` on the pinned 2-cover + slice-Ext comparison** (notes option 1: prove `Ext^n_{Sh(X)}(j_!A, F) ≃ Ext^n_{Sh(U)}(A, F∣_U)`, transport the landed affine vanishing along `F_g∣_{Vᵢ} ≅ 𝒪∣_{Vᵢ}`) | REJECTED | Ground truth (notes, verified in tree): `HModule'` is whole-site Ext (`OverOpen.lean:268`); restricted isos do *not* act on it, so the comparison lemma is a genuine mathlib-PR-grade prerequisite (exactness of `j_!`, injectives under restriction) sitting on the critical path of every χ statement. Moreover a class need not trivialize on the pinned 2-cover at all (Dedekind-chart counterexample, wave3 §7.3 REJECTED-row), so a refinement layer would be needed *on top*. Two engines for zero consumer-visible gain over (c). |
| (b) **Re-run Serre cobounding for twisted sheaves** (notes option 2: generalize `IsAffineOpen.cokernel_app_surjective` beyond `moduleKSheaf`) | REJECTED | The landed proof (`AffineVanishing.lean`, docstring + §309) manipulates `Γ`-sections of the *structure sheaf* over basic opens (localization surjectivity); generalizing to "invertible-glued" sheaves means re-proving quasi-coherence-style lemmas for a bespoke sheaf class — a general engine forbidden by route rule 5, and still cover-dependent. |
| (c) **Divisor-first function-field subsheaves** (notes option 3) | **ADOPTED** | See §2.3. The only cohomological inputs are: the landed structure-sheaf facts, one skyscraper vanishing (§4.3, cheap by verified mathlib gifts), and the covariant Ext LES (verified: `Mathlib/Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean:143,151,158`). |
| (d) **Repartition/adele carrier** (Serre GACC / papaioannou §2 style: `H¹(D) := R/(R(D)+F)`) | REJECTED | Route rule 5 verbatim ("no global adele space"). Would also duplicate the landed derived-functor `H¹` and need a comparison to it for `χ(𝒪) = 1 − g`. |
| (e) **Hilbert-polynomial degree** (old draft) | REJECTED | Recon lesson 3 (old-draft-picard-recon §3): `PicScheme.degree` "stayed a bare `sorry` the whole campaign — blocked on Hilbert-polynomial machinery that never landed". Structural reason, understood per task: Hilbert polynomials need `𝒪(1)`/Serre twists, i.e. a projective embedding — which is N2, which *consumes* the degree lane. Circular. |
| (f) **Pushforward-to-ℙ¹ lattice χ** (define χ/deg via `π_*` modules over `k[t]`, extending `Algebra/TwoLattice`) | REJECTED | Makes every χ statement depend on the non-canonical `π` and on lattice bookkeeping per divisor; (E-ii)/(E-iv) would need `π`-independence and base-change of `π`. The finite `π` remains what it already is: the finiteness engine for `H¹(𝒪)` (landed), consumed once. |

### 2.3 The adopted shape, and the two corrections to the notes

Adopted from chi-ledger-notes "recommended shape": `𝒪(D)` as subsheaf of the constant
function-field sheaf; skyscraper quotients; χ additivity by the Ext LES; finiteness by
dévissage from the landed `Module.Finite k H¹(C,𝒪)`; (E-iv) via `SectionsBaseChange` + flat
`⊗_K K'`. **Audit outcome: recommendation CONFIRMED**, with two corrections:

1. **The notes underspecified the one new cohomological brick.** Skyscraper dévissage via the
   LES needs `H¹(X, sky) = 0`, which is *not* free from "the LES is available": it needs an
   acyclicity input. Computing it through the two-cover would re-import the twisted-affine-
   vanishing problem the notes set out to avoid (a skyscraper is not `𝒪` on the charts). The
   honest route (§4.3): skyscraper of an injective `K`-module is an injective *sheaf*
   (adjunction `stalk ⊣ skyscraper` — mathlib `stalkSkyscraperSheafAdjunction`,
   `Topology/Sheaves/Skyscraper.lean:400`, left adjoint preserves monos —
   `Topology/Sheaves/Stalks.lean:544`, `Injective.injective_of_adjoint` —
   `CategoryTheory/Preadditive/Injective/Basic.lean:195`), then one application of the landed
   criterion `Abelian.Ext.subsingleton_one_of_injective_of_surjective`
   (`AffineVanishing.lean:61`) with `I := sky(I⁰)`. Whole-site, no affine hypothesis anywhere.
2. **The notes' route for "principal divisors have degree 0" is overturned.** The notes
   proposed "order-sum of a rational function vanishes — Weil repartition / two-chart argument
   over ℙ¹ via the landed finite π". Both variants are strictly heavier than needed and the
   order-sum statement is exactly where non-perfect/non-closed subtleties concentrate
   (norms/inseparability, residue-weighting). Instead (§5.4): multiplication by `f` is a
   `K`-linear sheaf isomorphism `𝒪(D) ≅ 𝒪(D − div f)`; χ is iso-invariant; with (E-iii) for
   *arbitrary* divisors, `deg(div f) = χ(𝒪(div f)) − χ(𝒪) = 0`. Truth-audit §11: valid over
   any field, any (in)separability. The classical order-sum theorem is *recovered* as a
   corollary, never used as an input.

---

## 3. Divisors and degree (task pin 2 and the deg part of pin 3)

### 3.1 Closed points (file R2)

```lean
-- On the curve bundle, "closed point" ⟺ "≠ generic point" (landed:
-- Scheme.isClosed_singleton_of_forall_specializes + specializes_eq_genericPoint_or_eq).
-- Deliverables at a closed point x:
theorem isDiscreteValuationRing_stalk (hx : x ≠ genericPoint X) :
    IsDiscreteValuationRing (X.presheaf.stalk x)
  -- re-run of the landed IsAffineOpen.valuationRing_stalk case split (StalksDVR.lean:50–70):
  -- x ≠ generic ⇒ the chart prime is ≠ ⊥ ⇒ the DVR branch; plus IsDedekindDomain via
  -- IsPrincipalIdealRing.isDedekindDomain (Mathlib RingTheory/DedekindDomain/Basic.lean:171)
def stalkHeightOne (hx) : IsDedekindDomain.HeightOneSpectrum (X.presheaf.stalk x)
  -- the maximal ideal; ne_bot from ¬IsField
noncomputable def ord (hx) : Valuation X.functionField ℤᵐ⁰ := (stalkHeightOne hx).valuation _
  -- via the mathlib instance IsFractionRing (stalk x) X.functionField
  -- (AlgebraicGeometry/FunctionField.lean:157, needs IsIntegral X — Wave-1 instance)
noncomputable def ordUnits (hx) : X.functionFieldˣ →* Multiplicative ℤ   -- ℤ-valued order hom
noncomputable def residueDeg (K) (x) : ℕ := Module.finrank K (X.residueField x)
theorem residueDeg_pos / residueDeg_finite :
    0 < residueDeg K x ∧ Module.Finite K (X.residueField x)   -- for x closed
```

`residueDeg_finite` is Zariski's lemma on the Dedekind chart: `κ(x)` is a field, finite-type
over `K` (chart ring is), hence module-finite — mathlib
`finite_of_finite_type_of_isJacobsonRing` (`RingTheory/Jacobson/Ring.lean:675`, fields are
Jacobson). The `K`-module structures on `κ(x)` and on the stalk are carried by explicit
`algebraMap` composites through `X ↘ Spec (.of K)` in the style of `Scheme.overAlgebraMap`
(`ModuleKSheaf.lean:192`) — never a global `Algebra` instance (same overlap hazard).

**Vocabulary decision (OPEN-2 default).** The stalkwise `HeightOneSpectrum`-valuation is the
pinned order vocabulary: it is chart-free (no chart-independence lemma needed), `g = 0` is
handled by the valuation's bottom automatically, and the FLT-style `ℤᵐ⁰` API
(`intValuation`/`valuation`, `DedekindDomain/AdicValuation.lean:169,327`) is the most complete
order toolbox in v4.31 (no `HeightOneSpectrum.ord` exists there — grep-verified). Fractional-
ideal membership and `IsDiscreteValuationRing`-multiplicity phrasings are fallbacks.

### 3.2 The divisor group and `deg` (file R3)

```lean
/-- Weil divisors on the curve: finitely supported ℤ-valued functions on closed points. -/
def Scheme.CurveDivisor (X : Scheme.{u}) : Type u := {x : X // x ≠ genericPoint X} →₀ ℤ
-- AddCommGroup, pointwise partial order, `Effective D := 0 ≤ D`, single-point divisors —
-- all free from Finsupp. (OPEN-3: subtype-index vs full-index-with-support-condition.)

/-- Degree, weighted by residue degrees over the base field. -/
noncomputable def CurveDivisor.deg (K) (D : X.CurveDivisor) : ℤ :=
  D.sum fun x n => n * (residueDeg K x.1 : ℤ)
theorem deg_add : deg K (D + D') = deg K D + deg K D'      -- (E-ii) divisor half, free
theorem deg_single : deg K (single x n) = n * residueDeg K x.1

/-- The principal divisor of a nonzero rational function. -/
noncomputable def divOf (f : X.functionFieldˣ) : X.CurveDivisor
  -- x ↦ ordUnits x f; finite support: f is the generic germ of a section s on a nonempty
  -- open U (stalk = colimit); ord = 0 on U ⊓ basicOpen s (mem_basicOpen germ-unit,
  -- Mathlib AlgebraicGeometry/Scheme.lean:658) and off it the locus is closed, avoids the
  -- generic point, hence finite (landed Scheme.finite_of_isClosed_of_notMem_genericPoint +
  -- the §1 Noetherian derivation); poles = zeros of f⁻¹, same argument.
theorem divOf_mul : divOf (f * g) = divOf f + divOf g       -- ordUnits is a hom
```

### 3.3 Interface to L2's `LocalEquations`/`picClass` — the binding coordination note

The two lanes keep **one divisor notion each, with a pinned one-way bridge owned by this
lane**; no lane redefines the other's carrier.

- L2's `Scheme.LocalEquations` (wave3 §2.6(a)) is the *Cartier-style datum* (cover + equations
  + regularity + unit ratios) used to build cocycle classes on arbitrary schemes.
- This lane's `CurveDivisor` is the *Weil-style ledger index* on the curve.
- Bridge (this lane, file R11): for `d : X.LocalEquations` on the curve,

```lean
noncomputable def LocalEquations.toDivisor (d : X.LocalEquations) : X.CurveDivisor
  -- x ↦ ord_x of the generic-germ ratio of d's equation at x (well-defined: the
  -- ratio_isUnit field makes the order independent of the chart index; finite support
  -- by the same closed-locus argument as divOf, using regularity)
theorem toDivisor_effective (hd : ∀ x, d is regular-section data) : 0 ≤ d.toDivisor
theorem toDivisor_mul, toDivisor_pullback_field  -- multiplicativity; §6.4 base-change compat
```

  **No Weil→Cartier constructor is built** (audited: no consumer needs one — every class-level
  statement starts from L2 data or from the meromorphic bridge, both already Cartier-style).

- **Exact asks to L2** (the only adjustments requested; wave3 file numbering):
  1. *(file 5b, `MeromorphicTrivialization`)* the bridge statement in the ∃-form
     `∀ λ : X.CechPic, ∃ d₁ d₂ : X.LocalEquations, effective d₁ ∧ effective d₂ ∧
     λ = picClass d₁ * (picClass d₂)⁻¹` — wave3 §2.6(c) already intends this; pinning the
     ∃-form (rather than a "divisor class group ≃" packaging) is what `classDeg` (§6.2) consumes.
  2. *(file 5, `GraphDivisor`)* the rank-1 certificate for the graph/point divisor at a
     field-valued point should be delivered as (or imply): *support of the datum is the single
     point `x₀ = image of t`, and the equation germ at `x₀` has order 1*. Together with
     `κ(x₀) ≅ K` (free: `x₀` is the image of a section of the structure morphism, so
     `K → κ(x₀) → K` splits) this makes `deg (toDivisor (graph datum)) = 1` a `deg_single`
     computation — realizing wave3 §6.2's "deg 𝒪(Γ_t) = 1 via (E-i)". The scheme-theoretic
     phrasing `𝒪_{Γ_t} ≅ 𝒪_T` may stay as L2's internal form; the order/support certificate is
     what crosses the interface.
  3. *(file 4, `DivisorClass`)* no change; this lane consumes `picClass`, its
     multiplicativity, rescaling-independence, and pullback-compatibility exactly as pinned.

### 3.4 `Γ(𝒪_D)` normal form — the (E-i) carrier

The "finite flat `D → Spec K` pushforward rank" of (E-i) is realized **without constructing a
divisor subscheme**: for effective `d : X.LocalEquations` define the *sections module*

```lean
noncomputable def LocalEquations.sectionsModule (d) : Type u :=
  Π x ∈ d.support, (X.presheaf.stalk x) ⧸ Ideal.span {d.germ x}   -- finite product, K-module
```

This *is* `Γ(D, 𝒪_D)` — semantic anchor: Stacks `lemma-chi-tensor-finite` (2)
(`stacks-varieties.tex:6208`, read): for a dim-0-support coherent module,
`H⁰(X, F) = ⊕_{x ∈ Supp F} F_x`; and Stacks `lemma-degree-effective-Cartier-divisor`
(`stacks-varieties.tex:9832`, read): `D` is finite over `Spec k` with
`deg(D) = dim_k Γ(D, 𝒪_D)`. Deviation from a literal scheme-with-finite-flat-morphism
realization is flagged in §10.

---

## 4. The sheaf ledger (task pins 1/4, cohomological substrate)

### 4.1 `𝒪(D)` as a subsheaf of the constant function-field sheaf (file R4)

```lean
/-- The subsheaf of K(X) of rational functions with poles bounded by D. -/
noncomputable def Scheme.divisorSheaf (K) (D : X.CurveDivisor) :
    Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} K)
  -- sections over U: {g : X.functionField | ∀ x ∈ U, x ≠ generic →
  --                      ord x g ≤ ofAdd (D x) in ℤᵐ⁰}   (g = 0 included: valuation 0 = ⊥)
  -- a K-submodule of K(X): K ⊆ 𝒪ˣ_x ∪ {0} (structure map through a local ring), and
  -- valuation bounds are closed under + and K-scaling. Restrictions: Submodule.inclusion.
  -- Sheaf condition: via isSheaf_iff_isSheaf_forget on the Type-level presheaf, as the
  -- landed isSheaf_moduleKPresheaf did (ModuleKSheaf.lean:247): on an irreducible space a
  -- compatible family of elements of K(X) indexed by a cover is a single element (any two
  -- nonempty opens meet), and the defining predicate is pointwise-local.
theorem divisorSheaf_mono (h : D ≤ D') : divisorSheaf K D ⟶ divisorSheaf K D'  -- Mono, sectionwise ⊆
```

*Sign convention*: `g ∈ 𝒪(D)(U) ⟺ ord_x(g) ≥ −D_x` on `U`, i.e. `L(D) := Γ(𝒪(D))` is
papaioannou Def 1.9 / cff §12 `L(A)` verbatim (both read). In the `ℤᵐ⁰` vocabulary the
condition reads `valuation g ≤ exp(D x)` — monotone-decreasing exp convention of
`intValuation`, pinned so the lane never mixes the two directions.

### 4.2 `𝒪(0) ≅ 𝒪` — the anchor iso (file R4)

```lean
noncomputable def divisorSheafZeroIso : divisorSheaf K 0 ≅ X.moduleKSheaf K
```

Sectionwise: `Γ(U, 𝒪_X) ≅ {g ∈ K(X) | ∀ x ∈ U closed, ord_x g ≥ 0}`. Injectivity is the
landed `germ_injective_of_isIntegral`; surjectivity is **sections = ⋂ of stalks inside the
function field**: an everywhere-regular `g` is locally a section (stalk = colimit), the local
sections agree on overlaps (they agree in `K(X)` and sections inject), and glue. Blueprint
node with complete proof; algebra anchor for the affine model: Stacks
`algebra-lemma-normal-domain-intersection-localizations-height-1`
(`stacks-algebra.tex:44046`, read: `R = ⋂_{ht 𝔭 = 1} R_𝔭` for Noetherian normal domains).
This iso is what connects the entire ledger to the landed `Γ(C,𝒪) ≅ k` and
`Module.Finite k H¹` — χ of `𝒪(0)` *is* χ of `moduleKSheaf` by χ-iso-invariance (§5.1).

### 4.3 Skyscrapers and their cohomology (file R5)

Vehicle (OPEN-1 default): mathlib's `skyscraperSheaf x M : TopCat.Sheaf (ModuleCat K) X`
(`Topology/Sheaves/Skyscraper.lean:250`) — defeq to our category (§1). Deliverables:

```lean
theorem skyscraper_sections : (skyscraperSheaf x M).obj (op U) ≅ if x ∈ U then M else 0-object
noncomputable def skyscraperGammaEquiv : Sheaf.HModule (skyscraperSheaf x M) 0 ≃ₗ[K] M
  -- via the landed HModule.linearEquiv₀ (ModuleKSheaf.lean:151) + the ite-extraction
instance : Subsingleton (Sheaf.HModule (skyscraperSheaf x M) 1)   -- H¹(sky) = 0, THE new brick
```

Proof of the instance, whole-site and affine-free (§2.3 correction 1): embed `M ↪ I⁰`
injective in `ModuleCat K`; `skyscraperSheaf x I⁰` is an injective sheaf by
`Injective.injective_of_adjoint (stalkSkyscraperSheafAdjunction …)` — the left adjoint
`Sheaf.forget ⋙ stalkFunctor x` preserves monos (mathlib instance, `Stalks.lean:544`).
The cokernel of `sky M ↪ sky I⁰` is `sky (I⁰/M)` (sectionwise cokernels; sky presheaves are
already sheaves). `Hom(k_X, sky I⁰) → Hom(k_X, sky (I⁰/M))` is `I⁰ → I⁰/M` (both compute
sections at `⊤ ∋ x` via the landed `constModuleSheafHomEquiv`), surjective. Apply the landed
`Abelian.Ext.subsingleton_one_of_injective_of_surjective` with `L := k_X`
(via `freeModuleSheafIsoConstModuleSheaf`, `OverOpen.lean:324`). Semantic anchors:
Stacks Sheaves §skyscraper (`stacks-sheaves.tex:3270`, `lemma-skyscraper-stalks`, read);
mathlib adjunction verified in checkout.

### 4.4 The dévissage SES (file R6)

For a divisor `D` and closed `x`, with `M(D,x) := (jump module) = m_x^{−D_x−1}·/m_x^{−D_x}·`
inside `K(X)` (a 1-dimensional `κ(x)`-space, hence `finrank_K = residueDeg K x` — the DVR
filtration lemma, cff §12 Observation (C1)–(C3), read; Lean route: uniformizer multiplication,
or adapt mathlib `quotientRangePowQuotSuccInclusionEquiv`,
`NumberTheory/RamificationInertia/Basic.lean:318ff`):

```lean
/-- 0 ⟶ 𝒪(D) ⟶ 𝒪(D + x) ⟶ sky_x M(D,x) ⟶ 0, as a ShortComplex.ShortExact. -/
noncomputable def devissageSES (D) (x) :
    ShortComplex (Sheaf (Opens.grothendieckTopology X) (ModuleCat K))
theorem devissageSES_shortExact : (devissageSES D x).ShortExact
```

Certificates, each with its verified mathlib vehicle:
- **mono**: sectionwise injective (inclusion) ⇒ mono (kernels sectionwise; `Sheaf.forget`
  faithful reflects monos).
- **exactness at middle**: the second map is "leading-coefficient at `x`" (over `U ∋ x`:
  `g ↦ [g] ∈ M(D,x)`; over `U ∌ x`: to the zero object); its sectionwise kernel is exactly
  `𝒪(D)(U)`; conclude by `ShortComplex.exact_of_f_is_kernel`
  (`Algebra/Homology/ShortComplex/Exact.lean:426`) — kernel forks are computed in presheaves.
- **epi**: `Presheaf.IsLocallySurjective` + `Sheaf.epi_of_isLocallySurjective`
  (`CategoryTheory/Sites/LocallySurjective.lean`, instance verified). Local surjectivity at
  `x`: given `U ∋ x` and a class `c ∈ M(D,x)`, pick `g ∈ K(X)` realizing `c` (the stalk is a
  DVR with fraction field `K(X)`); its finitely many order-violations on `U` other than `x`
  are closed points; shrink `U` to exclude them (they are ≠ `x`); `g` lifts `c` there. At
  points ≠ `x` the target is locally zero. The lifting sieve covers `U`.

This is the Lean form of Stacks `lemma-degree-effective-Cartier-divisor`'s SES
`0 → 𝒪_X → 𝒪_X(D) → i_*i^*𝒪_X(D) → 0` (read), specialized to one point at a time — the
one-point granularity is what keeps every certificate a *local* DVR statement.

---

## 5. h⁰, h¹, χ (task pin 4)

### 5.1 Definitions (file R7)

```lean
noncomputable def h0 (F) : ℕ := Module.finrank K (Sheaf.HModule F 0)
noncomputable def h1 (F) : ℕ := Module.finrank K (Sheaf.HModule F 1)
noncomputable def chi (F) : ℤ := (h0 F : ℤ) - (h1 F : ℤ)
theorem chi_congr (e : F ≅ G) : chi F = chi G   -- HModule.map along e (landed map_id/map_comp)
```

Definitions are unconditional (`finrank` junk = 0 when infinite); every *theorem* carries the
`Module.Finite` facts, which the dévissage itself supplies (§5.2). `h⁰/h¹` of `𝒪` connect to
the landed stack: `h0 (moduleKSheaf) = 1` via `HModule.linearEquiv₀` + the landed
`isIso_hom_appTop_of_geometricallyReduced` (`Curve/Sections.lean:160`; the `k → Γ` iso is
`K`-linear for the `overModule` structure — one compatibility lemma);
`h1 (moduleKSheaf) = genus C` **definitionally** at `K = k` under the §1 keying.

### 5.2 Finiteness dévissage

From the SES's five-term exact sequence (LES via `covariant_sequence_exact₁/₂/₃`, fixed first
argument `k_X`, plus `H¹(sky) = 0`):

`0 → H⁰(𝒪(D)) → H⁰(𝒪(D+x)) → H⁰(sky) → H¹(𝒪(D)) → H¹(𝒪(D+x)) → 0`

- upward step: `Module.Finite` of both `H^i(𝒪(D))` ⇒ of both `H^i(𝒪(D+x))` (extension by the
  finite `H⁰(sky) ≅ M(D,x)`; quotient for `H¹`);
- downward step: ⇒ of both `H^i(𝒪(D−x))` (submodule for `H⁰`; extension for `H¹`).

Base case `D = 0`: `divisorSheafZeroIso` + landed `Γ(C,𝒪) ≅ k` + landed
`moduleFinite_hModule_one` (`Cohomology/Finiteness.lean:387`). Induction over the Finsupp
(`Finsupp.induction` on positive and negative parts):

```lean
instance moduleFinite_hModule_divisorSheaf (D) (i ∈ {0,1}) :
    Module.Finite K (Sheaf.HModule (divisorSheaf K D) i)
```

### 5.3 χ additivity and the χ–deg identity ((E-iii) engine)

```lean
/-- finrank bookkeeping brick (pure linear algebra, PR-candidate):
alternating sum of finranks along an exact 5-term sequence of f.d. modules vanishes. -/
theorem finrank_alternating_sum_eq_zero_of_exact₅ … -- via rank-nullity chains
  -- (Submodule.finrank_quotient_add_finrank / LinearMap.finrank_range_add_finrank_ker;
  --  no such n-term lemma exists in v4.31 — grep-verified; spelling lane-owned, may be
  --  decomposed into image-factorization steps instead of one 5-term statement)

theorem chi_step : chi (divisorSheaf K (D + single x 1)) =
    chi (divisorSheaf K D) + residueDeg K x        -- LES + brick + h⁰(sky) = residueDeg
theorem chi_divisorSheaf (D : X.CurveDivisor) :    -- ★ the wave keystone
    chi (divisorSheaf K D) = chi (X.moduleKSheaf K) + CurveDivisor.deg K D
theorem chi_structureSheaf : chi (X.moduleKSheaf K) = 1 - (h1 (X.moduleKSheaf K) : ℤ)
  -- = 1 − genus C at K = k under the §1 keying: "χ(𝒪) = 1 − g" discharged
```

Semantic anchors (all read): Stacks `lemma-euler-characteristic-additive`
(`stacks-varieties.tex:6183`, LES + rank-nullity — our brick is its 5-term truncation, honest
because `H¹(sky) = 0` caps the sequence, so no `H²` of anything is ever mentioned);
`lemma-chi-tensor-finite` (3)–(4) (χ of dim-0-support sheaf = `dim H⁰`); cff Lemma 12.2 /
Prop 12.4(D1) (the classical `dim L(B)/L(A) ≤ deg(B−A)` bookkeeping that `chi_step` refines
to equality-with-h¹-correction).

### 5.4 Multiplication isomorphism and `deg (div f) = 0`

```lean
noncomputable def mulEquivDivisorSheaf (f : X.functionFieldˣ) (D) :
    divisorSheaf K D ≅ divisorSheaf K (D - divOf f)
  -- sectionwise g ↦ f·g; ord (f g) = ord f + ord g; K-linear; inverse is f⁻¹
theorem deg_divOf (f : X.functionFieldˣ) : CurveDivisor.deg K (divOf f) = 0
  -- χ(𝒪(div f)) = χ(𝒪(0)) by mulEquivDivisorSheaf + chi_congr + divisorSheafZeroIso;
  -- expand both sides with chi_divisorSheaf
```

Anchor for the iso: papaioannou §1.3 (read): "equivalent divisors have isomorphic
corresponding vector spaces (… `x ↦ xz`)" — our sheaf-level version. The classical statement
recovered: cff Thm 12.6 `deg((s)) = 0` (read) — but its proof route (`[L : K(s)]`, cff
Prop 11.5 / papaioannou Thm 1.11) is NOT used (§2.3 correction 2, §11 audit row).

### 5.5 The Riemann inequality (task pin 5; route: N2 needs `h⁰(𝒪(nP))` growth)

Narrowest consumer form, over the generic base `K` (Wave 4 instantiates at `k` and at `k'`):

```lean
theorem riemann_inequality (D : X.CurveDivisor) :
    CurveDivisor.deg K D + 1 - (h1 (X.moduleKSheaf K) : ℤ) ≤ (h0 (divisorSheaf K D) : ℤ)
  -- h⁰ ≥ h⁰ − h¹ = χ = deg + χ(𝒪) = deg + 1 − g. One line from §5.3.
theorem h0_nsmul_point_unbounded (x closed) :    -- the N2 growth form
    ∀ N, ∃ n, N ≤ h0 (divisorSheaf K (n • single x 1))
  -- deg (n•x) = n·residueDeg ≥ n → ∞; NO rational point needed (x any closed point,
  -- matching the challenge's pointless-curve constraint)
```

Anchor: papaioannou p.8 "Riemann's Inequality" `g ≥ deg D − dim D + 1` (read; note his `g` is
the sup-definition — the identity "sup-genus = h¹(𝒪)" is deliberately NOT needed: our
inequality is stated with our `g := h¹(𝒪)`, which is the form N2 consumes); cff Thm 12.10;
proof pattern = Stacks `lemma-ample-curve` first display (`stacks-varieties.tex`, read:
`dim H⁰(L^n) ≥ χ(L^n) = n deg L + χ(𝒪)`). *Wave-4 hooks, not pinned here*: `h⁰(𝒪(D)) ≤
deg D + 1` for `D ≥ 0` (cff 12.4(D1); one more dévissage induction if Wave 4 wants it),
uniform `h¹`-vanishing (route item 12, Wave-4-owned), `deg > 0 ⇒ ample` (Stacks
`lemma-ample-curve` pattern, Wave-4 N2 proper).

---

## 6. The pinned consumer interface (task pin 3): realizing (E-i)–(E-iv)

All in the junction file `RiemannRoch/Degree.lean` (R11) — the only file of this lane that
imports L2 carriers (`CechPic`, `LocalEquations.picClass`, meromorphic bridge). Everything in
§§3–5 is L2-independent and can land **now** against the already-landed stack.

### 6.1 (E-i) — normalization

```lean
theorem deg_toDivisor_eq_finrank_sectionsModule (d : X.LocalEquations) (hd : effective d) :
    CurveDivisor.deg K d.toDivisor = Module.finrank K d.sectionsModule
theorem classDeg_picClass (d) (hd) :          -- the class-level (E-i) shape of wave3 §6.1
    classDeg (d.picClass) = Module.finrank K d.sectionsModule
```

Engine: the **Dedekind colength formula** (file R1, pure algebra, PR-candidate):

```lean
theorem IsDedekindDomain.finrank_quotient_span_eq_sum_ord
    (B : Type u) [CommRing B] [IsDedekindDomain B] (K …) [Algebra K B] (f : B) (hf : f ≠ 0)
    (hres : ∀ q : HeightOneSpectrum B, Module.Finite K (B ⧸ q.asIdeal)) :
    Module.finrank K (B ⧸ Ideal.span {f}) = ∑ q ∈ (finite support), ordq(f) • finrank K (B ⧸ q)
```

Proof route: CRT `IsDedekindDomain.quotientEquivPiOfProdEq`
(`RingTheory/DedekindDomain/Ideal/Lemmas.lean:920`, verified) on the factorization of `(f)`,
then the `q`-adic filtration `q^{i}/q^{i+1} ≅ B/q` (adapt
`quotientRangePowQuotSuccInclusionEquiv`, `RamificationInertia/Basic.lean:318ff`, or direct
uniformizer multiplication after localizing — DVR case first, then CRT). The stalk-level
corollary `finrank_K (𝒪_x ⧸ (g)) = ord_x(g) · residueDeg K x` is the single-point case; the
sections-module identity is the finite product over the support.

### 6.2 (E-ii) — the degree homomorphism on classes

```lean
noncomputable def classDeg : (X : Scheme).CechPic → ℤ
  -- choose (Classical) a bridge presentation λ = picClass d₁ * (picClass d₂)⁻¹ (L2 file 5b,
  -- ∃-form per §3.3 ask 1); value := deg (toDivisor d₁) − deg (toDivisor d₂)
theorem classDeg_well_defined … -- from exists_unit_of_picClass_eq below + deg_divOf
theorem classDeg_mul (a b) : classDeg (a * b) = classDeg a + classDeg b
theorem classDeg_one : classDeg 1 = 0

/-- The extraction lemma: cocycle-level triviality yields a global rational function. -/
theorem exists_unit_of_picClass_eq (d₁ d₂ d₁' d₂' effective)
    (h : picClass d₁ * (picClass d₂)⁻¹ = picClass d₁' * (picClass d₂')⁻¹) :
    ∃ f : X.functionFieldˣ,
      d₁.toDivisor - d₂.toDivisor - (d₁'.toDivisor - d₂'.toDivisor) = divOf f
```

Extraction proof (pinned; the ONE lemma needing both vocabularies, hence R11 — OPEN-5):
equality in `CechPic` = cohomologous on a common refinement `𝒲`; push cocycle values and
equations into `K(X)ˣ` via generic germs (integrality); the coboundary `v` gives
`F_x := (e₁ₓ/e₂ₓ)·(e₁'ₓ/e₂'ₓ)⁻¹·v_x⁻¹` independent of `x` (its `x`/`y`-ratio is the cocycle
identity); `f := F` has `ord_z f = (D₁ − D₂ − D₁' + D₂')_z` at every closed `z` because `v_x`
is a *unit section* near `z` (ord 0). Well-definedness of `classDeg` = extraction +
`deg_divOf` + `deg_add`. Hom property: bridge presentations multiply (L2 `picClass`
multiplicativity) and `deg_add`.

### 6.3 (E-iii) — χ-connection

```lean
theorem chi_divisorClass (d : X.LocalEquations) (hd : effective d) :
    chi (divisorSheaf K d.toDivisor) = chi (X.moduleKSheaf K) + classDeg (d.picClass)
```

— `chi_divisorSheaf` (§5.3) + `classDeg_picClass` (§6.1). The route pin "`deg L := χ(L) − χ(𝒪)`"
holds as this theorem (with `classDeg` on the left of the rearrangement); wave3 §6.1 expressly
delegates the choice of primitive ("via χ … or via local colengths … is Wave-2 internal").

### 6.4 (E-iv) — invariance under field extension (files R9, R10, R11)

`p : X' ⟶ X` the projection of `X' := X ×_{Spec K} Spec K'` for a field extension `K → K'`.

- **R9 (`Curve/BaseChangeInstances.lean`)**: the instance transport making `X'/K'` a curve
  bundle again — all `IsStableUnderBaseChange` gifts of §1; plus `X'.Over (Spec (.of K'))`
  via the second projection (the wave3 §6.1 convention).
- **R10 (`RiemannRoch/DegreeBaseChange.lean`)**, divisor level:

```lean
theorem deg_toDivisor_pullback (d : X.LocalEquations) (hd : effective d) :
    CurveDivisor.deg K' (d.pullback p).toDivisor = CurveDivisor.deg K d.toDivisor
```

  Proof route (pinned): reduce to a single support point `x` by multiplicativity; isolate `x`
  in a small affine Dedekind chart `V` on which the equation `f` has *no other* zero — take
  `V := basicOpen g` inside a chart, `g` chosen by CRT/prime-avoidance vanishing at the other
  zeros but not at `x`; then both sides are colengths: LHS `= finrank_{K'} (B_g ⊗_K K' ⧸ (f⊗1))`
  — the fiber of `x` lies entirely in the base-changed chart (`g` is a unit along it) and
  `Γ(V') = B_g ⊗_K K'` is `SectionsBaseChange` (wave3 file 7, in flight; OPEN-4 fallback:
  direct affine pullback `Spec (B_g ⊗_K K')`) — RHS `= finrank_K (B_g ⧸ (f))` by R1; they
  agree because `(B_g ⧸ (f)) ⊗_K K' ≅ (B_g ⊗_K K') ⧸ (f ⊗ 1)` (right-exactness) and `⊗_K K'`
  preserves `finrank`. Regularity of `f ⊗ 1` (the pullback datum's regularity certificate):
  flatness of `K → K'`.
- **R10, χ level** (the `h¹` base-change, needed so `g` is base-field-stable and
  `χ(𝒪) = 1 − genus C` holds over every `K'`):

```lean
theorem h1_baseChange : h1 (X'.moduleKSheaf K') = h1 (X.moduleKSheaf K)
  -- two-cover carriers on both sides (landed TwoCover.h1CokEquiv, structure sheaf ONLY —
  -- the landed affine vanishing suffices; base-changed charts are affine); sections of the
  -- base-changed cover = sections ⊗ K' (SectionsBaseChange); cokernel commutes with the
  -- flat ⊗; finrank invariant under ⊗_K K'.
```

- **R11, class level** (the pinned (E-iv) shape; `CechPic.map` is L2's contravariant map):

```lean
theorem classDeg_baseChange (λ : X.CechPic) :
    classDeg (K := K') (Scheme.CechPic.map p.left λ) = classDeg (K := K) λ
  -- bridge presentation + L2 pullback-compatibility ((d.pullback p).picClass =
  -- CechPic.map p d.picClass, wave3 §2.6(a)) + deg_toDivisor_pullback
```

Semantic anchors (read): Stacks `lemma-degree-base-change` and
`lemma-euler-characteristic-extend-base-field` (`stacks-varieties.tex:6266,9570`) — both via
flat base change of cohomology; our divisor-level route is the colength shadow of the same
flatness, chosen because it needs only *affine* section base change (the landed-lane brick),
not an `H^i`-base-change engine (route rule 1).

### 6.5 Consumer traces (wave3 §6.2 checked against the deliverables)

| Consumer | Uses |
|---|---|
| `degAt` (wave3 §6.2) | `classDeg` over every `K` (§6.2 here), well-definedness across `K'/K` representations = `classDeg_baseChange` |
| `pic0Functor` subfunctor stability | `classDeg_mul`, `classDeg_baseChange` |
| `abelElement` degree-0 certificate | `classDeg_picClass` + graph/point certificates (§3.3 ask 2) + `deg_single` with `residueDeg = 1` at `K`-rational points |
| Wave-4 N2 | `riemann_inequality` / `h0_nsmul_point_unbounded` (§5.5), `chi_structureSheaf` |
| Wave-7 deg-multiplicativity under finite `g` | **not pinned here** (wave3 §4.6 flags it outside Wave 3/2); anchor recorded: Stacks `lemma-degree-pullback-map-proper-curves` (read) |

---

## 7. Files, lanes, keystones (task pin 6)

### 7.1 Files (≤ 500 lines each; namespace `AlgebraicGeometry`; blueprint nodes 1-to-1)

| # | File | Contents (≈ size) | Depends on |
|---|------|-------------------|-----------|
| R1 | `Algebra/DedekindColength.lean` | colength formula, DVR filtration jump, finrank-alternating-sum brick (~400, pure algebra, PR-candidate) | mathlib only |
| R2 | `RiemannRoch/ClosedPoint.lean` | closed-point predicate, DVR/Dedekind stalk instances, `stalkHeightOne`, `ord`/`ordUnits`, `residueDeg` finite (~400) | `Curve/StalksDVR`, `Curve/Basic` |
| R3 | `RiemannRoch/Divisor.lean` | `CurveDivisor`, `deg`, order, `divOf` + finite support, Noetherian bookkeeping (~350) | R2 |
| R4 | `RiemannRoch/DivisorSheaf.lean` | `divisorSheaf`, sheaf condition, `divisorSheafZeroIso` (sections = ⋂ stalks), monotone monos, `mulEquivDivisorSheaf` (~450) | R2, R3, `Cohomology/ModuleKSheaf` |
| R5 | `RiemannRoch/Skyscraper.lean` | skyscraper transport to `ModuleCat K`, `Γ`-equiv, injectivity of `sky I`, `Subsingleton (HModule (sky) 1)` (~350) | `Cohomology/{ModuleKSheaf,OverOpen,AffineVanishing}` |
| R6 | `RiemannRoch/DevissageSES.lean` | jump module `M(D,x)` + its finrank, `devissageSES` + `ShortExact` certificates (~400) | R4, R5, R1 (jump dim) |
| R7 | `RiemannRoch/Chi.lean` | `h0/h1/chi`, `chi_congr`, finiteness dévissage, `chi_step`, ★`chi_divisorSheaf`, `chi_structureSheaf`, `deg_divOf` (~450) | R6, `Cohomology/Finiteness`, `Curve/Sections` |
| R8 | `RiemannRoch/RiemannInequality.lean` | `riemann_inequality`, `h0_nsmul_point_unbounded` (~150) | R7 |
| R9 | `Curve/BaseChangeInstances.lean` | curve-bundle instances for `X ×_K K'` over `K'` (~250) | `Curve/Basic`, `Curve/GeometricallyReduced` |
| R10 | `RiemannRoch/DegreeBaseChange.lean` | `deg_toDivisor_pullback` (colength route), `h1_baseChange` (~450) | R1, R3, R9, `Cohomology/{SectionsBaseChange,TwoCover}` |
| R11 | `RiemannRoch/Degree.lean` | `toDivisor`, `sectionsModule`, `classDeg`, extraction lemma, (E-i)–(E-iv) statements, consumer corollaries (~450) | R7, R10, L2 files 4 + 5b (signatures) |

### 7.2 Lanes and keystones

Immediately parallel, landed-stack-only: **A** = R1; **B** = R2 → R3 → R4; **C** = R5;
**D** = R9. Then **E** = R6 (after B, C, A-jump), **F** = R7 → R8 (after E; ★ wave keystone),
**G** = R10 (after A, D + `SectionsBaseChange` lands), **H** = R11 (after F, G + L2 files 4/5b
signature freeze — L2's lanes L2/5b are concurrently in flight per wave3 §7.2).

| Lane | Keystone | Verification bar |
|------|----------|------------------|
| A | colength formula | kernel build + axiom audit; smoke test: `B = K[t]`, `f = t^n` gives `n` |
| B | `divisorSheafZeroIso` + `mulEquivDivisorSheaf` | kernel build; `Γ(𝒪(0)) ≅ K` reproduces landed `Γ(C,𝒪) ≅ k` at `K = k` (consistency gate) |
| C | `Subsingleton (HModule (sky) 1)` | kernel build + axiom audit |
| E | `devissageSES_shortExact` | kernel build |
| F | ★ `chi_divisorSheaf` + `deg_divOf` + `riemann_inequality` | kernel build + axiom audit; `chi_structureSheaf` at `K = k` yields `χ = 1 − genus C` against the frozen `genus` spelling |
| G | `deg_toDivisor_pullback` | kernel build; smoke test `K' = K` |
| H | (E-i)–(E-iv) statements elaborate against L2 signatures | signature-freeze dry-run first (statements-only file), then proofs |

Recon lesson 8 binding: kernel-verify every claimed closure; a file is not "done" on LSP green.

---

## 8. What this lane does NOT do (scope fence)

No Serre duality, no Weil differentials, no canonical divisor (route: deferred until a consumer
forces them; `vater-weil-differentials` stays unread/uncited). No uniform `h¹`-vanishing, no
ampleness/projectivity (Wave 4, N2). No `deg` multiplicativity under finite morphisms of curves
(Wave-7 prerequisite, flagged in wave3 §4.6). No divisor subschemes as schemes, no finite-flat
morphism objects. No cocycle constructions (L2-owned) beyond *consuming* `picClass` in R11. No
`R^i f_*`, no monoidal sheaf categories, no adeles/repartitions, no Quot/Hilbert (route rule 5).
No genus-0 fork (route rule 8): every statement uniform in `g`.

---

## 9. Open sub-decisions

- **OPEN-1 (skyscraper vehicle).** Mathlib `skyscraperSheaf` + `stalkSkyscraperSheafAdjunction`
  (default) vs hand-rolled `ModuleCat`-skyscraper. Risk with default: `ite`/terminal-object
  (`⊤_C` vs `0`) plumbing in `ModuleCat`. *Close by*: R5's first ~1h probe — if the
  `Γ`-extraction and `sky(coker) = coker(sky)` lemmas exceed ~150 lines of `eqToHom`/dite
  surgery, hand-roll the functor (value `M` on `U ∋ x`, `0` else) and keep mathlib's adjunction
  proof as the template. Owner: lane C.
- **OPEN-2 (order vocabulary).** Stalk `HeightOneSpectrum.valuation` (default) vs fractional-
  ideal membership vs bespoke DVR-multiplicity. *Close by*: R2 probe of the three core lemmas
  (`ord` hom on units, `ord ≥ 0 ⟺ stalk membership`, jump-module dim); switch if the `ℤᵐ⁰`
  comparisons dominate proofs. Owner: lane B.
- **OPEN-3 (divisor index).** `Finsupp` on the closed-point subtype (default) vs on `X` with a
  support-away-from-generic invariant. *Close by*: R3, whichever makes `Finsupp.induction` +
  `deg_add` frictionless. Owner: lane B.
- **OPEN-4 (`SectionsBaseChange` dependency).** Wave-3 file 7 is being landed concurrently; R10
  consumes `Γ(V_A) ≅ Γ(V) ⊗[k] A` for affine `V`. *Close by*: adopt its landed signature; if it
  slips or its shape differs, R10 proves the single needed instance directly (preimage of an
  affine under the projection is `Spec (B ⊗_K K')` — `AlgebraicGeometry/Pullbacks.lean` toolkit).
  Owner: lane G.
- **OPEN-5 (extraction-lemma home).** Pinned to R11 (needs both vocabularies). If L2's 5b lands
  a picClass-equality ⇒ principal-difference lemma of its own, consume it and delete ours.
  *Close by*: L2 file 5b signature freeze. Owner: lane H + L2 coordination.

---

## 10. Route compliance and deviations

Compliant by construction: rule 1 (each lane funnels to one keystone; every statement is the
narrowest consumer form — e.g. no `H²`, no sheaf tensor, no scheme-theoretic divisors), rule 2
(§11 audit table; two counterexample-backed rejections recorded), rule 3 (no sorried data; the
only `Classical.choice` uses are value-independent, §1), rule 5 (scope fence §8), rule 6 (file
sizes §7.1; blueprint 1-to-1; `\source` only on read anchors per §12), rule 7 (verification
bars §7.2), rule 8 (no genus fork), rule 9 (known walls pre-assigned: `ite`/`eqToHom` at
skyscraper OPEN-1, instance opacity confined to R9, `overModule` local-instance discipline
carried over from the landed stack).

Deviations from pinned wordings, each flagged and justified:

1. **(E-i) realization**: "finrank of the finite flat `D → Spec K`" is delivered as
   `finrank K d.sectionsModule` (stalk-colength normal form, §3.4) — no divisor subscheme or
   finite-flat morphism object is constructed. Semantics identical by Stacks
   `lemma-degree-effective-Cartier-divisor` + `lemma-chi-tensor-finite` (2) (both read):
   `Γ(D, 𝒪_D) = ⊕_{x ∈ D} (𝒪_D)_x`. Narrower per route rule 1; no consumer touches the
   subscheme (checked §2.1, §6.5).
2. **`deg` order-first, not χ-first** (route item 7 wording "degree via `deg L := χ(L) − χ(𝒪)`"):
   the equation is delivered as theorem (E-iii)/§6.3; wave3 §6.1 explicitly leaves the primitive
   to this lane. Reason: order-first makes (E-ii) additivity and (E-iv) colengths definitional
   and keeps `deg(nP) = n·[κ(P):K]` a `rfl`-grade computation for N2.
3. **Wave3 §6.1 twisted-two-cover note declared MOOT** (already anticipated by
   chi-ledger-notes): no `Subsingleton (HModule' F_g Vᵢ 1)` instance is needed on this route;
   nobody should build the `F_g` equalizer carrier for this lane's sake.
4. **The notes' principal-divisor proof route replaced** (§2.3 correction 2): χ/multiplication
   argument instead of repartitions or the `π : C → ℙ¹` order-sum. The classical route is
   documented (§11) so the blueprint can cite both.

Nothing here contradicts (E-i)–(E-iv), wave3 §6.1's division of labour, or any route §3/§5 pin.

---

## 11. Semantic-audit table (route rule 2)

Every pinned statement against a READ anchor (§12). "SV" = `stacks-varieties.tex`,
"SA" = `stacks-algebra.tex`, "SD" = `stacks-divisors.tex`, "SSh" = `stacks-sheaves.tex`,
"P" = papaioannou, "CFF" = cff-curves-function-fields; mathlib anchors by path:line.

| Pin | Source anchor | Audit note |
|-----|---------------|------------|
| `deg D = Σ n_x[κ(x):K]` residue-weighted | CFF §12 (`deg_K` def, p.17) + (A2)/(A3); P Def 1.6/§1.3 | **Truth-critical over non-closed `K`**: unweighted sum is FALSE — `X = ℙ¹_ℝ`, `f = t²+1`: `div f = x_{t²+1} − 2·∞`, unweighted sum `1−2 = −1 ≠ 0`; weighted `1·2 − 2·1 = 0`. Counterexample goes in the blueprint. |
| `residueDeg` finite | mathlib `finite_of_finite_type_of_isJacobsonRing` (Jacobson/Ring.lean:675, Zariski's lemma, stacks 0CY7 tag on it); CFF Thm 4.8(3) | needs only chart finite-type over `K`; no separability/perfectness |
| `L(D)` carrier + sign | P Def 1.9; CFF §12 `L(A)` | `(f) + D ≥ 0` convention; `ℤᵐ⁰` direction pinned §4.1 (exp is order-*reversing* vs ord) |
| `Γ(U) = ⋂_{x∈U} 𝒪_x` in `K(X)` | SA `lemma-normal-domain-intersection-localizations-height-1` (:44046) for the affine model; sheaf glue standard | full proof in blueprint (10 lines); needed only on integral schemes with our stalks |
| χ additivity via LES + rank-nullity | SV `lemma-euler-characteristic-additive` (:6183) | our 5-term truncation is honest **because `H¹(sky) = 0`** ends the sequence — no `H²` claim of any kind is made (the landed stack has no `H²` vanishing and we never need one) |
| `H⁰(sky) = M`, `H^{>0}(sky) = 0`, `χ(sky) = dim M` | SV `lemma-chi-tensor-finite` (:6208); SSh §skyscraper (:3270); mathlib `stalkSkyscraperSheafAdjunction` (Skyscraper.lean:400), `Injective.injective_of_adjoint` (Injective/Basic.lean:195; `[PreservesMonomorphisms L]` section variable discharged by Stalks.lean:544) | whole-site; no affine hypothesis; new brick, proof pinned §4.3 |
| dévissage SES `0 → 𝒪(D) → 𝒪(D+x) → sky → 0` | SV `lemma-degree-effective-Cartier-divisor` SES (:9832); SD `definition-invertible-sheaf-effective-Cartier-divisor` (:2660) | one point at a time; epi is *local* surjectivity only — global `Γ(𝒪(D+x)) → M` surjectivity is FALSE in general (e.g. `g ≥ 1`, `D = 0`, `x` rational: `Γ(𝒪(x)) = K` when no degree-1 function exists), which is exactly why the sheaf-epi certificate must be the locally-surjective one |
| jump dim `= residueDeg` | CFF §12 Obs (C1)–(C3); mathlib `RamificationInertia/Basic.lean:318ff` | DVR filtration; works for any residue extension (inseparable OK) |
| `χ(𝒪(D)) = χ(𝒪) + deg D` for ALL `D` | SV `definition-degree-invertible-sheaf` (:9539) read together with `lemma-degree-effective-Cartier-divisor` | stated for arbitrary (non-effective) `D`; both dévissage directions needed and provided (§5.2) |
| `χ(𝒪) = 1 − g` | landed `Γ(C,𝒪) ≅ k` (Curve/Sections.lean:94, kernel-checked) + `genus` spelling (Challenge.lean:89) | `h⁰ = 1` uses the `K`-linearity compat lemma (§5.1); keying `letI := .ofHom C.hom` pinned |
| `deg (div f) = 0` | CFF Thm 12.6 (classical statement); P §1.3 iso `x ↦ xz` (the mult map) | **proof route ≠ classical**: χ/mult-iso (§5.4). Classical route (CFF 12.6 via Prop 11.5 `[L:K(s)] ≥ Σ ν_P(s) deg P`; P Thm 1.11) REJECTED: needs the `K(x)`-lattice/module machinery (mathlib's `Ideal.sum_ramification_inertia`, RamificationInertia/Basic.lean:596, is close but keyed to `R ⊂ integral closure` setups — a second engine for one lemma) |
| extraction (class-equality ⇒ principal difference) | K §2.11 `rk:coh` semantics (via wave3 §2, read there); cocycle argument §6.2 | uses only: integrality (generic germs), unit sections have ord 0; no approximation theorem |
| (E-ii) hom | CFF (A3)/(A4) | on classes via bridge; choice-independence proof obligatory (§1 discipline) |
| (E-iv) | SV `lemma-degree-base-change` (:9570), `lemma-euler-characteristic-extend-base-field` (:6266) | our route is divisor/colength + flat `⊗` (§6.4) — avoids an `H^i` base-change engine; `h1_baseChange` covers the genus constancy consumers separately |
| Riemann inequality | P p.8 (Riemann's Inequality; his sup-genus ≥ our identity's content), CFF Thm 12.10; SV `lemma-ample-curve` display | stated with `g := h¹(𝒪)` — no sup-genus comparison needed or claimed |
| pointless-curve growth (`nP`, `P` any closed point) | SV `lemma-ample-curve` proof (works with `deg > 0`, no rational point) | matches the challenge's no-rational-point constraint; `residueDeg ≥ 1` suffices |
| REJECTED: 2-cover-only χ | wave3 §6.1/§7.3 (Dedekind-chart counterexample, recorded there) | inherited rejection; this design removes even the *presented-twist* variant (§2.2(a)) |
| REJECTED: Hilbert-polynomial degree | old-draft-picard-recon §3 (read) | circularity documented §2.2(e) |

---

## 12. Reading log (basis for every citation above; rule: never cite unread text)

**Project documents, read in full**: `informal/route-decision.md`; `informal/wave3-picard-design.md`;
`informal/chi-ledger-notes.md`; `informal/old-draft-picard-recon.md`.

**Landed Lean, read (docstrings + main statements; proofs where load-bearing)**:
`Cohomology/ModuleKSheaf.lean` (full header + declaration list), `Cohomology/OverOpen.lean`
(header, `HModule'` §268ff), `Cohomology/AffineVanishing.lean` (header + `subsingleton_one_of_
injective_of_surjective` proof), `Cohomology/TwoCover.lean` (full), `Cohomology/Finiteness.lean`
(header + main §280–399), `Cohomology/FinitenessP1.lean` (full), `Curve/Basic.lean` (full),
`Curve/Sections.lean` (full), `Curve/StalksDVR.lean` (full), `Curve/DedekindSections.lean` (full),
`Curve/MapToP1.lean` (full), `Curve/RationalToP1.lean` (§§26–256 excerpts incl. the Noetherian
derivation), `Challenge.lean` (§1–120). *Not read*: `Curve/P1.lean`, `P1Charts.lean`,
`P1Points.lean`, `GeometricallyReduced.lean`, `Algebra/TwoLattice.lean` bodies (headers only via
importers) — nothing above cites their internals.

**Mathlib v4.31 checkout, grep/read-verified (file:line as cited inline)**: Ext LES
(`Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean`), `Ext` enough-injectives use sites;
`Topology/Sheaves/Sheaf.lean` (`TopCat.Sheaf` def), `Skyscraper.lean` (defs, `skyscraperSheaf`,
both adjunctions), `Stalks.lean:544`; `CategoryTheory/Preadditive/Injective/Basic.lean:185–200`;
`CategoryTheory/Sites/LocallySurjective.lean:360–392`; `Algebra/Homology/ShortComplex/Exact.lean:426,436`;
`RingTheory/DedekindDomain/AdicValuation.lean` (`intValuation`/`valuation`),
`DedekindDomain/Basic.lean:171`, `DedekindDomain/Ideal/Lemmas.lean:908–920`;
`NumberTheory/RamificationInertia/Basic.lean` (§318ff, §596); `RingTheory/Jacobson/Ring.lean:670–686`;
`RingTheory/Length.lean` header (noted, not used); `AlgebraicGeometry/FunctionField.lean:110–172`;
`AlgebraicGeometry/ResidueField.lean:19–54`; `AlgebraicGeometry/Geometrically/{Irreducible,Integral}.lean`
stability instances; `Morphisms/Smooth.lean:117,167`; `AlgebraicGeometry/Scheme.lean:658–668`.

**References**:
- `stacks-varieties.tex`: §Euler characteristics (L6153–6319, complete) and §Degrees on curves
  (L9525–c.10100: `definition-degree-invertible-sheaf`, `lemma-degree-base-change`,
  `lemma-degree-additive`, `lemma-degree-birational-pullback`, `lemma-degree-on-proper-curve`,
  `lemma-degree-in-terms-of-components`, `lemma-degree-tensor-product`, `lemma-degree-and-det`,
  `lemma-degree-effective-Cartier-divisor`, `lemma-divisible`,
  `lemma-degree-pullback-map-proper-curves`, `lemma-check-invertible-sheaf-trivial`,
  `lemma-no-sections-dual-nef`, `lemma-ample-curve`, `lemma-ampleness-in-terms-of-degrees-components`
  — statements + proofs).
- `stacks-algebra.tex`: `lemma-normal-domain-intersection-localizations-height-1` (L44046,
  statement).
- `stacks-divisors.tex`: `definition-invertible-sheaf-effective-Cartier-divisor` (L2660, located),
  `lemma-characterize-OD` (L2851, statement), `remark-affine-punctured-spectrum-standard-proof`
  (L3411–3432).
- `stacks-sheaves.tex`: §skyscraper-sheaves (L3270–3330: definition + `lemma-skyscraper-stalks`).
- `papaioannou-algebraic-rr.pdf`: pp. 4–8 (§1.1 valuations/places/degree of a place, Thm 1.4/1.6,
  Cor 1.7/1.8; §1.2 Weak Approximation Thm 1.9, Thm 1.11, Cor 1.12; §1.3 divisors, Defs 1.6–1.10,
  `L(D)`, genus-as-sup, Riemann's Inequality discussion).
- `cff-curves-function-fields.pdf`: pp. 6, 17–19 (§4 Prop 4.2–Thm 4.8; §11 Prop 11.5, Cor 11.6;
  §12 complete on those pages: divisor group, `deg_K`, (A1)–(A5), (B1)–(B3), (C1)–(C3),
  Lemmas 12.2–12.5, Thm 12.6, Cor 12.7, Lemma 12.9, Thm 12.10 Riemann, (D1)–(D9), (E1)–(E3)).
- `hartshorne-algebraic-geometry/tex/`: **only pp. 242–243 are transcribed, and they are III.5
  (cohomology of ℙ^r), not ch. IV** — read both pages; consequently NO Hartshorne ch. IV citation
  appears in this design (the task's "check which pages are transcribed" resolved: ch. IV degree
  theory would need new transcription; not required, Stacks anchors cover everything).
- Kleiman: not re-read this session; the two Kleiman-dependent rows in §11 cite wave3's reading
  log (§11 there) explicitly rather than fresh anchors.
- **Not read, therefore not cited**: `vater-weil-differentials.pdf` and
  `scheidler-function-fields.pdf` bodies (manifest entries only — both are Weil-differential /
  survey material for the deferred Serre-duality lane), Hartshorne beyond the two transcribed
  pages, `Algebra/TwoLattice.lean` internals, stacks chapters other than the four listed.
