# iter-188 — Recommendations for next plan agent

## CRITICAL (HARD GATE re-confirmations — these are the iter-188 entry condition)

### −1. Mandatory `blueprint-reviewer iter188` re-confirms iter-187 writer fixes

Three lanes were deferred iter-187 per HARD GATE pending writer fixes that LANDED iter-187 plan-phase:

| Chapter | Writer slug | Affected lane |
|---|---|---|
| `RiemannRoch_RRFormula.tex` | `rrformula-h0h1split` | Lane H |
| `AbelianVarietyRigidity.tex` | `avr-iiic-pivot-label` | Lane B (and E by deferral chain) |

iter-188's mandatory `blueprint-reviewer iter188` must clear those two chapters on the HARD GATE (`complete: true` AND `correct: true` AND no must-fix). On clearance, Lanes B + E + H prover dispatches resume.

If the reviewer flags either chapter as PARTIAL again, the same deferral logic applies — do NOT shortcut.

### 0. Mandatory `progress-critic iter188` verifies iter-187 correctives moved needle

Key trajectory verifications:

- **Lane A OCofP**: 7 → 4 (−3 closures). CHURNING → CONVERGING transition. iter-188 cascade target: `carrierPresheaf_isSheaf` body (sheafForget bridge, ~30 LOC) — close to take Lane A to 3 sorries.
- **Lane I RationalCurveIso**: STUCK → CONVERGING. iter-188 follow-up: `localParameterAtInfty` body (~30-50 LOC; 4-step recipe documented).
- **Lane F QuotScheme**: CHURNING → ??? — depends on whether iter-188 closes the analogist-recommended section-level linearEquiv assembly. iter-187 added 2 substantive named sorries per the recipe; iter-188 prover assembles.
- **Lane G AuslanderBuchsbaum**: CHURNING (G1 sub-lane); spanFinrank-dim-drop body iter-188.
- **Lane J OcOfD**: BLOCKED structurally. **DO NOT re-dispatch without a strategy decision** widening to `sheafOf` body (off-target ~100-200 LOC).

## HIGH (closest-to-completion targets to prioritize)

### 1. Lane A.1.b LineBundlePullback — close `IsLocallyTrivial.pullback` chart-iso

Lane A.1.b is 4/5 axiom-clean. The 1 named typed sorry at L156 needs the `restrictFunctorIsoPullback` + `pullbackComp` + `pullbackObjUnitToUnit` composition to assemble the chart-iso. The affine-chart existence step is already closed. **Likely closure in iter-188 (~30-50 LOC)**.

### 2. Lane A OCofP — close `carrierPresheaf_isSheaf` body

Refactor Step 4's narrow named typed sorry. The sheaf condition reduces via `isSheaf_iff_isSheaf_forget` to a Set-level check. Mathlib substrate present; ~30 LOC axiom-clean within reach.

### 3. Lane I RationalCurveIso — close `localParameterAtInfty`

Substrate gap from Hom.poleDivisor body. 4-step recipe documented in helper's docstring:
1. Pick chart-1 affine open from `AlgebraicGeometry.projectiveLineBarAffineCover`.
2. Construct `X₀ / X₁ ∈ HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X 1)`.
3. Embed via `germToFunctionField` on the chart open.
4. Non-zero witness via `germ_injective_of_isIntegral`.

Then re-attack `Hom.poleDivisor_degree_eq_finrank` (was BLOCKED by circular dep — now unblocked).

### 4. Lane H RRFormula — H⁰ half axiom-clean (post-reviewer clearance)

iter-187 writer `rrformula-h0h1split` provides the H⁰/H¹ split + sub-helper pins. iter-188 prover (post-clearance) closes H⁰ half via `constantSheafGammaHom_linearEquiv` chain (~30-60 LOC axiom-clean).

### 5. Lane G sub-lane G1 — close spanFinrank-dim-drop equation

iter-187 reduced κ-finrank to spanFinrank. iter-188 closes the spanFinrank equation:
- (≥) direction: lift-and-cons strategy (preservation under quotient).
- (≤) direction: cotangent-quotient kernel via `Ideal.mapCotangent_ker_of_surjective`.

~100-150 LOC. Mathlib substrate fully present at b80f227 per iter-187 search log.

## MEDIUM (promising approaches needing more work)

### 6. Lane F QuotScheme — assemble section-level linearEquiv

Per iter-187 prover task result: `IsBaseChange.ofEquiv` requires `f = e.toLinearMap`. iter-188 stitches `pullback_tildeIso` to a section-level linearEquiv via `hV.isoSpec` / `hU.isoSpec` + `tilde.isoTop`, then applies the transport. Helper budget = 2 (the linearEquiv + the intertwining verification). The `pullback_tildeIso` body itself (Stacks 01HQ, ~115-200 LOC) stays deferred until the IsBaseChange assembly is complete.

### 7. Lane E AVR — execute 6-step appTop recipe (post-reviewer clearance)

iter-187 plan-phase deferred Lane E semaphore-conservatively. The 6-step recipe (per iter-186 progress-critic corrective) is `r_1_appTop_isLocElem_eq_one` helper via `cancel_mono` on `Proj.awayι` + `IsOpenImmersion.lift_appTop` chain, then telescope simp. **Helper budget = 1**. Execute exactly; if it fails, surface as new information.

### 8. Lane B GmScaling — path III.c separated-locus (post-reviewer clearance)

Per iter-187 plan-phase: III.a/III.b descoped; III.c is the committed alternative (extend `𝔸¹ → A` via valuative criterion then constancy argument). iter-187 writer landed expanded recipe. iter-188 prover executes.

### 9. Lane IdentityComponent — `identityComponent_locallyConnectedSpace` axiom-clean

EGA I 6.1.9 (4-step classical argument): `LocallyOfFiniteType.isLocallyNoetherian` → `IsLocallyNoetherian.NoetherianSpace` → finite irreducible/connected components → each clopen → `LocallyConnectedSpace.mk` basis form. ~80-100 LOC. Mathlib upstream candidate. Unlocks `identityComponentCarrier` and the closed-half of `isOpenSubgroupScheme`.

## LOW / ongoing

### 10. Lane M↓ CodimOneExtension — strategy commit on Stacks 00TT path

The `isRegularLocalRing_stalk_of_smooth` typed sorry is structurally correct but unbounded in iters. Two paths to commit on:
- **(a) Wait for Mathlib upstream** of the Smooth → IsRegularLocalRing bridge (parallel multi-week, outside loop control).
- **(b) Project formalisation** via cotangent-complex (`Algebra.FormallySmooth.iff_injective_cotangentComplexBaseChange` + `IsRegularLocalRing.iff_finrank_cotangentSpace`, ~200-300 LOC).

If a decision is wanted iter-188, this is on the same scale as Lane G Option 2; STRATEGY.md row should be added or pointed at.

### 11. OcOfD body work strategy decision

`sheafOf_zero` cannot be axiom-clean without `sheafOf` body. Either accept the current transitive-sorry state and stop dispatching prover lanes on this sub-target, OR commit a multi-iter substrate effort (Hartshorne II.6 subsheaf-of-`K_C` recipe, ~100-200 LOC) modeled after the existing `Scheme.toModuleKPresheaf` / `toModuleKPresheaf_isSheaf` template in `AlgebraicJacobian/Cohomology/StructureSheafModuleK/`. Surface to STRATEGY.md.

## DO NOT RETRY without structural change

### Lane J OcOfD `sheafOf_zero` axiom-clean

The kernel sorry-tracker propagates `else sorry` through every closure tactic that touches `sheafOf`. **No proof-side trick exists.** Confirmed via 6-tactic multi-attempt + 3 packaging restructurings. The only viable path is off-target `sheafOf` body work. Plan agent: do not re-dispatch Lane J expecting closure without widening.

### Lane B GmScaling Path III.a / III.b

Per progress-critic STUCK + 3-iter Mathlib simp-coverage gap confirmation (`pullback.map ≫ pullbackRightPullbackFstIso.inv` adjacency not simp-covered, `cocycle's residual normal form is not Mathlib-canonical`, `simp made no progress` empirical). These paths are HARD-walled at Mathlib b80f227. **Only III.c (separated-locus) gets a prover try iter-188.**

### Lane H RRFormula H¹ flasque-vanishing half

Mathlib gap (acknowledged iter-186 progress-critic OVER_BUDGET corrective). Either ~150-300 LOC project formalisation off critical path, or Mathlib upstream. STRATEGY.md already row-revised iter-187. Do not target H¹ in body proofs until the substrate exists.

### Lane G G2 (joint induction `IsRegularLocalRing → IsDomain`)

Per iter-187 STRATEGY decision (Option 2 from `analogies/isregularlocalring-isdomain.md`): ~200 LOC iter-188+ after G1 spanFinrank-dim-drop lands. The joint induction cannot be cheaply isolated (NO_USEFUL_ALTERNATIVE verdict from iter-186 analogist).

## Reusable proof patterns discovered iter-187

1. **φ-as-typeclass-binder pattern** (Lane I — broke 4-iter STUCK route). When φ : X → Y is a morphism between proper smooth curves, thread the function-field algebra map as a typeclass binder `[Algebra K(Y) K(X)]` rather than carrying φ explicitly through every sub-construction. Lets you use `algebraMap _ _ : K(Y) → K(X)` directly without `Hom.functionFieldMap φ` boilerplate. Documented in `analogies/ratcurveiso-pin3.md`.

2. **`constantSheafAdj.unit.app` at terminal-⊤ pattern** (Lane A — toFunctionField closure). To extract a kbar-value from a sheaf morphism `(constantSheaf _).obj kbar ⟶ F`, evaluate at `op ⊤` (which is `IsTerminal ⊤` via `Preorder.isTerminalTop`) and apply `constantSheafAdj.unit.app` to `(1 : kbar)`. Reusable wherever a project carrier is `carrierSubmodule(⊤)`-valued and we need the constant-sheaf hom interpretation.

3. **`LinearMap.toSpanSingleton` round-trip** (Lane A — globalSections_iff_mp). To build a sheaf morphism from a single element + membership witness: `LinearMap.toSpanSingleton kbar _ ⟨f, hf_in⟩` → `ModuleCat.ofHom` → `constantSheafAdj.homEquiv.symm` → `HModule_zero_linearEquiv.symm`. Close round-trip via `adj.homEquiv_unit` ∘ `ModuleCat.comp_apply` at `(1 : kbar)`.

4. **`[IsQuasicoherent]` as binder, not Prop-in-body** (Lane F). When threading quasi-coherence through `Tilde`-based section identification, prefer `[N.IsQuasicoherent]` binders over `N.IsQuasicoherent → …` arrow-in-body. Matches Mathlib idiom; signature edits cost ~5-10 LOC across 9 consumers but unlock the section-level linearEquiv.

5. **Subtype vs `@[reducible]` alias trade-off** (Lane A.1.b). `@[reducible] noncomputable def Carrier := AmbientType` lets direct Mathlib applications close axiom-clean (iter-186 5/5 closures); subtype refinement `{ M : AmbientType // P M }` adds the semantic constraint but requires a preservation lemma per propagation site. Pick the alias FIRST to land closures, then refine to subtype with the preservation work.

6. **Named typed sorry as kernel-correct gap placeholder** (Lane M↓). When a Mathlib gap is known and localized (e.g. Stacks 00TT, EGA I 6.1.9), wrap it as `private theorem narrow_gap_name (typeclasses_only) : ConclusionShape := sorry` rather than leaving the bare sorry inline. Improves traceability, isolates the gap, and lets downstream consumers be marked "axiom-clean modulo this named gap." Already documented in earlier patterns; iter-187 reinforces.
