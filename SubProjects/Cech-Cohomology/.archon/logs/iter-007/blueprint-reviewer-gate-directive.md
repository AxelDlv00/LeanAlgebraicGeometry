# Blueprint Reviewer Directive

## Slug
gate

## Strategy snapshot

**Goal.** Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected frozen-signature target: for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent,
`𝒰` a finite affine open cover, `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`
under `[HasInjectiveResolutions X.Modules]`, with `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero project
axioms. Route A (acyclic-resolution comparison via Leray's acyclicity lemma) is CHOSEN.

**## Phases & estimations**

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P4 abstract acyclic-resolution lemma (Leray acyclicity, Stacks 015E) | ACTIVE | ~1 | ~120–220 | `rightDerivedZeroIsoSelf`, `ShortComplex.ShortExact.homology_exact₁/₂/₃`+`.δ`+`.δIso` (verified present) | Horseshoe + object-level dimension shift built; TARGET 3 staircase decomposed into 4 sourced leaves + assembly. Standard homological algebra, no new Mathlib gap. |
| P5a vanishing inputs (independent of P3/P4 — parallelisable) | NEXT | ~2–4 | ~150–350 | augmented-Čech-is-a-resolution (stalkwise); `R^q(jₛ)_*=0` affine open immersions; basis lemma `lem:cech_to_cohomology_on_basis` (Stacks 01EO) | Three absent-from-Mathlib `Scheme.Modules` facts. Basis lemma is the linchpin lifting narrowed standard-cover acyclicity to general-affine vanishing. |
| P3 affine acyclicity (`CechAcyclic.affine`) | NEXT (statement-gap fix) | ~3–6 | ~200–500 | standard-cover Čech complex = localisations; prime-local contracting homotopy | Lean signature takes general `X.OpenCover`; blueprint proves standard-cover case. Narrow non-protected signature to standard covers (downstream-safe via the P5a basis lemma). |
| P5b comparison assembly | LAST (needs P3+P4+P5a) | ~2–4 | ~150–300 | P3+P4+P5a + termwise `f_*`-acyclicity of `Cᵖ` | Final assembly. Routes general finite-affine `𝒰` through the basis lemma, NOT `CechAcyclic.affine` directly. |

## Routes
- **Route A — acyclic-resolution comparison (CHOSEN)**: augmented Čech complex is an `f_*`-acyclic
  resolution; the abstract "G-acyclic resolution computes `G.rightDerived`" lemma (P4, Stacks 015E)
  gives the comparison directly — one abstract lemma, no spectral sequences. Chapters:
  `Cohomology_AcyclicResolution.tex` (P4, the abstract lemma) + `Cohomology_CechHigherDirectImage.tex`
  (P3/P5 geometric inputs + assembly).
- **Route B — two spectral sequences (REJECTED, fallback only)**: both spectral sequences absent from
  Mathlib; strictly heavier. No blueprint coverage expected.

## References
- `references/homological-acyclic-derived.tex` (+ `.md`): Stacks `derived.tex` — right-F-acyclic
  objects (Tag 0157), criterion (015C), Leray acyclicity (015E), enough-acyclics (05TA), F-acyclic
  SES (015D). Backs the WHOLE `Cohomology_AcyclicResolution.tex` chapter, esp. the new TARGET 3 staircase.
- `references/stacks-cohomology.tex` (+ `.md`): Stacks `cohomology.tex` — `lemma-describe-higher-direct-images`
  (01XJ L592), `lemma-cech-vanish-basis` (01EO L1696). Backs `Cohomology_CechHigherDirectImage.tex`.
- `references/stacks-coherent.md` → `.tex`: Stacks ch.30 — Čech computes cohomology when intersections
  affine (02KE), Serre vanishing (02KG). Backs the Čech/affine-acyclicity material.

## Focus areas
- **`Cohomology_AcyclicResolution.tex` — PRIMARY.** This chapter just received the full TARGET 3
  decomposition (a staircase of new sub-lemmas) plus two plan-written coverage-debt blocks, and was
  then run through blueprint-clean. It feeds the ONLY live prover lane this iter
  (`AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, `[prover-mode: mathlib-build]`). Audit
  completeness + correctness of these new blocks carefully — they gate the prover dispatch:
  - `lem:cosyzygy_ses` (`CategoryTheory.Functor.cosyzygyShortExact`) — cosyzygy SES of an acyclic
    resolution. Frontier-ready (deps done).
  - `lem:acyclic_one_iso_coker` (`CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic`) — base
    coker iso `(R¹G)(A) ≅ coker(G(J)→G(Z))`. Frontier-ready (deps done).
  - `lem:applied_cosyzygy_cycles` (`CategoryTheory.Functor.gCosyzygyIsoCocycles`).
  - `lem:cohomology_of_applied_resolution` (`CategoryTheory.Functor.cohomologyAppliedResolutionIso`).
  - `lem:acyclic_resolution_computes_derived` (`CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`)
    — the comparison theorem assembly (TARGET 3). Its `\lean{}` declaration does NOT yet exist; this is
    a build/scaffold target, expected to be filled this iter — that is correct, not a fabrication.
  - `lem:quasiIso_tau2` (`HomologicalComplex.HomologySequence.quasiIso_τ₂`) and
    `lem:right_derived_shift_split_resolution`
    (`CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES`) — plan-written blocks for two
    ALREADY-PROVEN Lean decls (coverage debt, fixing previously-broken `\uses{}` refs). Both are
    project-bespoke Mathlib supplements: they legitimately carry NO `% SOURCE` block — do NOT flag the
    absence of source quotes as a citation failure.

## Known issues (do not re-report)
- `lem:acyclic_resolution_computes_derived`'s `\lean{}` target is not yet a Lean declaration — it is
  this iter's build target; expected.
- P3 statement gap (`CechAcyclic.affine` general `OpenCover` vs standard-cover blueprint) and the
  P5a/P5b geometric vanishing inputs in `Cohomology_CechHigherDirectImage.tex` are known-deferred
  (build dependencies, not writer-fixable this iter). Report that chapter's status, but the P3/P5
  `partial` is expected and is NOT the gate for this iter's P4 prover lane.
