# Strategy Critic Report

## Slug
iter009

## Iteration
009

## Routes audited

### Route: FBC (affine lemma direct-on-sections + Čech-free globalization)

- **Goal-alignment**: PASS — reducing the affine i=0 base-change iso to `cancelBaseChange` and globalizing via the H⁰-equalizer is the right shape for `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`, and is genuinely Čech-cohomology-free (sheaf condition is Čech degree 0/1, not cohomology). This matches Stacks 02KH(2).
- **Mathematical soundness**: PASS — the math is correct. `(R'⊗_R A)⊗_A M ≅ R'⊗_R M` is `cancelBaseChange`; flat `−⊗B` preserves the finite equalizer via `Module.Flat.ker_lTensor_eq` / `LinearMap.tensorEqLocusEquiv`.
- **Sunk-cost reasoning detected**: yes — the live plan keeps the adjoint-**mate** tower (`base_change_mate_regroupEquiv`, `base_change_mate_generator_trace_eq`, + the 3 sub-lemmas `unit-value` / `fstar-reindex` / `gstar-transpose`) that the route's own prose says to DROP. Carried because ~6 iters of work already went into it, not because the stated route needs it.
- **Infrastructure-deferral detected**: yes — the iter-003-style "pivot to direct-on-sections" changed the surface framing but the hardest prerequisite is unchanged before vs after: the categorical adjoint-mate computation plus the opaque `Module R'` / `IsScalarTower` / `SMulCommClass` instance wall on the regrouped tensor. Pattern #1 (pivot renames the problem, same hardest prereq).
- **Phantom prerequisites**: none — `TensorProduct.AlgebraTensorModule.cancelBaseChange`, `Module.Flat.ker_lTensor_eq`, `LinearMap.tensorEqLocusEquiv` all VERIFIED present.
- **Effort honesty**: under-counted (acknowledged) — FBC-A self-flags OVER-BUDGET (5 iters elapsed vs 3–5 est) yet still carries `3–4` more iters on the same mate path that produced the overrun. The 3–4 is optimistic if the mate tower stays.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

### Route: GF (algebraic core + geometric wrapper)

- **Mathematical soundness**: PASS — `genericFlatnessAlgebraic` (Noetherian domain A, finite-type A-algebra B, finite B-module M ⟹ ∃ f≠0, M_f free over A_f) is exactly Nitsure §4 / generic flatness. The dévissage on variable count d with the SES `0→P_d^{⊕m}→N→T→0` and single-variable Nagata reindex is the canonical proof.
- **Infrastructure-deferral detected**: no — the Mathlib-absent variable-drop / denominator-clearing engine is planned project-side, decomposed (`gf_clear_one_denominator` + fold, shared with `gf_torsion_reindex`), and on an ACTIVE lane with a concrete iter estimate.
- **Phantom prerequisites**: none verified-as-missing — `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` VERIFIED (full name, `Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`). `exists_finite_inj_algHom_of_fg` not independently confirmed (see Prerequisite verification).
- **Verdict**: SOUND
  - The Q2 base-domain-generalization finding is mathematically correct: the reindex sends base `A → A_g`, so the strong-induction IH only typechecks at base `A_g`, forcing `A` (+ instances) into the motive. The shared-universe `(A N : Type u)` pin is the right fix and is **not** a downstream constraint for the `Scheme.{u}` cone — see Q2 analysis below.

### Route: QUOT (graded-Hilbert encoding, predicates, Grassmannian, representability)

- **Goal-alignment**: PASS — the graded Hilbert-function encoding of `def:hilbert_polynomial` yields the same polynomial as the cohomological χ for m≫0 without higher cohomology, keeping QUOT inside the Čech-independent leg. Sound and goal-faithful.
- **Mathematical soundness**: PASS — SNAP S1/S2/S3 (Serre correspondence → graded Hilbert–Serre rationality → `existsUnique_hilbertPoly` extraction) is the classical route; GR-cells/glue/quot/repr is the standard big-cell construction of the Grassmannian.
- **Infrastructure-deferral detected**: partially — `gradedModule_hilbertSeries_rational` (graded Hilbert–Serre rationality) is Mathlib-ABSENT and **required by the goal** (`def:hilbert_polynomial`), but it IS planned project-side as S2 with a concrete description. The concern is status, not plan: SNAP is marked BLOCKED with **no named unblocking dependency** (see Infrastructure-deferral findings).
- **Phantom prerequisites**: none — `Polynomial.existsUnique_hilbertPoly` VERIFIED (and is indeed only the extraction half, as the strategy states).
- **Effort honesty**: at the optimistic edge — QUOT-repr `~400–1000+` LOC / `6–12` iters for a from-scratch Grassmannian over ℤ + Plücker gluing + separatedness-via-diagonal + tautological-quotient universal property is light at the bottom of the range; the `1000+` / `12` top-ends keep it honest. Watch GR-glue.
- **Verdict**: SOUND (with the SNAP status caveat below)

## Format compliance

- **Size**: 142 lines / ~9 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, canonical order; `## Completed` legitimately omitted (no phase is fully complete — all ACTIVE/NEXT/BLOCKED).
- **Per-iter narrative detected**: yes — pervasive. Verbatim: "blueprinted iter-007"; "Decomposed iter-007 … into"; "Load-bearing structural finding (iter-007):"; "the real cause of the iter-006 stall, not the rank API"; "scaffolding STARTED iter-007"; "(PIVOT iter-003, addressing the strategy-critic CHALLENGE)"; "rewritten to the graded encoding (iter-003)"; "VERIFIED iter-007"; "(strategy-critic iter-007 housekeeping)". Per-iter history belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: yes (minor) — the inline "*Rejected:* the cohomological-χ encoding …" is a considered-alternative kept in prose; that belongs in an iter sidecar, not STRATEGY.md.
- **Table discipline**: FAIL — several `## Phases & estimations` cells are multi-clause paragraphs (FBC-A `Risks`, GF-alg `Risks`, QUOT-defs `Risks`), violating "one short line per cell".
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: adjoint-mate computation + `Module R'` instance wall (FBC-A)

- **Required by goal**: yes — `lem:affine_base_change_pushforward` is a goal node; the affine iso must be identified with `cancelBaseChange`.
- **Current plan for building it**: contradictory. `## Routes` says "Drop the parent's abstract adjoint-mate ↔ cancelBaseChange decomposition" and "Prove the affine lemma directly on global sections … reducing … to cancelBaseChange". But `## Phases & estimations` (FBC-A row) and `## Mathlib gaps` both list the 3 mate sub-lemmas (`unit-value`/`fstar-reindex`/`gstar-transpose`) + `base_change_mate_regroupEquiv` + `base_change_mate_generator_trace_eq` + the `map_smul'` opaque-`Module R'` reduction as required work. The plan keeps exactly what the route says to drop.
- **Timeline**: `3–4` iters, but on the same mate path that already overran (`OVER-BUDGET`).
- **Verdict**: CHALLENGE — the pivot moved the same hard prerequisite one layer deeper without solving it. Resolve the contradiction this iter (see Must-fix and the FBC alternative below).

### Deferred: `gradedModule_hilbertSeries_rational` status (SNAP)

- **Required by goal**: yes — gates `def:hilbert_polynomial`.
- **Current plan for building it**: planned as SNAP-S2, "classical, inductive on degree-1 generators" — an adequate plan.
- **Timeline**: `2–4` iters, but the phase is marked **BLOCKED with no named blocker**. A BLOCKED phase with a concrete authorable plan and no stated unblocking dependency and no active lane is deferral-by-inaction. (Plausibly it is blocked on the QUOT-defs `sectionGradedRing` predicate for S1 — if so, say so and edge it; if not, move SNAP to NEXT and start S2, which imports only Mathlib + the already-blueprinted graded encoding.)
- **Verdict**: CHALLENGE (light) — name SNAP's blocker dependency explicitly or re-status it ACTIVE/NEXT.

## Alternative routes (suggested)

### Alternative: identify Γ(θ) as the lTensor of the algebraic unit (FBC-A), dropping the mate tower

- **What it looks like**: The base-change map `θ : g*f_*F → f'_*g'^*F` is the mate of `f_*` applied to the unit of `g'^* ⊣ g'_*`. In the affine-affine case its value on global sections is precisely the R'-base-change of the algebraic unit on sections: `Γ(θ) = (R'⊗_R −)` applied to `η_M : M → (R'⊗_R A)⊗_A M, m ↦ 1 ⊗ₜ m`. So: (1) prove the one section-level naturality identity `Γ(θ) = lTensor R' η_M`; (2) post-compose with `cancelBaseChange`. This replaces the three categorically-subtle *untyped* sub-lemmas (unit-value / fstar-reindex / gstar-transpose) and the `…_generator_trace_eq` with a single typed section-level identification.
- **Why it might be cheaper or sounder**: it is the route the strategy *already commits to in prose* but does not execute. It removes the adjunction-unit/reindex/transpose superstructure entirely. Crucially, the `Module R'` / `IsScalarTower R R' (regrouped)` / `SMulCommClass A R' M` instance wall is **intrinsic to `cancelBaseChange`'s signature** (verified: `TensorProduct.AlgebraTensorModule.cancelBaseChange` demands `[Module B M] [IsScalarTower R B M] [SMulCommClass A B M]`) — so **no route dissolves it**, and it should be isolated as a single standalone instance lemma proved once, decoupled from the map identification. This directly answers Open strategic question #2: the direct-on-sections route dissolves the *mate tower* (superstructure) but **not** the instance wall (inherent); the current plan is the worst of both worlds because it keeps the tower AND fights the wall.
- **What the current strategy may have rejected**: nothing explicitly — the strategy says to take this route but the live decomposition reverts to the mate path (sunk cost from ~6 iters).
- **Severity of the omission**: critical — this is the single highest-leverage decision in the leg; a route swap here is what Open strategic question #2 exists to force.

## Sunk-cost flags

- `the 3 mate sub-lemmas (unit-value / fstar-reindex / gstar-transpose, blueprinted iter-007)` + `base_change_mate_regroupEquiv` / `base_change_mate_generator_trace_eq` — Why this is sunk-cost: the `## Routes` FBC prose says to drop the adjoint-mate decomposition, yet the Phases/Gaps sections retain the entire mate tower because it was already blueprinted and partially built over ~6 iters. Recommendation: decide on the merits — if direct-on-sections is the route, delete the mate tower from the plan and execute the `lTensor η_M` identification; if the mate computation is genuinely required, correct the Routes prose (it currently misstates the plan) and stop calling the route "direct on sections".

## Prerequisite verification

- `TensorProduct.AlgebraTensorModule.cancelBaseChange`: VERIFIED (`Mathlib.LinearAlgebra.TensorProduct.Tower`; instance baggage `[Module B M] [IsScalarTower R B M] [SMulCommClass A B M]` = the "opaque instance wall").
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib.RingTheory.Flat.Equalizer`).
- `tensorEqLocusEquiv`: VERIFIED as `LinearMap.tensorEqLocusEquiv` (`Mathlib.RingTheory.Flat.Equalizer`) — strategy's bare name is namespace-shortened, fine.
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`: VERIFIED (`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`; motive over `N : Type v` with `A : Type u` fixed).
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`; extraction-only, `[CharZero F]`, as the strategy states).
- `exists_finite_inj_algHom_of_fg`: UNVERIFIED — not independently confirmed (not marked VERIFIED in STRATEGY either). Planner should confirm it exists in Mathlib or is a project build before depending on it in GF-alg.

## Q2 — GF shared-universe pin (directive question 2)

Acceptable; not a downstream constraint. In the `Scheme.{u}` parent cone the geometric instantiation gives `A = Γ(O_X)` and `N = Γ(F)` both in `Type u`, so `(A N : Type u)` is exactly satisfied. Every intermediate the induction touches preserves universe `u`: `Localization.Away g`, `MvPolynomial (Fin k) A_g` (`Type (max 0 u) = Type u`), and `FractionRing` all stay in `u`. The only statement the pin *cannot* serve is one instantiated at `A : Type u`, `N : Type v` with `v < u`, and the cone has no such consumer (Mathlib's own dévissage `induction_on_isQuotientEquivQuotientPrime` keeps `A` fixed while letting the module live in an independent `v`, so independent universes are even conceivable — but the shared pin is the simpler correct choice here). No flag.

## Must-fix-this-iter

- Route FBC: CHALLENGE — STRATEGY.md is internally contradictory (Routes says "drop the adjoint-mate decomposition"; Phases + Mathlib-gaps require the full mate tower). Resolve it: either (a) commit to direct-on-sections and delete the mate tower, executing `Γ(θ) = lTensor R' η_M` + `cancelBaseChange`, isolating the `Module R'` instance reconciliation as one standalone lemma; or (b) admit the mate computation is required and correct the Routes prose. Settling Open strategic question #2 is a precondition for sinking more FBC-A iters.
- Route QUOT / SNAP: infrastructure-deferral CHALLENGE — `gradedModule_hilbertSeries_rational` is required by the goal and SNAP is BLOCKED with no named blocker. Name SNAP's unblocking dependency (likely the `sectionGradedRing` predicate) and edge it, or re-status SNAP ACTIVE/NEXT and start S2.
- Alternative (FBC `lTensor η_M`): critical omission — the strategy names this route but does not execute it; adopt it or rebut it explicitly in `iter/iter-009/plan.md`.
- Format: DRIFTED — strip the ~9 per-iter citations (iter-003/006/007) from STRATEGY prose into the iter sidecar; move the inline "*Rejected:* cohomological-χ" note to a sidecar; shorten the overstuffed Phases-table `Risks`/`Key Mathlib needs` cells to one line each.

## Overall verdict

The leg's mathematics is sound and every load-bearing Mathlib prerequisite I checked exists — no phantom infra. But the FBC route is incoherent as written: **the strategy says to drop the adjoint-mate decomposition while the plan keeps the entire mate tower**, which is the infrastructure-deferral signature — a pivot that renamed the surface approach (direct-on-sections) while preserving the same hardest prerequisite (the adjoint-mate computation plus the intrinsic `Module R'`/`IsScalarTower`/`SMulCommClass` instance wall) that has blocked FBC-A for ~6 iters and pushed it over budget. There is a more direct path the strategy already gestures at but does not take: identify `Γ(θ)` as `lTensor R'` of the algebraic unit and post-compose with `cancelBaseChange`, isolating the (unavoidable, inherent-to-cancelBaseChange) instance reconciliation as a single standalone lemma — this dissolves the mate tower even though nothing dissolves the instance wall, and it resolves Open strategic question #2. Separately, **the strategy defers `gradedModule_hilbertSeries_rational`, which is required for the stated goal** (`def:hilbert_polynomial`), into a BLOCKED phase with no named blocker — name the dependency or start it. The GF route (including the shared-universe pin, which is correct for the `Scheme.{u}` cone) and the QUOT graded-encoding decision are sound. Format has drifted via pervasive per-iter narrative and overstuffed table cells and should be restructured in-place this iter.
