# Blueprint-reviewer directive — fast-path, iter-217

This is a **same-iter fast-path re-review** to clear the HARD GATE on ONE chapter so a
prover may be dispatched on its file THIS iter. You still audit the whole blueprint as
usual, but the gate decision this iter hinges on the chapter below.

## Chapter under the gate
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(backs `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — the sole active prover lane).

## Why it was `complete: partial` last iter, and what was just fixed
The iter-216 review (lean-vs-blueprint-checker ts216) flagged TWO must-fix-this-iter
findings on this chapter:
1. `lem:tensorobj_assoc_iso` proof claimed "direct gluing / no whiskering" while the
   Lean uses the route-(d) whiskering composite.
2. `lem:tensorobj_restrict_iso` (and the assoc proof) carried a "free-cover avoids H1"
   narrative that the iter-216 prover make-or-break REFUTED (H1 is on the critical path).

This iter, blueprint-writer ts217 + blueprint-clean ts217 rewrote both proof blocks:
- Deleted both refuted "free-cover" paragraphs and both stale `% NOTE` comments.
- `lem:tensorobj_restrict_iso`: now ends on the H1 residual (presheaf
  `pushforward β ≅ pullback φ` via `leftAdjointUniq`) as the sole open obligation,
  with a verbatim Stacks `(f^*,f_*)` adjunction quote.
- `lem:tensorobj_assoc_iso`: now states the CURRENT realization (route-(d) whiskering,
  transitively gated on the open `isLocallyInjective_whiskerLeft_of_W`) honestly, plus
  the PLANNED re-route (direct gluing via `tensorobj_restrict_iso` once H1 closes it).
- Added a companion block `lem:restrictscalars_ringiso_strongmonoidal` pinning the 5
  ModuleCat-level H2 declarations.

## What I need from you
Confirm whether `Picard_TensorObjSubstrate.tex` is now **complete: true** AND
**correct: true** with **no must-fix-this-iter finding**, focusing on:
- Are the two prior must-fix findings genuinely resolved (no remaining "free-cover
  avoids H1" guidance; the assoc proof sketch now matches the Lean's route-(d)
  realization and clearly labels current vs. planned)?
- Are the newly-pinned declarations well-formed (`\lean{...}` names plausible, `\uses`
  resolve, source quote present and verbatim)?
- Any NEW correctness problem the rewrite introduced.

Report per your standard per-chapter checklist + verdict. The gate clears for this
file only on a fresh complete+correct verdict with no must-fix.
