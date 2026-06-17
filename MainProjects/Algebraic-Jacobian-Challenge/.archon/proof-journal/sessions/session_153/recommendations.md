# Recommendations for iter-154 (from session_153 review)

## Headline

Iter-153 closed `constants_integral_over_base_field` (9 → 8, axiom-clean),
validating the iter-152 `[IsAlgClosed]` pivot. Both review subagents (and
the blueprint doctor) are clean — **no must-fix or major findings this
iter.** The active Route C now has exactly one open sorry on its critical
path (KDM `mem_range_algebraMap_of_D_eq_zero`, FT.3 Mathlib gap), plus the
off-path (S3.*) and the Jacobian/Rigidity sorries.

## 1. KDM `mem_range_algebraMap_of_D_eq_zero` — dispatch `mathlib-analogist`, do NOT re-prove (HIGH)

**Blocked target — do NOT re-assign a prover round with a recipe variation.**
The single residual is blueprint step FT.3: for a separably generated char-0
field extension `K = Frac B / k`, `ker (KaehlerDifferential.D k K) =` relative
algebraic closure of `k` in `K`. iter-153 confirmed (full negative search,
documented in `ChartAlgebra.lean:398–426` and the KB Known-Blocker update)
that this is a **genuine Mathlib gap (b80f227)** — abstract-single-derivation
`ContainConstants`, the algebraic-only `FormallyUnramified`+`Subsingleton Ω`
case, and `Smooth/Field`'s `FormallySmooth` all fail to supply it.

**Action for the plan agent**: per the STRATEGY.md bright-line, dispatch
`mathlib-analogist` in **cross-domain-inspiration** mode on the structural
shape *"kernel of the universal derivation = field of constants for a
separable field extension"*. Failed approaches to feed it: (a) abstract
`Differential.ContainConstants` (no instance for the universal Kähler
derivation); (b) `FormallyUnramified`+`Subsingleton Ω` (algebraic-only,
`Ω=0`); (c) `Smooth/Field` `FormallySmooth` (no `Ω`-basis from a separating
transcendence basis). Suggested assembly to validate: separating
transcendence basis `{t_j}` ⟹ `Ω[K⁄k]` free on `{d t_j}`; cotangent exact
sequence `k → k(t) → K` with `Ω[K⁄k(t)] = 0` (separable-algebraic top via
`FormallyUnramified`) ⟹ `d x = 0` forces `x` algebraic over `k(t)`, char-0
over `k`, then `[IsAlgClosed k]` ⟹ `x ∈ k`. This is ~research-grade; the
analogist's job is to find whether any Mathlib domain has the
"kernel-of-derivation = constants" shape already.

## 2. `ChartAlgebraS3.lean` is now ENTIRELY ORPHANED — decide keep-deferred vs excise (MEDIUM, strategic)

`lean-auditor-iter153` (major) confirms by grep that **nothing consumes any
declaration in `ChartAlgebraS3.lean`** — not `ChartAlgebra.lean`, not
anywhere. The alg-closed shortcut that closed `constants_integral_over_base_field`
this iter obviated the entire (S3.sep/pi) path-(b) chain the file was built
to support (`isGeometricallyReduced_Gamma_of_smooth`,
`Gamma_baseChange_iso_tensor_of_proper`, the two separability/inseparability
lemmas, `Algebra.IsSeparable.of_finite_of_perfectField`, `gammaAlgebra`,
`gammaAlgebraMap`). The 4 (S3.*) sorries (L199/276/342/403) are no longer on
any critical path.

**Action for the plan agent (a genuine decision, not hygiene):** decide
whether to (a) **excise** `ChartAlgebraS3.lean` (and drop the now-likely-unused
`import …ChartAlgebraS3` at `ChartAlgebra.lean:6`) — cleanest, removes 4 sorries
from the count and a whole orphaned file; or (b) **keep it as a deferred
standalone** if the (S3.*) lemmas have independent value (e.g. a future
general-`k` route). Given the pivot is now validated and the route is alg-closed
only, (a) excise is the likely correct call — but it touches the blueprint
(`ChartAlgebraS3.tex` cref cascade) so route it through a `refactor` +
`blueprint-writer` pass, not a prover. **Note**: excising removes 4 sorries
(8 → 4) but they were always off-path; do not read that as proving progress.

## 3. Stale post-pivot documentation cleanup (MEDIUM — lean-auditor majors, none block proving)

`lean-auditor-iter153` returned **0 must-fix, 6 major, 6 minor** — every major
is post-pivot documentation/orphaning hygiene, none blocks proving. Beyond the
ChartAlgebraS3 orphaning (item 2) and the persistent `df_zero` sorryAx-launder
(carried unchanged from iter-152; documented in `iter/iter-153/review.md`
"Persistent soundness note" — the auditor flags that `df_zero`'s header/docstring
do not state it is unproven pending KDM, so a reader scanning sorry-warnings may
misread it as closed; a one-line `% NOTE`/docstring fix would address it), the
actionable stale-doc majors for a cleanup pass
(prover owning the file, or a refactor):
- `ChartAlgebra.lean` KDM body (L276–427): ~95 lines of inert
  `have`/`let`/`obtain` scaffolding (`_hFree`/`_basis`/`_hCoordVanish`/
  `SubmersivePresentation`/`bTilde`/`_hFunct`) precede a bare `sorry` that none
  of it feeds; underscore names suppress the unused linter. Plus a **route
  conflict**: the iter-150 MvPolynomial-transfer narrative (L311–351) and the
  iter-153 FT.3 field-theory narrative (L398–426) coexist, and the "remains
  valid and reusable" claim (L393–396) about the `_mvPoly_*`/`_hFunct`
  scaffolding is inconsistent with the iter-153 FT route, which does not consume
  it. **This is bright-lined for proving** — but when the `mathlib-analogist`
  consult (item 1) settles which route FT.3 actually takes, the losing
  scaffolding (and the orphaned `_mvPoly_*` chain L121–229) should be pruned so
  the body stops carrying two contradictory plans.
- `ChartAlgebraS3.lean` (L71–79, 96–98, 156–160, 312–315): stale consumer-
  integration claims describing a `constants_integral_over_base_field` code
  shape (`set α`/`algkΓ`, a `(b.1)` branch, direct invocation of the S3 lemmas)
  that the iter-153 rewrite removed — actively misleading about the dependency
  graph. (Moot if item 2 excises the file.)
- `Jacobian.lean` (L18–40): stale file-header inventory lists
  `nonempty_jacobianWitness` as a sorry (it is **closed** via delegation) and
  omits `positiveGenusWitness` (a **real** sorry at L223). Internally
  inconsistent with the correct per-decl docstrings.

Minor (LOW): `ChartAlgebra.lean:522–523` inline comment "smoothness gives
IsReduced X" contradicts the docstring (`[IsReduced X]` is explicit precisely
because `Smooth ⇒ IsReduced` is absent upstream); `[Smooth …]` at L511 is
unused by the proof (confirm it is intended/protected before pruning);
`ChartAlgebraS3.lean` stale `ChartAlgebra.lean:L367/L431/L457` line refs (actual
KDM L270 / df_zero L455 / constants_ L508); `GrpObj.lean:465–525` orphaned
"Piece (i.b) Step 2" prose describing declarations excised at L552–560.

## 4. Re-assess Route C trajectory with the first real post-pivot data (MEDIUM)

iter-153 is the **first prover data since the pivot**. The progress-critic
was skipped at iter-152/153 (no prover data / discharging its own
prescription). At iter-154 it should be re-dispatched on Route C with the
9→8 closure as new trajectory signal — the route just produced its first net
reduction in ~5 iters, so the read should improve from CHURNING. Feed it: the
9→8 delta, the single remaining critical-path sorry (KDM), and the fact that
KDM's corrective is now `mathlib-analogist` not another helper round.

## 5. Blueprint housekeeping (LOW — non-blocking, from lean-vs-blueprint-checker)

`lean-vs-blueprint-checker-chartalgebra-iter153` returned **PASS** (0
must-fix/major). Two optional minor items for a future blueprint-writer pass
(NOT this iter — both off the critical path):
- `RigidityKbar.tex` KDM proof block: the live FT route (~5 lines) is buried
  under ~70 lines of explicitly-superseded (p1)/(p2)/(BR.*) provenance prose.
  Consider relegating the superseded chains to an appendix/comment to keep
  the live recipe legible. (Already correctly labelled "Superseded …
  auditable record only" — not stale-as-live, just verbose.)
- `ChartAlgebra.lean` KDM body retains dead `_hFree`/`_basis`/`_hCoordVanish`
  (BR.2/BR.3) scaffolding as unused `have`/`let` — matches the documented
  disposition; a future golf pass may prune. NOT a prover task now (the body
  is bright-lined).

## 6. Deferred off-path item (LOW — carried from iter-153 plan)

Stacks-tag drift: smooth ⇒ geometrically-reduced cited as Tag **04QM** in
`RigidityKbar.tex` vs **056T** in the descoped `ChartAlgebraS3.tex` (+ a stale
iter-151 `% NOTE` claiming "retaining 04QM"). Both tags valid; off the active
alg-closed route. A careful blueprint-writer pass should align the label
*and* its verbatim source quote together (aligning the label alone risks a
quote/tag mismatch). Becomes must-fix only if an active route ever consumes
an (S3.*) lemma (it will not under the pivot).

## Do-NOT-retry list (standing)

- **KDM via any prover recipe variation on the current signature** — the
  residual is a research-grade Mathlib gap, not a tactic miss. Analogist
  first.
- **KDM signature inflation as a fix** — disproven at iter-151; the iter-152
  joint `[IsAlgClosed k]`+`[IsDomain B]`+`[CharZero k]` is the correct (and
  final) signature.
- **`Smooth ⇒ IsReduced` / `Smooth ⇒ geometrically reduced` Mathlib grep** —
  confirmed absent multiple times (iter-148); `[IsReduced X]` is carried
  explicitly.

## Reusable pattern landed this iter

**Alg-closed constants collapse + `RingHom.finite_respectsIso.2` iso-transfer**
— see the new KB Proof Pattern entry in `PROJECT_STATUS.md`. Reusable for any
"global sections of a proper geom-irreducible variety over an alg-closed
field = base field" obligation, and the iso-transfer move generalises to any
`Γ(Spec k)`-side ring-hom property that needs to flow to the `k`-side across
`ΓSpecIso`.
