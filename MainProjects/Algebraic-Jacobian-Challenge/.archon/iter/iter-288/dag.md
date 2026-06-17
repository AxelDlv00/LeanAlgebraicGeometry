# DAG iter-288 narrative

## Headline: verified-stable iter with one genuine TO_USER.md refinement. Fresh `leandag build`
confirms the blueprint is byte-for-structure identical to iter-287 (878 blueprint nodes, 54
lean-aux, 1484 edges, gaps 0, isolated-blueprint 0, 2 ∞ lean-aux). Gate criteria 1–4, 6, 7 PASS;
criterion 5 (1-to-1 over the 54 lean-aux) stays STRUCTURALLY DEFERRED. The only live doctor class
— 11 `literal-ref` flags — is entirely inside the two mathematician-protected chapters, so it is
routed to the user per my prompt's explicit protected-file rule. I read the flagged lines directly
and found **2 of the 11 are not defects at all** (comment-embedded verbatim Kleiman source quotes);
I sharpened TO_USER.md to the exact renderable line list so the mathematician doesn't waste effort
on non-rendering comment text.

## What I verified directly this iter (not lifted from prior status)
1. **`archon-protected.yaml` read** — protects only Lean SIGNATURES: `AlgebraicGeometry.Jacobian`
   (+4 instances), `AlgebraicGeometry.genus`, three `Jacobian.ofCurve` decls. The blueprint
   chapters `Jacobian.tex`/`AbelJacobi.tex` blueprint exactly those protected declarations.
2. **Doctor JSON** (`logs/iter-287/blueprint-doctor.json`) — `malformed_refs` = 11, all
   `literal-ref`, all in `Jacobian.tex` (9) + `AbelJacobi.tex` (2). `broken_refs` 0,
   `orphan_chapters` 0, `axiom_decls` 0.
3. **Read every flagged line.** Renderable placeholders: `AbelJacobi.tex` L68 (3 `REF` in the
   `thm:nonempty_jacobianWitness`-gap prose); `Jacobian.tex` L459 ("Theorem~REF of Chapter~REF"),
   L469 ("Theorems~REF--REF … Chapter~REF"), L630 ("Theorem~REF … Theorems~REF--REF"), L631
   ("Chapter~REF"). **NOT defects:** `Jacobian.tex` L612/614 (`Exercise~REF`/`Remark~REF`) sit
   inside a `% SOURCE QUOTE` comment — verbatim Kleiman cross-refs (arXiv:math/0504020 p.50);
   they do not render and must not be "filled".
4. **Fresh `leandag build` + `stats`** — 878 blueprint / 54 lean-aux / 1484 edges; Proved 443
   (50.5%); Ready 50; Unmatched `\lean{}` 44; Isolated 54 (0 blueprint); ∞ nodes 2.
   `leandag show gaps` → 0 nodes. Identical to iters 283–287.
5. **STRATEGY.md** — `git hash-object` = `aa783bb7…`, unchanged since the iter-280 era.
6. **Prover lane** — `TensorObjSubstrate.lean` 18 sorries + `DualInverse.lean` 13 = 31, frozen
   since iter-277; all 54 uncovered lean-aux originate from these two files.

## The protected-file decision (re-grounded, unchanged)
My DAG prompt's "Mathematician-protected material" section names `literal-REF` in protected files
as an explicit do-NOT-auto-repair / route-to-user case. `Jacobian.tex` and `AbelJacobi.tex` exist
solely to blueprint protected declarations, and the prose is mathematician-grade (Brauer–Severi
obstruction handling, route-(c) rigidity, the C.2.a–C.2.g descent expansion). The `REF` tokens are
unfilled cross-references the mathematician left to resolve against their own exposition — guessing
a target risks mis-citing inside the most sensitive chapters. This is the opposite case to iters
286–287, where the repaired chapters (RiemannRoch) were NOT protected and the targets were
context-determinable. Decision: keep them with the user; sharpen the notice.

## The one substantive action: TO_USER.md refinement
Updated the single TO_USER bullet to (a) give the mathematician the exact renderable line list
(AbelJacobi L68; Jacobian L459/469/630/631) instead of a vague count, and (b) mark Jacobian
L612/614 as **no action** (comment-quoted Kleiman source text, non-rendering). This is the third
consecutive confirmation that the deterministic doctor over/under-flags this class (iter-286
`math-delim` under-report; iter-287 `literal-ref` under-report; iter-288 comment-text over-report)
— a useful alarm, not a complete oracle.

## Criterion-5 deferral — STRUCTURALLY FORCED (re-verified)
- 2 of the 54 lean-aux are ∞-effort sorry targets (`sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`) — ∞ because they ARE the stuck D3′ / dual-route-2 pieces; no settled
  informal proof exists and they are not sorry-free. Blueprinting them ⇒ ∞ *blueprint* sources ⇒
  criterion 1 fails. So criterion 5 cannot be met without breaking criterion 1.
- The other 52 are transient prover scaffolding below the granularity of the consolidated
  `Picard_TensorObjSubstrate.tex`; the prover churns/renames them, so entries would go stale.
- The deadlock breaks only when the prover/math settles the 2 ∞ pieces (a Lean-kernel
  `whnf`/`eqToHom`-transport wall, memory `ts271`/`ts265`) — not a blueprint gap.

## Subagent skips
- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb`) from iters 282–287; prior verdict SOUND,
  no live CHALLENGE; this DAG iter did not touch STRATEGY.md.
- blueprint-reviewer: no `blueprint/src/chapters/*.tex` edited since its prior (iter-283
  `cyclefix283`) dispatch, which certified all 38 chapters complete + correct and cleared the HARD
  GATE; no live must-fix finding; this iter touched only TO_USER.md (not a chapter). A
  whole-blueprint re-review would only re-confirm — hollow dispatch avoided.
- blueprint-writer: nothing to write — the only outstanding finding (protected-file literal-refs)
  is routed to the user; every non-protected chapter is complete + correct.
- dag-walker: 0 ∞ blueprint sources + 0 isolated blueprint — both triggers absent.
- progress-critic: no new prover output since iter-277 (lane byte-frozen); verdict unchanged
  STUCK/CHURNING, already documented as the loop-level meta-signal; no new trajectory data.
- effort-breaker: the 2 ∞ pieces have no finite informal proof to decompose (they ARE the open
  Lean-formalization targets); nothing to break.

## The meta-signal (unchanged)
DAG-only across iters 278–288 while the A.1.c.sub prover lane has not advanced. The blueprint is
not the bottleneck — one acyclic cone, renders EXIT 0, zero non-protected doctor findings. The
stuck-ness is a Lean-kernel transport wall on D3′ / dual-route-2 for the plan/prover phase to
break; no further blueprint work unblocks it.
