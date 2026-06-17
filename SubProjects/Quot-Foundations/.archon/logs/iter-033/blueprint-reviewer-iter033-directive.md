# blueprint-reviewer — iter-033 (whole blueprint, HARD GATE)

Audit the WHOLE blueprint per your standard per-chapter checklist (complete? correct? Lean
targets well-formed? proofs detailed enough to formalize?). Do not limit scope — the cross-chapter
view is the point.

## What changed this plan cycle (context, not a scope limit)
- `Cohomology_FlatBaseChange.tex`: a 7-block FBC-B chain was just added (globalization /
  H^0-as-equalizer leg), and `thm:flat_base_change_pushforward`'s proof was rewritten as a short
  composite over that chain. A `% archon:covers FlatBaseChange.lean FlatBaseChangeGlobal.lean`
  line was added (the FBC-B Lean will live in a NEW file `FlatBaseChangeGlobal.lean`). **These 7
  blocks will feed a prover THIS iter** — they are the gate-critical content. Confirm each has a
  well-formed `\lean{}` target, an accurate `\uses{}`, and a proof sketch detailed enough to
  formalize. Flag any that is too thin to guide a mathlib-build prover. NOTE: the FBC-A `_legs`
  crux (`lem:base_change_mate_fstar_reindex_legs` and its links) is a SEPARATE, already-reviewed
  region — not the focus here.
- `Picard_QuotScheme.tex`: three coverage blocks added (`def:over_restrict_equiv`,
  `lem:over_restrict_functor_iso`, `lem:over_restrict_pullback_iso`). The P1 node
  `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` will also feed a prover this iter — confirm it
  is complete + formalizable.
- `Picard_GrassmannianCells.tex`: three coverage blocks added; `lem:gr_separated` will feed a
  scaffold+prove lane this iter — confirm it is complete + formalizable (it is source-quoted from
  Nitsure §1).

## Output
Your standard whole-blueprint report with the per-chapter complete/correct verdicts and a
must-fix-this-iter list. Be explicit about whether the FBC chapter (covering both FlatBaseChange.lean
and FlatBaseChangeGlobal.lean), Picard_QuotScheme.tex, and Picard_GrassmannianCells.tex each clear
the HARD GATE for the lanes named above.
