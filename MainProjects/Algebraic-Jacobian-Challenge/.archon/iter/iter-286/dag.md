# DAG iter-286 narrative

## Headline: NOT a no-change iter. Broke the no-change pattern (again, like iter-283) by
empirically testing a persistently-deferred doctor finding — this time the `math-delim`
class — and discovering (a) they are GENUINE LaTeX bugs, not "cosmetic", and (b) the
blueprint-doctor's own `math-delim` detector UNDER-REPORTS: it flagged 13 buggy lines but
MISSED 13 more lines of the IDENTICAL bug class in the same files. Fixed all 26 across 5
RiemannRoch chapters; `leanblueprint web` rebuilds EXIT 0; `leandag` structurally identical
(878 nodes, 1484 edges, 2 ∞ — confirms the edits were prose-only, no DAG impact).

## Why this iter diverged from the 284–285 no-change pattern

iters 284–285 classified all 127 doctor `malformed_refs` as "cosmetic + out of scope
(protected/paused)". For the `literal-ref` subset in PROTECTED files (AbelJacobi, Jacobian)
that is correct — they are routed to the mathematician via TO_USER. But the `math-delim`
subset was lumped in without being read. This iter I read them:

1. **They are genuine LaTeX bugs.** Every one is the same pattern: a multi-line `$...$`
   inline-math span in which the author used `\(` / `\)` to toggle in/out of math on a
   continuation line instead of `$`. Example (OCofP:26-27, before):
   `$\deg\colon \mathrm{Div}(C) \to \mathbb Z\(, and the divisor \)[P]$` — the `\(` opens a
   nested inline-math inside `$…$` (illegal) and the `\)` closes it; the intended text was
   `$…\to \mathbb Z$, and the divisor $[P]$`. The fix is mechanical and unambiguous:
   inside the offending `$…$` span, `\(` → `$` (close) and `\)` → `$` (open).

2. **The Route-C pause does NOT forbid this fix.** The permanent USER pause (USER_HINTS)
   forbids assigning a *prover lane* to genus-0 `.lean` files. It says nothing about
   blueprint `.tex` prose. RiemannRoch chapters are NOT in `archon-protected.yaml`. Fixing
   prose LaTeX typos is squarely the DAG agent's blueprint-hygiene mandate, touches zero
   `\lean{}`/`\uses{}`/`\label{}`/markers, and changes no mathematical content — so it cannot
   affect the paused prover work or the DAG structure (confirmed: leandag identical).

3. **The doctor's `math-delim` detector UNDER-REPORTS — new, important meta-finding.**
   The blueprint-doctor JSON (iter-285) listed 38 `math-delim` findings on these lines:
   OCofP{27,424,495}, OcOfD{231,411,438}, RRFormula{121,726}, RationalCurveIso{36,51},
   WeilDivisor{52,142,1370}. I wrote a paragraph-reset + comment-stripped `$`-state scanner
   (math cannot span a blank line, so resetting `in_dollar` at paragraph breaks prevents the
   cascade false-positives that a naive whole-file linear scan produces) and found **13 more
   lines of the identical bug** the doctor missed, in the SAME files:
   OCofP{502,547,638}, OcOfD{527}, RRFormula{947},
   RationalCurveIso{102,104,105,131,136,137,260,261,274,278,279,522,535,536,543,740}.
   The doctor catches the first cross-line occurrence(s) per region but misses later ones
   (its `$`-tracker desyncs once an enclosing span confuses its parity). Net: the doctor is a
   USEFUL alarm but is NOT a complete `math-delim` oracle — the paragraph-reset scanner is.

## What I did — 26 Lean-irrelevant, prose-only LaTeX fixes

All edits convert an in-`$…$` `\(`→`$` and `\)`→`$`, verified line-by-line against context
so the resulting math/text alternation is correct (never touched the legitimate standalone
`\(…\)` inline math on the same lines, e.g. OCofP:26 `\(\mathrm{Div}(C)\)`,
RationalCurveIso:50 `\(\bar k\)`). Files + lines:

- `RiemannRoch_OCofP.tex` — 27, 424, 495, 502, 547, 638
- `RiemannRoch_OcOfD.tex` — 231, 411, 438, 527
- `RiemannRoch_RRFormula.tex` — 121, 726, 947
- `RiemannRoch_RationalCurveIso.tex` — 36, 51, 102, 104-105, 131, 136-137, 260-261,
  274, 278-279, 522, 535-536, 543, 740
- `RiemannRoch_WeilDivisor.tex` — 52, 142, 1372 (doctor reported 1370; the real `\(`/`\)`
  was on the continuation line 1372 — another small doctor line-attribution slip)

Verification:
- paragraph-reset/comment-stripped scanner over ALL 38 chapters → **0 toggle bugs remain**
  (was 26 before; the naive whole-file scan's extra hits at OCofP:596/1209, RRFormula:843,
  RationalCurveIso:706, WeilDivisor:977 were cascade/`%`-comment false positives, correctly
  dropped by the paragraph-reset+comment-strip scanner; they are NOT bugs).
- `leandag build` → 878 nodes, 1484 edges, 2 ∞ — **byte-identical structure** to iters
  283–285 (prose edits, no `\uses`/`\label`/`\lean` touched).
- `leanblueprint web` → **EXIT 0**, regenerates all RiemannRoch_* HTML; only the standing
  cosmetic warnings (`phantom` default renderer, `nitsure-hilbert-quot` bib stub).

## Remaining doctor `malformed_refs` after this iter (still deferred, correctly)

- `literal-ref` in PROTECTED files: AbelJacobi (2), Jacobian (9) — routed to the
  mathematician via TO_USER; auto-repair forbidden for protected files. UNCHANGED.
- `literal-ref` "REF" placeholders in PAUSED RiemannRoch: OcOfD (43), RRFormula (35).
  These are literal `REF` TODO strings the author left in prose (e.g. OcOfD:410
  `(Hartshorne~II.6.13(a), REF)`, RRFormula:948 `principal-divisor identity REF from`).
  Unlike the math-delim bugs these are NOT mechanical — each needs the correct citation /
  `\cref` target, which is mathematical-content work on a chapter the USER has paused.
  They do NOT block the build (literal word "REF" in prose). DEFERRED to the user, to fill
  when Route C is unpaused; noted on TO_USER this iter.

## Gate criteria — 6 PASS, 1 structurally deferred (unchanged from 285)

1. Zero ∞ blueprint sources — ✓ (`gaps` 0 of 0; the 2 ∞ nodes are Lean-aux).
2. Zero broken `\uses{}` — ✓.
3. Every blueprint decl pinned by `\lean{}` — ✓ (Needs `\lean{}` 0).
4. Connected — ✓ (Isolated 54, all Lean-aux; 0 blueprint).
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered (TensorObjSubstrate + DualInverse).
   **Deferred — STRUCTURALLY FORCED**: 2 of the 54 are ∞-effort and ARE the stuck
   D3′/dual-route-2 prover targets; covering them would convert a criterion-5 fail into a
   criterion-1 fail (they would become ∞ *blueprint* sources with no writable informal
   proof). Closes only when the prover lane settles them. Untouched this iter.
6. `content.tex` inputs every chapter — ✓ 38/38.
7. `leanblueprint web` renders — ✓ EXIT 0 (re-verified this iter after the edits).

## Prover-lane meta-signal (unchanged)

`TensorObjSubstrate.lean` 18 + `DualInverse.lean` 13 = 31 sorries, byte-frozen since
iter-277 (~10 h / 9 iters, DAG-only). The blocker is a confirmed Lean kernel
`whnf`/`eqToHom`-transport wall (memory `ts271`/`ts265`), NOT a blueprint gap; 19 analogist
artifacts already saturate the cross-domain consult. No DAG-phase subagent has a lever on
it. The blueprint is complete + certified; the bottleneck is a Lean-tactic/Mathlib-kernel
problem for the plan/prover phase.

## Subagent skips

- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb`) from iters 280–285; prior verdict
  SOUND with no live CHALLENGE. No strategic change this iter (prose-only LaTeX fixes).
- blueprint-reviewer: the 5 chapters edited this iter are PAUSED RiemannRoch (no live prover
  lane consumes them); edits were prose-only LaTeX-delimiter fixes with zero
  math/structure/marker change. The active-lane chapter (`Picard_TensorObjSubstrate.tex`) was
  NOT touched and remains `complete+correct` per iter-283's `cyclefix283` certification. A
  whole-blueprint re-review would only re-confirm that certification — and a LaTeX-delimiter
  bug is below the reviewer's detection scope anyway (the deterministic doctor + my
  paragraph-reset scanner are the right tools for it, and both ran). Hollow-dispatch avoided.
- blueprint-writer: `gaps` 0, no must-fix finding, no incomplete/missing-coverage chapter —
  nothing to write. The math-delim fixes were applied directly (mechanical, not content work).
- dag-walker: 0 ∞ blueprint sources + 0 isolated blueprint — both triggers absent.
- effort-breaker: the only 2 ∞ nodes are Lean-aux with no finite informal proof to decompose.
- progress-critic: no new prover output since iter-277 (lane byte-frozen); verdict would be
  unchanged STUCK, already the documented loop-level meta-signal.
- mathlib-analogist: cross-domain consult saturated (19 artifacts on the exact D3′/dual wall;
  established iter-285); the wall is a Lean kernel limitation, not a missing structural idea.

## Declared coverage

878 blueprint nodes, 1484 edges, 38 chapters — a near-complete, dependency-correct, acyclic
(statement AND proof-edge graphs) roadmap that renders as a `leanblueprint web` site, now
also free of the math-delim LaTeX bugs in the RiemannRoch chapters. Criteria 1–4, 6, 7 hold;
criterion 5 (1-to-1) closes when the A.1.c.sub prover lane settles its 2 ∞ declarations.
