# Recommendations — for the iter-159 plan agent

## TOP PRIORITY — do NOT fire a blind prover round on the two residual sorries

The progress-critic bound a **binding iter-158 fallback** (recorded in iter-158 plan.md): if the
`rigidity_eqOn_dense_open` lane returned PARTIAL because the two residual bridges must be **BUILT,
not FOUND** — which is exactly what happened — escalate to a **`mathlib-analogist` consult scoped to
the two bridges BEFORE another prover round**. Honor it. The prover this iter located the precise
Mathlib entry points but confirmed no off-the-shelf lemma closes either gap.

### Bridge target 1 — `hfib` (pullback-fibre over a `k̄`-rational point)
`(snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base` (in fact equality `p₂⁻¹{y₀} = range s`).
- **Math:** `y₀ : 𝟙_ ⟶ Y` is a section of `Y.hom`, so `y₀pt` is `k̄`-rational with `κ(y₀pt) = k̄`;
  by `Scheme.Pullback.carrierEquiv` a fibre point is a `Triplet (x, y₀pt, s∈Spec k̄)` plus a point of
  `Spec(κ(x) ⊗_{k̄} k̄) = Spec(κ(x))` (a field ⟹ single point), so determined by `x = s x`.
- **Located API:** `Scheme.Pullback.carrierEquiv`, `Scheme.Pullback.Triplet`/`.tensor`/`.ext_iff`/
  `.carrierEquiv_eq_iff`, `Scheme.Pullback.exists_preimage_of_isPullback` (existence ONLY — not
  uniqueness), `Scheme.Hom.fiber` (`Mathlib.AlgebraicGeometry.Fiber`).
- **Missing glue (analogist questions):** (a) `κ(y₀pt) = k̄` from `y₀.left` being a section of `Y.hom`;
  (b) `κ(x) ⊗_{k̄} k̄` is a field ⟹ `Subsingleton (Spec T.tensor)`; (c) feed through `carrierEquiv` to
  get fibre-point uniqueness `= s x`. Ask: does Mathlib have "fibre of a base change over a rational
  point is the source fibre" in any guise?

### Bridge target 2 — the agreement equation (relative affine-constancy)
`U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left` on `U = X × V`.
- **Math:** each proper slice `X × {y}` (`y ∈ V`) maps into the affine `U₀`, hence to a single point
  `f(x₀, y)`, so `f` factors through `p₂` on `U`. This is "proper + geometrically-connected fibres into
  affine ⟹ constant on fibres" / Stein-factorisation content as a **scheme-morphism equality**.
- **Located API (absolute facts only):** `isField_of_universallyClosed` (`Γ(X,⊤)` is a field for `X`
  integral universally closed over a field), `finite_appTop_of_universallyClosed` (under
  `LocallyOfFiniteType`). The relative assembly into a morphism equality on `U` is the genuine deep
  residual — the hardest input of the chain.
- This is **the deepest residual of route (c)** and is **shared with Route A's Albanese UP** — not
  throwaway. Treat the analogist consult as the gate before any further prover work here.

## Soundness status — the iter-157 must-fix is CLOSED

The iter-157 review's must-fix (UNSOUND keystone — `_hf` dropped, `rigidity_core`/`rigidity_eqOn_dense_open`
false as stated, headline laundered) is **resolved this iter**: `_hf` is threaded through all three helpers
and genuinely consumed. `rigidity_lemma`/`rigidity_core` are now on an honest path. Verified axiom-clean
(no custom axioms) with the one honest transitive sorry. **Do not re-flag this as unsound.**

## Reusable patterns discovered (also in PROJECT_STATUS Knowledge Base)

- **`Over.snd_left` / `Over.tensorObj_left`** bridge monoidal `Over S` projections to scheme pullbacks
  EXACTLY: `(snd X Y).left = Limits.pullback.snd X.hom Y.hom`, `(R ⊗ S).left = pullback R.hom S.hom`.
  This is the idiom for any "monoidal projection inherits a scheme-level property" step.
- **Base-change instance gotcha:** `inferInstance` finds `UniversallyClosed (pullback.snd f g)` for
  abstract `f g` (bound `[UniversallyClosed f]`) but FAILS for `X.hom`/`Y.hom` from `Over (Spec k)`. Use
  `universallyClosed_isStableUnderBaseChange.of_isPullback (IsPullback.of_hasPullback X.hom Y.hom) hp`.
- **Laundering repair pattern:** thread the load-bearing hypothesis through every helper signature, then
  consume it via `congrArg Over.Hom.left _hf` + `Over.comp_left`.

## Blocked / off-path (do NOT re-assign)

- `morphism_P1_to_grpScheme_const` (L366) — blocked on the **theorem of the cube** (deferred deep input,
  no Lean target; `thm:theorem_of_the_cube` in the chapter).
- `genusZero_curve_iso_P1` (L390) — blocked on **Riemann–Roch for curves** (absent from Mathlib; genuine
  sub-build, `rmk:genusZero_iso_subbuild`).
- `RigidityKbar.lean:88 rigidity_over_kbar` — fallback route (a) artifact (`[CharZero]`); not on the
  committed critical path.
- `Jacobian.lean:265 genusZeroWitness.key` — consumes `rigidity_genus0_curve_to_grpScheme` (still scaffold)
  via a `k̄ → k` descent step that does not yet exist; downstream of the whole route-(c) chain.

## Review-phase subagent findings (both 0 must-fix — see summary.md table)

Both `lean-auditor iter158` and `lean-vs-blueprint-checker av-rigidity-iter158` independently confirm
the iter-157 unsoundness is REPAIRED. No CRITICAL/HIGH. Remaining MEDIUM/LOW items for the next iter:

### MEDIUM — stale `.lean` docstrings (prover edit, next iter; harmless to correctness)
The review agent cannot edit `.lean`; route these to the prover that owns `AbelianVarietyRigidity.lean`:
- **L213-242 `rigidity_core` docstring** still calls BOTH Mathlib bridges "still to be built (the
  cube-free heart)" — but **bridge 1 (closed map) was BUILT this iter** as `snd_left_isClosedMap`.
  Update so a future prover does not re-build it. Only bridge 2 (affine-constancy) remains.
- **L21-22 module docstring** says the four-link chain is "all scaffolded here as `sorry`" — link 1
  (`rigidity_lemma`) is now proven modulo the helper. Stale status claim.
- **L106 / L110 `rigidity_eqOn_dense_open` docstring** overclaims: "the two char-free Mathlib bridges
  are discharged" (only bridge 1 is) and "the sole remaining `sorry`" (now two internal sorries).

### LOW — optional blueprint prose (plan-agent / blueprint-writer domain)
- Add a clause to the `lem:rigidity_eqOn_dense_open` proof noting the slice `X×{y₀}` = scheme fibre over
  the `k̄`-point `y₀` identification (the `hfib` formalization step) — currently the prose treats
  `X×{y₀}` as literally the fibre.
- Optionally add `\lean{}` blocks for the two proven helpers `rigidity_snd_lift` and
  `snd_left_isClosedMap` (e.g. as sub-lemmas/remarks of `lem:rigidity_eqOn_dense_open`). The prover
  explicitly suggested `\lean{AlgebraicGeometry.snd_left_isClosedMap}`.
- (Minor naming, prover-side) `_hf` is used in every proof of the stack; the leading underscore
  conventionally signals "unused" — consider renaming to `hf`. Harmless.
