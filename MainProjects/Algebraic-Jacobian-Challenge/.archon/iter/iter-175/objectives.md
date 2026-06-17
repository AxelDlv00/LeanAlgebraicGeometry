# Iter-175 — detailed prover lane prompts

10 prover lanes total. Composition: 3 body lanes + 7 file-skeleton lanes.

## Lane A1 — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (POST-G0BO-SPLIT)

### Status target

- **COMPLETE** = `gmScalingP1_chart_PLB_eq` Step C `i=0` + `i=1` cases
  closed axiom-clean **AND** `gmScalingP1_chart_agreement` cross cases
  `(0,1)` + `(1,0)` closed axiom-clean.
- **PARTIAL-acceptable** = Step C closed axiom-clean; cross cases left
  for iter-176.
- **PARTIAL-low** = Step C still open OR a new helper substituted for
  Step C (any fresh sorry added at the chart-bridge layer).
- **INCOMPLETE** = no Lane A change to either Step C or cross cases.

**If iter-175 Lane A1 returns PARTIAL-low**, the progress-critic STUCK
trigger re-arms for iter-176, and the iter-176 plan agent MUST execute
a route-pivot decision per `analogies/chart-bridge-structural-pivot.md`
or escalate to user.

### Required reading

- **`analogies/chart-bridge-structural-pivot.md`** (iter-175
  analogist consult; supersedes `chart-bridge-shared-helper.md`) —
  contains the structural-pivot recipe for the Fin syntactic mismatch
  on Step C and the cross-case ring identity for chart_agreement.
- `analogies/chart-bridge.md` (iter-173) — the original 4-step
  pullback bridge that lands `gmScalingP1_chart`.
- `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md` (iter-174
  result; archived to `logs/iter-174/`) — documents Steps A+B of
  `chart_PLB_eq` axiom-clean and the 4 candidate options for closing
  Step C.

### Hard scope discipline

- Attack EXACTLY these 4 sorries: `chart_PLB_eq` Step C `i=0`,
  `chart_PLB_eq` Step C `i=1`, `chart_agreement` `(0,1)`,
  `chart_agreement` `(1,0)`.
- **Authorised to restructure `gmScalingP1_cover_X_iso`** (the private
  helper at the new GmScaling.lean line range) if the analogist
  recommends pulling apart the `match i with | 0 => … | 1 => …` form
  into per-`i` named definitions (per the iter-174 task result option
  3). This is the structural-pivot green-light, NOT scope creep.
- Helper-budget = up to **2 new private lemmas** if the analogist
  recipe explicitly calls for them. Each new helper must close
  axiom-clean — no helper sorries.
- Do NOT attack any of: `gm_grpObj`, `gmScalingP1_collapse_at_zero`,
  `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`,
  `gm_geomIrred`, `projGm_isReduced`. These are all out of scope.

### Verification

- `lake build AlgebraicJacobian.Genus0BaseObjects.GmScaling` exits 0.
- `lean_verify AlgebraicGeometry.gmScalingP1_chart_PLB_eq` returns
  axiom set `{propext, Classical.choice, Quot.sound}` (NO `sorryAx`)
  IFF Step C is closed axiom-clean.
- Same check on `gmScalingP1_chart_agreement`.
- Net file sorry count drops by 4 (8 → 4 if COMPLETE; 8 → 6 if
  PARTIAL-acceptable; 8 → 8 if PARTIAL-low; no change if INCOMPLETE).

## Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean`

### Status target

Subset of the 5 downstream sorries to attack:
- **PRIMARY**: `RelativeSpec` body (L160) — the load-bearing scheme
  constructor.
- **SECONDARY**: `structureMorphism` (L171) — the affine morphism out
  of `RelativeSpec`.
- **TERTIARY**: `affine_base_iff` (L230) — the `IsAffine` consequence
  when the base is affine.

### Required reading

- **`analogies/qcohalgebra-structure.md`** (iter-174 analogist
  consult) — the Encoding I `structure QcohAlgebra` rationale (sheaf
  `O_X`-algebra + unit) and the construction recipe via Mathlib
  `Scheme.GlueData` / `AffineScheme.glueOpens` + Stacks tag
  `lemma-transitive-spec` for the cocycle.

### Hard scope discipline

- Attack at MOST 3 of the 5 downstream sorries (PRIMARY + SECONDARY +
  TERTIARY listed above). Leave `UniversalProperty` (L206) and
  `base_change` (L260) to iter-176.
- Helper-budget = up to **2 new private lemmas** if recipe-aligned.

### Verification

- `lake build AlgebraicJacobian.Picard.RelativeSpec` exits 0.
- `lean_verify` on each attacked declaration returns kernel-only
  axiom set if closed.

## Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

### Status target

- **COMPLETE** = `RationalMap.order` body (L140) closed axiom-clean.
- **PARTIAL** = body filled but with downstream `sorry`s on Mathlib
  bridge gaps (acceptable; the bridge gaps are off-lane).
- **INCOMPLETE** = body still `sorry`.

### Required reading

- **`analogies/dvr-rationalmap-order.md`** (iter-175 analogist
  consult) — concrete body recipe:
  ```lean
  noncomputable def order {X : Scheme.{u}} [IsIntegral X]
      [IsLocallyNoetherian X] (Y : X.PrimeDivisor)
      [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]
      (f : X.functionField) : ℤ :=
    WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)
  ```
- Per analogist Decision 3 (NEEDS_MATHLIB_GAP_FILL), the prover MAY
  refine the signature to thread `[Ring.KrullDimLE 1
  (X.presheaf.stalk Y.point)]` as an explicit typeclass argument on
  `order` and downstream consumers. This is local enough that the
  blueprint pin (`def:order_at_point`) is unaffected and lets
  `Ring.ordFrac` typecheck.

### Hard scope discipline

- Attack ONLY `RationalMap.order` body. Leave `principal`,
  `principal_hom`, `principal_degree_zero` to iter-176 (downstream of
  this iter's body landing).
- Helper-budget = up to **1 new private lemma** for the
  `Order.coheight = 1 → Ring.KrullDimLE 1 (stalk)` bridge if the
  analogist gap-fill is needed.

### Verification

- `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` exits 0.
- `lean_verify AlgebraicGeometry.Scheme.RationalMap.order` returns
  kernel-only axiom set if closed.

## Lane E — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (NEW FILE)

### Status target

- **COMPLETE** = file-skeleton lands. Each `\lean{...}` pinned
  declaration in `blueprint/src/chapters/Picard_FlatteningStratification.tex`
  has a corresponding Lean declaration with substantive (non-tautological)
  type and `sorry` body. Build green.

### Required reading

- `blueprint/src/chapters/Picard_FlatteningStratification.tex`
  (LANDED iter-174) — the chapter contents authorise the
  type signatures.

### Hard scope discipline

- One Lean declaration per `\lean{...}` pin in the chapter.
- Types should be substantive (not `True := trivial`, not
  `X = X`); when Mathlib lacks the predicate (e.g.,
  `IsFlatteningStratification`), encode via `structure`/`def` with
  the carrier components matching the chapter's prose, OR follow the
  iter-173 `QcohAlgebra` / iter-174 `OnProduct` precedent (a typed
  `sorry` at the type level with a clear docstring naming the
  Mathlib-gap reason). Avoid `Type (u+1) := sorry` unless the
  blueprint explicitly authorises it.
- Add a brief docstring on each declaration naming the chapter pin
  and the iter-176+ body-fill prerequisite.
- Place the file at `AlgebraicJacobian/Picard/FlatteningStratification.lean`
  with namespace `AlgebraicGeometry`. Add the `import` to
  `AlgebraicJacobian.lean`.
- Use `import Mathlib` at the file head (matching project pattern for
  scaffold files; tighter imports can come later).

### Verification

- `lake build AlgebraicJacobian.Picard.FlatteningStratification` exits 0.
- Number of `sorry` warnings matches the number of pinned declarations
  in the chapter (one per pin, plus any helpers).
- Each declaration's docstring cites its chapter `\lean{...}` pin.

## Lane F — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (NEW FILE)

### Status target

Same shape as Lane E. **COMPLETE** = chapter pins scaffolded with
substantive types + `sorry` bodies; build green.

### Required reading

- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (LANDED iter-174).

### Hard scope discipline

- Per Lane E.
- A.4.b is "independently startable on Mathlib-import side": the
  scaffold should reference Mathlib's existing depth /
  projective-dimension / regular-local-ring infrastructure
  (`RingTheory.Depth`, `Mathlib.RingTheory.Regular`,
  `Mathlib.RingTheory.Filtration`, etc.) where the chapter cites
  them.

### Verification

- Per Lane E.

## Lane G — `AlgebraicJacobian/Picard/RelPicFunctor.lean` (NEW FILE)

### Status target

Same shape as Lane E.

### Required reading

- `blueprint/src/chapters/Picard_RelPicFunctor.tex` (LANDED iter-174).

### Hard scope discipline

- A.1.c wires A.1.a (`RelativeSpec`) + A.1.b (`LineBundle.Pullback`)
  into the relative Picard presheaf. Reference the iter-174
  `Picard/RelativeSpec.lean` and `Picard/LineBundlePullback.lean`
  scaffolds where the chapter pins names from them.

## Lane H — `AlgebraicJacobian/Picard/QuotScheme.lean` (NEW FILE)

### Status target

Same shape as Lane E. **NOTE**: the chapter is large (Nitsure §5 + a
Grassmannian sub-build). The file-skeleton scaffolds ONLY the
`\lean{...}`-pinned declarations; downstream Grassmannian-specific
sub-pieces are iter-176+ body work.

### Required reading

- `blueprint/src/chapters/Picard_QuotScheme.tex` (LANDED iter-174).

### Hard scope discipline

- Per Lane E.

## Lane I — `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (NEW FILE)

### Status target

Same shape as Lane E. Small assembly chapter — fewer pins expected
(~3–5).

### Required reading

- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` (LANDED iter-174;
  this iter's `blueprint-writer fgapic-empty-uses-fix` closes 2 empty
  `\uses{}` annotations — chapter pins are unaffected).

## Lane J — `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` (NEW FILE)

### Status target

Same shape as Lane E. Small assembly chapter.

### Required reading

- `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` (LANDED iter-174).

## Lane K — `AlgebraicJacobian/RiemannRoch/OCofP.lean` (NEW FILE)

### Status target

Same shape as Lane E.

### Required reading

- `blueprint/src/chapters/RiemannRoch_OCofP.tex` (LANDED iter-174; this
  iter's `blueprint-writer rr-broken-uses-fix` may add a
  `\label{cor:nonconstant_function_genus_zero}` corollary block here —
  scaffold that pin too if it lands).
