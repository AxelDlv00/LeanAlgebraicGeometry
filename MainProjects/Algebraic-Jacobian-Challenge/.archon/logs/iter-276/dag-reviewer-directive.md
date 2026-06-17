# Blueprint-reviewer directive — whole-blueprint certification (iter-276)

Audit the **entire** blueprint (`blueprint/src/chapters/*.tex`) per your standard
per-chapter completeness + correctness checklist. Do not limit scope — the
cross-chapter view is the point.

## Context for this dispatch (not a scope limit)

The live `leandag` (rebuilt this iter) shows the blueprint is in a better state
than the last carried-forward status narrative claimed: **54 uncovered `lean-aux`
nodes**, all in the two actively-churning prover-lane files
(`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`,
`.../TensorObjSubstrate/DualInverse.lean`) — deliberately deferred until that lane
stabilises. The previously-reported "123" was a stale cache; the 69 internal-hom
/ stalk-tensor / vestigial helper coverage blocks (the three `*_helpers`
subsections of `Picard_TensorObjSubstrate.tex`) are already present on disk and
matched by `leandag` (0 of them isolated or unmatched).

## What I most need verified

1. **The three `*_helpers` subsections of `Picard_TensorObjSubstrate.tex`**
   (`subsec:tensorobj_internalhom_helpers`, `subsec:tensorobj_stalktensor_helpers`,
   `subsec:tensorobj_vestigial_helpers`): are the ~69 "Proved directly in Lean"
   coverage blocks **mathematically faithful** to their Lean declarations, with no
   duplicate `\lean{}` pins and no Lean syntax leaking into statement/proof bodies?
   These blocks may have been written in a batch that never received a final
   whole-blueprint review pass, so this is the priority.
2. Standard whole-blueprint axes: completeness, correctness, faithful `\lean{}`
   pins, no new isolated nodes, `\uses{}` fidelity.
3. Your usual `### Dependency & isolation findings` section — tag each isolated /
   broken-edge node `wire-up`, `remove`, or `keep`. Note: three blueprint nodes
   are long-standing isolation-exempt leaves (`lem:S3_sep_2_*`, `lem:S3_pi_2_*`,
   `lem:isiso_sheafification_map_of_W`); confirm whether `lem:isiso_sheafification_map_of_W`
   should be wired into the W-class machinery or is genuinely vestigial.

Render your standard per-chapter checklist and HARD GATE verdict.
