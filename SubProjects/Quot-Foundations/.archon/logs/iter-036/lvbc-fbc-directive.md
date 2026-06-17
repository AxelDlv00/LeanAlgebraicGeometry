# lean-vs-blueprint-checker — FlatBaseChange (iter-036)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Verify bidirectionally:
- This iter added `base_change_mate_extendScalars_inner_value_counit` (step (b) of the
  `lem:base_change_mate_gstar_transpose` proof). It is a new inline sub-lemma with no separate
  `\lean{}` block. Confirm the chapter's step-(b) prose now matches the Lean, and report whether it
  should get its own blueprint block (coverage debt).
- `lem:base_change_mate_gstar_transpose` still carries a `sorry` (steps (a)+(c) open). Confirm no
  `\leanok` falsely claims its proof is closed.
- Check the `% NOTE` at `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a) reflects current
  state (it was updated this review to say conj-2a is now off the critical path; the iter-035
  explicit-inverse pivot was reverted).
- Report any blueprint pins (`\lean{...}`) that no longer resolve to a real Lean decl, and any
  Lean decl in the file that the chapter does not cover.

Report Lean->blueprint AND blueprint->Lean findings with must-fix-this-iter flags where warranted.
