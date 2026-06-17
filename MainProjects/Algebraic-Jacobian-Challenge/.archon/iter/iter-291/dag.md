# DAG iter-291 narrative

## Headline: verified-stable structure + ONE real fix — the protected-chapter literal-refs were
never actually recorded for the user. A fresh `leandag build` reconfirms the blueprint is
byte-for-structure identical to iters 287–290: **878 blueprint nodes, 54 lean-aux, 1484 edges,
gaps 0, isolated-blueprint 0, 2 ∞ lean-aux**; doctor `malformed_refs` 11 (all `literal-ref`,
`Jacobian.tex` 9 + `AbelJacobi.tex` 2), `broken_refs` 0, `orphan_chapters` 0; STRATEGY.md SHA
`aa783bb7` unchanged. Gate criteria 1–4, 6, 7 PASS; criterion 5 (1-to-1 over the 54 lean-aux)
stays STRUCTURALLY DEFERRED. **The substantive action this iter:** I read `TO_USER.md` directly
and found it does NOT contain the literal-ref notice that iters 288–290 status/sidecars *claimed*
it carried ("TO_USER.md already current… exact renderable line list"). The file had only 2
bullets (Picard-frozen + RiemannRoch-REF hygiene); the 11 central-chapter refs were recorded
nowhere actionable. I wrote the proper entry, with a confirm-ready `\cref` target per line.

## What I verified directly this iter (grounded, not lifted)
1. `leandag build` — 2 ∞ nodes, gaps 0; effort done 678,198 / remaining 275,905.
2. `leandag show gaps` → **0 nodes**. Criterion 1 (zero ∞ *blueprint* sources) holds.
3. Doctor JSON (`logs/iter-290/blueprint-doctor.json`) — `malformed_refs` 11, partitioned
   `Jacobian.tex` 9 + `AbelJacobi.tex` 2 by reading each entry's `chapter`. `broken_refs` 0,
   `orphan_chapters` 0.
4. `git hash-object .archon/STRATEGY.md` = `aa783bb7881d917ad132d0e3180af15525a04c11` — unchanged.
5. **`archon-protected.yaml` read directly** — protects only Lean *signatures*
   (`AlgebraicGeometry.Jacobian` +4 instances, `genus`, 3 `Jacobian.ofCurve`). It does NOT list
   any `.tex` chapter. So "protected files" is technically imprecise for `Jacobian.tex`/
   `AbelJacobi.tex`; they are the human-authored *exposition* of the protected decls.
6. **Read every flagged `REF` line in both chapters** (grep'd with line numbers) — see the
   per-line determination below.
7. **Read `TO_USER.md` in full** — only 2 bullets, neither the literal-ref notice. The
   prior-status claim that it was "already current" with the line list was FALSE.

## The drift I corrected
Iters 288→290 DAG_STATUS/sidecars asserted TO_USER.md carried "the exact renderable line list
(AbelJacobi L68; Jacobian L459/469/630/631) and the L612/614 no-action note." It did not — that
content was never written to the file. This is the failure mode of inheriting a prior narrative
without re-checking the artifact it describes. I corrected it by actually writing the notice.

## Per-line determination (now in TO_USER.md, all candidate labels verified to exist)
- **AbelJacobi L68** — two `Theorem~REF`, both → `\cref{thm:nonempty_jacobianWitness}` (FORCED;
  same paragraph already `\ref`s that label and calls it "the deferred existence hypothesis").
- **Jacobian L631** — `Chapter~REF` ("introduces the Abel–Jacobi morphism") → `\cref{chap:AbelJacobi}` (FORCED).
- **Jacobian L469** — `Chapter~REF` → `\cref{chap:AbelJacobi}` (FORCED); `Theorems~REF--REF` =
  the four protected `Jac(C)` instances, needs labels the mathematician chooses (AMBIGUOUS).
- **Jacobian L630** — `Theorem~REF` → `\cref{thm:nonempty_jacobianWitness}` (FORCED);
  `Theorems~REF--REF` = same four-instance range (AMBIGUOUS).
- **Jacobian L459** — `Theorem~REF of Chapter~REF` GENUINELY AMBIGUOUS: keystone
  `\cref{prop:rigidity_genus0_curve_to_AV}` of `\cref{chap:AbelianVarietyRigidity}` (named first,
  active route) vs fallback `\cref{thm:rigidity_over_kbar}` of `\cref{chap:RigidityKbar}`. The
  prose names BOTH — the leading-reference choice is the mathematician's.
- **Jacobian L612/614** — `Exercise~REF`/`Remark~REF` inside a `% SOURCE QUOTE` comment (verbatim
  Kleiman, non-rendering). NOT a defect; NO action.

## Why I routed rather than edited the chapters directly
Although `archon-protected.yaml` freezes Lean signatures (not `.tex` files), my DAG prompt's
"Mathematician-protected material" rule (line 261) routes doctor findings inside files that
blueprint protected material to the user, and these are the project's two most sensitive
chapters (central-theorem exposition: Brauer–Severi obstruction, route-(c) rigidity, the
C.2.a–C.2.g descent). Decisive practical point: most flagged lines MIX a forced ref with a
genuinely ambiguous one (L459 rigidity choice; L469/L630 four-instance ranges), so a partial
direct edit would leave a messy half-state AND still trip the doctor for that line — net negative.
`\cref` in prose creates no `\uses{}` DAG edge, so there is no cycle risk either way; the blocker
to a clean fix is purely the ambiguous targets, which are the author's call. Routing with
confirm-ready per-line suggestions is the clean, ownership-respecting, and genuinely
issue-advancing move.

## Criterion-5 deferral — STRUCTURALLY FORCED (unchanged from iters 284–290)
The 54 uncovered lean-aux all originate from `TensorObjSubstrate.lean` + `DualInverse.lean`.
- 2 of the 54 are ∞-effort sorry targets (`sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`) — ∞ because they ARE the stuck D3′ / dual-route-2 pieces; no settled
  informal proof exists, not sorry-free in Lean (Lean-kernel `whnf`/`eqToHom` wall, `ts271`/`ts265`).
- Covering them would TRADE a criterion-5 fail for a criterion-1 fail (they'd become ∞ *blueprint*
  sources I cannot prove).
- The other 52 are transient prover scaffolding below the granularity of the consolidated
  `Picard_TensorObjSubstrate.tex` (which blueprints the file's public theorems); the prover
  extracts/renames/merges them constantly, so blueprinting now goes stale next prover edit. Lane
  frozen because STUCK, not done. Criterion 5 closes only once those 2 declarations settle.

## Gate criteria — 6 PASS, 1 structurally deferred
1. Zero ∞ blueprint sources — ✓ (`gaps` 0; 2 ∞ nodes are Lean-aux).
2. Zero broken `\uses{}` — ✓.
3. Every blueprint decl pinned by `\lean{}` — ✓ (Needs `\lean{}` 0).
4. Connected — one cone, 0 isolated blueprint — ✓.
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered. Deferred — STRUCTURALLY FORCED.
6. `content.tex` inputs every chapter — ✓.
7. `leanblueprint web` renders — ✓ (EXIT 0; no chapter edited since iter-287, and I edited no
   chapter this iter — only `TO_USER.md`).

## The meta-signal (unchanged)
The blueprint is not the bottleneck — one acyclic cone, renders as a web site, zero non-protected
doctor findings. Stuck-ness is a Lean-kernel transport wall on D3′ / dual-route-2 for the
plan/prover phase to break. The one thing the DAG phase could still do — make sure the user
actually sees the open central-chapter refs — was silently undone by narrative drift; that is now
fixed.

## Subagent skips
- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb7`) from iter-290 and prior verdict SOUND
  with no live CHALLENGE — skip condition met. No chapter/strategy edit this iter (only TO_USER.md).
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` edited since its prior dispatch
  (this iter edited only `.archon/TO_USER.md`); prior verdict cleared the HARD GATE for all
  chapters under active prover work; no live must-fix finding.
- blueprint-writer: no chapter flagged incomplete/partial; the only open findings (11 literal-refs)
  are routed to the user per the protected-material rule, not a writer target.
- progress-critic: prior iter ran no prover phase (loop DAG-only since iter-277; 31 sorries frozen);
  no new trajectory data to assess.
- dag-walker / effort-breaker: gaps 0, no ∞ *blueprint* source and no high-effort frontier to
  decompose; the 2 ∞ nodes are Lean-aux with no informal proof to write/break.
