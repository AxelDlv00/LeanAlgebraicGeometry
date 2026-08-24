# AJCR Pic0 finite-stage gluing foundation: review capsule

This file is the inspection boundary for the Palimpsest review of issue #2. It
does not pre-classify a defect or propose a repair. Reviewers are expected to
discover the mathematical and maths-Lean issues from the complete source.

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
