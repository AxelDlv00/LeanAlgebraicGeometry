# Blueprint Writer Report

## Slug
ratcurveiso-pin3-prose

## Status
COMPLETE

## Target chapters
- `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- `blueprint/src/chapters/RiemannRoch_OCofP.tex`

(Two chapters edited per directive — Pin 3 + Pin 2 signature refresh
on the RR.4 chapter, and a new typed-sorry-def declaration block on
the RR.3 chapter.)

## Changes Made

### `RiemannRoch_RationalCurveIso.tex`

- **Revised** `lem:degree_one_morphism_iso` (statement block) —
  replaced the implicit `\deg(\varphi) = 1` hypothesis with the
  explicit function-field-extension-degree-one formulation
  `[K(C) : K(C')] = 1`, formally
  `Module.finrank C'.functionField C.functionField = 1`. Added a
  "Convention on the function-field map" paragraph documenting the
  canonical `[Algebra C'.functionField C.functionField]` instance
  threaded into the Lean signature at each call-site (composite of
  `Scheme.Hom.stalkMap` at the generic point with
  `IsFractionRing.lift`), per `analogies/ratcurveiso-pin3.md`
  Decision 2.
  - Added a leading `% NOTE: ...` LaTeX comment referencing
    iter-181 Lane I + the analogies file with verdict
    `DIVERGE_INTENTIONALLY`.
  - The proof prose body (Hartshorne I.6.12 + alternative
    scheme-theoretic argument) is mathematically unchanged; only
    the proof's opening sentence was rephrased to match the new
    hypothesis shape (and the closing `Sub-build note.` paragraph
    was refreshed to mention the `[Algebra ...]` instance and the
    `Module.finrank ... = 1` hypothesis).
- **Revised** `lem:degree_via_pole_divisor` (statement block) —
  refactored the placeholder existential
  `∃ d D, 0 < d ∧ D.degree = d` (vacuous in `φ`) into the
  substantive existential
  `∃ D, D = φ^*[∞] ∧ deg(D) = [K(C):k̄(P¹)]`. Added a "Convention
  on the pole divisor" paragraph documenting the typed-sorry def
  `Scheme.Hom.poleDivisor` and the iter-183+ closure route via
  `Ideal.sum_ramification_inertia`. Added a leading `% NOTE: ...`
  LaTeX comment referencing the iter-182 plan-phase refactor slug
  `pin2-sig-strengthen`.
- **Revised** `thm:genus_zero_curve_iso_p1` Step 4 — added a one-line
  bridge that re-expresses the Step 3 conclusion
  `\deg(\varphi) = 1` as
  `Module.finrank k̄(P¹) K(C) = 1` (via Hartshorne IV.2) so the
  invocation of `lem:degree_one_morphism_iso` matches its new
  function-field-extension-degree hypothesis shape.

### `RiemannRoch_OCofP.tex`

- **Added definition** `\definition`/`\label{def:lineBundleAtClosedPoint_toFunctionField}`/
  `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}`
  — informal statement of the canonical $\bar k$-linear inclusion
  $\iota : H^0(C, \mathcal O_C(P)) \hookrightarrow K(C)$ obtained by
  composing with the structural inclusion
  $\mathcal O_C(P) \hookrightarrow \mathcal K_C$ at each point.
  Placed after the existing `def:lineBundleAtClosedPoint` block (and
  before `lem:lineBundleAtClosedPoint_globalSections_iff`) per the
  directive. Citation block reuses the same II.6 source quote (the
  $\mathscr L(D)$-as-subsheaf-of-$\mathscr K$ definition) already
  used by `def:lineBundleAtClosedPoint`.
- **Revised** `lem:lineBundleAtClosedPoint_globalSections_iff`'s
  `\uses{...}` line — added
  `def:lineBundleAtClosedPoint_toFunctionField` so the dependency
  graph picks up the new node.

## Cross-references introduced

- `\uses{def:lineBundleAtClosedPoint_toFunctionField}` added to
  `lem:lineBundleAtClosedPoint_globalSections_iff` (statement block;
  the proof's `\uses{...}` was left unchanged because the proof
  derives the inclusion from the parent definition directly without
  invoking the named map). Both blocks live in the same chapter, so
  the cross-reference resolves locally.
- `\Cref{def:lineBundleAtClosedPoint_toFunctionField}` is referenced
  from the new
  `Pin 2 ... \texttt{Scheme.Hom.poleDivisor}` paragraph in
  `RiemannRoch_RationalCurveIso.tex` (as a cross-chapter pattern
  pointer — "mirroring the OCofP pattern in which a typed-sorry def
  is introduced upstream of its consumer lemma"). The cross-chapter
  `\Cref` resolves via `leanblueprint`'s global label scope.

## References consulted

- `references/hartshorne-algebraic-geometry.md` — registry / source
  card for Hartshorne. Confirmed the local file path
  `references/hartshorne-algebraic-geometry.pdf` and verified the
  II.6 verbatim source quote (the
  `\mathscr L(D)`-as-subsheaf-of-`\mathscr K` definition, PDF
  page 161) was already character-by-character extracted in the
  existing `def:lineBundleAtClosedPoint` and is re-used (identical
  bytes) for the new `def:lineBundleAtClosedPoint_toFunctionField`
  block.
- `analogies/ratcurveiso-pin3.md` — Decision 2 (the
  `DIVERGE_INTENTIONALLY` verdict that drove the iter-181 Lane I
  signature refinement to `Module.finrank ... = 1` with a
  `[Algebra C'.functionField C.functionField]` instance argument).
  Used to back the `% NOTE: ...` comment in `Edit 1`.

## Macros needed (if any)
None. All new prose uses existing macros (`\Cref`, `\Div`, `\div`,
`\ord`, `\deg`, `\mathcal O_C(P)`, `\mathbb P^1_{\bar k}`,
`\bar k`, `\texttt{...}`). No new commands introduced.

## Reference-retriever dispatches (if any)
None. The directive's "may need a child reference-retriever dispatch"
was conditional on `ls references/hartshorne*` being empty; that
check returned a populated entry (`hartshorne-algebraic-geometry.md`
+ `.pdf` present, both already verified by prior iters with the same
verbatim quote in-tree), so no retrieval was needed.

## Notes for Plan Agent

- The `def:lineBundleAtClosedPoint_toFunctionField` block reuses the
  parent `def:lineBundleAtClosedPoint`'s Hartshorne II.6 verbatim
  source quote (the
  `\mathscr L(D)`-as-subsheaf-of-`\mathscr K` definition). This is
  legitimate: the inclusion $\mathcal O_C(P) \hookrightarrow
  \mathcal K_C$ is **directly part of** Hartshorne's definition of
  $\mathscr L(D)$ (the quote literally says
  "We define a subsheaf $\mathscr L(D)$ of the sheaf of total
  quotient rings $\mathscr K$"), so the taking-global-sections of
  this inclusion produces $\iota$ without requiring a fresh source.
  Both citation blocks now share the same verbatim text. No
  duplication concern.
- The `% NOTE: ...` comment on `lem:degree_one_morphism_iso` points
  at `analogies/ratcurveiso-pin3.md`, which is in `analogies/` (not
  `references/`). The "verbatim from `references/...`" rule does
  NOT apply to `% NOTE: ...` comments (those are project-internal
  routing pointers, not external citation blocks), so this is fine.
- `RiemannRoch_RationalCurveIso.tex` now sits at 595 lines (was
  541); still under any reasonable split threshold. No
  reorganisation needed.

## Strategy-modifying findings

None. The two chapter edits are direct, mechanical consequences of:

  1. The iter-181 Lane I signature refinement landed in
     `RationalCurveIso.lean` (`Module.finrank ... = 1` replacing the
     `Nonempty (... ≃+* ...)` placeholder), per the
     `analogies/ratcurveiso-pin3.md` Decision 2
     `DIVERGE_INTENTIONALLY` verdict.
  2. The iter-182 plan-phase Pin 2 refactor (refactor slug
     `pin2-sig-strengthen`) refactoring the
     `morphism_degree_via_pole_divisor` signature to bind
     `D = poleDivisor φ` and `deg D = finrank K(C)/K(P¹)`,
     introducing the typed-sorry def `Scheme.Hom.poleDivisor`.
  3. The iter-181 `lean-vs-blueprint-checker iter181-ocofp` minor
     finding recommending a blueprint pin for the
     `lineBundleAtClosedPoint.toFunctionField` typed-sorry def on
     `OCofP.lean:154`.

No strategic ambiguity surfaced. No STRATEGY.md update required.
