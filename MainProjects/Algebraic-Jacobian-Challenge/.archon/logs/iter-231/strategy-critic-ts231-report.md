# Strategy Critic Report

## Slug
ts231

## Iteration
231

## Routes audited

### Route: A.1.c.SubT — ⊗-group law (the sole ungated lane)

- **Goal-alignment**: PASS — the by-hand `CommGroup` on locally-trivial iso-classes is the honest substrate for `J := Pic⁰_{C/k}`; the `CommRing.Pic`-non-reuse argument (varying `𝒪_X` ⇒ no coherent fixed-ring `MonoidalCategory`) is a genuine mathematical reason, not sunk cost.
- **Mathematical soundness**: PASS — the C-bridge re-scope is mathematically sound (see Q1 analysis below); the dual-restrict-iso is genuinely near-definitional at the presheaf level.
- **Sunk-cost reasoning detected**: no (self-disclosed) — the strategy honestly labels this "STUCK route" and `~0/it`, and (correctly) installs a hard outcome gate + a pre-committed escape rather than asserting healthy progress. That is the right response to a multi-iter-stuck lane, not denial.
- **Infrastructure-deferral detected**: no — the re-scope changes the *method* of proving `dual(M.restrict j) ≅ (dual M).restrict j`, and the FAIL fallback (route II, object-gluing off the dual) is a genuinely different construction that does NOT need that lemma at all. The hardest prerequisite *does* change across the pivot (see Q2 caveat on the residual A-engine gluing).
- **Phantom prerequisites**: none blocking. `TopCat.Sheaf.existsUnique_gluing` VERIFIED; `CategoryTheory.Equivalence.sheafCongr` VERIFIED. `Opens.overEquivalence` not surfaced in Mathlib by name, but it backs the already-CLOSED project decl `overSliceSheafEquiv`, so it is not a live dependency of this iter's work.
- **Effort honesty**: under-counted — `~150–300 LOC · ~0/it` velocity with "Iters left ~2–4" is internally inconsistent (0/it never clears 150–300 LOC). The estimate is salvaged only by re-defining the gate as "named bridge lands axiom-clean" rather than LOC/sorry burndown. Treat "2–4 iters" as optimistic.
- **Parallelism under-exploited**: no (forced) — A.1.c / A.2.c are gated by dependency on this substrate's `CommGroup`, so serialization here is real, not a planning miss. The file-split fallback to open parallel lanes is the correct mitigation.
- **Verdict**: SOUND

### Route: A.1.c — RelPic functor (held)
- **Verdict**: SOUND — honestly flagged as holding dishonest placeholders (`PicSharp := const PUnit`, `functorial := 0`) with a RE-ENGAGE note; gated by the substrate's group.

### Route: A.2.c — representability + Quot engine (held)
- **Goal-alignment**: PASS — representability is required by the goal and is planned (not deferred to upstream with no plan); the `R^i f_*` dependency carries a concrete project-side option (Čech build ~800–1200) alongside the Mathlib-PR option.
- **Effort honesty**: reasonable given scope — ~3400–5500 LOC for an RR-free Quot/Hilbert engine is a large but honestly-labeled build, correctly gated behind the current bottleneck.
- **Verdict**: SOUND

### Route: Albanese UP — Route 2
- **Mathematical soundness**: PARTIAL — rests on autoduality `J^∨≅J` whose RR-freeness is explicitly UNVERIFIED and classically RR-dependent (theta divisor). The strategy flags this as a top risk with a "second-verify before investment" gate, which is the correct posture; not actionable this iter since it is gated behind A.2.c.
- **Verdict**: SOUND (risk correctly quarantined)

### Route: Route C — Riemann–Roch (USER PAUSE)
- **Verdict**: SOUND — paused by USER; not autonomously reachable. The cost-asymmetry FYI (RR chain now numbered at ~2000–4000 LOC, "closer than ~5× cheaper") is honest and correctly does not drive an autonomous re-route into a locked lane.

## Directive question findings

**Q1 — Is the C-bridge re-scope sound, or the same route relabeled?** SOUND, genuine method change. The *target lemma* `dual(M.restrict j) ≅ (dual M).restrict j` is unchanged, but the *method* is. The falsified route tried to derive it from the heavyweight value-cat-fixed sheaf-site root `overSliceSheafEquiv`, which (per the iter-230 finding the strategy cites) cannot transport the varying-`𝒪(V)` module fibration. The re-scope abandons that root and proves the lemma pointwise: at the presheaf level `dual(M.restrict j)(W) = Hom_{𝒪(W)}(M(W),𝒪(W)) = (dual M)(W)` with identical restriction maps, because restriction along an open immersion is value-forgetting. This really is near-definitional and is the *opposite* of avoidance — a simplification. **Caveat:** the project's `dual` is sheafified and historically the residual was a slice-internal-hom-vs-sectionwise mismatch; the "near-definitional" optimism has been wrong before, so the bet that the project's `dual` is sectionwise-enough is unproven. The hard outcome gate (PASS = 80→79 or named bridge axiom-clean; FAIL → pivot off the dual) correctly bounds this to one iter.

**Q2 — Is the pre-committed fallback chain sound?** SOUND with one caveat. Pivoting the inverse OFF the dual via object-level gluing of the `g_{ij}⁻¹` cocycle (route II) is a standard, genuinely different construction of the inverse line bundle that does not touch internal-hom-restriction — a real escape, not a relabel. File-split is low-risk and enables parallelism. **Caveat the planner must not overlook:** route II removes the *C-bridge* (dual-restrict-iso) but still glues local data to a global sheaf + global trivialization, so it likely still needs the *A-engine* morphism-descent machinery (`homOfLocalCompat` / `existsUnique_gluing`). "Sidesteps internal-hom-restriction entirely" is true; "escapes the whole ⊗-inverse block" is not — one of the two bridges survives the pivot. That residual is a build-size problem, not phantom infra, so the fallback is still sound; just don't bank it as a clean break.

**Q3 — Is continuing the RR-free substrate the right sole-lane choice?** SOUND — it is the *only* ungated lane (the divisor/`Pic⁰` arm is locked by the permanent USER ROUTE C PAUSE and is not autonomously reachable). There is no choice to make; the only live risk is structural-doomedness of the substrate, which the gate + true escape (route II) correctly address. Disabling escalation per the USER autonomous directive is consistent and appropriate here.

## Format compliance

- **Size**: 135 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — material. Representative: the A.1.c.SubT table cell reads "`iter-230 falsified the slice-site root for C; analogist ts231ih confirms minimal target is near-definitional`"; Open questions: "`iter-230 empirically settled that the value-cat-fixed sheaf root...`" and "`Re-scope (analogist ts231ih)`" and "`(progress-critic ts231)`"; Phases note "`Per USER standing directive (2026-05-31, autonomous operation)`". Iter numbers, subagent slugs (`ts231ih`, `progress-critic ts231`), and dated directives are per-iter history that belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no — held/paused phases are legitimately live dependencies, not completed-and-lingering.
- **Table discipline**: PASS (structure) — six columns, both LOC figures present. Internal-consistency flag (not a discipline violation): the A.1.c.SubT row pairs `~0/it` with "Iters left ~2–4", arithmetically impossible on its face; honest only because the gate is redefined off LOC.
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Format: DRIFTED — strip the per-iter narrative (iter-NNN references, subagent slugs `ts231ih` / `progress-critic ts231`, the dated standing-directive note) from the A.1.c.SubT table cell and the Open strategic questions section; move that detail to `iter/iter-231/plan.md`. State the C-bridge re-scope and the autonomous posture in iter-agnostic terms.
- Route A.1.c.SubT: effort-honesty CHALLENGE — `~0/it` velocity against "2–4 iters left" and `~150–300` LOC is inconsistent. Either re-state the iter estimate honestly given self-disclosed zero burndown, or make explicit that the gate is binary (bridge-lands / pivot) and the LOC figure is the route-II fallback budget, not a burndown forecast.
- Route A.1.c.SubT (fallback): planner must record that route II removes the C-bridge but inherits the A-engine gluing engine, so the FAIL pivot is partial progress, not a whole-block escape — set expectations in the directive accordingly.

## Overall verdict

The strategy is substantively SOUND on all three questions the directive raises. The C-bridge re-scope is a genuine method change — proving `dual(M.restrict j) ≅ (dual M).restrict j` pointwise at the presheaf level instead of through the falsified value-cat-fixed sheaf-site root — and is a simplification, not the same route relabeled; it passes the infrastructure-deferral test because the FAIL fallback (route II, object-gluing off the dual) genuinely changes the hardest prerequisite. The autonomous posture and sole-lane choice are forced and correct given the permanent USER ROUTE C PAUSE. Two things the planner must address before committing the iter: (1) STRATEGY.md has DRIFTED — material per-iter narrative (iter-230, the `ts231ih` / `progress-critic ts231` slugs, the dated directive) must be moved to the iter sidecar and the document restated iter-agnostically; and (2) the effort line for the stuck substrate (`~0/it` vs "2–4 iters left") is internally inconsistent and should be re-stated honestly as a binary gate, with the directive making explicit that "pivot off the dual" removes only the C-bridge and still needs the A-engine gluing machinery.
