# Iter 036 — Plan (Quot-Foundations)

## TL;DR

Resumed an interrupted iter-036 plan phase that had **pivoted-then-reverted** the FBC route. The
prior partial run (a) executed the iter-035-scheduled pivot to the affine-local explicit-inverse /
element-`ext` route (writer `fbc-pivot` rewrote the blueprint), (b) dispatched the mandatory critics,
(c) got a decisive **strategy-critic CHALLENGE** that the pivot is *inverted sunk-cost* — element-`ext`
is documented in the SOURCE CODE as a dead end while the conjugate-counit `huce` route it abandoned has
a **landed master identity and a bounded ~150-LOC enumerated remainder** — and (d) correctly **reverted**
(writer `fbc-revert` restored the conjugate-`huce` blueprint; STRATEGY.md was re-pointed). It was
interrupted before finalizing PROGRESS/task_pending/sidecar. This resume consumes that work, **verified
the strategy-critic's three source claims directly in `FlatBaseChange.lean`** (all confirmed), ran the
missing **blueprint-reviewer HARD GATE** (all 3 active chapters PASS), and dispatched **3 parallel
import-independent prover lanes**:

1. **FBC-A** [fine-grained] — close the `gstar_transpose` sorry via the **conjugate-counit `huce`
   remainder** (steps a/b/c), bypassing the stalled conj-2a sub-lane. This is the route the source
   labels "the only tractable route"; the hard counit coherence (`huce`) is already landed.
2. **QUOT-Hfr** [mathlib-build] — build `gammaPullbackTopIso`, the `Hfr` section-transport ingredient
   that turns `isLocalizedModule_basicOpen_descent` + gap1 into one-liners.
3. **GR-existence** [mathlib-build] — scaffold + build **E1** (chart factorization), the primary
   missing-API gate of `ValuativeCriterion.Existence (toSpecZ)`.

## Decision made — resume the conjugate-`huce` route (NOT the element-`ext` pivot)

- **Option chosen:** revert FBC-A to the conjugate-counit `huce` calculus and close `gstar_transpose`
  from the landed master identity + the enumerated remainder. The element-`ext` / explicit-inverse
  pivot (iter-035's pre-scheduled ramp) is **rejected**.
- **Why (the strategy-critic CHALLENGE, source-verified by me this iter):**
  - `pushforwardBaseChangeMap` is *defined* (FlatBaseChange.lean:79–86) as an adjunction transpose, so
    any element-level evaluation unfolds via `Adjunction.homEquiv_counit` to the mate form and lands
    **back on `gstar_transpose`** — the element route does not bypass the gap, it renames it.
  - The in-code note (verified at L2057) states verbatim: *"The per-generator route is a dead end …
    the geometric counit/pullback/Γ have no element-level normal form — the abstract conjugate calculus
    above is the only tractable route."* The pivot pointed at a route the source already rejected.
  - The conjugate route is **not exhausted**: `huce` (the counit-transport master identity) is **landed
    and compiling** (verified L2079, L2090–2107), and the residual is a bounded, enumerated ~150-LOC
    telescoping (steps a/b/c at L2108–2124) with **all named inputs already proved standalone**
    (`base_change_mate_fstar_reindex_legs_unitExpand` @1317, `…_gammaDistribute` @1348, verified present).
  - The new route is a **genuine structural change** from the 5-iter stall, not a re-run: the stall was
    on the `_legs`→conj-2a *section-composite→conjugateEquiv-component reframing*; the `huce` remainder
    **reproves the inner reindex INLINE** from the proved standalone lemmas and never touches conj-2a.
- **LOC/risk:** ~150 LOC, fine-grained. Hardest piece (`huce`) already landed; remainder is three named
  telescoping steps. Risk: the dictionary cancellation (step c) matching `huce`'s tilde-counit factors
  against `Θ_src`/`Θ_tgt`.
- **Cheapest reversal signal:** if this round closes `gstar_transpose` with no verifiable structural
  progress AND no standalone sub-lemma (a)/(b) lands compiling, the conjugate encoding is genuinely
  spent → iter-037 dispatches a **mathlib-analogist** consult on the counit coherence (strategy-critic
  secondary corrective) and weighs the affine tilde-equivalence transport fallback. NOT user escalation
  (standing AUTONOMOUS-OPERATION directive forbids it).

## Critic dispositions (both dispatched THIS iter, slug iter036)

- **strategy-critic `iter036` — CHALLENGE (FBC): ADDRESSED by reverting.** I side fully with the critic.
  Its RECOMMENDED Alternative ("resume the conjugate-counit calculus from the landed `huce`") is exactly
  the route now active. STRATEGY.md + the FBC blueprint were re-pointed to it (writer `fbc-revert`). The
  non-FBC routes (GF, QUOT gap1, GR-proper, QUOT-repr) it graded SOUND. Format nit (slightly
  multi-sentence Risks cells) is residual and accepted — the substantive iter-stamped-narrative drift it
  flagged was already removed in the revert; not re-editing STRATEGY to avoid introducing errors for a
  cosmetic cell-length nit.
- **progress-critic `iter036` — STUCK (FBC-A): ADDRESSED with a refinement of its framing.** The critic
  endorsed "route pivot (already dispatched)" as the corrective and demanded the new route *engage and
  partially discharge obligation 2, not defer it into another sorry*. I rebut only its assumption that the
  corrective is the element-`ext` pivot: per the strategy-critic + the source, that pivot would have
  re-deferred the same lemma. The corrective I took — resume conjugate-`huce`, **bypassing conj-2a** —
  satisfies the critic's actual requirement: the obligation is engaged in a language where its hard part
  (`huce`) is *already discharged*, and the remainder is enumerated with proved inputs. This is a genuine
  structural advance, not a fourth approach. QUOT graded CONVERGING, GR UNCLEAR (healthy, <K data) — both
  proceed.
- **`UniversallyClosed.of_valuativeCriterion` prerequisite** (strategy-critic flagged UNVERIFIED): moot
  for iter-036 — the GR reduction `isProper_of_valuativeExistence` that consumes it is **already landed
  and compiling** (iter-035). The iter-036 GR target is E1, upstream of that reduction.

## Blueprint gate (HARD GATE cleared this iter)

Writers `fbc-pivot`→`fbc-revert`, `quot-hfr`, `gr-existence` (prior partial run) + `blueprint-clean
iter036` (ran through all 3 chapters; killed before its report, edits landed). **blueprint-reviewer
`iter036` (whole, HARD GATE): all 3 active chapters `complete=true, correct=true`, no must-fix.** DAG:
0 unknown_uses, 0 isolated, 0 blueprint-doctor findings. → all 3 lanes clear to dispatch.

- One residual stale `% NOTE` at FBC conj-2a (L2207–2216, "iter-036 executes explicit-inverse") — flagged
  for the review agent to update (`% NOTE` is review-domain); does not block dispatch.

## Coverage debt

21 → 9 (writers cleared the GR scaffold / QUOT descent-keystone / FBC param blocks). The remaining 9 are
all file-local implementation-detail helpers: GR `rotMid`/`transitionInvImageMatrix`/`transitionInvPair`;
QUOT `descent_overlap_agree`/`descent_smul_eq_zero`/`descent_surj`/`iSup_basicOpen_subtype_eq_top`/
`res_comp`; FBC `isIso_unitToPushforwardObjUnit_of_isIso'`. Each lane is instructed to mark its own
file's helpers `private` (verify no out-of-file refs via the build) — the sanctioned implementation-detail
escape hatch — clearing them from the 1-to-1 scan without polluting the DAG with trivial nodes.

## Subagent skips

- strategy-critic / progress-critic: already dispatched THIS iter (slug iter036) by the interrupted
  partial run; both verdicts consumed and dispositioned above. No re-dispatch — inputs unchanged since.
- blueprint-clean: already ran THIS iter (logs `blueprint-clean-iter036.jsonl`; edited all 3 chapters,
  killed before report). Re-running risks churn; the blueprint-reviewer HARD GATE that followed confirms
  all 3 chapters clean + correct.

## Tripwire (record only)

FBC-A is at the conjugate route's ~6th iter. If iter-036 closes `gstar_transpose` → cascade
`cancelBaseChange`/`affineBaseChange_pushforward_iso` and open FBC-B chain assembly + obligation 1. If it
closes nothing AND lands no compiling standalone sub-lemma (a)/(b), iter-037 = mathlib-analogist consult
on the counit coherence (NOT another conjugate round, NOT user escalation). The dead `_legs`/conj-2a/
`inner_value_eq` sorry-cluster (now fully off the critical path) is pruning debt for a cleanup pass once
`gstar_transpose` lands.
