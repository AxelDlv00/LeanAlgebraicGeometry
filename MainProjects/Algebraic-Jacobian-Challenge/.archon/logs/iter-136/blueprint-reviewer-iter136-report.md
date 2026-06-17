# Blueprint Review Report

## Slug
iter136

## Iteration
136

## Top-level summaries

### Incomplete parts
- `Jacobian.tex` / `def:genusZeroWitness` (L385) and `def:positiveGenusWitness`
  (L420): both carry `\notready` markers with `sorry` bodies, which is
  intentional — closure gated downstream. Their statements/prose are
  adequate; flagged here only so the plan agent sees the witness chain
  remains open.
- `RigidityKbar.tex` Piece (i.b) trio (`lem:GrpObj_omega_basechange_proj` L423,
  `lem:GrpObj_omega_restrict_to_identity_section` L483,
  `lem:GrpObj_mulRight_globalises` L331): all three carry `\notready` with
  honest-scaffold sorry bodies, intentional per iter-135 close and the
  iter-136 target plan. Proof outlines (Steps 1+2+3+Compose) are detailed
  enough for prover dispatch.
- `RigidityKbar.tex` Piece (i.c) (`lem:GrpObj_omega_free` L528,
  `lem:GrpObj_omega_rank_eq_dim` L541): both `\notready` and unfilled. Bodies
  ~3–10 lines each; deferred to iter-137+ per the chapter's piece-build-order
  ordering "(i.a) → (i.b) → (i.c)".

No declaration is missing from the blueprint that the strategy requires
this iter.

### Proofs lacking detail
- (none) — the proof sketches in scope this iter (RigidityKbar.tex Piece
  (i.b)'s three honest scaffolds) are detailed: Step 1 cites
  `lem:GrpObj_shearMulRight` (closed in-tree iter-134); Step 2 cites the
  algebra-side `KaehlerDifferential.tensorKaehlerEquiv` + presheaf-side
  `TopCat.Presheaf.pullback` chain with name+file pin; Step 3 cites
  `PresheafOfModules.pullbackComp` + `pullbackId` on the section identity
  `pr_2 ∘ s = η_G ∘ π_G`. LOC envelopes are recorded per piece (~150–300
  for L468, ~30–80 for L496, ~30–80 LOC step in L560 plus Compose).
- `Jacobian.tex` C.2.d cotangent-bundle route prose (L342–347, second
  bullet of "Two standard proofs are available") is slightly under-specified
  on the smoothness-implies-set-level-constant step ("smoothness of $A$
  over $\bar k$ together with the vanishing of $df$ forces $f$ to be a
  constant morphism on the geometric points"); the proper bridge to
  `Differential.ContainConstants` + `ext_of_diff_zero` is documented at
  `RigidityKbar.tex` § shared-pile piece (ii), not here. Cross-link OK,
  detail is sufficient for navigation. Informational.

### Lean difficulty quality
- (none) — all three iter-136 prover-target `\lean{...}` hints
  (`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`,
  `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`,
  `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`) name declarations
  that exist in-tree at the cited file `AlgebraicJacobian/Cotangent/GrpObj.lean`
  (verified L468, L496, L560 respectively). Each Lean signature matches the
  blueprint's stub comment shape (compatibility morphisms supplied via
  `Scheme.Hom.toRingCatSheafHom`, per the iter-135 mathlib-analogist
  verdict in `analogies/phi-compatibility-morphisms.md`). All three bodies
  are honest `sorry` scaffolds, as documented in the per-lemma
  "NOTE iter-135" blocks.

### Multi-route coverage
- Directive lists single-route focus for iter-136 (the piece-(i.b)
  honest-scaffold targets); strategy-level routes (genus-0 vs positive-genus
  arms; Route A vs Route B for M3) are documented per chapter:
  - **Genus-$0$ arm**: PASS — `Jacobian.tex` § "Genus-$0$ Albanese witness"
    (L385+) plus `RigidityKbar.tex` provide the full route via
    `\cref{thm:rigidity_over_kbar}` + iter-127 over-k commitment.
  - **Positive-genus arm**: PASS — `Jacobian.tex` § "Positive-genus
    Albanese witness" (L420+) with Routes A ($\alpha$ — Picard scheme /
    FGA representability) and B ($\beta$ — symmetric powers / Stein
    factorisation) both written; both gated as "off critical path"
    per STRATEGY.md M3.
  - **Shared cotangent-vanishing pile**: PASS — `RigidityKbar.tex`
    § `\ref{sec:RigidityKbar_shared_pile}` documents pieces (i)(ii)(iii)
    (active) and (iv) Serre duality (DEFERRED named gap, no body in this
    chapter). Each piece has an active sub-lemma decomposition; (i.a) is
    closed iter-128→132, (i.b) is the iter-136 target, (i.c) is iter-137+.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 89 LOC. Three Layer-II Albanese projections (`def:ofCurve`,
    `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) each have
    Lean closure + classical-description remark.
  - Cross-references to `Jacobian.tex` and `RigidityKbar.tex` resolve.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **MUST-FIX**: broken `\ref{chap:rigidity_kbar}` at L6 and
    `\cref{chap:rigidity_kbar}` at L59 — the actual label in
    `RigidityKbar.tex:2` is `chap:RigidityKbar` (CamelCase). LaTeX/
    leanblueprint labels are case-sensitive; the rendered blueprint
    therefore shows broken cross-references in this chapter's prose.
    The chapter is the per-Lean-file pointer for `Cotangent/GrpObj.lean`
    (the iter-136 prover-target file).
  - Iter-135 bullet-list update (adding `schemeHomRingCompatibility` and
    `shearMulRight` companion `@[simps]` lemmas) lands cleanly.
  - The seven `\texttt{...}` Lean declarations enumerated at L13–55 all
    exist in-tree (verified: `cotangentSpaceAtIdentity` L161,
    `cotangentSpaceAtIdentity_eq_extendScalars` L210,
    `cotangentSpaceAtIdentity_finrank_eq` L256, `shearMulRight` L349,
    `schemeHomRingCompatibility` L423,
    `relativeDifferentialsPresheaf_basechange_along_proj_two` L468,
    `relativeDifferentialsPresheaf_restrict_along_identity_section` L496,
    `mulRight_globalises_cotangent` L560 of
    `AlgebraicJacobian/Cotangent/GrpObj.lean`).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 947 LOC. Full MV LES + Čech-acyclicity pipeline including comparison-iso
    typeclass carrier (`HasCechToHModuleIso`) and affine-Čech-acyclic-cover
    carrier (`HasAffineCechAcyclicCover`); both honestly documented as
    "currently unproduced" in § "Use in the project" (L942–947).
  - Iter-135 broken-ref fix at L769 + L917 (per directive) confirmed
    resolved: § "Čech acyclicity and vanishing on affines" (L766+) and
    § "Affine Čech-acyclic cover carrier" (L915+) both render correctly,
    with internal cross-refs to `def:Scheme_IsCechAcyclicCover` and
    `def:Scheme_HasCechToHModuleIso` resolving.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 40 LOC. Single theorem `thm:HasSheafCompose_forget` with proof + use-
    in-project chain; declaration body is a 5-line composition of limit-
    preservation lemmas.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 78 LOC. Three declarations (`thm:HasSheafify_Opens_AddCommGrp`,
    `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`) wiring
    Phase-A steps 2–4. All cross-refs resolve.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655 LOC. Full Phase-A step 5 build-out plus Stein-finiteness producer
    chain (`inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf` L555).
  - **Informational** (iter-135 carry-over per directive § "Known
    carry-over items", option (b) leave-as-is): label-prefix asymmetry at
    L358/386/440 — definition blocks `\begin{definition}` bear `\label{thm:...}`
    instead of `\label{def:...}`. No semantic impact; chapter compiles and
    all references resolve.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 209 LOC. Forward-direction smoothness criterion `thm:smooth_locally_free_omega`
    (L48, `AlgebraicGeometry.Scheme.smooth_locally_free_omega`) is the
    project-side existential consumed by `RigidityKbar.tex` piece (i.a)
    rank closure path.
  - Post-iter-126 M1 excise documented in § "Standalone Kähler-localization
    utilities" (L108+); two retained PR-quality lemmas
    `lem:kaehler_localization_subsingleton` (L115) and
    `lem:kaehler_quotient_localization_iso` (L128) stand alone.
  - Converse direction (M4) deferred with concrete counterexample
    (L156–185); honest framing.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 69 LOC. Single named declaration `def:genus`
    (`AlgebraicGeometry.genus`) with full Lean encoding + Mathlib-gap
    statement § L44–60 (Serre finiteness for $H^i$ on a proper $k$-curve
    is the only remaining gap).
  - Phase-A step-6 (Serre finiteness) remains the deep work but is now
    expressible via the `IsAffineHModuleVanishing` /
    `IsHModuleHomFinite` carriers from
    `Cohomology_StructureSheafModuleK.tex`.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 449 LOC. Layer-I + Layer-II decomposition is fully written; all four
    protected-instance Albanese projections + Albanese witness bundle +
    nonempty-jacobianWitness existence statement (with iter-135 body
    restructure `by_cases h : genus C = 0` delegating to
    `def:genusZeroWitness` / `def:positiveGenusWitness`) all present and
    cross-referenced.
  - **Informational** (iter-135 carry-over per directive § "Known carry-over
    items"): L400 stale citation `AlgebraicJacobian/Jacobian.lean:120–126`
    (actual `134–140` per iter-135 lean-vs-blueprint-checker MED-B). No
    semantic impact; rendered as plain text, not a `\ref{...}`.
  - Iter-127 over-k commitment is consistently applied: C.2.f explicitly
    DROPPED (L352), C.2.g restated to iter-127 over-k inventory (L354);
    no leftover "Galois descent" prerequisites.
  - All `\uses{}` cross-references resolve (verified by global
    label-vs-ref diff).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 71 LOC. Single named declaration `thm:GrpObj_eq_of_eqOnOpen`
    (`AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`) post-iter-125
    refactor; closure via Mathlib's `ext_of_isDominant_of_isSeparated'`.
  - Cross-references to `RigidityKbar.tex` and to `thm:exists_unique_ofCurve_comp`
    resolve.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 590 LOC. Full piece-(i)(ii)(iii)(iv) shared-pile inventory (L60–79)
    plus the iter-129+ sub-lemma decomposition (i.a) → (i.b) → (i.c)
    (L82–558).
  - Iter-135 honest-scaffold NOTE blocks at L372, L452, L505 each
    accurately describe the iter-134 scaffold landing + iter-135 retraction
    of the prior `\leanok` markers, with `sync_leanok` doing the marker
    flip.
  - Three iter-136 prover-target lemmas (the iter-135 honest scaffolds)
    `lem:GrpObj_omega_basechange_proj` (L423, → L468), `lem:GrpObj_omega_restrict_to_identity_section`
    (L483, → L496), `lem:GrpObj_mulRight_globalises` (L331, → L560) all
    have proof sketches with detailed Step 1+2+3+Compose outlines + LOC
    envelopes + Mathlib name summaries. Each is `\notready` with
    well-defined closure targets.
  - The companion lemma `lem:GrpObj_shearMulRight` (L283, → L349, closed
    iter-134) underpins the Step 1 of L331; the `\uses` chain on L302/320
    references `lem:GrpObj_cotangentSpace` (the iter-128 piece-(i.a)
    definition) cleanly.
  - All `\uses{}` cross-references resolve (verified by label-vs-ref diff).
  - Iter-131 `Classical.choose`-chain body shape note at L560 + companion
    rewrite-handle lemma `lem:GrpObj_cotangentSpace_extendScalars_witness`
    at L124–160 are coherent and downstream-usable.

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` is a pointer-only auxiliary
  chapter for the per-Lean-file convention; its math content is delegated
  to `RigidityKbar.tex` § Piece (i). The two broken `\ref{chap:rigidity_kbar}`
  refs in this chapter (L6, L59) reference the latter, so the fix is a
  case-only edit (`rigidity_kbar` → `RigidityKbar`).

## Strategy-modifying findings (if any)

None. The iter-127 over-k commitment, iter-129 sub-lemma decomposition, and
iter-131 Replacement (B) `Classical.choose`-chain body strategy all stand
unchanged. No declaration redefinitions, no `\uses{}` cycles, no
contradictions with STRATEGY.md.

## Severity summary

### must-fix-this-iter
- **`AlgebraicJacobian_Cotangent_GrpObj.tex` L6 + L59**: broken
  `\ref{chap:rigidity_kbar}` / `\cref{chap:rigidity_kbar}` — actual label is
  `chap:RigidityKbar` (CamelCase). Spirit-of-rule application of the
  "broken cross-reference" severity gate: this chapter is the per-Lean-file
  pointer chapter for `Cotangent/GrpObj.lean`, the iter-136 prover-target
  file. A 2-instance case-only correction in a pointer chapter, dispatchable
  to a blueprint-writer pass in <50 LOC.

### soon
- (none material to iter-136 prover dispatch)

### informational
- `Jacobian.tex` L400 stale line citation (`Jacobian.lean:120–126` vs.
  actual `134–140`) — iter-135 MED-B carry-over.
- `Cohomology_StructureSheafModuleK.tex` L358 / L386 / L440 label-prefix
  asymmetry (`\label{thm:...}` on definition blocks) — iter-135
  "option (b) leave-as-is" carry-over.
- `Jacobian.tex` C.2.d cotangent-bundle route second-bullet prose
  (L342–347) is slightly thin on the smoothness-implies-constant step;
  the substantive bridge is documented at `RigidityKbar.tex` piece (ii),
  cross-link OK. Per-iter detail tuning candidate.

Overall verdict: blueprint is correct and prover-ready for the iter-136
piece-(i.b) honest-scaffold dispatch on `RigidityKbar.tex`; a tiny
blueprint-writer pass on `AlgebraicJacobian_Cotangent_GrpObj.tex` (case
fix on two `\cref` instances) is required this iter to clear the per-Lean-file
HARD GATE on `Cotangent/GrpObj.lean`.

## HARD GATE verdict (per prover-target Lean file)

### `AlgebraicJacobian/Cotangent/GrpObj.lean` (iter-136 candidate dispatch)
- Mapped chapters: `RigidityKbar.tex` (math content) + `AlgebraicJacobian_Cotangent_GrpObj.tex`
  (per-Lean-file pointer).
- `RigidityKbar.tex` status: **clear-to-dispatch** (`complete: true`,
  `correct: true`, no must-fix-this-iter finding).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` status: **defer-with-writer-pass**
  (`complete: true`, `correct: partial` due to broken refs; one
  must-fix-this-iter finding).
- **Combined verdict**: per the directive's "Apply this to RigidityKbar.tex
  AND to AlgebraicJacobian_Cotangent_GrpObj.tex" instruction — STRICT
  reading produces **defer-with-writer-pass for `Cotangent/GrpObj.lean`
  prover dispatch this iter**, with the writer pass being a 2-instance
  case fix in the pointer chapter. Plan-agent discretion: the broken refs
  are in pointer prose only (no `\uses` graph corruption, no semantic
  blocker for the prover); if the plan agent judges the fix-and-dispatch
  ordering tractable within iter-136 (writer pass takes minutes), the
  prover dispatch on `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (cheapest target, ~30–80 LOC) remains viable in-iter.

### Other iter-136 candidates (per directive)
- `Jacobian.lean` (2 sorries: `genusZeroWitness` L193, `positiveGenusWitness`
  L223): not iter-136 prover targets per the strategy; deferred pending
  M2-body-pile (piece (i.b)) closure.
- `RigidityKbar.lean` (1 sorry: `rigidity_over_kbar` L75): not iter-136 prover
  target; gated on M2.body-pile pieces (i)–(iii).
