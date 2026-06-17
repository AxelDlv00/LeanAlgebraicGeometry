# Blueprint Review Report

## Slug
iter151

## Iteration
151

## Directive answers (up front)

1. **`RigidityKbar.tex` clean for the `ChartAlgebra.lean` (KDM) prover lane?**
   PARTIAL. The iter-150 render-fix **holds**: the iter-150 blueprint-doctor
   (post render-fix) reports zero structural findings, every `\ref`/`\uses`
   resolves, and the three S3 Stacks tags inside `RigidityKbar.tex` itself were
   corrected (035U+04QM, 0BUG, 030K, 00T7 — see the render-fix `% NOTE` blocks
   at L2002–2116, L2328–2360). HOWEVER the KDM block
   `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` — the chapter
   for the active `ChartAlgebra.lean` lane — has its **first-class proof prose
   describing routes (p1 char-p) and (p2 = BR.1–BR.5, char-0 via
   `Differential.ContainConstants`), while the actual Lean body has pivoted to
   HYBRID route (C)** (MvPolynomial joint-kernel-collapse + `SubmersivePresentation`
   lift + `KaehlerDifferential.map_D`), which is documented **only in a `% NOTE`
   comment** (L2278–2324), not in first-class blueprint prose. The residual
   `sorry` the prover is actually working — the "(C.e) transfer step" — lives on
   route (C), not on "(BR.5)" as the directive's framing assumes. The embedded
   NOTE itself and the iter-150 `lean-vs-blueprint-checker` already flagged this
   as a must-fix divergence and recommend the writer add a first-class **(BR.5')**
   sub-block. → `complete: partial` for that block; see HARD GATE note below.

2. **`AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` clean?**
   NO — `correct: partial`. The 3 carried-over wrong Stacks tags are **still
   present** in the bullet list: **`0334`** (L41, should be `035U`), **`0BJF`**
   (L46, should be `0BUG`), **`05DH`** (L52, should be `030K`). The L60–72
   `% NOTE` acknowledges this and states the canonical `RigidityKbar.tex` was
   already corrected but this pointer chapter was out of the render-fix writer's
   write-domain. Since this chapter is the per-file chapter for the actively-proven
   `ChartAlgebraS3.lean`, this is **must-fix-this-iter**.

3. **Declarations lacking a citation block (seeds the citation-writer; prioritised
   `RigidityKbar.tex` + `Jacobian.tex`).** See `### Citation discipline` below.
   Note: the project uses **no** strict `% SOURCE:` / `% SOURCE QUOTE:` /
   `\textit{Source:}` four-element format anywhere. The chart-algebra piece (ii)
   of `RigidityKbar.tex` is the best-cited region (`\emph{Literature.}` blocks with
   specific tags + lemma numbers); the Albanese/Jacobian declarations and the
   `RigidityKbar.tex` main theorem + piece (i) carry only loose in-prose mentions.

4. **Broken `\uses` / `\ref` / orphan labels?** None. iter-150 blueprint-doctor
   clean; I re-confirmed the cross-file pointer labels from the two pointer chapters
   (`lem:GrpObj_omega_restrict_to_identity_section`, `lem:GrpObj_mulRight_globalises`,
   `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`)
   all resolve in `RigidityKbar.tex`, and the KDM `\uses` chain resolves.

## Top-level summaries

### Incomplete parts
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  (KDM, active `ChartAlgebra.lean` lane): the active Lean strategy (HYBRID route
  (C)) is **not** present in first-class prose — only the abandoned (p2/BR.5)
  `ContainConstants` route and the (p1) char-p route are. A prover directed to
  "the BR.5 transfer step" per the blueprint is pointed at a route the Lean
  dropped. Writer should add a first-class **(BR.5')** route-(C) sub-block
  (MvPolynomial `_mvPoly_mem_range_C_of_D_eq_zero` collapse → `SubmersivePresentation`
  `.out` lift → `KaehlerDifferential.map_D` reduction → residual transfer step,
  with the two iter-151+ closure paths (S5.a) `ker_map_of_surjective` unfolding
  vs (S5.b) `FormallySmooth.subsingleton_h1Cotangent`).

### Proofs lacking detail
- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  Step 3.aux: the 2-chart-cover-with-affine-intersection existence leans on
  "Stacks Tag 0F8L" + a normality argument sketched at prose level only
  ("if the project does not already expose a `Scheme.affineCover_card_two`-shape
  lemma … lands as a thin wrapper, ~20–40 LOC"). Adequate for the *current*
  thin-wrapper Lean disposition (the lemma is a one-line delegate to KDM per the
  iter-148 `% NOTE`), but under-specified for the iter-149+ substantive
  refinement that will actually run Step 3. Soon, not blocking.

### Citation discipline
Strict `% SOURCE QUOTE:` verbatim blocks are absent project-wide (the plan agent
already knows this and is dispatching the citation writer). Declarations that
derive from an external source but **lack any citation block** (loose in-prose
mention only), to seed the writer — **prioritised**:

`RigidityKbar.tex`:
- `thm:rigidity_over_kbar` — derives from Mumford, *Abelian Varieties*, Ch. II §4
  (rational curves on abelian varieties). Only a `% NOTE` informal pointer
  (L18–24); no citation block, no lemma-precise reference before the statement.
- `lem:GrpObj_cotangentSpace`, `lem:GrpObj_lieAlgebra_finrank`,
  `lem:GrpObj_cotangent_bridge` (piece (i)): cite Stacks 02G1 / Hartshorne II.8 /
  EGA only inline in proof prose; no citation block. (Several are project-bespoke
  Lie-algebra-of-GrpObj constructions — for those, omitting a source is correct;
  flag only the bridge's `k⊗_R Ω ≅ 𝔪/𝔪²` step, which is Stacks 02G1 / Hartshorne
  II.8 and should carry a block.)

`Jacobian.tex` (directive-prioritised; none of these carry a citation block —
all references are loose in-prose):
- `def:IsAlbanese` — Albanese universal property; classical (Serre/Lang,
  Albanese variety). No source named at the definition.
- `thm:nonempty_jacobianWitness` — Route A cites "FGA 232", "Hartshorne III.4",
  "FGA Explained Ch. 9"; Route B cites "Milne, *Abelian Varieties*, Ch. III";
  genus-0 sub-case cites "Mumford Ch. II §4, Proposition" — all in prose, none in
  a citation block with the verbatim statement.
- `thm:Jacobian_proper`, `thm:Jacobian_smooth_genus`,
  `thm:Jacobian_geomIrred` — proofs invoke FGA Explained Ch. 9 / deformation
  theory of Pic; no citation block.
- `def:genusZeroWitness`, `def:positiveGenusWitness` — Route A / rigidity prose
  only.

Lower priority (not active lanes this iter):
- `Genus.tex` / `def:genus` — Hartshorne IV §1 in a `% NOTE` only; Serre
  finiteness backing referenced loosely.
- `Differentials.tex` / `thm:smooth_locally_free_omega` and the M4–M8 remarks —
  Stacks 02G1, 009H, 01UV, 0FVU, Hartshorne II.8/II.5/III.7 cited in prose, no
  block. (This chapter's inline references are specific and `[verified]`-tagged;
  lowest priority.)

**Dangling local-file pointers (separate finding).** The `% NOTE` render-fix
audit comments cite local files that **do not exist on disk**:
`references/stacks-0334.md`, `references/stacks-0BJF.md`,
`references/stacks-05DH.md`, `references/stacks-0BUG.md`,
`references/stacks-07F4.md`, `references/hartshorne-ag.md`,
`references/literature-crosscheck-iter149.md` (cited in `RigidityKbar.tex`
L2076/L2190 etc. and `ChartAlgebraS3.tex` L70–72). `references/` actually holds
bundled `stacks-{algebra,coherent,fields,varieties}.tex`, `summary.md`, and the
Kleiman/Nitsure PDFs — no per-tag `.md` files. The directive itself relies on
`references/stacks-0334.md` existing; it does not. The citation writer this iter
should point verbatim blocks at the bundled `.tex` files (e.g. the
"Geometrically reduced schemes" section of `stacks-varieties.tex` for 035U),
and the dangling `references/*.md` pointers should be corrected or dropped.
NB: the bundled Stacks `.tex` use semantic `\label{}`s, not tag numbers, so the
035U/0BUG/030K/00T7 tag *numbers* in the blueprint cannot be machine-verified
against the local files by number — the writer must map tag→section by hand.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:Scheme_AffineCoverMVSquare_corners` carries no `\lean{...}` hint (the
    four per-corner `_X₁…_X₄` lemmas right after it do). Informal corner lemma;
    fine, but worth a `\lean` if it is ever consumed. Informational.
  - Producer classes `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` honestly
    documented as unproduced; downstream results are conditional. Acceptable
    project disposition, parallel to `nonempty_jacobianWitness`.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
(Scheme-level `thm:GrpObj_eq_of_eqOnOpen` is well-formed and Mathlib-backed via
`ext_of_isDominant_of_isSeparated'`; consumer of the active lift lemma.)

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:smooth_locally_free_omega` (load-bearing forward Jacobian criterion
    consumed by piece (i)/(ii)) is precisely stated with a verified 5-piece Mathlib
    closure list. Clean.
  - Citation: inline Stacks/Hartshorne references only, no block (low priority).

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
(All blocks close by projection from the Albanese structure; citation in
remarks is loose but these are Pic-route *remarks*, not the formalised path.)

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; accurately lists the post-iter-145 GrpObj.lean declarations and
the excised bundled-route names. Cross-ref `lem:GrpObj_omega_restrict_to_identity_section`
resolves.)

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Citation: `def:genus` derives from Hartshorne IV §1; only a `% NOTE` pointer.
    Soon (not an active lane).

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Mathematically complete and correct; `nonempty_jacobianWitness` honestly
    framed as the single foundational existence gap (Route A FGA), with
    `genusZeroWitness` / `positiveGenusWitness` as honestly-deferred scaffolds.
    No 2-cycle (the iter-149 `% NOTE` records the `\uses` de-cycling).
  - Citation: core declarations (`def:IsAlbanese`, `thm:nonempty_jacobianWitness`,
    the four protected instances, both witness scaffolds) lack citation blocks —
    see `### Citation discipline`. Directive-prioritised for the writer; **soon**
    (not an active prover lane this iter, so not a HARD GATE blocker).

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Render-fix HOLDS: structurally clean (blueprint-doctor), all refs resolve,
    in-chapter S3 tags corrected to 035U+04QM / 0BUG / 030K / 00T7.
  - KDM block `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
    (active `ChartAlgebra.lean` lane): first-class prose describes the abandoned
    (p2 = BR.1–BR.5) `ContainConstants` route + the (p1) char-p route; the live
    Lean route HYBRID (C) is only in a `% NOTE`. **complete: partial** for this
    block. Add a first-class **(BR.5')** route-(C) sub-block this iter (already
    recommended by the embedded NOTE + iter-150 lean-vs-blueprint-checker).
  - Math is sound throughout (no wrong steps); the (β-core) Step-3 chart-Čech
    invocation of `H⁰(C,Ω^{⊕g})=0` is honestly reconciled with the
    "no named Serre duality" disclaimer (Q3 honesty note).
  - Citation: `thm:rigidity_over_kbar` + piece (i) bridge lack citation blocks;
    chart-algebra piece (ii) S3/KDM/constants lemmas DO carry `\emph{Literature.}`
    blocks (good). Dangling `references/*.md` pointers — see top-level finding.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **3 wrong Stacks tags still present** in the bullet list: `0334` (L41 →
    `035U`), `0BJF` (L46 → `0BUG`), `05DH` (L52 → `030K`). Canonical
    `RigidityKbar.tex` already corrected; this pointer chapter was out of the
    render-fix writer's write-domain (L60–72 `% NOTE` acknowledges). Feeds the
    active `ChartAlgebraS3.lean` lane → **must-fix-this-iter**.
  - The L70–72 NOTE also cites non-existent `references/stacks-0334.md` /
    `stacks-0BJF.md` / `stacks-05DH.md` (see dangling-pointer finding).

## Severity summary

- **must-fix-this-iter**
  1. `ChartAlgebraS3.tex`: wrong Stacks tags `0334`/`0BJF`/`05DH` (L41/46/52) →
     `035U`/`0BUG`/`030K`. `correct: partial`, chapter feeds the active
     `ChartAlgebraS3.lean` prover lane. Dispatch the blueprint-writer to apply the
     three substitutions and mirror the `RigidityKbar.tex` render-fix `% NOTE`s.
  2. `RigidityKbar.tex` KDM block (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`):
     `complete: partial` — active Lean route (HYBRID C) absent from first-class
     prose; only abandoned (BR.5)/(p1) routes are written. Feeds the active
     `ChartAlgebra.lean` lane. Writer should add a first-class **(BR.5')** route-(C)
     sub-block. **Plan-agent judgement call:** the Lean source carries thorough
     inline (C.a)–(C.e) documentation, so the plan agent may elect to keep the
     `ChartAlgebra.lean` lane live (the prover reads the Lean, not just the
     blueprint) while the writer lands (BR.5') in parallel; but per the literal
     HARD GATE the KDM block is `complete: partial` and the safe action is to fold
     (BR.5') into the citation-writer's directive this iter.

- **soon**
  - Missing citation blocks on `Jacobian.tex` core declarations + `RigidityKbar.tex`
    `thm:rigidity_over_kbar`/piece (i) bridge + `Genus.tex`/`Differentials.tex`
    (directive's citation writer this iter; prioritise `RigidityKbar.tex` +
    `Jacobian.tex`).
  - Dangling `references/*.md` pointers in `% NOTE` comments (files absent on
    disk; real material is bundled `stacks-*.tex`). The citation writer should
    retarget to the bundled `.tex` and the planner should be aware the directive's
    own `references/stacks-0334.md` pointer does not resolve.

- **informational**
  - `lem:Scheme_AffineCoverMVSquare_corners` (MayerVietoris) has no `\lean` hint.
  - `RigidityKbar.tex` `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
    Step 3.aux 2-chart-cover existence under-specified for the iter-149+ substantive
    refinement (fine for the current thin-wrapper Lean body).

Overall verdict: render-fix holds and the blueprint is structurally clean, but
both active-lane chapters carry a must-fix this iter — `ChartAlgebraS3.tex` has 3
stale wrong Stacks tags (`correct: partial`) and `RigidityKbar.tex`'s KDM block is
`complete: partial` because the live Lean route (HYBRID C) is not yet first-class
prose — so neither active prover lane is unconditionally gate-cleared until a
blueprint-writer round (which is already being dispatched for citations) lands the
tag fixes and the (BR.5') route-(C) sub-block.
