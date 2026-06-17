# Lean Audit Report

## Slug
iter104

## Iteration
104

## Scope
- files audited: 15
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File is clean. The "Status (iteration 073)" header documents how the three projected definitions reduce uniformly to the Albanese witness — accurate description of current code, not stale.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 0 flagged (all sorries are tracked per directive)
- **bad practices**: 2 flagged
- **excuse-comments**: 4 flagged
- **notes**:
  - **L488–493**: The docstring of `cechCofaceMap_summand_family_R_linear` declares
    `Body left as 'sorry' for the iter-105 prover. Proof sketch (~15 LOC): ...`
    but the body is **actually fully closed** at L536–595. The docstring's
    "sorry/proof sketch" prose is STALE and contradicts the body. This is
    excuse-comment shaped (admits sorry where none exists). Severity: **major**.
  - **L760–778**: Docstring of `alternating_sum_pi_smul_aux` declares
    `Body left as 'sorry' for the iter-097 prover.` — but the body is fully
    closed at L795–811 via `Finset.cons_induction`. Same pattern, STALE.
    Severity: **major**.
  - **L823–829**: Docstring of `alternating_sum_pi_smul_aux_sum_comp` declares
    `Body left as 'sorry' for the iter-099 prover.` — but the body is closed at
    L852–854. STALE. Severity: **major**.
  - **L871–886**: Docstring of `alternating_zsmul_pi_smul_aux_sum_comp` declares
    `Body left as 'sorry' for the iter-103 prover. Proof sketch (~5-10 lines): ...`
    — but the body is closed at L910–926. STALE. Severity: **major**.
  - **L732–751** (`cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`,
    the newly-added theorem flagged in the directive): the body uses
    ```
    rcases n with _ | n'; · omega; ·
      have hPrev : (ComplexShape.up ℕ).prev (n' + 1) = n' := by
        simp [ComplexShape.prev, ComplexShape.up_Rel]
      sorry
    ```
    The `have hPrev` is computed but never used (the very next tactic is
    `sorry`). This is a dead-end scaffold — the lemma was set up for a proof
    that was abandoned mid-stream, leaving an unused hypothesis. Either complete
    the proof or remove `hPrev`. Severity: **major** (suspect definition: the
    declaration carries a `sorry` plus orphan setup).
  - **L928–937**: heartbeat-tuning comment block (`-- Iter-087: lifted to
    1600000 ... Iter-102 NOTE: ...`). Reasonable engineering note but
    bordering on bloat; the iter-102 sub-paragraph documents a reverted
    experiment that's no longer relevant to the current code. Minor.
  - **L1144–1179**: the `sorry`-trailing comment block inside
    `cechCofaceMap_pi_smul` ("iter-105 attempt", "iter-106 attempt") is
    a long admission of failed routes ending in `sorry`. The "iter-107
    plan-agent re-route: lift maxHeartbeats to 3200000+" line is
    **excuse-comment** territory: it documents a workaround that has not been
    applied (current `set_option` is 1600000 at L937) and defers the fix to a
    later prover. Severity: **major** (load-bearing
    `cechCofaceMap_pi_smul`).
  - **Bad practice**: the `letI perI₁/perI₂/perI₃` + `letI h_mod_pi₁/...`
    setup block (L539–558, L649–700, L681–718, L973–992, L1001–1020) is
    *duplicated* between the statement and the body of
    `cechCofaceMap_summand_family_R_linear` and again in
    `cechCofaceMap_summand_family'_R_linear` and again in `cechCofaceMap_pi_smul`.
    The duplication is required (per the iter-080 comment) so the let-instances
    register with typeclass synthesis inside the body. This is honest but
    reflects deep instance-management fragility around `Module R (Z_i j)`.
    Minor — flagged for the refactor agent.
  - All ~7 tracked sorries are present (lines 751, 1179, 1271, 1595, 1623,
    1813, 1842) — known to the review agent per directive.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. All `Iter-XXX` annotations are historical breadcrumbs but
    consistent with current declarations. Clean file.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. Iter annotations are historical but accurate. Clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. Clean closure.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. Iter annotations match declared content. Clean.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 0 flagged (sorries tracked per directive)
- **bad practices**: 1 flagged
- **excuse-comments**: 1 flagged
- **notes**:
  - **L675–912**: a ~240-line `/- ITER-076 disabled chain. Preserved as a
    reference block ... -/` containing commented-out tactic source with two
    embedded `sorry`s. This is large dead code preserved as documentation.
    Documentation belongs in the docstring or in `blueprint/`; live source
    files should not carry hundreds of lines of disabled tactics. Severity:
    **major** (bad practice + stale comment).
  - **L632–636** (`case h_exact`): comment says
    `"Iter-086 (Lane 2): the iter-085 false-signature helper has been reverted.
      Alternative route deferred: see blueprint/src/chapters/Differentials.tex
      § Cotangent exact sequence for the section-wise + sheafification strategy."`
    followed by `sorry`. This is a tracked deferred sorry, but the comment
    references "iter-085 false-signature helper" which is no longer in the
    file — minor stale reference. Severity: **minor**.
  - Tracked sorries at L122, L636, L957, L974, L1116 — known to review agent.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **L39–61**: 22-line block-comment "Sketch of the route once Phase A is
    available: ... `noncomputable def OXAsAddCommGrpSheaf ... sorry` ..."
    preserved as a historical sketch. Phase A is now (at least partially)
    delivered through `Scheme.toModuleKSheaf` and `Scheme.HModule`, so the
    sketch is no longer "once available" — it's superseded. The actual
    definition `genus` at L65–68 is closed and correct. The dead sketch should
    be deleted or moved to blueprint. Severity: **minor** (bad practice +
    stale comment).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 flagged
- **bad practices**: none
- **excuse-comments**: 0 flagged (per directive, `nonempty_jacobianWitness`
  sorry is tracked Phase-C scaffolding)
- **notes**:
  - `nonempty_jacobianWitness` sorry at L179 is documented at L162–175 as
    "single remaining mathematical sorry of the Phase-C scaffolding ...
    requires infrastructure not yet available in Mathlib (quotients of schemes
    by finite group actions; FGA representability)". This is honest:
    identifies a precise Mathlib gap, names the classical references, and
    explains why deferral is the right move. Not an excuse-comment.
  - The "Forbidden shortcut (sanity check)" block at L30–38 actively warns
    against `Jacobian C := 𝟙_ (Over (Spec (.of k)))` — this is exactly the
    *opposite* of an excuse-comment: it documents what would be a known-wrong
    shortcut and why the current witness-based definition avoids it. Good
    practice.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 flagged
- **bad practices**: none
- **excuse-comments**: 0 flagged (per directive: audited)
- **notes**:
  - **Directive audit of L100–165** (the docstring of `instIsMonoidal_W`): the
    comment is **honest, not excuse-territory**. It:
    1. Names the exact Mathlib gap (stalk-of-presheaf-tensor for varying-ring
       `PresheafOfModules R₀`);
    2. Documents two alternative routes investigated and ruled out
       (sheafificationCompToSheaf + AddCommGrpCat-side; internal-hom);
    3. References user policy (`2026-05-11`, no project-local helper allowed
       to bridge the gap);
    4. Explicitly verifies that the sorry does NOT block downstream consumers
       — `instMonoidalCategoryStruct` and `instMonoidalCategory` (L183–193)
       are both fully closed via `LocalizedMonoidal`.
    This is the correct way to mark an honest Mathlib upstream gap. Not an
    excuse-comment.
  - The sorry at L173 is the long-standing tracked Mathlib gap per directive.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 flagged
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **L29–37 (file docstring)**: the "Forward-compatibility note" block reads
    `"'LineBundle' (per 'Picard/LineBundle.lean') is currently realised as the
      global-sections approximation 'CommRing.Pic Γ(X, ⊤)'. The relative Picard
      functor built on top of this approximation gives smaller subgroups than
      the true relative Picard functor on non-affine 'S'. Closing
      'representable' on top of this approximation would silently assert
      representability of the wrong functor and is therefore a forbidden
      shortcut: keep it as 'sorry'."`
    This is **excuse-comment shaped**: it admits that the upstream definition
    is mathematically wrong and that the consequence is that downstream
    consumers ('representable') cannot honestly be closed. Severity:
    **critical** — the comment documents that the load-bearing infrastructure
    of Phase C is built on a known-incorrect definition. **However**, the
    comment is also honest about the consequence (do NOT close `representable`
    on top of this — keep the sorry) and points at the proper fix (Phase B/C
    step 2+ — refactor the LineBundle definition). The criticality is in the
    *upstream definition*, not in this docstring. See `Picard/LineBundle.lean`
    note below.
  - The `PicardFunctor.representable` sorry at L190 is the long-standing
    tracked sorry per directive — its docstring at L176–185 is honest about
    deferral.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. Inherits the LineBundle wrongness through `PicardFunctor C`
    via `quotMap` but does not itself add new excuse-comments.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **L17–61, L72–84 (the `LineBundle` definition and surrounding docstrings)**:
    the file *explicitly admits* that `def LineBundle X := CommRing.Pic Γ(X, ⊤)`
    is mathematically the **wrong definition** in general:
    - L51–52: `"For non-affine schemes this is the image of the natural map
      ... and is therefore a strict subgroup of the true Picard group
      (e.g. it is trivial for projective space whereas the true Pic is ℤ)."`
    - L80–82: `"By Stacks 0AGS this agrees with the actual Picard group of X
      whenever X is affine and is a strict subgroup in general"`
    - L82–84: `"the present definition is a genuine, non-vacuous stand-in that
      suffices to set up the type theory needed by 'Jacobian.lean'."`
    This is **critical excuse-comment**: the `LineBundle` declaration is the
    upstream of `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`,
    `PicardFunctorAb.etaleSheafified` — a load-bearing definition that the
    file's own author flags as wrong. The justification given ("stand-in that
    suffices to set up the type theory") is precisely the structure of an
    excuse-comment: admits the definition is wrong, asserts it's good enough
    for now, defers the fix. Severity: **critical**.
  - Mitigation: the wrongness is recognised throughout — `Picard/Functor.lean`
    refuses to close `representable` on top of this, so the wrongness is
    contained (no downstream `theorem`/`lemma` is proved against the
    approximation). But the *type* of `LineBundle X` is wrong, and any
    quantitative result (rank computation, finiteness in the Jacobian's
    relative dimension `g`) that consumes `Pic` would silently be about
    the global-sections-approximate group rather than the true Picard group.
  - No sorries in this file — all declarations are honestly proved against
    the (wrong) definition.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries. The "Hypothesis correction (iter 003 prover)" block at L37–67
    is a genuine documentation of a *corrected* hypothesis (the original
    point-wise topological agreement was mathematically too weak — Frobenius
    counterexample given) and the strengthened scheme-level form is what is
    declared. This is the correct way to record a definitional correction.
    Clean file.

## Flagged issues by severity

### Critical
- `AlgebraicJacobian/Picard/LineBundle.lean:85` — `def LineBundle X := CommRing.Pic Γ(X, ⊤)` is admitted by the file's own docstrings (L51–52, L80–84) to be mathematically incorrect on non-affine schemes (a strict subgroup of the true Picard group). Why critical: this is the load-bearing definition of an entire Phase C cohort (Picard functor, AbVar setup) and is upstream of the four `Jacobian.lean` sorries. The wrongness is contained today only because `Picard/Functor.lean` refuses to close `representable` on top of it; any attempt to prove a quantitative result against `Pic` would silently be about the wrong group.

### Major
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:488` — docstring of
  `cechCofaceMap_summand_family_R_linear` declares "Body left as 'sorry'"
  but the body is fully closed. Stale excuse-comment.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:760` — same pattern on
  `alternating_sum_pi_smul_aux`: docstring says sorry, body is closed.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:823` — same on
  `alternating_sum_pi_smul_aux_sum_comp`.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:871` — same on
  `alternating_zsmul_pi_smul_aux_sum_comp`.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:732` —
  `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` has a
  computed `have hPrev` that is never used before the trailing `sorry`.
  Dead-end scaffold; either complete the proof or remove the unused
  hypothesis (cleanest: replace `· have hPrev := ...; sorry` with a single
  `· sorry` until the proof is ready).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1170` — inside
  `cechCofaceMap_pi_smul`'s body, the iter-107 plan-agent re-route comment
  (`"Iter-107 plan-agent re-route: lift maxHeartbeats to 3200000+ ... then
  retry"`) is an excuse-comment: it defers the fix without applying it
  (current heartbeat budget at L937 remains 1600000). The body falls
  through to `sorry` at L1179.
- `AlgebraicJacobian/Differentials.lean:675-912` — ~240-line
  `/- ITER-076 disabled chain. Preserved as a reference block ... -/`
  containing commented-out tactic source with two embedded `sorry`s.
  Documentation belongs in the docstring or in `blueprint/`; live source
  should not carry hundreds of lines of disabled tactics.

### Minor
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:928-937` — heartbeat
  comment block contains an iter-102 sub-paragraph documenting a reverted
  experiment that is no longer applicable. Trim.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — repeated `letI perI_n`
  / `letI h_mod_pi_n` block across four theorems
  (`cechCofaceMap_summand_family_R_linear`,
  `cechCofaceMap_summand_family'_R_linear`,
  `cechCofaceMap_pi_smul`,
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`). Each duplication is
  required by the iter-080 instance-management constraint; flag for a
  potential refactor-subagent helper (e.g. an `abbrev`/macro hoisting the
  block) once the proof has stabilised.
- `AlgebraicJacobian/Differentials.lean:632-636` — `h_exact` sorry's comment
  references "iter-085 false-signature helper" which is no longer in the
  file. Stale.
- `AlgebraicJacobian/Genus.lean:39-61` — 22-line commented-out "Sketch of the
  route once Phase A is available" block. Phase A is delivered; sketch is
  superseded by the actual `genus` definition at L65–68. Delete.

## Excuse-comments (always called out separately)

The following are flagged as excuse-comments per the auditor's stance.
"Excuse-comment" here means a comment that admits the code is wrong/incomplete
in a way that, on its own, would silence a downstream alarm:

- `Picard/LineBundle.lean:80-84`: `"By Stacks 0AGS this agrees with the actual
  Picard group of X whenever X is affine and is a strict subgroup in general
  ... the present definition is a genuine, non-vacuous stand-in that suffices
  to set up the type theory needed by 'Jacobian.lean'."` Attached to
  `def LineBundle`. Severity: **critical** (load-bearing for all of Phase C).
- `Picard/Functor.lean:29-37`: `"'LineBundle' ... is currently realised as the
  global-sections approximation ... gives smaller subgroups than the true
  relative Picard functor ... Closing 'representable' on top of this
  approximation would silently assert representability of the wrong functor
  and is therefore a forbidden shortcut: keep it as 'sorry'."` Attached to
  the file docstring (and motivating the `PicardFunctor.representable`
  deferral). Severity: **critical**, but the comment itself is correctly
  containing the wrongness (it refuses to compound the upstream error).
  The criticality is inherited from `Picard/LineBundle.lean`, not from this
  file.
- `Cohomology/BasicOpenCech.lean:488-493` (×4 — same pattern at L760-778,
  L823-829, L871-886): docstrings say `"Body left as 'sorry' for the iter-XXX
  prover. Proof sketch (~N LOC): ..."` but the bodies are now fully closed.
  These are STALE excuse-comments that no longer reflect reality. Severity:
  **major** each. Fix: rewrite the docstrings to describe what the body
  *actually* does, not what someone *planned* to do.
- `Cohomology/BasicOpenCech.lean:1112-1179`: inside `cechCofaceMap_pi_smul`,
  the iter-105 + iter-106 + iter-107 nested comments defer the closure to
  a later prover iteration (`"Iter-107 plan-agent re-route: lift maxHeartbeats
  to 3200000+ for the 'cechCofaceMap_pi_smul' theorem head, then retry the
  Route 1 chain at this position."`). The fix is not applied; the body falls
  through to `sorry`. Severity: **major** (load-bearing for the substantive
  iter-060+ Čech-acyclicity theorem).

## Severity summary

- **critical**: 1 (`LineBundle` definition admitted-wrong)
- **major**: 7 (4 stale "body sorry" docstrings + 1 dead-end `have hPrev` +
  1 iter-107 deferral inside `cechCofaceMap_pi_smul` body + 1 large
  commented-out block in `Differentials.lean`)
- **minor**: 4
- **excuse-comments**: 6 distinct sites (counting the four stale BasicOpenCech
  docstrings as 4; LineBundle + PicardFunctor as 2; BasicOpenCech iter-107
  block as 1 — total 7 sites, of which the LineBundle one is the critical
  upstream).

Overall verdict: the project is structurally honest about its known
upstream gap (`Modules/Monoidal.lean`, `Jacobian.lean`,
`PicardFunctor.representable`, `Differentials.lean` sorries) but carries one
**critical** load-bearing approximation (`LineBundle`) admitted-wrong by its
own docstring, and `BasicOpenCech.lean` has accumulated **four stale "body
left as sorry"** docstrings on theorems that are now closed — the gap
between docstring and body silences the alarm on what is actually delivered.
