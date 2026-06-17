# Blueprint Review Report

## Slug
iter119

## Iteration
119

## Top-level summaries

### Incomplete parts
- `Cohomology_MayerVietoris.tex`: a long sequence of declarations in
  Sections~\ref{sec:basic_open_infrastructure} and
  \ref{sec:basic_open_acyclicity}
  (`def:Scheme_basicOpenCover`, the four `…_supr_of_span_eq_top` /
  `…_isAffineOpen` / `…_inter_*` / `…_finset_inf_*` /
  `…_isLocalization` theorems, the `def:Scheme_splitEpi_pi_lift_of_injective`
  helper, `thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt`,
  and the headline `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`)
  carry full proof bodies but **omit `\leanok` inside their `\begin{proof}`
  blocks**, even though the chapter's status remark (lines 1167–1172) ties
  them to file `BasicOpenCech.lean` with six labelled-transient sorries
  still open. This was the iter-118 source of the `complete: partial`
  verdict and remains unchanged this iter. The iter-118 writer did not
  return to this chapter.

### Proofs lacking detail
- `Differentials.tex` / `thm:smooth_locally_free_omega`: in Step 5 the
  prose says the section-module identification of
  `lem:relative_kaehler_presheaf_obj` is `definitionally equal` to
  `Ω_{B/A}` and so the free-of-rank-n conclusion `transfers verbatim`.
  This glosses over a single Lean-side detail the prover will hit: the
  ring `R := X.ringCatSheaf.presheaf.obj (.op U)` in the conclusion
  and the algebra `B := A → B` coming out of Step 1 are
  *definitionally* equal but live behind two coercions
  (`CommRingCat.KaehlerDifferential` on one side, the
  `relativeDifferentials'` construction on the other), so a `cast` or
  `Module.Free.of_equiv` step may be needed. Not a must-fix — a prover
  can navigate it — but a one-line strengthening of Step 5 would help.

### Lean difficulty quality
- None. All `\lean{...}` hints in the nine active chapters resolve to
  current declarations (`AlgebraicGeometry.Scheme.smooth_locally_free_omega`,
  `AlgebraicGeometry.JacobianWitness`, the seven-field structure with
  fields `J, grpObj, proper, smooth, geomIrred, smoothGenus, isAlbaneseFor`
  exactly as enumerated in `def:JacobianWitness`,
  `AlgebraicGeometry.IsAlbanese.*` trio, the four protected `Jacobian.*`
  instances, the `AbelJacobi.Jacobian.*` projection trio, etc.). Spot
  checks confirm the iter-118 writer's rewrite landed: the
  `\structure JacobianWitness` block of `Jacobian.tex` lines 199–217
  matches the Lean structure at `Jacobian.lean:143–160` field-for-field.

### Multi-route coverage
Single route this iter — the directive specifies the Phase-C prover
lane on `Differentials.lean:87` (forward direction of the Jacobian
criterion). The blueprint covers it in one chapter (`Differentials.tex`)
via the 5-step Mathlib chain. `Jacobian.tex`'s proof of
`thm:nonempty_jacobianWitness` enumerates three potential proof routes
(α/β/γ) for the single remaining `sorry`, each properly attributed as
out-of-autonomous-loop-scope, all routes described to the same depth.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No drift since iter-118. Single auxiliary theorem
    `thm:HasSheafCompose_forget` with a brief but sufficient proof
    sketch. `\lean{}` reference resolves.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No drift since iter-118. Three auxiliary blocks
    (`thm:HasSheafify_Opens_AddCommGrp`,
    `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`) with
    `\leanok` markers and adequate sketches.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No drift since iter-118. Long chapter, every block carries
    `\leanok`. All cross-refs to `Cohomology_SheafCompose` resolve.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Same status as iter-118 (no writer was dispatched this iter to
    address it; the iter-118 dispatch went to Differentials/Jacobian).
  - The partial verdict is driven by Sections
    \ref{sec:basic_open_infrastructure}–\ref{sec:basic_open_acyclicity}:
    each `\begin{proof}` block in that span omits `\leanok` despite
    the file `BasicOpenCech.lean` being end-to-end compiling against
    six labelled-transient sorries (per the iter-108 status remark
    at lines 1167–1172, which the chapter properly disclosures).
  - The iter-108 escape-valve `\remark` (lines 1167–1172) explicitly
    parks the trailing transport behind higher-priority Phase-B work
    and the C1 promotion of the refined `LineBundle` carrier. The
    enumerated named-deferral surface (seven entries) is described in
    that remark but `Modules/Monoidal.lean` and `Picard/LineBundle.lean`
    are NOT in `content.tex` for this iteration — they appear here only
    for cross-reference accounting.
  - Mathematical content is correct: the Mayer–Vietoris LES
    construction, the comparison iso, and the Čech-acyclicity ladder
    all sketch sound proofs.
  - **Does not gate the iter-119 prover lane** (which targets
    `Differentials.lean:87`, no MayerVietoris dependency).

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Iter-118 rewrite landed cleanly.** Theorem
    `thm:smooth_locally_free_omega` is now stated forward-only
    (`Smooth ⇒ Ω locally free of rank n`), matching the
    `Differentials.lean:87` signature (`∀ x : X, ∃ U, ...`, no iff).
  - The 5-step Mathlib chain in the proof block is detailed enough
    for a prover to formalize directly: each step names a Mathlib
    declaration with `[verified]`, file location, and the role it
    plays. The five pieces are
    `AlgebraicGeometry.smoothOfRelativeDimension_iff`,
    `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`,
    `Algebra.IsStandardSmooth.free_kaehlerDifferential`,
    `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
    and the project-local
    `relativeDifferentialsPresheaf_obj_kaehler` (`Differentials.lean:58`).
  - The side condition `Nontrivial B` from `x ∈ U` is supplied
    explicitly in the proof body, addressing a gap that would
    otherwise trip up a prover at Step 4.
  - The `\sec{Converse direction --- out of autonomous-loop scope}`
    is a clean disclosure of why the iff form was demoted, with an
    explicit Mathlib-side counterexample (`Spec k → Spec k[t]`,
    `t ↦ 0`) and a precise statement of which three hypotheses
    (FinitePresentation, Subsingleton H1Cotangent, basis-in-range)
    are missing for the converse.
  - The auxiliary `\rem:smooth_class_naming` documents that
    `IsSmoothOfRelativeDimension` is a deprecated alias, removing a
    common source of stale name confusion.
  - Single under-specified detail flagged above in "Proofs lacking
    detail" (Step 5 coercion glue). Not a must-fix.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No drift since iter-118. `def:genus` is matched by
    `AlgebraicGeometry.genus` (protected, listed in
    `archon-protected.yaml:5–6`). The Mathlib-gap analysis and
    `noncomputable`-authorisation sections are unchanged and remain
    accurate.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Iter-118 rewrite landed cleanly.** The three must-fix items the
    iter-118 reviewer raised are all addressed:
    1. `thm:IsAlbanese_unique` prose now correctly describes the
       conclusion as `∃! (e : J_1 → J_2), \iota_2 = \iota_1 \circ e`
       (a morphism, not an iso) with `rem:IsAlbanese_unique_iso`
       documenting the iso-strengthening as a deferred refactor.
    2. The `\structure JacobianWitness` block (lines 199–217) lists
       all seven fields verbatim — `J`, `grpObj`, `proper`, `smooth`,
       `geomIrred`, `smoothGenus`, `isAlbaneseFor` — matching the
       Lean structure at `Jacobian.lean:143–160` field-for-field.
       The redundancy of `smooth`/`smoothGenus` is documented in
       `rem:JacobianWitness_smooth_redundancy`.
    3. The `\lean{...}` hints for the
       `IsAlbanese.ofCurve` / `IsAlbanese.comp_ofCurve` /
       `IsAlbanese.exists_unique_ofCurve_comp` projection trio are
       all present (lines 47, 61, 74) and resolve to the
       `Jacobian.lean:67–84` declarations.
  - The proof of `thm:nonempty_jacobianWitness` lays out three
    independent routes (Picard scheme α; symmetric powers β;
    genus-0 rigidity γ) and accurately identifies each Mathlib gap
    that blocks each route. This is the correct framing for the
    single explicit foundational hypothesis at
    `Jacobian.lean:179`.
  - `rem:JacobianWitness_quantifier_order` justifies the
    `∀ P, IsAlbanese C P J` quantifier order (uniformity over the
    marked point) — this is consumed by `AbelJacobi.tex`.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No drift since iter-118. Single declaration
    `thm:GrpObj_eq_of_eqOnOpen` matched by
    `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen` in `Rigidity.lean`
    (confirmed). Proof sketch (equaliser-is-closed → irreducibility
    → reducedness) is rigorous; the Mathlib-ingredients enumeration
    is accurate.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Status upgraded from iter-118's `complete: partial`: the
    cascading dependency on `Jacobian.tex` (specifically the
    `JacobianWitness` structure block and the `IsAlbanese.*`
    projection trio) is now closed by the iter-118 Jacobian rewrite.
    Each of the three blocks in this chapter (`def:ofCurve`,
    `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) is now
    backed by a properly-typed `\lean{...}` target and projects
    cleanly from an `IsAlbanese` term as described.

## Cross-chapter notes

- `Jacobian.tex` → `AbelJacobi.tex`: the per-`P` Albanese-witness
  reversal of quantifier order described in
  `rem:JacobianWitness_quantifier_order` is now consumed correctly by
  the three blocks of `AbelJacobi.tex` (each takes a marked point `P`
  as input and projects from `isAlbaneseFor P`). No drift.
- `Differentials.tex` → `Genus.tex`: `Differentials.tex` cites the
  "n=1, relative dimension read off via the rank of Ω" framing as
  the connection to the genus side. `Genus.tex` does not yet consume
  `thm:smooth_locally_free_omega` because the Phase-A Serre-finiteness
  ladder is what actually feeds `def:genus`; the Differentials chain
  is a parallel forward implication for the Jacobian side, not a
  feed into the genus definition. The blueprint correctly does not
  link them with a `\uses{}`.
- `Cohomology_MayerVietoris.tex` references seven external named
  declarations in its iter-108 status remark (lines 1167–1172):
  `instIsMonoidal_W`, `cotangentExactSeq_structure.h_exact`,
  `serre_duality_genus`, `nonempty_jacobianWitness`,
  `PicardFunctor.representable`, `SheafOfModules.pullback_tensorObj`,
  `SheafOfModules.pullback_oneIso`. Of these, only
  `nonempty_jacobianWitness` is in scope for the current
  `content.tex`; the others reference files in
  `AlgebraicJacobian/Modules/` and `AlgebraicJacobian/Picard/` whose
  blueprint chapters (`Modules_Monoidal.tex`, `Picard_*.tex`) are
  **not in `content.tex` this iteration** and are explicitly
  orphan-on-disk per the directive. The reference is descriptive
  (catalogues the project's named-deferral surface) rather than a
  hard `\uses{}` cross-ref, so it does not break the dependency
  graph.

## Strategy-modifying findings

None. The iter-118 demotion of `smooth_locally_free_omega` from iff
to forward-only is a one-time strategy-side correction that has now
fully landed in both the blueprint and the Lean signature; no
further strategy modification is implied by anything I read.

## Severity summary

- **must-fix-this-iter**:
  - `Cohomology_MayerVietoris.tex` remains `complete: partial`. Per
    the gate rule's verbatim wording (`any chapter has
    complete: partial … even if the strategy does not require that
    chapter this iter`), this is a must-fix and a blueprint-writer
    should be dispatched against
    Sections~\ref{sec:basic_open_infrastructure}–\ref{sec:basic_open_acyclicity}
    to add `\leanok` markers consistent with the actual state of
    `BasicOpenCech.lean` (or to explicitly mark the gap as unformalized
    and reflect that in the chapter prose). **But this finding does
    NOT touch `Differentials.lean:87`, and so does not gate the
    iter-119 prover lane on `smooth_locally_free_omega`.**

- **soon**:
  - `Differentials.tex` Step 5 of `thm:smooth_locally_free_omega` would
    benefit from a single line acknowledging the Lean-side coercion
    between `X.ringCatSheaf.presheaf.obj (.op U)` and the algebra
    `B` produced by the `mk_iff` bridge. Not blocking — the chain is
    sound and a prover can navigate it — but cheap to add.

- **informational**:
  - `Differentials.tex` uses a stylistically unusual layout where
    `\leanok` sits on its own line after a blank line inside
    `\begin{definition}` blocks (lines 11–13, 20–22, 33–35, 60–62,
    etc.) rather than the project-standard `\begin{X}\leanok` on the
    same line as in `Genus.tex:8` and `Cohomology_StructureSheafModuleK.tex:11`.
    Renders correctly; aesthetic only.

## Overall verdict

`Differentials.tex` is **ready** to gate the iter-119 prover lane on
`AlgebraicGeometry.Scheme.smooth_locally_free_omega` — the chapter is
mathematically correct, the Mathlib chain is explicitly enumerated
and verified, and the proof sketch maps cleanly to a 5-tactic Lean
plan. The iter-118 rewrites of both `Differentials.tex` and
`Jacobian.tex` landed cleanly; the one outstanding must-fix
(`Cohomology_MayerVietoris.tex` partial) does not touch the iter-119
prover lane and can be deferred to a future iter's writer dispatch.
