# lean-auditor — iter-023

Audit these two Lean files as Lean (no strategy bias). Report outdated/stale comments,
suspect definitions, dead-end proofs, bad Lean practices, and any excuse-comments masking
non-proofs. Pay special attention to:
- Comments describing a proof state that no longer matches the code (the files were heavily
  edited this iter).
- The new gstar-chain lemmas in FlatBaseChange.lean (3 new theorems around lines 1499–1760)
  and whether their `sorry` bodies are honest scaffolding vs. excuse-laden.
- genericFlatness in FlatteningStratification.lean (~line 2264): a signature hypothesis was
  added this iter; check the surrounding in-body comments for staleness.
- A known DEAD declaration `base_change_mate_fstar_reindex_legs` (~line 1421, sorry) — flag if
  its comments still claim it is live.

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
