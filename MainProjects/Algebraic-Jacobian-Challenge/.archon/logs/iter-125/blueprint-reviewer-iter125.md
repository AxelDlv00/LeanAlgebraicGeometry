# Blueprint Review Report

## Slug
iter125

## Iteration
125

## Top-level summaries

### Incomplete parts

None blocking. All chapters included in `content.tex` carry the
informal prose and `\lean{...}` hints they need for the active
critical-path provers. The iter-125 plan-agent inline updates to
`Rigidity.tex` (refactored declaration name, dropped hypotheses,
weakened target-side instance) and `Jacobian.tex` (C.2.b reduction
prose, C.2.g cross-reference text) both landed and align with the
post-refactor Lean source.

- **Carry-forward (informational, not blocking):** five
  `\lean{...}`-only references in `Differentials.tex` proof prose —
  `appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`,
  `appLE_colimRingHom_comp_φV`, `appLE_colimRingHom`,
  `appLE_colimAlgebra` — still have no dedicated `\begin{lemma}` /
  `\begin{definition}` blocks. With M1 parked iter-125, these are
  even less urgent than the iter-124 review flagged them. Per the
  directive's "Known issues" list, they are not iter-125 blocking.

### Proofs lacking detail

None on the active critical-path chapters this iter. The iter-125
plan-agent inline updates to `Rigidity.tex` § "Proof sketch" added
explicit Mathlib-ingredient bullets (lines 41–49), so the prover-side
recipe is concrete. The proof of `thm:nonempty_jacobianWitness` in
`Jacobian.tex` remains a multi-route exposition (Routes A, B,
genus-0 sub-case); the genus-0 sub-case sub-step C.2.d still hides
the load-bearing cotangent-vanishing Mathlib gap (`AbelianVariety.constant_of_P1_map`
phantom), but this is documented as such and is the legitimate
roadmap target (shared cotangent-vanishing pile under M2.d-alt).

### Lean difficulty quality

- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE}`:
  signature well-specified (`LinearEquiv` ≃ₗ[B]), Lean target
  exists with a `sorry`-rooted body inside the helper lemma
  `lem:appLE_isLocalization` (per the parked-recipe remark
  `\rem:m1_parked_iter125`). Difficulty is well-formulated; the
  blocker is now narrated in the new remark, not in the bridge
  theorem itself. **PARKED-aware: OK.**
- `Jacobian.tex` / `\lean{AlgebraicGeometry.nonempty_jacobianWitness}`:
  the sole project sorry (`Jacobian.lean:179`). Signature frozen
  (protected), well-specified. The proof block in the chapter is
  multi-route narrative, not a single concrete prover target — this
  is correct for an existence theorem decomposed across M2/M3.

### Multi-route coverage

Per the iter-125 directive's `## Routes` block (single critical-path
route), the multi-route question is the legacy M2.d (RR vs.
cotangent-vanishing) and M3 (Route A vs. Route B). Both are
documented in chapter prose:

- **M2.a Rigidity refactor (iter-125):** PASS — `Rigidity.tex` is
  the chapter covering it; the iter-125 plan-agent inline updates
  ship in §"Statement" (lines 10–19), §"Proof sketch" (lines 27–50),
  and §"Use in the project" (lines 52–61), all reflecting the
  refactored declaration name + signature.
- **M2.a prover lane (iter-126 → iter-130+):** PASS — covered in
  `Jacobian.tex` § "Genus-$0$ sub-case", sub-steps C.2.a through
  C.2.g (lines 313–369). The iter-125 plan-agent updates to C.2.b
  + C.2.g correctly reference the post-refactor declaration name
  and explicitly retire the "group-object-on-source" caveat.
- **M2.b genus-0 witness:** PARTIAL — `Jacobian.tex` § "The
  Albanese universal property" + §"Existence of an Albanese
  variety" cover the abstract structure (`def:JacobianWitness`,
  `thm:nonempty_jacobianWitness`); the concrete `genusZeroWitness`
  builder mentioned in STRATEGY.md is not yet given a dedicated
  blueprint sub-section, but the existence statement
  (`thm:nonempty_jacobianWitness`) is the protected target and
  the sub-route is described in C.3 ("The trivial witness").
- **M2.d-alt (cotangent-vanishing) / M2.d (RR):** PASS — both
  variants are described in `Jacobian.tex` § C.2.d (lines 332–348)
  with the two-proof-paths breakdown.
- **M3 Route A (Picard / FGA):** PASS — described in
  `Jacobian.tex` § "Route A — Picard scheme" (lines 255–284). The
  Lean files corresponding to Route A's representability
  infrastructure (`Picard/*.lean`, `Modules/Monoidal.lean`) do not
  exist, but the prose covers Route A's mathematical structure for
  decision purposes; the orphan blueprint chapters
  (`Picard_*.tex`, `Modules_Monoidal.tex`) describe these
  non-existent Lean files but are not included in `content.tex`
  and so do not affect the active build.
- **M3 Route B (symmetric powers / Stein):** PASS — described in
  `Jacobian.tex` § "Route B" (lines 286–311).
- **M1 (bridge presheaf ↔ algebra-Kähler) PARKED:** PASS for the
  parked state — the new remark `\rem:m1_parked_iter125` at
  `Differentials.tex:188–191` documents the parked state and the
  un-parking recipe (filtered-colim element representation +
  basic-open cofinality + `lift_{inj,surj}_iff`), satisfying the
  directive's request for parked-route documentation. The
  blueprint chapter remains a forward-looking, well-structured
  sketch.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single statement-and-proof chapter for the structure-sheaf
    forget composite. Lean target `instHasSheafCompose_forget_CommRing_AddCommGrp`
    is well-specified. Carries `\leanok`. No active prover route
    needs this iter; no changes called for.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three statements (sheafification on Opens for AddCommGrp,
    Ext on the same, structure sheaf as a sheaf of AddCommGrp) all
    `\leanok` and have well-specified `\lean{...}` hints. No
    iter-125 changes needed.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase-A step-5 + step-6 infrastructure. Long chapter (~656
    lines) but every block carries a `\lean{...}` hint matching a
    declaration in `Cohomology/*.lean`. Producer-instance section
    closes with `instIsHModuleHomFinite_toModuleKSheaf` (Stein
    finiteness chain). No iter-125 changes needed.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Mayer–Vietoris LES + Čech-acyclicity infrastructure. Two
    carrier classes (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`)
    documented as unproduced at the end of the chapter; the consumer
    delivers $H^1(C,\mathcal O_C)$ finiteness conditionally. This
    matches what is shipped. No iter-125 changes needed.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **Iter-125 plan-agent inline update landed:** new remark
    `\rem:m1_parked_iter125` at lines 188–191 documents the
    parked-state recipe (filtered-colim element representation
    + basic-open cofinality + `IsLocalization.lift_{inj,surj}_iff`)
    with the explicit pointer to the archived task-result. This
    satisfies the directive's request.
  - **Carry-forward informational:** five `\lean{...}`-only
    references inside proof prose (`appLE_unitSubmonoid`,
    `isUnit_appLE_unitSubmonoid_in_colim`,
    `appLE_colimRingHom_comp_φV`, `appLE_colimRingHom`,
    `appLE_colimAlgebra`) still lack dedicated
    `\begin{lemma}`/`\begin{definition}` blocks. The plan agent's
    directive flagged this as known-issue carry-forward; the `partial`
    on `complete` reflects that the chapter is documentationally
    incomplete (these helper declarations exist in Lean but aren't
    cross-referenced from dedicated blueprint blocks). This does
    not block any active prover (M1 is parked); promotion is a
    soon item, not iter-125 must-fix.
  - The bridge target `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`
    and helper `lem:appLE_isLocalization` are well-specified; the
    proof sketches walk through M1.a–M1.e in detail.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\lean{AlgebraicGeometry.genus}` matches `Genus.lean:40` (verified
    via grep). Definition body matches the blueprint's stated formula
    `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
    No changes called for.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Iter-125 plan-agent inline updates landed.** C.2.b (lines
    322–328) explicitly states the refactored declaration's
    hypotheses — "stated at the scheme level: source reduced and
    geometrically irreducible, target separated; the source-side
    group-object decoration that the earlier formulation carried
    has been dropped" — and confirms $\mathbb P^1_{\bar k}$
    satisfies the refactored hypotheses trivially. C.2.g (lines
    354–358) updates the gap statement: "(after the iter-125
    refactor, this is `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`,
    stated at the scheme level … the original 'group-object-on-source'
    decoration has been dropped, removing the iter-124 caveat about
    needing a 'thin variant' or 'inlining the proof template')".
    Both updates align with the iter-125 Lean refactor.
  - Single residue: the `\uses{...}` cross-reference at line 248
    still names the **label** `thm:GrpObj_eq_of_eqOnOpen` (defined
    in `Rigidity.tex:12`). The label slug retained its legacy name
    even though the Lean declaration was renamed; the
    cross-reference therefore continues to resolve and the build is
    unaffected. See "Cross-chapter notes" for the consistency
    observation.
  - Otherwise the chapter is well-structured: the
    `def:JacobianWitness` reverse-quantifier-order bundle is
    explained and matches `Jacobian.lean:143` (verified); the
    multi-route proof of `thm:nonempty_jacobianWitness` lays out
    Routes A, B, and the genus-0 sub-case C.1–C.3 in concrete
    enough detail for downstream consumers.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Iter-125 plan-agent inline updates landed.** Statement (lines
    10–19) names `\lean{AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen}`
    matching the refactored Lean declaration; the informal hypotheses
    ($X$ reduced geometrically irreducible $k$-scheme, $Y$ separated
    $k$-scheme) match the Lean signature
    `[IsSeparated Y.hom] [GeometricallyIrreducible X.hom] [IsReduced X.left]`
    at `Rigidity.lean:91–98`.
  - New remark at lines 21–25 explicitly disclosure-notes the
    Mumford-rigidity history and that 8 unused hypotheses were
    dropped + properness was weakened to separatedness in iter-125.
  - "Proof sketch" (lines 27–50) is rewritten to walk through the
    actual proof body: derives `IsSeparated (Y.left ↘ Spec k)`,
    `IrreducibleSpace X.left`, `IsDominant U.ι`, then applies
    `ext_of_isDominant_of_isSeparated'` and `Over.OverMorphism.ext`.
    The five Mathlib closure pieces are itemised.
  - "Use in the project" (lines 52–61) explicitly notes the M2.a
    consumer ($X := \mathbb P^1_{\bar k}$, $Y := A_{\bar k}$) and
    the iter-125 refactor's enabling role.
  - "Mathlib status" (lines 63–71) describes the upstream-PR
    candidate (`ext_of_eqOnNonemptyOpen` as a thin Mathlib corollary).

## Cross-chapter notes

- **Label slug retained from pre-iter-125 naming.** `Rigidity.tex`
  retains the label slug `\label{thm:GrpObj_eq_of_eqOnOpen}` (line
  12) even though the underlying Lean declaration has been renamed
  to `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`. `Jacobian.tex`
  consumers reach this label via `\uses{thm:GrpObj_eq_of_eqOnOpen}`
  (line 248) and `Theorem~\ref{thm:GrpObj_eq_of_eqOnOpen}` (lines
  328, 358, 367), all of which still resolve correctly because the
  label string is unchanged. This is **informational only** — the
  build is not broken — but the slug is now actively misleading.
  A future iter could rename the label to `thm:Scheme_Over_ext_of_eqOnOpen`
  and update its 4 cross-references in a single mechanical pass; not
  iter-125 blocking.

- **Orphan chapters (`Modules_Monoidal.tex`, `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`).** None are
  included in `content.tex` (verified line by line). All four
  describe Lean files that do not exist in the current source
  tree (`Modules/Monoidal.lean`, `Picard/{LineBundle,Functor,FunctorAb}.lean`
  — all absent). They cross-reference one another and reach into
  `Jacobian.tex` for `def:Jacobian`, but because they are
  unreferenced from `content.tex`, plastex never compiles them
  and the dangling Lean targets and chapter cross-references do
  not surface anywhere. Per the iter-124 reviewer and the iter-125
  directive's "Known issues" list, this is **informational
  carry-forward**; cleanup is a future-iter candidate.

- **Differentials.tex helper-declaration cross-references.** Five
  helpers (`appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`,
  `appLE_colimRingHom_comp_φV`, `appLE_colimRingHom`,
  `appLE_colimAlgebra`) are mentioned by `\lean{...}` inside the
  proofs of `lem:appLE_isLocalization` and
  `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` but lack
  dedicated lemma/definition blocks. With M1 parked, the
  promotion-to-dedicated-blocks task is even less urgent; carry
  forward as a **soon** item.

## Strategy-modifying findings

None.

The iter-125 directive explicitly anticipated the two
correctness-of-update questions (Rigidity.tex alignment and
Jacobian.tex C.2.b prose), and both have been correctly executed by
the plan-agent inline. No definition contradicts STRATEGY.md.
STRATEGY.md's "M1 PARKED" framing is now mirrored in the blueprint
by the new `\rem:m1_parked_iter125` remark, satisfying the
correctness-of-parked-state question raised in the directive.

## Severity summary

- **must-fix-this-iter**: none. The two correctness questions the
  directive flagged (Rigidity.tex alignment with iter-125 refactor;
  Jacobian.tex C.2.b alignment with the renamed/refactored
  declaration) have both been correctly executed by the plan-agent
  inline edits this iter. No chapter has `partial` `correct`, no
  route is `MISSING`, and the one `partial` on `complete`
  (Differentials.tex) is a documentation-completeness lag for
  helper declarations whose downstream consumers are PARKED (M1).
- **soon**:
  - Promote the five `Differentials.tex` `\lean{...}`-only helper
    references to dedicated `\begin{lemma}` / `\begin{definition}`
    blocks (un-park dependent; lower urgency post-iter-125).
  - Rename the legacy label `thm:GrpObj_eq_of_eqOnOpen` to
    `thm:Scheme_Over_ext_of_eqOnOpen` and update the 4
    cross-references (`Rigidity.tex:12`; `Jacobian.tex:248, 328,
    358, 367`). The build is unaffected today, but the label name
    is actively misleading. ~5 LOC mechanical edit.
- **informational**:
  - Four orphan blueprint chapters (`Modules_Monoidal.tex`,
    `Picard_Functor.tex`, `Picard_FunctorAb.tex`,
    `Picard_LineBundle.tex`) describe non-existent Lean files and
    are not included in `content.tex`. No build impact. Cleanup
    is a future-iter candidate; per the iter-125 directive, not
    blocking.

**Overall verdict.** The iter-125 plan-agent inline updates to
`Rigidity.tex`, `Jacobian.tex` (C.2.b and C.2.g), and
`Differentials.tex` (`\rem:m1_parked_iter125`) have all landed
correctly and align with the iter-125 Lean refactor and the M1
parking; no must-fix items remain for this iter and the M2.a
prover lane scheduled for iter-126 may proceed against the active
blueprint without a writer dispatch first.
