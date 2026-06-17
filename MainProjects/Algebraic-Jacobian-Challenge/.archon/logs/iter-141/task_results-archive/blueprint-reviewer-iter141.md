# Blueprint Review Report

## Slug
iter141

## Iteration
141

## Top-level summaries

### Incomplete parts
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof (d_app NOTE block,
  L602–L659): the iter-140 prover lane validated (standalone via
  `lean_run_code`) a concrete **factoring-lemma pattern** — explicit
  construction of `h : Source ⟶ ((pullback fst.left.base).obj
  G.left.presheaf).obj (snd⁻¹X)` with `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app
  X) ≫ (ψ.app X)`, then apply `Derivation.map_algebraMap` — that is
  **not** in the blueprint. Blueprint d_app recipe stops at "the composite
  factors through the source-presheaf morphism" without naming the
  Mathlib lemma to chain (`Derivation.map_algebraMap`) or showing the
  algebra/module/scalar-tower instance chain. The recipe is "informally
  correct" but the iter-140 task_results (`Cotangent_GrpObj.lean.md`
  §"d_app: detailed gap" L68–L108) carries the load-bearing concrete
  closure that should be lifted.
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof (d_map NOTE
  block, L661–L708): silent on the iter-140 `whnf`-opacity-on-
  `pushforward.obj.map` discovery. The blueprint asserts that the
  `((pushforward ψ).obj LHS).map f = LHS.map (snd⁻¹f)` identification is
  "definitional (transparent)" (L703–L708) — but iter-140 reverted a
  `change`-based scaffold because of a **deterministic `whnf` timeout
  at maxHeartbeats=200000** at the d_map field elaboration site
  (`task_results/Cotangent_GrpObj.lean.md` L137–L143). Two consecutive
  iters (139, 140) attacked this lane; a third without the advisory
  will likely re-discover the timeout.

### Proofs lacking detail
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` (d_app): the
  conceptual recipe is present but does not name `Derivation.map_algebraMap`
  as the closing Mathlib lemma, does not show the
  `Algebra/Module/IsScalarTower` triple needed to invoke it, and does not
  pin the post-`change` goal shape. The iter-140 prover-lane validation
  (`lean_run_code` example with full instance discharge) is the missing
  prose, currently lying only in task_results.
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` (d_map): the
  recipe names two pieces (ψ-naturality, `relativeDifferentials'_map_d`)
  but does not warn that the `change (CommRingCat.KaehlerDifferential.D
  _).d _ = _` approach causes a `whnf` timeout, nor that the pattern
  used for d_add/d_mul (`change` + `rw`) is contraindicated here.
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` (IsIso Route
  (b'2)): the four iter-140 gap items are enumerated in build order
  (L917–L928), but iter-140 actually shipped item (1) only (the
  `isIso_of_app_iso_module` helper at `Cotangent/GrpObj.lean:544`)
  while marking the per-open sorry as the residual. The blueprint's
  "iter-140 prover gap items" framing presents all 4 as iter-140
  targets, which would mis-set expectations for the iter-141 prover.
  Update needed to reflect iter-140 actual progress (item 1 closed,
  items 2–4 are iter-141+).

### Lean difficulty quality
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}`:
  the target itself is well-formulated (verbatim signature stub at
  L456–L472; matches the Lean target at `Cotangent/GrpObj.lean:670`),
  but the residual per-open sorry inside the `isIso_of_app_iso_module
  (fun _ => sorry)` pattern is implicit in the prose. A consumer reading
  only the chapter (without `Cotangent/GrpObj.lean`) would not know the
  exact residual sorry has type `∀ X, IsIso ((basechange_along_proj_two_inv
  G).app X)` (iter-140 narrowed it from "whole iso" to "per-open").
  Worth pinning in a small iter-140 NOTE block for prover clarity.
- All other `\lean{...}` hints across the blueprint are precise (verbatim
  signature stubs reproduced in commented Lean blocks).

### Multi-route coverage

Strategy single-route on the active critical path (genus-0 Albanese
witness via `\cref{thm:rigidity_over_kbar}` + the shared cotangent-
vanishing pile pieces (i)+(ii)+(iii); positive-genus arm parked
off-critical-path as M3). Both arms have blueprint coverage:

- Active route "genus-0 via piece (i)+(ii)+(iii) over k": **COVERED** in
  `RigidityKbar.tex` §`subsec:RigidityKbar_piece_i_decomposition` (piece
  i.a/i.b/i.c sub-lemmas) and `Jacobian.tex` §`sec:genusZeroWitness`
  (witness construction). Piece (ii) and piece (iii) are catalogued in
  `RigidityKbar.tex` §`sec:RigidityKbar_shared_pile` but have no
  dedicated sub-section yet — informational only, since piece (i.b)
  is the active blocker.
- Off-critical-path route "positive-genus via Route A (Pic-scheme) or
  Route B (Sym^g+Stein)": **COVERED** in `Jacobian.tex`
  §`sec:positiveGenusWitness` and §"Existence of an Albanese variety"
  (Routes A and B prose at L255–L311). Both routes mark themselves as
  Mathlib-gap-blocked and currently OFF-CRITICAL-PATH per STRATEGY.md.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three Layer-II projections (`def:ofCurve`, `lem:comp_ofCurve`,
    `thm:exists_unique_ofCurve_comp`) cleanly project from the Albanese
    witness; classical Pic-scheme prose is correctly marked as not
    replayed in Lean.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pointer chapter (no original mathematical content); itemised list of
    nine Lean declarations matches the file's `\lean{...}` set in
    `RigidityKbar.tex` and the Lean targets at `Cotangent/GrpObj.lean`.
  - The list's status annotations are slightly out-of-date relative to
    iter-140 (e.g. `mulRight_globalises_cotangent` annotated "iter-138
    prover landed PARTIAL"; iter-139 and iter-140 made further
    progress without updating this line). Informational only — does not
    affect prover-readiness.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter (947 lines), every `\lean{...}` carries `\leanok` on
    both statement and proof; auxiliary chapter (no protected decls).
  - Producer status for `HasCechToHModuleIso` + `HasAffineCechAcyclicCover`
    is honestly documented as currently unproduced (L946–L948), with
    the genus carrier shipping as conditional under those two
    hypotheses. Consistent with the conditional-theorem-status the
    chapter advertises.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter (655 lines), thorough infrastructural coverage; every
    `\lean{...}` declaration has a clean signature stub. Stein-finiteness
    producer instance `inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf`
    closes the `\Module.Finite` story for proper integral curves.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Standalone K\"ahler-localization utilities (`lem:kaehler_localization_subsingleton`,
    `lem:kaehler_quotient_localization_iso`) preserved post-iter-126 M1
    excise; converse direction documented as out-of-scope M4 with
    explicit counterexample and the Mathlib lemma's three hypotheses.
  - `thm:smooth_locally_free_omega` is the load-bearing existential
    consumed by piece (i.a) (`cotangentSpaceAtIdentity_finrank_eq`)
    and by piece (i.b) (chart-level Algebra.IsPushout for
    `basechange_along_proj_two`); proof steps are all `[verified]`
    Mathlib lemmas.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genusZeroWitness` (L389) and `def:positiveGenusWitness`
    (L424) carry `\notready` on the statement block but are formalized
    in `AlgebraicJacobian/Jacobian.lean` (per the iter-140 review-agent
    territory). Per CLAUDE.md, `\notready` on a formalized statement is
    stale — review-agent's job to strip, not blueprint-writer's.
    Flagged informational; not a must-fix-this-iter item.
  - The C.2.f DROPPED iter-127 commitment is consistently threaded
    through every section that previously referenced base-change-and-
    descent; no stale Galois-descent references remain.
  - Layer-I projection identifications (`thm:Jacobian_grpObj`,
    `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`,
    `thm:Jacobian_geomIrred`) all correctly delegate to the witness.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-125 refactor (dropping the source-side group-object
    hypothesis, weakening target to `IsSeparated`) is documented;
    consumer-side packaging into M2.a is consistent with `\cref{thm:rigidity_over_kbar}`'s
    use in `RigidityKbar.tex` and `def:genusZeroWitness` in `Jacobian.tex`.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **(d_app gap, must-fix-this-iter)** The d_app NOTE block (L602–L659)
    gives a 3-step categorical-chase recipe but does not include the
    iter-140 prover's validated `Derivation.map_algebraMap`-based
    factoring-lemma pattern (verified standalone via `lean_run_code`,
    in `task_results/Cotangent_GrpObj.lean.md` L45–L57). Without this
    lifted in, an iter-141 prover working from the blueprint alone
    would re-derive what iter-140 already proved.
  - **(d_map gap, must-fix-this-iter)** The d_map NOTE block (L661–L708)
    asserts `((pushforward ψ).obj LHS).map f = LHS.map (snd⁻¹f)` is
    "definitional (transparent per
    `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39,
    86`) — `pushforward = pushforward₀ ∘ restrictScalars`" (L703–L707),
    but iter-140 found that the `change`-based attempt times out in
    `whnf` at maxHeartbeats=200000 (`task_results/Cotangent_GrpObj.lean.md`
    L137–L143). Blueprint must add an advisory note that the
    `change`-based pattern that closed d_add/d_mul is **contraindicated**
    for d_map.
  - **(IsIso gap-items framing, must-fix-this-iter)** The "Iter-140
    prover gap items, in build order" list at L917–L928 presents all
    four items as iter-140 targets, but iter-140 shipped item (1) only.
    Items (2)–(4) should be re-labelled as iter-141+ targets and the
    iter-140 partial closure (helper + structural narrowing of the
    sorry from "whole iso" to "per-open iso") should be recorded.
  - **(stale-marker triage, informational)** Per the iter-140 lean-vs-
    blueprint-checker `\notready` markers persist on statement blocks
    at L382 (`lem:GrpObj_mulRight_globalises`), L481
    (`lem:GrpObj_omega_basechange_proj`), L985
    (`lem:GrpObj_omega_basechange_proj_inv_derivation`), L1067
    (`lem:GrpObj_omega_basechange_proj_inv`); and `\leanok` markers on
    proof blocks at L402, L505, L1032 cover proofs with body sorries.
    Both belong to the review-agent / `sync_leanok` workflow, not the
    blueprint-writer's; flagged here purely for cross-reference, not
    as must-fix items for this dispatch.
  - **(iter-139 NOTE block staleness, informational)** The NOTE block at
    L491–L504 (about the `letI := sorry` pattern's `sync_leanok` mis-
    mark concern) references the iter-138 pattern shape; iter-140's
    refactor moved the pattern to `(fun _ => sorry)` inside
    `isIso_of_app_iso_module`. The note's concern remains valid (sorry
    persists, so the proof block's `\leanok` is still a mis-mark
    candidate) but the pattern citation is no longer current.

## Cross-chapter notes

- `RigidityKbar.tex` (the pointer chapter
  `AlgebraicJacobian_Cotangent_GrpObj.tex` points at it for piece (i.b)
  content) and `Cotangent/GrpObj.lean` are in good cross-sync at the
  signature level. The drift is at the **proof-recipe** level: iter-140
  task_results carries concrete lemma names and instance chains the
  blueprint does not yet absorb.
- The `Differentials.tex` Lean target `thm:smooth_locally_free_omega` is
  cited by both `lem:GrpObj_cotangentSpace` and
  `lem:GrpObj_lieAlgebra_finrank` (Steps 1+2 of the iter-132 closure).
  Consistent — both chapters' usage matches the Lean signature.
- `Jacobian.tex` cites `thm:rigidity_over_kbar` (in `def:genusZeroWitness`
  at L407) and `Rigidity.tex`'s `thm:GrpObj_eq_of_eqOnOpen` (at L82, L394).
  Consistent — both Lean targets exist.
- No broken `\uses{}` cross-references detected across the 11 chapters.

## Strategy-modifying findings (if any)

None. The active strategy (rigidity over k via shared cotangent-vanishing
pile pieces (i)+(ii)+(iii), with piece (i.b) the current blocker) is
internally consistent with the blueprint coverage.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` (d_app gap): lift iter-140's validated
    `Derivation.map_algebraMap`-based factoring-lemma pattern into the
    d_app NOTE block. Source: `task_results/Cotangent_GrpObj.lean.md`
    §"d_app: detailed gap" L68–L108.
  - `RigidityKbar.tex` (d_map gap): add a `whnf`-opacity-on-
    `pushforward.obj.map` advisory; warn that the d_add/d_mul `change`-
    based pattern is contraindicated. Source: same file, L137–L143.
  - `RigidityKbar.tex` (IsIso framing): update L917–L928 to reflect
    iter-140 actual progress (item 1 closed via `isIso_of_app_iso_module`
    helper at `Cotangent/GrpObj.lean:544`, items 2–4 remain iter-141+).
  - `RigidityKbar.tex` (per-open IsIso pin): add a small NOTE block
    pinning the exact type of the iter-141 residual sorry: `∀ X,
    IsIso ((basechange_along_proj_two_inv G).app X)`, sitting inside
    `isIso_of_app_iso_module ... (fun _ => sorry)` at
    `Cotangent/GrpObj.lean:689`.
- **soon**:
  - `AlgebraicJacobian_Cotangent_GrpObj.tex` pointer-list status
    annotations are slightly stale (still cite "iter-138 prover landed
    PARTIAL"). Optional refresh; not blocking.
  - The iter-139 NOTE block at `RigidityKbar.tex` L491–L504 needs a
    minor edit to reflect that iter-140 moved the pattern from `letI :
    ... := sorry` to `(fun _ => sorry)` inside
    `isIso_of_app_iso_module`. The `sync_leanok` concern still applies;
    only the pattern citation is dated.
- **informational**:
  - Stale `\notready` markers on formalized statement blocks of
    `Jacobian.tex` (L389, L424) and `RigidityKbar.tex` (L382, L481, L985,
    L1067) — review-agent / `sync_leanok` territory.
  - Stale `\leanok` markers on three proof blocks with body sorries
    (`RigidityKbar.tex` L505, L1032; and `Jacobian.tex` proof blocks of
    `def:genusZeroWitness`/`def:positiveGenusWitness` carrying `\leanok`
    on sorry-bodied proofs) — same review-agent territory.

## HARD GATE verdict for `AlgebraicJacobian/Cotangent/GrpObj.lean`

**DEFER the prover lane on `Cotangent/GrpObj.lean` this iter and
dispatch a `blueprint-writer` to `RigidityKbar.tex` instead.**

Per the dispatcher rule: `RigidityKbar.tex` (which is the substantive
chapter for `Cotangent/GrpObj.lean` per the slug mapping, with the
pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` re-routing to
it) has **complete: partial** and **correct: partial** on three
must-fix-this-iter items tied to the **same three sub-sorries** the
planner is considering re-dispatching a prover for. Specifically:

1. The d_app closure recipe is conceptually correct but missing the
   load-bearing concrete factoring-lemma pattern that iter-140 prover
   validated standalone. An iter-141 prover working from the blueprint
   alone would re-derive what iter-140 already discovered.
2. The d_map closure recipe contains a **factually incorrect** claim of
   `whnf` transparency (contradicted by iter-140's `whnf`-timeout
   discovery at maxHeartbeats=200000). A prover working from the
   blueprint would attempt the same `change`-based approach that
   iter-140 reverted.
3. The IsIso "iter-140 prover gap items" framing presents items
   already-closed (item 1, the helper) alongside items not yet attempted
   (items 2–4), with no signal as to which is which. An iter-141
   prover would have no anchor for which item the iter-140 helper
   actually delivered.

Re-dispatching the same prover lane against the same blueprint a third
consecutive iter, with the iter-140 ground truth (concrete lemma names,
the `whnf` opacity advisory, the helper actually shipped) not lifted
in, is the CHURNING trap the gate rule exists to prevent. The
1-iter latency cost of a blueprint-writer pass is dominated by the cost
of another PARTIAL iter producing 0 net sub-sorries closed.

The blueprint-writer directive should target:
- `RigidityKbar.tex` d_app NOTE block (L602–L659): lift the iter-140
  factoring-lemma pattern.
- `RigidityKbar.tex` d_map NOTE block (L661–L708): add `whnf`-opacity
  advisory; flag d_add/d_mul-style `change` pattern as contraindicated.
- `RigidityKbar.tex` IsIso gap-items list (L917–L928): re-label items
  2–4 as iter-141+ targets; record iter-140 helper landing.
- (Optional) Add a NOTE block pinning the exact residual per-open sorry
  type at `Cotangent/GrpObj.lean:689`.

Sources for the writer: `task_results/Cotangent_GrpObj.lean.md` (iter-140
prover report) and `task_results/lean-vs-blueprint-checker-cotangent-
grpobj-review140.md` (iter-140 lean-vs-blueprint checker).

Overall verdict: **PARTIAL** — 11 chapters audited, 10 chapters
`complete: true / correct: true`; `RigidityKbar.tex` carries three
must-fix-this-iter items tied to the active prover-lane sub-sorries and
should be sent to a blueprint-writer before the next prover dispatch
on `Cotangent/GrpObj.lean`.
