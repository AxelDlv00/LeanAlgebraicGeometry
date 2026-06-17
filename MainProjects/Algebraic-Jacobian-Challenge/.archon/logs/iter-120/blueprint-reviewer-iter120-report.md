# Blueprint Review Report

## Slug
iter120

## Iteration
120

## Scope
Whole-blueprint audit of the 9 active chapters listed in
`blueprint/src/content.tex`. Orphan chapters
(`Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`,
`Picard_LineBundle.tex`) are NOT in scope as content, but cross-
references to them from active chapters were checked and are reported
under cross-cutting findings.

## Top-level summaries

### Incomplete parts (severity: must-fix-this-iter unless flagged)

1. **`Differentials.tex` / `thm:smooth_locally_free_omega` Step 5** —
   prose at L91 still claims "By Lemma~\ref{lem:relative_kaehler_presheaf_obj},
   the section module $M_U = \Omega_{X/S}(U)$ is definitionally equal to
   $\Omega_{B/A}$, so the free-of-rank-$n$ conclusion from Steps 3--4
   transfers verbatim." The L92–104 `% NOTE:` comment correctly
   diagnoses why this is wrong at the Lean level (the source ring of
   the project-side Kähler module is the inverse-image-presheaf
   colimit ring at $V_0$, not $A = \Gamma(S, U_0)$), but the prose
   itself was not rewritten. A prover hitting this chapter will still
   try to discharge Step 5 by `rfl`/unfolding and produce broken
   tactics. **Severity: must-fix-this-iter** — this chapter is the
   sole active target for prover work this iter (per the directive,
   the only `.lean` file with a remaining sorry is
   `Differentials.lean` at L136).

2. **`Differentials.tex` lacks coverage of the new project-local helper
   `relativeDifferentialsPresheaf_iso_kaehler_appLE`.** The iter-119
   prover finding explicitly recommends factoring the Step-5 bridge
   into a helper lemma with this name. There is no `\begin{lemma}`
   block for it, no `\label{lem:relative_kaehler_iso_appLE}`, and no
   proof sketch describing how to construct the $B$-linear iso between
   $\Omega_{B/A}$ and $\Omega_{B/A'}$. Per the user's directive
   ("complete blueprints for all the components"), this helper is a
   latent component that must be blueprinted. The `% NOTE:` text at
   L101–103 names the lemma but is a comment, not a blueprint block.
   **Severity: must-fix-this-iter** — the prover lane on
   `Differentials.lean` cannot proceed without a written proof sketch
   for this bridge. Recommended location: a new `\begin{lemma}` block
   between the current Lemma~`lem:relative_kaehler_presheaf_obj`
   (L19–37) and Theorem~`thm:smooth_locally_free_omega` (L48), with
   `\label{lem:relative_kaehler_iso_appLE}` and
   `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_iso_kaehler_appLE}`.

3. **`Jacobian.tex` proof of `thm:nonempty_jacobianWitness`
   (L247–340) — routes A/B/C are documented but not at the
   user-criterion bar of "complete".** The 3-route documentation
   correctly enumerates the headline obstructions (FGA representability
   for Route A, finite-group-scheme quotients of schemes for Route B,
   rigidity-plus-genus-0-identification for Route C). However:
   - Route A sub-step A.2 ("FGA representability") is named but the
     prerequisite Hilbert/Quot scheme infrastructure is not itself
     blueprinted as a component the project could blueprint-stub. The
     user's directive asks for *all* components for the end state. If
     the end state is to discharge `nonempty_jacobianWitness`, the
     Hilbert-scheme component is a latent block.
   - Route B sub-step B.1 "smooth quotient by $S_g$" — Fogarty/Mumford
     reference given, but no concrete sub-statement-level breakdown.
   - Route C sub-step C.1 (Brauer–Severi triviality for genus-0 with
     rational point) — Riemann–Roch dependence noted, but the project
     has trimmed Riemann–Roch infrastructure, so this sub-step is a
     forward-pointer to absent Mathlib content.

   **Severity: advisory (soon).** Per the project STRATEGY (see
   `% NOTE:` in `Jacobian.lean:17–25`), `nonempty_jacobianWitness` is
   intentionally an open hypothesis, NOT something the autonomous loop
   will close. The three-route documentation is honest and adequate
   *to communicate the gap*; promoting each sub-step into its own
   blueprintable component would be the next quality bar but is not
   blocking any iter-120 prover lane (no prover is being sent at
   `Jacobian.lean:179`).

### Proofs lacking detail

- **`Differentials.tex` / `thm:smooth_locally_free_omega`** Step 5
  (L91): the prose says "transfers verbatim", but the residual Lean
  `sorry` shows it doesn't. The Step-5 transfer needs a written-out
  proof sketch via the new bridge lemma; current text is one sentence
  hand-waving. (Tied to item 1 above.)
- **`Jacobian.tex` / `thm:Jacobian_smooth_genus`** proof body
  (L143–148): the Lean closure is one line ("project the field
  `smoothGenus`"), but the *mathematical* paragraph (L148) jumps from
  "tangent space at identity equals $H^1(C, \mathcal O_C)$" to
  "smoothness follows from constant-rank tangent space via
  homogeneity" without citing deformation theory of Picard or
  identifying which Mathlib (or project-side) lemma would be the
  bridge. Since the field is just projected from a hypothesis, the
  Lean side is fine, but the math paragraph is informal. **Severity:
  informational** — Lean closure is well-formed; no prover lane
  depends on the math paragraph's detail.
- **`Jacobian.tex` / `thm:Jacobian_proper`** proof body (L159–164):
  same pattern — Lean closure is one-line projection; math paragraph
  invokes "FGA representability" or Route B's universal closedness of
  $\sigma$ without sub-step labels. **Severity: informational.**
- **`AbelJacobi.tex` / `thm:exists_unique_ofCurve_comp`** proof body
  (L75–83): Lean closure is the universal-property projection; the
  classical-description paragraph at L82 cross-refers back to
  `thm:nonempty_jacobianWitness` Routes A/B/C — this is correct but
  inherits the looseness of that proof. **Severity: informational.**
- **`Rigidity.tex` / `thm:GrpObj_eq_of_eqOnOpen`** proof sketch
  (L27–53): the proof says "equaliser closed in $X$" + "promote
  point-wise to scheme-theoretic via reduced-induced + faithfulness".
  The promotion step (L37–40) is the one nontrivial step and is
  glossed in one clause. A prover would need to know specifically
  which Mathlib lemma names the "scheme morphisms identified by
  values on points for reduced source and separated target" (cited at
  L48). **Severity: soon** — this chapter has `complete: true`
  (`\leanok` already, see grep below) so the prover work is closed,
  but the sketch is thin if a future iter ever revisits the proof.

### Lean difficulty quality

- **`Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_iso_kaehler_appLE}`**
  is *not declared* as a `\lean{...}` hint in the chapter (only in the
  `% NOTE:` comment). When this lemma is added (per item 2 above), the
  `\lean{...}` hint must specify a clear signature in the proof sketch
  — current `% NOTE:` text gives the formula
  ("$\Omega_{B/A} \cong_B \Omega_{B/A'}$ where $A' = $ the
  inverse-image-presheaf section at $V_0$") but does NOT give the
  exact Lean argument list, so a prover would have to invent the
  binder shape. **Severity: must-fix-this-iter** — same blocker as
  item 2.
- **All other `\lean{...}` hints in active chapters** are
  well-formulated: each names a fully-qualified Mathlib-style path,
  and the prose immediately above gives enough type information for a
  prover to infer the signature. Spot-checks across
  `Cohomology_*` chapters and `Jacobian.tex` confirm this.

### Multi-route coverage

- **Route "via Pic-scheme (FGA)" (Route A of
  `thm:nonempty_jacobianWitness`)**: PARTIAL — covered in
  `Jacobian.tex` L255–284, with 4 sub-steps and a Mathlib-status
  summary per sub-step. Each sub-step is named but not blueprinted
  as a discrete component (no per-sub-step labels). **Adequate for
  documenting the gap; not adequate as a "complete blueprint of all
  components" in the user's strictest sense.**
- **Route "via symmetric powers + Stein factorisation" (Route B)**:
  PARTIAL — covered in `Jacobian.tex` L286–311 with 3 sub-steps and
  Mathlib-status summary. Same caveat as Route A.
- **Route "genus-0 sub-case via Brauer–Severi + rigidity" (Route C)**:
  PARTIAL — covered in `Jacobian.tex` L313–329 with 3 sub-steps. C.2
  (rigidity $\Hom(\mathbb P^1_k, A) = A(k)$) cross-refers to the
  abstract rigidity in `Rigidity.tex` correctly; C.1 (Brauer–Severi
  triviality) points at trimmed Riemann–Roch infrastructure.
- **Route "forward direction of Jacobian criterion via standard-smooth
  algebras" (active prover route this iter)**: PARTIAL — covered in
  `Differentials.tex` Section 2 (L44–114) but blocked by the Step-5
  bridge gap (items 1–2 above). This is the only multi-route entry
  where the gap is gating-relevant THIS iter.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `thm:HasSheafCompose_forget` with `\leanok` and a
    5-line proof sketch. Auxiliary chapter, no protected
    declarations. Adequate for prover work; no `.lean` sorries
    remain.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 3 declaration blocks: sheafification on opens, $\Ext$ on opens,
    structure sheaf as ab-sheaf. All `\leanok`. Proof sketches
    appropriately one-paragraph; chapter is plumbing.
  - `\uses{...}` chain to `Cohomology_SheafCompose` is correct.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Largest auxiliary chapter (~656 lines). 30+ declarations
    covering: sheafification & $\Ext$ for $k$-modules, presheaf and
    sheaf of $k$-modules from $\mathcal O_C$, $H^0$ bridges, Čech
    scaffolding, finite-dimensionality consumer/producer chain.
  - All `\leanok`. Detailed proof sketches with Mathlib lemma
    names. Carrier-predicate structure (`IsAffineHModuleVanishing`,
    `IsAffineHModuleHomFinite`, `IsHModuleHomFinite`,
    `IsCechAcyclicCover`, `HasCechToHModuleIso`,
    `HasAffineCechAcyclicCover`) is well-articulated and the
    consumer/producer separation is clear.
  - **One minor inconsistency**: `def:Scheme_HModule` (L185–195) is
    typed as `\begin{definition}` but labelled with the role of a
    typeclass-producing abbrev. The `\leanok` on the body is
    correct; just a documentation nit.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Mayer–Vietoris LES, $\Ext$ comparison, two-affine cover
    specialisation, Čech-acyclicity-to-vanishing transport,
    comparison-iso & cover carriers. ~948 lines. All declarations
    `\leanok`.
  - `\lean{...}` hints all match the project's Lean naming
    (verified by grepping `AlgebraicGeometry.Scheme.HModule'_*` in
    `MayerVietorisCore.lean` / `MayerVietorisCover.lean`).
  - The note in §"Producer status" at L947 correctly documents that
    `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` carriers
    have no producer instance — this is the project-acknowledged
    second open hypothesis (parallel to `nonempty_jacobianWitness`).
    The shipped genus theorem is conditional on the two carriers.
  - One label without `\lean{...}` (L444 `lem:Scheme_AffineCoverMVSquare_corners`)
    is the informal collective statement; the four detail-lemmas
    L450–508 carry the `\lean{...}` hints and `\leanok`. This is
    fine.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - 2 declaration blocks (definition + section-eval lemma) + 1
    forward-direction theorem + 4 remarks. The forward theorem is
    where the problem lives.
  - **must-fix**: L91 prose claims the section module is
    definitionally $\Omega_{B/A}$; the `% NOTE:` at L92–104 confirms
    this is *not* `rfl` at the Lean level (the source ring is the
    inverse-image-presheaf colimit, not $\Gamma(S, U_0)$). The prose
    has not been rewritten; the Lean residual `sorry` at
    `Differentials.lean:136` is *expected* given the gap.
  - **must-fix**: the project-local helper
    `relativeDifferentialsPresheaf_iso_kaehler_appLE` flagged by the
    iter-119 prover is not blueprinted as its own declaration block.
    Per user directive, all components need a blueprint. The
    `% NOTE:` mentions the lemma in a comment, but a comment is not
    a blueprint block (no label, no `\lean{...}` hint, no proof
    sketch outline naming the cofinality/colimit-cone construction
    or the relevant Mathlib infrastructure).
  - The converse-direction section (§3, L121–154) is excellent —
    explicit counterexample, Mathlib-name pointer to the converse
    lemma, hypotheses listed, scope decision documented. No issue.
  - Section 4 ("Content out of autonomous-loop scope", L156–177)
    correctly catalogues 4 trimmed items with Mathlib-gap reasons.
    No issue.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single definition `def:genus` with `\leanok`. The body is
    `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`
    routed through the Module-$k$ cohomology of
    `Cohomology_StructureSheafModuleK`. Cross-refs resolve.
  - The `\uses{def:Scheme_HModule, def:Scheme_toModuleKSheaf}` chain
    is correct.
  - §"Equivalent reformulations" (L36–42) lists 3 out-of-scope
    reformulations with Mathlib gaps cited. Fine.
  - §"User authorisation of noncomputable" (L62–65) is informational
    and correct.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 14 declaration blocks: `IsAlbanese`, `IsAlbanese.ofCurve`,
    pointed lemma, universal-factorisation lemma, uniqueness
    theorem, `Jacobian`, four protected instances on `Jacobian`,
    `JacobianWitness`, `nonempty_jacobianWitness`. All `\leanok`.
  - **Foundational hypothesis disclosure** at the end of the proof
    of `thm:nonempty_jacobianWitness` (L339) is correct: "Mathlib
    currently contains none of the three infrastructure builds, and
    so the existence statement is recorded here as the project's
    single explicit foundational hypothesis."
  - The 3-route documentation (Routes A/B/C, L255–339) is the
    advisory item from Top-level §"Incomplete parts" item 3. It
    documents *that* the routes are blocked and *which* Mathlib
    pieces would unblock each, but does not blueprint the sub-steps
    as components themselves.
  - **`partial` rationale**: the chapter is internally consistent
    and prover-actionable (5 sorries point at the single
    `nonempty_jacobianWitness` hypothesis); but per the user
    directive ("all components for the end state"), the
    sub-components inside each route are latent components that are
    *named* but not *blueprinted*. Soft `partial`, not blocking
    this iter.
  - Quantifier-reversal remark (L219–231) is excellent. The
    `JacobianWitness` smoothness-redundancy remark (L233–237)
    explicitly justifies the Lean-level redundancy of `smooth` +
    `smoothGenus` fields.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `thm:GrpObj_eq_of_eqOnOpen` with `\leanok`.
    Self-contained chapter; not in any prover queue this iter.
  - Proof sketch (L27–53) has the structure pointed out in §"Proofs
    lacking detail" — the reduced-induced-subscheme promotion step
    is light, but the chapter has 0 sorries in `Rigidity.lean`, so
    this is informational only.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 4 declaration blocks (Abel–Jacobi map + pointed property +
    Albanese property of $\Jac(C)$) and 2 classical-description
    remarks. All `\leanok`; 0 sorries in `AbelJacobi.lean`.
  - Inherits the looseness of `Jacobian.tex` Routes A/B/C through
    the classical-description paragraphs (L82) — this is informational
    and consistent with the way the chapter cleanly separates Lean
    closure (Albanese projection) from classical content (line
    bundles / Pic / rigidity).

## Cross-chapter notes

- **CRITICAL — broken `\ref` from active chapter to orphan chapter**:
  `Jacobian.tex:6` reads
  "Because the Picard-scheme machinery (Chapter~\ref{chap:Picard_Functor})
  is blocked..."
  but `chap:Picard_Functor` is defined only in the orphan
  `Picard_Functor.tex` (NOT in `content.tex`). The compiled blueprint
  will render this as `Chapter ??`. **Severity: must-fix-this-iter**
  (broken cross-reference). Recommended fix: replace the
  `\ref{chap:Picard_Functor}` with descriptive prose (e.g. "the
  Pic-scheme machinery — FGA representability and its prerequisites,
  out of autonomous-loop scope (see Theorem~\ref{thm:nonempty_jacobianWitness}
  Route A for the detailed Mathlib gap analysis)").

- **Mismatched chapter-to-Lean-file slug, but content stays
  consistent**: `Cohomology_MayerVietoris.tex` is one blueprint
  chapter, but the Lean side has split it into
  `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` and
  `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`. The
  `\lean{...}` hints in the chapter all resolve correctly to one of
  the two files (verified by grepping for the declaration names). No
  fix needed — Archon's slug map handles this — but worth noting if
  Future-Archon adds a `Bar.lean ↔ Bar.tex` invariant check.

- **Orphan chapters self-reference but don't leak into active
  chapters** (except the single `Jacobian.tex:6` case above). The
  4 orphan chapters reference each other (`Picard_FunctorAb.tex`
  references `chap:Picard_Functor`, etc.) — these are internal to
  the orphan island and do not show up in the compiled PDF. No fix
  needed.

- **Stale `% NOTE:` in `Differentials.tex` L92–104** is intentional
  and correct as an annotation, but its presence with un-rewritten
  prose makes the chapter mid-transition. The note should either
  drive a prose rewrite this iter (preferred) or be marked clearly
  as "blueprint-writer TODO" so it doesn't get mistaken for a stable
  annotation.

## Strategy-modifying findings

None this iter. The strategy (single explicit foundational hypothesis
`nonempty_jacobianWitness`, plus the two cohomology carriers
`HasCechToHModuleIso` + `HasAffineCechAcyclicCover`) is consistent
with the blueprint's framing. The Differentials Step-5 bridge gap is
a *chapter-rewrite* concern, not a strategy concern: the strategy
already targets `smooth_locally_free_omega` as the project's forward
direction of the Jacobian criterion, and a project-local helper
lemma to bridge the type mismatch is a normal blueprint refinement,
not a strategy pivot.

## Severity summary

- **must-fix-this-iter** (these block the Differentials prover lane
  from running with confidence):
  - `Differentials.tex` Step-5 prose still claims "definitionally
    equal" — needs rewrite to acknowledge the inverse-image-presheaf
    source ring and route through a bridge lemma.
  - `Differentials.tex` is missing a blueprint block for the new
    project-local helper
    `relativeDifferentialsPresheaf_iso_kaehler_appLE` (label,
    `\lean{...}` hint, proof sketch outlining cofinality of $U_0$ in
    the colimit cone of $f V_0$-neighbourhoods + the resulting
    $B$-linear iso between $\Omega_{B/A}$ and $\Omega_{B/A'}$).
  - `Jacobian.tex:6` broken `\ref{chap:Picard_Functor}` (orphan
    target).
- **soon**:
  - `Rigidity.tex` proof sketch reduced-induced promotion step is
    glossed.
  - `Jacobian.tex` Routes A/B/C sub-steps are named but not
    individually blueprinted as components — user-directive concern
    that does not block any iter-120 prover lane.
  - `Jacobian.tex` proof bodies for `Jacobian_smooth_genus`,
    `Jacobian_proper`, `Jacobian_geomIrred` are one-line
    projections + thin mathematical paragraphs; fine for Lean
    closure, loose for the math reader.
- **informational**:
  - `def:Scheme_HModule` (L185) typed as definition but documents an
    abbrev — naming nit.
  - `Cohomology_MayerVietoris.tex` chapter file ↔ Lean file
    split (`MayerVietorisCore.lean` + `MayerVietorisCover.lean`) — no
    fix needed.

## Hard-gate guidance for iter-120 plan agent

The plan agent is considering one prover lane this iter:

- **`Differentials.lean`** (for re-attempting `smooth_locally_free_omega`
  Step 5, possibly with the project-local helper
  `relativeDifferentialsPresheaf_iso_kaehler_appLE` as a stepping
  stone). The corresponding chapter is `Differentials.tex`, which
  the per-chapter checklist marks `complete: partial` and `correct:
  partial` (Step-5 prose lies about definitional equality; bridge
  lemma is unblueprinted). Two **must-fix-this-iter** items name this
  chapter.

  **GATE VERDICT: DEFER.** Per the dispatcher-notes hard-gate rule
  (`blueprint-reviewer.md` L24–45), drop `Differentials.lean` from
  this iter's `## Current Objectives`. Dispatch a `blueprint-writer`
  this iter against `Differentials.tex` with the directive:

  1. Rewrite Step 5 of `thm:smooth_locally_free_omega` prose (L91)
     to acknowledge the inverse-image-presheaf source ring mismatch
     and route the transfer through a new bridge lemma.
  2. Insert a new blueprint block (between L37 and L48) for
     `relativeDifferentialsPresheaf_iso_kaehler_appLE` with:
     `\label{lem:relative_kaehler_iso_appLE}`,
     `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_iso_kaehler_appLE}`,
     statement (the $B$-linear iso between the two Kähler modules
     conditional on `IsAffineOpen U_0 ∧ IsAffineOpen V_0`), and a
     proof sketch naming `KaehlerDifferential.map`,
     `KaehlerDifferential.map_surjective`, and the cofinality input
     for injectivity.
  3. Update the `% NOTE:` block at L92–104 to point at the new
     blueprint block (or remove it once the prose is rewritten).

  Once the blueprint-writer lands, the iter-121 mandatory dispatch
  of me will green-light a `Differentials.lean` prover lane.

- **No other prover lane planned**: the other 8 active chapters have
  0 sorries in their corresponding Lean files. Re-running
  `blueprint-writer` on `Jacobian.tex` to flesh out the Routes A/B/C
  sub-step components is **soon**, not must-fix-this-iter — none of
  the 8 zero-sorry files would benefit from a Jacobian.tex prose
  refinement this iter.

  However: the **`Jacobian.tex:6` broken `\ref{chap:Picard_Functor}`**
  is a `must-fix-this-iter` finding that does not block a prover lane
  but corrupts the compiled blueprint. The fix is a one-line prose
  edit; if blueprint-writer is dispatched for Differentials.tex this
  iter, fold the Jacobian.tex:6 fix into the same writer directive
  (it's the cheapest co-located correction).

## Overall verdict

The blueprint is in solid shape on 7 of 9 active chapters. The one
gating issue is `Differentials.tex` — the Step-5 prose was not
updated after the iter-119 prover diagnosed the type-bridge defect,
and the proposed helper lemma is documented only in a `% NOTE:`
comment. Defer the Differentials prover lane, dispatch a
blueprint-writer this iter, and pick up Differentials again in
iter-121. The one cross-chapter `\ref` bug (Jacobian.tex:6 → orphan
chapter) is a co-located cleanup.

9 chapters audited, 7 findings (3 must-fix + 3 soon + 1 informational
+ the cross-chapter broken-ref); recommend dispatching
`blueprint-writer` on `Differentials.tex` (with Jacobian.tex:6 ref-fix
folded in) before any iter-120 prover lane runs.
