# Blueprint Review Report

## Slug
av-rigidity-fastpath

## Iteration
157

## Scope note
HARD-GATE fast-path re-review (same-iter, post-writer). I deep-audited the two chapters edited
this iter — `AbelianVarietyRigidity.tex` (NEW, primary gate target) and `Jacobian.tex` (route-(c)
strip) — plus the `RigidityKbar.tex` doctor follow-ups. The remaining chapters were **not**
re-audited this round (unchanged since the iter-156 full audit); their verdicts carry forward.
The gate-relevant verdict is on the edited chapters.

## Top-level summaries

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{AlgebraicGeometry.rigidity_lemma}`: the target is
  **well-formulated** (signature resolves to the scaffolded decl; conclusion `∃ g, f = snd ≫ g`
  is a clean categorical encoding mirroring the established `RigidityKbar` idiom). The
  **difficulty is in the proof, not the formulation**: the verbatim Mumford proof is point-set
  (choose `x₀ ∈ X`, affine nbhd of `z₀`, `G = p₂(f⁻¹(F))` closed by completeness, fibrewise
  collapse), whereas the Lean statement is point-free / categorical. The prover must bridge
  "proper ⇒ projection is a closed map" and "proper connected → affine has constant image" to
  the `factors-through-snd` conclusion. This is a genuine but legitimate formalization task —
  the prose is detailed enough; it does not make the target "poor". `soon`, not must-fix.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All four `\lean{...}` hints resolve to the scaffolded decls in
    `AlgebraicJacobian/AbelianVarietyRigidity.lean`: `thm:rigidity_lemma`→`rigidity_lemma`,
    `prop:morphism_P1_to_AV_constant`→`morphism_P1_to_grpScheme_const`,
    `prop:genusZero_curve_iso_P1`→`genusZero_curve_iso_P1`,
    `thm:rigidity_genus0_curve_to_AV`→`rigidity_genus0_curve_to_grpScheme`. ✓
  - **`thm:rigidity_lemma` IS prover-ready** (the iter-158 lane target): verbatim Mumford
    statement (Form I) + full prose proof (properness/closed-map, Form I), `% SOURCE` +
    `% SOURCE QUOTE` + `% SOURCE QUOTE PROOF` + visible `\textit{Source:}` all present and
    verbatim-faithful. `rmk:rigidity_lemma_cube_free` correctly isolates the two ingredients
    (closed map; proper-connected→affine constant) and confirms cube-free / cohomology-free.
  - Headline `thm:rigidity_genus0_curve_to_AV` correctly describes the char-free statement
    `genusZeroWitness` consumes. **Signature-match verified against the Lean tree**:
    `rigidity_genus0_curve_to_grpScheme` is `rigidity_over_kbar` **verbatim minus `[CharZero
    kbar]`** — same `[IsAlgClosed kbar]`, same curve typeclasses (`SmoothOfRelativeDimension 1`,
    `IsProper`, `GeometricallyIrreducible`), same AV typeclasses, same conclusion
    `f = toUnit C ≫ η[A]`. The blueprint's claim is exact.
  - The other three blocks are **honestly scoped as deferred/blocked**:
    `thm:theorem_of_the_cube` carries no `\lean{}` target and is explicitly marked "deferred
    deep input, no formal proof"; `prop:morphism_P1_to_AV_constant` openly rests on the cube
    (with `rmk:cube_is_load_bearing` correcting the iter-156 "single ℙ¹ is cube-free" expectation
    — a notably honest correction); `prop:genusZero_curve_iso_P1` flagged as a Riemann–Roch
    sub-build (`rmk:genusZero_iso_subbuild`). `\uses` edges are correct
    (`prop:morphism_P1_to_AV_constant`→{`thm:rigidity_lemma`,`thm:theorem_of_the_cube`};
    `prop:genusZero_curve_iso_P1`→`def:genus` [resolves to Genus.tex];
    headline→{`prop:morphism_P1_to_AV_constant`,`prop:genusZero_curve_iso_P1`}).
  - Citation discipline intact on all four sourced blocks. `% SOURCE` parentheticals name
    `.pdf` files (not `.md`) with explicit PDF-page numbers — this is **justified, not a
    fabrication**: the writer's "References consulted" lists exactly these PDFs and explains the
    `.md` extractions mojibake the math symbols, so the rendered PDF images are the authoritative
    source actually read (Mumford pdf p.54/p.66, Milne pdf p.26, Hartshorne pdf p.314 — all
    match). Quotes are verbatim in original language/notation (Hartshorne's `\mathbf P^1`
    preserved). Headline theorem is Archon-original composition → correctly omits source lines.
  - The double label on the headline (`thm:` + `prop:rigidity_genus0_curve_to_AV`) is a
    deliberate alias for carry-over crefs — legal LaTeX, only the `thm:` form is referenced.
  - Local `\providecommand{\fatsemi}` is a safe no-op guard; writer flagged it for promotion.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Route-(c) duplicate subsection successfully stripped: the deleted labels
    `lem:rigidity_theorem`, `cor:complete_product_to_AV_decomp`, `lem:rational_map_to_AV_extends`,
    `prop:unirational_to_AV_constant` have **zero surviving references** anywhere in the
    blueprint. `thm:theorem_of_the_cube` / `prop:rigidity_genus0_curve_to_AV` now live **only**
    in the new chapter (single `\label` each). ✓
  - Genus-0 prose now consumes the upstream `thm:rigidity_genus0_curve_to_AV` (via
    `\cref{chap:AbelianVarietyRigidity}`) as the committed keystone, and references
    `thm:rigidity_over_kbar` only as the retained `[CharZero]`-carrying fallback-(a) artifact —
    exactly the intended redirection. All `\uses` edges to `thm:rigidity_genus0_curve_to_AV`
    (lines 310, 459, 464) resolve to the new chapter.
  - iter-155/156 carry-over corrections landed: uniqueness via epi-cancellation
    (`Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` + `cancel_epi`, explicitly NOT
    terminality) at `def:genusZeroWitness`; C.2.f descent honestly re-costed as a multi-iteration
    base-change sub-build (not ~2 lines); import-cycle honesty (AbelianVarietyRigidity upstream of
    Jacobian). Zero `% NOTE:` blocks remain — the stale ones were removed.
  - The only blueprint-wide dangling `\ref`/`\uses` targets (`ex:jac`, `rmk:Ablsch`,
    `lem:S3_*`) are all inside `%` comments or verbatim-quoted Kleiman source identifiers
    (`\textit{Source: ... Exercise (ex:jac)}` is plain parenthetical text, not `\ref{}`) — **not
    live cross-references**, pre-existing, and not introduced by this iter's strip.
  - Residual: Route A positive-genus arm remains sketch-level (`partial` at the route-detail
    granularity), but that is the ONLY residual — the genus-0 arm's blueprint is no longer the
    blocker. The chapter as a whole is complete+correct for its declared decls.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes** (doctor follow-ups — both resolved):
  - `% archon:covers` now uses full repo-root paths:
    `AlgebraicJacobian/RigidityKbar.lean AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. ✓
  - Carries the iter-157 STRATEGY NOTE redirecting the committed route to
    `chap:AbelianVarietyRigidity` and reframing this chapter as the fallback-(a) home
    (`df=0` / cotangent-triviality + Serre-duality + closed chart-algebra envelope). The
    route-mismatch the iter-157 review flagged is **resolved**: the chapter now honestly
    documents `rigidity_over_kbar` (which still carries `[CharZero]`) as the fallback artifact,
    not the committed keystone. `thm:rigidity_over_kbar` label intact and referenced from
    Jacobian.tex as the fallback.

### Other chapters (not re-audited this fast-path round)
`AbelJacobi.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`, `Cohomology_MayerVietoris.tex`,
`Cohomology_SheafCompose.tex`, `Cohomology_StructureSheafAb.tex`,
`Cohomology_StructureSheafModuleK.tex`, `Differentials.tex`, `Genus.tex`, `Rigidity.tex` —
unchanged this iter; verdicts carried from the iter-156 full audit. Cross-refs from the edited
chapters into these (`def:genus`, `thm:GrpObj_eq_of_eqOnOpen`, `def:IsAlbanese`,
`def:JacobianWitness`, `thm:nonempty_jacobianWitness`, etc.) all resolve.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - `AbelianVarietyRigidity.tex` / `\lean{rigidity_lemma}`: point-set proof prose vs categorical
    Lean target — the prover must translate "proper ⇒ closed projection" + "proper-connected →
    affine constant" into the `factors-through-snd` conclusion. Not a formulation defect; sets
    iter-158 prover expectations. Plan agent should scope the lane to `rigidity_lemma` ALONE.
- **informational**:
  - The new chapter's `% SOURCE` parentheticals cite `references/*.pdf` (with PDF-page numbers)
    rather than the `.md` convention. Intentional and justified (writer read rendered PDF images;
    `.md` mojibakes math symbols) — files exist and writer's consulted-list matches. No action
    needed; flagged so the plan agent knows the deviation is sanctioned.

## HARD-GATE lines (per gated chapter)

- **`AbelianVarietyRigidity.tex` — GATE CLEARS.** `complete: true`, `correct: true`, no
  must-fix finding touches it. The iter-158 prover lane on `AlgebraicGeometry.rigidity_lemma`
  may proceed. **Caveat for the plan agent**: scope the lane to `rigidity_lemma` ONLY — the
  sibling decls `morphism_P1_to_grpScheme_const` (blocked on the deferred theorem of the cube)
  and `genusZero_curve_iso_P1` (blocked on absent Riemann–Roch) are honestly deferred and a
  prover sent at them this iter would stall on unbuilt prerequisites.
- **`Jacobian.tex` — GATE CLEARS** (no prover lane targeted here this iter; route-(c) strip is
  clean, genus-0 arm no longer the blocker).
- **`RigidityKbar.tex` — GATE CLEARS** (doctor follow-ups resolved; fallback-(a) home, off the
  active prover path).

Overall verdict: `AbelianVarietyRigidity.tex` is `complete: true` + `correct: true` with no
must-fix — the gate clears for an iter-158 prover lane on `rigidity_lemma` (scoped to that decl
alone); the route-(c) strip and RigidityKbar doctor follow-ups are clean.
