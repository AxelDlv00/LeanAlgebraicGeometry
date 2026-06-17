# Blueprint Review Report

## Slug
iter122

## Iteration
122

## Top-level summaries

### Incomplete parts
- (none specific to this iter beyond known issues listed in the directive)

### Proofs lacking detail
- (none — the iter-121 expansions of `thm:nonempty_jacobianWitness` § C.2.a–C.2.g
  and the iter-122 inline-corrected M1.b proof in
  `Differentials.tex` § sec:bridge are both at the level a prover can
  consume.)

### Lean difficulty quality
- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.appLE_isLocalization}`
  (line 154): namespace inconsistent with the directive's stated
  iter-122 correction "namespace `Scheme.appLE_isLocalization` →
  `IsAffineOpen.appLE_isLocalization`". The file still shows
  `AlgebraicGeometry.Scheme.appLE_isLocalization`. The corrected
  namespace (per the persistent analogist file
  `analogies/relative-differentials-presheaf-bridge.md`, Decision 2
  Verdict ALIGN_WITH_MATHLIB and § Recommendation item 5) is
  `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`, matching
  Mathlib's `IsAffineOpen.isLocalization_basicOpen` namespace
  convention. A prover dispatched against the current hint will create
  the declaration in the wrong namespace and a subsequent rename
  step will be required. Surface as a Lean-difficulty-quality finding
  because the hint is on an active M1 prover route (the refactor
  subagent is queued to land this declaration this iter).

### Multi-route coverage
- Route **M1 — Bridge** (presheaf ↔ algebra-Kähler on affine chart):
  PARTIAL — covered in `Differentials.tex` § sec:bridge (statement
  block `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` plus
  three sub-lemmas), but the chapter has the iter-122 must-fix items
  listed under `Differentials.tex` below (stale `\ref{...}` cross-ref,
  stale `\lean{...}` namespace). Until those land, M1 prover
  dispatch on `Differentials.lean` is gated.
- Route **M2 — Genus-0 witness (Brauer–Severi-aware via $\bar k$ +
  Galois descent)**: PASS — fully covered in `Jacobian.tex` § C.2
  (seven sub-steps C.2.a–C.2.g, iter-121 expansion + iter-122
  inline corrections to (γ) bullet and Layer I).
- Route **M3 — Positive-genus witness, Route A (Picard / FGA)**:
  PARTIAL — the M3 chapters `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, `Picard_LineBundle.tex` exist on disk and
  are well-formed, but `blueprint/src/content.tex` does NOT
  `\input{}` them. They will not render in the rendered blueprint
  PDF / web build until `content.tex` is updated. See "Cross-chapter
  notes" below. Route covered in chapter text; not consumable via the
  rendered blueprint until content.tex includes them.
- Route **M3 — Positive-genus witness, Route B (symmetric powers /
  Stein)**: PARTIAL — covered at a high level in `Jacobian.tex` §
  Route B and § "Mathlib infrastructure summary" (β); no dedicated
  chapter elaborates the Stein factorisation construction beyond
  the four-bullet sketch in `Jacobian.tex`. Not blocking this iter
  (M3 is downstream of M1).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Cross-chapter inconsistency with `Jacobian.tex`'s iter-122
    correction. Lines 82 and 87 still carry the stale framing
    "rigidity result $\Hom(\mathbb P^1_k, A) = A(k)$ of Mumford
    \S4" and "the rigidity theorem $\Hom(\mathbb P^1_k, A) = A(k)$
    (genus-$0$ sub-case)". The iter-122 plan agent's inline
    corrections to `Jacobian.tex` removed exactly this framing
    (in favour of the base-change-to-$\bar k$ + Galois-descent
    formulation of § C.2) but did not propagate to `AbelJacobi.tex`.
    Inside `AbelJacobi.tex` these are flagged as "classical
    description" content not replayed by the Lean side, but the
    framing is now inconsistent with the chapter the same
    classical-description paragraph cross-references
    (`Jacobian.tex` § C.1–C.3).
  - All `\uses{...}` and `\lean{...}` references resolve correctly.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The two producerless carrier classes `HasCechToHModuleIso`
    (§ Comparison-iso typeclass carrier) and
    `HasAffineCechAcyclicCover` (§ Affine Čech-acyclic cover
    carrier) are disclosed and accepted per the directive's "Known
    issues" list — not re-reported.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - —

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - —

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The `IsAffineHModuleHomFinite` dead chain (review118 #1) is
    disclosed and accepted per the directive's "Known issues" list
    — not re-reported.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Broken `\ref{...}` cross-reference at line 156** (`lem:appLE_isLocalization`
    statement body). The lemma opens with
    "In the setting of Theorem~`\ref{thm:relativeDifferentialsPresheaf_iso_kaehler_appLE}`",
    but the only label declared in the chapter is
    `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` (line 114,
    `_equiv_`, post iter-122 rename per the analogist file's § Recommendation
    item 4). The `_iso_` form is a stale leftover from the pre-rename
    blueprint and points at a non-existent label. Plastex will render
    this as `??`; downstream graph generators will treat the lemma as
    having no upstream attachment to the theorem it is a sub-step of.
  - **Stale `\lean{...}` namespace at line 154**. The hint reads
    `\lean{AlgebraicGeometry.Scheme.appLE_isLocalization}` but the
    directive states the iter-122 plan agent applied the correction
    "namespace `Scheme.appLE_isLocalization` →
    `IsAffineOpen.appLE_isLocalization`" per the analogist file's
    § Recommendation item 5. The correction is not visible in the
    file. A prover (or refactor subagent) dispatched against the
    current hint will create the declaration under `Scheme.*` and
    require a subsequent rename step to align with Mathlib's
    namespacing (cf. `IsAffineOpen.isLocalization_basicOpen` at
    `Mathlib.AlgebraicGeometry.AffineScheme`, the directly analogous
    Mathlib precedent).
  - Minor `\uses{...}` inaccuracy on `lem:kaehler_localization_subsingleton`
    (line 189): the lemma's `\uses{}` block names `lem:appLE_isLocalization`,
    but the lemma itself is a generic algebraic statement ("Kähler
    module of any localization is subsingleton") with no scheme-side
    or `appLE`-side input. The Mathlib closure is a two-line
    composition of `Algebra.FormallyUnramified.of_isLocalization` +
    `Algebra.FormallyUnramified.subsingleton_kaehlerDifferential` (per
    the analogist file's § Auxiliary finding "M1.c is NOT a Mathlib
    gap"). The `\uses{lem:appLE_isLocalization}` cross-edge is
    mathematically spurious; it pollutes the blueprint dependency
    graph by attaching a generic lemma to a scheme-shaped consumer.
    Informational, not blocking — but cleanup is cheap.
  - The other `\uses{...}` cross-references (lines 116, 127, 200,
    205) resolve to existing labels.
  - The four-step M1.b proof sketch (lines 159–184) is consistent
    with the analogist's iter-121 finding: two-direction
    `IsLocalization.of_le` pattern, no `Functor.Final` cofinality.
    The Mathlib closure pieces listed in the proof's "Mathlib
    leverage summary" (lines 173–179) — `IsAffineOpen.isLocalization_basicOpen`,
    `IsAffineOpen.basicOpen_eq_iff_isUnit`, `IsLocalization.lift`,
    `IsLocalization.ringHom_ext`, `IsLocalization.of_le` — are
    plausible Mathlib references; verification is downstream of the
    refactor / prover.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - —

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-122 inline corrections to line 376 (Mathlib infrastructure
    summary (γ) bullet) and line 387 (Layer I bullet) are in place:
    both now use the base-change-to-$\bar k$ + Galois-descent framing
    of § C.2 and avoid any unconditional $C \cong \mathbb P^1_k$
    claim. The (γ) bullet reads "the rigidity theorem for
    $\mathbb P^1_{\bar k} \to A_{\bar k}$ over the algebraic closure,
    together with Galois descent of morphism equality of schemes",
    which matches § C.2.a–C.2.g.
  - The seven-step C.2 expansion (lines 320–358) decomposes cleanly:
    statement over $\bar k$ (C.2.a), reduction to the project's
    `\thm:GrpObj_eq_of_eqOnOpen` (C.2.b), image-dimension argument
    (C.2.c), classical-input "proper rational curves on an abelian
    variety are constant" (C.2.d, both standard proofs sketched),
    set-to-scheme equality (C.2.e), Galois descent to $k$ (C.2.f),
    Mathlib-gap statement (C.2.g). Adequate for a prover on
    `\thm:nonempty_jacobianWitness` once the M2/M3 routes unblock.
  - The `\leanok`-in-proof anomaly at the proof block of
    `\thm:nonempty_jacobianWitness` (line 249 marker, while the
    Lean body is `sorry`) is `sync_leanok`'s responsibility per
    directive; not flagged.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter not included in `blueprint/src/content.tex` (cross-chapter
    note below); content itself is well-formed. The named-deferred
    `instIsMonoidal_W` gap is honestly disclosed in
    Remark~`\ref{rem:W_IsMonoidal_load_bearing}`.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter not included in `blueprint/src/content.tex` (cross-chapter
    note below); content itself is well-formed. The post-C1 dependency
    note (§ "Post-C1 dependency note") cleanly enumerates the named-
    deferred sorry chain.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter not included in `blueprint/src/content.tex` (cross-chapter
    note below); content itself is well-formed.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Chapter not included in `blueprint/src/content.tex` (cross-chapter
    note below); content itself is well-formed. The split named-
    deferred gap pair (`thm:SheafOfModules_pullback_tensorObj`,
    `thm:SheafOfModules_pullback_oneIso`) is honestly disclosed.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The six redundant typeclass args on `GrpObj.eq_of_eqOnOpen`
    (review118 #2) are disclosed and accepted per the directive's
    "Known issues" list — not re-reported.

## Cross-chapter notes

- **`content.tex` omits four chapters.** `blueprint/src/content.tex`
  only `\input{}`s nine chapters:
  `Cohomology_SheafCompose`, `Cohomology_StructureSheafAb`,
  `Cohomology_StructureSheafModuleK`, `Cohomology_MayerVietoris`,
  `Differentials`, `Genus`, `Jacobian`, `Rigidity`, `AbelJacobi`.
  The four chapters `Modules_Monoidal`, `Picard_Functor`,
  `Picard_FunctorAb`, `Picard_LineBundle` exist on disk and contain
  the project's M3 Route A coverage but will not render in the
  blueprint PDF or web build. This silently hides the M3 Route A
  scaffolding from any consumer reading the rendered blueprint.
  Whether intentional (the chapters were trimmed out at the M3-defer
  decision) or oversight is ambiguous. Recommend either adding the
  four `\input{}` lines OR removing the chapter files entirely so
  the on-disk state matches the published state.

- **`AbelJacobi.tex` retains the framing `Jacobian.tex` corrected.**
  Iter-122 plan agent removed the stale "rigidity result
  $\Hom(\mathbb P^1_k, A) = A(k)$ of Mumford \S4" prose from
  `Jacobian.tex` (per directive's strategy snapshot, lines 376
  and 388). The same prose persists in `AbelJacobi.tex` at lines
  82 and 87, in the same "classical description" register but now
  contradicting what `Jacobian.tex` (which `AbelJacobi.tex` cross-
  references) actually says about the genus-0 sub-case. This is a
  cross-chapter consistency defect — easy to fix in a follow-up
  blueprint-writer dispatch on `AbelJacobi.tex`.

- **`Differentials.tex` stale `_iso_` vs `_equiv_` cross-reference.**
  The chapter renamed
  `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE` →
  `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` (per the
  analogist file's § Recommendation item 4, applied at line 114),
  but the back-reference in `lem:appLE_isLocalization` body (line
  156) still uses the `_iso_` form, which now resolves to no
  label. This is a self-contained chapter-local fix (one `_iso_` →
  `_equiv_` rewrite at line 156).

## Strategy-modifying findings (if any)

None. The M1 / M2 / M3 strategy from the directive remains
well-formed; the active route (M1) is gated by chapter-fix work
on `Differentials.tex` only, not by any strategy change.

## Severity summary

- **must-fix-this-iter**:
  - `Differentials.tex` broken `\ref{thm:relativeDifferentialsPresheaf_iso_kaehler_appLE}`
    at line 156 — the bridge theorem's only sub-lemma cross-references
    a non-existent label, silently corrupting the dependency graph.
    Touches `Differentials.lean`, an active M1 prover route this iter.
    Per HARD GATE rule (broken `\uses{}` / `\ref{...}` to non-existent
    labels), the refactor subagent dispatch on
    `Differentials.lean` for M1 must be deferred this iter until a
    blueprint-writer fixes the stale `_iso_` reference.
  - `Differentials.tex` stale `\lean{Scheme.appLE_isLocalization}`
    namespace at line 154 — the hint is on an active M1 prover route
    (the iter-122 refactor subagent will land this declaration), and
    the hint points at a namespace that the directive explicitly says
    was corrected to `IsAffineOpen.appLE_isLocalization`. Compounds
    the broken-`\ref` finding above; the same blueprint-writer
    dispatch handles both.
  - `AbelJacobi.tex` stale `\Hom(\mathbb P^1_k, A) = A(k)` framing
    (lines 82, 87) — cross-chapter inconsistency with the
    iter-122-corrected `Jacobian.tex` § C.2 framing. Touches
    `AbelJacobi.lean` (not active for an M1/M2 prover this iter,
    but the prose contradicts the directive's "Known issues"
    description of `Jacobian.tex`'s corrected state). Per severity
    rule "Any chapter has `correct: partial`", a blueprint-writer
    dispatch on `AbelJacobi.tex` is mandatory.

- **soon**:
  - `Differentials.tex` line 189: `\uses{lem:appLE_isLocalization}`
    on `lem:kaehler_localization_subsingleton` is mathematically
    spurious (lemma is generic) and pollutes the dependency graph.
    Cleanup is one-line.
  - `content.tex` omits four chapters (Modules_Monoidal, Picard_*);
    decide intentional vs. oversight and reconcile.

- **informational**:
  - The iter-122 inline corrections to `Jacobian.tex` § Mathlib
    summary (γ) bullet and § Layer I are in place and self-consistent.

Overall verdict: M1 prover dispatch on `Differentials.lean` is
**gated this iter by must-fix chapter work** (broken `\ref{_iso_}`
and stale `\lean{Scheme.*}` namespace in `Differentials.tex`); M2
chapter `Jacobian.tex` is HARD-GATE-clear; `AbelJacobi.tex`
requires a parallel chapter-fix for cross-chapter prose consistency.
