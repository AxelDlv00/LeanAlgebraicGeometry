# Strategy Critic Report

## Slug
ts246

## Iteration
246

## Routes audited

### Route: A.1.c.sub — loc-triv-restricted comparison iso (iter-245 pivot)

- **Goal-alignment**: PASS — the comparison iso is consumed only by RPF `map_add`, which acts on iso-classes of line bundles; general modules never reach it.
- **Mathematical soundness**: PASS — the reduction is sound and, if anything, *under*-claimed. The inverse-image functor `f^*` on `O`-modules is **strong** monoidal (`f^* = f⁻¹(−) ⊗_{f⁻¹O} O`), so δ is an iso on *all* objects, not merely loc-triv ones. Proving it only on the loc-triv pairs via `isIso_of_isIso_restrict` over a common trivialising cover (reducing each chart to the unit pair, where `pullbackUnitIso` is unconditional via the VERIFIED `final_of_representablyFlat`) is a strictly easier sufficient sub-case.
- **Infrastructure-deferral detected**: no — this is a *genuine* reduction, not a renamed gap. Hardest prereq of the abandoned route = filtered-colimit/⊗ interchange in the `Lan` colimit model. Hardest prereq of the new route = the bounded D3' δ-vs-base-change-square coherence, which already has a proven axiom-clean unit analog (`pullbackObjUnitToUnit_comp`). Different constructions; the new one is strictly smaller. Passes the same-prerequisite test.
- **Verdict**: SOUND

### Route: A.1.c.fun — RelPic functor on IsLocallyTrivial

- **Goal-alignment**: PASS
- **Mathematical soundness**: PARTIAL — see the carrier-closure subtlety below. The `addCommGroup` on loc-triv iso-classes (RelPicFunctor.lean:269) needs the *inverse* element to live in the loc-triv carrier. `exists_tensorObj_inverse` is cited for the inverse, but as stated it only yields an *invertible* witness `N` with `M⊗N≅𝒪`. For group closure you additionally need that witness to be loc-triv. This is true and *locally easy* (on a cover where `M≅𝒪`, `N≅𝒪` too), but it is NOT the same as the bare `exists_tensorObj_inverse` Prop. The strategy should confirm `exists_tensorObj_inverse` delivers a **loc-triv** witness, not a bare invertible one.
- **Infrastructure-deferral detected**: no
- **Phantom prerequisites**: none confirmed missing (`final_of_representablyFlat` VERIFIED; `IsLocalAtTarget` iso-on-cover machinery present).
- **Effort honesty**: under-counted — `~350–600 · 0/it` with `Iters left ~7–12` is the canonical "0/it realized but multi-iter-left" pattern. Mostly excused by the A.1.c.sub gate, but it cannot start closing until the substrate lands, so the parallelism claim ("PARALLEL") is partly aspirational.
- **Verdict**: CHALLENGE — pin down that the inverse witness is loc-triv (group closure), and reconcile the carrier inconsistency below.

### Route: A.2.c — representability + Quot embedding bridge

- **Goal-alignment**: PASS — representability of `Pic⁰` as a scheme is genuinely required by the goal (`J` must be a scheme satisfying the AV/Albanese UP).
- **Mathematical soundness**: PASS in outline.
- **Infrastructure-deferral detected**: yes (see findings) — the `IsInvertible ⟹ locally-free-rank-1` bridge is double-estimated and is on the critical path.
- **Effort honesty**: see A.2.c-engine. The `~600–800 · 0/it`/`12–16 iters` row is scaffolding-only; the real cost is the engine.
- **Verdict**: CHALLENGE — resolve the bridge-cost contradiction (below).

### Route: A.2.c-engine — Quot/Cartier RR-free engine

- **Goal-alignment**: PASS — required given the permanent RR pause.
- **Mathematical soundness**: PASS — standard FGA spine (Nitsure §5 + Kleiman §4).
- **Infrastructure-deferral detected**: no (it is named, scoped, and de-gated with an active lane). But `R^i f_*` (i≥1) is the true bottleneck and is itself a major Mathlib-absent construction flagged only as an open question ("Mathlib PR vs project Čech build ~800–1200 vs typed-sorry pin") with the decision deferred to "when the engine de-gates." That single sub-construction could dominate the whole engine cost.
- **Effort honesty**: optimistic — `~30–60 iters · ~3400–5500 LOC` is internally consistent at the claimed focused velocity (≈92/it), but the velocity assumption is itself the risk: `R^i f_*`, Relative Proj, CM-regularity, flattening, and Quot representability are each multi-hundred-LOC Mathlib-absent builds. The lower bound (30 iters) looks aspirational.
- **Verdict**: SOUND (the route is the right RR-free spine), with an honesty caveat on velocity and on `R^i f_*` being an undecided sub-fork.

### Route: A.4 — Albanese UP (Route 2 preferred / Route 1 fallback)

- **Goal-alignment**: PASS via either route — `isAlbaneseFor` is reachable on Route 1 unconditionally.
- **Mathematical soundness**: PARTIAL — Route 2's landing step (autoduality `J^∨≅J`) is classically the theta-divisor principal polarization, which rests on Riemann–Roch. The strategy itself flags it UNVERIFIED for RR-freeness. Under a *permanent* RR pause, an RR-dependent step is dead-on-arrival, yet it is labeled the **preferred** route while every in-tree Albanese file (Thm32RationalMapExtension, CodimOneExtension, AbelianVarietyRigidity) backs Route 1.
- **Infrastructure-deferral detected**: no (the fallback is named and substrated).
- **Effort honesty**: reasonable for Route 1; Route 2 carries zero committed LOC so its estimate is moot.
- **Verdict**: CHALLENGE — the "preferred" labeling contradicts the permanent RR pause and the in-tree evidence. Either demote Route 2 to contingent and name Route 1 primary, or run the *self-described "cheap literature check"* (Milne §III.6) NOW rather than deferring it ~50 iters — deferring a cheap check that decides the primary route is procrastination, not sequencing.

## Format compliance

- **Size**: 165 lines / ~12 KB — at/over the byte budget; the oversized table cells are the main driver.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, exactly in canonical order.
- **Per-iter narrative detected**: yes — egregious. Verbatim: "PIVOTED iter-245 off the general strong-monoidal build", "the iter-244 're-base OnProduct onto IsInvertible' is RETRACTED", "DECIDED iter-245", "Backs `Picard_RelativeSpec.tex` (iter-171)"-style stamps throughout. Iter numbers belong in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: yes — (a) the DONE phase A.1.c.SubT still occupies a full Routes paragraph and a Gaps bullet; (b) "Dead-ends (do NOT re-attempt)", "NEGATIVE (rejected): ...", and "ABANDONED (do NOT revive): ..." lists are a Lessons-Learned / Considered-Alternatives appendix smuggled inline — that history belongs in iter sidecars.
- **Table discipline**: FAIL — "one short line per cell" is violated massively; the A.1.c.sub Status and A.1.c.fun Status cells are multi-sentence paragraphs. Several LOC cells read `· 0/it` against multi-iter `Iters left` (A.1.c.fun, A.2.c, A.3, A.4, genusZero).
- **Appendix sections**: the inline dead-end/negative/abandoned lists function as a hidden "Considered alternatives" appendix.
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: IsInvertible ⟹ IsLocallyTrivial (= locally-free-rank-1) forward bridge

- **Required by goal**: yes — the Quot embedding at A.2.c needs it, and representability is required by the goal.
- **Current plan for building it**: **internally contradictory.** A.1.c.sub and the Mathlib-gaps section call it "genuinely Mathlib-scale" and "off-path" (citing "no finite-presentation spreading-out for SheafOfModules"). A.2.c and the Open-Questions section call the *same* implication "the EASY direction, proved directly from a tensor-inverse ... ~1–2 iters." `IsLocallyTrivial` and "locally-free-rank-1" are the same notion, so these cannot both be true.
- **Timeline**: contradictory — "~1–2 iters, scheduled at A.2.c entry" vs "Mathlib-scale".
- **Verdict**: CHALLENGE — resolve the contradiction. If the bridge is genuinely Mathlib-scale, A.2.c is under-counted by a major construction and the `~1–2 iters` estimate is dishonest. If it is actually easy, then the A.1.c.sub claim that it is "Mathlib-scale" — the stated justification for abandoning the general strong-monoidal build — is overstated, and that pivot's framing should be corrected (the pivot is still right on the "only line bundles consumed" ground, but not on the "forward bridge is Mathlib-scale" ground).

## Sunk-cost flags

- `the iter-244 "re-base OnProduct onto IsInvertible" is RETRACTED — ... its pullback machinery ... is built+axiom-clean` — borderline: keeping the already-built `IsLocallyTrivial`-carried `OnProduct` because it "is built+axiom-clean" rather than because loc-triv is the right carrier is a mild sunk-cost framing. The decision is likely correct on merits (loc-triv is the genuine consumer carrier), but the justification leans on "already built." Recommendation: restate the carrier choice on merits (RPF intrinsically classifies loc-triv line bundles), not on prior build effort.

## Prerequisite verification

- `CategoryTheory.final_of_representablyFlat`: VERIFIED (`Mathlib.CategoryTheory.Functor.Flat`) — backs the unconditional `pullbackUnitIso`.
- `IsLocalAtTarget` for `isomorphisms` (iso-on-a-cover ⟹ iso): VERIFIED (present in `Mathlib.AlgebraicGeometry.Gluing` / `MorphismProperty`) — backs the `isIso_of_isIso_restrict` cover reduction.

## Must-fix-this-iter

- Route A.2.c / infrastructure-deferral CHALLENGE: the `IsInvertible ⟹ locally-free-rank-1` bridge is required by the goal and is double-estimated as both "Mathlib-scale/off-path" and "~1–2 iters/easy". Pick one, with a concrete iter estimate; if Mathlib-scale, re-cost A.2.c.
- Route A.1.c.fun CHALLENGE: confirm the group inverse on loc-triv iso-classes closes in the carrier — i.e. `exists_tensorObj_inverse` (or a thin lemma over it) yields a **loc-triv** inverse witness, not a bare invertible one.
- Route A.4 CHALLENGE: stop labeling the RR-dependent, UNVERIFIED autoduality Route 2 as "preferred" under a permanent RR pause; either make Route 1 (already substrated in-tree) primary or run the self-described cheap Milne §III.6 check now.
- Format: NON-COMPLIANT — strip all iter-NNN narrative, collapse the multi-sentence table cells to one line each (move detail to the iter sidecar), and delete the DONE A.1.c.SubT paragraph and the inline "Dead-ends / NEGATIVE / ABANDONED" lists into `iter/iter-246/plan.md`. Restructure in-place this iter.

## Overall verdict

The mathematical spine is sound: `J := Pic⁰_{C/k}` via the FGA representability engine is the correct RR-free route given the permanent Route-C pause, and the iter-245 loc-triv pivot is a *genuine* reduction (the comparison iso is consumed only on line bundles, `f^*` is strong monoidal anyway, and the new hardest prerequisite is strictly smaller than the abandoned one — not a same-problem-one-layer-deeper avoidance). No downstream node in A.1.c.fun → A.2.c → A.3 → A.4 needs the comparison iso on general modules, so the abandoned general build stays dead. However, three issues must be addressed before proceeding: (1) the strategy defers `IsInvertible ⟹ locally-free-rank-1`, which is required for the goal (the Quot embedding), and double-estimates it as both Mathlib-scale and ~1–2 iters — this contradiction must be resolved because it directly controls whether A.2.c is under-counted; (2) the loc-triv group law's inverse-closure within the carrier is asserted but not pinned; and (3) under a *permanent* RR pause, preferring the RR-dependent, explicitly-UNVERIFIED autoduality Route 2 over the already-substrated RR-free Route 1 is incoherent and the cheap deciding literature check should be run now, not in ~50 iters. The named Route-1 fallback is sufficient insurance, so this is a CHALLENGE, not a REJECT. Separately, STRATEGY.md is format NON-COMPLIANT (pervasive iter-NNN narrative, multi-sentence table cells, accumulated DONE-phase and dead-end appendices) and must be restructured in-place this iter.
