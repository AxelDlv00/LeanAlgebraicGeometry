# Strategy Critic Report

## Slug
clean205

## Iteration
205

## Routes audited

### Route: Main — `J := Pic⁰_{C/k} := PicScheme.degComp C 0`

- **Goal-alignment**: PASS — Pic⁰ is base-point-independent, so it is the right uniform witness; the Albanese UP (Milne Prop 6.1/6.4) is the correct target for `isAlbaneseFor`.
- **Mathematical soundness**: PARTIAL — the architecture is correct, but the *choice* of `degComp` (Hilbert-poly/degree decomposition) over the identity-component construction is precisely what makes the whole critical path RR-dependent. See Alternative "identity-component Pic⁰". The decomposition of `Pic` into open-closed pieces by Hilbert polynomial is RR-free (locally-constant Hilbert poly via flattening stratification); but *naming* the degree-0 piece and tying it to "degree" pulls in Riemann–Roch (`χ(L) = deg L + 1 − g`). The pivot rationale lives in `analogies/pic0-ker-deg-pivot.md`, which I have not read — but a fresh reader cannot see why the more elementary, RR-free construction was excised in favor of the one that now blocks everything.
- **Sunk-cost reasoning detected**: no (the pivot is justified by a cited analogy, not by prior investment).
- **Infrastructure-deferral detected**: yes — the degComp choice routes through RR (Route C), which is paused. See the deferral finding.
- **Effort honesty**: under-counted — see the table-row analysis under Route A.2.c / TS.
- **Verdict**: CHALLENGE — justify (in STRATEGY.md or plan.md) why the RR-free identity-component construction was excised in favor of RR-dependent degComp, given that degComp is the proximate cause of the global RR block.

### Route: A.2.c — FGA `Pic_{C/k}` representability ("RR-substrate-blocked")

- **Goal-alignment**: PASS — representability is genuinely required; `J` must be an actual object.
- **Mathematical soundness**: PARTIAL — the claim "**both** the Quot route and the Sym^d route need Riemann–Roch" conflates two distinct steps. Grothendieck/Kleiman representability of the Picard *functor* as a scheme (Nitsure §5 Quot existence + flattening stratification + projective embedding) is classically **RR-free** — RR is not an input to Quot-scheme existence. RR enters only at (i) the degree/Hilbert-polynomial *identification* of components and (ii) dimension/divisor-map arguments downstream. So "A.2.c is RR-blocked" is over-stated: bare representability is reachable without RR; only the `degComp`-flavored extraction of `Pic⁰` is RR-coupled.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — RR (Route C) is deferred; see finding.
- **Phantom prerequisites**: "scheme Hilbert poly absent in Mathlib" (Risks cell) is plausible and consistent with a real gap; not phantom, but unbudgeted.
- **Effort honesty**: under-counted — row reads `~600–800 LOC · 0/it`, `Iters left ~12–16`. At the only realized velocity in the whole project (~2 LOC/it), 600 LOC is ~300 iters, not 12–16. The 12–16 figure is an aspiration with zero supporting velocity.
- **Verdict**: CHALLENGE — separate "representability of `Pic` (RR-free)" from "extraction of `Pic⁰` via degComp (RR-coupled)" in STRATEGY.md. If bare representability + isolating the component of the trivial class is RR-free, a substantial protected-adjacent milestone is reachable *under the current Route-C pause*, which the strategy currently treats as wholly blocked.

### Route: Lane TS monoidal cone (`Scheme.Modules.tensorObj` substrate)

- **Goal-alignment**: PASS — monoidal `Scheme.Modules` is a genuine prerequisite for `LineBundle.OnProduct` / RelPic.
- **Mathematical soundness**: PASS — and the named recipe is real. `CategoryTheory.Localization.Monoidal.toMonoidalCategory`, the instance `instMonoidalCategoryLocalizedMonoidal`, and the `MorphismProperty.IsMonoidal` typeclass all exist in Mathlib (verified). The claim "given a `W.IsMonoidal` instance + the existing `IsLocalization` instance, `Localization.Monoidal` yields the monoidal structure" is accurate; this is a well-scoped `mathlib-build` target, not a PR wait.
- **Effort honesty**: under-counted — the row reads `~120–250 LOC · ~2/it`, `Iters left ~2–4`. At 2 LOC/it, 120–250 LOC is **60–125 iters**, not 2–4. This is the exact internal inconsistency (`remaining ÷ velocity ≫ iters-left`) the audit is meant to flag. Either the velocity is about to jump 20× (no evidence) or "2–4 iters" is fiction.
- **Verdict**: SOUND (math/prerequisites) — but the iters-left estimate is dishonest; fix the row.

### Route: Route C — Riemann–Roch chain (PAUSED)

- **Goal-alignment**: FAIL as *currently dispositioned* — RR is required for the genus ≥ 1 main path (via degComp / divisor-map genus formula), yet it is paused with **no project-side timeline**.
- **Mathematical soundness**: PASS — the RR chain itself is sound mathematics; the problem is disposition, not math.
- **Sunk-cost reasoning detected**: borderline — "stay imported (no excision)" keeps ~9 sorry-bearing files in the build "modulo option (c)"; this is a "don't discard what we built" instinct rather than a merit argument, though excision would also be wasteful.
- **Infrastructure-deferral detected**: yes — this is the central finding (below).
- **Verdict**: CHALLENGE — the route's math is fine; the strategy must stop treating a goal-required construction as indefinitely pausable without surfacing that the goal is unreachable until it resumes.

### Route: Genus-0 arm — candidates (a) Pic⁰-via-AV-wrap and (b) `J := Spec k` via Mumford rigidity

- **Goal-alignment**: PASS — for genus 0, `C_{k̄} ≅ ℙ¹`, `Pic⁰` trivial, Albanese = `Spec k`; the universal property reduces to `Mor(ℙ¹, A) = const` (Milne Prop 3.10) + descent. Sound, and char-general (no Serre duality needed per Milne 3.2/3.10).
- **Mathematical soundness**: PASS — candidate (b) is the cheaper of the two and is correctly identified. The open question "may need only `AbelianVarietyRigidity`, not `RigidityKbar`" is well-posed: if the target is the *terminal* `Spec k`, the descended statement is a property (map is constant), so the descent is trivial and full k̄-rigidity for an arbitrary AV target may be unnecessary. The audit-against-Milne-§1 instruction is the right next step.
- **Verdict**: SOUND — but see the must-fix note that this arm closes **only** the genus-0 case; it does not advance the dominant genus ≥ 1 obligation, which remains RR-blocked regardless of amendment (a).

### Route: Option-(c) operative end-state (Goal section)

- **Goal-alignment**: FAIL — the strategy states verbatim that "the kernel-triple `#print axioms` contract cannot be delivered unconditionally." The stated goal is the *unconditional* protected theorems. Option (c) — "protected `#print axioms` verifies modulo the explicit residual sorries … with consumers carrying the RR-substrate dependency in commentary, not in the type signature" — is a goal-weakening (sorry-conditioned closure) dressed as an end-state.
- **Sunk-cost / momentum**: yes — see sunk-cost flags ("24-consecutive-zero-axiom streak"; deferring TO_USER escalation until "all priority-1/2 roots close").
- **Verdict**: CHALLENGE — option (c) is a holding pattern, not an end-state. The only resolution that reaches the stated goal is (b) full Route C. The strategy should say this plainly and escalate the USER decision **now**, not after more substrate iters.

## Format compliance

- **Size**: 146 lines / ~8 KB — within budget (≤250 lines / ≤12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. (The `## Reference index`, `## Blueprint chapters`, `## Focus questions` blocks were appended by the dispatcher's directive, not present in the file.)
- **Per-iter narrative detected**: yes — `"reduced to one gap (iter-204)"`, `"Lane COE STUCK/PAUSED pending USER (iter-204)"`, `"A.4.b (CLOSED iter-202)"`, and three `"USER 2026-05-28"` date-stamps. Iter numbers and event date-stamps are per-iter history that belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: yes (mild) — the Route C block enumerates 9 paused files "stay imported (no excision)"; that inventory is iter-sidecar material.
- **Table discipline**: PASS — six columns, mostly one line per cell.
- **Format verdict**: DRIFTED — scrub the `iter-NNN` references and absolute date-stamps in-place; move the paused-file inventory to a sidecar.

## Infrastructure-deferral findings

### Deferred: Riemann–Roch (Route C chain)

- **Required by goal**: yes — the genus ≥ 1 case (the dominant part of the goal) runs through A.2.c `degComp` and the A.4.d divisor-map genus formula, both of which the strategy itself routes through RR.
- **Current plan for building it**: none with a project-side timeline — "PAUSED (USER 2026-05-28)", "Not budgeted; documented in the chapter files for future re-engagement."
- **Timeline**: absent.
- **Verdict**: REJECT — under the current pause the stated goal is provably unreachable in the genus ≥ 1 case. The strategy defers Riemann–Roch, which is required for the stated goal. Disposition note: the USER pause is a real external gate the planner cannot override — but the correct response is to surface the goal-unreachability to the USER *immediately* (the loop currently defers that escalation until "all priority-1/2 roots close"), and to stop presenting option (c) as a goal-achieving end-state. Also re-examine whether the RR coupling is genuinely necessary for *representability* (see A.2.c CHALLENGE) — part of this "block" may be self-inflicted by the degComp pivot.

## Alternative routes (suggested)

### Alternative: identity-component `Pic⁰` (RR-free)

- **What it looks like**: construct `Pic⁰` as the connected component of the identity in the group scheme `Pic_{C/k}` (open-closed for group schemes locally of finite type over a field, Stacks). This is purely topological/group-theoretic once representability is in hand — no degree map, no `χ(L) = deg + 1 − g`.
- **Why it might be cheaper or sounder**: it removes Riemann–Roch from the critical path entirely. The genus ≥ 1 obligation would then depend on representability (RR-free, see A.2.c) + identity-component (RR-free), unblocking the whole project from the Route-C pause.
- **What the current strategy may have rejected**: the strategy says the identity-component construction was "EXCISED from the critical path (rationale: `analogies/pic0-ker-deg-pivot.md`)". A fresh reader cannot evaluate that rationale, but the consequence — trading an RR-free construction for one that blocks the entire goal on a paused RR chain — demands an explicit re-justification.
- **Severity of the omission**: critical.

### Alternative: bare Pic representability via Quot, then isolate the trivial-class component

- **What it looks like**: prove `Pic_{C/k}` representable via Grothendieck/Nitsure Quot machinery (RR-free), then take the open-closed component containing `[O_C]` as `Pic⁰` (RR-free, via locally-constant Hilbert polynomial / flattening stratification — no degree identification needed).
- **Why it might be cheaper or sounder**: reaches a representable `Pic⁰` object without Riemann–Roch, i.e. *under the current Route-C pause*. It directly attacks the strategy's claim that A.2.c is wholly RR-blocked.
- **What the current strategy may have rejected**: unclear — the strategy asserts both representability routes need RR but does not separate representability from degree-identification.
- **Severity of the omission**: major.

## Sunk-cost flags

- `Currently 0 project axioms (24-consecutive-zero-axiom streak).` — Why this is sunk-cost/momentum: the zero-axiom count is hollow while every protected decl still closes only modulo `sorryAx`, and a "streak" is a momentum metric, not a goal metric. Recommendation: report distance-to-goal (which protected decls are sorry-free under what hypotheses), not a streak.
- `Loop runs Route A substrate continuously under (c); when all priority-1/2 roots close, a TO_USER re-escalation surfaces the cone audit.` — Why this is sunk-cost/momentum: it keeps the loop busy on the sole productive lane and postpones the one decision (USER resolution of the RR pause) that actually gates the goal. Recommendation: escalate the goal-unreachability to the USER now; substrate iters do not change the blocking set.

## Prerequisite verification

- `CategoryTheory.Localization.Monoidal.toMonoidalCategory`: VERIFIED (Mathlib.CategoryTheory.Localization.Monoidal.Basic).
- `CategoryTheory.Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal`: VERIFIED — yields `MonoidalCategory` on the localized category from `[W.IsMonoidal]` + `[L.IsLocalization W]`.
- `CategoryTheory.MorphismProperty.IsMonoidal`: VERIFIED (appears as the `[W.IsMonoidal]` hypothesis of the above instances).

## Must-fix-this-iter

- Infrastructure-deferral REJECT — **the strategy defers Riemann–Roch, which is required for the stated goal** (genus ≥ 1). Planner must (a) escalate the goal-unreachability to the USER this iter rather than after "priority-1/2 roots close", and (b) stop framing option (c) as an end-state.
- Route A.2.c: CHALLENGE — separate "Pic representability (RR-free, Grothendieck/Quot)" from "Pic⁰ extraction via degComp (RR-coupled)". The "both routes need RR" claim is over-stated and may be hiding an RR-free path to a protected-adjacent milestone reachable under the current pause.
- Route Main / Alternative "identity-component Pic⁰": critical omission — justify excising the RR-free identity-component construction in favor of degComp, the proximate cause of the global RR block, or re-engage it.
- Route TS / A.1.c.SubT: CHALLENGE (effort) — `120–250 LOC · ~2/it` is inconsistent with `Iters left ~2–4` (implies ~60–125 iters). Fix the estimate; the headline "Total Route A ~140–230 iters / ~4400–8200 LOC" implies ~30 LOC/it against a realized ~2 LOC/it on the only active lane — a ~15× optimism gap to reconcile.
- Parallelism under-exploited — A.3.0 (scheme-level tangent space, ~200–400 LOC) is an **ungated root** in the dependency graph yet sits at `0/it` while A.1.c.SubT is called the "sole productive lane". The self-contained lemma "connected étale group scheme over a field, dim 0 = `Spec k`" is likewise independent and idle. Open a parallel lane or record why these ungated roots are not being worked.
- Format: DRIFTED — remove `iter-204`/`iter-202` references and the three `USER 2026-05-28` date-stamps; relocate the paused-file inventory to a sidecar.

## Overall verdict

The route *architecture* is mathematically sound — `J := Pic⁰` as a base-point-independent witness with the Milne Albanese UP, and `J := Spec k` for genus 0, are the correct objects, and the one actively-progressing lane (TS monoidal) rests on Mathlib API I verified exists. But the strategy has a structural problem it is dressing as a holding pattern: **the strategy defers Riemann–Roch, which is required for the stated goal** in the genus ≥ 1 case, and adopts an "option (c)" end-state that it admits "cannot be delivered unconditionally." That is a goal weakening, and the loop's continuous substrate work — while forward-compatible — cannot reduce the blocking set, which is gated entirely on a USER decision the strategy postpones. Two specific challenges may partially dissolve the block: the "A.2.c needs RR" claim conflates representability (classically RR-free) with degree-identification, and the excised RR-free identity-component construction of `Pic⁰` was traded for the RR-dependent degComp that now blocks everything — both deserve explicit re-justification this iter. Effort estimates are internally inconsistent (60–125 implied iters labelled "2–4"; ~15× headline optimism against realized velocity), an ungated root (A.3.0) sits idle behind the "sole productive lane," and the document has drifted from the canonical skeleton via iter-number and date-stamp narrative. Verdict: CHALLENGE — proceed only after surfacing the RR goal-block to the USER and addressing the representability/identity-component challenges.
