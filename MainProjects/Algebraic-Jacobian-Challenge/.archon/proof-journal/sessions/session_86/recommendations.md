# Recommendations for the next plan-agent iteration (iter-087)

## TL;DR

- **Priority target (iter-087)**: Lane 1 closure of `h_diff_pi_smul_f` in `BasicOpenCech.lean` via the concrete 5-step recipe documented in the iter-086 task result (`hom_sum_dist` inline `Finset.cons_induction` lemma → sum-distribution → per-summand chain leveraging the now-landed `R_restrict_R_linear`).
- **Lane 2 decision required**: plan agent must CHOOSE between Route A (build `SheafOfModules.exact_of_presheaf_exact` true-signature helper) and Route B (section-wise + sheafification direct construction) for `cotangentExactSeq_structure case h_exact`. Do NOT pursue both. Route A is preferred (shorter once infra is in place) but requires multi-iter upstream homology-preservation work.
- **Off-limits (unchanged)**: `Modules/Monoidal.lean` L173 (Mathlib gap, indefinite defer); `Jacobian.lean` L179, `Picard/Functor.lean` L190 (Phase C deferred); BasicOpenCech.lean L502 / L826 / L854 (substep-(a) / `h_π_split` analogue / extra-degeneracy multi-iter blockers); Differentials L122 / L957 / L974 / L1116 (Phase B / B+ multi-iter).
- **Realistic iter-087 sorry-count target**: net **−1** (13 active) if Lane 1 lands a clean closure.

---

## Lane 1 — `BasicOpenCech.lean` `h_diff_pi_smul_f` body (PRIORITY)

**Status**: iter-086 LANDED the `R_restrict_R_linear` inline lemma (Step 1 of the iter-085 recipe) with a real 3-tactic body. The post-`hsmul_eq` goal remains in S6-form at L1478. Step 2 closure stalled because the goal needs the outer `ModuleCat.Hom.hom (∑ i, ...)` sum peeled BEFORE per-summand application of `R_restrict_R_linear` can fire.

### Iter-087 directive — implement Steps 2–5 of the iter-086 recipe

The iter-086 task result `.archon/task_results/AlgebraicJacobian_Cohomology_BasicOpenCech.lean.md` § "Iter-087 next-step recipe" (L88–111) is concrete and executable. Reproduce here:

```lean
-- Step 2: surface the sum (must be inline `have`, NOT a top-level helper)
have hom_sum_dist :
    ∀ (s : Finset ι) (f : ι → (M ⟶ N)),
      ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, ModuleCat.Hom.hom (f i) := by
  intro s f
  induction s using Finset.cons_induction with
  | empty => simp [ModuleCat.hom_zero]  -- or analogous zero lemma
  | cons i s hi ih => rw [Finset.sum_cons, ModuleCat.hom_add, Finset.sum_cons, ih]

-- Step 3: apply hom_sum_dist + distribute (Pi.π Z₂ j).hom over the sum via map_sum
-- Step 4: per-summand (i,j): Pi.lift_π_apply → Pi.smul_apply → map_mul → R_restrict_R_linear
-- Step 5: reassemble via Finset.smul_sum
```

**CRITICAL — do NOT retry the iter-085 / iter-086 documented dead-ends**:
- `simp only [LinearMap.comp_apply, map_sum, ...]` — no fire
- `simp only [ModuleCat.hom_sum]` — lemma doesn't exist
- `simp only [Pi.lift_π_apply]` directly — Pi.lift is INSIDE the sum, cannot fire until sum is peeled
- `rw [ModuleCat.hom_comp]` directly — pattern not in goal
- `change` over `(eqToHom ∘ₗ Σ.hom)` — eqToHom cast type proof cannot be inferred
- `induction hRel; rfl` — motive issue
- `set L : ... →ₗ[k] ... := comp` — universe constraint stuck

The iter-085/iter-086 dead-end catalogue is exhaustive at the simp/rw/change level; the ONLY remaining productive path is the `hom_sum_dist` inline + reverse-direction chain.

**Estimated complexity**: ~40–60 LOC of carefully-sequenced tactics. The `hom_sum_dist` lemma is ~6 LOC inline. Per-summand reduction + S8 reassembly is the bulk.

**Recommended approach**: work BACKWARDS from the RHS — start with `r •_{perI₂ j} (Pi.π Z₂ j).hom (...)` and rewrite using `Finset.smul_sum` + per-summand `R_restrict_R_linear` + `←` chain to match LHS. The "S8 → S7 → S6 reverse direction" is the path the iter-086 task result also recommends.

**iter-087 hard cap**: 5 sorries per file. BasicOpenCech currently at 6 — closure would drop to 5; aggregate to 13.

**Stop rules iter-087 Lane 1**:
1. If after 6 hours of prover budget the `hom_sum_dist` inline `have` hasn't compiled standalone, escalate to the challenger or analogy subagent with the explicit `Finset.cons_induction` + `ModuleCat.hom_add` template — `ModuleCat.hom_zero` may need to be derived via `map_zero` of the additive-hom wrapper if `ModuleCat.hom_zero` itself isn't a Mathlib lemma.
2. If `hom_sum_dist` compiles but the per-summand chain fails on the `eqToHom_app` step, fall back to documenting the explicit per-summand identification as a NEW inline `have` (still NOT a top-level helper).
3. Do NOT introduce new axioms.
4. Do NOT introduce new project-local TOP-LEVEL helpers — inline `have`s only.

## Lane 2 — `Differentials.lean` `cotangentExactSeq_structure case h_exact` (DECISION REQUIRED)

**Status**: iter-086 reverted the iter-085 false-signature helper `_root_.SheafOfModules.exact_iff_stalkwise` (which had a `sorry`-bodied declaration with the universal claim that EVERY short complex of sheaves of modules is exact — mathematically false). `case h_exact` is now an honest open `sorry` at L636.

**iter-087 directive — plan agent must CHOOSE one route**:

### Route A (top-down) — preferred for shortness once infra is in place

Introduce a project-local helper:

```lean
lemma SheafOfModules.exact_of_presheaf_exact
    {C : Type*} [Category C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat}
    (S : ShortComplex (SheafOfModules R))
    (h : (S.map (SheafOfModules.toPresheaf R)).Exact) : S.Exact
```

(Or the iff form.) This has a TRUE, mathematically defensible signature: faithful functors reflect exactness in abelian categories. The body uses `CategoryTheory.ShortComplex.exact_map_iff_of_faithful` against `SheafOfModules.toPresheaf` plus:
- proven faithfulness of `SheafOfModules.toPresheaf` (this is essentially `Sheaf.val_injective`-style, should be a small lemma);
- proven preservation of left/right homology by the toPresheaf functor (this is the multi-iter part — Mathlib does NOT currently provide `PreservesLeftHomologyOf (SheafOfModules.toPresheaf R) S`).

Expected closure budget: 2–3 iterations to land the helper + its body + apply at `case h_exact`.

### Route B (bottom-up) — concrete but mechanically long

Skip `SheafOfModules`-level exactness entirely. Use `ShortComplex.exact_iff_image_eq_kernel` and:
- For each open `U`, compute both ker and image as modules over `X.presheaf.obj (op U)` using `KaehlerDifferential.exact_mapBaseChange_map`.
- Glue across opens via sheafification's left-exactness (`PresheafOfModules.instPreservesFiniteLimitsSheafOfModulesSheafification`).

Expected closure budget: 3–4 iterations. Concrete but mechanically long.

### Recommendation

Route A. Reasons:
1. The Mathlib lemma `CategoryTheory.ShortComplex.exact_map_iff_of_faithful` is a clean target.
2. The faithfulness of `SheafOfModules.toPresheaf` is essentially folklore and likely provable in <20 LOC inline.
3. The homology-preservation argument, while multi-iter, has well-defined deliverables: `PreservesLeftHomologyOf` + `PreservesRightHomologyOf` for the toPresheaf functor. Each is a tractable subgoal.
4. The resulting helper has a TRUE signature (in contrast to the iter-085 false claim), and is a reusable piece of infrastructure for any future cotangent-exactness argument.

### CRITICAL warning — do NOT repeat the iter-085 false-helper mistake

The iter-085 prover introduced `lemma _root_.SheafOfModules.exact_iff_stalkwise (S : ShortComplex (SheafOfModules R)) : S.Exact := by sorry`. This signature has NO HYPOTHESIS — it claims every short complex is exact. This was an autoformalization shortcut that the iter-086 plan correctly identified and ordered the revert of. The plan agent and prover MUST verify any new helper's signature before authorising the introduction:

- The signature must have non-trivial hypotheses (e.g. presheaf-exactness + functor-preservation conditions);
- The signature must reduce to a TRUE mathematical theorem;
- The signature should reference Mathlib lemmas in its hypotheses where appropriate so the body becomes a thin wrapper.

### Lane 2 stop rules iter-087

1. If the chosen route (A or B) has not surfaced a clean signature by the 4-hour mark, defer Lane 2 to iter-088+ and concentrate fully on Lane 1 closure.
2. Do NOT introduce a helper with universal hypothesis-free signatures.
3. Do NOT introduce new axioms.
4. The helper signature, body strategy, and budget should be reviewed by the plan agent BEFORE the prover begins implementation (in `STRATEGY.md` or `PROGRESS.md`).

## Lane 3 — `Modules/Monoidal.lean` (UNCHANGED)

Off-limits pending Mathlib upstream PR for `PresheafOfModules.stalk_tensorObj` with varying-ring R₀ + iso-stability of sheafification. No prover assignment.

## Off-limits (do NOT assign — confirmed multi-iter blockers)

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L502 — substep (a) infrastructure (augmented Čech simplicial object); needs the extra-degeneracy chain.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L826 — `h_π_split` analogue / refinement transport.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L854 — substep (a) for `s₀`-indexed slice cover (extra-degeneracy).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1523 — downstream of `h_diff_pi_smul_f` closure (`g_R.map_smul'`). iter-087 should NOT touch this until L1478 lands.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1552 — `h_loc_exact`; needs `IsLocalizedModule.Away f.1` infrastructure.
- `AlgebraicJacobian/Differentials.lean` L122 — `relativeDifferentialsPresheaf_isSheaf` (Phase B step 1; multi-iter).
- `AlgebraicJacobian/Differentials.lean` L957, L974, L1116 — Phase B step 2–4 (smooth_iff, cotangent_at_section, serre_duality_genus).
- `AlgebraicJacobian/Modules/Monoidal.lean` L173 — `instIsMonoidal_W` (Mathlib gap).
- `AlgebraicJacobian/Jacobian.lean` L179, `AlgebraicJacobian/Picard/Functor.lean` L190 — Phase C deferred.

---

## Reusable proof patterns to surface in iter-087 STRATEGY.md (NEW iter-086 additions)

1. **`R_restrict_R_linear` inline lemma for presheaf-functoriality element-level collapse** *(NEW iter-086, KEY)*. The 3-tactic body `intro V W h_VW h_VU h_WU r' ; rw [← ConcreteCategory.comp_apply, ← presheaf.map_comp] ; congr 1` closes the chain `(presheaf.map (V≤W).op).hom ((presheaf.map (W≤U).op).hom r') = (presheaf.map (V≤U).op).hom r'` by reducing to `Opens.op` subsingleton hom-types. The signature must AVOID a `(r' * z)` factor at statement level (typeclass synth fails on `HMul ↑(presheaf.obj (op W))`); state element-level functoriality only.

2. **Drop-the-`* z`-factor refactor for `presheaf-as-CommRingCat` typeclass-synth obstructions** *(NEW iter-086)*. When a lemma's statement involves `(presheaf.map ...).hom r' * z` with `z : ↑(presheaf.obj (op W))`, Lean's typeclass synthesis at the `*` site fails because it cannot reach the bundled `CommRingCat` instance through the carrier coercion. Workaround: drop the `* z` factor and prove the element-level functoriality form alone; pull `* z` out separately via `(presheaf.map ...).hom.map_mul` at the call site. Confirmed iter-086 (7 distinct attempts failed; 8th succeeded after dropping the factor).

3. **`congr 1` for hom-type subsingleton collapse in `(Opens X)^op`** *(NEW iter-086)*. After `rw [← C.left.presheaf.map_comp]`, the goal `(presheaf.map (h_VW.op ≫ h_WU.op)).hom r' = (presheaf.map h_VU.op).hom r'` reduces to equality of two morphisms in `(Opens X)^op`. Since all parallel morphisms in `(Opens X)^op` are equal (it's a poset-category, hence morphisms are subsingleton), `congr 1` closes both halves: the carrier-arg leg AND the morphism leg. No trailing `Subsingleton.elim` needed (it would error with "No goals to be solved").

4. **Mathematical-honesty audit protocol for sorry-bodied helpers** *(NEW iter-086, KEY)*. When introducing a new project-local helper with a `sorry` body that packages a Mathlib gap, the signature MUST have non-trivial hypotheses that, if discharged, would make the conclusion TRUE. A signature like `(S : ShortComplex (SheafOfModules R)) : S.Exact` is FALSE (claims every short complex is exact) and must be rejected — even if the body is "obviously sorry / Mathlib gap". The iter-085 false-helper was identified and reverted in iter-086; this pattern is now codified.

5. **No-direct-name lookup for `ModuleCat.hom_sum`** *(NEW iter-086, dead-end avoidance)*. `ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, ModuleCat.Hom.hom (f i)` is NOT a Mathlib lemma by that name. Use `Finset.cons_induction` inline + `ModuleCat.hom_add` (which DOES exist as a two-summand lemma). The iter-087 recipe formalises this.

---

## Carry-overs from iter-085 (still relevant)

- **Open-frontier-as-named-helper protocol** — REMAINS USEFUL but now requires the mathematical-honesty audit (pattern 4 above) before introduction. The protocol was incorrectly applied iter-085 with the false-universal signature; iter-086 corrected the application by deleting the false helper.
- **`hsmul_eq` to surface inner Pi.module smul past AddEquiv.module transport** — preserved iter-086 byte-for-byte at L1399–1402.
- **HOU obstruction catalogue for `(eqToHom ∘ₗ Σ.hom) (...)` opaque terms** — 8 distinct bypasses confirmed dead-end (iter-085). Iter-086 added 6 more failed simp/rw probes to the catalogue (see milestones.jsonl attempts 9–11 for Lane 1).

## Known Blockers (do not retry without new infrastructure)

- **BasicOpenCech L1478 `simp only [...]` on the post-`hsmul_eq` goal** — 6 distinct simp / rw probes fail because the outer `ModuleCat.Hom.hom (∑ i, ...)` wraps the sum opaquely (iter-086 dead-end catalogue).
- **`ModuleCat.hom_sum` as a direct-named lemma** — does not exist in Mathlib; derive inline via `Finset.cons_induction`.
- **All iter-085 dead-ends** still apply (`LinearMap.comp_apply` HOU, `change` over eqToHom-cast, `induction hRel`, `set L`, `have key`).

## Process discipline for iter-087

- Two-lane parallel dispatch (Lane 1 BasicOpenCech, Lane 2 Differentials) should continue, BUT Lane 2 budget should be conditional on plan-agent Route A/B decision and ≤ 4 hours of prover time. Lane 1 has the cleaner deliverable and should receive the bulk of the prover budget.
- Zero new axioms; zero new project-local top-level helpers (inline `have`s only). The iter-086 `R_restrict_R_linear` is a model of correct inline-helper introduction.
- Mathematical-honesty audit pass (pattern 4 above) MUST be performed by the plan agent BEFORE authorising any new sorry-bodied helper.
