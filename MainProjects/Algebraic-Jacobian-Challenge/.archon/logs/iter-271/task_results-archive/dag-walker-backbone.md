# DAG Walker Report

## Slug
backbone

## Seed
thm:exists_unique_ofCurve_comp

## Status
COMPLETE — the spine's real dependencies are transcribed; both goal cones now
reach the route heads of every sub-DAG, no broken edges, no cycles.

## Cone before → after
- Seed `thm:exists_unique_ofCurve_comp` ancestor cone: **6 → 28** nodes.
- Second goal `thm:Jacobian_smooth_genus`
  (`AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus`) ancestor cone:
  now **25** nodes (reaches all cross-chapter heads).
- ∞ holes introduced: 0 (no new statement blocks). broken `\uses`: **0 → 0**.
- blocks added: 0; proofs written: 0; placeholder `\lean{}` pins: 0 (every
  statement block in all three chapters already carries `\lean{}`).
- `\uses` edges added: ~34 across 15 nodes.

## Blocks added / proofs written
None. Per directive, this is pure `\uses{}` transcription — every spine node is
"Proved directly in Lean" by projection from the Albanese witness; no proof
bodies were authored and no statements were created.

## \uses edges added/fixed (the completeness fixes)

### AbelJacobi.tex
- `thm:exists_unique_ofCurve_comp` now also `\uses{def:Jacobian,
  lem:IsAlbanese_exists_unique_ofCurve_comp, thm:nonempty_jacobianWitness}`
  (was only `{def:ofCurve, def:IsAlbanese}`) — its Lean closure projects the
  universal-factorisation field of the Albanese witness supplied by
  `thm:nonempty_jacobianWitness` via the extraction lemma.
- `def:ofCurve` now also `\uses{def:IsAlbanese_ofCurve}` — `α_P := ι_P` is the
  universal-morphism projection (Def `def:IsAlbanese_ofCurve`).
- `lem:comp_ofCurve` now also `\uses{lem:IsAlbanese_comp_ofCurve}` — its pointed
  property is the projection of the extraction lemma `comp_ofCurve`.

### Jacobian.tex
- `def:IsAlbanese_ofCurve` now `\uses{def:IsAlbanese}` (new edge).
- `lem:IsAlbanese_comp_ofCurve` now `\uses{def:IsAlbanese, def:IsAlbanese_ofCurve}`.
- `lem:IsAlbanese_exists_unique_ofCurve_comp` now
  `\uses{def:IsAlbanese, def:IsAlbanese_ofCurve}`.
- `thm:IsAlbanese_unique` now `\uses{def:IsAlbanese, def:IsAlbanese_ofCurve}`
  (its statement compares the two universal morphisms).
- `thm:Jacobian_grpObj` now `\uses{def:Jacobian, thm:nonempty_jacobianWitness}`.
- `thm:Jacobian_smooth_genus` now
  `\uses{def:Jacobian, def:genus, thm:nonempty_jacobianWitness}` (statement is
  "smooth of relative dimension g(C)", so `def:genus` is a genuine dependency).
- `thm:Jacobian_proper` now `\uses{def:Jacobian, thm:nonempty_jacobianWitness}`.
- `thm:Jacobian_geomIrred` now `\uses{def:Jacobian, thm:nonempty_jacobianWitness}`.
- `thm:nonempty_jacobianWitness` now
  `\uses{def:JacobianWitness, def:genusZeroWitness, def:positiveGenusWitness}`
  — its Lean body is `by_cases h : genus C = 0`, delegating to the two arms; the
  conclusion type is `JacobianWitness`. (Heeded the in-file iter-149 cycle-fix
  NOTE: did **not** add `def:Jacobian` here, which would re-create the
  `def:Jacobian ↔ thm:nonempty_jacobianWitness` 2-cycle that crashes plastex.
  Verified the three targets do not depend back on this theorem — no cycle.)
- `def:genusZeroWitness` now `\uses{def:JacobianWitness, def:IsAlbanese,
  def:genus, prop:rigidity_genus0_curve_to_AV}` — trivial-`Spec k` witness whose
  `isAlbaneseFor` field is built by descent from the genus-0 rigidity keystone.
- `def:positiveGenusWitness` now `\uses{def:JacobianWitness, def:genus,
  thm:fga_pic_representability, thm:albanese_universal_property}` — Route-A
  Picard-scheme construction.

### Genus.tex
- `def:genus` now `\uses{def:Scheme_HModule, def:Scheme_toModuleKSheaf}` — see
  the deviation note below.

## Deviation from directive (mathematically corrected edge)

The directive asked `def:genus` to `\uses` the Riemann–Roch heads
`thm:riemannRoch_genus_zero` / `thm:euler_char_eq_deg_plus_one_minus_genus`. I
did **not** add those edges, because that direction is backwards and would
create a cycle:

- `def:genus` is defined *cohomologically*:
  `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`,
  i.e. `dim_k H¹(C, O_C)`. Its real dependencies are the cohomology
  constructions `def:Scheme_HModule` and `def:Scheme_toModuleKSheaf` (both in
  Cohomology_StructureSheafModuleK.tex).
- `thm:euler_char_eq_deg_plus_one_minus_genus` is the RR identity
  `χ(O_C(D)) = deg D + 1 − g`, which itself *contains and uses* the genus `g`.
  So the honest edge is RR → genus, not genus → RR. Likewise
  `thm:riemannRoch_genus_zero` is a downstream consequence. Adding the directive
  edge would point `def:genus` at nodes that already depend on it
  (completeness condition 3 forbids over/backwards declaration; it would also
  introduce a cycle).

Net effect is the same as the directive's stated *goal*: the genus node is now
connected to the route head of the sub-DAG it actually lives in (the Cohomology
H¹ construction), so the goal cone reaches that sub-DAG's head. The RR↔genus
edge, if desired, belongs in the RR nodes' `\uses` and is the Cohom-RR walker's
to add (boundary handoff below).

## Could not complete (genuine gaps — strategy items)
None opened by this walk. The two deferred bodies remain the project's known
gaps (unchanged, not my domain to prove): `def:genusZeroWitness` (gated on
`prop:rigidity_genus0_curve_to_AV`, effort ≈ 6183 in the Rigidity sub-DAG) and
`def:positiveGenusWitness` (gated on Route A / `thm:fga_pic_representability`,
≈ 2939). These are correctly surfaced now that the edges exist.

## References consulted
None — pure dependency transcription from prose already in the three chapters.

## Notes for dispatcher

### Boundary handoffs (edge added in my node; cone NOT followed into the foreign chapter)
- `def:genusZeroWitness` → **`prop:rigidity_genus0_curve_to_AV`**
  (AbelianVarietyRigidity.tex — **Rigidity walker**). This is the genus-0
  keystone; its sub-cone (rigidity lemma chain, `prop:morphism_P1_to_AV_constant`,
  `thm:genus_zero_curve_iso_p1`, …) is the Rigidity walker's to complete.
- `def:positiveGenusWitness` → **`thm:fga_pic_representability`**
  (Picard_FGAPicRepresentability.tex — **Picard/Albanese walker**) and
  **`thm:albanese_universal_property`** (canonical copy in Albanese_AlbaneseUP.tex
  — **Picard/Albanese walker**).
- `def:genus` → **`def:Scheme_HModule`** and **`def:Scheme_toModuleKSheaf`**
  (Cohomology_StructureSheafModuleK.tex — **Cohomology/RiemannRoch walker**).
  Also: the RR heads `thm:euler_char_eq_deg_plus_one_minus_genus` /
  `thm:riemannRoch_genus_zero` should `\uses{def:genus}` from *their* side
  (RR uses the genus); that edge is the Cohom-RR walker's, not mine.

### ⚠ Duplicate label — needs cross-chapter resolution
`thm:albanese_universal_property` is defined **twice**, both as full statement
blocks:
- `blueprint/src/chapters/Jacobian.tex:519` (Milne III Prop 6.1, full sourced
  proof block; `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}`) — in MY chapter.
- `blueprint/src/chapters/Albanese_AlbaneseUP.tex:99` — the directive's named
  canonical home.

I did **not** delete either copy: the Jacobian.tex copy is a substantial block
with a `% SOURCE`/`% SOURCE QUOTE PROOF` citation apparatus and a Milne III §6
dependency audit, and removing it is a cross-chapter coordination call (the
Picard/Albanese walker owns the canonical copy). LaTeX will emit a
"multiply-defined label" warning and plastex/`\cref`/`\uses` will resolve to one
copy nondeterministically. **Recommend**: pick the Albanese_AlbaneseUP.tex copy
as canonical and demote the Jacobian.tex block to a `\begin{remark}` (or a
`\cref` pointer), preserving its sourced proof text. My
`def:positiveGenusWitness \uses{thm:albanese_universal_property}` edge resolves
either way.

### No new macros needed; all three chapters remain valid LaTeX (balanced
braces in every added `\uses{}`).
