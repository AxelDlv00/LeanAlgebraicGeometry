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

- The two panel-blocking `sorryAx` dependencies were removed from
  `Pic0FiniteStageGluePackage.glueData` and
  `Pic0FiniteStageGluePackage.gluedMap`.
- `Pic0FiniteStageUniversalAtlasClass` now carries `universal_eq`, so its
  global class is propositionally pinned to
  `pic0SepClosedUniversalClass`; the canonical constructor discharges this by
  `rfl`.
- The finite-stage package still does not expose the producer's pair-transition
  inverse certificate.  The certificate is available in
  `exists_finSubext_pic0FiniteStageTransition_models`; retaining it in the
  package is deferred until a downstream consumer needs that API explicitly.
- The finite-stage universal-class package still has no theorem transporting
  its canonical class through the finite-stage glued carrier or proving the
  corresponding representability/descent statement.  Likewise,
  `finiteStageBaseChangeIso` remains a raw scheme isomorphism whose direct
  consumers supply representability separately; no structure-map equality or
  `Over`-category companion is proved.  These are follow-up architecture work,
  not claims established by this review capsule.
- The default `AlgebraicJacobian` target imports
  `Pic0FiniteStageGluingDiagramIso` but not
  `Pic0FiniteStageGluedComparison` or the `...GluingOverlapIsoSnd` chain.
  The comparison declarations are therefore outside the ordinary root-build
  validation graph.  A future milestone must add an intentional import or a
  dedicated test target before treating that chain as CI-validated.
- `Pic0FiniteStageOrbitAffine` and `Pic0FiniteStageStableAffineCover` still
  quantify independent `C : Over (Spec K)` and `Ck : Over (Spec k)` and take
  `RepresentableBy P.gluedOver` as an external hypothesis.  No producer links
  those binders to `finiteStageBaseChangeIso`; this remains a conditional
  endpoint pending base-change identification and representability transport.

## 🔴 Blocking audit findings

- **Raw comparison is not representability transport.**
  `Pic0FiniteStageGluedComparison.lean:284-292` exports
  `finiteStageBaseChangeIso` as an isomorphism of underlying `Scheme`s.  The
  source object is the pullback of `P.gluedMap` and the target is
  `(pic0_sepClosed_representableBy (C := C)).1.left`, but the declaration has
  no equality relating either structure map to `Spec k`.  The local transport
  API `Pic0RepresentableByTransport.lean:75-86` requires an isomorphism of
  `Over (Spec k)` objects.  The required repair is a structure-map square,
  followed by an exported `Over` isomorphism and the corresponding universal
  class/naturality transport; a raw `Scheme` iso must not be presented as a
  representer comparison.
- **The conditional consumers can mention unrelated curves.**
  `Pic0FiniteStageOrbitAffine.lean:31-49` and
  `Pic0FiniteStageStableAffineCover.lean:28-46` quantify an independent
  `C : Over (Spec K)` and `Ck : Over (Spec k)`, construct
  `P : Pic0FiniteStageGluePackage Ck F`, and then accept
  `rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy
  P.gluedOver`.  No equality or `Over` isomorphism connects `Ck` with the
  base-changed `C`; the same carrier can therefore be asserted to represent a
  different Picard functor.  The repair boundary is to tie `Ck` to the chosen
  base change (or pass and use an explicit curve `Over` iso) before removing
  the external `rep` binder.  The Galois/Jacobian wrappers inherit this gap.

## 🟠 Architecture / validation finding

- **The comparison cone is not in the default validation graph.**
  `AlgebraicJacobian.lean:815-817` reaches
  `Pic0CriticalPath.lean`, `Pic0FiniteStageGeometry.lean`, and
  `Pic0FiniteStageStableAffineCover.lean`, while
  `Pic0FiniteStageGluedComparison.lean` (and the
  `...GluingOverlapIsoSnd` chain) is not imported by the root.  Thus the
  exported `finiteStageBaseChangeIso` is not ordinary root-build evidence.
  Add an intentional root import or a dedicated CI test target before using
  that chain as validated infrastructure.

## 🟠 Follow-up API observations

- `exists_finSubext_pic0FiniteStageTransition_models` returns an inverse
  certificate, but `exists_pic0FiniteStageGluePackage` discards it at
  `Pic0FiniteStageGluePackage.lean:276`; the package consequently cannot expose
  a reusable pair-transition equivalence without rederiving it.
- `gluingGluedHom_ι` and `gluingGluedInv_ι` are private in
  `Pic0FiniteStageGluedComparison.lean:97-108,225-236`, so a future `Over`
  bridge cannot reuse the chart equations without reproving them.  The helper
  `gluingOverlapIso_pre_snd_snd` is also marked `[irreducible]` at
  `Pic0FiniteStageGluingOverlapIsoPreSndSnd.lean:37`, which makes the eventual
  naturality API needlessly opaque.

## ✅ Verified locally

- The directional chart/overlap equations in
  `Pic0FiniteStageGluingDiagramIso.lean` and
  `Pic0FiniteStageGluingOverlapIsoSnd.lean` are type-correct at the source
  level; no reversed-leg equality was found in this audit.
- `Pic0FiniteStageUniversalAtlasClass.universal_eq` pins only the exact
  separably-closed universal class.  It does not claim a class on
  `P.gluedOver`, which is the correct limitation until the missing `Over`
  comparison exists.
- The repository README's acceptance matrix
  (`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md:56-67,114-127`)
  independently classifies the `(rep : ...)` declarations as conditional
  consumers and names a binder-free finite-stage producer as the next required
  milestone.  This agrees with the type-level findings above.

## 🧪 Validation boundary

- `git diff --check` passes for this review capsule.
- A fresh `lean_diagnostic_messages` pass on
  `Pic0FiniteStageUniversalClass.lean` completed with no diagnostics.
  `Pic0FiniteStageGluePackage.lean` timed out while still elaborating (lines
  36 and 66-319), while `Pic0FiniteStageGluedOver.lean` and
  `Pic0CriticalPath.lean` were unavailable because their broad dependency
  graph did not finish.  These outcomes are recorded as limits, not as a
  local full-build claim.
- The existing `.github/workflows/lean.yml` `lake-build` job remains the
  authoritative full-build check; this audit makes no local full-build claim
  and does not change repository CI.

## 📚 References consulted

- A focused search of public mathlib4 pull requests for `Over`-category
  isomorphisms, scheme base change, and `RepresentableBy` transport found no
  close PR analogue to this finite-stage comparison, so no PR is presented as
  precedent.
- The current mathlib `Over.isoMk` API requires an underlying isomorphism plus
  an explicit commuting triangle in
  [`CategoryTheory/Comma/Over/Basic.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/CategoryTheory/Comma/Over/Basic.lean).
  The current scheme API likewise preserves explicit underlying-map equalities
  in [`AlgebraicGeometry/Scheme.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/AlgebraicGeometry/Scheme.lean).
  These sources support the raw-`Scheme` versus `Over` distinction above; the
  repository's `Pic0RepresentableByTransport.lean` is the implementation-level
  authority for the required transport theorem.

## 🗺️ Roadmap alignment

- Roadmap revision: `f7806c7ce1ce4889eec9bb5bfce154cffe933c24`
- Roadmap nodes: AJCR review lane / mathematical correctness / local Pic0 architecture
- Delivers: a review-scope manifest plus the panel-requested constructor repairs and the universal-class pinning invariant
- Unlocks: re-review of the repaired finite-stage glue constructors and a focused follow-up architecture milestone
- Provisional debt: the branch carries the two proof-restoration commits in `Pic0FiniteStageGluePackage.lean` and `Pic0FiniteStageGluedOver.lean`; the dropped transition-inverse field, finite-stage class transport, raw-to-`Over` comparison bridge, orphan comparison imports, conditional `C`/`Ck` consumers, and irreducible overlap equality remain explicit follow-up debt
- References: `ROADMAP.md`; `docs/references.bib`; current declarations and direct Pic0 consumers

The two carried proof-restoration commits replace baseline `opaque ... := by
sorry` declarations with their existing executable bodies. They are recorded
here for review transparency, not presented as evidence that the finite-stage
descent or Picard representation is complete.

## 🚫 Out of scope

Unrelated AJCR modules, Horizon control-plane files, dashboard/status artifacts, and implementation changes made solely to create review evidence.
