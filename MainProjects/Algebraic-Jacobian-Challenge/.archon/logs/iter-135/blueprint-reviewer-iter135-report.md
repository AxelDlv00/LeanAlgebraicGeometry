# Blueprint Review Report

## Slug

iter135

## Iteration

135

## Scope

Whole-blueprint audit per descriptor. All 11 chapter files under
`blueprint/src/chapters/*.tex` read; `content.tex` and
`macros/common.tex` cross-checked. (The directive's "14 chapters" count
appears to have included `content.tex`, `web.tex`, `print.tex`, and
macros files — the actual chapter count is 11.)

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` — no standalone `\begin{lemma}\lean{...}` block
  for `AlgebraicGeometry.GrpObj.shearMulRight`. The declaration is
  listed in `AlgebraicJacobian_Cotangent_GrpObj.tex` (line 24) and
  invoked by name inside the proof body of
  `lem:GrpObj_mulRight_globalises` (Step 1, line 369 — "$\sim 30$--$60$
  LOC NEEDS\_MATHLIB\_GAP\_FILL"), but the binary-product shear iso
  $\sigma = \langle \pr_1, \mu\rangle$ has no dedicated statement
  block. Confirms directive item 2.
- `Jacobian.tex` — no `\lean{positiveGenusWitness}` block covering the
  iter-134 scaffold (per directive item 6). The only mention of
  `positiveGenusWitness` in the entire blueprint is a parenthetical
  inside an iter-134 NOTE comment at
  `RigidityKbar.tex:334`; `Jacobian.tex` itself has zero references.
  `def:genusZeroWitness` covers the genus-$0$ arm but the
  positive-genus side is now scaffolded in Lean without blueprint
  coverage.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — chapter file exists in
  `chapters/` but is NOT `\input`-included by `content.tex`. It is
  therefore orphaned at the rendered level: the pointer chapter never
  appears in the PDF / web blueprint. Either it should be wired in via
  `\input{chapters/AlgebraicJacobian_Cotangent_GrpObj}` or the file
  should be removed (since the substantive prose lives in
  `RigidityKbar.tex` § "Piece (i)" by design).

### Proofs lacking detail

- None at the must-fix level. The three (i.b) lemma blocks in
  `RigidityKbar.tex` (`lem:GrpObj_mulRight_globalises`,
  `lem:GrpObj_omega_basechange_proj`,
  `lem:GrpObj_omega_restrict_to_identity_section`) carry detailed
  proof sketches with explicit Mathlib name summaries, LOC budgets,
  and the categorical decomposition (shear-iso construction $\to$
  base-change of differentials $\to$ section restriction). The proof
  prose is dense and adequate for a future prover lane working from
  honest-scaffold signatures.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{mulRight_globalises_cotangent}` (line 284,
  signature stub at lines 298–305): the intended type is pinned
  explicitly inside the comment block as `relativeDifferentialsPresheaf
  G.hom ≅ (PresheafOfModules.pullback (φ_str G)).obj
  ((PresheafOfModules.pullback (φ_η G)).obj (relativeDifferentialsPresheaf
  G.hom))`. Adequate for the iter-135 refactor lane to consume.
- `RigidityKbar.tex` /
  `\lean{relativeDifferentialsPresheaf_basechange_along_proj_two}` (line
  391, signature stub at lines 400–416): same quality — intended type
  explicit, with the LHS/RHS asymmetry between `pr_1` and `pr_2`
  documented. Adequate.
- `RigidityKbar.tex` /
  `\lean{relativeDifferentialsPresheaf_restrict_along_identity_section}`
  (line 453, signature stub at lines 458–471): same quality. Adequate.
  (Caveat on line numbers: the directive cites lines 298–305 / 384–399 /
  427–441 for these three. The first range is exact; the other two are
  approximately right but actually sit at 400–416 and 458–471. Not a
  semantic issue — the stubs are findable and unambiguous.)

### Multi-route coverage

Single-route project at this point. The strategy's three classical
routes for `nonempty_jacobianWitness` (Picard scheme A / Stein
factorisation B / rigidity over $k$ C+genus-0) are catalogued in
`Jacobian.tex` § "Existence of an Albanese variety" with explicit
Mathlib-gap analyses for each; the iter-127 over-k commitment pins
genus-$0$ (route C) as the live arm, with A and B documented as
deferred-by-Mathlib-cost. Coverage: PASS — all three routes have prose
in the chapter, with C uniquely scaffolded as the Lean-side live work
via `def:genusZeroWitness` + `thm:rigidity_over_kbar`.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) each cleanly project from the
    Albanese witness `IsAlbanese C P (Jac C)`; proof sketches reference
    the right witness fields. Classical Pic-scheme description is
    factored into remarks (mathematically equivalent, Lean-not-replayed).

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Orphaned: file exists in `chapters/` but is NOT included in
    `content.tex`. Decide between wiring it in (`\input{chapters/...}`
    after `\input{chapters/RigidityKbar}` so the per-Lean-file
    convention is honoured in the rendered output) or removing the
    file. The chapter intro itself says the file's role is to "satisfy
    the per-Lean-file blueprint convention (one chapter per Lean
    file)" — but if it's never rendered, that convention is not
    actually satisfied at the dashboard / dependency-graph level.
  - The chapter lists `AlgebraicGeometry.GrpObj.shearMulRight` (line
    24) as a Lean declaration in the file, but `RigidityKbar.tex` has
    no `\lean{...shearMulRight}` block — the declaration appears only
    inside the body of `lem:GrpObj_mulRight_globalises`'s proof Step 1.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Three broken `\ref`s.** Line 769 references
    `\ref{sec:basic_open_infrastructure}` and
    `\ref{sec:basic_open_acyclicity}` — neither label exists anywhere
    in the blueprint sources. (The `blueprint/web/` HTML cache
    contains matches because it was generated from an earlier
    pre-refactor version of this chapter; the current TeX has six
    `\label{sec:...}`s: `hmodule_prime_cohomologyPresheaf`,
    `hmodule_prime_mayer_vietoris`, `scheme_affineCoverMVSquare`,
    `cover_totality`, `cech_acyclicity`, `mv_use_in_project` — none of
    the two referenced.) Line 917 references
    `\ref{def:Scheme_IsAffineHModuleVanishing}` — the actual label in
    `Cohomology_StructureSheafModuleK.tex:358` is
    `thm:Scheme_IsAffineHModuleVanishing` (prefix mismatch). All three
    silently corrupt the dependency graph.
  - Chapter prose, definitions, and proofs are otherwise rich and
    detailed; the Mayer–Vietoris LES construction, four ext-bridge
    lemmas, the $X_4$ corner bridge, and the Čech-acyclicity machinery
    are all present with proof sketches at full detail.
  - "Producer status" remark at end of § `sec:mv_use_in_project`
    honestly flags the two carrier typeclasses
    (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`) as
    currently unproduced — conditional theorems shipped honestly.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter; statement, proof, "Use in the project"
    chain, and Lean implementation remark are all in place. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three Phase-A pieces (sheafification on opens, `Ext` on opens,
    `toAbSheaf`) plus the use-in-project chain. Cross-refs to
    `chap:Cohomology_SheafCompose` consistent. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **Label-prefix asymmetry (3 sites).** `\begin{definition}` blocks
    at lines 358 (`Scheme_IsAffineHModuleVanishing`), 386
    (`Scheme_IsAffineHModuleHomFinite`), and 440
    (`Scheme_IsHModuleHomFinite`) all carry `\label{thm:...}` prefixes,
    while every other definition block in the chapter uses `def:`. This
    is the source of the broken-ref-with-`def:` at
    `Cohomology_MayerVietoris.tex:917`. Either re-label the three sites
    to `def:` (and update internal `\uses{}` chains within this chapter
    plus the cross-ref at MayerVietoris:917) or accept the asymmetry
    and fix only the MayerVietoris-side ref. The latter is the lighter
    touch.
  - Otherwise the chapter is complete and detailed: 23 declarations
    spanning sheafification, $\Ext$, the `toModuleKSheaf` algebra-map
    construction, $H^0$ bridges, the carrier-class predicates, and the
    Stein-finiteness producer chain. Proof sketches are adequate.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Forward smoothness criterion (`thm:smooth_locally_free_omega`) with
    five-step proof and verified Mathlib name list; the two surviving
    K\"ahler-localisation utilities (post-iter-126 M1 excise) carry
    `\leanok`. The "converse is false" sub-section with explicit
    counterexample (`rem:converse_counterexample`) is mathematically
    sharp. Future-milestone bullets (M5–M8) honestly named. No issues.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-definition chapter with honest discussion of the remaining
    Mathlib gap (Serre finiteness for $H^i(C, \mathcal F)$ on a
    proper $k$-curve), the `noncomputable` modifier authorisation,
    and the scope boundary ("this iteration defines, does not
    compute"). No issues.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **Missing `\lean{positiveGenusWitness}` block** for the iter-134
    Lean scaffold (per directive item 6). The genus-$0$ arm has the
    explicit construction `def:genusZeroWitness` (lines 383–411) with
    full proof sketch; the positive-genus arm needs a parallel block.
    The current chapter routes positive-genus existence through
    `thm:nonempty_jacobianWitness` only at the level of "Route A /
    Route B" deferral analysis, with no Lean target named.
  - Otherwise: clean four-protected-theorem core (`grpObj`, `proper`,
    `smooth_genus`, `geomIrred`), uniformly-over-$P$ witness bundle
    `JacobianWitness`, the three-route + genus-0 existence analysis
    with explicit Mathlib-gap statements, the
    iter-127 over-k commitment threading.
  - `\uses{}` cross-refs in proof bodies (e.g.\
    `thm:GrpObj_eq_of_eqOnOpen`, `def:genusZeroWitness`,
    `thm:rigidity_over_kbar`) all resolve.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter (`thm:GrpObj_eq_of_eqOnOpen`) with full
    proof sketch (three load-bearing instances explicitly named) and
    "Use in the project" listing the two downstream consumers
    (`thm:rigidity_over_kbar` and `thm:exists_unique_ofCurve_comp`).
    Mathlib status section is precise. No issues.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **No standalone `lem:GrpObj_shearMulRight` block** (per directive
    item 2). The shear iso $\sigma = \langle \pr_1, \mu\rangle$ in
    $\Over(\Spec k)$ is the binary-product upgrade of
    `CategoryTheory.GrpObj.mulRight` and is constructed inside the
    proof of `lem:GrpObj_mulRight_globalises` Step 1 (line 369,
    "$\sim 30$--$60$ LOC NEEDS\_MATHLIB\_GAP\_FILL"). Per
    `AlgebraicJacobian_Cotangent_GrpObj.tex:24` it ships as a separate
    Lean declaration `AlgebraicGeometry.GrpObj.shearMulRight` —
    needs its own blueprint block so it appears in the dependency
    graph and can be cited as a `\uses{...}` premise of
    `lem:GrpObj_mulRight_globalises`.
  - **Three iter-134 NOTE-block flags retained**: the `\notready`
    markers on `lem:GrpObj_mulRight_globalises` (line 340),
    `lem:GrpObj_omega_basechange_proj` (line 431), and
    `lem:GrpObj_omega_restrict_to_identity_section` (line 485) are
    correctly placed — the Lean side ships tautological-iso
    placeholders, per the NOTE prose at lines 323–339, 418–430,
    473–484. The blueprint statements themselves are sound, the
    intended Lean types are pinned in the signature-stub comments,
    and proof-sketch text is adequate for a refactor or prover lane
    against honest-scaffold signatures. The chapter is "honest" about
    the placeholder discrepancy.
  - **Stale Lean-line citations (informational, per directive item
    5).** Line 159 cites `AlgebraicJacobian/Cotangent/GrpObj.lean:198--219`
    for the body of
    `cotangentSpaceAtIdentity_eq_extendScalars`. Line 493 (inside the
    Step 3 proof of
    `lem:GrpObj_omega_restrict_to_identity_section`) references
    `AlgebraicJacobian/Cotangent/GrpObj.lean:508`. The iter-134
    review flagged these as likely stale; cannot verify without
    reading the Lean file (out of read-only scope). The line
    citations at the iter-134 NOTE blocks themselves (`:566`, `:476`,
    `:508`) for the three placeholder declarations are also likely
    drift-prone after the iter-135 refactor lane lands — the cleanup
    pass should de-pin line numbers or update them post-refactor.
  - Otherwise the chapter is mathematically dense and complete: the
    keystone theorem `thm:rigidity_over_kbar` (line 19) is fully
    stated with the encoding note; § `sec:RigidityKbar_proof_decomposition`
    runs the C.2.b–C.2.e decomposition cleanly; §
    `sec:RigidityKbar_shared_pile` decomposes the cotangent-vanishing
    pile into (i)+(ii)+(iii)+(iv-deferred) with per-piece LOC budgets
    and the iter-127 over-k commitment threaded; §
    `subsec:RigidityKbar_piece_i_decomposition` decomposes piece (i)
    into (i.a)+(i.a-bridge)+(i.a-rank)+(i.b)+(i.b-helper×2)+(i.c)+(i.c-rank)
    with each Lean target pinned by name. The "Iter-131
    `Classical.choose`-chain body shape" paragraph is dense Lean-encoding
    documentation that should aid downstream consumers.

## Cross-chapter notes

- **The MayerVietoris broken refs and the StructureSheafModuleK label
  asymmetry are linked.** Fixing one without the other leaves the
  graph half-corrupt. Recommend the cleanup writer either (a) re-label
  the three `\begin{definition}` blocks at
  `Cohomology_StructureSheafModuleK.tex:358, 386, 440` from `thm:` to
  `def:` AND fix the MayerVietoris:917 ref to match, OR (b) leave the
  three `thm:` labels and only update MayerVietoris:917 to use `thm:`
  prefix. Option (b) is the smaller surface and preserves the
  pre-existing label IDs; option (a) is more semantically honest but
  has wider blast radius (any other `\uses{thm:Scheme_IsAffine...}`
  inside the K-chapter must be updated too — quick grep confirms two
  more uses at the same chapter's lines 368 and 373).
- **`AlgebraicJacobian_Cotangent_GrpObj.tex` orphan + missing
  `lem:GrpObj_shearMulRight` block** combine into a single
  consistency drift: the per-Lean-file convention is being honoured
  in the file list at line 24 (which names `shearMulRight`) but not
  in the dependency-graph view (because the file is unincluded and
  `shearMulRight` has no statement block elsewhere). Either route
  produces blueprint coverage for the Lean declaration.
- The `\lean{...}` hints in `Jacobian.tex` resolve to declarations the
  iter-134 pre-rebuild trace appears to confirm exist
  (`nonempty_jacobianWitness`, `genusZeroWitness`,
  `Jacobian.smoothOfRelativeDimension_genus`, etc.); could not verify
  `positiveGenusWitness` exists with the right signature without
  reading Lean — taking the directive at face value that it landed at
  `Jacobian.lean:211`.

## Strategy-modifying findings (if any)

None. The blueprint is consistent with the strategy as understood. No
chapter contains a definition that conflicts with `STRATEGY.md` in a
way requiring a strategy edit; the iter-127 over-k commitment is
correctly threaded through `RigidityKbar.tex`, `Jacobian.tex`, and
`AbelJacobi.tex` (all three repeatedly note "no base-change to $\bar
k$ and no Galois descent of morphism equality enters" and route through
`thm:rigidity_over_kbar`).

## Directive-specific verdicts

### HARD GATE (vacuous this iter — refactor + writer lanes only)

Per the directive's pre-commitment, no `.lean` files for prover work
this iter. Confirming the specific iter-135 dispatch shape:

- **Cotangent/GrpObj.lean refactor lane** (replace 3
  placeholder theorems with intended-type signatures + sorry bodies):
  **GO**. The signature stubs in `RigidityKbar.tex` lemma comments at
  lines 298–305, 400–416, 458–471 explicitly pin the intended Lean
  types. The refactor agent can read these into the Lean file
  verbatim without consulting any other source. (Directive line
  numbers 384–399 / 427–441 were approximate; actual stub locations
  given above.) Proof sketches in the blueprint are detailed enough
  that downstream prover work against the honest-scaffolds will have
  a clear roadmap.

- **Writer dispatches this iter** — assessment of "right shape":
  - `RigidityKbar.tex`: **add `lem:GrpObj_shearMulRight` block**
    (confirmed need; directive item 2 ✓). PLUS the writer should also
    consider whether to update the stale Lean-line citations at lines
    159 and 493 (and the iter-134 NOTE-block citations at lines 326,
    422, 476) in the same pass — these are cleanups but cheap to fold
    in if the writer is already editing the chapter.
  - `Cohomology_MayerVietoris.tex`: **fix 3 broken refs at lines 769,
    917** (confirmed; directive item 3 ✓).
  - `Cohomology_StructureSheafModuleK.tex`: **fix label-prefix
    asymmetry** at lines 358 / 386 / 440 (confirmed; directive item 4
    ✓). Coordinate with the MayerVietoris fix per cross-chapter note
    above.
  - `Jacobian.tex`: **add `\lean{positiveGenusWitness}` block**
    (confirmed need; directive item 6 ✓).
  - `AlgebraicJacobian_Cotangent_GrpObj.tex`: **new finding not in
    directive** — decide whether to wire this orphan file into
    `content.tex` or remove it. If wiring in, this is a one-line edit
    to `content.tex`. If keeping as-is (Lean-mirror-only documentation),
    consider deleting and folding any unique content into
    `RigidityKbar.tex` § "Piece (i)".

## Severity summary

- **must-fix-this-iter** (per the rubric in the descriptor):
  - `Cohomology_MayerVietoris.tex`: three broken `\uses{}` /
    `\ref{...}` cross-references (lines 769 ×2, 917) corrupt the
    dependency graph. Per the descriptor's severity rule, broken
    cross-references are always must-fix.
  - Chapters with `complete: partial` OR `correct: partial` axis
    (per the descriptor's rule that these are always must-fix
    regardless of whether the strategy needs them this iter):
    `AlgebraicJacobian_Cotangent_GrpObj.tex` (complete: partial —
    orphaned from content.tex),
    `Cohomology_MayerVietoris.tex` (complete + correct: partial),
    `Cohomology_StructureSheafModuleK.tex` (correct: partial —
    label-prefix asymmetry),
    `Jacobian.tex` (complete: partial — missing
    `positiveGenusWitness` block),
    `RigidityKbar.tex` (complete + correct: partial — missing
    `shearMulRight` block + iter-134 placeholder discrepancy + stale
    line citations).
- **soon**:
  - Stale Lean-line citations in `RigidityKbar.tex` (lines 159, 493
    + iter-134 NOTE block citations) — informational rot, not graph
    corruption.
- **informational**:
  - The directive's "14 chapters" miscount (actual: 11).
  - The iter-134 NOTE block at `RigidityKbar.tex:336–339` correctly
    raises a meta-question: should the audit rubric exempt
    `\notready`-marked + docstring-intended-type placeholders, or
    should the Lean signature carry the intended type with a `sorry`
    body? The iter-135 plan has pre-committed to refactoring to honest
    sorry bodies, which is the more conservative choice and what the
    blueprint chapter is already set up to support (the signature
    stubs are pinned in the lemma comments).

**Overall verdict.** The blueprint is in good mathematical shape for
the iter-135 refactor + writer dispatches the plan agent has
pre-committed to: the intended Lean types for the three (i.b)
placeholders are pinned in the comments of `RigidityKbar.tex`, the
proof sketches are detailed enough for downstream provers, and the
five identified writer tasks (3 broken refs, 1 label-prefix
asymmetry, 1 missing shearMulRight block, 1 missing
positiveGenusWitness block, plus the bonus orphan-file decision) are
each well-scoped one-edit tasks. The graph-corrupting cross-reference
breaks in `Cohomology_MayerVietoris.tex` are the highest-priority
single item.
