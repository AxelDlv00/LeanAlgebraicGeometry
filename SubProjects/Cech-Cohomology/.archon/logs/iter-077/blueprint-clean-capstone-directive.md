Target: blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

Post-write purity pass on the blocks just added near `lem:cech_computes_cohomology` (~L11700+):
`lem:pushforward_mapHC_cechComplexOnX`, `lem:cechAugmented_to_acyclicResolutionInput`,
`lem:rightAcyclic_finite_prod`, `lem:cech_computes_cohomology_affineCover`, and the edited
`lem:cech_term_pushforward_acyclic`. Strip any Lean tactic strings / project-history / iter narrative
from prose; keep statements math-only in project notation. Do NOT touch `\leanok`/`\mathlibok` markers.
Leave the rest of the chapter alone.
