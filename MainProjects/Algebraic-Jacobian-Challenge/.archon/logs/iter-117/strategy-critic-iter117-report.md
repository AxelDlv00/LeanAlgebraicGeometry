# Strategy Critic Report

## Slug
iter117

## Iteration
117

## Frame

The user directive in `USER_HINTS.md` overrules the prior STRATEGY.md's
core architectural commitment: deferring named Mathlib gaps as
permanent end-state disclosures. Under "nothing deferred, every signed
statement is correct," exactly two strategic shapes are honest:

- **TRIM**: shrink the project's deliverable scope so every shipped
  statement is fully closed.
- **BUILD**: commit multi-iter resources to filling the underlying
  Mathlib infrastructure for each kept declaration.

The prior strategy's third shape — **DEFER** (`-- DEFERRED (budget)`,
`JacobianWitness` exit, "load-bearing disclosure of `instIsMonoidal_W`",
the 7 named gaps) — is now off the table per the user.

The protected chain has **exactly one** load-bearing sorry
(`nonempty_jacobianWitness` at `Jacobian.lean:179`). All other 15
inline sorries are orphan project content. This is the single most
important fact for re-shaping the strategy and the current
STRATEGY.md does state it (in the load-bearing-vs-orphan paragraph)
but then proceeds as if the orphan sorries are obligations on equal
footing with the protected chain — a sunk-cost framing the directive
rejects.

## Routes audited

### Route: Phase A — Čech acyclicity / `BasicOpenCech.lean`

- **Goal-alignment**: FAIL — the file's 6 sorries are *all* orphan to
  the 9 protected declarations. `Genus.lean` defines genus directly
  via `Scheme.HModule k (Scheme.toModuleKSheaf C) 1`; no protected
  declaration transits through `BasicOpenCech`.
- **Mathematical soundness**: PARTIAL — the L1120 lane has been STUCK
  for 7+ iters per progress-critic; L1846 is mechanizable from
  existing Mathlib (per the strategy text's own iter-108 audit) but
  parked. Mathematical statements are correct.
- **Sunk-cost reasoning detected**: yes — "L1846 reactivation is on
  the table as a fallback wedge-task"; the entire Phase A row is
  framed around preserving the iter-107/108 partial scaffolding rather
  than asking whether the file should exist at all.
- **Effort honesty**: under-counted — "per-substep close-out ~30-80
  LOC conditional on the predecessor substep landing" hides the
  reality that the L1120 predecessor has been paused for 7+ iters.
- **Verdict**: REJECT — under the directive, the right move is to
  *delete* `BasicOpenCech.lean` (and trim `Cohomology_*.tex`
  accordingly), keeping only the minimal Čech infrastructure that
  `MayerVietorisCover.lean` and `StructureSheafModuleK.lean` actually
  consume. The "deferred" annotation is exactly what the user
  prohibits; an unused, partially-broken file violates "should always
  be correct."

### Route: Phase B — `Differentials.lean` (5 sorries: L191, L737, L931, L947, L1091)

- **Goal-alignment**: FAIL on `serre_duality_genus` (L1091); PARTIAL
  on the smoothness-iff lemmas (L931, L947) and the
  unique-gluing/exact-sequence helpers (L191, L737). None of the five
  are transitively required by the 9 protected declarations.
- **Mathematical soundness**: PASS on the statements; the
  smoothness-iff content is real mathematics and the
  iter-116-identified Mathlib bridge
  `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`
  [verified] does collapse the algebra-side translation.
- **Phantom prerequisites**: `SheafOfModules.exact_iff_stalkwise`
  named in L737's status comment is genuinely missing from Mathlib
  b80f227. The algebra-side ingredients exist
  (`exact_of_isLocalized_span` [verified], `exact_of_localized_maximal`
  [verified]) but the packaged sheaf-side criterion does not — closure
  requires a project-local ~300-1000 LOC bridge.
- **Sunk-cost reasoning detected**: yes — the entire 3-option L175/L191
  fan in the current strategy is framed around preserving
  `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` as a
  sheaf-level lemma rather than asking whether downstream consumers
  *need* it as a sheaf-level lemma. Option 2 (presheaf-only refactor)
  is mathematically the right answer and should have been the default
  the moment iter-114 verified the missing-Mathlib-bridge.
- **Effort honesty**: under-counted on L1091 (Serre duality from first
  principles in Mathlib is a Hartshorne-chapter undertaking;
  `[gap]` — no dualizing sheaf, no trace map, no Zariski coherent
  cohomology of `O_X`-modules). Reasonable on L931/L947 (the iff form
  collapses to 1 iter + chart-by-chart lift).
- **Verdict**: CHALLENGE — split this row:
  - L191: REFACTOR to presheaf-only consumers (Option 2 in the
    directive's enumeration) and DELETE the sheaf-level lemma.
    Closeable.
  - L737 (`h_exact` of `cotangentExactSeq_structure`): downgrade the
    `Exact` conjunct to a project-local consumer-side requirement on
    each affine chart, or BUILD the ~300-1000 LOC stalkwise-exactness
    bridge.
  - L931 + L947 (`smooth_iff_locally_free_omega` +
    `cotangent_at_section`): CLOSE via the iter-116 Mathlib bridge +
    `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` [verified] +
    chart-by-chart lift (~3-5 iters total).
  - L1091 (`serre_duality_genus`): DELETE the theorem and the
    `Serre duality genus equality` blueprint subsection.

### Route: Phase C0 — `instIsMonoidal_W` (`Modules/Monoidal.lean` L173)

- **Goal-alignment**: FAIL — orphan to all 9 protected declarations.
  Load-bearing only on the Picard arc, which is itself project
  content beyond the protected chain.
- **Mathematical soundness**: PASS — the statement is correct.
- **Phantom prerequisites**: the strategy claims this is a Mathlib
  gap on `stalk_tensorObj` for varying-ring `PresheafOfModules`. The
  alternative route via `CategoryTheory.Sheaf.monoidalCategory`
  [verified] hits the *same* gap because that lemma also requires
  `J.W.IsMonoidal`.
- **Sunk-cost reasoning detected**: yes — "pre-C1: dormant; post-C1:
  load-bearing for entire Pic-and-down arc". This is *itself* the
  story of paying for sunk costs: the C1 promotion at iter-109 was
  done knowing it would activate this gap.
- **Effort honesty**: the strategy correctly says "defer
  indefinitely". Under the new directive, deferral is not allowed.
  Actual closure (the iso-stability-of-presheaf-tensor-under-
  sheafification argument) is bounded but non-trivial: ~500-1500 LOC
  Mathlib-style infra build.
- **Verdict**: REJECT — under the directive, recommend TRIM: remove
  `Modules/Monoidal.lean` (or rewrite to a stub that does not provide
  `instIsMonoidal_W`); pair this with TRIM on `Picard/LineBundle.lean`
  + `Picard/Functor.lean` + `Picard/FunctorAb.lean` (see below). The
  BUILD option (~500-1500 LOC) is feasible but would consume many
  iters; pre-commit needed before going down it.

### Route: Phase C1 — `Picard/LineBundle.lean` L82, L96

- **Goal-alignment**: FAIL — orphan; `Pic.pullback` is not consumed by
  any protected declaration.
- **Verdict**: REJECT under the directive — TRIM `Pic.pullback`,
  `Pic.pullback_id`, `Pic.pullback_comp`, and the two sorry-bodied
  iso helpers. Keep `Pic X := (Skeleton X.Modules)ˣ` as a pure
  definition (no sorry); drop the functoriality wing.

### Route: Phase C2 — `Picard/Functor.lean` L181 `representable`

- **Goal-alignment**: FAIL — orphan and explicitly named "FGA-level,
  not honestly closeable on the global-sections-approximate
  LineBundle".
- **Verdict**: REJECT under the directive — TRIM the
  `PicardFunctor.representable` declaration outright. Optionally trim
  `Picard/Functor.lean` and `Picard/FunctorAb.lean` entirely; their
  status comment already admits the file's content is not
  protected-chain load-bearing.

### Route: Phase C3 — `nonempty_jacobianWitness` (`Jacobian.lean` L179)

- **Goal-alignment**: PASS on what it provides (the framework is
  well-typed); **FAIL on the directive** (it is the canonical "always
  temporarily wrong" pattern — a sorry-bodied existence theorem that
  every protected definition transits through). The current
  `Jacobian C := (jacobianWitness C).J` definition is logically
  equivalent to introducing an `axiom`, which is exactly what the user
  prohibits ("no wrong definition/proofs/signatures").
- **Mathematical soundness**: the *statement* of
  `nonempty_jacobianWitness` is true (Albanese varieties exist for
  smooth proper geometrically irreducible curves over a field). But
  the chain `protected Jacobian := Classical.choice (sorry)` is
  exactly the "temporarily wrong" pattern, sound only up to a sorry.
- **Phantom prerequisites**: Hilbert/Quot schemes [gap]; finite-group
  scheme quotients [gap]; FGA representability [gap]; divisor-class-
  image Pic⁰ alternative also requires Riemann-Roch effective theory
  [gap] + scheme-theoretic image API [gap].
- **Sunk-cost reasoning detected**: yes — "Jacobian framework
  conditional on `nonempty_jacobianWitness` ≠ Jacobian constructed"
  is the strategy's own admission that the deliverable is vacuous; it
  is then justified by "the protected chain bottoms out at the
  JacobianWitness gap" rather than re-examining whether the witness
  pattern is the right scaffold.
- **Effort honesty**: the strategy concedes "wildly under-counted" on
  the routes. Under the new directive there is no honest in-loop
  closure; the choice is BUILD (multi-month Mathlib infra commitment)
  or escalate to the user.
- **Verdict**: REJECT — must be resolved before any further iter
  fires. The directive is incompatible with the current `Jacobian`
  body. Two honest options:
  1. **Multi-month BUILD plan** for one of the alternative routes
     (divisor-class-image Pic⁰; degree-0 line-bundles via
     `LineBundle`/`Pic` quotient; relative Albanese via formal
     deformation theory). Each requires a chain of Mathlib
     prerequisites that themselves are multi-thousand-LOC builds.
  2. **Escalate** to the user with a one-shot question: "the
     directive 'nothing deferred' is incompatible with shipping the
     protected `Jacobian` declaration in this loop; choose: (A)
     temporarily remove `Jacobian`/`ofCurve` from
     `archon-protected.yaml` so the project ships only the
     unconditional core (`genus`, `Rigidity`, etc.); (B) keep them
     and commit to the multi-month build; (C) waive the no-deferral
     rule specifically for `nonempty_jacobianWitness`."

## Alternative routes (suggested)

### Alternative: Aggressive TRIM to unconditional core

- **What it looks like**: ship `Rigidity.lean`, `Genus.lean`,
  `Cohomology/StructureSheafModuleK.lean`,
  `Cohomology/MayerVietorisCover.lean`, and a stripped
  `Differentials.lean` that contains only the closeable smoothness-iff
  lemmas + the cotangent presheaf API. Delete `BasicOpenCech.lean`,
  `Modules/Monoidal.lean`, `Picard/*.lean`, the Serre-duality + L737
  + L191 obligations, and (with user authorisation) drop
  `Jacobian`/`ofCurve` from `archon-protected.yaml`.
- **Why it might be cheaper or sounder**: the only directive-compliant
  state where every shipped statement is fully closed. Eliminates ~15
  of 16 sorries by removing their containing declarations. Honest
  about what the project does and does not deliver in this loop.
- **What the current strategy may have rejected**: scope-shrink is
  framed as "invalidating the blueprint chapters" — but the blueprint
  is the *project's* commitment, editable in lockstep with the
  strategy. Trimming blueprint chapters alongside Lean files is not a
  loss of math, it is a recalibration of scope.
- **Severity**: critical — this is the directive-honest default and
  the current STRATEGY.md does not even enumerate it.

### Alternative: Divisor-class-image Pic⁰ for the Jacobian

- **What it looks like**: define `Jacobian C` as the scheme-theoretic
  image of `C^g → Pic^g(C)` (Riemann-Roch effective theory says this
  image *is* `Pic^g` for `g = genus C`), then translate to `Pic⁰` via
  a base-point choice. Avoids Hilbert/Quot/finite-group-quotients but
  still requires multi-thousand-LOC Mathlib infra for Riemann-Roch +
  scheme-theoretic image + birational-image-is-group-scheme.
- **Why it might be cheaper or sounder**: avoids the worst of the
  named gaps; uses Pic which the project is already approximating.
- **What the strategy rejected**: the current strategy mentions this
  as a "future-work option" but does not cost it. Severity: major —
  if the user chooses BUILD over TRIM, this route should be costed
  and compared head-to-head with the Sym^g/S_g and FGA routes.

### Alternative: Refactor `Differentials.lean` consumers to presheaf-only

- **What it looks like**: drop the `relativeDifferentialsPresheaf …
  IsSheafUniqueGluing` lemma (L191), rephrase
  `smooth_iff_locally_free_omega` and `cotangent_at_section` to
  quantify over affine charts directly (which the iter-116 Mathlib
  bridge `AlgebraicGeometry.isSmoothOfRelativeDimension_iff`
  [verified] already does), and remove the sheaf-condition obligation
  entirely.
- **Why cheaper**: the algebra-side framing is already what
  `isSmoothOfRelativeDimension_iff` uses; "sheafification" is a
  detour. Removes one whole class of sorries.
- **Severity**: critical — this should be Option 2 in any
  replacement strategy and chosen as the default; the current
  three-option fan in the strategy implicitly treats Options 1 and 3
  as equally viable but only Option 2 is directive-compliant (no
  deferral, no oversized infra build).

## Sunk-cost flags

- "Phase A escape-valve fired with Option (i) — defer L1846" — Sunk-
  cost smell: the iter-108 partial scaffolding is preserved at the
  cost of the directive's "no deferrals" rule. Reframe on merits:
  delete the file unless it is genuinely load-bearing.
- "iter-109 universe bumps absorbed cleanly" — the C1 promotion
  *introduced* the `instIsMonoidal_W` load-bearing transition; the
  current strategy treats this as a feature. Under the directive it
  is a regression.
- "Jacobian framework conditional on `nonempty_jacobianWitness` ≠
  Jacobian constructed" — the strategy admits the protected Jacobian
  is vacuous and then defends shipping it anyway via the
  "blueprint-completeness commitment". Reframe: the blueprint is a
  draft, not a binding contract.
- "If iter-117+ progress-critic reports CHURNING on L880-converse for
  2+ iters, the narrower trim fires" — under the new directive,
  reactive trim is too late; the planner must decide TRIM vs BUILD
  upfront.
- "L1846 reactivation is on the table as a fallback wedge-task" —
  classic sunk-cost: the only reason L1846 is named is the iter-108
  scaffold. The work is orphan; the file should be reconsidered for
  removal, not reactivation.

## Prerequisite verification

- `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`:
  VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`).
- `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`:
  VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: VERIFIED.
- `AlgebraicGeometry.isSmoothOfRelativeDimension_iff`: VERIFIED
  (`Mathlib.AlgebraicGeometry.Morphisms.Smooth`).
- `AlgebraicGeometry.Scheme.Modules.pullback`: VERIFIED
  (`Mathlib.AlgebraicGeometry.Modules.Sheaf`).
- `CategoryTheory.Sheaf.monoidalCategory`: VERIFIED — but requires
  `J.W.IsMonoidal`, the *same* obstruction as `instIsMonoidal_W`. Not
  an escape hatch.
- `Functor.Monoidal (Scheme.Modules.pullback f)`: MISSING (no
  `Functor.Monoidal` instance).
- `SheafOfModules.exact_iff_stalkwise`: MISSING — algebra-side
  ingredients exist (`exact_of_localized_maximal` [verified],
  `exact_of_isLocalized_span` [verified]) but the sheaf-side wrapper
  must be built locally.
- Hilbert / Quot schemes: MISSING.
- Finite-group scheme quotients: MISSING.
- Dualizing sheaf / trace morphism / Serre duality for proper
  morphisms: MISSING.
- Zariski coherent cohomology of `O_X`-modules: MISSING (only
  ℓ-adic on the pro-étale site).
- Riemann-Roch effective theory: MISSING.
- Scheme-theoretic image API at the granularity needed for
  divisor-class-image: MISSING.

## Recommended replacement-strategy shape

Five top-level sections, in this order, no prose-bloat:

1. **Project goal + protected chain.** One paragraph: 9 protected
   declarations; their type-correctness; the single load-bearing
   sorry `nonempty_jacobianWitness`.
2. **What ships unconditionally.** Explicit file-by-file list of
   declarations whose `lean_verify` surfaces no `sorryAx`. Today:
   `Rigidity`, `Genus.genus`, `StructureSheafModuleK`,
   `MayerVietorisCover`, the closeable smoothness-iff lemmas (after
   iter-117+ closure), `FunctorAb` additive wrapping iff Pic is
   trimmed correctly.
3. **What ships framework-conditionally (with explicit user
   acknowledgement).** Only `Jacobian`/`ofCurve`/four-instances/
   `comp_ofCurve`/`exists_unique_ofCurve_comp`, conditional on
   `nonempty_jacobianWitness`. **Must be explicitly listed as the one
   waived no-deferral; if the user does not waive, the protected
   declarations must be removed from `archon-protected.yaml`
   (escalation required).**
4. **What is being closed this loop.** Per-sorry concrete plan with
   verified Mathlib lemmas, no `[expected]` claims:
   - L191 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`:
     REFACTOR consumers + DELETE.
   - L737 `cotangentExactSeq_structure.h_exact`: BUILD the ~300-1000
     LOC stalkwise-exactness bridge OR weaken the statement to drop
     the `Exact` conjunct (deliver `h_zero` + `Epi` only).
   - L931 `smooth_iff_locally_free_omega`: CLOSE via Mathlib bridge.
   - L947 `cotangent_at_section`: CLOSE via pullback + L931.
5. **What is being removed this loop** (with corresponding blueprint
   chapter edits):
   - `BasicOpenCech.lean` (6 sorries) → trim
     `Cohomology_MayerVietorisCore.tex`.
   - `Modules/Monoidal.lean` (1 sorry, `instIsMonoidal_W`) →
     drop `Modules_Monoidal.tex` or rewrite as
     "monoidal structure deferred to Mathlib infra".
   - `Picard/LineBundle.lean`'s `Pic.pullback` family (2 sorries) →
     drop `Pic.pullback` from `Picard_LineBundle.tex`.
   - `Picard/Functor.lean`'s `PicardFunctor.representable` (1 sorry)
     → drop the theorem + the representability paragraph from
     `Picard_Functor.tex`.
   - `Differentials.lean` L1091 `serre_duality_genus` → drop the
     "Serre duality genus equality" subsection from
     `Differentials.tex`.

No "Path from today" prose, no per-iter narrative, no aggregate cost
tables. Sections 4 and 5 are the strategy.

## Must-fix-this-iter

- Route Phase A: REJECT — TRIM `BasicOpenCech.lean` or BUILD with a
  named multi-iter plan. The "DEFERRED (budget)" annotation is
  directive-incompatible.
- Route Phase B (L1091): REJECT — DELETE `serre_duality_genus` and
  its blueprint subsection; no in-loop closure exists.
- Route Phase B (L191): CHALLENGE — adopt Option 2 (refactor to
  presheaf-only). Options 1 and 3 are directive-incompatible.
- Route Phase C0: REJECT — TRIM `Modules/Monoidal.lean` or commit to
  BUILD with a named ~500-1500 LOC multi-iter plan.
- Route Phase C1: REJECT — TRIM `Pic.pullback` and the two iso
  helpers (L82, L96) or commit to BUILD `Functor.Monoidal` on the
  pullback functor (~500-2000 LOC).
- Route Phase C2: REJECT — TRIM `PicardFunctor.representable`. No
  honest closure on the project's current `LineBundle`.
- Route Phase C3: REJECT — the `JacobianWitness` exit policy is
  exactly the "temporarily wrong" pattern the directive prohibits.
  Must escalate to the user with a 3-option fan (A) drop protected
  Jacobian; (B) commit multi-month BUILD; (C) waive no-deferral for
  this one sorry.
- Alternative "aggressive TRIM to unconditional core": critical — the
  current strategy does not enumerate this option. The replacement
  must consider it as the default.
- Phantom prerequisite `SheafOfModules.exact_iff_stalkwise`: MISSING
  — L737's status comment names this as if it exists; it must be
  built locally or the statement weakened.

## Overall verdict

A fresh mathematician — and the user — would **reject** the current
STRATEGY.md as-is. Its core architectural commitment (defer named
Mathlib gaps as the end-state) is exactly what the user just
overruled. The strategy text contains accurate intel (sorry counts,
load-bearing-vs-orphan split, verified Mathlib lemmas) but its
top-level shape is incompatible with "nothing deferred." The
replacement strategy must (a) explicitly enumerate the aggressive
TRIM option that is currently missing; (b) per-sorry route to TRIM or
CLOSE rather than DEFER; (c) escalate the protected-chain
`nonempty_jacobianWitness` decision to the user, since that single
sorry cannot be closed in-loop and is the directive's one genuine
load-bearing collision. The orphan sorries are easy: trim them and
their blueprint chapters, and the project ships a smaller-but-honest
deliverable on the unconditional core.

`iter117: REJECT — 7 routes audited, 7 CHALLENGE/REJECT verdicts.`
