# lean-vs-blueprint-checker directive — iter-041 — FlatBaseChange

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

- Lean file: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint chapter: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Context for this check
One edit this iter (no new declarations). The open `sorry` in `base_change_mate_fstar_reindex_legs_conj`
(~line 1757/1822) gained an in-proof Γ-collapse `simp` stage ahead of the remaining sorry; the keystone
`_legs_conj` is NOT closed (still has a sorry). This was the FINAL in-loop FBC attempt.

## Specific things to check
1. The blueprint block `lem:base_change_mate_fstar_reindex_legs_conj` should NOT carry a `\leanok` proof
   marker (the Lean still has a sorry). Confirm sync_leanok did not wrongly mark it.
2. The three supporting legs (conj-2b `base_change_mate_reindex_conj_pullbackLeg`, conj-2c
   `base_change_mate_reindex_conj_pushforwardCollapse`, conj-2d `base_change_mate_reindex_conj_crossLayer`)
   are proven — confirm their blueprint pins match and are honestly marked.
3. Check the blueprint sketch for `_legs_conj` still reflects Fallback B (layer-by-layer conjugate transport)
   and that the open sorry's roadmap comment in the Lean does not cite a sorry-backed lemma as proven.

## Output
Bidirectional report, must-fix flagged. Read both paths directly.
