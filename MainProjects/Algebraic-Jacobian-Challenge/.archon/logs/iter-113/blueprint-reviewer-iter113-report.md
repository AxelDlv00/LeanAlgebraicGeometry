# Blueprint Review Report

## Slug
iter113

## Iteration
113

## Top-level summaries

### Incomplete parts

- (none) Every chapter under `blueprint/src/chapters/` carries the
  definitions, lemmas, and theorems that the strategy snapshot
  requires. The 9 protected signatures (`AlgebraicGeometry.genus`,
  the 5 `Jacobian.*`, the 3 `AbelJacobi.*`) all have a `\lean{...}`
  hint and live in well-formulated declaration blocks under
  `Genus.tex`, `Jacobian.tex`, and `AbelJacobi.tex`. The 7
  named-deferred Mathlib-gap targets + 1 budget-deferral are present
  with adequate prose and pointers. No statement, definition, or
  proof skeleton is missing.

### Proofs lacking detail

- (none material this iter) The iter-113 active prover route is helper
  #1 of `relativeDifferentialsPresheaf_isSheaf` (`Differentials.tex` /
  `thm:relative_kaehler_isSheaf`). The proof block at L28–54 covers
  the two sub-lemmas the prover must close:
  - **Sub-lemma A** (affine identification, basis side): Step 2 prose
    (L41–47) names `KaehlerDifferential.isLocalizedModule_map`
    [verified], `IsAffineOpen.isLocalization_basicOpen` [verified],
    `tilde` [verified], `tensorKaehlerEquivOfFormallyEtale`
    [verified], `FormallyEtale.of_isLocalization` [verified]. The
    pointwise identification `D(f) ↦ Ω_{B[1/f]/A} ≅ tilde Ω_{B/A}`
    is laid out completely.
  - **Sub-lemma B** (refinement-cofinality, basis-to-opens): Step 3
    prose (L49–51) names `isSheaf_iff_isSheafOpensLeCover`
    [verified], `isBasis_affineOpens` [verified],
    `isSheaf_iff_isSheafPairwiseIntersections` [verified],
    `isSheaf_iff_isSheafEqualizerProducts` [verified]; honestly
    discloses that no single Mathlib lemma packages the descent,
    offers Routes (a) and (b), and pins the Lean stub to Route (a).
- This is the same content the iter-112 prover round consumed when it
  closed the main theorem body and the bridge helper #2; the
  remaining helper #1 sorry is mechanizable from the prose without
  guessing.

### Lean difficulty quality

- (carry-over, recorded by iter-112 review with `% NOTE:` annotations
  — refactor lane staged for iter-113):
  - `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega}`
    (`Differentials.lean:816`): blueprint pins
    `IsSmoothOfRelativeDimension n f`; Lean uses dimension-free
    `Smooth f` + free standalone `n : ℕ`, making the biconditional
    unsatisfiable for free `n`. NOTE at L183–188 of the chapter
    flags this. Refactor lane, not prover lane.
  - `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.cotangent_at_section}`
    (`Differentials.lean:832`): identical mismatch. NOTE at
    L209–212.
  - `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.serre_duality_genus}`
    (`Differentials.lean:976`): Lean equation is
    `H^0(O_C) = H^0(Ω_{C/k})` (i.e. dim H^0 = dim H^0), which is
    mathematically false for genus > 1; blueprint asserts
    `H^0(Ω_{C/k}) = H^1(O_C)`. Lean also asks only
    `IsIntegral C.left`, whereas the blueprint asks geometrically
    irreducible plus dimension-1. NOTE at L233–240. Refactor lane.
- All three NOTE blocks are well-placed (immediately above the
  affected `\begin{theorem|corollary}\leanok` block) and prose
  correctly states the intended target.

### Multi-route coverage

- **single route per phase** (per directive). Iter-113 active route =
  closure of helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type`
  on `Differentials.lean` plus the 3-signature-mismatch refactor on
  the same file.
  - Helper #1 closure: **PASS** — `Differentials.tex` Step 2 +
    Step 3 explicitly enumerates the verified Mathlib names for
    Sub-lemmas A and B and pins Route (a) as the Lean route. Two
    routes (a)/(b) are described; Route (a) is the chosen Lean
    route and has adequate detail.
  - Signature-mismatch refactor: **PASS** — the three `% NOTE:`
    annotations identify the exact signature changes required (use
    `IsSmoothOfRelativeDimension n f`; bump the second cohomological
    index 0 → 1; pair with the correct sheaf; require geometric
    irreducibility on `serre_duality_genus`). Refactor target is
    fully specified.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three protected `AbelJacobi.*` targets (`ofCurve`,
    `comp_ofCurve`, `exists_unique_ofCurve_comp`) have `\lean{...}`
    hints, `\uses{...}` graph wiring to the Albanese framework, and
    proof sketches that route through `thm:nonempty_jacobianWitness`
    (the load-bearing Mathlib gap). Implementation-route section at
    L61–65 explains the Pic-scheme-free routing.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-112 must-fix on L1198 (stale gap-list count: 6 → 7,
    adding `serre_duality_genus`) **is in place**. Current count is
    7 named entries + 1 budget-deferral. The temporal qualifier was
    updated to "As of iter-112".
  - **Soon (line-number rot, non-load-bearing)**: within the L1198
    enumeration, two Lean line numbers are stale by ~100 lines
    after the iter-112 prover restructuring of `Differentials.lean`
    (insertion of helpers #1 + #2 at L159 / L188 shifted downstream
    declarations):
    - `Differentials.lean:636` for `cotangentExactSeq_structure.h_exact` —
      actual `case h_exact =>` clause is at L737 (declaration at
      L622).
    - `Differentials.lean:877` for `serre_duality_genus` — actual
      sorry at L982 (declaration at L976).
    The names are correct; only the line numbers are stale. No
    dependency-graph impact.
  - **Soon (broken `\ref{}`)**: L917 of this chapter writes
    `\ref{def:Scheme_IsAffineHModuleVanishing}`, but the actual
    label in `Cohomology_StructureSheafModuleK.tex:358` is
    `thm:Scheme_IsAffineHModuleVanishing` (the `thm:` prefix is
    used for the predicate-as-definition; see also
    `thm:Scheme_IsAffineHModuleHomFinite` and
    `thm:Scheme_IsHModuleHomFinite`). The rendered PDF will show
    "??" in place of the cross-reference. **Not** a `\uses{}`
    breakage — the dependency graph is intact.
  - Chapter content for the iter-113 active route is not consumed
    by it (BasicOpenCech.lean is PAUSED).

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem (`thm:HasSheafCompose_forget`) plus
    implementation remark. Prose is correctly framed against the
    `CommRing → Ring → AddCommGrp` forget composite.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three foundational Phase A blocks (sheafification, Ext,
    `toAbSheaf`). All `\lean{...}` hints point at registered
    instances/definitions and `\uses{...}` wiring matches the
    Phase A chain to `Cohomology_StructureSheafModuleK.tex`.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Comprehensive Phase A step 5 chapter. All blocks carry
    `\leanok` and well-formed `\lean{...}` hints.
  - **Informational (style)**: three carrier-predicate
    declarations use the `thm:` prefix despite being
    definitions: `thm:Scheme_IsAffineHModuleVanishing` (L358),
    `thm:Scheme_IsAffineHModuleHomFinite` (L386),
    `thm:Scheme_IsHModuleHomFinite` (L440). Labels are arbitrary
    strings so this is purely cosmetic; the broken `\ref{}` in
    `Cohomology_MayerVietoris.tex:917` happens because that
    reference assumed a `def:` prefix.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:relative_kaehler_isSheaf` proof block (L28–54) carries the
    iter-111 rewrite with all-[verified] Mathlib names + 1 honest
    [gap] for the basis-to-opens descent. **Adequate for the
    iter-113 helper #1 closure**: Step 2 covers Sub-lemma A
    (`isLocalizedModule_map` + `isLocalization_basicOpen` + `tilde`),
    Step 3 covers Sub-lemma B (refinement cofinality with
    `isSheaf_iff_isSheafOpensLeCover` + `isBasis_affineOpens`). Two
    routes (a)/(b) described; Route (a) pinned as the Lean route.
  - Three iter-112 `% NOTE:` annotations (L183–188, L209–212,
    L233–240) flag the signature mismatches for the refactor lane;
    all are well-placed immediately above the affected
    `\begin{theorem|corollary}\leanok` blocks and correctly
    describe the intended Lean signature.
  - Cotangent-exact-sequence machinery (L79–179) is intact;
    `cotangentExactSeq_structure` carries the named-deferred
    `h_exact` sorry parallel to `instIsMonoidal_W`.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single protected `\lean{AlgebraicGeometry.genus}` with proof
    closure documented at L27–34 (`Module.finrank`-of-Ext recipe).
    `noncomputable` authorisation captured at L62–65.
    Mathlib-gap section identifies Serre finiteness as the
    remaining work.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Five protected `\lean{...}` hints (`Jacobian`, `instGrpObj`,
    `smoothOfRelativeDimension_genus`, `instIsProper`,
    `instGeometricallyIrreducible`) + Albanese framework
    (`IsAlbanese`, `IsAlbanese.unique`, `nonempty_jacobianWitness`).
    `thm:nonempty_jacobianWitness` proof block (L108–117) honestly
    discloses the Pic-scheme / symmetric-power / rigidity gaps and
    bundles them as a single working hypothesis. Implementation
    route at L119–128 cleanly summarises the two-layer split.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:Modules_MonoidalCategory` proof at L41–53 lays out the
    `LocalizedMonoidal` chain; `rem:W_IsMonoidal_content` (L59–62)
    documents the named-deferred stalk-of-presheaf-tensor gap
    cleanly. `rem:W_IsMonoidal_load_bearing` (L64–72) gives the
    Pre-C1 / Post-C1 transition honestly. Cited line
    `Modules/Monoidal.lean:166` in body prose matches the actual
    decl-line of `instIsMonoidal_W` (sorry is at L173; both lines
    are referenced in the project, no internal inconsistency).

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Body §"Post-C1 dependency note" at L77+ correctly describes the
    closed-by-hand-construction `Pic.pullback` and routes the
    transitive dependence through the two oracle isos +
    `instIsMonoidal_W`.
  - **Soon (stale LaTeX comment)**: the `% NOTE:` block at L10
    writes "transitively consumes the sorry-bodied
    `Pic.pullback` (`AlgebraicJacobian/Picard/LineBundle.lean:93`)".
    `Pic.pullback` is **no longer sorry-bodied** (closed iter-109
    at `Picard/LineBundle.lean:108–127`); the same chapter's L77+
    body correctly says so. The comment text and the body are now
    contradictory at the metadata layer. The comment line `:93`
    is also stale (Pic.pullback decl is at L108; L93 is a
    docstring line). Pure LaTeX comment, not rendered to PDF —
    informational severity.
  - **Soon (stale line number in body prose)**: L88 writes
    `\texttt{lean\_verify} ... rooted at \texttt{Picard/LineBundle.lean:93,\,82}`.
    `:82` is correct (`pullback_tensorObj` decl). `:93` is stale;
    correct sorry lines are L86 (`pullback_tensorObj` sorry) and
    L98 (`pullback_oneIso` sorry); correct decl lines are L82
    and L96. The rendered prose will show a stale line number.
  - Representability sorry at `PicardFunctor.representable` is
    correctly framed as a Phase C3 exit-policy deferral.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Codomain-bump narrative for Post-C1 is consistent with
    `Picard_Functor.tex` §"Post-C1 dependency note" and with
    `Picard_LineBundle.tex` §"Status note". `forgetCompare` and
    `etaleSheafified` are both straightforward.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - C1 refactor narrative (LineBundle = (Skeleton X.Modules)ˣ)
    consistent across §Definition, §Status note, §Pull-back, and
    §Mathlib gap. `pullback_tensorObj` (L123–138) and
    `pullback_oneIso` (L141–156) are honestly framed as the two
    siblings of the missing
    `(SheafOfModules.pullback _).Monoidal` instance; both blocks
    carry `\leanok` (statement well-formed, body sorry).
  - Body refers to `Modules/Monoidal.lean:166` (decl-line of
    `instIsMonoidal_W`) — matches the actual decl-line.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained chapter for `GrpObj.eq_of_eqOnOpen`. Proof
    sketch correctly identifies Mathlib ingredients (separatedness
    from properness, equaliser closedness, irreducibility,
    reducedness from smoothness). Not on the iter-113 active
    route but adequate for any future prover round.

## Cross-chapter notes

- **Stale line-number metadata** appears in three places, all caused
  by the iter-112 prover restructuring of `Differentials.lean`
  (insertion of helpers #1 and #2 at L159 / L188 shifted downstream
  declarations by ~100 lines) and the iter-109 closure of
  `Pic.pullback` shifting line counts in
  `Picard/LineBundle.lean`. None affect the dependency graph; all
  are soft metadata (citations in remark prose / LaTeX comments).
  Listed in one place so a single blueprint-writer pass can sweep
  them:
  - `Cohomology_MayerVietoris.tex:1198`: `Differentials.lean:636`
    → actual L737 (sorry) / L622 (decl).
  - `Cohomology_MayerVietoris.tex:1198`: `Differentials.lean:877`
    → actual L982 (sorry) / L976 (decl).
  - `Picard_Functor.tex:10` (`% NOTE:` comment): says
    `Pic.pullback` is sorry-bodied at `LineBundle.lean:93`. Stale:
    `Pic.pullback` was closed at iter-109, decl now at L108.
  - `Picard_Functor.tex:88` (body prose): cites
    `LineBundle.lean:93,82`. `:82` is correct; `:93` should be
    `:86` (or `:98`) per the actual sorry lines, or `:96` per the
    `pullback_oneIso` decl.

- **One broken `\ref{}` (no `\uses{}` graph impact)**:
  `Cohomology_MayerVietoris.tex:917` writes
  `\ref{def:Scheme_IsAffineHModuleVanishing}`, but the actual
  label is `thm:Scheme_IsAffineHModuleVanishing` (in
  `Cohomology_StructureSheafModuleK.tex:358`). Rendered PDF will
  show "??". Three carrier-predicate labels in
  `Cohomology_StructureSheafModuleK.tex` use the `thm:` prefix
  while their semantic role is a definition — stylistic, but the
  cross-chapter `\ref{}` above assumed `def:` and broke.

- **`\uses{}` dependency graph is intact**: a full sweep of all
  214 labels against all 115 unique `\uses{...}` references
  produced zero broken `\uses{}` edges.

- **All `\lean{...}` hints verified against the Lean source for the
  targets that bear on the iter-113 active route + named-gap
  roster**: `relativeDifferentialsPresheaf_isSheaf` (L220),
  `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159,
  sorry L177), `relativeDifferentialsPresheaf_isSheaf_type` (L188),
  `cotangentExactSeq_structure` (L622, h_exact sorry L737),
  `smooth_iff_locally_free_omega` (L816), `cotangent_at_section`
  (L832), `serre_duality_genus` (L976, sorry L982),
  `instIsMonoidal_W` (L166, sorry L173),
  `SheafOfModules.pullback_tensorObj` (L82, sorry L86),
  `SheafOfModules.pullback_oneIso` (L96, sorry L98),
  `nonempty_jacobianWitness` (L176, sorry L179),
  `PicardFunctor.representable` (L181). All target the correct
  declarations.

## Strategy-modifying findings (if any)

None.

## Severity summary

- **must-fix-this-iter**: none.
  - No chapter is `complete: partial | false`.
  - No chapter is `correct: partial | false` per the criterion the
    iter-112 reviewer applied (content omissions, contradictions
    that affect rendered prose or the dependency graph). The
    iter-112 must-fix on `Cohomology_MayerVietoris.tex:1198` was
    addressed (count 6 → 7, `serre_duality_genus` added).
  - No `\uses{}` edge is broken (the dependency graph is intact;
    the one broken cross-ref is a `\ref{}` for prose, which the
    severity rule does not classify as must-fix).
  - No strategy-modifying finding.
  - No multi-route gap.
  - The three iter-112 signature-mismatch annotations
    (`smooth_iff_locally_free_omega`, `cotangent_at_section`,
    `serre_duality_genus`) are *blueprint-side already done*
    (the `% NOTE:` annotations are in place); the iter-113
    refactor lane is a **Lean-side** refactor (re-signing in
    `Differentials.lean`) and does not require additional
    blueprint-writer work.

- **soon** (cross-cutting items that don't block any specific chapter's
  prover work this iter):
  - Sweep stale Lean line numbers in
    `Cohomology_MayerVietoris.tex:1198`,
    `Picard_Functor.tex:10` (LaTeX comment), and
    `Picard_Functor.tex:88` (body prose). One blueprint-writer
    pass closes all four.
  - Fix the broken `\ref{def:Scheme_IsAffineHModuleVanishing}` in
    `Cohomology_MayerVietoris.tex:917` to
    `\ref{thm:Scheme_IsAffineHModuleVanishing}` (or relabel the
    carrier-predicate in `Cohomology_StructureSheafModuleK.tex`
    with a `def:` prefix and re-thread its three downstream
    `\uses{...}` entries).
  - Reconcile the contradictory metadata in `Picard_Functor.tex`:
    the L10 `% NOTE:` comment says `Pic.pullback` is sorry-bodied,
    but the L77+ body correctly says it was closed iter-109.
    Either retire the L10 comment or update it to match the body.

- **informational**:
  - Stylistic: `Cohomology_StructureSheafModuleK.tex` uses the
    `thm:` prefix for three predicate-style definitions
    (`Scheme_IsAffineHModuleVanishing`,
    `Scheme_IsAffineHModuleHomFinite`,
    `Scheme_IsHModuleHomFinite`). This is the proximate cause of
    the broken `\ref{}` above. Either is acceptable; consistency
    is the only win.
  - The L1198 gap-list in `Cohomology_MayerVietoris.tex`
    inconsistently mixes decl-line (Differentials targets) and
    sorry-line (`Modules/Monoidal.lean:173`) conventions. Pick one
    or annotate which is which.

**Overall verdict**: Iter-113 is **GREEN** for the planned
`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` helper-#1
prover dispatch on `Differentials.lean` and for the 3-signature
refactor lane on the same file — `Differentials.tex` is
`complete: true, correct: true` with adequate Step 2 + Step 3 prose
for the basis-to-opens descent and three well-placed `% NOTE:`
annotations staging the refactor. Cross-cutting metadata rot (line
numbers, one `\ref{}` typo, one stale `% NOTE:` comment in
`Picard_Functor.tex`) is **soon-severity** and can be swept in a
single later blueprint-writer pass without blocking any prover this
iter.
