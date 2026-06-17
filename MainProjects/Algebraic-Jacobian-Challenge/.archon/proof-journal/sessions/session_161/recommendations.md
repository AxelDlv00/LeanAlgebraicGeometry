# Recommendations for the next plan iter (post-iter-161)

## HIGH — next prover target (the chain's lone deep residual)
**`rigidity_eqAt_closedPoint_of_proper_into_affine` (Step-1 geometric assembly, AVR L204, sorry
L263).** The algebraic heart is DONE (`eq_comp_of_isAffine_of_properIntegral`, axiom-clean) and the
body is reduced to the clean `k̄`-point equation `q ≫ f.left = q ≫ retract.left ≫ f.left`. The
remaining work is the *geometric* slice/section assembly. Decompose into:
1. **`IsIntegral X.left` (the one genuine blocker)** — extract as a new named ~0.3–0.5-iter helper.
   `X.left` is a retract of the integral `(X⊗Y).left` via `(s, p₁)`, `s ≫ p₁ = 𝟙`: irreducible
   (continuous retract of irreducible) + reduced (split injection `p₁* : O_X ↪ O_{X⊗Y}` into a
   reduced ring, `isReduced_of_injective` exists). No packaged Mathlib "retract of integral scheme
   is integral" — must be built.
2. The section `ŷ := Over.homMk` from `ysec := q ≫ (snd X Y).left` (section of `Y.hom` by
   `Over.w (snd X Y)` + `hqsec`), then `s := lift (𝟙 X) (toUnit X ≫ ŷ)`.
3. Corestrict `(s ≫ f).left` to `U₀.toScheme` via `IsOpenImmersion.lift` (range bound from `_hfU`
   + saturation `_hUV`); apply `eq_comp_of_isAffine_of_properIntegral` to the two `k̄`-points
   `q ≫ p₁` and `x₀.left`.
4. Two pullback-`hom_ext` identities `q = (q ≫ p₁) ≫ s` and `retract.left ∘ q = x₀.left ≫ s` —
   mirror the existing `hfib` proof in `rigidity_eqOn_dense_open` (`Over.snd_left`/`fst_left`,
   `lift_fst`/`lift_snd`, `Over.w`, `(toUnit X).left = X.hom`).
- **This is route B (cohomology-free); the relative Stein / `f_*𝒪=𝒪` framing remains a confirmed
  Mathlib gap and is OFF-LIMITS.** Reversal signal: if Step 1 genuinely needs proper-pushforward,
  `analogies/rigidity-affineconst.md` is wrong → fresh analogist consult before another prover round.

## MEDIUM — blueprint-writer (HARD-GATE-relevant for the next AVR prover round)
The `lean-vs-blueprint-checker` major: add a `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}`
lemma node ("proper integral l.f.t. `k̄`-scheme into affine is constant on `k̄`-points") to
`AbelianVarietyRigidity.tex` and wire `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`'s proof
`\uses{}` to it. Documentary gap only (NOT a laundering vector — the proven helper is invisible to
the dep graph). A `% NOTE:` already flags the exact TODO in the chapter (this review). After the
writer lands it, re-run the scoped blueprint-reviewer fast-path to confirm before the prover round.

## MEDIUM — Lean docstring fix (prover/refactor domain, NOT a review-agent edit)
The `lean-auditor` major: `rigidity_eqOn_saturated_open_to_affine`'s docstring (AVR L276-278) still
calls the lemma a `sorry`-bodied "named top-level obligation" — it is now **assembled** (Step 2 over
Step 1) and `sorry`-free in its own body. The docstring UNDER-states the proof status. The prover
that next touches AVR should refresh it to "assembled from Step 2 over the per-slice Step 1;
transitively depends on Step 1's residual `sorry`." Minor companions: stale "(iter-160)" status tag
at L201 → bump to iter-161; prose drift L289-292 (`ext_of_isDominant_of_isSeparated'` vs the realised
`morphism_eq_of_eqAt_closedPoints`).

## SCHEDULED (not firing this iter) — OVER_BUDGET re-estimate
progress-critic set **iter-162** as the trigger: if the iter again advances only the Rigidity chain
while the theorem of the cube + Riemann–Roch stay unstarted, re-estimate the `~10–18` full-arm cell
and begin blueprinting the theorem of the cube. The cube/RR scaffolds (AVR L663/L687/L712 +
`Jacobian.lean`) remain entirely unstarted.

## Do NOT retry
- Proving the chain at the *old* signature (without `[LocallyOfFiniteType (X⊗Y).hom]`) — it is
  impossible-as-typed; the iter-161 refactor threaded the instance and this is now settled.
- The relative Stein / `f_*𝒪=𝒪` route for Step 1 — confirmed Mathlib gap, off-limits.

## Reusable patterns discovered
- **"Global function on proper integral `k̄`-variety is constant", cohomology-free**:
  `isField_of_universallyClosed` + `isIntegral_appTop_of_universallyClosed` +
  `IsAlgClosed.ringHom_bijective_of_isIntegral` ⟹ `wk.appTop` iso ⟹ `cancel_epi` on sections ⟹
  `ext_of_isAffine`. Packaged as `eq_comp_of_isAffine_of_properIntegral`.
- **Closed point of l.f.t. `k̄`-scheme ⇒ `k̄`-rational point**:
  `Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean` — `pointOfClosedPoint`, `residueFieldIsoBase`,
  `pointOfClosedPoint_comp`. Cancel the residue-field iso with `rw [← cancel_epi (Spec.map
  (residueFieldIsoBase …).hom)]` to reduce a residue-field-probe goal to a `k̄`-point goal.
- **`JacobsonSpace` on an open subscheme of an l.f.t. `k̄`-scheme**:
  `LocallyOfFiniteType.jacobsonSpace` + `JacobsonSpace.of_isOpenEmbedding U.ι.isOpenEmbedding`.
