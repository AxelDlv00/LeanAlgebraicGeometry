# Strategy Critic Report

## Slug
route174

## Iteration
174

## Routes audited

### Route: A — Picard scheme / Albanese via FGA

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` over arbitrary `k` (no `C(k)` hypothesis) directly yields the universally quantified `isAlbaneseFor` witness the protected signature demands.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III.6 is the standard chain. No claimed step assumes infrastructure that downstream lacks.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — every Mathlib gap A.1.a … A.4.d is **inside** the route with a concrete project-side phase and iter estimate. (Auslander–Buchsbaum is A.4.b, not a "future-work" deferral.)
- **Phantom prerequisites**: none verified absent. Weil-divisor API confirmed missing from Mathlib (`MeromorphicOn.divisor` is the only thing leansearch surfaces — analytic, not scheme-theoretic), correctly classified as in-tree A.4.a / RR.1.
- **Effort honesty**: under-counted — see "Effort honesty" block below. A.2.a / A.2.b / A.4.a are each plausibly 1.5–2× the stated LOC.
- **Parallelism under-exploited**: no — the L51-53 dependency graph is honest, names 5 parallel-startable prover lanes, and blueprint-writing is correctly identified as fan-outable to every un-written sub-chapter.
- **Verdict**: CHALLENGE — content sound, three sub-row LOC estimates under-counted (see Must-fix).

### Route: C — genus-0 rigidity completion via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k` + Cor 1.5 ⟹ constancy on `𝔾_m` + density of `𝔾_m ⊆ ℙ¹` + `ext_of_isDominant` closes `f` constant; combined with the `k̄→k` descent (still open) and `genus-0 ⟹ ≅ ℙ¹` (RR bridge), this delivers exactly the `genusZeroWitness.key` discharge the strategy promises.
- **Mathematical soundness**: PASS — the `𝔾_m`-scaling shortcut uses only the proven Cor 1.5 (axiom-clean) + the proven `ext_of_eqOnOpen`; the Thm-3.2 circularity rebuttal in §Route-C is correct (Thm 3.2 / Thm 3.4 is for a *non-complete* source, not the total `ℙ¹`).
- **Sunk-cost reasoning detected**: no — Route C is justified on a Mathlib-blockedness survey (deferred-routes char-free, fewer Mathlib gaps), not on prior investment.
- **Infrastructure-deferral detected**: no — the only remaining gap is `σ_×` chart construction, which has a 30-LOC analogist recipe verified, not deferred.
- **Phantom prerequisites**: `pullbackSpecIso`, `pullbackSymmetry`, `pullbackRightPullbackFstIso`, `Scheme.Cover.glueMorphisms` all spot-verified plausibly present (loogle timed out on the live names, but each is a standard `Mathlib.AlgebraicGeometry.Pullback` / `Mathlib.AlgebraicGeometry.Cover` declaration with the expected signature, and the rest of the project already imports siblings). `Proj.awayι_toSpecZero` I could not verify in this session — the planner should LSP-check before the cocycle-discharge prover dispatch.
- **Effort honesty**: reasonable — `~100-170 LOC · ~25/it` is internally consistent (≈4–7 iters at velocity ≈ stated `~3-6`).
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 101 lines / 13738 bytes — within line budget; **over 12 KB byte budget by ~14%**.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in order.
- **Per-iter narrative detected**: no — I searched for "iter-NNN" / "this iter" / "last iter" patterns and found none. Clean.
- **Accumulation detected**: minor — the two refactor rows (`Genus0BaseObjects.lean` split + `Cohomology/StructureSheafModuleK.lean` split) are housekeeping items deferred to future hygiene iters; they belong in `task_pending.md` rather than the strategy table, but the cost of leaving them is small.
- **Table discipline**: PASS in shape (Phase | Status | Iters left | LOC | Mathlib needs | Risks). Several LOC cells read `~XXX-YYY · ~0/it` (A.1.a, A.2.a, A.3, RR.1 — lanes where realized velocity is still 0 because the body-fill prover hasn't started). The format guidance flags `~0/it` as a dishonesty signal only when the row claims "actively progressing" — here the Status column honestly reports "file-skeleton lane open" or "chapter NOT YET WRITTEN", so the `~0/it` is consistent with the row state. Defensible.
- **Format verdict**: DRIFTED — size 14% over budget. Trim ~2 KB by collapsing the prose blurbs after the Route-A and Route-C headings to one paragraph each, or by demoting the per-sub-row "small assembly once parents land" Risks-cell remarks.

## Alternative routes (suggested)

### Alternative: Albanese UP via Sym^g C / theta-divisor (Mumford-Jacobian construction)

- **What it looks like**: Build the Jacobian as an open in `Sym^g C / linear-equivalence` and recover the Albanese UP from the Abel–Jacobi map `C → J, P ↦ [g·P - g·P₀]`. This sidesteps FGA representability entirely — no Quot, no flattening stratification.
- **Why it might be cheaper or sounder**: Mumford's construction is more concrete than Kleiman §4; the geometric content is "the `g`-fold symmetric product of a curve has a Jacobi quotient that is an abelian variety". It avoids A.2.a (flattening) + A.2.b (Quot) entirely — potentially ~1500–3000 LOC saved.
- **What the current strategy may have rejected**: (i) Mathlib has **no** `Sym^g` for schemes (leansearch confirms: only `Sym` for types and `SymmetricPower` for modules), so the `Sym^g C` construction is itself an in-tree build comparable to A.2.a/b in scope. (ii) Mumford's construction requires `C(k) ≠ ∅` for the base-point `P₀`, which the project goal explicitly disallows; recovering the unpointed case requires `Sym^g` over `k`-without-rational-point, which is delicate. (iii) The theta-divisor route still relies on Weil divisors on `C × Sym^{g-1} C`, overlapping with A.4.a.
- **Severity of the omission**: minor — likely not actually cheaper once you account for `Sym^g` infrastructure and the pointing-free issue. Worth one sentence in `## Open strategic questions` noting "Sym^g route considered and rejected for [reasons]" so future re-planners don't re-litigate.

### Alternative: Bypass A.4.a via `Pic⁰`-functor-of-points Albanese-UP construction

- **What it looks like**: Derive the Albanese UP directly from `Pic⁰`'s defining functor (`T ↦ {degree-0 line bundles on C×T}/{pullbacks from T}`). Given an AV `A` and `f : C → A`, build the line bundle `f^*L` for `L` on `A` and translate the universal property into a representability statement on Yoneda images, avoiding Milne Thm 3.2 / Lemma 3.3 codim-1 entirely.
- **Why it might be cheaper or sounder**: A.4.a (Lemma 3.3 + Weil divisor surface API) is the dominant project risk; bypassing it would slash ~900–1200 LOC. Functor-of-points arguments are typically Yoneda-shaped and lighter on `Mathlib` infrastructure than divisor-on-surface arguments.
- **What the current strategy may have rejected**: the functor-of-points UP still needs the `Pic⁰`-representability (A.2.c) AND a Weil divisor structure on `C × T` to convert "line bundle on `C × T`" ↔ "divisor class on `C × T`" — the latter overlaps with A.4.a's content. So the saving is partial, not total.
- **Severity of the omission**: major — worth one paragraph in Route A's prose section explicitly noting "the functor-of-points UP construction was considered; it shifts the A.4.a content into A.2.c but does not eliminate it". The planner should record this even if rejecting it, so future re-planners don't independently re-discover and re-litigate.

## Must-fix-this-iter

- **Route A: CHALLENGE — A.2.a effort under-counted.** Flattening stratification (Stacks 052H) at 600–900 LOC understates the Mathlib gap. Realistic build: generic flatness + noetherian induction on Krull-Schmidt + locally-closed strata indexing, ≈1200–2000 LOC. Either revise the row's LOC band or split A.2.a into a sub-decomposition (generic-flatness sub-build vs. full stratification) so the per-sub-phase estimates are honest.
- **Route A: CHALLENGE — A.2.b effort under-counted.** Quot scheme representability (Nitsure §5) at 800–1000 LOC understates that Mathlib has no Grassmannian scheme — the full FGA construction needs the Grassmannian-of-quotients embedding plus the flat-locus open subscheme. Realistic build: ≈1500–2500 LOC. Either widen the band or split A.2.b into a Grassmannian-sub-build + Quot-assembly.
- **Route A: CHALLENGE — A.4.a effort under-counted.** Lemma 3.3 + Weil-divisor sub-build at 900–1200 LOC understates. Building Weil divisors on a smooth surface from scratch (closed-point order, valuations on local rings, principal divisors, support, Cartier↔Weil equivalence, degree map) plus the codim-1 extension theorem is realistically ≈1500–2500 LOC. The shared material with RR.1 helps, but A.4.a's codim-1 indeterminacy locus is itself ≈400–600 LOC and is NOT a deduplication target. Widen the row or factor out a `WeilDivisor.Surface` sub-row.
- **Format: DRIFTED — byte budget 14% over.** Trim ~2 KB by collapsing the Route A and Route C prose blurbs to one paragraph each (the per-sub-row decomposition prose at L51 duplicates the Phases table) or by demoting the "small assembly once parents land" risk-cells to a single shared note.

## Overall verdict

The strategy is **SOUND in shape and direction** — Route A is the right Picard-engine spine for the positive-genus arm, Route C with the `𝔾_m`-scaling shortcut is the right Mathlib-blocked-minimising genus-0 base, the per-sub-row A.1–A.4 decomposition exposes the dependency graph honestly, and the parallelism claim is real. No infrastructure-deferral patterns: every named Mathlib gap is inside a sized phase with a concrete plan, and the theorem-of-the-cube / `Hom(𝔾_a,A)=0` / Thm-3.2 excisions are correct (the strategy actually *resolved* a deferral by demoting them off the critical path, rather than creating one). The single material correction is **effort honesty on A.2.a / A.2.b / A.4.a**, each plausibly 1.5–2× the stated LOC due to Mathlib gaps (Grassmannian, Weil divisors, flattening) the estimates undercount; the planner should widen those three LOC bands or factor each into sub-rows so the iter-counting downstream is honest. The format file is 14% over its byte budget — trim the Route-A and Route-C prose duplicates with the table to fix. Two alternative-route omissions worth recording in `## Open strategic questions` so re-planners don't independently re-discover them: the Sym^g-Jacobian construction (minor — likely not actually cheaper) and the `Pic⁰`-functor-of-points Albanese-UP (major — partially bypasses A.4.a). The strategy does **not** defer any construction required by the goal; all corrections are about effort calibration and minor format trim, not about route soundness.
