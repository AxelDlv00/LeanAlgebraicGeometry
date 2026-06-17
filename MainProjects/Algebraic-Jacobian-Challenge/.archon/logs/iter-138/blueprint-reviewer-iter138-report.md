# Blueprint Review Report

## Slug
iter138

## Iteration
138

## Top-level summaries

### Incomplete parts
- `RigidityKbar.tex` / piece (i.b) — chapter is missing the **iter-137 `% NOTE`
  block** that the directive explicitly anticipates. The iter-138 plan
  agent is dispatching a blueprint-writer in parallel to add it, but as
  of this audit the only NOTE blocks on the three piece-(i.b) scaffolds
  are iter-135 (on `mulRight_globalises_cotangent` line 372 and on
  `_basechange_along_proj_two` line 452) and iter-136 (on
  `_restrict_along_identity_section` line 505). The iter-137 PARTIAL
  finding from the prover lane — that `PresheafOfModules.pullback` is
  opaque on `.obj`/`.map` (defined as `(pushforward φ).leftAdjoint`) and
  the chart-by-chart route therefore requires an intermediate ~30–60 LOC
  chart-unfolding helper — is **not yet recorded in the chapter prose**.
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` (line 471–480) —
  the proof prose **prescribes a chart-by-chart recipe via
  `tensorKaehlerEquiv` + `TopCat.Presheaf.pullback`** and does not
  acknowledge the opacity blocker. The closure path documented in
  `analogies/kaehler-tensorequiv-presheafpullback.md` (Decision 4
  universal-property-at-presheaf-level route) and in
  `task_results/Cotangent_GrpObj.lean.md` (Attempt 2 inverse-direction-
  via-adjunction-transpose route) is **not surfaced anywhere in the
  chapter**. Without these alternative closure paths in the blueprint,
  a prover dispatched against this lemma's `\lean{...}` target will
  re-discover the iter-137 PARTIAL gap.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` (line 34–42) — the
  `schemeHomRingCompatibility` helper is documented in the itemize-list
  prose with `\texttt{...}` only, but carries **no `\lean{...}` block**.
  The Lean declaration exists at
  `AlgebraicJacobian/Cotangent/GrpObj.lean:423`. This was flagged
  iter-137 and is explicitly named in the directive's Focus areas.

### Proofs lacking detail
- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises` Step 2 (line 405–
  409) — the proof outline says "$\Omega_{(G \times_k G)/G} \cong
  \pr_2^*\,\Omega_{G/k}$ via \cref{lem:GrpObj_omega_basechange_proj}",
  which is correct as far as it goes, but inherits the chart-opacity gap
  surfaced iter-137. Once the iter-137 NOTE block lands on the helper,
  this Step 2 prose should be updated to cross-reference the chosen
  closure path (chart-unfolding helper vs. inverse-direction-via-
  adjunction-transpose).
- `RigidityKbar.tex` / `lem:GrpObj_omega_free` (line 539–542) and
  `lem:GrpObj_omega_rank_eq_dim` (line 552–555) — both proofs are
  one-sentence sketches. Acceptable while the piece-(i.b) main lemma
  remains `\notready`; flag if they become an active prover target
  (currently they're below the critical-path piece (i.b) main lemma,
  so this is informational).

### Lean difficulty quality
- `AlgebraicJacobian_Cotangent_GrpObj.tex` / `schemeHomRingCompatibility`
  prose item — the prose names the declaration but a prover (or a
  cross-checker like `sync_leanok`) cannot trace it back to a declaration
  via the `\lean{...}` dependency graph. This is a poor-quality "implicit
  hint" — and the named target is part of the active piece-(i.b) closure
  chain (the `relativeDifferentialsPresheaf` adjunction-transpose
  packaging uses it). Must-fix per the severity rules.

### Multi-route coverage
- Route "over-k cotangent-vanishing pile via pieces (i)+(ii)+(iii)":
  PARTIAL — only piece (i) carries `\lean{...}` declarations
  (`RigidityKbar.tex` §subsec:RigidityKbar_piece_i_decomposition,
  lemmas (i.a) through (i.c)). Pieces (ii)
  (`Differential.ContainConstants` + `ext_of_diff_zero`) and (iii)
  (Frobenius-iteration) are documented as named pile components in
  §sec:RigidityKbar_shared_pile but lack `\lean{...}` declaration blocks
  because they are not yet active prover targets. This is correct
  scheduling (iter-138 plan agent is staying on piece (i.b) Step 2) and
  not a defect — flagging only so the plan agent remembers to dispatch
  blueprint-writers for (ii) and (iii) before launching provers on them.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 3 declarations (`def:ofCurve`, `lem:comp_ofCurve`,
    `thm:exists_unique_ofCurve_comp`), all with `\lean{...}` hints
    pinned to the protected `AlgebraicGeometry.Jacobian.*` interface.
    All have `\leanok` markers; proofs project the Albanese witness as
    documented. Classical remarks correctly bracket the Pic-scheme
    description. -

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **MUST-FIX**: `schemeHomRingCompatibility` (line 34) has prose only,
    no `\lean{...}` block. The Lean declaration is at
    `AlgebraicJacobian/Cotangent/GrpObj.lean:423`. Flagged iter-137,
    explicitly named in the iter-138 directive's Focus areas.
  - The itemise list otherwise correctly catalogues
    `cotangentSpaceAtIdentity`,
    `cotangentSpaceAtIdentity_eq_extendScalars`,
    `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`,
    `relativeDifferentialsPresheaf_basechange_along_proj_two`,
    `relativeDifferentialsPresheaf_restrict_along_identity_section`,
    and `mulRight_globalises_cotangent`. Each is paired with a
    `Statement~\cref{...}` pointer back to `RigidityKbar.tex`.
  - The pointer-chapter convention (no `\lean{...}` blocks in this
    file; they live in `RigidityKbar.tex`) is fine, but the
    `schemeHomRingCompatibility` exception — which is *not* mirrored
    in `RigidityKbar.tex` — leaves the helper invisible to the
    dependency graph.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 51 `\lean{...}` declarations, all with `\leanok`-bearing statement
    + proof blocks. The Mayer–Vietoris LES + two-affine cover + Čech
    acyclicity carrier chain is documented end-to-end.
  - Iter-137 carry-over (do not re-flag): label-prefix asymmetry on the
    MV side reference is acknowledged.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - One theorem (`thm:HasSheafCompose_forget`), `\leanok` on both
    statement and proof. Acts as the unblocking gateway for Phase A
    sheafification chain. -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 3 declarations (two `instHasSheafify/Ext` instances + one
    `Scheme.toAbSheaf`), all `\leanok`. -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 50+ `\lean{...}` declarations across the sheafification / Ext /
    `toModuleKSheaf` / `HModule(')` / Čech-cochain pipeline. All have
    `\leanok` statement + proof blocks. The downstream feed to the
    genus carrier is well-articulated in §sec:use_in_project.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 5 declarations (`def:relative_kaehler_presheaf`,
    `lem:relative_kaehler_presheaf_obj`,
    `thm:smooth_locally_free_omega`, plus the two
    standalone-K\"ahler-localisation utilities surviving the iter-126
    M1 excise). All `\leanok`.
  - Informational: the literal Lean identifier `appLE` leaks into the
    informal prose 8x ("the appLE algebra structure", "the appLE map
    $(f.\mathrm{appLE}\,U\,V\,e)$", etc.). A reader without Lean
    context will not parse this. Suggest a one-line glossary note or
    consistent macro; not blocking.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single declaration (`def:genus`), `\leanok`. The Mathlib-gap
    discussion correctly defers Serre finiteness as the open
    obligation. The user-authorisation note for `noncomputable` is
    well-recorded. -

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 11 `\lean{...}` declarations (`IsAlbanese` family +
    `Jacobian.inst*` + `JacobianWitness` + `nonempty_jacobianWitness`
    + the two iter-135 genus-arm scaffolds). The two `\notready`
    markers on `def:genusZeroWitness` (line 389) and
    `def:positiveGenusWitness` (line 424) correctly mirror the
    honest-scaffold sorries in `Jacobian.lean:197,223`.
  - The body of `thm:nonempty_jacobianWitness` (line 247–378) — the
    600-line Route A / Route B / genus-0 sub-case prose — is the
    project's deepest sketch and is correctly preserved.
  - Iter-137 carry-overs (do not re-flag): `Jacobian.tex:400` stale
    citation, `Jacobian.tex` C.2.d second-bullet prose thinness.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `thm:GrpObj_eq_of_eqOnOpen` (with the iter-125
    scheme-level refactor reflected in both statement and proof
    sketch), `\leanok`. -

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX** (focus area): the iter-137 PARTIAL finding from the
    prover lane on `_basechange_along_proj_two` surfaced a chart-
    opacity blocker (`PresheafOfModules.pullback` is opaque on `.obj`),
    and the chapter prose does not yet document it. The plan agent is
    dispatching a parallel blueprint-writer this iter to add a
    `% NOTE iter-137:` block documenting the blocker + the two
    alternative closure paths (chart-unfolding helper /
    inverse-direction-via-adjunction-transpose). As of this audit, no
    such block is present.
  - **MUST-FIX** (focus area): the proof of `lem:GrpObj_omega_basechange_proj`
    (line 471–480) prescribes the chart-by-chart recipe via
    `tensorKaehlerEquiv` + `TopCat.Presheaf.pullback`, but this
    recipe relies on chart-side reasoning through
    `PresheafOfModules.pullback`, which is opaque on `.obj`. The
    prose needs amendment (or a `% NOTE iter-137:` cross-reference)
    so a prover does not re-walk into the iter-137 PARTIAL gap.
  - The signature of `thm:rigidity_over_kbar` (line 18–32) is sound
    (over-k commitment, `[Field kbar]` no `[IsAlgClosed kbar]`),
    matches the Lean signature at `RigidityKbar.lean:75`. The
    `\leanok` marker on the statement is consistent with `genus C = 0`
    being a hypothesis and the abstract-curve encoding documented in
    the encoding note.
  - `\notready` markers on `lem:GrpObj_cotangent_bridge` (line 183),
    `lem:GrpObj_mulRight_globalises` (line 382),
    `lem:GrpObj_omega_basechange_proj` (line 463),
    `lem:GrpObj_omega_free` (line 535),
    `lem:GrpObj_omega_rank_eq_dim` (line 548) are honest scaffolds
    (per the directive's "do not re-flag" list).
  - The iter-136 NOTE block on
    `_restrict_along_identity_section` (line 505–518) correctly
    documents the in-tree closure (~27 LOC: helper 5 LOC + body 22
    LOC, comfortably inside the predicted envelope).
  - Pieces (ii) and (iii) of the shared cotangent-vanishing pile are
    documented as named pile components in
    §sec:RigidityKbar_shared_pile but lack `\lean{...}` declarations.
    Acceptable while they're not active prover targets; flag for the
    iter that promotes them.

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` and `RigidityKbar.tex` share
  ownership of the `Cotangent/GrpObj.lean` Lean file. The pointer
  chapter's prose itemize list mentions `schemeHomRingCompatibility`
  but `RigidityKbar.tex` (where `\lean{...}` declarations live) does
  not. Either the pointer chapter should host a `\lean{...}` block for
  this declaration, or `RigidityKbar.tex` should grow one. The plan
  agent should pick a chapter and assign the writer accordingly.

- `Jacobian.tex` line 247–378 (the `thm:nonempty_jacobianWitness` body)
  and `RigidityKbar.tex` (the named declaration `thm:rigidity_over_kbar`)
  cross-reference each other heavily on the C.2 sub-step labels. The
  cross-references are consistent and the over-k commitment is uniformly
  reflected (no surviving `[IsAlgClosed]` / Galois-descent vestiges).
  Healthy.

- `Cohomology_StructureSheafModuleK.tex` and `Cohomology_MayerVietoris.tex`
  share the carrier predicates (`HasCechToHModuleIso`,
  `HasAffineCechAcyclicCover`); cross-references are well-formed.
  Iter-137 carry-over label-prefix asymmetry (do not re-flag).

## Strategy-modifying findings (if any)

None this iter. The iter-127 over-k commitment remains internally
consistent across all chapters (no surviving alg-closure / Galois-
descent vestiges in `Jacobian.tex` C.2 sub-steps, `RigidityKbar.tex`
piece-(i) decomposition, or `Rigidity.tex` lemma statement). The
iter-138 piece-(i.b) Step 2 PARTIAL is a tactical proof-script gap, not
a strategic blueprint conflict — the chart-opacity blocker is a
Mathlib-API-discovery problem that has two known alternative closure
paths, both documented in analogist files; the chapter just needs to
inherit the documentation.

## Severity summary

- **must-fix-this-iter** (3 items, all chapter-bound):
  1. `RigidityKbar.tex` — chapter is `complete: partial` /
     `correct: partial`. Missing iter-137 `% NOTE` block on
     `_basechange_along_proj_two` + `mulRight_globalises_cotangent`,
     and the proof prose on `lem:GrpObj_omega_basechange_proj` still
     prescribes the chart-by-chart recipe without acknowledging the
     opacity blocker. **The iter-138 plan agent has already dispatched
     a parallel blueprint-writer to fix this.** Per the hard-gate rule,
     no prover should dispatch against `relativeDifferentialsPresheaf_basechange_along_proj_two`
     until the writer's commit lands.
  2. `AlgebraicJacobian_Cotangent_GrpObj.tex` — chapter is
     `complete: partial`. `schemeHomRingCompatibility` lacks a
     `\lean{...}` block, leaving it invisible to the dependency graph.
     Either the pointer chapter or `RigidityKbar.tex` should grow one
     (suggest the pointer chapter to keep the per-Lean-file convention
     clean).
  3. Implicit broken `\uses{}` consequence: any cross-chapter `\uses{}`
     that would reach `schemeHomRingCompatibility` cannot — because no
     label exists. No chapter currently `\uses{schemeHomRingCompatibility}`
     by label, but the situation is structurally identical to a broken
     `\uses{}` and would be flagged the moment a downstream lemma is
     authored that depends on the helper.

- **soon** (1 item):
  - Pieces (ii) (`Differential.ContainConstants` + `ext_of_diff_zero`)
    and (iii) (Frobenius-iteration) of the shared cotangent-vanishing
    pile lack `\lean{...}` declarations in `RigidityKbar.tex`. They
    are documented as named pile components in
    §sec:RigidityKbar_shared_pile and are not yet active prover
    targets, so this is informational; the plan agent should dispatch
    a blueprint-writer for each in the iter that promotes them.

- **informational** (1 item):
  - `Differentials.tex` leaks the literal Lean identifier `appLE`
    into informal prose 8 times. A reader without Lean context will
    not parse this. Minor naming-drift cleanup; not blocking.

**Overall verdict**: Two chapters (`RigidityKbar.tex` and
`AlgebraicJacobian_Cotangent_GrpObj.tex`) carry must-fix findings tied
to the iter-138 piece-(i.b) Step 2 prover target; the parallel
blueprint-writer dispatch the plan agent already issued addresses the
load-bearing one (`RigidityKbar.tex`), and a second writer (or the same
one extended) should add the `schemeHomRingCompatibility` `\lean{...}`
block to the pointer chapter before any prover round resumes on
`_basechange_along_proj_two`.
