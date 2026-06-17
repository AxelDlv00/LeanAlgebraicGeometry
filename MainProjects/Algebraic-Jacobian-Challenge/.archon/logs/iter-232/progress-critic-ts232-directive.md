# Progress-critic directive — iter-232

Assess convergence of the single active prover route. Strict context discipline:
only the signals below.

## Route: A.1.c.SubT — `Picard/TensorObjSubstrate.lean` (⊗-inverse C-bridge)

The sole active prover lane. Target sorry: `exists_tensorObj_inverse` (the line-bundle
⊗-group inverse), via the dual / internal-hom base-change iso `dual_restrict_iso`.

### Signals, last 5 iters (227–231)
| iter | project sorry | helpers added | prover status | blocker phrase |
|---|---|---|---|---|
| 227 | 81→80 | +5 | COMPLETE (closed `tensorObj_restrict_iso`) | — (last elimination) |
| 228 | 80→80 | +3 (dual-iso helpers) | PARTIAL | C-bridge hard-block at H2′ |
| 229 | 80→80 | +3 (`overSliceSheafEquiv` shared root) | COMPLETE (infra only) | "build shared root, unblocks both" |
| 230 | 80→80 | 0 | PROBE / no-close | shared root does NOT serve C (presheaf over varying 𝒪(V)) |
| 231 | 80→80 | 0 | NO-EDIT STALL (gate failed) | "no packaged dual-commutes-with-pushforward; ~150–300 LOC build resisted 4 iters; tool-latency" |

- Recurring blocker: the C-bridge `dual_restrict_iso` is a genuine ~150–300 LOC
  presheaf-level base-change iso over the varying ring `𝒪(V)`; the all-or-nothing
  HARD GATE used in iters 230–231 produced no edits.
- Project sorry has been flat at **80 for 14 iters** (since iter-217).
- Strategy `Iters-left` for this phase: was a "binary gate"; this phase was entered
  ≈ iter-217 (≈15 iters elapsed in-phase).

### This iter's proposed action (iter-232)
STRUCTURAL RESET, not another helper round:
1. **File-split** the 2375-line leaf `TensorObjSubstrate.lean` (refactor subagent) into a
   dedicated C-bridge file + a vestigial quarantine (executes the iter-231 pre-committed
   FAIL corrective + the USER parallelism directive; removes the named context-cost blocker).
2. **Convert the C-bridge to an EXPLICIT incremental sub-build** — one axiom-clean
   sub-lemma per iter instead of the all-or-nothing 150–300 LOC gate. First standalone
   deliverable: the per-`V` slice equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)`
   (no module-coherence risk).
3. Seed an ungated engine parallel lane (`Cohomology_FlatBaseChange`) for the USER
   parallelism directive.

### Question for you
Is the structural reset (file-split + incremental sub-build + parallel-lane seeding) a
genuinely different action that breaks the 14-iter churn, or is it cosmetic? If you see
a sharper corrective (e.g. commit to the route-II pivot now rather than continue the
dual), name it. Verdict per route + the corrective TYPE you recommend.
