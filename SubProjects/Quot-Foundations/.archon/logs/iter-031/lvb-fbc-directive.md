# lean-vs-blueprint-checker — FlatBaseChange (iter-031)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Verify bidirectionally for the iter-031 prover work (no sorry closed; `_legs` assembly advanced):
- Live target `base_change_mate_fstar_reindex_legs` (@~1392 stmt, sorry @~1472): proof advanced
  with a new `simp only [base_change_mate_codomain_read_legs, ...]` before the `sorry`.
- The prover reports a DECLARATION-ORDERING issue: the eCancel atoms
  (`base_change_mate_inner_eCancel_eUnit/_pushforwardComp/_pullbackComp`) and
  `base_change_mate_inner_value_eq` are defined AFTER `_legs`, so they are out of scope at the
  `_legs` sorry. Check whether the blueprint reflects this ordering / whether the named sub-lemma
  cone (`..._link_*`) is consistent with the Lean.
- Report: (a) Lean-side red flags (misleading "sorry-free" docstrings, dead `set`/`have`); (b)
  blueprint adequacy for the residual term-mode canceller splice; (c) any dangling `\lean{}` pins
  (the iter-030 review flagged L1-L5 link pins — confirm whether resolved). The 4 sorries
  (`_legs`, `gstar_transpose`, affine, FBC-B) are all known/gated.
