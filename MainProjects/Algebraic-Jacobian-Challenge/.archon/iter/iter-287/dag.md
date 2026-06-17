# DAG iter-287 narrative

## Headline: NOT a no-change iter. Resolved the LAST live blueprint-doctor class — the
`literal-ref` placeholders. Continuing the iter-283 (web-cycle) / iter-286 (math-delim) pattern
of empirically testing a persistently-deferred doctor finding instead of rubber-stamping it, I
read the 89 `malformed_refs` (all `literal-ref`) and found the 78 in the two non-protected
RiemannRoch chapters are genuine render defects — unfinished `\cref{}` cross-references left as
bare `REF`/`(REF)`/`Theorem~REF`/`REF of REF` tokens that render as literal "REF" in the
blueprint. Two scope-bounded blueprint-writers resolved **80** of them (OcOfD 43, RRFormula 37)
to real `\cref{<label>}`. `leandag` is structurally identical (878 nodes, 1484 edges, gaps 0, 2 ∞
lean-aux) — prose-only, zero DAG impact; `leanblueprint web` EXIT 0 with **0** "could not be
resolved" crashes. The 11 protected-file refs (Jacobian 9, AbelJacobi 2) stay routed to TO_USER.

## Why this iter diverged from the 284–285 no-change pattern (again)

iters 284–285 lumped ALL 127 doctor `malformed_refs` as "cosmetic + out of scope". iter-286
disproved that for the `math-delim` subset (26 real LaTeX bugs fixed). This iter disproves it for
the `literal-ref` subset:
- **They are genuine render defects.** Each is an unfinished cross-reference. Both chapters
  already use `\cref{...}` correctly in dozens of places — the `REF` tokens are simply the ones
  the original writer never filled. They render as bare "REF" in the HTML.
- **The Route-C pause does not forbid the fix.** The permanent USER pause is prover-only (no
  prover lane on genus-0 `.lean`); it says nothing about blueprint `.tex` prose. RiemannRoch
  chapters are NOT in `archon-protected.yaml`. DAG integrity rule 8 explicitly names `literal-ref`
  as the DAG agent's repair obligation ("repair by dispatching writers at the affected chapters").
- **0 DAG impact, verified.** Every `REF` is in prose/motivation/NOTE-comment text, never in a
  `\uses{}` or a statement — so leandag is byte-for-byte structurally identical to iters 283–286.

## What I did

1. **Resolved the REF→label mapping myself first** (read both chapters fully, built the
   cross-chapter label inventory across all RiemannRoch + WeilDivisor + OCofP + AVR + Genus +
   StructureSheafModuleK chapters, pinned the one genuinely ambiguous cross-chapter target — the
   "consumed by REF of AbelianVarietyRigidity" → `prop:rigidity_genus0_curve_to_AV` — by reading
   AVR L2982). Verified the cited cross-chapter labels exist (`def:genus`, `def:Scheme_HModule`,
   `thm:principal_deg_zero`, ...).
2. **Dispatched two scope-bounded blueprint-writers** (`ocofd-literalref-287`,
   `rrformula-literalref-287`), each with the resolved mapping as a seed + a hard "replace REF
   tokens ONLY; touch no `\label`/`\lean`/`\uses`/`\leanok`/`% SOURCE`/math" boundary, and explicit
   handling for the two unresolvable Hartshorne-6.13(a) cases (no project label exists → one
   becomes `\cref{sec:sheaf-property-correctness}`, one drops the dangling token).
3. **Independently verified** after both returned COMPLETE:
   - `grep -nE 'REF'` over both files → exit 1 (zero standalone REF tokens, zero literal "REF"
     substring of any kind);
   - all 42 (OcOfD) + 55 (RRFormula) `\cref` targets resolve to defined `\label{}`s;
   - marker counts unchanged vs my pre-edit reads (OcOfD labels=6/lean=4/leanok=4;
     RRFormula labels=15/lean=14/leanok=13) — no structural marker touched;
   - `leandag build`+`stats` identical to prior iters;
   - `leanblueprint web` EXIT 0, both chapters re-rendered, 0 "could not be resolved".

## NEW meta-finding — the `literal-ref` detector ALSO under-reports

The doctor listed 35 `literal-ref` for RRFormula; the writer found and fixed **37** (the two
`(REF, REF)` pairs were partially under-counted). This is the same under-reporting the iter-286
sidecar recorded for `math-delim`: the deterministic doctor is a useful alarm but not a complete
oracle. The reliable check is a direct `grep -nE 'REF'` for standalone tokens, which I ran to
confirm zero remain.

## leandag picture — before (iter-286) vs after (iter-287)

Identical: 878 blueprint nodes, 1484 edges, 0 isolated blueprint, 0 broken `\uses{}`, gaps 0,
2 ∞ lean-aux. The cref edits move nothing in the graph — exactly the expected signature of a
prose-only repair.

## Doctor findings after this iter

Only the 11 protected-file `literal-ref`s remain (Jacobian 9, AbelJacobi 2), routed to TO_USER
(auto-repair forbidden for protected files). The entire non-protected `literal-ref` portion —
and, combined with iter-286, the entire non-protected `math-delim` portion — is now clear. The
blueprint carries zero non-protected `malformed_refs`.

## Gate criteria — 6 PASS, criterion 5 structurally deferred (unchanged)

1 (zero ∞ blueprint sources), 2 (zero broken `\uses{}`), 3 (every decl `\lean{}`-pinned),
4 (one cone, 0 isolated blueprint), 6 (`content.tex` 38/38), 7 (`leanblueprint web` EXIT 0) all
PASS. Criterion 5 (1-to-1, 54 lean-aux) stays deferred — STRUCTURALLY FORCED (2 of the 54 are ∞
prover-stuck pieces; covering them trades a criterion-5 fail for a criterion-1 fail; the other 52
churn on every prover edit). See DAG_STATUS.md for the full argument.

## Subagent skips

- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb`) from iters 282–286; prior verdict SOUND,
  no live CHALLENGE; this DAG iter did not touch STRATEGY.md.
- blueprint-reviewer: this iter's edits were prose-only `REF`→`\cref` substitutions on
  certified-complete PAUSED RiemannRoch chapters (no live prover lane consumes them); zero
  math/structure/marker change — below the reviewer's detection scope. The deterministic doctor +
  my independent grep/marker-count/web verification covered it. Active-lane chapter
  `Picard_TensorObjSubstrate.tex` untouched; iter-283 `cyclefix283` certified all 38
  `complete+correct` and cleared the HARD GATE. Whole-blueprint re-review would only re-confirm —
  hollow-dispatch avoided.
- dag-walker: 0 ∞ blueprint sources + 0 isolated blueprint — both triggers absent.
- progress-critic: no new prover output since iter-277 (lane byte-frozen); verdict unchanged.
- effort-breaker: the 2 ∞ pieces have no finite informal proof to decompose.

## The meta-signal (restated for the plan/prover phase)

DAG-only across iters 278–287 while the A.1.c.sub prover lane is frozen. The blueprint is one
acyclic cone, renders as a web site, and now carries zero non-protected doctor findings — it is
NOT the bottleneck. The stuck-ness is a Lean-kernel `whnf`/`eqToHom`-transport wall on D3′ /
dual-route-2 (memory `ts271`/`ts265`), for the plan/prover phase to break.
