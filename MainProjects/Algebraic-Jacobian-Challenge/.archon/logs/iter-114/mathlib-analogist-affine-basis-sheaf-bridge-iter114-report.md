# Mathlib Analogist Report

## Slug
affine-basis-sheaf-bridge-iter114

## Iteration
114

## Question

For an underlying type-valued presheaf `F : Opens X^op ⥤ Type u` on a scheme `X`, does Mathlib b80f227
expose an off-the-shelf API that converts "`F` satisfies a sheaf condition on the affine opens of
`X` (or on a base of basic opens of each affine chart)" into "`F` is a sheaf in the Zariski topology
on `X`"? Or — broader — is `Scheme.PresheafOfModules`-as-sheaf even the right *predicate* for the
project's iter-113 unique-gluing route, or should the project shift to a different infrastructure
(`SheafOfModules.{u}` / `Sheaf (Opens X)` / `Scheme.OpenCover`-indexed gluing) for the
sheaf-condition closure of `Ω_{X/S}`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Off-the-shelf "sheaf-on-basis ⇒ sheaf" theorem | NEEDS_MATHLIB_GAP_FILL | informational |
| 2: `IsSheafUniqueGluing` as the iter-113 framework reformulation | PROCEED | informational |
| 3: `relativeDifferentialsPresheaf` + IsSheaf-proof vs. `PresheafOfModules.sheafification` | DIVERGE_INTENTIONALLY | major |
| 4: tilde + affine-cover gluing as Route (d) | NEEDS_MATHLIB_GAP_FILL | informational |
| 5: recipe at Differentials.lean:148–167 (Step (1) "project Ω-families via d") | ALIGN_WITH_MATHLIB | must-fix |

## Sub-question answers

### Sub-question 1 — Off-the-shelf affine-basis-to-X bridge for `Scheme.PresheafOfModules`

**Not found.** Exhaustive search via `lean_local_search` and direct grep:

- `Scheme.PresheafOfModules.IsSheaf.{ofAffineCover, ofAffineBasis, ofOpenCover}` — **does not exist**.
- `Scheme.AffineOpenCover.isSheaf` — **does not exist**.
- `TopCat.SheafOnBasis` — **does not exist** (the named module does not exist; no namespace under it).
- `TopCat.Presheaf.isSheaf_of_isSheaf_on_basis` — **does not exist**.

The closest analogues, all *adjacent but not equivalent* to the desired bridge:

- `TopCat.Sheaf.restrictHomEquivHom` (`Mathlib/Topology/Sheaves/SheafCondition/Sites.lean:231`):
  bijection between presheaf-morphisms `F → F'.1` and basis-restricted morphisms, when the
  *codomain* `F'` is already a sheaf. Not a sheaf-condition predicate-level conversion.
- `TopCat.Opens.coverDense_inducedFunctor` (line 135 of same file): a basis-indexed functor into
  `Opens X` is cover-dense in `Opens.grothendieckTopology X`. Categorical input, but not by itself
  the desired bridge.
- `CategoryTheory.Functor.IsDenseSubsite.sheafEquiv`
  (`Mathlib/CategoryTheory/Sites/DenseSubsite/Basic.lean:784`): the equivalence
  `Sheaf J A ≌ Sheaf K A` between *sheaf categories* on dense subsites. Operates on a presheaf
  via *sheafification* — the corresponding sheaf on `X` may differ from the original presheaf on
  non-basis opens, so this is not a predicate-level conversion of the original presheaf.
- `CategoryTheory.Functor.IsOneHypercoverDense` and
  `Functor.isEquivalence_of_isOneHypercoverDense`
  (`Mathlib/CategoryTheory/Sites/DenseSubsite/OneHypercoverDense.lean`): a stronger
  hypercover-dense form of the comparison lemma. Same caveat — sheaf-category equivalence, not
  predicate-level conversion.

### Sub-question 2 — Sheaf-on-basis API at the type-level

**Not found** at the `Type*`-presheaf predicate level for general `Opens.IsBasis`:

- `TopCat.Presheaf.IsSheafOnOpens.toSheaf` — **does not exist**.
- `Presheaf.IsSheafOnBasis` — **does not exist**.
- `TopologicalSpace.Opens.IsBasis.isSheaf_iff` — **does not exist**.

What does exist (relevant but indirect):

- `TopCat.Presheaf.IsSheafUniqueGluing` and `isSheaf_iff_isSheafUniqueGluing_types`
  (`Mathlib/Topology/Sheaves/SheafCondition/UniqueGluing.lean`) — equivalent reformulation in terms
  of unique gluings of compatible families; quantified over ALL families `U : ι → Opens X`, not
  restricted to basis families.
- `TopCat.Presheaf.IsSheafOpensLeCover` and `isSheaf_iff_isSheafOpensLeCover`
  (`Mathlib/Topology/Sheaves/SheafCondition/OpensLeCover.lean`) — same situation: quantifies over
  all `U`, not just basis-indexed.
- The `subsheafToTypes (P : LocalPredicate T) : Sheaf (Type _) X`
  (`Mathlib/Topology/Sheaves/LocalPredicate.lean:282`) — produces a sheaf *automatically* whenever
  the presheaf is described as "dependent functions to a fiber, locally satisfying a predicate".
  This is the idiom Mathlib's `AlgebraicGeometry.tilde` uses via the `isLocallyFraction` predicate
  (`Mathlib/AlgebraicGeometry/StructureSheaf.lean:112`). The project's
  `relativeDifferentialsPresheaf` is **not currently** in this form, but in principle could be
  rebuilt as such (the locally-fraction predicate would assert "locally of the form `germ_x(b•dc)`
  in the Kähler-differential stalk").

**Comparison with the project's current usage**:
- The project uses `isSheaf_iff_isSheafUniqueGluing_types` (via `isSheaf_of_isSheafUniqueGluing_types`)
  to reduce the type-level IsSheaf to IsSheafUniqueGluing. This is sound but operates on the full
  `Opens X` lattice; it does not provide any basis-restriction shortcut.
- The four equivalent forms (`IsSheaf`, `IsSheafOpensLeCover`, `IsSheafPairwiseIntersections`,
  `IsSheafUniqueGluing`) are interchangeable as reformulations but **none** of them carries an
  basis-restriction lemma at the predicate level.

### Sub-question 3 — Is `Scheme.PresheafOfModules`-as-sheaf the right predicate?

**Yes for the present infrastructure; an alternative exists but does not bypass the gap.**

- The Mathlib idiom for "a quasicoherent sheaf of `O_X`-modules" is `X.Modules :=
  SheafOfModules.{u} X.ringCatSheaf` (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:37`). This is a
  *pair* (presheaf-of-modules, sheaf-condition-proof) — *the project's pattern matches this exactly*.
- Mathlib's affine analogue `AlgebraicGeometry.tilde`
  (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean:87`) defines `tilde M : (Spec R).Modules` as
  `⟨moduleStructurePresheaf R M, isSheaf-via-forget-and-subsheafToTypes⟩`, where the sheaf
  condition is proved by `(TopCat.Presheaf.isSheaf_iff_isSheaf_comp _ _).2 (structureSheafInType R M).2`
  — i.e., via the forget functor to types + a type-level sheaf coming from
  `subsheafToTypes (isLocallyFraction R M)`. This is structurally identical to the project's
  envisioned Step 1 (forget reduction) and confirms the predicate-level pattern.

**Alternative: `PresheafOfModules.sheafification`**
(`Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:54`) provides a functor
`PresheafOfModules.{v} R₀ ⥤ SheafOfModules.{v} R`. The project could define
`relativeDifferentials f := (PresheafOfModules.sheafification (𝟙 _)).obj (relativeDifferentialsPresheaf f)`
without proving `relativeDifferentialsPresheaf_isSheaf`. But:
- This does not bypass the mathematical content. The sheafification computes non-basis sections by
  taking a limit over the dense subsite; to relate the resulting sections back to
  `KaehlerDifferential` (which is what the project needs downstream for the universal derivation,
  cotangent exact sequence, smoothness characterization), the project would still need:
  - The affine-basis identification `Ω_{X/S}(D(g)) ≅ Ω_{B_α[1/g]/A_α}` for each affine chart
    (Step 2 of Route (a) — same Kähler-localisation lemma `KaehlerDifferential.isLocalizedModule_map`).
  - Proof that the sheafification unit `F → F^a` is iso on affine opens — which is *equivalent* to
    the sheaf-condition restricted to affine opens.
- The sheafification route also degrades by-`rfl` access to affine sections: currently
  `((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) = CommRingCat.KaehlerDifferential …`
  is proved by `rfl` (Differentials.lean:96). After sheafification this would be an iso, not
  `rfl`.

**Verdict for the predicate choice**: keep the current pattern. Switching to
`PresheafOfModules.sheafification` is a *valid framework relocation* of the obligation but is not
a strictly better path.

### Sub-question 4 — `AlgebraicGeometry.tilde` + cover-gluing as Route (d)

**Not a complete off-the-shelf route**:

- `AlgebraicGeometry.tilde : ModuleCat R ⥤ (Spec R).Modules`
  (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean:87`) produces a `(Spec R).Modules`
  (SheafOfModules) on a *single affine* `Spec R`. There is no `Tilde.fromAffineCover`,
  `Tilde.glue`, `AlgebraicGeometry.glueAffineSheaves`, or
  `SheafOfModules.ofAffineCover` declaration in Mathlib b80f227.
- `IsQuasicoherent.of_coversTop`
  (`Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean:377`) shows quasicoherence is
  local for a `SheafOfModules`, and `QuasicoherentData.bind` (line 360) glues quasicoherent
  *data*. Both operate on a SheafOfModules **that already exists**; they do not construct one
  from per-affine pieces.
- `Scheme.GlueData.oneHypercover`
  (`Mathlib/AlgebraicGeometry/GluingOneHypercover.lean:43`) and
  `CategoryTheory.Functor.IsOneHypercoverDense`
  (`Mathlib/CategoryTheory/Sites/DenseSubsite/OneHypercoverDense.lean`) provide the categorical
  equivalence `Sheaf K A ≌ Sheaf J A` for a 1-hypercover-dense subsite. In principle, an affine
  cover of `X` defines a 1-hypercover and the affine subsite is 1-hypercover-dense; so the
  category of `Sheaf (affine subsite) X.Modules` is equivalent to `Sheaf (full topology) X.Modules`.
  But constructing the affine-side object (a presheaf-on-affines satisfying the affine-restricted
  sheaf condition) still requires the *same* affine-restriction descent the project is trying to
  produce.

The signature `AlgebraicGeometry.tilde` confirmed:
```
def tilde : (Spec R).Modules where
  val := moduleStructurePresheaf R M
  isSheaf := (TopCat.Presheaf.isSheaf_iff_isSheaf_comp (forget AddCommGrpCat) _).2
    (structureSheafInType R M).2
```
This is a *single-affine* construction; no Mathlib lemma combines tildes on an open cover.

## Must-fix-this-iter

1. **Recipe error at Differentials.lean:148–167** (docstring for
   `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`). Step (1) of the docstring says:
   > Compatibility ⇒ gluing on the structure-sheaf side. A compatible family
   > `sf i ∈ Ω_{X/S}(U i)` projects, via the universal derivation `d : O_X → Ω_{X/S}`, to a
   > compatible family `Section_i : O_X(U i)` (modulo identification). Use the sheaf property of
   > `X.ringCatSheaf` to glue uniquely.

   This is **not well-defined**: `d` is a multilinear map of modules, not invertible; you cannot
   recover `sf i` from a "section in `O_X(U i)`" via `d`'s left inverse because `d` has no left
   inverse. The correct recipe uses *base-change compatibility of Kähler differentials*:
   `KaehlerDifferential.isLocalizedModule_map` [verified] identifies
   `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]`, and the descent then runs on the affine-basis pieces.

   **Action**: the iter-115 plan agent should rewrite this docstring with the corrected recipe
   (described in §Recommendation below). The Lean body itself remains `sorry` until the descent
   is actually constructed; the docstring is just informational and not load-bearing for
   compilation, but a misleading recipe sends future provers down a wrong path.

## Major

- **Decision 3** (presheaf-with-IsSheaf-proof vs. `PresheafOfModules.sheafification`): DIVERGE_INTENTIONALLY
  is recorded in `analogies/affine-basis-sheaf-bridge.md`. The current pattern matches Mathlib's
  `tilde` idiom exactly; the sheafification alternative is valid but does not bypass the
  Mathlib-gap obligation. No code refactor recommended.

## Informational

- **Decision 1** (basis-to-X bridge): NEEDS_MATHLIB_GAP_FILL. The blueprint `[gap]` callout at
  Differentials.tex:51 stands and is independently verified by this audit. No Mathlib b80f227
  declaration closes this gap.
- **Decision 2** (`IsSheafUniqueGluing` framework reformulation): PROCEED. The iter-113 pivot to
  unique-gluing is internally consistent and connects via `isSheaf_of_isSheafUniqueGluing_types`
  [verified] + `IsSheaf.isSheafOpensLeCover` [verified] to the project's helpers.
- **Decision 4** (tilde + cover gluing as Route (d)): NEEDS_MATHLIB_GAP_FILL. The route is not
  off-the-shelf — affine-cover gluing for `Scheme.Modules` is not present in Mathlib b80f227.

## Recommendation (concrete for the planner)

**Top-level verdict: PROCEED with iter-115+ closure on the existing route**, with two corrections:

### Correction 1: rewrite the recipe at Differentials.lean:148–167

Replace the current Step (1)/Step (2)/Step (3) recipe with the **affine-basis-descent** recipe:

> **Concrete iter-115+ recipe** (using only verified Mathlib b80f227 lemmas):
>
> 1. **Affine basis identification.** Let `B = Set.range (X.affineOpens)` (via
>    `Scheme.isBasis_affineOpens` [verified, `Mathlib/AlgebraicGeometry/AffineScheme.lean:297`]).
>    For each affine `V_α = Spec B_α ⊂ X` and a basic open `D(g) ⊂ V_α`, identify
>    `relativeDifferentialsPresheaf f` on `D(g)` with `Ω_{B_α[1/g]/A_α}`, then with
>    `Ω_{B_α/A_α} ⊗_{B_α} B_α[1/g]` via `KaehlerDifferential.isLocalizedModule_map`
>    [verified, `Mathlib/RingTheory/Etale/Kaehler.lean:63`]. This identifies the
>    affine-basis-restricted presheaf with `tilde Ω_{B_α/A_α}` restricted to `V_α`, hence a
>    sheaf-on-`V_α` by `AlgebraicGeometry.tilde` [verified,
>    `Mathlib/AlgebraicGeometry/Modules/Tilde.lean:87`].
>
> 2. **Cofinality descent to all opens.** Given an arbitrary open cover `U : ι → Opens X` of
>    `iSup U`, refine to the intersection-with-affine-basis cover `U' : ι' → Opens X` where each
>    `U' j ⊆ U (f j)` for some `f : ι' → ι` and `U' j ⊆ V_{α(j)}` is a basic open of an affine
>    chart. The refinement is cofinal in `OpensLeCover (iSup U)` (a routine `Sigma`-of-`affineOpens`
>    construction). Lift the equalizer-products / `OpensLeCover` cone condition for `U'` from the
>    affine-restricted sheaf property of Step 1, then transfer back to `U` via cofinality of the
>    refinement in the `OpensLeCover` category — this is the standard "sheaf condition is local on
>    the basis" cofinality argument. The structural target is
>    `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` [verified,
>    `Mathlib/Topology/Sheaves/SheafCondition/OpensLeCover.lean`].
>
> 3. **Forgetful reduction Ab ⥤ Type.** Apply `Presheaf.isSheaf_iff_isSheaf_comp` [verified,
>    `Mathlib/Topology/Sheaves/Forget.lean`] with `forget AddCommGrpCat` to descend from the
>    type-level sheaf condition to the module-level sheaf condition (already enacted in the
>    main theorem `relativeDifferentialsPresheaf_isSheaf` at L282).

The mathematical descent in Step 2 is the load-bearing content; this is where the Mathlib gap is
real and the project must hand-construct the cofinality argument. No further Mathlib lemma
provides this step automatically.

### Correction 2: blueprint annotation

The blueprint at Differentials.tex:51 already correctly states the gap. **No edit required**, but
the iter-115 plan agent should ensure the prose matches the recipe in Correction 1 (e.g., remove
any lingering reference to "project Ω-families via d" if such a phrase appears).

### Reframing of the iter-113 pivot

The iter-113 pivot to `IsSheafUniqueGluing` is **framework-equivalent** to `IsSheafOpensLeCover` via
the standard four-form-equivalence chain. The pivot was a reformulation, not a mathematical
advance, and progress-critic-iter114's STUCK verdict is correct. The corrected recipe in
Correction 1 lives mathematically in the `OpensLeCover` form — but the project can keep the
`IsSheafUniqueGluing` framework if it prefers; just note that the load-bearing descent step is the
same in either form, and there is no Mathlib lemma that does Step 2 for you.

## Persistent file

- `analogies/affine-basis-sheaf-bridge.md` — design-rationale captured for future iters.

Overall verdict: **PROCEED with iter-115+ closure** on the current route after rewriting the
docstring recipe; the basis-to-X bridge remains a real Mathlib gap with no off-the-shelf
substitute (NEEDS_MATHLIB_GAP_FILL), and the project's hand-rolled cofinality descent in Route (a)
Step 2 is unavoidable.
