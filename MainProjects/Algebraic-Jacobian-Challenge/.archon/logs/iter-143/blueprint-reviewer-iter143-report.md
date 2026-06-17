# Blueprint Review Report

## Slug
iter143

## Iteration
143

## Top-level summaries

### Incomplete parts

Nothing structurally incomplete this iter — every chapter in scope for M2 (the
HARD-GATE target) has prose, signatures, and per-step closure recipes pinned.
The two `\notready` markers on `def:genusZeroWitness` and
`def:positiveGenusWitness` are stale (the underlying Lean declarations are
formalized as sorry-bodied scaffolds) and are informational rather than
incompleteness. No chapter is missing a definition that the active strategy
requires.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof block,
  d_app sub-recipe (L612–L703): the 4-step closure recipe
  (categorical equality $\pr_1.\mathrm{left} \circ G.\mathrm{hom}
  = \pr_2.\mathrm{left} \circ G.\mathrm{hom}$ → `comp_c_app` →
  adjunction-transpose → `d_map`-discharge) IS present, but the **iter-142
  empirical lessons** from the d_map closure are not yet reflected:
    1. The `rw [show ... from NatTrans.naturality_apply ...]` packaging
       pattern (needed because the bare lemma produces
       `ConcreteCategory.hom`-form equalities that do not unify with the
       goal's `RingCat.Hom.hom` / `CommRingCat.Hom.hom`-form terms) is not
       mentioned in the d_app recipe. A future prover will likely re-derive
       this lesson under pressure; recording it would save the
       re-discovery cost.
    2. The "explicit `change` must spell BOTH LHS and RHS" rule is
       recorded as a negative-lesson NOTE for d_map at
       `RigidityKbar.tex:784–801` but is not lifted into the d_app
       recipe even though d_app is a categorical chase of the same shape
       and is highly likely to hit the same `pushforward₀`-`whnf`-opacity
       wall when its categorical equality is rewritten.
  Severity: **soon** (not blocking — the recipe is dispatchable as-is and a
  competent prover will rediscover the patterns; but the discoveries are
  costly to re-derive and worth promoting).

- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof block,
  IsIso sub-recipe (Route (b'2), L943–L1073): the recipe **is**
  decomposed into items (1) closed, (2)+(3)+(4) iter-141+ targets, but the
  in-Lean bundling chosen by iter-140 (`isIso_of_app_iso_module ...
  (fun _ => sorry)`) collapses items (2)+(3)+(4) into a single
  `(fun _ => sorry)` argument inside a `letI`. The blueprint recipe is
  compatible with either (a) the current bundled-`letI` shape or (b) the
  Lean-auditor's recommended named-theorem refactor (`theorem
  basechange_along_proj_two_inv_app_isIso` carrying the same residual
  sorry as a named, auditable obligation). The blueprint does not pick a
  side, which is mostly fine because the underlying mathematical content
  is the same; but a one-paragraph NOTE pointing the iter-143+ prover at
  the named-theorem option would unblock the auditor's recommended
  refactor without forcing it. Severity: **soon** (informational
  preference; not a blueprint correctness issue).

### Lean difficulty quality

All `\lean{...}` hints in the M2-active chapters
(`AlgebraicJacobian_Cotangent_GrpObj.tex`, `RigidityKbar.tex`,
`Jacobian.tex`, `AbelJacobi.tex`, `Rigidity.tex`, `Differentials.tex`)
name targets whose signatures are explicitly pinned via either a
verbatim "Lean signature stub" comment in the blueprint or a closed Lean
declaration. The IsIso-related declarations are particularly well-pinned
this iter: `lem:GrpObj_omega_basechange_proj_inv` /
`lem:GrpObj_omega_basechange_proj_inv_derivation` carry explicit
signature stubs that match the in-tree iter-138-landed definitions, and
the docstring-vs-blueprint advisory chain at
`Cotangent/GrpObj.lean:479–499` is referenced from the blueprint NOTE
blocks (so a downstream prover knows which source is more recent on which
question).

The non-M2 chapters (`Cohomology_*`, `Genus.tex`) likewise have specific
target names tied to concrete signatures; no vague hints found.

### Multi-route coverage

- **Genus-0 arm of `thm:nonempty_jacobianWitness`** (the M2 route the
  iter-143 plan agent is dispatching against): **PASS** — covered in
  `Jacobian.tex` §C.2 (informal C.2.a–C.2.g), `Rigidity.tex` (the
  iter-125 `ext_of_eqOnOpen` lemma — the C.2.b reduction step), and
  `RigidityKbar.tex` (the named `rigidity_over_kbar` declaration + the
  shared cotangent-vanishing pile (i)+(ii)+(iii) inventory).
  `AlgebraicJacobian_Cotangent_GrpObj.tex` pointer-chapter ties the
  9 Lean declarations in `Cotangent/GrpObj.lean` back to the
  RigidityKbar.tex piece-(i) prose.

- **Positive-genus arm of `thm:nonempty_jacobianWitness`** (M3,
  off-critical-path per STRATEGY.md): **PASS** — covered in
  `Jacobian.tex` §sec:positiveGenusWitness; Route A (FGA / Picard) and
  Route B (symmetric powers / Stein factorisation) are both spelled out
  at sub-step granularity (A.1–A.4 and B.1–B.3) with explicit Mathlib
  gap statements. No prover dispatch this iter on M3 is contemplated, so
  this is not on the HARD-GATE path.

- **Sub-step (i.b) of the cotangent-vanishing pile, IsIso closure
  route** (the iter-143-active prover lane): **PASS** — Route (b'2)
  (local-iso check via `PresheafOfModules.toPresheaf` +
  `NatTrans.isIso_iff_isIso_app`) is fully specified in `RigidityKbar.tex`
  L943–L1073 with all five Mathlib API references verified iter-139 and
  the 5-line iso-reflection bridge `isIso_of_app_iso_module` already
  in-tree at `Cotangent/GrpObj.lean:544–550`. Route (a) (chart-unfolding
  via `pullbackObjEquivTensor` + the 5-step recipe) is also documented
  as the comparison alternative.

- **Sub-step (i.b) of the cotangent-vanishing pile, d_app closure
  route**: **PASS** — the 4-step recipe at `RigidityKbar.tex:672–703` is
  prover-dispatchable; see "Proofs lacking detail" §1 for the iter-142
  empirical-lesson promotion suggestion (soon, not blocking).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - No change since iter-142. Three declarations (`def:ofCurve`,
    `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) all carry
    closed Lean projections from the Albanese witness; the iter-127
    over-k commitment is consistently reflected in the §"Implementation
    route" paragraph and the rigidity-route paragraph.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pure pointer chapter to `Cotangent/GrpObj.lean`. Lists all nine
    Lean-file declarations and ties each one to a `RigidityKbar.tex`
    label. No `\lean{...}` hints; the chapter intentionally delegates
    formal content to `RigidityKbar.tex`.
  - The iter-138 status text correctly identifies "three concrete
    sub-sorries remain inside this declaration's body and inside the
    two helpers below" — this still matches the in-tree state for the
    iter-142-collapsed three-sorry inventory (d_app L637, IsIso L720,
    mulRight_globalises body L848). The iter-138 prose framing names
    "d_app + d_map + IsIso" — iter-142 closed d_map, so this paragraph
    is technically stale, but the staleness is sympathetically obvious
    (the pointer file isn't load-bearing for prover dispatch).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 947 LOC, no `\notready` markers, no protected declarations. Builds
    the Mayer–Vietoris LES + Čech acyclicity infrastructure for the
    Serre-finiteness path (Phase A step 6). Off the M2 critical path,
    so HARD GATE does not apply.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single 5-line `instHasSheafCompose_forget_CommRing_AddCommGrp`
    theorem with closed Lean target. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase A steps 2–4 packaging. Three theorems + one definition, all
    `\leanok`. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655 LOC, Phase A step 5 implementation. Heavy chain of typeclass
    plumbing (sheafification of `ModuleCat k`, `Ext`, structure sheaf
    promotion to `ModuleCat k`, Čech infrastructure, finite-
    dimensionality carriers). All `\lean{...}` targets ship; no
    `\notready`. Off the M2 critical path but cleanly self-contained.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 209 LOC. Forward-direction Jacobian criterion `thm:smooth_locally_free_omega`
    + the two surviving K\"ahler-localisation utility lemmas after the
    iter-126 M1 excise. No new findings since iter-142. The lemma is
    actively consumed by `RigidityKbar.tex` piece (i.a)'s rank-lemma
    Step 1, so its correctness is M2-load-bearing — and it is closed.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 69 LOC. Honest definition `def:genus = Module.finrank k ...`. Notes
    Mathlib gap (Serre finiteness) clearly. No issues.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Stale `\notready` markers (informational; carry-over from iter-141 + iter-142):**
    `def:genusZeroWitness` at L389 and `def:positiveGenusWitness` at
    L424 both carry `\notready` despite the underlying Lean declarations
    being formalized as honest sorry-bodied scaffolds. Per CLAUDE.md
    marker vocab, `\notready` on a formalized statement is stale; the
    review agent's blueprint-marker domain covers `\notready` removal
    (semantic judgement). Recommend stripping these two markers in the
    iter-143 review phase.
  - Rest of chapter (definitions through positive-genus arm) unchanged
    from iter-142. The iter-127 over-k commitment + the C.2.f DROPPED
    note are consistently present in both the genus-0 sub-case prose
    and the §"Implementation route via the Albanese functor"
    closing paragraph.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-125 scheme-level form `thm:GrpObj_eq_of_eqOnOpen`
    (`ext_of_eqOnOpen`) is the C.2.b reduction step's input. Closed.
    No new findings since iter-142.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true (with soon-severity recommendations below)
- **correct**: true
- **notes**:
  - **HARD GATE — chapter is GREEN-LIT for `Cotangent/GrpObj.lean` prover
    dispatch.** All declarations the prover will touch (d_app sub-sorry
    L637, IsIso sub-sorry L720, mulRight_globalises_cotangent compose
    body L848) have prover-ready recipes pinned with explicit Mathlib
    API references.
  - **Stale `\notready` markers on `lem:GrpObj_omega_free` (L1291)
    and `lem:GrpObj_omega_rank_eq_dim` (L1304):** these two piece-(i.c)
    lemmas are downstream of `lem:GrpObj_mulRight_globalises` and have
    not been scaffolded in Lean yet; the `\notready` is NOT stale
    (no formalization exists). This is correct usage.
  - **d_app recipe quality (RigidityKbar.tex:672–703):** see "Proofs
    lacking detail" §1 — soon-severity request to elevate the iter-142
    `rw [show ... from NatTrans.naturality_apply ...]` packaging pattern
    and the "change-fully-explicit-on-both-sides" rule from per-iter
    NOTE annotations to first-class recipe steps. **Not blocking.**
  - **IsIso recipe quality (RigidityKbar.tex:943–1073):** see "Proofs
    lacking detail" §2 — soon-severity request for a NOTE pointing at
    the lean-auditor's recommended named-theorem refactor option (extract
    the `IsIso` obligation from the in-line `letI` into a named
    sorry-bodied theorem `basechange_along_proj_two_inv_app_isIso`).
    **Not blocking.** The blueprint's mathematical recipe is unchanged
    under either Lean code shape.
  - **Sync_leanok mis-mark watch (informational, out-of-agent-scope per
    CLAUDE.md):** count is **3** suspect `\leanok` markers (L406, L524,
    L1152), unchanged from iter-142. All three sit on proof blocks
    whose underlying Lean declarations have inline sorries
    (`lem:GrpObj_mulRight_globalises`,
    `lem:GrpObj_omega_basechange_proj`,
    `lem:GrpObj_omega_basechange_proj_inv_derivation`). The
    deterministic `sync_leanok` phase appears to mark these `\leanok`
    even though the bodies contain sorries reached via the
    `letI ... := sorry` / `(fun _ => sorry)` / pure-term-sorry-arg
    constructions (rather than top-level `by sorry`). This is a
    `sync_leanok`-handling concern — flagged here only because the
    count is growing iter-over-iter. The iter-143 planner may consider an
    `archon-lean4:doctor` consult per the directive's special-focus
    item §2.

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer chapter, L46–L49)
  describes the three iter-138 sub-sorries as "d_app + d_map + IsIso"
  in its `relativeDifferentialsPresheaf_basechange_along_proj_two`
  bullet. After iter-142 closed d_map, the live three are "d_app +
  IsIso + (mulRight_globalises body)" — the pointer chapter's prose is
  technically stale, but the staleness is at the iter-138 status-text
  layer, not at any signature or recipe layer. Recommend a one-line
  update in the iter-143 review phase if the planner is calling a
  blueprint-writer anyway; otherwise informational.

- `Rigidity.tex` §"Use in the project" cites `thm:rigidity_over_kbar`
  via the `RigidityKbar.tex` chapter label; `RigidityKbar.tex` in turn
  consumes `thm:GrpObj_eq_of_eqOnOpen` from `Rigidity.tex` at C.2.b.
  Mutual references are consistent and accurate.

## Strategy-modifying findings (if any)

None. The iter-127 over-k commitment + the iter-142 prover-empirical
findings have not surfaced any inconsistency with STRATEGY.md.

## Severity summary

- **must-fix-this-iter**: NONE. The HARD GATE on
  `Cotangent/GrpObj.lean` is GREEN-LIT.
  No chapter has `complete: partial | false` or `correct: partial | false`.
  No route under "Multi-route coverage" is MISSING. No broken `\uses{}`
  cross-references were found. No `\lean{...}` hint in an M2-active
  route is poorly formulated.

- **soon** (cross-cutting, not blocking specific prover dispatch):
  1. Elevate the iter-142 empirical lessons (the
     `rw [show ... from NatTrans.naturality_apply ...]` packaging
     pattern, the change-fully-explicit-on-both-sides rule) from
     per-iter NOTE annotations into first-class steps of the d_app
     recipe at `RigidityKbar.tex:672–703`. This is a future-prover
     ergonomics improvement; the recipe is dispatchable as-is.
  2. Add a one-paragraph NOTE to the IsIso recipe at
     `RigidityKbar.tex:943–1073` pointing at the
     lean-auditor-recommended named-theorem refactor of the in-Lean
     `letI := isIso_of_app_iso_module ... (fun _ => sorry)` pattern.
     The blueprint's mathematical recipe is unchanged under either
     Lean code shape; this is a Lean-side encoding choice the iter-143+
     prover lane (or a refactor agent) can make at dispatch time.

- **informational**:
  1. Strip the two stale `\notready` markers at `Jacobian.tex:389`
     (`def:genusZeroWitness`) and `Jacobian.tex:424`
     (`def:positiveGenusWitness`) in the iter-143 review phase
     (review-agent's domain per CLAUDE.md marker vocab).
  2. Sync_leanok mis-mark count is now 3
     (`RigidityKbar.tex:406, 524, 1152`); growing iter-over-iter.
     Surface to iter-143 planner for an optional
     `archon-lean4:doctor` consult on the `sync_leanok` rule for
     `letI ... := sorry` / pure-term-sorry-argument constructions.
  3. Iter-138 status-text in
     `AlgebraicJacobian_Cotangent_GrpObj.tex:46–49` lists the three
     concrete sub-sorries as "d_app + d_map + IsIso"; iter-142 closed
     d_map so the live three are "d_app + IsIso + mulRight_globalises
     body". One-line update opportunity in the pointer chapter if the
     planner is dispatching a blueprint-writer anyway.

**Overall verdict:** the blueprint is dispatch-ready for iter-143's
intended prover lane on `Cotangent/GrpObj.lean`; the d_app and IsIso
recipes carry detailed, prover-ready prose plus all the Mathlib API
pointers iter-142's empirical work surfaced, and the in-tree gaps are
narrow concrete sub-pieces aligned with the chapter's existing
decomposition.
