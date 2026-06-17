# Strategy Critic Report

## Slug
iter048

## Iteration
048

## Routes audited

### Route: FBC (affine base change i=0)

- **Goal-alignment**: PASS — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward` are explicit `## Goal` bullets; the route targets exactly them.
- **Mathematical soundness**: PASS — iso-ness as `conjugateEquiv adjL adjR` of `gammaPushforwardNatIso` with module content `regroupEquiv` is a standard mate argument; the reduction of `_legs_conj` to conj-2b/2c/2d is coherent.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The kill-criterion is dated `iter-045 = FINAL` but the row still reads `Iters left: 1` at iteration 048, i.e. the route has been carried at least 3 iters past its own stated terminal round without the row flipping to PARKED.
- **Infrastructure-deferral detected**: yes — `_legs_conj` (and the independent A2 affine/locality reduction) are required by `## Goal` yet the live plan routes to escalate+park rather than commit to a build. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none — `CategoryTheory.conjugateEquiv` (+ `conjugateEquiv_apply_app`) VERIFIED present in `Mathlib.CategoryTheory.Adjunction.Mates`.
- **Effort honesty**: reasonable — `~60–120` LOC / 1 iter is consistent with "final round then park"; A2 at `~200–500` / 3–6 is honest about a second Mathlib-absent build.
- **Parallelism under-exploited**: no — FBC-B already runs as a split-out parallel lane.
- **Verdict**: CHALLENGE

### Route: GF-geo (generic flatness, geometric)

- **Goal-alignment**: PASS — wraps the DONE algebraic core into `thm:generic_flatness` with the goal's `[IsQuasicoherent]`+`[IsFiniteType]` signature.
- **Mathematical soundness**: PASS — affine-cover + per-patch algebraic form + `V=D(∏fⱼ)` freeness is the textbook reduction; the G1 affine base case via gap1 transport is sound.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — seam-1 is decomposed into 3 concrete primitives with a Stacks-01PB anchor; the transport reuses the DONE gap1 recipe rather than deferring.
- **Phantom prerequisites**: none — `SheafOfModules.IsFiniteType` + `.exists_localGeneratorsData` VERIFIED; this confirms the abstract datum is only `∃ σ, σ.IsFiniteType` (a `LocalGeneratorsData`), so the finite-basic-open refinement is genuinely absent, not phantom.
- **Effort honesty**: reasonable — `~150–350` / 3–5 iters for 3 primitives + assembly + G3 is plausible.
- **Parallelism under-exploited**: no (G3 sequencing-after-G1 is documented and acceptable).
- **Verdict**: SOUND

  On the directive's Q1 alternative ("work entirely over `Spec Γ(X,W)` from the start to avoid the X.Modules transport"): this does **not** dodge either wall. Transporting `F|_W` to a qcoh sheaf on `Spec A` *is* the gap1 transport, and asking finite-type on `Spec A` still bottoms at the 01PB refinement (`M̃` finite-type ⟹ `M` finite). The two hardest prerequisites — transport and the 01PB finite-cover refinement — are identical before and after the proposed reframing. The current decomposition is the right move.

### Route: QUOT / GR (Quot scheme + Grassmannian representability)

- **Goal-alignment**: PASS — targets `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`.
- **Mathematical soundness**: PASS — graded-Hilbert-function encoding via `existsUnique_hilbertPoly` + the DONE rationality engine; GR cells/glue/sep/proper DONE; representability via functor-of-points.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — but see parallelism.
- **Phantom prerequisites**: none — `Polynomial.existsUnique_hilbertPoly` VERIFIED (`[CharZero]`, as stated).
- **Effort honesty**: reasonable — `~400–1000+` / 6–12 iters for GR-quot+GR-repr is wide but honest given realized comparators (GR-proper ~330/≈5, GR-cells ~600/2); the headline theorem genuinely carries this scope.
- **Parallelism under-exploited**: yes — GR-quot/repr is the longest remaining pole (6–12 iters) on the critical path to the headline `thm:grassmannian_representable`, is independent of both live infra frontiers (new file; GR-repr depends only on the RelativeSpec strengthening, not on GF/SNAP), yet sits in `NEXT` rather than being scaffolded now. The import-race serialization the strategy documents applies to QUOT-defs (in `QuotScheme.lean`, imported by `FlatteningStratification`), **not** to GR-quot's new file.
- **Verdict**: SOUND (with a parallelism flag — see Must-fix)

### Route: SNAP (section graded ring infra)

- **Goal-alignment**: PASS — `def:sectionGradedRing` feeds the Hilbert-polynomial encoding the goal's `def:hilbert_polynomial` rests on.
- **Mathematical soundness**: PASS — the associator is genuinely required: a graded *ring* (associative multiplication) on `Γ_*(X,L)=⊕Γ(X,L^{⊗m})` cannot be obtained from lax-Γ alone; associativity of `sectionsMul` traces to the coherence of `L^{⊗m}⊗L^{⊗n}≅L^{⊗(m+n)}`, i.e. the monoidal associator of the sheaf tensor.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the associator is named as the active wall with two concrete routes, not deferred to "future work."
- **Phantom prerequisites**: none — and notably the route #2 scaffolding is RICHER than the strategy lets on: `CategoryTheory.Localization.Monoidal.toMonoidalCategory`, `CategoryTheory.Sheaf.monoidalCategory` (`MonoidalCategory (Sheaf J A)` given `[J.W.IsMonoidal]`), the **strong-monoidal** `Sheaf.instMonoidalFunctorOppositePresheafToSheaf` (`(presheafToSheaf J A).Monoidal`), and `MorphismProperty.IsMonoidal` (+ `IsMonoidal.mk'` reducing it to tensor-stability of the localizer) are all VERIFIED present. The only genuinely-absent piece is the *varying-ring* (`PresheafOfModules.sheafification`) transport of this; `MonoidalCategory (SheafOfModules _)` is NOT in Mathlib (confirmed). So the build is "supply `IsMonoidal` for the module-presheaf local-iso localizer and reuse the generic strong-monoidal sheafification," not "build an associator from scratch."
- **Effort honesty**: reasonable — `~200–450` / 3–6 iters; if anything the verified generic infra makes this slightly *over*-counted rather than under.
- **Parallelism under-exploited**: no — SNAP-S0 and GF-geo are already separate active lanes in different files.
- **Verdict**: SOUND

  On the directive's Q2 ("sidestep the full sheaf-monoidal associator"): a partial sidestep exists but is unlikely to be cheaper — see Alternative routes. The recommended action is not to sidestep but to lean route #2 explicitly on the verified `Sheaf.monoidalCategory`/`MorphismProperty.IsMonoidal.mk'` entry points rather than the open-ended "stalkwise-iso criterion."

## Format compliance

- **Size**: 160 lines / 19,743 bytes — **over budget** (~12 KB ceiling exceeded by ~64%). Line count is fine; the byte overage comes from prose-paragraph table cells.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive. E.g. Status cell `"adjL/hunitL landed iter-044, adjR/β remain. FINAL in-loop round iter-045 → escalate+park"`; Risks cell `"the 037–041 trap"` and `"Effort-broken iter-048"`; Open-questions prose `"the live route (analogist iter-044)"`, `"Q6 — GF-geo G3 parallelism (strategy-critic iter-039)"`.
- **Accumulation detected**: no — `## Completed` is 9 rows (within ~12); gap1/gap2 correctly moved out of the active table.
- **Table discipline**: FAIL — the `Status` column carries multi-clause prose with iter history (e.g. FBC-A1, GF-geo, SNAP-S0) instead of a short inline tag; the rule requires `Status` to be a tag (`ACTIVE`/`BLOCKED`/`STUCK`/…) with detail living elsewhere.
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: FBC keystone `_legs_conj` (and the A2 affine/locality reduction)

- **Required by goal**: yes — FBC (`lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`) is an explicit `## Goal` bullet; `_legs_conj` is the keystone of the affine lemma and A2 is the independent second sorry of the same theorem.
- **Current plan for building it**: a "final round then escalate via TO_USER + park," with a documented in-prose fallback (reopen element-`ext` using the conj atoms as a change-of-rings dictionary, OR a refactor rebuilding `_legs` from `leftAdjointCompIso` primitives). The fallback is described but is **gated behind** park-on-failure rather than committed to with a timeline.
- **Timeline**: absent for the build — the only dated commitment is "park" (and that date, iter-045, has already passed).
- **Verdict**: CHALLENGE — "Off critical path (no QUOT/GF/GR dependency)" is true of *downstream* dependents but does not remove FBC from the goal. Parking FBC = not delivering a goal bullet. The planner must this iter (a) reconcile the stale kill-criterion — record FBC as actually PARKED-pending-user (flip the Status, stop showing `Iters left: 1`) or justify continuing past iter-045; and (b) state whether a documented fallback gets built in-loop with an iter estimate, or whether the user has signed off on descoping FBC from `## Goal`. Escalation-to-the-supervising-mathematician is a legitimate terminal state — but it must be recorded as a goal-impacting decision, not left implicit behind a stale "1 iter left."

## Alternative routes (suggested)

### Alternative: graded ring over a fixed polynomial / Proj coordinate ring (SNAP-S0 partial sidestep)

- **What it looks like**: instead of `Γ_*(X,L)` as a sheaf-tensor object, build `⊕Γ(X,F⊗L^{⊗m})` as a `DirectSum`-graded module over the homogeneous coordinate ring `MvPolynomial (Fin (n+1)) κ = ⊕Γ(ℙⁿ,O(m))` of a projective embedding, whose `CommRing`/`DirectSum.GAlgebra` structure is already in Mathlib. Feed that to the DONE `gradedModule_hilbertSeries_rational`.
- **Why it might be cheaper or sounder**: ring associativity becomes polynomial multiplication (free), removing the need to certify the sheaf associator as the ambient *ring's* coherence.
- **What the current strategy may have rejected**: the module-action coherence `(O(m)⊗O(n))⊗F ≅ O(m)⊗(O(n)⊗F)` still requires the same associator for powers of the single very-ample `O(1)`, so the sidestep narrows the associator's role rather than eliminating it, and it imports the Proj/very-ample embedding machinery. Likely **not** net-cheaper than route #2 now that the generic `Sheaf.monoidalCategory`/`MorphismProperty.IsMonoidal.mk'` infra is confirmed present.
- **Severity of the omission**: minor.

## Sunk-cost flags

- `STUCK — 8-iter wall (037→044) … FINAL in-loop round iter-045 → escalate+park if adjR/β resist` (FBC-A1 Status, with `Iters left: 1` at iteration 048) — Why this is sunk-cost: the route names its own terminal round as iter-045 yet is still carried as active with "1 iter left" three iters later, so either the kill-criterion silently slipped or the row is stale. Recommendation: flip FBC-A1 to a `PARKED`/`ESCALATED` tag and move its narrative to the iter sidecar, or, if genuinely still active, replace the stale "iter-045 = FINAL" with a fresh terminal condition the planner actually intends to honor.

## Prerequisite verification

- `CategoryTheory.conjugateEquiv`: VERIFIED (`Mathlib.CategoryTheory.Adjunction.Mates`)
- `SheafOfModules.IsFiniteType` / `.exists_localGeneratorsData`: VERIFIED (`…Sheaf.Generators`) — abstract datum is only `∃ σ, σ.IsFiniteType`, confirming the seam-1 refinement is genuinely absent
- `PresheafOfModules.sheafification` (+ `sheafificationAdjunction`): VERIFIED
- `PresheafOfModules.Monoidal.*` / `PresheafOfModules.monoidalCategory`: VERIFIED
- `CategoryTheory.Localization.Monoidal.toMonoidalCategory`: VERIFIED (`…Localization.Monoidal.Basic`)
- `CategoryTheory.Sheaf.monoidalCategory`: VERIFIED (`…Sites.Monoidal`, needs `[J.W.IsMonoidal]`)
- `CategoryTheory.Sheaf.instMonoidalFunctorOppositePresheafToSheaf` (strong-monoidal `presheafToSheaf`): VERIFIED
- `CategoryTheory.MorphismProperty.IsMonoidal` / `IsMonoidal.mk'`: VERIFIED — reduces the route #2 obligation to tensor-stability of the localizer
- `MonoidalCategory (SheafOfModules _)`: MISSING (confirmed absent) — so the varying-ring transport is the real residual gap
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`…Polynomial.HilbertPoly`, `[Field][CharZero]`)

## Must-fix-this-iter

- Route FBC: CHALLENGE — reconcile the stale kill-criterion (iter-045 named FINAL, still `Iters left: 1` at 048): either flip Status to PARKED/ESCALATED and stop carrying it as active, or set a fresh terminal condition.
- Route FBC: infrastructure-deferral CHALLENGE — `_legs_conj` (and A2) are required by `## Goal`; "off critical path" does not remove them from the goal. Record park-as-goal-impacting (user descope) OR commit a documented fallback with an iter estimate.
- Route GR (QUOT): parallelism — GR-quot/repr is the headline-goal long pole, independent of both live frontiers, sitting in `NEXT`. Begin its new-file scaffold + blueprint now in parallel with the GF/SNAP infra builds (no import race — that constraint binds QUOT-defs in `QuotScheme.lean`, not GR-quot's new file).
- Format: NON-COMPLIANT — (1) byte budget ~64% over (~19.7 KB vs ~12 KB); (2) `Status` cells are prose, not tags; (3) pervasive per-iter narrative in Status/Risks/Open-questions. Restructure in-place this iter: shrink Status to tags, push iter history to the sidecar, trim Open-questions prose.

## Overall verdict

The two live frontiers are mathematically sound and, importantly, NOT built on phantom prerequisites: every named lemma/structure verified present, and the GF-G1 seam-1 / SNAP-S0 associator walls are genuine Mathlib-absent constructions correctly identified rather than design errors. The GF-G1 decomposition into 3 primitives + gap1 transport is the right move — the directive's "work over `Spec Γ(X,W)` from the start" alternative is a non-pivot that retains the same two hardest prerequisites. SNAP-S0's associator investment is justified, and is in fact lighter than the strategy implies: the generic strong-monoidal-sheafification + `MorphismProperty.IsMonoidal.mk'` machinery is already in Mathlib, leaving only the varying-ring (`PresheafOfModules.sheafification`) transport. Two things must be fixed this iter. First, **the strategy defers FBC's `_legs_conj` (and A2), which is required for the stated goal** — the kill-criterion is stale (it named iter-045 as final, but the route is still carried active at iter-048), and "off critical path" does not excuse a goal bullet; the planner must record the park as a goal-impacting decision or commit a fallback with a timeline. Second, GR-quot/repr — the longest pole on the critical path to the headline `thm:grassmannian_representable` and independent of the live frontiers — should be scaffolded in parallel now rather than waiting in `NEXT`. Finally, the document is NON-COMPLIANT (64% over the byte budget, prose Status cells, pervasive iter narrative) and must be restructured in-place this iter.
