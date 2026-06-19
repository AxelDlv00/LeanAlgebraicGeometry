# Analogy: foundational cohomology/bundle layer — how to shape it in Lean

## Mode
api-alignment

## Slug
found-design

## Iteration
004

## Question
How should the project model its FOUNDATIONAL algebraic-geometry infrastructure
(cohomology/bundle layer) so that (a) the ~40 theorem statements can be written as
FAITHFUL Lean signatures, and (b) the proofs compose — given Mathlib lacks most of this?
For sheaf cohomology H^i / R^i f_*, Koszul K_{p,q}, and vector bundles + Sym^i/∧^i + SES:
does Mathlib have a usable idiom, or NEEDS_MATHLIB_GAP_FILL, and what SHAPE should the
stand-in take?

## Project artifact(s)
- `MR4213770UniversalSecantBundlesAndSyzygiesOfCanonicalCurves/Basic.lean:35-92` — 7
  `opaque ... := Unit/True` stubs (4 peer anchors + 3 even-genus defs).
- `blueprint/.../Kemeny_UniversalSecantBundles.tex:104-150` — def blocks (kernel bundle
  reduction, universal zero locus, universal secant bundles).
- `blueprint/.../Kemeny_PeerDependencies.tex` — 4 peer-interface anchors.

## Headline finding

Mathlib ALREADY supplies the load-bearing scaffolding the project is treating as un-wired
"peer dependencies" stubbed `opaque := Unit`. The `opaque := Unit/True` peer-anchor
strategy is the classic "couldn't build the prerequisite, so we made a stand-in"
anti-pattern, and for most of these items it is unnecessary AND mis-shaped (a `Type :=
Unit` can never be a drop-in for a functor `X.Modules ⥤ Y.Modules`, so downstream
statements type against `Unit`, i.e. vacuously). The right move is to build THIN CONCRETE
defs over Mathlib's existing abelian-category-of-O_X-modules API, not parallel opaques and
not fresh typeclasses.

Confirmed Mathlib substrate (all cited, verified via LSP):
- `AlgebraicGeometry.Scheme.Modules : Scheme → Type (u+1)` — category of O_X-modules.
  (`Mathlib.AlgebraicGeometry.Modules.Sheaf`)
- `AlgebraicGeometry.Scheme.Modules.instAbelian` — **X.Modules is ABELIAN**. So kernels,
  cokernels, SES are native.
- `AlgebraicGeometry.Scheme.Modules.pushforward (f : X ⟶ Y) : X.Modules ⥤ Y.Modules` +
  `…instAdditivePushforward` — **f_* exists and is ADDITIVE**.
- `CategoryTheory.Functor.rightDerived (F) [F.Additive] (n) : C ⥤ D`
  (`Mathlib.CategoryTheory.Abelian.RightDerived`) — abstract R^i, needs
  `[HasInjectiveResolutions C]`.
- `ModuleCat.exteriorPower.functor (R) (n) : ModuleCat R ⥤ ModuleCat R`
  (`Mathlib.Algebra.Category.ModuleCat.ExteriorPower`) — ∧^n at ModuleCat level (NOT sheaf).
- `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` (`Mathlib.Topology.Sheaves.Stalks`) —
  the stalk-locality criterion, already a theorem for concrete-category-valued sheaves.
- `CategoryTheory.Sheaf.instIsGrothendieckAbelian` + `IsGrothendieckAbelian.enoughInjectives`
  — general route to enough injectives for sheaf categories.
- `SheafOfModules.isQuasicoherent : ObjectProperty (SheafOfModules R)` — the IDIOM for
  "structural property of a sheaf of modules" = a predicate/`ObjectProperty`, not a struct.

Confirmed GAPS (verified absent via loogle, empty results):
- `EnoughInjectives (X.Modules)` / `IsGrothendieckAbelian (X.Modules)` /
  `HasInjectiveResolutions (X.Modules)` — NOT wired for the `Scheme.Modules` abbreviation
  (general sheaf theorems exist; the concrete instance bridge does not). This is the ONE
  instance gating `(pushforward f).rightDerived n`.
- No exterior/symmetric-power FUNCTOR on `X.Modules` (only `ModuleCat` level for ∧; Sym has
  no categorical functor even at ModuleCat — only `SymmetricAlgebra`/`TensorPower.Symmetric`
  at element level).
- No locally-free / vector-bundle predicate on `X.Modules`. (`VectorBundleCore`/`VectorBundle`
  in Mathlib are the differential-geometry topological notion — wrong category, DO NOT reuse.)
- No additive global-sections functor `X.Modules ⥤ AddCommGrp/ModuleCat`
  (`SheafOfModules.sectionsFunctor` lands in `Type`, not additive) → H^i needs a thin Γ_Ab.
- No Koszul cohomology K_{p,q} anywhere.
- No flat base change for (higher) direct images.

## Decisions identified

### Decision: higher direct image R^i f_* (`AlgebraicGeometry.higherDirectImage`)
- **Mathlib idiom**: `(Scheme.Modules.pushforward f).rightDerived n : X.Modules ⥤ Y.Modules`.
  All pieces present (`instAdditivePushforward`, `Functor.rightDerived`) EXCEPT
  `[HasInjectiveResolutions X.Modules]`.
- **Project's current path**: `opaque higherDirectImage : Type := Unit` — not indexed by
  f, F, i; carries no content.
- **Gap**: divergent-and-wrong. Downstream `R^i q_*` statements type against `Unit`.
- **Cost of divergence**: every Leray / Grauert / pushforward lemma (`W_locally_free`,
  `R1q_line_bundle`, `psi_global_sections`, `even_secant_vanishing`) is vacuous; when the
  real object lands the `: Type := Unit` signature won't match a functor, so all consumers
  break at once (no incremental migration).
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — but the gap is ONLY the
  `HasInjectiveResolutions (X.Modules)` instance (derive from Grothendieck-abelian general
  theorems). Then define `higherDirectImage f n := (Scheme.Modules.pushforward f).rightDerived n`.
  Replace the opaque now with at least the correct functor type.

### Decision: scheme cohomology H^i(X,F) (`AlgebraicGeometry.Scheme.HModule`)
- **Mathlib idiom**: either `CategoryTheory.Sheaf.H` (Ext-based, AddCommGrp sheaves on a
  site) or `((Γ_Ab).rightDerived i).obj F` with `Γ_Ab : X.Modules ⥤ AddCommGrp`.
- **Project's current path**: `opaque Scheme.HModule : Type := Unit`.
- **Gap**: divergent-and-wrong (same vacuity as above).
- **Cost**: every `H^i(X, ∧^j M_L)`, `Sym^k H^0(E)` statement is vacuous; the headline
  `K_{k,1}=0 ⇐ H^1(∧^{k+1}M_L)=0` cannot be stated faithfully.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — thin. Build `Γ_Ab` (compose `sectionsFunctor` with
  its module structure, or pushforward to `Spec ℤ` + Γ), then `Hⁱ F := (Γ_Ab.rightDerived i).obj F`
  returning an `AddCommGrp`/`ModuleCat`. Shape = a `def` returning a module object, never `Unit`.

### Decision: affine pushforward + base change (`AlgebraicGeometry.pushforwardBaseChangeMap`)
- **Mathlib idiom**: i=0 pushforward IS `Scheme.Modules.pushforward`. The base-change
  COMPARISON morphism is a genuine Mathlib gap.
- **Project's current path**: `opaque … : Type := Unit`.
- **Gap**: divergent-and-wrong (a base-change map is a MORPHISM, not a type).
- **Verdict**: NEEDS_MATHLIB_GAP_FILL for the comparison map; type it as a real morphism
  in `Y.Modules` (`g^* f_* F ⟶ f'_* g'^* F`), not `Unit`.

### Decision: stalk-locality of module iso (`Modules.isIso_iff_isIso_stalkFunctor_map`)
- **Mathlib idiom**: `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` — already proves
  exactly this for concrete-category-valued sheaves; `X.Modules` forgets via
  `Scheme.Modules.toPresheaf : X.Modules ⥤ TopCat.Presheaf Ab`.
- **Project's current path**: `opaque … : Prop := True`.
- **Gap**: divergent-and-wrong — the Prop is literally `True`, so any later "use" is vacuous.
- **Verdict**: ALIGN_WITH_MATHLIB. Restate as a real `theorem`; proof reduces to the Mathlib
  lemma through `toPresheaf` + the stalk functor. This is essentially already in Mathlib.

### Decision: Koszul cohomology K_{p,q} + kernel-bundle reduction (`MR4213770.KernelBundleReduction`)
- **Mathlib idiom**: none — Koszul/syzygy cohomology absent.
- **Project's current path**: `opaque … : Prop := True`.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — define concretely once H^i and ∧^i exist: M_L =
  `kernel` (abelian X.Modules) of eval `H⁰(L)⊗O_X → L`; K_{k,1}=0 ⇔ statement about
  `H¹(∧^{k+1} M_L)`. Real def/Prop, not `True`.

### Decision: vector bundles + Sym^i / ∧^i + short exact sequences
- **∧^i**: `ModuleCat.exteriorPower.functor` exists at ModuleCat level; PORT the pattern to
  `X.Modules ⥤ X.Modules`. NEEDS_MATHLIB_GAP_FILL.
- **Sym^i**: no categorical functor even at ModuleCat (`SymmetricAlgebra`,
  `TensorPower.Symmetric` are element-level). NEEDS_MATHLIB_GAP_FILL (build at ModuleCat,
  then sheaf level).
- **vector bundle / locally free**: NEEDS_MATHLIB_GAP_FILL — model as a PREDICATE
  (`ObjectProperty (X.Modules)` or a `Prop`/`class IsLocallyFree`), mirroring
  `SheafOfModules.isQuasicoherent`. NOT a bundled structure; NOT `VectorBundleCore`
  (wrong, topological-DG category).
- **SES**: ALIGN_WITH_MATHLIB — `X.Modules` is abelian; use
  `CategoryTheory.ShortComplex` + `.ShortExact`. No new infrastructure.

## Recommendation

Stop stubbing the cohomology/bundle layer as `opaque := Unit/True`. Mathlib's
`AlgebraicGeometry.Scheme.Modules` (abelian) + additive `pushforward` + `Functor.rightDerived`
+ `ModuleCat.exteriorPower` + `ShortComplex.ShortExact` + `isIso_iff_stalkFunctor_map_iso`
provide enough to write the foundational signatures FAITHFULLY now. Concretely, the next Lean
lane should: (1) supply the bridge instance `HasInjectiveResolutions (X.Modules)` via the
general Grothendieck-abelian theorems — this single instance unblocks `R^i f_*` and `H^i`;
(2) replace `higherDirectImage`/`Scheme.HModule`/`pushforwardBaseChangeMap` opaques with real
defs of the CORRECT shape (functor / module object / morphism) over that substrate; (3) turn
the stalk-locality anchor into a real theorem reducing to Mathlib (`ALIGN`); (4) build ∧^i/Sym^i
functors on `X.Modules` (∧ ports from ModuleCat; Sym is a true gap) and a locally-free
PREDICATE (`ObjectProperty`, like `isQuasicoherent`); (5) define M_L and K_{p,q} concretely on
top. Keep `opaque` ONLY as a genuinely last-resort temporary, and even then give it the real
type signature (e.g. `opaque higherDirectImage (f) (n) : X.Modules ⥤ Y.Modules`) so downstream
statements are non-vacuous and migration is incremental rather than a big-bang break.
