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

## 🗺️ Roadmap alignment

- Roadmap revision: `f7806c7ce1ce4889eec9bb5bfce154cffe933c24`
- Roadmap nodes: AJCR review lane / mathematical correctness / local Pic0 architecture
- Delivers: a review-scope manifest for the finite-stage Pic0 gluing foundation
- Unlocks: panel findings and a focused follow-up repair milestone in the same PR
- Provisional debt: the branch carries two pre-existing proof-restoration commits in `Pic0FiniteStageGluePackage.lean` and `Pic0FiniteStageGluedOver.lean`; their bodies remain subject to the panel review, and no new mathematical repair is claimed by this capsule
- References: `ROADMAP.md`; `docs/references.bib`; current declarations and direct Pic0 consumers

The two carried proof-restoration commits replace baseline `opaque ... := by
sorry` declarations with their existing executable bodies. They are recorded
here for review transparency, not presented as evidence that the finite-stage
descent or Picard representation is complete.

## 🚫 Out of scope

Unrelated AJCR modules, Horizon control-plane files, dashboard/status artifacts, and implementation changes made solely to create review evidence.
