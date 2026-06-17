# Directive: mathlib-analogist-m1b-tactical-iter123

## Task

**Tactical pre-prove consult for the iter-123 M1.b prover lane.**

The iter-123 progress-critic returned CHURNING on the M1 route
(`AlgebraicJacobian/Differentials.lean`, target
`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`, sorry at
`Differentials.lean:304`). Per the stuck-protocol rules, the planner
must respond before another prover round; the primary corrective the
critic named is "mathlib-analogist consult on Lan-functor `map_comp`,
alternatives to `IsLocalization.of_le`'s four-step shape, and
`algebraMap` rewriting APIs."

This dispatch is that corrective. Your task is to surface the
Mathlib-canonical APIs for the three tactical clusters that bloated
the iter-122 prover's Step 0 work to ~15 attempts and would otherwise
bloat the iter-123 prover's Step 1+2+3+4 work.

## Background: what the iter-122 prover learned (technical lessons)

These four lessons came back in the iter-122 task result (verbatim,
abbreviated):

1. **`rw [Functor.map_comp]` fails on
   `((TopCat.Presheaf.pullback _ _).obj _).map (f ≫ g)`** despite the
   pattern being literally present. Workaround: pre-prove
   `hmc : self.map (f ≫ g) = self.map f ≫ self.map g` via
   `Functor.map_comp _ _ _`, then `erw [hmc]` (`erw` succeeds where
   `rw` fails for these unification edge-cases).

2. **`rw [Category.assoc]` similarly fails** under category instance
   metadata noise. Workaround: use `exact Category.assoc _ _ _`
   directly.

3. **`show`/`change` on `algebraMap` doesn't work** even when the
   algebra instance is `appLE_colimAlgebra := φ.hom.toAlgebra` (which
   should make `algebraMap = φ.hom` definitionally). Workaround: route
   the conclusion through `IsUnit ((appLE_colimRingHom f e).hom g)`
   first, then `exact`.

4. **`adj.unit.naturality` produces an equation involving the identity
   functor** `((𝟭 _).obj _)`; use `simpa using` to clean it up.

## What I want from you

### Cluster A — Lan-defined functor rewriting

The colimit ring source is
`A_colim := ((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)`,
which is built via `TopCat.Presheaf.pullback = Lan f.base.op _ ⋙ ...`
(a left-Kan-extension construction). The iter-122 blocker pattern was
"`rw [Functor.map_comp]` on `((pullback _ _).obj _).map (f ≫ g)` fails."

**Find Mathlib's canonical rewriting strategy for this situation.**
Specifically:
- Does Mathlib have a `@[simp]` lemma that rewrites
  `((pullback CommRingCat f.base).obj S.presheaf).map (g₁ ≫ g₂)` to
  the composition `... .map g₁ ≫ ... .map g₂` cleanly (without `erw`)?
  Search e.g. `TopCat.Presheaf.pullback.map_comp` or
  `TopCat.Presheaf.pullback_map_comp`.
- If not, what is Mathlib's recommended tactical workaround (e.g.
  `simp only [Functor.map_comp]`? `conv_lhs => rw [...]`? `rw [show
  ... = ... from ...]`)?
- Are there alternative ways to construct the algebra map
  `Γ(S, U) → A_colim` (currently `appLE_colimRingHom`) that avoid
  the Lan-defined functor entirely (e.g. via direct cocone construction
  + universal property)?

### Cluster B — `IsLocalization.of_le` alternative shapes for Step 1+2+3+4

The blueprint's M1.b plan is the 4-step `IsLocalization.of_le` chain:
build `A_M → A_colim`, build `A_colim → A_M`, verify composites are
identities, conclude. **Find any Mathlib alternative that
`A_colim` can use directly, skipping or simplifying steps:**

- Is there an `IsLocalization` constructor that takes only the
  "every `g ∈ M` is a unit in `A_colim`" hypothesis (Step 0) plus a
  surjectivity / unique-extension hypothesis? E.g.
  `IsLocalization.of_surjective`, `IsLocalization.of_isUnit_isUnique`,
  `IsLocalization.of_existsUnique`? If so, would the proof shape
  shrink from 4 steps to 1 step?
- Does `IsLocalization.atUnits` or
  `IsLocalization.isLocalization_of_isUnit` apply (i.e. is `A_colim`
  morally a localization "trivially" because every element of `M` is
  already a unit, sidestepping the universal-property argument)?
- Are there `Localization.algEquiv`-style constructors that produce
  the desired iso from just "every `g ∈ M` is a unit + every element
  of `A_colim` is `(unit)^{-1} * algebraMap`"?
- The cleanest path may be `IsLocalization.isLocalization_of_algEquiv`
  applied to an explicit equivalence. What's the smallest input shape
  that constructor takes?

### Cluster C — `algebraMap` rewriting after `letI :=  φ.hom.toAlgebra`

When the algebra structure is provided by `letI : Algebra A B :=
φ.hom.toAlgebra`, the goal uses `algebraMap A B` but `change` / `show`
to `φ.hom` fails to unify. The iter-122 workaround was to introduce a
`have h_alg : algebraMap A B g = φ.hom g := rfl` and `rw [h_alg]`.

**Find Mathlib's canonical `algebraMap`-from-`.toAlgebra` simp /
rewrite lemma.** Likely names:
- `RingHom.algebraMap_toAlgebra`
- `Algebra.algebraMap_toAlgebra`
- `(φ.hom.toAlgebra).algebraMap_eq`

If a canonical simp lemma exists, the workaround is unnecessary; if
not, the workaround is the canonical approach.

### Cluster D (informational) — adj.unit.naturality cleanup

The iter-122 lesson 4 says `adj.unit.naturality` emits `((𝟭 _).obj _)`
terms requiring `simpa using` cleanup. Is there a Mathlib lemma that
gives the naturality square *without* the `𝟭` decorations (e.g.
`Adjunction.unit_naturality`, `Adjunction.unit_naturality_apply`)?

## Output format

For each cluster (A/B/C/D), return:
- The canonical Mathlib API name (if it exists), with file path /
  line number.
- A 1-2 line illustrative usage snippet against the iter-122 prover's
  context (the actual subgoals can be approximated from the blueprint's
  Step 1+2+3+4 prose).
- If no clean Mathlib API exists, give the recommended tactical pattern
  the iter-123 prover should use (e.g. "pre-prove + `erw`").
- A verdict per cluster: ALIGN_WITH_MATHLIB (here's the right API),
  NEEDS_MATHLIB_GAP_FILL (this would be a clean Mathlib PR), or
  PROCEED_WITH_WORKAROUND (the iter-122 workaround is the best
  available pattern, document and move on).

## Persistent file

Optional — if the findings reveal a reusable pattern (e.g. "for
Lan-defined functors, always use `simp only [Functor.map_comp]` not
`rw`"), append a section to
`analogies/relative-differentials-presheaf-bridge.md` documenting it
for future iters.

## Strict context discipline

Do NOT consult STRATEGY.md, PROGRESS.md, blueprint chapters, or iter
sidecars. The point of this consult is tactical Mathlib-API discovery,
not strategic re-evaluation. The four lessons above and the cluster
descriptions are all the project-side input you need.
