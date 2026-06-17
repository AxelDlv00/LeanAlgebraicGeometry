# Iter-216 plan-agent run

## Headline outcome

The "two pre-committed escalation gates missed → the planner must decide, and the decisive consult
reframes the whole stall" iter. The iter-215 FINAL gate (close `isLocallyInjective_whiskerLeft_of_W`
this iter or escalate iter-216) was NOT met. progress-critic ts216 = **STUCK** (6 iters flat at 81,
13+ helpers, 0 eliminations, PARTIAL×6, two gates missed) → mandatory USER escalation. But the
decision-critical **mathlib-analogist ts216** (api-alignment) reframed the 6-iter stall: the group
law on iso-classes consumes ONLY *existence* of the assoc/unit/braiding isos (Mathlib's `CommRing.Pic`
builds its `CommGroup` directly on `Module.Invertible` iso-classes; the pentagon is never invoked).
**So the entire ROUTE-(d) whiskering / `(J.W).IsMonoidal` / stalk(d.1) / d.2 apparatus — ~300 LOC
including the 6-iter open-sorry wall — is VESTIGIAL: the project was building the wrong thing.** The
sole genuine substrate linchpin is the `tensorObj` restriction-compatibility (+ a bounded associator
Hom-sheaf gluing). strategy-critic ts216 confirmed the math core but issued must-fixes that sharpened
the plan (see Decision). Strategy pivoted, blueprint rewritten (writers ts216/b/c → clean → fast-path
reviewer), USER escalation surfaced. Build GREEN entering; project sorry 81.

## What I processed (iter-215 outcomes)

- Merged iter-215 prover result (`restrictScalarsRingIsoTensorEquiv`, the H2 "bottom gap" of the
  linchpin, closed axiom-clean) → `task_done.md`; cleared the result file. No top-level sorry closed.
- iter-215 review reports: **lean-vs-blueprint-checker ts215** — 0 must-fix, 3 major (the new helper
  unpinned; associator proof-route mismatch; commgroup pinned-but-absent). All folded into the writer
  ts216 directive. **lean-auditor ts215** — prior doc-staleness asks (carried; the vestigial-deletion
  this iter subsumes most of them).

## Decision made — execute the analogist's CRITICAL structural pivot (delete the vestigial wall);
## escalate the SubT-vs-RR fork to USER; keep the objective NARROW

**Fork:** (i) dispatch a 3rd "+1 infra helper" round toward the whiskering/H1 wall (progress-critic
forbids this — two gates missed); (ii) escalate to USER and idle (the planner rule forbids idling —
no other un-gated Route-A lane exists); (iii) execute the analogist's structural pivot (delete the
vestigial apparatus, re-route the associator directly) AND sharply escalate the strategic fork.

**Chosen: (iii).** It is the progress-critic's own option (b) ("pivot to a structurally different
associator strategy"), NOT a 3rd same-wall infra round — it DELETES the wall the gate was guarding.
Acting on a mandatory critic's CRITICAL must-fix this iter is exactly the deeper-think trigger.

**Explicit rebuttal of the progress-critic's "no 3rd round without USER authorization."** The
progress-critic is right that another helper toward `isLocallyInjective_whiskerLeft_of_W` / H1 / d.2
would be churn. But the analogist established that lemma is VESTIGIAL — the group law never needed it.
The dispatch this iter is not "+1 helper on the wall"; it is re-routing the associator OFF the wall
and DELETING the wall (count can drop −1 the moment the whiskering sorry goes). The planner rule
("you decide; you never wait; never idle the loop on a pending user decision") overrides "wait for
USER authorization": I surface the decision to the USER as an override-able FYI and proceed. A
"no-dispatch, awaiting USER" round is explicitly forbidden.

**strategy-critic ts216 must-fixes — all incorporated (not ignored):**
1. *`monoidOfSkeletalMonoidal` mis-citation.* Correct: that decl needs a coherent
   `MonoidalCategory (X.Modules)` (the thing we avoid); only `CommRing.Pic`/`instCommGroupPic`
   supports the direct hand-build. Fixed in STRATEGY.md + blueprint (writer ts216c).
2. *Demonstrate the linchpin is SMALLER, don't assert.* Incorporated as the **make-or-break**: the
   restriction-compatibility is consumed only on a *free trivializing cover* (sheaf-⊗ = presheaf-⊗,
   cheap) — the prover must prove it there, NOT via the general presheaf-pushforward adjunction
   (Mathlib-absent H1). If the free-cover proof needs H1, the pivot relocated the gap → revert to the
   `J.W.IsMonoidal`→`Sheaf.monoidalCategory` comparison. This is the iter's reversal signal.
3. *Justify grinding SubT while the RR fork could moot it.* Acknowledged: the ⊗-substrate is
   route-A-specific; if USER lifts the RR pause, `Pic⁰` via divisor classes (`WeilDivisor`/`OcOfD`)
   discards it. Under the STANDING pause it is the only un-gated critical-path work (cannot idle), so
   the resolution is: keep the objective NARROW (minimal sunk cost) + surface the moot-risk sharply to
   USER. Recorded in STRATEGY Open questions + TO_USER (via this sidecar).
4. *STRATEGY.md format NON-COMPLIANT.* Fixed: collapsed the SubT row to one line, stripped per-iter
   narrative ("iter-216 PIVOT", "6-iter wall"), terse dead-end guardrail only.

**Risk management (addressing the avoidance concern concretely).** The prover sequences:
(1) build the associator via free-cover restrict-compat + Hom-sheaf gluing; (2) ONLY after it lands &
compiles, delete the now-dead whiskering/stalk apparatus (count −1). If (1) fails this iter, the
vestigial code is NOT deleted prematurely (git-recoverable regardless). The prover must REPORT whether
the free-cover restrict-compat was cheap (pivot validated) or bottomed out in general H1 (pivot =
avoidance → reconsider `Sheaf.monoidalCategory`). That report is the cheapest reversal signal.

**Cheapest signal that would reverse this:** prover finds the free-cover restriction-compatibility
itself requires the general presheaf-pushforward adjunction (H1) → the pivot relocated the gap; next
iter run the `J.W.IsMonoidal`→`Sheaf.monoidalCategory` head-to-head (strategy-critic's alternative).

## USER escalation (surfaced for TO_USER via review)

Two override-able decisions, neither blocking the loop:
- **SubT may be wasted effort.** The 6-iter ⊗-group-law grind was building a vestigial monoidal-
  category apparatus; the pivot fixes that, but the substrate itself is route-A-specific and would be
  DISCARDED if you lift the RR pause (then `Pic⁰` comes from divisor classes, infra already present).
- **The PRIMARY GOAL (A.2.c) has no live discharge lane under the RR pause.** Keep pause ⇒ ~3400–5500
  LOC RR-free Quot engine; lift ⇒ ~600–1000 LOC `Sym^n`/Abel–Jacobi (~5× cheaper) AND moots SubT.
  This is the project's single highest-leverage decision. To redirect, add a hint to USER_HINTS.md.

## Subagents dispatched (plan-phase)

| Subagent | Slug | Verdict / outcome |
|---|---|---|
| progress-critic | ts216 | **STUCK** (Lane TS): 6 iters flat, 13+ helpers/0 elim, PARTIAL×6, two gates missed → mandatory USER escalation; warns H1 has absent presheaf sub-deps. |
| mathlib-analogist | ts216 (api-align) | **CRITICAL must-fix**: group law needs only existence-of-iso (à la `CommRing.Pic`); whiskering/`(J.W).IsMonoidal`/d.1/d.2 VESTIGIAL → delete; single linchpin = restrict-compat. Recipe `analogies/ts-picard-direct-216.md`. |
| strategy-critic | ts216 | **CHALLENGE×2** (both incorporated): mis-citation fix; demonstrate-smaller via free-cover; justify SubT-vs-RR (moot-risk); STRATEGY format. |
| blueprint-writer | ts216 | COMPLETE — associator → direct gluing; restrict-iso Step 3 → H1-only; 7 route-(e) blocks superseded; commgroup reframed; pinned `restrictScalarsRingIsoTensorEquiv`. |
| blueprint-writer | ts216b | COMPLETE — demoted route-(e) in motivation/survey/off-path/unit-iso sections. |
| blueprint-writer | ts216c | COMPLETE — commgroup mis-citation fixed (by-hand, not `Skeleton`); free-cover make-or-break added to assoc/restrict-iso; route-(e) demoted chapter-wide. Surfaced that `CommRing.Pic` itself uses `Skeleton` over a fixed-ring coherent category (resolved as a contrast, not a reuse). |
| blueprint-clean | ts216 | PASS — Lean leakage / iter-narrative stripped; missing SOURCE QUOTE added verbatim; markers untouched. |
| blueprint-reviewer | ts216fp | fast-path: `complete: partial, correct: true`. Math sound, 5/5 content checks pass. 3 metadata must-fix (circular `\uses` graph cycle; missing proof-block `\uses`; missing `\lean` hint) → **all fixed by plan agent directly** (within blueprint write-domain). |

## Decision: prover DEFERRED to iter-217 (blueprint-gate)
The fast-path reviewer returned `complete: partial` (3 pure metadata must-fix). The HARD GATE requires
`complete: true` with no must-fix, so the prover is **deferred** — the rule-correct action on a partial
re-review. I fixed the 3 metadata items directly (circular `\uses` removed from
`lem:restrictscalars_ringiso_tensorequiv`; added it to `lem:tensorobj_restrict_iso`'s `\uses`; added a
`\lean{}` hint to `lem:pullback_compatible_with_tensorobj`), so iter-217's mandatory blueprint review
clears the gate cleanly and the NARROW prover (PROGRESS.md objective 1) runs then.

This deferral is NOT idling and NOT avoidance: the iter delivered the diagnostic pivot (the 6-iter stall
was building a vestigial apparatus), a 3-round blueprint rewrite + clean + review, resolution of three
mandatory critics, the metadata fixes, and a sharp dual USER escalation. It also honors both critics'
counsel (escalate; don't rush another substrate grind) by giving the USER a one-iter window to redirect
via USER_HINTS before the narrow prover runs. Build GREEN throughout (no Lean edits by plan).

## Subagent skips
None — all three highly-recommended plan-phase subagents (progress-critic, strategy-critic,
blueprint-reviewer) were dispatched.
