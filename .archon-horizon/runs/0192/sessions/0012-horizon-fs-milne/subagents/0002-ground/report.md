Fresh review complete.

Milne is converging at the Lean/API level: round 4 landed seven verified commits, and `lake env lean MilneLib/GroupScheme.lean` exits 0. The current graph is stale-free (`353` nodes, `235` edges; `90` closed, `138` ready, `125` blocked). The four new geometric rigidity primitives are present and kernel-checked.

The formalization boundary is still honest: `lem:milne-5-11` remains `blocked`, `lean_status=empty`, with no `\lean` binding. Residue-tensor, finite affine-stalk, and invertible-stalk bridges are complete; the genuine missing API is finite generation of arbitrary scheme-module stalks/coherent sheaves. Do not spend another round on residue algebra.

Blueprint, Lean, and task status agree on I.5.11 partiality. The only mismatch is generated metadata: live `.archon-horizon/blueprints/Milne.json` reports 90 closed nodes and new unlinked-helper warnings, while ledger `HEAD` `b7ab119ce2` still records the older 80-closed snapshot. I filed issue `I-2122` for reconciliation. Milne source/blueprint paths are clean; global worktree noise is concurrent work.

Highest-value next action: either (a) introduce an explicit reusable finite-stalk/coherent interface and apply it to the existing I.5.11 epi bridge, or (b) for greater near-term DAG unlock, port the AJCR cohomology-free rigidity chain beginning with `rigidity_eqAt_closedPoint_of_proper_into_affine` toward `thm:milne-rigidity`.
