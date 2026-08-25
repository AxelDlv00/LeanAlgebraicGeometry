# AJCR Pic0 finite-stage gluing foundation: review capsule

This file began as the inspection boundary for the Palimpsest review of issue
#2 and now records the concrete findings from that audit. It is a review
ledger, not a substitute for the panel's independent re-review or for a
mathematical repair.

## 🔍 Review scope

Inspect the current implementation on `palimpsest/main` and the complete dependency chain around:

- `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean`
- `Pic0FiniteStageGluingDiagramIso.lean`
- `Pic0FiniteStageGluingOverlapIsoPreSnd.lean` and its helper modules
- `Pic0FiniteStageGluingOverlapIsoSnd.lean`
- `Pic0FiniteStageGluedOver.lean`
- `Pic0FiniteStageUniversalClass.lean`
- `Pic0FiniteStageGluedComparison.lean`
- direct consumers in the Pic0 critical path

## 🧭 Reviewer responsibility

Reviewers should determine whether the existing declarations and proof route are mathematically correct and whether the Lean statements faithfully encode the intended mathematics. Report concrete findings with exact file and declaration references, including missing hypotheses, invalid universal properties, incorrect base-change or overlap claims, hidden field assumptions, and APIs that cannot support their stated consumers.

Do not assume that elaboration or the current roadmap establishes correctness.
After the panel publishes findings, the contributor will address them in this
same PR and the panel will re-review the new head.

## ✅ Applied repairs and retained debt

- The two review-blocking `sorryAx` dependencies were removed from
  `Pic0FiniteStageGluePackage.glueData` and
  `Pic0FiniteStageGluePackage.gluedMap`.
- `Pic0FiniteStageUniversalAtlasClass` now carries `universal_eq`, so its
  global class is propositionally pinned to
  `pic0SepClosedUniversalClass`; the canonical constructor discharges this by
  `rfl`.
- `chartBaseChangeIso_hom_structureMap`,
  `gluingChartIso_hom_structureMap`, and
  `gluingGluedIso_hom_structureMap` now propagate the chart-level structure
  map through the global gluing comparison.  The resulting
  `finiteStageBaseChangeIso_hom_structureMap` bundles the existing raw
  comparison as `finiteStageBaseChangeOverIso` in `Over (Spec k)`.
- The independent `C`/`Ck` consumer binders were re-audited without weakening
  their theorem statements.  The displayed `RepresentableBy P.gluedOver`
  value is already the formal evidence connecting the carrier to the named
  Picard functor; the actual route gap is the absence of a theorem constructing
  that evidence from the finite-stage package.
- `Pic0CriticalPath.lean` now imports `Pic0FiniteStageGluedComparison` and
  checks the structure-map and `Over` declarations, bringing the complete
  comparison chain into the default root-build graph.
- The finite-stage package still does not expose the producer's pair-transition
  inverse certificate.  The certificate is available in
  `exists_finSubext_pic0FiniteStageTransition_models`; retaining it in the
  package is deferred until a downstream consumer needs that API explicitly.
- The finite-stage universal-class package still has no theorem transporting
  its canonical class through the finite-stage glued carrier or proving the
  corresponding representability/descent statement.  The new `Over`
  comparison is object-level only: it neither supplies a curve over `P.N.1`
  nor transports the Picard natural equivalence in the descent direction.
  Direct consumers therefore continue to expose
  `RepresentableBy P.gluedOver` as an external hypothesis.  This is follow-up
  architecture work, not a claim established by the object comparison.

## ✅ Resolved audit findings

- **The raw comparison now has the required object-level `Over` API.**
  `finiteStageBaseChangeIso_hom_structureMap` proves the commuting triangle
  from the affine chart algebra maps through both multicoequalizers, and
  `finiteStageBaseChangeOverIso` packages that triangle with
  `finiteStageBaseChangeIso` using `Over.isoMk`.  Its docstring explicitly
  excludes curve, natural-equivalence, and representability descent.
- **The independent consumer binders do not create an unsound theorem.**
  Each result assumes
  `rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy
  P.gluedOver`; that proof, rather than the provenance of `P`, is exactly what
  its group-action and descent arguments consume.  Restricting `P` to a
  definitionally chosen base change would unnecessarily weaken these valid
  conditional results.  The remaining route debt is a binder-free producer
  deriving `rep` from a curve-compatible finite-stage construction.

## ✅ Validation graph repair

- `Pic0CriticalPath.lean` intentionally imports
  `Pic0FiniteStageGluedComparison.lean`, which transitively roots the
  `...GluingOverlapIsoSnd` chain.  It also checks the local, global, raw, and
  `Over` comparison declarations.  Protected CI remains authoritative for the
  resulting expanded root-build graph.

## 🟠 Follow-up API observations

- `exists_finSubext_pic0FiniteStageTransition_models` returns an inverse
  certificate, but `exists_pic0FiniteStageGluePackage` discards it at
  `Pic0FiniteStageGluePackage.lean:276`; the package consequently cannot expose
  a reusable pair-transition equivalence without rederiving it.
- `gluingGluedHom_ι` and `gluingGluedInv_ι` are private in
  `Pic0FiniteStageGluedComparison.lean`; the public
  `gluingGluedIso_hom_structureMap` now exposes the structure-map consequence
  needed by downstream code, so those implementation equations need not be
  exported solely for the `Over` bridge.  The helper
  `gluingOverlapIso_pre_snd_snd` remains marked `[irreducible]` at
  `Pic0FiniteStageGluingOverlapIsoPreSndSnd.lean:37`, which makes the eventual
  naturality API needlessly opaque.

## ✅ Verified locally

- The directional chart/overlap equations in
  `Pic0FiniteStageGluingDiagramIso.lean` and
  `Pic0FiniteStageGluingOverlapIsoSnd.lean` are type-correct at the source
  level; no reversed-leg equality was found in this audit.
- `Pic0FiniteStageUniversalAtlasClass.universal_eq` pins only the exact
  separably-closed universal class.  It does not claim a class on
  `P.gluedOver`, which remains the correct limitation after adding the
  object-level `Over` comparison.
- The repository README's acceptance matrix
  (`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md:56-67,114-127`)
  independently classifies the `(rep : ...)` declarations as conditional
  consumers and names a binder-free finite-stage producer as the next required
  milestone.  This agrees with the type-level findings above.

## 🧪 Validation boundary

- The generic affine structure-map calculation underlying
  `chartBaseChangeIso_hom_structureMap` compiles in a focused
  `lean_run_code` probe.  A second probe verifies the
  `limit.isoLimitCone_hom_π` projection equation used by
  `baseChangeGluingIso_hom_p2`.  A separate `Over.isoMk` probe verifies the
  exact source-object shape used by `finiteStageBaseChangeOverIso`.
- `lean_diagnostic_messages` was requested for every Lean file changed by the
  `Over` repair: `Pic0FiniteStageChartBaseChange.lean`,
  `Pic0FiniteStageGluingBaseChange.lean`,
  `Pic0FiniteStageGluingDiagramIso.lean`,
  `Pic0FiniteStageGluedComparison.lean`, and `Pic0CriticalPath.lean`.  Each
  request stopped before the file at the same broad failed-dependency graph
  (82 dependencies for the four comparison files and 85 for the root), so none
  is recorded as locally clean.  The earlier focused pass on
  `Pic0FiniteStageUniversalClass.lean` completed without diagnostics; this is
  supporting evidence only, not validation of the new head.
- A focused `lean_verify`/source scan of
  `Pic0FiniteStageGluePackage.glueData` reported only `propext`,
  `Classical.choice`, and `Quot.sound`, with no source warnings.
- The existing `.github/workflows/lean.yml` `lake-build` job remains the
  authoritative full-build check; this repair makes no local full-build claim
  and adds no further workflow change.

## 📚 References consulted

- A focused search of public mathlib4 pull requests for `Over`-category
  isomorphisms, scheme base change, and `RepresentableBy` transport found two
  close API precedents: [mathlib PR #24059](https://github.com/leanprover-community/mathlib4/pull/24059)
  adds explicit isomorphisms between representing objects, and [mathlib PR
  #40054](https://github.com/leanprover-community/mathlib4/pull/40054) adds
  Over-scoped base-change/pullback transport.  Their common design point is
  that the structure-preserving object isomorphism is a first-class API value,
  not an underlying carrier isomorphism.
- The current mathlib `Over.isoMk` API requires an underlying isomorphism plus
  an explicit commuting triangle in
  [`CategoryTheory/Comma/Over/Basic.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/CategoryTheory/Comma/Over/Basic.lean).
  The pullback API makes the same boundary explicit through
  `IsPullback.isoOverPullback` and
  `IsPullback.iff_exists_over_iso` in
  [`Limits/Pullback/IsPullback/Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Limits/Shapes/Pullback/IsPullback/Basic.html).
  The current scheme API likewise preserves explicit underlying-map equalities
  in [`AlgebraicGeometry/Scheme.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/AlgebraicGeometry/Scheme.lean).
  These sources support the raw-`Scheme` versus `Over` distinction above; the
  repository's `Pic0RepresentableByTransport.lean` is the implementation-level
  authority for the required transport theorem.

## 🗺️ Roadmap alignment

- Roadmap revision: `f7806c7ce1ce4889eec9bb5bfce154cffe933c24`
- Roadmap nodes: AJCR review lane / mathematical correctness / local Pic0 architecture
- Delivers: a review-scope ledger, constructor repairs, the universal-class
  pinning invariant, a rooted `Over` comparison, and a corrected account of
  the conditional consumer boundary
- Unlocks: exact-head panel review and a focused finite-stage curve plus
  Picard-natural-equivalence descent milestone
- Provisional debt: the branch carries the two proof-restoration commits in
  `Pic0FiniteStageGluePackage.lean` and `Pic0FiniteStageGluedOver.lean`; the
  dropped transition-inverse field, finite-stage curve and class transport,
  binder-free representability producer, and irreducible overlap equality
  remain explicit follow-up debt
- References: `ROADMAP.md`; `docs/references.bib`; current declarations and direct Pic0 consumers

The two carried proof-restoration commits replace baseline `opaque ... := by
sorry` declarations with their existing executable bodies. They are recorded
here for review transparency, not presented as evidence that the finite-stage
descent or Picard representation is complete.

## 🚫 Out of scope

Unrelated AJCR modules, Horizon control-plane files, dashboard/status artifacts, and implementation changes made solely to create review evidence.
