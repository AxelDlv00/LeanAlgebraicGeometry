# Recommendations for the next plan-agent iteration (iter-138)

Iter-137 was a docstring-only PARTIAL session on `_basechange_along_proj_two`
(Step 2 of piece (i.b)). Sorry count unchanged at 5. The prover's
analysis produced a concrete, validated-as-compilable iter-138+
closure-path skeleton that the iter-138 plan agent should consume
directly.

## HIGH — primary actions for iter-138

### HIGH-A. Build the `PresheafOfModules.pullback` chart-unfolding helper FIRST, then re-attempt Step 2

The iter-137 PARTIAL diagnosed the root blocker precisely: the
analogist's 5-step recipe (`analogies/kaehler-tensorequiv-presheafpullback.md`)
hits a load-bearing gap at Step 2 because `PresheafOfModules.pullback`
is defined as `(pushforward φ).leftAdjoint` and is OPAQUE on
`.obj`/`.map`. The prover named the helper signature precisely
(`task_results/Cotangent_GrpObj.lean.md` § "Concrete next step (iter-138+)"):

```lean
-- For φ : S ⟶ F.op ⋙ R, M : PresheafOfModules S, V : Dᵒᵖ
noncomputable def pullbackObjEquivTensor
    {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₂} D]
    {F : C ⥤ D} {R : Dᵒᵖ ⥤ RingCat.{u}} {S : Cᵒᵖ ⥤ RingCat.{u}} (φ : S ⟶ F.op ⋙ R)
    [(PresheafOfModules.pushforward.{v} φ).IsRightAdjoint]
    (M : PresheafOfModules.{v} S) (V : Dᵒᵖ) :
    ((PresheafOfModules.pullback φ).obj M).obj V ≃ₗ[R.obj V]
      TensorProduct ((F.op ⋙ S).obj V) (R.obj V) (M.obj (F.op.obj V)) := ...
```

**Recommended iter-138 lane shape**:

1. **Pre-dispatch a `mathlib-analogist` consult** on
   `PresheafOfModules.pullback` chart-unfolding (validates the helper
   signature via `lean_run_code`, confirms Mathlib's
   `pullbackPushforwardAdjunction` unit/counit are the right building
   blocks, suggests host file). Persistent file under `analogies/`.
2. **Prover lane** on the helper itself (~30–60 LOC) — plausible host:
   new file `AlgebraicJacobian/PresheafOfModulesPullback.lean`, OR
   append to `AlgebraicJacobian/Differentials.lean`, OR top of
   `Cotangent/GrpObj.lean` (analogist's expected location). The
   per-file host choice goes through the iter-138 plan agent's
   refactor lane if a new file.
3. **Conditional Wave-3 prover lane** on Step 2 itself
   (`_basechange_along_proj_two`) using the helper. Only fires if the
   helper landed in Wave-2.

If the helper lane takes a full iter, the Step 2 lane slides to
iter-139.

### HIGH-B. Alternative fast-path consideration: adopt iter-137 Attempt 2's inverse-only skeleton

The iter-137 prover validated the inverse-direction-via-adjunction-
transpose route as compiling-typeable (per
`task_results/Cotangent_GrpObj.lean.md` § "Attempt 2"). The skeleton
is in the file's L479–499 docstring and in the task_result. Fast-path
shape: ship the inverse-direction definition (with the inner
derivation `D := sorry`, ~+1 sorry), then prove the inverse is iso
(via `PresheafOfModules.epi_iff_locally_surjective`-style local
checks, OR construct the forward direction by some other means and
apply `isIso_of_isInverse`).

**Trade-off**: this route adds ~100–200 LOC for the derivation
construction (Leibniz + `d_app` pointwise verifications) and an
iso-from-inverse argument; the HIGH-A route adds the ~30–60 LOC
helper as separate infrastructure. The HIGH-A path is more aligned
with the analogist's prescribed 5-step recipe and the blueprint's
chart-by-chart prose; HIGH-B is a hedge. **Plan agent verdict
recommended**: HIGH-A first, HIGH-B as iter-139+ fallback if HIGH-A
stalls.

### HIGH-C. Blueprint-writer dispatch on `RigidityKbar.tex` § `lem:GrpObj_omega_basechange_proj` proof (L471–480)

Per `lean-vs-blueprint-checker-cotangent-grpobj-review137` MINOR #1:
the blueprint's chart-by-chart recipe does not anticipate the iter-137-
surfaced `PresheafOfModules.pullback` chart-opacity blocker. Add a
`% NOTE iter-137:` block (or expanded prose) acknowledging the
chart-opacity gap and documenting both alternative routes (the
HIGH-A chart-unfolding-helper route and the HIGH-B inverse-direction-
via-adjunction-transpose route). The Lean docstring at L479–L499 is a
sufficient interim record per the checker's own assessment, so this is
**minor severity, not blocking**. Bundle with HIGH-A's plan-phase
analogist consult.

## MED — secondary actions for iter-138

### MED-A. Carry-over: 6 minor cosmetic/docstring-staleness items (lean-auditor-review137)

From `lean-auditor-review137.md` § Minor:

1. `Cohomology/MayerVietorisCore.lean:168` — stale forward-reference
   to iter-018/iter-019 which have long closed in-file.
2. `Cohomology/StructureSheafModuleK.lean` (L737, L749–750, L781,
   L803) — stale forward-references to iter-013/iter-048 work that
   has long landed in `MayerVietorisCover.lean`.
3. `Cohomology/MayerVietorisCore.lean:438` — line length 117.
4. `AbelJacobi.lean:22`, `:59` — line length 111, 101.
5. `Cotangent/GrpObj.lean:274`, `:285` — line length 111, 104.
6. `Jacobian.lean:110`, `:119` — line length 107, 107
   (L275 is protected, do not touch).

**Plan-agent verdict recommended**: DEFER. These accumulate per iter
and a small refactor pass can bundle them whenever a writer is being
dispatched to an adjacent area anyway. Not blocking.

### MED-B. Carry-over: file-header line-anchor refresh in `Cotangent/GrpObj.lean`

L61/L107/L146/L155/L160 carry stale "line 198/244 below" references
(iter-135 carry-over, extended by ~+12 iter-136 + ~+20–25 iter-137).
**Plan-agent verdict recommended**: DEFER until iter-138's Step 2
work stabilises the file's line numbers (either by closing Step 2
substantively or by failing it again and pivoting). A pre-emptive
refresh now would just need re-refreshing post iter-138 lane.

### MED-C. `_basechange_along_proj_two` signature over-constraint (lean-vs-blueprint-checker-cotangent-grpobj-review137 minor #2)

The Lean signature at `Cotangent/GrpObj.lean:502–503` carries
`{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
[GeometricallyIrreducible G.hom]` which the mathematical statement
does not require. **Plan-agent verdict recommended**: DEFER. The
binders match the consumer's context; refactoring them out is a
1-LOC change and not blocking iter-138 Step 2 closure. Address
opportunistically when the body lands and the signature is the
focus of attention.

### MED-D. `schemeHomRingCompatibility` blueprint coverage (lean-vs-blueprint-checker-cotangent-grpobj-review137 minor #3)

Promote `schemeHomRingCompatibility` (Lean `Cotangent/GrpObj.lean:423`)
to a dedicated `\lean{...}` block in `RigidityKbar.tex` under piece
(i.b). Currently it's listed only in the pointer chapter's itemize.
**Plan-agent verdict recommended**: DEFER. Coverage cleanup,
bundle with HIGH-C's blueprint-writer dispatch.

## DO-NOT-RETRY (blocked / closed)

These targets must NOT be assigned to a prover this iter.

- **`Cotangent/GrpObj.lean:635 mulRight_globalises_cotangent`** — Main
  lemma; gated on Step 2 closure. Iter-138 schedule depends on Step 2
  outcome: if iter-138 closes Step 2, Main becomes iter-139 target;
  if iter-138 returns PARTIAL on Step 2, Main slides to iter-140+.
  Per the iter-137 prover task result, Main is ~20–40 LOC composition
  of Steps 1+2+3 — the **cheapest** piece once Step 2 lands. **Do
  not retry before Step 2 closes substantively**.
- **`Jacobian.lean:197 genusZeroWitness`** — M2.b scaffold; gated on
  M2.a body close + terminal-object instances. Iter-151+ at earliest.
- **`Jacobian.lean:223 positiveGenusWitness`** — M3 scaffold,
  user-escalation-gated, off critical path per
  `analogies/m3-route-audit.md`.
- **`RigidityKbar.lean:87 rigidity_over_kbar`** — gated on shared
  cotangent-vanishing pile (i) + (ii) + (iii). Iter-151+ at earliest.

## Reusable proof patterns / strategic insights from iter-137

- **`PresheafOfModules.pullback` is OPAQUE on `.obj`/`.map`** (defined
  as `(pushforward φ).leftAdjoint`). Any construction needing
  `((pullback φ).obj M).obj V` concretely must either (a) build a
  `pullbackObjEquivTensor` chart-unfolding helper first (~30–60 LOC,
  goes through `pullbackPushforwardAdjunction` unit/counit), or
  (b) bypass via the adjunction transpose to land on
  `(pushforward φ).obj`, which IS transparent (`pushforward =
  pushforward₀ ⋙ restrictScalars`, both `@[simps]`-tagged). New
  Knowledge-Base entry candidate.
- **The PARTIAL escape hatch's "ship inverse-only with +1 sorry"
  trade-off**: a future PARTIAL with `lean_run_code`-validated
  skeleton but +1 sorry incurs may be the right call when the
  validated route reduces the closure to a single concrete sub-goal
  (not multiple), and the sub-goal is itself iter-N+1 tractable.
  Iter-137 honored the PARTIAL ceiling, but the recorded skeleton is
  ready to consume next iter. **Trade-off worth re-evaluating** if
  PARTIAL ceilings get tighter — the alternative is shipping nothing
  and re-discovering the sub-goal scope from scratch.

## Strategic guidance — do NOT retry the same approach without escalation

The iter-137 attempt of the analogist's full 5-step recipe FAILED
because the recipe presupposed a chart-unfolding helper that doesn't
yet exist. **Do NOT** re-dispatch the iter-137 prover lane unchanged.
The iter-138 dispatch MUST either:

- (a) build the chart-unfolding helper as a separate prover lane FIRST
  (HIGH-A path), OR
- (b) adopt the inverse-only adjunction-transpose skeleton with the
  +1 sorry trade-off (HIGH-B path; this is the explicit escape valve
  if HIGH-A is over-budget).

Re-dispatching the unchanged 5-step recipe would be a churn-shaped
iter and would trip the iter-138 progress-critic's CHURNING criterion
on Route 4.
