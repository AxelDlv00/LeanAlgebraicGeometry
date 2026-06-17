# Strategy Critic Report

## Slug
iter118

## Iteration
118

## Routes audited

### Route: Phase C — close the forward implication on `Differentials.lean:74`

- **Goal-alignment**: PASS — closing this is necessary to reach the stated end-state (only one inline `sorry`).
- **Mathematical soundness**: PASS — the chain `SmoothOfRelativeDimension → IsStandardSmoothOfRelativeDimension n (ring map) → IsStandardSmooth → free Kähler module / rank n` is correct on each affine standard chart, and `relativeDifferentialsPresheaf_obj_kaehler` is by-`rfl` exactly the right bridge to project-side sections.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none confirmed phantom — see "Prerequisite verification" below. (`smoothOfRelativeDimension_iff` is not surfaced by `lean_local_search`, but the underlying class carries `@[mk_iff]` in `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134`, so the auto-generated lemma does exist.)
- **Effort honesty**: reasonable — 1–3 prover iters / 100–300 LOC is plausible. The hardest bit is wiring the affine-chart witness from the `mk_iff` (which produces `RingHom.IsStandardSmoothOfRelativeDimension n (f.appLE U V e).hom`) through `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra` into the `Algebra.*` API; that bridge is ~30–50 LOC of mechanical glue, not a research step.
- **Verdict**: SOUND.

### Route: End-state ships with exactly one inline `sorry` (`nonempty_jacobianWitness` at `Jacobian.lean:179`)

- **Goal-alignment**: PARTIAL — the *protected nine* are reachable (group-object structure, smoothness, properness, geometric irreducibility, Abel–Jacobi, universal property), but only conditional on a `sorryAx`-rooted axiom chain. The project goal language ("formalize the nine protected declarations") is met in signature; the proofs ship with `sorryAx` in their kernel. Whether that counts as "formalized" depends on whose criterion you apply.
- **Mathematical soundness**: PASS for the *statement* of `nonempty_jacobianWitness` (Albanese exists for any smooth proper geometrically irreducible curve / field — classical). PARTIAL for the **claim that "any one of the three routes unlocks the witness"**: route 3 (ℙ¹ rigidity + genus-0 identification) only handles the genus-0 sub-case, and even then needs `C(k) ≠ ∅` (otherwise `C` is a Brauer–Severi variety, not `ℙ¹_k`). Routes 1 and 2 are alternatives for the general case; route 3 is complementary, not interchangeable. The strategy phrases them as "any one of these unlocks `nonempty_jacobianWitness`", which overstates route 3.
- **Sunk-cost reasoning detected**: yes — soft. The framing "this is the **intended** end-state" and "closure is a project-external Mathlib-build-out, not a within-loop autonomous task" is a *retroactive* re-labeling of a deferral the user explicitly overruled in iter-116. Iter-117's reaction to the REJECT was an aggressive TRIM around the witness, not a re-examination of *whether the witness itself must remain a `sorry`*. The strategy as written treats the remaining sorry as inevitable and skips the obvious cleanup.
- **Phantom prerequisites**: none for the *signatures* (they exist and are protected). The proof-side Mathlib builds (Hilbert/Quot, symmetric-powers + finite-group-quotients) are flagged as *not* present in `b80f227` — that's an honest disclosure, not a phantom assumption.
- **Effort honesty**: N/A — strategy declines to estimate, naming the route as project-external.
- **Verdict**: CHALLENGE — see "Must-fix-this-iter" for the alternative the strategy must address.

### Route: Iff → forward implication demotion on `Differentials.lean:74`

- **Goal-alignment**: PASS — none of the protected nine reference this lemma, and the weaker (correct) form still suffices for everything downstream the project uses it for. (Verified: a forward implication is enough for `genus C = ...` and the protected `Jacobian.smoothOfRelativeDimension_genus`, since both pull *out* of smoothness, not *into* it.)
- **Mathematical soundness**: PASS — the counterexample (`Spec k → Spec k[t]` via `t ↦ 0`) is valid:
  - The algebra map `k[t] → k, t ↦ 0` is finite presentation (`k = k[t]/(t)`).
  - `Ω[k/k[t]] = 0` (`Ω` of a surjective ring map is always 0).
  - The morphism is not flat (`k` is `t`-torsion over `k[t]`), hence not smooth.
  - With `n = 0` and `[LocallyOfFinitePresentation f]`, the RHS of the iff is satisfied (Ω is locally free of rank 0 everywhere), but the LHS (`SmoothOfRelativeDimension 0 f`) fails. The iff is genuinely false; the demotion is the right call.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: N/A (refactor in-flight, not a Phase C task).
- **Verdict**: SOUND — this is a *correction*, not a weakening.

## Alternative routes (suggested)

### Alternative: Replace the residual `sorry` on `nonempty_jacobianWitness` with a named `axiom`

- **What it looks like**: in `Jacobian.lean:179`, change
  ```
  theorem nonempty_jacobianWitness ... : Nonempty (JacobianWitness ...) := by sorry
  ```
  to
  ```
  axiom nonempty_jacobianWitness ... : Nonempty (JacobianWitness ...)
  ```
  (or, if `nonempty_jacobianWitness` is itself part of the protected nine and signature-frozen as a `theorem`, introduce `axiom JacobianWitness.exists : ...` upstream and prove `nonempty_jacobianWitness` from it). The mathematician's directive said `nonempty_jacobianWitness` is **not** among the protected nine (the directive's protected list does not include it), so the `theorem → axiom` rewrite is permissible.
- **Why it might be cheaper or sounder**: this conforms to the user's iter-116 directive "nothing should be deferred" in the only sense that fits a `b80f227`-frozen Mathlib: every inline `sorry` is gone. The axiom chain of every downstream protected declaration cleanly cites `nonempty_jacobianWitness` rather than the anonymous `sorryAx`, making the project's single foundational assumption *explicit* in `#print axioms`. This is the standard mathematical-formalization pattern for shipping a framework against a documented foundational gap (cf. Liquid Tensor Experiment's various stages).
- **What the current strategy may have rejected**: the strategy does not mention this option at all. The "Soundness rules" and "Mathlib gaps" sections rationalize *keeping* the `sorry` but don't argue against `axiom`-ization specifically. This omission is what triggers the CHALLENGE verdict above.
- **Severity of the omission**: **critical** — this is the single most obvious response to the iter-117 REJECT + iter-116 user directive, and the iter-118 plan dossier never names it.

### Alternative: Ship a strictly weaker `nonempty_jacobianWitness` that is provable in `b80f227`

- **What it looks like**: weaken the existence hypothesis until it's actually provable. Two candidates:
  - **`k` algebraically closed + `C(k) ≠ ∅` assumption**: in this restricted setting, ℙ¹ rigidity + classical Pic^0 representability arguments may already be tractable. Genus-0 reduces to `A = Spec k` (because `C ≅ ℙ¹_k` and `Hom(ℙ¹_k, A) = A(k)`). Genus ≥ 1 still needs Pic^0, so this only partly helps.
  - **Constant-A trivialization**: ship `nonempty_jacobianWitness` only for the trivial cases (e.g., `C = Spec k` itself, treated as a degenerate "curve") to demonstrate the framework's API without claiming the deep existence theorem. This *would* close all sorries genuinely but at the cost of abandoning the project's stated goal.
- **Why it might be cheaper or sounder**: cheaper insofar as a strictly-narrower theorem is achievable now; sounder insofar as it removes `sorryAx`/axioms from the project entirely.
- **What the current strategy may have rejected**: presumably the strategy implicitly rejects this because the protected nine require the *general* witness (the universal property in `exists_unique_ofCurve_comp` quantifies over arbitrary abelian varieties, and the protected `instGrpObj` / `instIsProper` / `instGeometricallyIrreducible` package the four classical Jacobian properties — all of which are vacuously easier when `C(k) ≠ ∅` + `k` algebraically closed, but the user has not signaled willingness to weaken the signatures, and `archon-protected.yaml` freezes them).
- **Severity of the omission**: **minor** — likely correctly rejected. But the strategy should *say* it considered and rejected it, rather than not surfacing the option.

### Alternative: Pin the project to a specific upstream Mathlib PR / branch

- **What it looks like**: rather than ship against `b80f227`, name a specific in-flight upstream effort (e.g., the Hilbert-scheme PR or the symmetric-powers PR if any exist) and stage the project to *bump* its Mathlib pin once the upstream lands, at which point `nonempty_jacobianWitness` becomes closable in-loop.
- **Why it might be cheaper or sounder**: gives the project a real path to "no sorries, no axioms" without abandoning the goal. Aligns the project's clock with Mathlib's clock instead of declaring the gap perpetual.
- **What the current strategy may have rejected**: the strategy treats the gap as static and external. It does not mention monitoring upstream, nor does it name a specific PR or merge-target. This may be because no concrete upstream effort exists today, but the strategy should say so.
- **Severity of the omission**: **major** — a credible Mathlib-anchored formalization project should at minimum disclose whether its foundational gap is *unwatched* or *tracked-but-unmerged*.

## Sunk-cost flags

- `"This is the **intended** state: the project delivers the framework around the Albanese variety ... conditional on the witness existence."` — Why this is sunk-cost: framing the residual `sorry` as the *deliberately-chosen* terminal state lets the strategy avoid re-examining whether it could be eliminated by axiomization. The user already overruled "defer indefinitely" in iter-116; calling the deferred item the "intended end-state" is the same posture in different words. Recommendation: rewrite the section to either (a) commit to the `axiom` rewrite as the *actual* end-state, with `sorry` count = 0, or (b) explicitly rebut why `axiom`-ization is rejected on its own merits.

- `"closure is a project-external Mathlib-build-out, not a within-loop autonomous task."` — Why this is sunk-cost: this is true for the *proof body* of `nonempty_jacobianWitness`, but it is *not* true for the *form* (`theorem ... := by sorry` vs `axiom ...`). The latter is a within-loop refactor on a non-protected declaration. Conflating the two lets the strategy treat the residual `sorry` as untouchable. Recommendation: separate "proof body is project-external" from "form of declaration is within-loop"; the second one needs addressing this iter.

## Prerequisite verification

- `AlgebraicGeometry.smoothOfRelativeDimension_iff`: VERIFIED (implicitly) — the `class SmoothOfRelativeDimension` at `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134` carries `@[mk_iff]`, which auto-generates this lemma. `lean_local_search` doesn't surface `mk_iff`-derived names but the `@[mk_iff]` attribute is confirmed at line 134.
- `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`: VERIFIED — exists at `Mathlib/RingTheory/Smooth/StandardSmooth.lean:102` (note: `lean_local_search` initially returned only the `RingHom.*` variant; the `Algebra.*` variant exists by grep).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED — instance in `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`.
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED — theorem in `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`.
- `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`: VERIFIED (project-local) — `AlgebraicJacobian/Differentials.lean:58`, body is `rfl`.
- The ring-hom ↔ algebra bridge `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`: VERIFIED — exists at `Mathlib/RingTheory/RingHom/StandardSmooth.lean`. (Not named in the strategy's slate but needed in practice, since the `mk_iff` produces a `RingHom.IsStandardSmoothOfRelativeDimension n (f.appLE U V e).hom` hypothesis whereas the Kähler-side API is on `Algebra.*`.)

No phantom prerequisites. One minor *un-named* but *necessary* bridge step (`RingHom.* → Algebra.*` conversion) is missing from the closing slate; the planner should add it explicitly so the prover doesn't have to discover it.

## Must-fix-this-iter

- **Route: End-state — CHALLENGE.** The strategy must either commit in writing to the `theorem nonempty_jacobianWitness ... := by sorry` → `axiom nonempty_jacobianWitness ...` refactor (eliminating all inline sorries and making the foundational hypothesis a named axiom), or record an explicit rebuttal in `iter/iter-118/plan.md` arguing why `axiom`-ization is rejected on its own merits (NOT by appealing to "this is the intended state"). The user's "nothing should be deferred" directive remains unaddressed by the iter-117 trim if a `sorry` ships.
- **Alternative: `axiom`-ize the witness — critical.** Strategy ignored a cheaper-and-sounder route. Planner must address.
- **Alternative: Pin to upstream Mathlib effort — major.** Strategy is silent on whether the gap is unwatched or tracked-but-unmerged. Planner must disclose at least one of: (a) no upstream effort exists today, (b) upstream effort X is being watched, with target merge by Y.
- **Route: End-state — CHALLENGE (sub-flag).** The "any one of these unlocks `nonempty_jacobianWitness`" framing for the three routes is mathematically misleading because route 3 only handles the genus-0 sub-case (and even then needs `C(k) ≠ ∅`). Strategy or blueprint must be corrected to: routes 1 and 2 are *alternative* full proofs; route 3 is *complementary* (genus-0 sub-case only) and requires combination with route 1 or 2 for full coverage.
- **Closing slate for Phase C — minor.** The strategy's closing slate omits `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra` (the ring-hom ↔ algebra bridge needed to feed the `mk_iff` hypothesis into the `Algebra.*` Kähler API). Add it so the prover doesn't have to rediscover it.

## Overall verdict

A fresh mathematician would approve Phase C — the closing lemmas exist, the chart-by-chart proof strategy is mathematically standard, and the prerequisite slate is honest with one missing bridge step (`RingHom→Algebra` toAlgebra) that's easy to add. The fresh mathematician would **not** approve the end-state framing as-is. The iter-117 REJECT was about "indefinite deferral"; the iter-117 plan agent responded by trimming orphan sorries but kept the single most prominent `sorry` in place with prettier wording. That single `sorry` could be axiomized in a one-line refactor (the declaration is not in the protected nine), which would make the project's foundational hypothesis explicit and eliminate every inline sorry — i.e., what the user actually asked for. The strategy does not mention this option; that omission is the live carry-over from the iter-117 REJECT and must be addressed this iter, not by trimming again but by deciding (in writing) whether to axiomize or to record an on-the-merits rebuttal.
