# Lean Audit Report

## Slug
iter112

## Iteration
112

## Scope
- files audited: 17 (all `.lean` files under project; excludes `.archon/lanes/**` snapshots)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator (15 lines). No findings.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14: docstring says `## Status (iteration 073 — Phase E closes by reduction)`.
    Iteration label is 39 iters stale; substance still correct. Minor.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: 0 new (carry-over)
- **suspect definitions**: none
- **dead-end proofs**: 0 new (carry-over labelled-substep sorries from iter-061+)
- **bad practices**: none
- **excuse-comments**: 1 cross-iter (carry-over from iter-109)
- **notes**:
  - L1742–1754: `g_R.map_smul'` body is `sorry` with comment "Deferred to the next
    iteration." This was already flagged at iter-109 (per the directive's
    "Known issues"). Still present; **re-flagged but not counted as new**.
  - L1715: ancillary "The next iteration can re-introduce it after either…"
    comment in the same `g_R` block; same cross-iter framing.
  - L1846 `h_loc_exact -- DEFERRED (budget)` is the documented named-deferred
    budget-deferral; on the allow-list.
  - L1120 `cechCofaceMap_pi_smul` `sorry`: comment says "iter-103 prover takes
    over"; this is annotated active prover work, not a new excuse-comment.
    But the framing remains stale across many iters — see Major below.
  - L1212, L1536, L1564: labelled-substep sorries inside the substantive Čech
    acyclicity theorem; each is named, mathematical content described,
    consistent with the iter-061 substep decomposition. Not new.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Whole file (629 lines) is closed, well-documented, with each declaration
    naming its iter source. The four Mathlib gap-fills
    (`Functor.const_additive`, `Functor.const_linear`, `left_adjoint_linear`,
    `right_adjoint_linear`, `homLinearEquiv`, `Abelian.Ext.chgUnivLinearEquiv`)
    are correctly localised and documented. No findings.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Whole file (713 lines) is closed. `HasAffineCechAcyclicCover` /
    `HasCechToHModuleIso` carrier-classes are well-scoped `Prop`-valued
    classes (data wrapped in `Nonempty`). No findings.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 49-line gateway instance. Closed, honest. No findings.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 63-line file. Phase A steps 2–4 closed. No findings.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 934-line file with extensive iter-006-through-iter-053 build-out.
    Bridges to Čech (`Scheme.cechCochain`, `Scheme.cechCohomology`), affine
    vanishing carrier classes, H⁰ Hom-finiteness carriers, all named and
    closed. No findings.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 2 (major — header rot)
- **suspect definitions**: none
- **dead-end proofs**: 1 new (iter-112 scaffolding sorry, on-purpose per directive)
- **bad practices**: 1 minor (inaccurate "Project-level sorry total" inline claim)
- **excuse-comments**: none new
- **notes**:
  - **L27–30 (header rot, carry-over)**: docstring header reads
    `## Status (iteration 064 — scaffold)` followed by `All main declarations
    have sorry bodies.` This is 48 iters stale and outright wrong now —
    most declarations are closed (cotangentExactSeqAlpha, cotangentExactSeqBeta,
    cotangentExactSeqBeta_hη, h_zero, h_epi, universalDerivation, etc.). Major.
    Already flagged at iter-109; re-flagged but **not** counted as new.
  - **L159 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` body
    `intro ι U; sorry`** (iter-112 new helper). Status, docstring, and body
    correctly enact the blueprint Route (a) recipe (§"Sheaf condition for
    Ω_{X/S}", Steps 2+3 packaged). Body is `sorry` per directive's scaffolding
    purpose; comment block (L163–176) cites the load-bearing Mathlib lemmas
    (`KaehlerDifferential.isLocalizedModule_map`,
    `AlgebraicGeometry.Scheme.isBasis_affineOpens`,
    `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover`). **On-purpose per directive.**
  - **L188 `relativeDifferentialsPresheaf_isSheaf_type`** (iter-112 new helper):
    fully closed via the equivalence `isSheaf_iff_isSheafOpensLeCover`.
    Body matches docstring. No findings.
  - **L220 `relativeDifferentialsPresheaf_isSheaf`** (rewritten in iter-112):
    body is the Step 1 forgetful reduction followed by delegation to
    helper #2. Clean. No findings.
  - **L213–215 inline claim "Project-level sorry total: 5 (same as entry)"
    is inaccurate.** Project-wide there are ~17 `sorry`s across files; the
    "5" is the *file-level* count for Differentials.lean only. L146 of the
    same docstring correctly says "file-level sorry count flat at 5". The
    two phrasings contradict each other within the same docstring block.
    Minor cosmetic finding (not a wrong-decision admission).
  - L622 `h_exact`, L823 `smooth_iff_locally_free_omega`,
    L840 `cotangent_at_section`, L982 `serre_duality_genus`:
    all carry-over deferred sorries with substantive route documentation.
    On the allow-list per directive (L622, L982 explicitly named; L823/L840
    not explicitly named but are documented Phase B/D deferrals matching the
    same shape).
  - The five `set_option maxHeartbeats 16000000 in` blocks are each justified
    by an inline note about elaboration cost; reasonable use of the escape
    hatch, not abuse.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 (minor — commented-out sketch from earlier iters)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L39–61: a multi-line commented-out "Sketch of the route once Phase A is
    available" with `sorry⟩` at L52. The route is already implemented (see
    `genus` body at L65–68), so the sketch is stale. Minor (commented code
    only; harmless but should eventually be removed).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 new
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L179 `nonempty_jacobianWitness := sorry` — named-deferred per directive.
    Docstring explains why (FGA-level + symmetric powers + quotient by finite
    group actions; honest gap). On the allow-list.
  - L30–38 "Forbidden shortcut (sanity check)" block is a clear, non-excuse
    explanation of why the terminal-object definition is unsuitable in
    higher genus. Good practice (preserves rationale).

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 new
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L173 `instIsMonoidal_W` is the named-deferred Mathlib gap-fill
    (stalk-of-presheaf-tensor in the varying-ring setting). On the allow-list.
    Docstring is honest about the obstruction (multi-PR Mathlib upstream
    needed) and explicitly notes downstream consumers are unaffected.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 new
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L181 `PicardFunctor.representable := sorry` — named-deferred per
    directive ("FGA-level, not honestly closeable"). On the allow-list.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Fully closed file. The "Status (iteration 008 …)" docstring is slightly
    stale-labelled (current iter is 112) but its content is still accurate.
    Not flagging.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 new
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L86 `SheafOfModules.pullback_tensorObj := by sorry` — named-deferred.
  - L98 `SheafOfModules.pullback_oneIso := by sorry` — named-deferred.
    Both on the allow-list; both have docstrings citing the specific Mathlib
    gap and the canonical successor lemma.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `GrpObj.eq_of_eqOnOpen` closed honestly. The "Hypothesis correction
    (iter 003 prover)" block at L38–69 is a non-excuse rationale for a
    strengthened hypothesis (point-wise → scheme-level on `U`) — good
    practice.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - External reference file (the AI Challenge specification). All
    declarations have `sorry` bodies as the challenge baseline; this is the
    *reference shape* against which the project's filled-in versions are
    measured. Not subject to project-side findings.

## Must-fix-this-iter

None. Every `sorry` and every excuse-comment in the project falls into one of:
(a) the directive's allow-list of named-deferred Mathlib-gap sorries plus
the 1 budget-deferral, (b) the iter-112 scaffolding helper explicitly
enacted from the blueprint Route (a) recipe, or (c) carry-over findings
from the iter-109 audit that the directive instructs not to double-count.

## Major

- `AlgebraicJacobian/Differentials.lean:27–30` — Header rot. Status block
  says `iteration 064 — scaffold` and `All main declarations have sorry
  bodies.` Substance is wrong: as of iter-112, most declarations are
  closed (`relativeDifferentialsPresheaf_isSheaf` body just landed,
  `cotangentExactSeqAlpha/Beta`/`cotangentExactSeq_structure`'s `h_zero`
  and `h_epi` branches all closed, `universalDerivation` closed, etc.).
  **Carry-over from iter-109** — re-flagged for visibility per directive
  but **not counted as a new finding**.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1742–1754` — Cross-iter
  excuse-comment. The `g_R.map_smul'` body is `sorry` and the inline
  comment says "Deferred to the next iteration." This is now several iters
  old; the framing should either be turned into a named-deferred entry on
  the project's allow-list (with mathematical justification) or be closed.
  **Carry-over from iter-109** — re-flagged but not counted as new.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1715` — Same cross-iter
  excuse-comment family. "The next iteration can re-introduce it after…" —
  comment was written for a specific upcoming iter but has outlived it.
  Carry-over.

## Minor

- `AlgebraicJacobian/Differentials.lean:213–215` — Inline claim "Project-level
  sorry total: 5 (same as entry)" is inaccurate; the project-wide sorry
  count is much higher than 5. The number 5 is the *file-level* count for
  Differentials.lean (helper #1's body + h_exact + smooth_iff_locally_free_omega
  + cotangent_at_section + serre_duality_genus). L146 of the same docstring
  correctly uses the "file-level" framing; the L214 phrasing contradicts it.
  New, but cosmetic.
- `AlgebraicJacobian/AbelJacobi.lean:14` — Status header says `iteration 073`;
  substance still correct, label drifts.
- `AlgebraicJacobian/Genus.lean:39–61` — Commented-out "Sketch of the route"
  block from before Phase A landed. The route is now implemented (L65–68);
  the sketch is stale commented code.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1120` — `cechCofaceMap_pi_smul`
  has body `sorry` with comment "iter-103 prover takes over." The pointer
  to a specific past iteration is stale (we are at iter-112); the comment
  should either be updated to point at the actual active prover lane or be
  flagged as a tracked sorry with named substep. Not severe — the
  surrounding context (S1–S6 step labels, iter-104 / iter-107 progress
  notes) does record real progress, just not via a clean "this iter is
  handling it" pointer.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1752`:
  `-- codomain.  Deferred to the next iteration.` (attached to
  `g_R.map_smul'`, body `sorry`). Severity: **major** (carry-over from
  iter-109; not new).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1715`:
  `-- (`Z₃`'s Fin index uses the literal `n + 2`). The next iteration can
  re-introduce it after…` (same block). Severity: **major** (carry-over).

No new excuse-comments this iter.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (all carry-over from iter-109; re-flagged for visibility but
  not new findings per the directive's known-issues list).
- **minor**: 4 (1 new on Differentials.lean inline "Project-level" claim;
  3 stale-label / commented-code drift).
- **excuse-comments**: 2 (both carry-over from iter-109; counted under
  major above).

Overall verdict: iter-112 introduced a clean scaffolding pair (two
helpers + main-body rewrite) on `Differentials.lean` that faithfully
enacts the blueprint Route (a) recipe with one named-deferred body and
the rest fully closed; no new wrong-code or excuse-comments were
introduced this iteration, and all carry-over findings from iter-109
(header rot in `Differentials.lean`, cross-iter excuse-comment framing
in `BasicOpenCech.lean`) remain unaddressed but are explicitly
catalogued as not-new.
