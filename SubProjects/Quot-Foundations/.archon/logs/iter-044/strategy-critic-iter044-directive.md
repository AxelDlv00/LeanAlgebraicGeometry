# Strategy-critic directive — iter-044

Read ONLY these, with fresh eyes (no project history, no iter narrative):
- `STRATEGY.md` (verbatim, current).
- `references/summary.md` (the reference index).
- Blueprint chapter topics: one line per file in `blueprint/src/chapters/` — read just each chapter's
  title/first lemma to form the topic map; do NOT read proofs.

Do NOT read: PROGRESS.md, task_pending.md, task_done.md, iter/ sidecars, task_results/, logs/ reports.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability`
cone (Kleiman FGA "The Picard scheme" §4): flat base change for `f_*` at i=0 (FBC), generic flatness (GF),
and the Quot/Grassmannian foundations (QUOT). End-state: zero project sorry + kernel-only axioms in the
closure; names/labels match the parent so finished work merges back.

## What changed this iter (the thing to assess)
FBC-A1 moved PIVOT → PARKED: both the conjugate route and the iter-043 affine-tilde-transport pivot were
found to funnel through the SAME open keystone (`_legs_conj`), with no section-level bypass. Per the standing
AUTONOMOUS-OPERATION directive (no user escalation), FBC is parked off the critical path (it blocks no other
route) pending a dedicated bottom-up keystone build; a mathlib-analogist de-risks the Mathlib idiom this iter.
QUOT-defs gap2 narrowed to Piece A only (Piece B done).

## Questions for you
1. Is parking FBC sound, given it is one of the three headline deliverables (the goal names
   `thm:flat_base_change_pushforward`)? Or does parking risk the leg never closing — should FBC instead be
   restructured (different proof route to the affine iso) rather than parked on the same keystone?
2. Is the overall leg-closing strategy still sound with the live frontier reduced to QUOT (converging) +
   GF (gap2-gated) while FBC + SNAP + QUOT-repr are blocked/parked?
3. Any mis-scoped phase or hidden missing prerequisite visible from the references vs the phase table?
