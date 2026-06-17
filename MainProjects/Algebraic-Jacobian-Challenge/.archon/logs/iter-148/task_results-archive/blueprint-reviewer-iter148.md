# Blueprint Review Report

## Slug
iter148

## Iteration
148

## Top-level summaries

### Incomplete parts

None of the chapter bodies are missing a declaration or theorem the
strategy says the project needs. All Lean targets named in `\lean{...}`
hints resolve to existing declarations in the Lean tree with matching
signatures (verified via Grep on the four files named in the directive).
The chapter-level completeness assessment is clean.

Lean-body sorries (informational, not blueprint findings):
`Cotangent/ChartAlgebra.lean` lines 139 (KDM forward inclusion) + 294
(constants substep 3 surjectivity); `Jacobian.lean` lines 197
(`genusZeroWitness`) + 223 (`positiveGenusWitness`);
`RigidityKbar.lean` line 87 (`rigidity_over_kbar`). All five sites
have complete chapter prose; closure is iter-148+ prover lane work,
not blueprint-writer work.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:constants_integral_over_base_field`: the
  chapter body still presents the iter-145 three-substep recipe ((1)
  finite-rank, (2) integral-domain, (3) $\dim_k = 1$ via base change),
  whereas the iter-147 Lean closure documents a 7-step (a)–(g) chain
  pivoting on flat base change of $\Gamma$ for proper schemes
  (Stacks 02KH/0BUG, step (e)) as the load-bearing Mathlib gap. The
  7-step chain currently lives only in the `% NOTE (iter-147 review)`
  comment block (lines 1983–1998). The chapter prose should be
  expanded to surface the 7-step chain and to name step (e) (flat
  base change of $\Gamma$ via `AlgebraicGeometry.IsBaseChange` + a
  cohomology-base-change-for-proper-schemes wrapper) as the
  substantive Mathlib gap. Severity: **proof lacks detail** — the
  body sketch does not match the iter-148+ prover lane's actual
  closure path. (See "Cross-chapter notes" and focus area 2 below.)
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  path (p2) — characteristic-0 bridge: the chapter presents the char-0
  case in the body (line 2061) as "the kernel of $D$ is exactly
  $\operatorname{range}(\mathtt{algebraMap}\,k\,B)$" via
  `Differential.ContainConstants`. The iter-147 prover's identification
  of (p2) as a viable alternative first-attempt path is not visible in
  the chapter prose: both (p1) and (p2) are presented as part of the
  same chain (char-0 case = empty Frobenius iteration + `ContainConstants`),
  not as alternative attack routes. An iter-148 prover wanting to try
  (p2) first must currently infer this from the case-split structure
  rather than read it explicitly. Severity: **proof lacks detail** for
  the iter-148 routing; chapter is correct, just not pre-routed.
- `Jacobian.tex` / `thm:nonempty_jacobianWitness`: Route A sub-step C.2.f
  (Galois descent of morphism equality) is DROPPED per iter-127
  over-k commitment, and the chapter clearly marks this. Otherwise
  the proof is detailed.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}`:
  Lean target exists at `Cotangent/ChartAlgebra.lean:84`. The chapter
  signature matches the Lean signature; the iter-146 `inferInstance`
  closure aligns with iter-147 review documentation. **OK.**
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}`:
  Lean target exists at `Cotangent/ChartAlgebra.lean:167` with sorry-free
  body delegating to KDM. Signature `b ∈ (algebraMap k B).range`
  matches the chapter's `f^{\sharp}(b) \in \operatorname{range}
  (\mathtt{algebraMap}\,k\,R)`. **OK.**
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}`:
  Lean target exists at `Cotangent/ChartAlgebra.lean:123`; body is a
  structured `sorry`. **OK** (signature matches; the chapter's prose
  is detailed for the iter-148+ prover lane modulo the two "proof
  lacks detail" items above).
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.constants_integral_over_base_field}`:
  Lean target exists at `Cotangent/ChartAlgebra.lean:220`; body has a
  single structured `sorry` at step (g) of the 7-step closure chain.
  **OK** signature-wise; the chapter's prose is the iter-145 three-
  substep version, which is mathematically equivalent to the iter-147
  7-step Lean closure but does not name the same Mathlib lemmas. See
  "Proofs lacking detail" above.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}`:
  Lean target exists at `Cotangent/ChartAlgebra.lean:325`. The iter-146
  Lean closure carries the lighter `eqOnOpen U` hypothesis rather than
  the chapter's `df = dg` formulation; the iter-147 review's
  `% NOTE` documents the iter-148+ refinement plan to add `df = dg` and
  derive `eqOnOpen` from it via the chart-algebra ($\beta$) chain. The
  chapter signature is the iter-148+ target shape, not the iter-146
  packaged shape. **OK** as a forward-looking target hint, but a reader
  comparing the chapter signature against the current Lean body will
  see a mismatch; the in-body `% NOTE (iter-146 review)` (lines
  2096–2110) records this drift honestly.
- `Jacobian.tex` / `\lean{AlgebraicGeometry.nonempty_jacobianWitness}`,
  `\lean{AlgebraicGeometry.genusZeroWitness}`,
  `\lean{AlgebraicGeometry.positiveGenusWitness}`: all three exist at
  the named Lean targets with matching signatures. **OK.**
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.rigidity_over_kbar}`:
  Lean target exists at `RigidityKbar.lean:75`. Signature is
  $k$-agnostic (`[Field kbar]`, no `[IsAlgClosed kbar]`) per the
  iter-127 over-k commitment; the variable name `kbar` is a legacy
  iter-126 carry-over. **OK** with the known low-priority rename
  pending.

### Multi-route coverage

- Single route. M2 is committed to the chart-algebra ($\beta$) route
  via `df_zero_factors_through_constant_on_chart` per the iter-144
  pivot; M3 is committed to Route A (Picard scheme via FGA) per the
  iter-144 disposition with Route B preserved as historical
  alternative only. Both committed routes have full blueprint
  coverage (`RigidityKbar.tex` for M2.a, `Jacobian.tex` for M3
  Route A in `thm:nonempty_jacobianWitness` proof). The KDM
  characteristic-$p$ sub-route inside (p1)–(p3) is the only one
  presented; the iter-147 prover's "(p2) char-0 bridge first" framing
  is informational (see "Proofs lacking detail" above), not a
  separate viable route in the multi-route sense.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The chapter ships its three declarations (`def:ofCurve`,
    `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) as
    `\leanok`-marked projections from the Albanese witness. The
    `% iter-127 over-k` framing of the genus-0 sub-case is consistent
    with `Jacobian.tex` and `RigidityKbar.tex` (Galois descent dropped,
    Brauer–Severi obstacle sidestepped via vacuity on the
    $C(k) = \emptyset$ branch).
  - Lean targets `AlgebraicGeometry.Jacobian.ofCurve`,
    `AlgebraicGeometry.Jacobian.comp_ofCurve`,
    `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp` resolve
    cleanly (verified iter-147 via dependency graph). No drift.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pointer chapter to `AlgebraicJacobian/Cotangent/GrpObj.lean`.
    The piece (i.a) trio (`cotangentSpaceAtIdentity`,
    `cotangentSpaceAtIdentity_eq_extendScalars`,
    `cotangentSpaceAtIdentity_finrank_eq`) plus iter-134–iter-136
    orphan helpers (`shearMulRight`, `schemeHomRingCompatibility`,
    `relativeDifferentialsPresheaf_restrict_along_identity_section`)
    inventory matches the Lean file (verified via Grep).
  - Post-iter-145 disposition (excise the bundled piece (i.b) Step 2
    chain into git history) is recorded clearly. Note the chapter
    explicitly cross-references `RigidityKbar.tex` § "Piece (i)" as
    the home of informal content; no orphan content.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Sole consumer of `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
    is `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`,
    which is documented as available infrastructure (`\leanok`-marked).
    Cross-reference correct.
  - "Producer status" paragraph at the end honestly documents
    `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` as
    currently-unproduced carrier classes, conditional theorems only.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: Single-theorem chapter; all referenced Mathlib infrastructure
  (forget composite + sheaf-condition transport) is stable.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: Phase-A steps 2–4 typeclass plumbing; no drift.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: Phase-A step 5 (the $k$-module-flavoured cohomology) plus
  the producer/consumer chain through Stein finiteness of global
  sections. All declarations `\leanok`-marked; iter-148 review found
  no naming drift relative to the Lean tree.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:smooth_locally_free_omega` is the load-bearing forward
    smoothness criterion, consumed by `Cotangent/GrpObj.lean`'s
    `cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_finrank_eq`
    (Step 1+2 of the rank lemma); cross-reference verified.
  - The iter-126 M1 excise of the bridge declaration is recorded
    honestly; the two surviving standalone K\"ahler-localization
    utilities (`kaehler_localization_subsingleton`,
    `kaehler_quotient_localization_iso`) are `\leanok` and have no
    in-tree consumers (intentionally upstream-PR-quality only).

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` cleanly defines $g(C) := \dim_k H^1(C, \mathcal O_C)$
    via the $k$-module-flavoured cohomology of
    `Cohomology_StructureSheafModuleK.tex`. The remaining Mathlib gap
    (Serre finiteness for $H^i(C, \mathcal F)$ on a proper $k$-curve)
    is honestly named.
  - The iter-145 strategy-critic Q3 absorption in
    `RigidityKbar.tex` notes that the chapter prose previously cited
    "Genus.lean's $H^1(C, \mathcal O_C) = 0$ computation as the
    running model"; iter-146 corrected this to point at the abstract
    MV theorem instead. No further drift.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three witness scaffolds (`def:JacobianWitness`,
    `def:genusZeroWitness`, `def:positiveGenusWitness`,
    `thm:nonempty_jacobianWitness`) exist as Lean targets with
    matching signatures (verified via Grep). The Lean bodies are
    `sorry` (M2.b and M3) but the chapter prose is detailed and
    honest about the deferral.
  - Route A vs Route B disposition at iter-144 is documented cleanly.
    Sub-step C.2.f (Galois descent of morphism equality) DROPPED per
    iter-127 over-k commitment.
  - Iter-135 body restructure (`by_cases h : genus C = 0` delegating
    to `genusZeroWitness` and `positiveGenusWitness`) matches the
    `nonempty_jacobianWitness` body at `Jacobian.lean:249-254`.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter for `thm:GrpObj_eq_of_eqOnOpen` (Lean
    `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`). The iter-125
    refactor (drop 8 source-side group-object hypotheses, weaken
    target-side $\mathtt{IsProper}$ to $\mathtt{IsSeparated}$) is
    recorded. The chapter is consumed by `RigidityKbar.tex` and
    `AbelJacobi.tex`.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The five chart-algebra piece (ii) declarations
    (`lem:chart_algebra_isPushout_of_affine_product`,
    `lem:chart_algebra_df_zero_factors_through_constant_on_chart`,
    `lem:constants_integral_over_base_field`,
    `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
    `lem:Scheme_Over_ext_of_diff_zero`) all carry `\lean{…}` hints
    that resolve to existing Lean declarations in
    `Cotangent/ChartAlgebra.lean`. Signatures match (verified via
    Grep). Iter-147 prover lane successfully delivered NET −1
    sorry on `ChartAlgebra.lean` reading from the current chapter
    prose, demonstrating chapter completeness.
  - The iter-147 review's three `% NOTE: (iter-147 review)`
    annotations are well-placed and accurate; they document
    (a) `inferInstance` discipline on the $\alpha$ helper,
    (b) the 7-step closure chain for `constants_integral_over_base_field`
        with step (e) Mathlib gap identification (flat base change of
        $\Gamma$ for proper schemes; Stacks 02KH/0BUG), and
    (c) the iter-148+ refinement plan for `ext_of_diff_zero` to add
        `df = dg` and derive `eqOnOpen` via the $\beta$-core chain.
  - **Soon-severity prose-detail finding 1 (focus area 2):** the
    iter-147 7-step closure chain (a)–(g) for
    `constants_integral_over_base_field` lives only inside the
    `% NOTE (iter-147 review)` comment block of the Lean signature
    stub (lines 1983–1998 of `RigidityKbar.tex`); the chapter's
    `\begin{proof}` body still presents the iter-145 three-substep
    recipe. The two recipes are mathematically equivalent (the
    7-step expansion just names more granular Mathlib lemmas
    around step (e), flat base change of $\Gamma$ for proper
    schemes; Stacks 02KH/0BUG). An iter-148+ prover lane will
    benefit from having the 7-step chain in the chapter body, but
    the chapter is not blocking on this — the iter-147 partial
    closure landed reading the % NOTE.
  - **Soon-severity prose-detail finding 2 (focus area 3):** the
    KDM chapter block currently presents (p1) as the substantive
    proof chain, with (p2) `Differential.ContainConstants` folded
    into the char-0 case of (p1) (line 2061). The iter-147 prover
    identified (p2) as a viable char-0 first-attempt route distinct
    from (p1)'s standard-smooth-chart routing. A writer pass that
    splits the proof into "primary path (p1) standard-smooth-chart
    for char-$p$" and "alternative path (p2) `ContainConstants` for
    char-0" would help an iter-148+ prover route between the two
    paths. Not iter-148-blocking; the existing nested-under-char-0
    presentation is mathematically correct.
  - The `Scheme.Over.ext_of_diff_zero` block at the end of the
    chart-algebra section is the only declaration whose chapter
    signature significantly differs from the current Lean body
    (chapter has `df = dg`, Lean has `eqOnOpen U`); the in-body
    `% NOTE (iter-146 review)` documents this honestly and queues
    the iter-148+ refinement. The mismatch is forward-looking and
    not iter-148-blocking.
  - "Honest pile cost" footer (1350–2600 LOC over 7–14 iters) and
    the per-piece build order paragraph cleanly summarise the
    multi-iter trajectory.

## Cross-chapter notes

- `RigidityKbar.tex` and `Jacobian.tex` both cite
  `thm:rigidity_over_kbar` (in `def:genusZeroWitness` and in
  `thm:nonempty_jacobianWitness` § C.2.g). Both citations are
  consistent with the iter-127 over-k commitment (the signature is
  $k$-agnostic; the Lean variable name `kbar` is a legacy carry-over,
  pending the low-priority rename to `k`). No drift.
- `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class
  decomposition" cites `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  of `Cohomology_MayerVietoris.tex` as the consumer for the Step 3
  chart-Čech kernel-equals-global-sections argument. The cited
  theorem exists with the matching $\mathcal F = \Omega_{C/k}^{\oplus g}$
  instantiation. Cross-reference correct.
- `Differentials.tex` § "Standalone K\"ahler-localization utilities"
  is the natural home for the `kaehler_quotient_localization_iso`
  Mathlib-PR candidate; `RigidityKbar.tex` does not consume it on
  the live path. No double-counting.

## Strategy-modifying findings

None. The strategy reflected in the blueprint is internally
consistent at iter-148 entry: M2 chart-algebra route + M3 Route A
commitment + Route B historical-only disposition are all coherent
with the current Lean tree (5 sorries: 2 in `Cotangent/ChartAlgebra.lean`
KDM + constants; 2 in `Jacobian.lean` two-arm scaffolds; 1 in
`RigidityKbar.lean` `rigidity_over_kbar`).

## Severity summary

- **must-fix-this-iter** — none. The iter-147 blueprint-doctor ran
  clean (no orphan chapters, no broken `\ref`/`\uses`, no new axioms);
  the iter-147 prover lane successfully delivered NET −1 sorry on
  `Cotangent/ChartAlgebra.lean` reading from the current
  `RigidityKbar.tex` chapter prose, demonstrating that the chapter
  is usable as written. No chapter is `complete: partial | false`
  or `correct: partial | false`; no route in the multi-route
  coverage section is MISSING; no strategy-modifying findings.
  HARD GATE CLEARS — the iter-148 plan agent may dispatch provers
  against `Cotangent/ChartAlgebra.lean`,
  `Jacobian.lean`, and `RigidityKbar.lean` per the catalogue rule.
- **soon** — two writer-pass prose-detail improvements on
  `RigidityKbar.tex` that an iter-148 prover lane could benefit
  from, both surfaced by the iter-147 review's `% NOTE` annotations
  but not yet lifted into the chapter body. Recommend optional
  dispatch of the blueprint-writing subagent this iter (or next)
  to land:
  1. Surface the iter-147 7-step closure chain (a)–(g) for
     `lem:constants_integral_over_base_field` in the chapter's
     `\begin{proof}` body. Currently the chain exists only inside
     the `% NOTE (iter-147 review)` comment annotations on the Lean
     signature stub (lines 1983–1998); the proof body still presents
     the iter-145 three-substep recipe (which is mathematically
     equivalent but does not name the Mathlib lemmas the iter-147
     partial closure used). The expanded prose should name step (e)
     (flat base change of $\Gamma$ for proper schemes; Stacks
     02KH/0BUG) as the substantive Mathlib gap concentrated at the
     single residual `sorry` of the iter-147 partial closure.
  2. Split the KDM block (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
     proof to present (p1) and (p2) as alternative iter-148 attack
     routes rather than nesting (p2) `Differential.ContainConstants`
     under (p1)'s char-0 case. The iter-147 prover identified (p2) as
     a natural char-0 first-attempt; the chapter prose should mirror
     this so an iter-148+ prover reading the chapter alone can route
     between the two paths.
  3. (Minor) Add one sentence to KDM step (p1.d) naming the Mathlib
     lemma for the characteristic-$p$ Frobenius-power expansion
     ($\mathrm{Frobenius}$ additivity + multiplicativity, currently
     a free-text appeal).
- **informational** —
  - `RigidityKbar.tex` `\lean{...rigidity_over_kbar}` Lean variable
    name `kbar` is a legacy carry-over from the iter-126 over-$\bar k$
    framing; the iter-127 over-k commitment makes the signature
    $k$-agnostic but does not rename. Low-priority rename to `k`
    scheduled in the chapter introduction.
  - `RigidityKbar.tex` `\lean{...ext_of_diff_zero}` chapter signature
    is the iter-148+ target shape (`df = dg`) rather than the iter-146
    packaged shape (`eqOnOpen U`); the in-body `% NOTE (iter-146 review)`
    documents this honestly. No action needed.
  - `Jacobian.tex` `def:positiveGenusWitness` is M3-Route-A scaffold
    OFF-CRITICAL-PATH per iter-144 disposition. Body remains
    `sorry`; chapter prose is complete and honest.

Overall verdict: 11 chapters audited, all `complete: true, correct:
true`; HARD GATE CLEARS; three soon-severity prose-detail
improvements on `RigidityKbar.tex` surfaced by the iter-147 review
but not yet lifted into chapter body — optional writer dispatch
recommended but not iter-148-blocking.
