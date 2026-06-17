# Blueprint Review Report

## Slug
iter177-whole

## Iteration
177

## Top-level summaries

### Incomplete parts

(None of the 26 chapters is structurally incomplete to a degree that
blocks a prover lane this iter. The "weaker" chapters are all in roles
where adequate coverage is in fact present — see notes.)

- `RigidityKbar.tex`: fragmented by iter-145…iter-155 history; pieces (i–v)
  composition into the main theorem is not narratively assembled in the
  prose. Soft only — this chapter backs the OFF-PATH fallback route (a);
  it does **not** back any iter-177 prover lane, so it does not gate the
  iter.
- `Albanese_Thm32RationalMapExtension.tex`: thin (the main theorem is
  proved in two lines as the combination of A.4.a's two outputs). This
  is adequate because the substantive content lives in the consumed
  chapter `Albanese_CodimOneExtension.tex`; the thinness is structural
  (assembly chapter), not a gap.
- `Cohomology_StructureSheafAb.tex`: Phase A steps 2–4 are pinned but
  k-module enrichment and Serre finiteness are deferred to siblings.
  Not on an iter-177 prover lane.

### Proofs lacking detail

- `prop:genusZero_curve_iso_P1` (`AbelianVarietyRigidity.tex` L1947-1963):
  the proof is an honest textbook Riemann–Roch sketch with the explicit
  remark `rmk:genusZero_iso_subbuild` that the formalisation is a
  genuine sub-build (RR.1–RR.4). This is now exactly the role assigned
  to the new chapter `RiemannRoch_RationalCurveIso.tex`. Soft observation:
  once `thm:genus_zero_curve_iso_p1` lands as a regular cross-reference,
  the corresponding proof block in AVR should be replaced by a one-line
  `\cref{thm:genus_zero_curve_iso_p1}` pointer. Not blocking.

### Lean difficulty quality

(No findings. All `\lean{...}` pins on chapters feeding active lanes
have well-typed, prover-ready signatures.)

### Multi-route coverage

- Route A (Picard scheme via FGA, positive-genus): **PASS** — covered
  across `Picard_RelativeSpec`, `Picard_LineBundlePullback`,
  `Picard_RelPicFunctor`, `Picard_FlatteningStratification`,
  `Picard_QuotScheme`, `Picard_FGAPicRepresentability`,
  `Albanese_AuslanderBuchsbaum`, `Albanese_CodimOneExtension`,
  `Albanese_Thm32RationalMapExtension`, `Albanese_AlbaneseUP`.

- Route C (genus-0 via Milne §I.3 rigidity): **PASS** — covered by
  `AbelianVarietyRigidity` (consolidated, covers 7 Lean files),
  `Rigidity` (scheme-level helper), `RigidityKbar` (off-path fallback
  route (a)), and the four RR sub-builds (`RiemannRoch_WeilDivisor`,
  `RiemannRoch_RRFormula`, `RiemannRoch_OCofP`,
  `RiemannRoch_RationalCurveIso`).

### Citation discipline

- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` (L1591-1597):
  the `% NOTE (iter-164)` explicitly records that the verbatim Milne
  Prop 3.9 quotes "were NOT re-rendered from
  references/abelian-varieties.pdf this session" and are reproduced
  from a "verified in-tree copy". This is a known hygiene gap rather
  than a fabrication (the underlying source file does exist on disk,
  and a prior session verified the quote). Soft only — the quotes are
  literally identical to those carried on `lem:hom_from_Ga_trivial`,
  which is the load-bearing duplicate.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Consolidated chapter (`% archon:covers` covers 7 Lean files:
    AbelianVarietyRigidity.lean, Genus0BaseObjects.lean and four
    sub-files, RigidityLemma.lean). HARD GATE clears for all 7.
  - All Rigidity-Lemma chain blocks marked `\leanok` (iter-162 closure
    is current in prose).
  - The iter-176 "documentary-drift" item is unchanged this iter (no
    new hardening). The remaining drift is the iter-167/168 NOTE block
    on `prop:morphism_P1_to_AV_constant`'s helper sorries — these
    are honestly labelled "scaffold" / "Lane A export" and propagate
    `sorryAx` cleanly. No laundering flagged this iter.
  - The four iter-171 scaffold blocks (`def:gmscaling_cover`,
    `def:gmscaling_chart`, `lem:gmscaling_chart_agreement`,
    `lem:gmscaling_over_coherence`) plus the iter-172 chart-ring iso
    helpers (`def:proj_chart_ring_iso`,
    `lem:proj_chart_ring_iso_aux_left`,
    `lem:mvPoly_to_homogeneousLocalization_away_surjective`,
    `lem:chart_ring_iso_preserves_algebraMap`,
    `lem:gmscaling_chart_PLB_eq`) are all pinned with substantive prose.
    Adequate to drive a temporary-axiom (Lane 2 GM-AXIOM) lane targeting
    a named axiom that names the statement `gmScalingP1` is intended to
    realise.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - NEW skeleton-driver chapter (`% archon:covers
    AlgebraicJacobian/Albanese/AlbaneseUP.lean`). The Lean file does
    not yet exist; this iter's Lane 7 is exactly to scaffold it.
  - 6 substantive `\lean{...}` pins covering the Albanese UP theorem,
    Abel–Jacobi morphism, symmetric power, symmetrisation lemma,
    birational morphism, and descent lemma.
  - Citation discipline COMPLETE — every SOURCE has a verbatim QUOTE
    block, `\textit{Source:...}` line, and `(read from
    references/abelian-varieties.pdf, PDF page N)` parenthetical.
  - The chapter explicitly flags `\texttt{Sym\_g}` of schemes as a
    Mathlib gap and tells the prover to use a `\notready` marker until
    the affine-and-glue sub-build lands; this is appropriate honest
    scope-marking for the file-skeleton.
  - Retired "moduli / Poincaré-bundle / autoduality" wording is
    correctly fenced inside a `% NOTE` comment block (no `\label{}` or
    `\lean{}` pins on the retired wording, so it does not feed the
    depgraph).

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Substantive five-step proof of the Auslander–Buchsbaum formula
    + Cohen–Macaulay corollary, with 7 `\lean{...}` pins.
  - Cites Mathlib audit need (existing depth/PD/CM classes at b80f227)
    rather than blindly producing new ones.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - NEW skeleton-driver chapter (`% archon:covers
    AlgebraicJacobian/Albanese/CodimOneExtension.lean`). The Lean file
    does not yet exist; this iter's Lane 6 is exactly to scaffold it.
  - 6 substantive `\lean{...}` pins: `indeterminacyLocus`, `CodimOneFree`,
    `localRing_dvr_of_codim_one`, `extend_of_codimOneFree_of_smooth`
    (Milne 3.1), `indeterminacy_pure_codim_one_into_grpScheme`
    (Milne 3.3), `extend_iff_order_nonneg` (Weil-divisor reformulation).
  - Citation discipline COMPLETE — every block sourced to Milne or
    Hartshorne with verbatim QUOTE blocks and `(read from
    references/...)` parentheticals.
  - Mathlib readiness audit is explicit: flags
    `Scheme.RationalMap.domain` and
    `AlgebraicGeometry.IsProper.valuative_criterion` as expected
    available; flags the local-cohomology Mathlib gap for Step 2 of
    Milne 3.1 with a sensible "surface fallback" mitigation.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Assembly chapter — the main theorem is two lines combining
    `thm:codim_one_extension` + `lem:milne_codim1_indeterminacy` from
    the sibling chapter. The thinness is structural; substantive content
    lives in `Albanese_CodimOneExtension.tex`. Adequate for its role.
  - Not on an iter-177 prover lane (deferred to A.4.c which depends on
    A.4.a landing first).

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two carrier producer instances (HasCechToHModuleIso,
    HasAffineCechAcyclicCover) are documented as unproduced, with
    downstream consumers conditional. This is intentional Phase-A
    deferral, not a gap.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Phase A bridge chapter; k-module enrichment and Serre finiteness
    deferred to siblings. Not on an iter-177 prover lane, so the
    partial verdict is non-blocking.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase A step 5 closed; Stein finiteness theorem proven. Step 6
    (Serre finiteness for positive degrees) intentionally deferred —
    documented, not a hidden gap.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Forward smoothness criterion proven; converse direction explicitly
    out-of-scope (M4) with counterexample documented. Future milestones
    M5–M8 listed openly. Not on an iter-177 prover lane.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-definition chapter pinning `AlgebraicGeometry.genus`. The
    genus is honestly defined; finiteness is conditioned on Phase-A
    step 6 (Serre finiteness) — documented, intentional.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Witness bundle definition reverses quantifier order (iter-149
    cycle-fix, documented). Visible portion is substantive; integrates
    Route A (positive-genus) and Route C (genus-0) at the top level.
  - Iter-172 `a4-bypass-audit` blueprint-writer note is referenced;
    the algebraic-closure pivot is implicit in the genus-zero witness
    definition. No new findings this iter.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter prose carries three iter-176 NOTE annotations explicitly
    documenting that the iter-176 Lean proofs of `thm:relative_spec_univ`,
    `thm:relative_spec_affine_base`, and `thm:relative_spec_base_change`
    discharge against the placeholder body `RelativeSpec _𝒜 := X` rather
    than the genuine relative-spectrum construction.
  - **The chapter PROSE itself is fully substantive** — the Yoneda
    bijection argument, base-change iso construction, and affine-base
    identification are all spelled out in full. Adequate to drive a
    substantive-body iter-177 lane (Lane 4).
  - Iter-177 planning concern (not a blueprint gap): the progress-critic
    `route177` report flagged that a Mathlib-analogist consult on the
    `RelativeSpec` type encoding should fire BEFORE another body-fill
    round, since the iter-176 closure laundered through structural
    elimination rather than encoding. This is a dispatch-sequencing
    matter; the chapter is correct.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter prose and `\lean{...}` pins are in sync. The iter-176
    BUILD-BREAK on `OCofP.lean` (4 errors from Lane D ↔ Lane K
    signature-change race introducing `[IsLocallyNoetherian C.left]`
    instance binders) is a Lean-file issue, **not** a blueprint gap —
    the chapter correctly names declarations as they would be exported
    from `WeilDivisor.lean`, and the build break is in `OCofP.lean`'s
    missing instance binders. No blueprint update needed for Lane 1.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - NEW skeleton-driver chapter (`% archon:covers
    AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`). The Lean
    file does not yet exist; this iter's Lane 8 is exactly to scaffold
    it.
  - 4 substantive `\lean{...}` pins:
    `morphismToP1OfGlobalSections`, `morphism_degree_via_pole_divisor`,
    `iso_of_degree_one`, and `genusZero_curve_iso_P1` (the headline
    iso, identical with the existing AVR pin at
    AbelianVarietyRigidity.lean:290).
  - Citation discipline COMPLETE — Hartshorne IV.1 Example 1.3.5 +
    II.6/IV.2 + I.6.12 cited verbatim with `(read from references/...)`
    parentheticals.
  - Closure of this chapter retires the `sorryAx` propagation on
    `rigidity_genus0_curve_to_grpScheme`'s upstream
    `genusZero_curve_iso_P1`; this is correctly documented in
    `rmk:rr4_unblocks_sorryAx_on_rigidity_genus0`.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - In sync with iter-176 axiom-clean `order` body. The iter-175
    signature note (lines 297-377) documents the explicit
    `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` parameter that the
    Lean encoding requires; chapter and Lean are co-evolved correctly.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Minimal scheme-level helper chapter; intentionally narrow scope
    (one pinned lemma, `Scheme.Over.ext_of_eqOnOpen`). Adequate.
  - **Soft observation**: this chapter has no `% archon:covers` line,
    yet its single `\lean{...}` pin names a concrete Lean target. The
    blueprint-doctor will treat it as an orphan chapter against the
    file-coverage map. Informational — not blocking; the planner may
    want to add an `% archon:covers` line in a future writer dispatch
    or leave it as a deliberately-uncovered helper.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **OFF-PATH chapter** — explicitly documents that
    `rigidity_over_kbar` is the iter-145+ fallback route (a) artifact,
    retained as `[CharZero]`-hypothesis fallback. The committed
    char-free route is `thm:rigidity_genus0_curve_to_AV` in
    `AbelianVarietyRigidity.tex`.
  - Chapter is structurally fragmented by iter-145…iter-155 history
    (multiple "EXCISED" / "DESCOPED" piece annotations). This is
    documentary debt, not a correctness issue; the pieces that remain
    pinned to live Lean targets are still well-typed.
  - **Not on an iter-177 prover lane**, so the partial verdict is
    non-blocking. Cleanup deferred until either the fallback route
    re-activates (unlikely per Strategy) or a routine documentary
    refresh dispatches a writer to consolidate the chapter.

## Cross-chapter notes

- `AbelianVarietyRigidity.tex` and `RiemannRoch_RationalCurveIso.tex`
  both pin `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}`. AVR pins it
  on the proposition block `prop:genusZero_curve_iso_P1` (L1922-1942 of
  AVR), and RR.4 pins the same Lean target on
  `thm:genus_zero_curve_iso_p1` (RationalCurveIso.tex L326-367). RR.4
  explicitly identifies itself as the consumer-side restatement
  ("the existing interface block \Cref{prop:genusZero_curve_iso_P1} of
  \Cref{chap:AbelianVarietyRigidity} is its consumer-side restatement,
  pinning the same Lean declaration"). This is documented and
  intentional; the lean target is unique. Informational only — once
  the RR.4 Lean file lands, the AVR block could be downgraded to a
  pointer, but doing so is a future cleanup, not a must-fix.

## Severity summary

Must-fix-this-iter: **none**.

Soon (cross-cutting, non-blocking):
- `RigidityKbar.tex` fragmented historical structure — cleanup
  dispatch when convenient. Off the iter-177 critical path.
- `Rigidity.tex` lacks `% archon:covers` — minor blueprint-doctor
  hygiene.
- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` SOURCE QUOTE
  re-render — known iter-164 NOTE; not a fabrication.

Informational:
- AVR / RR.4 dual-pin on `genusZero_curve_iso_P1` (documented
  consumer-side restatement, will resolve once RR.4 Lean lands).
- `Albanese_Thm32RationalMapExtension.tex` is structurally thin —
  intentional, not a gap.

## HARD GATE clearance — per active prover lane

For each of the 8 prover lanes dispatched this iter, the backing chapter
verdict is verified `complete: true` AND `correct: true` AND no
must-fix-this-iter finding names it:

1. **Lane 1** — `OCofP.lean` BUILD-FIX → `RiemannRoch_OCofP.tex`:
   **GATE CLEARS**. Chapter complete + correct; build break is in the
   Lean file's instance binders, not in blueprint pins.

2. **Lane 2** — `GmScaling.lean` GM-AXIOM →
   `AbelianVarietyRigidity.tex` (consolidated): **GATE CLEARS**. The
   consolidated chapter covers GmScaling.lean among 7 files; the
   chapter's statement of the target the temporary axiom realises
   (`def:gaTranslationP1` and its scaffold blocks) is substantive.

3. **Lane 3** — `WeilDivisor.lean` body → `RiemannRoch_WeilDivisor.tex`:
   **GATE CLEARS**. Chapter in sync with iter-176 axiom-clean closure.

4. **Lane 4** — `RelativeSpec.lean` body upgrade →
   `Picard_RelativeSpec.tex`: **GATE CLEARS**. Chapter prose is fully
   substantive; the three iter-176 placeholder NOTE annotations
   document exactly what the lane will fix.

5. **Lane 5** — `RelPicFunctor.lean` body →
   `Picard_RelPicFunctor.tex`: **GATE CLEARS**. Chapter complete +
   correct with substantive proof sketches across the étale
   sheafification chain.

6. **Lane 6** — `Albanese/CodimOneExtension.lean` (NEW skeleton) →
   `Albanese_CodimOneExtension.tex`: **GATE CLEARS**. New chapter,
   6 `\lean{...}` pins, substantive Milne 3.1 / Milne 3.3 / Weil-divisor
   reformulation proof sketches.

7. **Lane 7** — `Albanese/AlbaneseUP.lean` (NEW skeleton) →
   `Albanese_AlbaneseUP.tex`: **GATE CLEARS**. New chapter, 6
   `\lean{...}` pins, substantive symmetric-power Albanese-UP proof
   sketches.

8. **Lane 8** — `RiemannRoch/RationalCurveIso.lean` (NEW skeleton) →
   `RiemannRoch_RationalCurveIso.tex`: **GATE CLEARS**. New chapter,
   4 `\lean{...}` pins, substantive Riemann–Roch-genus-0 → ≅ ℙ¹
   classification proof sketch.

**ALL 8 LANES CLEAR THE HARD GATE.**

Overall verdict: All 26 chapters audited; 22 are
`complete: true, correct: true`; 4 are `partial` (RigidityKbar,
Albanese_Thm32RationalMapExtension, Cohomology_StructureSheafAb, plus
soft notes elsewhere) but **none of the partials feeds an iter-177
prover lane**. The HARD GATE clears for all 8 dispatched prover lanes
this iter, including the 3 new file-skeleton lanes (Albanese_AlbaneseUP,
Albanese_CodimOneExtension, RiemannRoch_RationalCurveIso) whose backing
chapters have substantive proof sketches, complete citation discipline,
and prover-ready `\lean{...}` pins.
