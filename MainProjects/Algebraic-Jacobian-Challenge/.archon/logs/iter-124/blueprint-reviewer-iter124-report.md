# Blueprint Review Report

## Slug
iter124

## Iteration
124

## Top-level summaries

### Incomplete parts

None of the chapters in `blueprint/src/content.tex` (the 9 chapters actually
included in the blueprint output) are incomplete in a sense that blocks any
prover lane this iter. The bridge chapter `Differentials.tex` — the iter-124
prover lane target — covers every declaration the iter-124 plan needs.

The 4 chapters NOT included in `content.tex` (`Modules_Monoidal.tex`,
`Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`) are
orphan Phase-C documents that describe Lean files that NO LONGER EXIST in
the source tree (only stale `.lake/build` artifacts remain — see
"Cross-chapter notes" for verification). They are not actively consumed by
any included chapter and not surfaced in the blueprint pdf, so this is a
clean-up matter, not an incompleteness matter for the active arc.

### Proofs lacking detail

- `Jacobian.tex` / `thm:nonempty_jacobianWitness`, Sub-step C.2.d
  (cotangent-vanishing alt): the chapter presents the proof "either via dual
  abelian variety or via cotangent bundle" without mentioning the
  **characteristic-`p` hazard** that the iter-123 strategy-critic flagged
  (df = 0 forces factoring through Frobenius in char p > 0, not constancy).
  STRATEGY.md M2.d (alt) records this honestly; the blueprint chapter does
  not. A prover starting on M2.d alt would not know to handle this.
- `Jacobian.tex` / `thm:nonempty_jacobianWitness`, Sub-step C.1: the genus-0
  identification `C ≅ ℙ¹_k` is described as "Brauer–Severi triviality"
  one-paragraph; for a prover the actual sequence is `genus 0` + rational
  point ⇒ `h⁰(C, O_C(P)) = 2` via Riemann–Roch ⇒ degree-1 map ⇒ iso.
  No `\lean{...}` hint is attached to a candidate identification declaration,
  and the chapter does not name the Mathlib gap concretely. Not blocking
  iter-124 (M2.b/M2.c is iter-126+).
- `Jacobian.tex` / `thm:nonempty_jacobianWitness`, Sub-step C.2.f (Galois
  descent of morphism equality): the prose claims "morphism equality is
  local in the fpqc topology" without naming a Mathlib lemma or candidate
  project declaration. STRATEGY.md flagged this as a phantom prerequisite
  pending iter-124 spot-check — the spot-check has not been performed
  inside the blueprint yet.

### Lean difficulty quality

- `Jacobian.tex` / Sub-step C.2.g names `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`
  with the parenthetical "(final name and namespace to be fixed when the
  declaration is introduced into the Lean tree)" — the chapter explicitly
  defers the formulation. Not a `\lean{...}` hint per se; no prover is yet
  assigned to introduce this declaration. Becomes must-fix at the iter
  where this declaration is first scheduled.
- `Differentials.tex` lemma block for `lem:appLE_isLocalization` (L154–160)
  has a `\lean{...}` hint pointing at a real top-level declaration
  (`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`, verified to exist
  at `Differentials.lean:282`). The signature is clear in the prose.
  Hint quality: good.
- `Differentials.tex` Theorem `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  (L113–125) — `\lean{...}` hint points at
  `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`.
  This is the iter-124 prover lane target (currently sorry-bodied via the
  internal `appLE_isLocalization` sorry at L362). Hint quality: good.

### Multi-route coverage

- **Single route** this iter (directive). M1.b continuation on
  `Differentials.tex § sec:bridge`.
- Multi-route status of the broader project (M2 vs M3, M3-route-A vs
  M3-route-B) is recorded in STRATEGY.md and partially reflected in
  `Jacobian.tex` C.2.d (RR path vs cotangent-vanishing alt) and the proof
  body of `thm:nonempty_jacobianWitness` (Routes A and B). Both M3 routes
  are sketched in Jacobian.tex; per the iter-123 audit and STRATEGY.md M3
  section, both exceed 5000 LOC of Mathlib gap and the user-escalation
  trigger has fired — this is plan-agent's iter-124 deliverable, not a
  blueprint reviewer call. **Blueprint coverage for M3 is adequate at the
  current roadmap level.**

Route coverage matrix:

- Route M1 (bridge): **PASS** — covered by `Differentials.tex § sec:bridge`,
  full sub-step decomposition M1.a–M1.e.
- Route M2 (genus-0 witness): **PASS** — covered by `Jacobian.tex`
  Sub-cases C.1–C.3 with C.2.a–C.2.g sub-step expansion. Detail gaps noted
  above (char-`p` for cotangent alt; C.1 Mathlib leverage; C.2.f Galois
  descent name spot-check) are "soon", not "must-fix".
- Route M3 Route A (Picard scheme via FGA): **PASS** — covered by
  `Jacobian.tex` Route A, A.1–A.4 with Mathlib gap statements.
- Route M3 Route B (symmetric powers + Stein): **PASS** — covered by
  `Jacobian.tex` Route B, B.1–B.3 with Mathlib gap statements.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single instance `instHasSheafCompose_forget_CommRing_AddCommGrp`,
    fully proved (`\leanok`), proof body explains the composition of
    limit-preserving functors. Adequate for downstream uses.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three declarations (`instHasSheafify_Opens_AddCommGrp`,
    `instHasExt_Sheaf_Opens_AddCommGrp`, `Scheme.toAbSheaf`), all
    `\leanok`-marked with proof bodies. Cross-refs to
    `Cohomology_SheafCompose` resolve.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter (655 lines), every block `\leanok`-marked. Multi-stage
    typeclass plumbing for the `k`-module-valued cohomology, plus the
    Stein-finiteness producer for proper integral curves.
  - Phase-A sub-sections internally consistent; cross-refs all resolve.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Largest chapter (947 lines). Every declaration `\leanok`-marked.
  - End-of-chapter (§ "Use in the project", L942–947) honestly discloses
    that the two carrier classes `HasCechToHModuleIso` and
    `HasAffineCechAcyclicCover` are **unproduced** in the project's
    autonomous-loop scope — i.e. the genus-carrier theorem ships as a
    conditional. This honest framing is consistent with STRATEGY.md.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Iter-124 prover lane target chapter. Section `\sec:bridge` is
    complete and gives sub-step M1.a–M1.e decomposition matching
    STRATEGY.md and the iter-122/123 progress.
  - **Intra-chapter prose inconsistency** (carried over from iter-123,
    still present in L138 vs L165): the bridge theorem's proof body
    (L138, M1.b prose) still concludes "via `IsLocalization.of_le`",
    while the dedicated `lem:appLE_isLocalization` proof body (L165)
    correctly uses `IsLocalization.isLocalization_of_algEquiv` (the
    iter-123 analogist-verified pattern). The actual Lean code at
    `Differentials.lean:350` uses `isLocalization_of_algEquiv`, matching
    L165, NOT L138. The L138 prose should be updated to match. SEVERITY:
    soon (the prover reads the Lean code, not L138 prose, so iter-124
    is not blocked; but this is a real correctness bug in the prose).
  - **Stale "of_le" mention** (L138 same paragraph): "Mathlib has no
    off-the-shelf 'colim of localizations is localization at the union
    submonoid' lemma; the analogist-verified pattern is the two-direction
    `IsLocalization.of_le` construction." — incorrect; the
    analogist-verified pattern is the `AlgEquiv`-based one, per L165's
    correction. SEVERITY: soon.
  - **Missing `\lean{...}` hints / dedicated lemma blocks** for three
    top-level Lean declarations carried over from iter-122/123:
    - `appLE_unitSubmonoid` (Differentials.lean:78) — referenced inline
      at L136 in proof prose only; no dedicated `\begin{definition}` block.
    - `isUnit_appLE_unitSubmonoid_in_colim` (Differentials.lean:164) —
      referenced inline at L167 in proof prose only.
    - `appLE_colimRingHom_comp_φV` (Differentials.lean:116) — referenced
      inline at L151 (in M1.e proof prose) only.
    All three are top-level theorems/defs; promoting them to dedicated
    blocks improves traceability. SEVERITY: soon.
  - Wrong-direction `\uses{lem:appLE_isLocalization}` on
    `lem:kaehler_localization_subsingleton` (iter-123 directive item):
    **VERIFIED RESOLVED.** Chapter L190–195 has no `\uses{}` on
    `lem:kaehler_localization_subsingleton`. No action needed.
  - Section `\sec:converse-out-of-scope` (L226–261) gives a clear
    counterexample, references the Mathlib converse lemma with its three
    hypotheses, and cross-references Stacks 02G1. Adequate.
  - Section "Content scheduled for later milestones" (L263–284) is
    a roadmap appendix; M5–M8 sketches are honest about Mathlib gaps.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single protected declaration `def:genus` with `\leanok`, Lean
    implementation explained, Mathlib-gap section honestly disclosed.
  - L42 still says "the sheaf of relative differentials of schemes
    (Phase~B)" — Phase-B framing is stale (current strategy uses M1/M2/M3
    milestones). SEVERITY: informational.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All six protected declarations (`def:JacobianWitness`, `def:Jacobian`,
    `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`,
    `thm:Jacobian_geomIrred`) covered with correct `\lean{...}` hints
    matching `AlgebraicJacobian/Jacobian.lean` declarations.
  - `thm:nonempty_jacobianWitness` proof body presents three routes
    (Route A Picard, Route B symmetric, genus-0 sub-case C). The genus-0
    sub-case C.2.a–C.2.g is the most detailed sub-step expansion (the
    iter-126+ M2.a target); cross-references `thm:GrpObj_eq_of_eqOnOpen`
    correctly.
  - **Char-`p` hazard for C.2.d cotangent-vanishing arg NOT mentioned**
    (see "Proofs lacking detail" above). The chapter presents the cotangent
    proof as "Either proof yields: f is constant" with no caveat — but the
    cotangent proof's `df = 0 ⇒ const` step is only valid in char 0;
    char-p needs Frobenius factorisation iteration or a separate
    no-rational-curves-on-AV argument. This is a real correctness gap
    against the prose claim "Either proof yields..." in the limit. STRATEGY.md
    M2.d (alt) records this honestly; the blueprint should too. SEVERITY:
    soon (M2.d alt is iter-130+, not iter-124).
  - **C.2.g phantom-prereq Lean name speculation**: the candidate name
    `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` is named with
    explicit "final name and namespace to be fixed" — i.e. this is an
    explicit promise, not an authoritative `\lean{...}` hint. Acceptable
    pending the iter where this declaration is first scheduled (M2.a in
    iter-126+).
  - **C.2.f Galois descent**: the prose names no Mathlib lemma or project
    declaration for "morphism equality is local in fpqc topology". The
    iter-124 STRATEGY.md called for an iter-124 spot-check of likely
    Mathlib names — this spot-check is unrelated to the iter-124 prover
    lane and could be done as a "soon" follow-up by a mathlib-analogist
    consult. SEVERITY: soon (M2.c is iter-126+).
  - **Routes A/B Mathlib status sections** (L278–284, L306–311) accurately
    summarise the iter-123 M3 route-pick audit's findings: every
    sub-step is recorded as a Mathlib gap. Good.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations (`def:ofCurve`, `lem:comp_ofCurve`,
    `thm:exists_unique_ofCurve_comp`), all `\lean{...}`-hinted and
    `\leanok`-marked.
  - Proof bodies project from `IsAlbanese` witness via the
    `JacobianWitness` extraction, consistent with `AbelJacobi.lean`.
  - L82 "classical description" paragraph mentions both Route A/B
    classical paths and the genus-0 base-change-and-descent argument,
    matching the consolidated genus-0 handling in `Jacobian.tex` C.2.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single project declaration `thm:GrpObj_eq_of_eqOnOpen`, fully proved
    in `Rigidity.lean:79`, with `\leanok`. Mathlib-ingredients list is
    accurate.
  - **L57 reference to symmetric-power route**: "the rigidity theorem
    applied to δ = g_1 · g_2^{-1} on the image of α_P (a non-empty open
    after passing to the symmetric power C^{(g)} → Jac(C))". This
    references the symmetric-power route that the current strategy uses
    only as Route B (alternative); the actual project usage is via the
    Albanese-witness route. Stale framing. SEVERITY: informational.
  - **L59 Phase B/C reference**: "Note: the existence half of
    \ref{thm:exists_unique_ofCurve_comp} requires Phase B/C
    infrastructure (Picard scheme, dual abelian variety). Rigidity alone
    yields uniqueness only." — Phase B/C framing is stale (current
    strategy uses M1/M2/M3). SEVERITY: informational.
  - **L62 Mathlib gap section**: still says "No rigidity lemma exists in
    current Mathlib" in present tense, but the project's
    `GrpObj.eq_of_eqOnOpen` is closed and is itself a contribution
    candidate; section could be updated. SEVERITY: informational.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true (within the chapter's own scope)
- **correct**: partial (relative to current strategy)
- **notes**:
  - **Orphan chapter** — NOT included in `content.tex`; describes Phase-C
    Lean files (`AlgebraicJacobian/Modules/Monoidal.lean`) that DO NOT
    EXIST in the source tree (only stale `.lake/build/lib/lean/AlgebraicJacobian/Modules/Monoidal.olean`
    artifacts remain — see Cross-chapter notes for the verification).
  - Describes Phase-C scaffolding (`instMonoidalCategory`, `instIsMonoidal_W`,
    `instBraidedCategory`) and a "load-bearing disclosure" framework that
    was superseded by the iter-121 pivot to the M1/M2/M3 roadmap.
  - Cross-refs to `\ref{thm:nonempty_jacobianWitness}` (in Jacobian.tex,
    included) work technically but are conceptually backwards — the
    current `nonempty_jacobianWitness` design does not consume Phase-C
    infrastructure.
  - SEVERITY: informational (chapter is invisible to provers; deletion or
    inclusion-with-rewrite is plan-agent's call).

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true (within own scope)
- **correct**: partial (relative to current strategy)
- **notes**:
  - **Orphan chapter** — NOT in `content.tex`; describes Phase-C Lean files
    (`AlgebraicJacobian/Picard/LineBundle.lean`) that DO NOT EXIST.
  - References `Modules_Monoidal.tex`'s (also orphan) declarations.
  - Includes "named-deferred Mathlib gap" pairs (`thm:SheafOfModules_pullback_tensorObj`,
    `thm:SheafOfModules_pullback_oneIso`) that are orphan-internal and
    not consumed by any included chapter.
  - SEVERITY: informational.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true (within own scope)
- **correct**: partial (relative to current strategy)
- **notes**:
  - **Orphan chapter** — NOT in `content.tex`; references Phase-C Lean files
    that don't exist.
  - `thm:Pic_representable` is recorded as deferred FGA-level work; the
    chapter's framing has been superseded by the M3 Route A/B route-pick
    decision in STRATEGY.md.
  - SEVERITY: informational.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true (within own scope)
- **correct**: partial (relative to current strategy)
- **notes**:
  - **Orphan chapter** — NOT in `content.tex`; references Phase-C Lean files
    that don't exist.
  - Naturally depends on `Picard_Functor.tex` (also orphan) and
    `Picard_LineBundle.tex` (also orphan).
  - SEVERITY: informational.

## Cross-chapter notes

- **Orphan-chapter verification.** The 4 chapters `Modules_Monoidal.tex`,
  `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`
  are file-system-present under `blueprint/src/chapters/` but are NOT
  included by `blueprint/src/content.tex` (verified by direct read of
  `content.tex` — only the 9 chapters listed there enter the blueprint
  pdf). The Lean files they reference
  (`AlgebraicJacobian/Modules/Monoidal.lean`,
  `AlgebraicJacobian/Picard/{LineBundle,Functor,FunctorAb}.lean`) do
  NOT EXIST in the current source tree (verified by
  `ls AlgebraicJacobian/` — only `AbelJacobi.lean`, `Cohomology/`,
  `Differentials.lean`, `Genus.lean`, `Jacobian.lean`, `Rigidity.lean`
  are present); only stale `.lake/build/lib/lean/AlgebraicJacobian/{Picard,Modules}/...olean`
  artifacts remain on disk (build leftovers, not source). These four
  chapters and any stale Lean-build dirs are clean-up candidates. SEVERITY:
  informational (does not block any prover).

- **Phase-B/Phase-C language across `Rigidity.tex`, `Genus.tex`, and the
  4 orphan chapters.** The pre-iter-121 strategy framed work in Phases
  B/C; the iter-121 pivot reframed everything as M1/M2/M3 milestones.
  The active-arc chapters (Differentials, Genus, Jacobian, AbelJacobi,
  Rigidity) mostly use the new framing, but `Genus.tex` L42 and
  `Rigidity.tex` L57+L59 still have lingering Phase-B/C mentions. Minor
  wording updates. SEVERITY: informational.

- **`AbelianVariety.constant_of_P1_map` candidate name** in
  `Jacobian.tex` C.2.g is named tentatively. When the M2.a prover lane
  is first scheduled (iter-126+), the actual Mathlib namespace and final
  spelling should be locked in via a mathlib-analogist consult and the
  chapter updated. Not a current-iter issue.

- **Coherence between `Differentials.tex` L138 prose and `lem:appLE_isLocalization`
  L165 prose.** The two paragraphs describe the M1.b closure with
  different concluding lemmas (L138: `IsLocalization.of_le`;
  L165: `IsLocalization.isLocalization_of_algEquiv`). The Lean code uses
  the latter, so L165 is correct and L138 is the stale one. This is a
  real intra-chapter inconsistency. SEVERITY: soon.

## Strategy-modifying findings

None this iter. All findings are local doc-drift or stale-framing items
that fit within the existing M1/M2/M3 roadmap.

## Severity summary

- **must-fix-this-iter**: None.
  - The iter-124 prover lane target chapter (`Differentials.tex
    § sec:bridge`) is `complete: true`, `correct: partial`-with-only-soon-items
    (the L138 vs L165 prose inconsistency does not block the prover, who
    reads the Lean code). HARD GATE for `Differentials.lean` is **CLEARED**.
  - No `Strategy-modifying findings`.
  - No `MISSING` route under "Multi-route coverage" — M2 and M3 routes are
    blueprint-covered to the roadmap level; the iter-124-relevant route
    (M1.b) is well-covered.
  - No broken `\uses{}` cross-references that point at non-existent labels
    (the iter-123 wrong-direction `\uses{lem:appLE_isLocalization}` on
    `lem:kaehler_localization_subsingleton` has been verified RESOLVED).

- **soon** (cross-cutting items worth a blueprint-writer pass when
  bandwidth allows, in priority order):
  1. `Differentials.tex` L138 prose update: "via `IsLocalization.of_le`" →
     "via `IsLocalization.isLocalization_of_algEquiv`", matching L165 and
     the Lean code at `Differentials.lean:350`. Single-line fix.
  2. `Differentials.tex` L138 sentence "the analogist-verified pattern is
     the two-direction `IsLocalization.of_le` construction" — same
     correction as above, in the same paragraph.
  3. `Differentials.tex`: promote `appLE_unitSubmonoid` (L136 inline),
     `isUnit_appLE_unitSubmonoid_in_colim` (L167 inline), and
     `appLE_colimRingHom_comp_φV` (L151 inline) to dedicated
     `\begin{lemma}/\begin{definition}` blocks with `\lean{...}` hints
     (iter-123 carryover). Each is a real top-level Lean declaration;
     traceability improves with the blocks.
  4. `Jacobian.tex` C.2.d (cotangent-vanishing alt): add a paragraph
     acknowledging the characteristic-`p` hazard (per STRATEGY.md M2.d
     alt note). Single paragraph addition; defended by the M2.d
     decision logic in STRATEGY.md.
  5. `Jacobian.tex` C.2.f (Galois descent): name the Mathlib gap concretely
     once the iter-124 phantom-prereq spot-check (planned in STRATEGY.md
     M2.c) lands. Bumps gap from "unnamed" to "named-deferred".

- **informational** (low-impact, no specific iter target):
  - Delete (or `\input` with rewrite) the 4 orphan chapters
    `Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`,
    `Picard_LineBundle.tex`. Also delete stale
    `.lake/build/lib/lean/AlgebraicJacobian/{Picard,Modules}/...`
    build artifacts.
  - Update Phase-B/Phase-C wording in `Genus.tex` L42 and
    `Rigidity.tex` L57+L59 to M1/M2/M3 framing.
  - `Rigidity.tex` L62 Mathlib-gap section could be rephrased to past
    tense / contribution-candidate framing now that the rigidity lemma
    is closed.

Overall verdict: All 13 chapters audited, 0 must-fix-this-iter findings,
5 "soon" findings, ~3 informational findings; the iter-124 prover lane
on `Differentials.lean` (target `appLE_isLocalization` Step 2+3) is
**CLEARED through the HARD GATE** — the chapter is complete and correct
in every load-bearing way, with only minor stale prose carry-over.
