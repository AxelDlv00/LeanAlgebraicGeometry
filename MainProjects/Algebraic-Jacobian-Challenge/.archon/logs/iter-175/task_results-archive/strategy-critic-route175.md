# Strategy Critic Report

## Slug
route175

## Iteration
175

## Routes audited

### Route: A — Picard scheme / Albanese via FGA

- **Goal-alignment**: PASS — `Pic⁰_{C/k}` correctly satisfies all five protected typeclass instances on the positive-genus arm; no k-point hypothesis is smuggled.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III §6 is the standard FGA stack.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — A.2.a (flattening, 8–14 iters · ~1200–2000 LOC), A.2.b (Quot, 10–17 iters · ~1500–2500 LOC) and A.4.a (Lemma 3.3 + Weil surfaces, 13–20 iters · ~1500–2500 LOC) are LANDED as chapters but are stated as monolithic mega-phases with NO sub-phase decomposition. Compare the careful A.4.a/b/c/d split of Albanese: the same discipline must be applied here. Phases sized at >8 iters with `~0/it` realised velocity are deferred-by-inaction.
- **Phantom prerequisites**: spot-checked `Grassmannian` (absent), `flattening stratification` / Stacks 052H (absent — leansearch returns only `SheafOfModules.Presentation`), `Auslander–Buchsbaum` (only depth/regular pieces, not the formula), `relativeSpec` (local_search: empty), `GroupScheme.IdentityComponent`, `Sym^g of schemes`. STRATEGY.md correctly marks all as gaps. No phantoms.
- **Effort honesty**: under-counted — A.2.a's `~1200–2000` LOC is light for "build Stacks 052H from generic flatness + noetherian induction + Quot-subscheme structure"; ~2000–3500 LOC is more realistic. A.2.b's `~1500–2500` LOC stuffs both the Grassmannian sub-build (Plücker + projective embedding + scheme functor-of-points, ~600–1000 LOC alone) AND the Quot scheme with its flat-locus open subscheme; ~3000–5000 LOC is more realistic. A.4.a is already flagged "dominant LOC under-count risk" so partial honesty there.
- **Parallelism under-exploited**: yes — strategy CLAIMS A.1.a, A.2.a, RR.1, A.4.b as "parallel-startable prover lanes", but every row except `gmScalingP1` and the gated rows reports `~0/it` realised velocity. Either lanes are not actually firing, or LOC velocity is not being tracked. Either way, the parallelism claim is unfalsified.
- **Verdict**: CHALLENGE

### Route: C — Genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PARTIAL — the genus-0 ⟹ `≅ ℙ¹` step (required to feed `ℙ¹→A constant` into a `C→A constant` conclusion) works only over `k̄`; the protected `IsAlbanese C P J` quantifies over `P : 𝟙_ ⟶ C` over `k`. Descent from `k̄` to `k` for a morphism-equality is required and remains "direction unconfirmed".
- **Mathematical soundness**: PASS — Rigidity Lemma + Cor 1.5 + Cor 1.2 + 𝔾_m-scaling shortcut + density of 𝔾_m in ℙ¹ + `ext_of_isDominant` is a clean char-general chain. The "no cube, no Thm 3.2, no Auslander–Buchsbaum, no diff/Frob" perimeter is genuine.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the RR.1/2/3/4 split is the correct decomposition.
- **Effort honesty**: reasonable — RR sub-phases at 300–600 LOC each look right for a from-scratch RR build.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND (with the descent direction flagged in `## Open strategic questions` — see Must-fix below for the recommendation to lock it in).

## Format compliance

- **Size**: 92 lines / 13561 bytes — over budget (~12 KB ceiling exceeded by ~13%).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — extensive `iter-NNN` references throughout. Verbatim examples: "band widened iter-174 per strategy-critic", "chapter LANDED (iter-174); Route-ii (Sym^g) committed per iter-174 a4d-albanese writer", "Per the iter-174 `blueprint-writer a4d-albanese` finding", "iter-175 plan-phase will re-issue the A.4.d writer directive", "EXCISED iter-163". These belong in `iter/iter-NNN/plan.md`, not in the strategy document.
- **Accumulation detected**: yes — the iter-tagged history accumulates inside the Phase rows and Open-questions entries; rejected alternatives carry iter-decision tags rather than living in iter sidecars.
- **Table discipline**: PARTIAL — the table is present with correct columns and the LOC cell carries both figures, but several `Status` cells are multi-sentence prose ("3 named scaffold sorries remain; `mvPolyToHomogeneousLocalizationAway_surjective` axiom-clean; chart-bridge analogist returned 30-LOC recipe"). Cells should be one short line.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: sub-phase decomposition of A.2.a (flattening stratification)

- **Required by goal**: yes — Route A is mandatory for the positive-genus object, and A.2.a is in its hard dependency chain (A.2.b ⊳ A.2.a, A.2.c ⊳ A.2.b, A.3 ⊳ A.2.c, witness object ⊳ A.3).
- **Current plan for building it**: "chapter LANDED iter-174" — the blueprint chapter exists, but the Phase row treats A.2.a as a single 8–14 iter unit with no internal milestones. Compare A.4 which is split into a/b/c/d.
- **Timeline**: vague — 8–14 iters with `~0/it` realised velocity and no sub-phase milestones means "I'll work on it later".
- **Verdict**: CHALLENGE — decompose A.2.a into ≥3 named sub-phases (e.g. generic flatness; noetherian induction over coherent strata; stratum-glueing & functoriality) with per-sub-phase iter bands.

### Deferred: sub-phase decomposition of A.2.b (Quot + Grassmannian)

- **Required by goal**: yes — same chain as A.2.a.
- **Current plan for building it**: chapter LANDED, single 10–17 iter monolithic phase.
- **Timeline**: vague.
- **Verdict**: CHALLENGE — split into at least (i) Grassmannian as a scheme (Plücker, functor of points), (ii) flat-locus open subscheme, (iii) Quot representability assembly. Each independently estimable.

### Deferred: `Sym^g C` of schemes (A.4.d Route-ii prerequisite)

- **Required by goal**: yes — Route-(ii) for A.4.d explicitly uses `Sym^g C ⇢ J` per Milne Prop 6.1; the alternative Route-(i) (autoduality via cube) was EXCISED so there is no fallback.
- **Current plan for building it**: "LOC budget absorbed into A.4.d row" — i.e. no separately tracked sub-build, no chapter, no decomposition.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — split `Sym^g C` into its own phase row (quotient by `S_g` on `C^g`; smoothness/properness of the quotient; comparison with `Pic^g`). At ~300–600 LOC realistically. Burying it inside A.4.d (~500–900 LOC for Albanese-UP wiring + Sym^g + verbatim Prop 6.1) hides the true scope.

## Alternative routes (suggested)

### Alternative: short-term axiomatisation of the deepest Route-A gaps

- **What it looks like**: temporarily admit `axiom`s for `flattening stratification` (052H), `Grassmannian` representability, `Quot` representability, and `FGA Pic_{C/k}` representability, with explicit `-- TODO: replace by Mathlib upstream` documentation. The downstream chain (`Pic⁰`, identity-component subscheme, Albanese UP) is then built on top of these axiomatised inputs. End-state cleanup pass replaces each axiom with the real construction (or upstreams to Mathlib).
- **Why it might be cheaper or sounder**: it collapses the critical-path iter count from ~80–130 to ~20–30 for a *working* (axiomatised) build; gives the project an early end-to-end sanity check that the dependency graph closes; surfaces incompatibilities in API choices before 2000+ LOC have been written against them; lets the genus-0 arm and the upper-layer Albanese assembly run in parallel against placeholder axioms.
- **What the current strategy may have rejected**: the strategy's stated end-state ("zero inline sorry, kernel-only axioms") rules out custom axioms *at end-state*, so this alternative would have to be staged: axiomatise-now, replace-later. The strategy is silent on whether this trade is acceptable.
- **Severity of the omission**: major — for a project carrying ~80–130 critical-path iters of foundational Mathlib build-out, the "axiomatise then cleanup" option deserves explicit consideration in `## Open strategic questions`, even if ultimately rejected.

### Alternative: lock the `k̄→k` descent direction before either arm is finished

- **What it looks like**: the current strategy lists "`k̄→k` descent is route-dependent" as an Open Question. Either commit early to (i) prove `Alb(C) = Spec k` directly over `k` for genus 0 by checking the universal property at the structural morphism `C → Spec k` (no `k̄` excursion needed — note that `IsAlbanese C P J` is over `Over (Spec k)`, and a `J = Spec k`-pointed factorisation only needs the constant-morphism fact on the geometric fibre, with the equality of the two morphisms `C → A` reduced via faithfully-flat descent of equalities), or (ii) commit to faithfully-flat descent of morphism equality along `Spec k̄ → Spec k`. Both have Mathlib support today; deferring the choice fragments work.
- **Why it might be cheaper or sounder**: locking it in lets the genus-0 prover lane write the descent step once instead of building two variants of `genusZeroWitness.key`.
- **What the current strategy may have rejected**: nothing visible — it appears genuinely unresolved.
- **Severity of the omission**: minor — flagged in Open Questions but not yet acted on.

## Sunk-cost flags

- `(autoduality bypass FAILS (cube excised iter-163))` — borderline sunk-cost: the parenthetical reads as "we excised cube earlier, so this route is closed". Reframe on merits: state instead that "autoduality requires the theorem of the cube, which is not in Mathlib and is at least as hard as Route A itself; we therefore prefer the direct Milne route". Why this is sunk-cost: the rejection is justified by a prior decision rather than by the route's own cost.

## Prerequisite verification

- `Grassmannian` (scheme): MISSING in Mathlib
- `Stacks 052H flattening stratification`: MISSING in Mathlib
- `relativeSpec`: MISSING in Mathlib (local_search empty; leansearch returns unrelated `Spec`/`AffineScheme.Spec`)
- `GroupScheme.IdentityComponent`: MISSING in Mathlib (per strategy claim; not contradicted by search)
- `Sym^g` of schemes: MISSING in Mathlib (only `Sym` for types and `SymmetricPower` for modules — strategy correctly states this)
- `Auslander–Buchsbaum` formula at the required form: MISSING (only depth + regular-local-ring fragments present)

## Must-fix-this-iter

- Route A: CHALLENGE — decompose A.2.a (flattening), A.2.b (Quot + Grassmannian), and A.4.d's Sym^g sub-build into named sub-phases with per-sub-phase iter bands. Mega-phases at 8–20 iters with no internal milestones are deferred-by-inaction.
- Route A: CHALLENGE — LOC bands on A.2.a and A.2.b are under-counted. Widen A.2.a to ~2000–3500 LOC and A.2.b to ~3000–5000 LOC, or explain the saving.
- Route A: CHALLENGE — most active lanes (A.1.a, A.2.a, RR.1, A.4.b) report `~0/it` realised velocity, contradicting the parallel-startable claim. Either start measuring velocity per-iter or down-grade those rows from "active" to "scheduled".
- Alternative: major omission — Open Questions must record the axiomatise-then-replace option (accepted or rejected, with rationale).
- Alternative: minor omission — Open Questions' `k̄→k` descent entry should be promoted to a decision this iter, not deferred.
- Format: DRIFTED — strip every `iter-NNN` reference from Phase Status cells and from Open Questions entries (move to `iter/iter-175/plan.md`); trim the file under the 12 KB ceiling; compress multi-sentence Status cells to one short line each.

## Overall verdict

The strategy's overall route choice is sound: Route A for positive genus is genuinely forced (Sym^g, autoduality, transcendental routes all blocked), and Route C's 𝔾_m-scaling shortcut for genus-0 is mathematically clean and char-general. The verdict is CHALLENGE rather than SOUND for three reasons. First, the strategy defers sub-phase decomposition of A.2.a (flattening stratification), A.2.b (Quot + Grassmannian), and A.4.d's Sym^g sub-build, which are all required by the stated goal — A.2.a/b/d are on Route A's mandatory critical path and no route in the strategy builds them with a concrete sub-phase timeline. Second, the strategy claims parallel-startable prover lanes but reports `~0/it` realised velocity on those same rows, so the parallelism is asserted rather than measured. Third, the format has drifted: 13.5 KB against a 12 KB ceiling, pervasive `iter-NNN` narrative inside Phase rows and Open Questions entries, and multi-sentence Status cells. None of these is a REJECT-level failure — the strategy's mathematical content is sound and the routes are correctly chosen — but the planner must restructure A.2.a/b and Sym^g into named sub-phases, widen the LOC bands on A.2.a/b, strip the iter-narrative, and record the axiomatise-then-replace alternative in Open Questions this iter.
