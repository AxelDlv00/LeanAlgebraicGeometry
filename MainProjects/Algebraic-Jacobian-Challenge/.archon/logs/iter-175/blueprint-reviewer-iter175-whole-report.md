# Blueprint Review Report

## Slug
iter175-whole

## Iteration
175

## Top-level summaries

### Incomplete parts
- `AbelianVarietyRigidity.tex` (chart-glue scaffold subsection,
  `\subsection*{Scaffolds for the body of $\sigma_\times = \mathtt{gmScalingP1}$ ...}`,
  L1268 onward): the two iter-174-landed Lean helpers
  `AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap` and
  `AlgebraicGeometry.gmScalingP1_chart_PLB_eq` (renamed under the iter-175
  G0BO refactor to live in `Genus0BaseObjects/ChartIso.lean` and
  `Genus0BaseObjects/GmScaling.lean`) are **not** pinned by any
  `\lean{...}` block in the chapter. The iter-175 plan-phase dispatched
  `blueprint-writer g0bo-helper-pins` at 05:12:22 against this exact gap,
  but the writer's `dispatch_end` is not in `dispatch.jsonl` and
  `task_results/blueprint-writer-g0bo-helper-pins.md` does not exist on
  disk at the time of this review. The grep confirms zero matches for
  `homogeneousLocalizationAwayIso_algebraMap` and
  `gmScalingP1_chart_PLB_eq` anywhere in
  `AbelianVarietyRigidity.tex`. **Must-fix-this-iter** because both pins
  are load-bearing for the chart-bridge prover lane targeting the
  `gmScalingP1` body which is on the genus-0 critical path.

- `RiemannRoch_WeilDivisor.tex` (`def:divisor_closed_point`, L300--L341;
  `def:order_at_point`, L256--L296): the iter-175 plan-phase dispatched
  `blueprint-writer weildivisor-doc-updates` at 05:12:26 against two
  precise gaps:
  1. The "Lean signature scope" paragraph of `def:divisor_closed_point`
     (currently L330--L340) still describes the **old**
     typeclass-threaded "promotion in proof body" plan rather than the
     iter-174 junk-branch convention actually adopted by the Lean
     (`if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0`).
  2. No `\lean{...}` blocks for the iter-174 bridge-equation lemmas
     `Scheme.WeilDivisor.ofClosedPoint_eq_single` and
     `Scheme.WeilDivisor.ofClosedPoint_eq_zero` have been added; grep
     confirms zero matches anywhere in the chapter.
  3. The `def:order_at_point` block has no "Lean signature scope"
     paragraph at all (no Mathlib-API pinning, no junk-on-`f = 0`
     convention, no recipe from the analogist
     `mathlib-analogist-dvr-rationalmap-order` which already completed
     at 05:15:43 and whose recipe should be incorporated).
  The writer's `dispatch_end` is not in `dispatch.jsonl` and
  `task_results/blueprint-writer-weildivisor-doc-updates.md` does not
  exist at the time of this review. **Must-fix-this-iter** because RR.1
  feeds two active downstream lanes: the iter-175 `RationalMap.order`
  body lane on the Lane D side and A.4.a's codim-1 Weil-divisor surface
  API on Route A.

- `Picard_RelativeSpec.tex` (multiple `\leanok` markers): the
  iter-173 NOTE blocks on `thm:relative_spec_univ` (L156--L165),
  `thm:relative_spec_affine_base` (L235--L244),
  `thm:relative_spec_functorial` (L374--L384) explicitly admit the
  iter-173 file-skeleton encodes weaker forms (the universal property
  as a bare `IsAffineHom (structureMorphism 𝒜)` rather than the
  natural-bijection statement; the affine-base equivalence as
  `IsAffine ((Spec R).RelativeSpec 𝒜)` rather than the named iso to
  `Spec(Γ(X, 𝒜))`; the functor as a bare `QcohAlgebra → Over X` object
  function rather than a categorical `Functor`). Yet the chapter carries
  `\leanok` on each statement line (L156, L235, L374) and on the
  associated proof bodies (L143, L432). This is **stale-leanok drift**
  under the project's `\leanok` convention (`\leanok` on a statement =
  "declaration is formalized to at least a `sorry`"; on a proof =
  "proof closed, no sorry"). The NOTE prose explicitly admits the
  formalisation is materially weaker than the pinned statement, which
  ought to surface as a `\notready` rather than `\leanok`. Flagged as
  **must-fix-this-iter** under the chapter-coverage HARD GATE because
  any prover lane targeting `RelativeSpec` Lean declarations would
  consume a statement the chapter falsely claims is formalised.

### Lean difficulty quality
- `Picard_FGAPicRepresentability.tex` / `def:rel_pic_etale_sheafification`
  (L301-L348 of `Picard_RelPicFunctor.tex`) **shares** the Lean target
  `AlgebraicGeometry.Scheme.PicScheme` with
  `Picard_FGAPicRepresentability.tex` / `def:pic_scheme` (L487-L508).
  Two distinct mathematical objects (the étale-sheafified functor on
  one hand; the representing scheme equipped with the abelian-group
  structure on the other) collide on a single Lean identifier. The two
  chapters' `\lean{...}` hints will produce ambiguous prover targets
  unless renamed (e.g., `AlgebraicGeometry.Scheme.PicSharpEt` for the
  sheafified functor; `AlgebraicGeometry.Scheme.PicScheme` reserved for
  the representing scheme). Soon-severity because neither chapter has an
  active prover lane yet, but the renaming should be settled before
  either file opens.

### Citation discipline
- `Albanese_AlbaneseUP.tex` / `def:symmetric_power_curve` (L229--L273):
  the freshly-landed iter-175 Sym^g block carries an empty `\uses{}`
  (L232). Mathematically defensible (a primitive scheme-construction
  definition with no internal dependencies inside the chapter), but the
  blueprint-doctor's empty-uses rule was the trigger that opened the
  parallel `fgapic-empty-uses-fix` writer dispatch; the same rule will
  flag this annotation. Informational --- the writer can either delete
  the empty `\uses{}` line or populate it with the surrounding
  ambient-categorical inputs (e.g., `def:over_specbar_category`,
  `def:fin_symm_action` if/when they are introduced in a later
  Sym^g-construction chapter). Not gating any prover lane.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - missing — 2 helper pins (`homogeneousLocalizationAwayIso_algebraMap`,
    `gmScalingP1_chart_PLB_eq`) that the iter-175
    `blueprint-writer g0bo-helper-pins` is contracted to add. Writer is
    in flight as of review time; no report on disk. (Same-iter fast-path
    re-review is the appropriate remediation once the writer lands.)
  - observation — the chapter is the consolidated home of
    `AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, the four
    G0BO sub-files (`BareScheme.lean`, `ChartIso.lean`, `Points.lean`,
    `GmScaling.lean` per the iter-175 `refactor-g0bo-split` report), and
    `RigidityLemma.lean`. The `% archon:covers` header (L3) is current
    and lists all seven Lean files; the prose otherwise correctly tracks
    the post-split file layout.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - observation — the iter-175 a4d-sym-g writer dispatch landed at
    05:27:33 and the chapter has been refactored end-to-end per the
    directive: the moduli sub-lemmas (Poincaré-bundle pullback, moduli
    classifier of a trivialised line bundle, autoduality polarisation)
    are removed from the active dependency graph and recorded only in
    the `% NOTE: Alternative route history` block at L793--L837; the
    three new Sym^g sub-lemmas `def:symmetric_power_curve` (L229--L273),
    `lem:symmetric_product_av_map` (L300--L329),
    `lem:symmetric_product_to_jacobian` (L363--L410), and the descent
    lemma `lem:descent_through_birational_sigma` (L468--L496) are pinned
    with full `\lean{...}` targets and proofs. The main theorem's
    `\uses{}` at L99--L102 cites the four new sub-lemmas plus
    `thm:rational_map_to_av_extends` (A.4.c). HARD GATE clears.
  - observation — `def:symmetric_power_curve` carries an empty `\uses{}`
    (L232). Permissible for a primitive scheme construction; flagged
    above under "Citation discipline" as informational.
  - observation — the chapter explicitly documents the missing Mathlib
    `Sym^g`-of-scheme construction and recommends a `\notready` marker
    on the Lean target until the sub-build lands (L277--L289, L666--L674,
    L754--L762). This is precisely the form a downstream-blocked
    blueprint should take.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - observation — the iter-175 plan-phase fgapic-empty-uses-fix writer's
    output is reflected in the on-disk file: grep for `\uses{}` (with
    literal empty braces) returns zero matches inside declaration
    blocks; the only remaining `\uses{}` strings are in prose mentions
    (L11, L619, L640) of the syntax itself. The blueprint-doctor's
    empty-uses flag for this chapter is closed.
  - observation — naming clash with `Picard_RelPicFunctor.tex`
    flagged above under "Lean difficulty quality"
    (`AlgebraicGeometry.Scheme.PicScheme` is over-loaded).

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - observation — Lean naming drift on `def:rel_pic_etale_sheafification`
    (L303 pins `AlgebraicGeometry.Scheme.PicScheme`, the same identifier
    that `Picard_FGAPicRepresentability.tex` reserves for the
    representing scheme). Flagged under "Lean difficulty quality" above;
    soon-severity (no active prover lane).

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - wrong — stale `\leanok` markers on theorem statements and proofs
    whose Lean encoding the chapter's iter-173 NOTE prose explicitly
    admits is weaker than the pinned form. Specifically:
    `thm:relative_spec_univ` (L156, L143 of the antecedent proof,
    NOTE at L161--L165),
    `thm:relative_spec_affine_base` (L235, NOTE at L239--L244),
    `thm:relative_spec_functorial` (L374, L434, NOTE at L379--L384).
    The chapter falsely claims these are formalised when the iter-173
    file-skeleton in fact encodes only weaker statements (object-level
    function rather than `Functor`; `IsAffineHom` rather than the
    natural-bijection witness; etc.). Must-fix-this-iter even though
    no prover lane is currently active on these declarations, because
    the next plan-phase will mistakenly read these `\leanok` markers
    as a green-light to dispatch consumer provers.
  - observation — the directive's known-issues block already flagged
    L127 / L418 for `sync_leanok` investigation. The full list of
    affected `\leanok` markers in this chapter is wider than two; the
    `sync_leanok` walker should be allowed to settle every one of them
    against the current Lean state, not only the two named.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - observation — the iter-175 `rr-broken-uses-fix` writer's Branch-A
    edit (alias `\label{cor:nonconstant_function_genus_zero}` inserted
    in `RiemannRoch_OCofP.tex` at L488 immediately after the existing
    `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`) is on
    disk. The two `\uses{cor:nonconstant_function_genus_zero}` sites
    in this chapter (L334 inside the theorem block, L379 inside its
    proof) now resolve. HARD GATE clears for the RR.4 file-skeleton
    lane.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - missing — the iter-175 weildivisor-doc-updates writer is contracted
    to (i) rewrite the L330--L340 "Lean signature scope" paragraph of
    `def:divisor_closed_point` to document the iter-174 junk-branch
    convention on `Scheme.WeilDivisor.ofClosedPoint`; (ii) pin the
    bridge-equation lemmas `ofClosedPoint_eq_single` /
    `ofClosedPoint_eq_zero`; (iii) add a Lean-signature-scope paragraph
    to `def:order_at_point` integrating the
    `mathlib-analogist-dvr-rationalmap-order` recipe. None of these are
    on disk: grep confirms zero matches for `ofClosedPoint_eq_single`
    and `ofClosedPoint_eq_zero` anywhere in the chapter, and the
    L330--L340 paragraph still has the pre-iter-174 wording. The
    writer is in flight; no report on disk. (Same-iter fast-path
    re-review applies once the writer lands.)

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Cross-chapter notes

- `\lean{AlgebraicGeometry.Scheme.PicScheme}` is pinned by two distinct
  definitions: `def:rel_pic_etale_sheafification` in
  `Picard_RelPicFunctor.tex` (the étale-sheafified relative Picard
  functor, target category `Ab`) and `def:pic_scheme` in
  `Picard_FGAPicRepresentability.tex` (the abelian-group-scheme that
  *represents* it). Resolution: rename one of them. The
  representability `theorem` (`thm:fga_pic_representability`,
  `\lean{AlgebraicGeometry.Scheme.PicScheme.representable}`) reads
  most naturally as "the scheme `PicScheme` represents the functor
  `PicSharpEt`", so the proposed rename is to keep
  `PicScheme` on the FGA side and rename `def:rel_pic_etale_sheafification`'s
  Lean pin to `AlgebraicGeometry.Scheme.PicSharpEt` (or similar). The
  plan agent should pick the convention before either file opens.

- The Sym^g infrastructure named in `Albanese_AlbaneseUP.tex`
  (`def:symmetric_power_curve`, `lem:symmetric_product_av_map`,
  `lem:symmetric_product_to_jacobian`,
  `lem:descent_through_birational_sigma`) has no on-disk Lean file or
  blueprint home outside this chapter. The chapter's "Mathlib status"
  callout at L277--L289 names the construction as a project-side
  sub-build (Spec of `(A^{\otimes g})^{S_g}` glued along the open cover
  of `C`, following Milne III.3 Prop 3.1 / Mumford II.7+III.11). If
  Sym^g is to become a real prover lane in the next few iters, a
  dedicated chapter (e.g., `Picard_SymmetricPowerCurve.tex`) is the
  right shape; for now the in-chapter pin + `\notready` annotation
  is correct and Sym^g remains gated.

## Severity summary

Apply rules verbatim.

- **must-fix-this-iter**:
  - `AbelianVarietyRigidity.tex` is `complete: partial` — 2 missing
    helper pins (g0bo-helper-pins writer dispatched; not yet landed at
    review time).
  - `Picard_RelativeSpec.tex` is `correct: partial` — stale `\leanok`
    drift on multiple theorem statements / proofs whose Lean encoding
    is materially weaker than the chapter pins.
  - `RiemannRoch_WeilDivisor.tex` is `complete: partial` — three
    documentation gaps (junk-branch paragraph, two missing bridge
    pins, RationalMap.order signature scope) per the
    weildivisor-doc-updates directive; writer dispatched, not yet
    landed at review time.

- **soon**:
  - `AlgebraicGeometry.Scheme.PicScheme` Lean-name collision between
    `def:rel_pic_etale_sheafification` and `def:pic_scheme` —
    cross-chapter rename before either file opens.

- **informational**:
  - `Albanese_AlbaneseUP.tex` / `def:symmetric_power_curve` empty
    `\uses{}` annotation (L232). Permissible for a primitive scheme
    construction; trivially fixable by the next writer pass on the
    chapter.

Overall verdict: three chapters fail the HARD GATE
(`AbelianVarietyRigidity.tex`, `Picard_RelativeSpec.tex`,
`RiemannRoch_WeilDivisor.tex`); the iter-175 plan-phase writer
dispatches against the first and third are in flight (no
`dispatch_end` and no report on disk at review time), so the same-iter
fast-path re-review applies once both writers complete. Plan agent
should also resolve the `PicScheme` cross-chapter naming clash before
opening either A.1.c or A.2.c as prover lanes. No unstarted phases
in the STRATEGY.md table: every row either has a dedicated chapter or
is covered per-sub-phase inside `Jacobian.tex` (A.3 +
`nonempty_jacobianWitness` body + `genusZeroWitness` body).
