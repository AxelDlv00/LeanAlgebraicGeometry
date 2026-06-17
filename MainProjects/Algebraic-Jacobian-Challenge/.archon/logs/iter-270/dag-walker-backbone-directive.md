# DAG Walker Directive

## Slug
backbone

## Seed
thm:exists_unique_ofCurve_comp

## Strategy context
This is the project SPINE. The goal declarations are
`thm:exists_unique_ofCurve_comp` (AbelJacobi) and
`thm:smoothOfRelativeDimension_genus` (Jacobian). Both project a field of the
central existence theorem `thm:nonempty_jacobianWitness` (Jacobian.tex), which
case-splits on genus into `def:genusZeroWitness` (genus-0 arm) and
`def:positiveGenusWitness` (positive-genus arm). Currently the spine has almost
NO `\uses{}` edges: the goal cone reaches only 6 of 543 nodes, and
`thm:nonempty_jacobianWitness` has zero transcribed dependencies. Your job is to
transcribe the spine's real dependencies so the goal's ancestor cone reaches the
route heads of every sub-DAG.

## Depth / scope
**Your write domain is ONLY: Jacobian.tex, AbelJacobi.tex, Genus.tex.** Three
parallel dag-walkers own the other chapters (Cohomology/RiemannRoch; Rigidity;
Picard/Albanese) — do NOT edit those files.

Walk UP from the goal and transcribe into `\uses{}` the dependencies that the
prose of each spine node already names. Concretely, ensure these edges exist
(create only the `\uses{}` edge — every target label below already exists in
some chapter):

- `thm:exists_unique_ofCurve_comp` (AbelJacobi) `\uses` the extraction
  `lem:IsAlbanese_exists_unique_ofCurve_comp`, `def:ofCurve`,
  `thm:nonempty_jacobianWitness`, `def:Jacobian`.
- `def:ofCurve`, `lem:comp_ofCurve` (AbelJacobi) `\uses` the corresponding
  `def:IsAlbanese_ofCurve` / `lem:IsAlbanese_comp_ofCurve` and
  `thm:nonempty_jacobianWitness`.
- `def:Jacobian` (Jacobian) `\uses{def:JacobianWitness, thm:nonempty_jacobianWitness}`.
- The four Jacobian property theorems (`thm:Jacobian_grpObj`,
  `thm:Jacobian_smooth_genus` / `thm:smoothOfRelativeDimension_genus`,
  `thm:Jacobian_proper`, and the geometric-irreducibility one if present)
  `\uses{def:Jacobian, thm:nonempty_jacobianWitness}`.
- `thm:nonempty_jacobianWitness` `\uses{def:genusZeroWitness, def:positiveGenusWitness}`
  (its body case-splits on genus into these two arms).
- `def:genusZeroWitness` (Jacobian) `\uses` the genus-0 keystone
  `prop:rigidity_genus0_curve_to_AV` (lives in AbelianVarietyRigidity.tex —
  owned by the Rigidity walker; just add the edge), plus `def:JacobianWitness`,
  `def:genus`.
- `def:positiveGenusWitness` (Jacobian) `\uses` the positive-genus route heads
  `thm:fga_pic_representability` (Picard_FGAPicRepresentability.tex) and
  `thm:albanese_universal_property` (Albanese_AlbaneseUP.tex) — both owned by
  the Picard/Albanese walker; just add the edges — plus `def:JacobianWitness`,
  `def:genus`.
- `def:genus` (Genus.tex) currently has NO `\uses`. It is defined via the
  Riemann–Roch genus invariant: `\uses` the RR genus declaration(s) it depends
  on — `thm:riemannRoch_genus_zero` and/or
  `thm:euler_char_eq_deg_plus_one_minus_genus` and the `\(\ell\)`/H^0–H^1
  dimension defs they package (these live in RiemannRoch_RRFormula.tex, owned by
  the Cohom-RR walker; add the edge to the genus-defining RR head).
- `def:JacobianWitness`, `def:IsAlbanese`, and the extraction trio: complete
  their `\uses{}` to whatever Albanese/structure defs they actually reference
  WITHIN Jacobian.tex.

**Boundary rule:** when an edge points at a label in a chapter you do NOT own
(Rigidity, Picard, Albanese, Cohomology, RiemannRoch), add the `\uses{}` edge in
YOUR node's block and STOP — do not follow the cone into that chapter; the
parallel walker that owns it completes it. Record each boundary handoff in your
report's "Notes for dispatcher".

For any node in your three chapters that has a real statement block but no
`\lean{}` and is NOT a `\begin{remark}`, add a placeholder
`\lean{AlgebraicGeometry.TODO.<descriptive_snake_name>}` (integrity rule 1).

Do NOT add `\leanok`. Do NOT write new mathematical proofs — these spine nodes
are already proved-in-Lean by projection (note "Proved directly in Lean." where
a proof body is missing and effort is ∞). Your deliverable is `\uses{}`
transcription + placeholder pins.

## References
- None required — this is pure dependency transcription from prose already in
  Jacobian.tex / AbelJacobi.tex / Genus.tex. Do not invent new mathematics.
