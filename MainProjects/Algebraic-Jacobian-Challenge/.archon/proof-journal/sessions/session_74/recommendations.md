# Recommendations for the next plan-agent iteration (iter-075)

## Context

Iter-074 closed **0 active sorries** (15 → 15 syntactic). Both prover lanes
returned PARTIAL.

- **Lane 1 (Differentials, `h_zero`)**: advanced 3 of 4 remaining strategy
  steps. The proof body now executes Steps 1–6 of the 7-step plan; only
  Step 7 (pointwise Derivation reduction) remains as a labelled `sorry`.
  Mathlib leverage names all pinned. The substantive next-step obstacle is
  the absence of a `Derivation.postcomp_comp` chain lemma in Mathlib.
- **Lane 2 (BasicOpenCech, `h_diff_pi_smul_f`)**: upgraded the iter-073 S1–S8
  recipe from inline commentary to runnable tactic syntax with `try`-wrappers
  for compile safety. The chain compiles clean against cached oleans but the
  bottom `sorry` remains. Without working LSP `lean_goal`, the prover could not
  validate which `simp only` step actually fires; the next prover (under live
  LSP) can probe step-by-step and convert `try t` to verified `t`.

The iter-074 estimate ("−3 to −5 sorries") did not hold. Realistic estimate
for iter-075: **−1 to −3 sorries**, contingent on either (a) staging the
`Derivation.postcomp_comp` helper or (b) working LSP for Lane 2's per-summand
distribution.

## Priority ranking

### P1 — Differentials.lean `_structure.h_zero` Step 7 closure

**Why highest**: 6 of 7 strategy steps are now concrete tactics. The remaining
work is a tightly-defined pointwise Derivation equation. All four rewrites
to close it are individually named.

**Action**: stage two project-local helpers, then close Step 7.

```lean
-- Helper 1 (likely `rfl` after unfolding `Derivation.postcomp`):
@[simp]
lemma PresheafOfModules.Derivation.postcomp_comp
    {R S : Cᵒᵖ ⥤ CommRingCat} {F : C ⥤ C} (φ : S ⟶ F.op ⋙ R)
    {M N K : PresheafOfModules ...} (d : M.Derivation φ)
    (f₁ : M ⟶ N) (f₂ : N ⟶ K) :
    d.postcomp (f₁ ≫ f₂) = (d.postcomp f₁).postcomp f₂ := by rfl

-- Helper 2 (β.val as a named desc with a fac-style simp lemma): optional but
-- useful if Step 7 cannot reach β.val via `unfold` alone.
```

After Helper 1, Step 7 reduces by:
```lean
simp [Derivation.postcomp_comp,
      PresheafOfModules.DifferentialsConstruction.isUniversal'.fac,
      PresheafOfModules.pushforward_map_app_apply,
      PresheafOfModules.Derivation'.d_app]
-- maybe + rw [adjunction-coherence identity] for the f.c.app U rewrite
```

**Estimated**: 30–50 LOC (10–20 for the helper, 20–30 for the closure).

### P2 — BasicOpenCech.lean `h_diff_pi_smul_f` closure under live LSP

**Why high**: the iter-073 S1–S8 recipe is fully committed as runnable tactic
syntax in the file. Under live LSP, a prover can run `lean_goal` after each
`try`-wrapped step to determine which fires, then drop the `try` wrappers.
The substantive residual is the per-summand `algebraMap_naturality` rewrite.

**Action** (requires working LSP):
1. Run `lean_goal` after `intro r y; try funext j`.
2. If goal is `... = r • ...` at index `j`, drop `try` from `funext j` and
   from the first `simp only`.
3. Run `lean_goal` after the long `simp only [scK₀, K₀, ...]` chain. Inspect
   whether it exposes the alternating-sum normal form.
4. If yes, run `lean_goal` after `simp only [Pi.smul_apply, Finset.sum_apply,
   Finset.smul_sum]`. Inspect.
5. If the per-summand goal `∑ k, (-1)^k.val • ...` appears, add:
   ```lean
   refine Finset.sum_congr rfl fun k _ => ?_
   -- inside: rw [show (-1 : ℤ) ^ k.val • _ = _ ... ];
   -- then apply algebraMap_naturality from StructureSheafModuleK.lean L161
   ```

**Estimated**: 60–100 LOC under live LSP; could be larger if the
14-name `simp only` chain does not fully reduce (route via explicit `show`
clauses then).

### P3 — `Derivation.postcomp_comp` helper staging (prereq for P1)

**Why**: P1 needs this. Most likely a one-line `rfl` proof.

**Action**: probe with `lean_run_code` (or directly add to Differentials.lean
inside the existing `PresheafOfModules.Derivation` namespace):
```lean
@[simp]
lemma postcomp_comp ... := by rfl
```
If `rfl` fails, try `AddMonoidHom.ext` + structural unfolding.

**Estimated**: 5–20 LOC.

### P4 — `h_diff_pi_smul_g` mechanical copy

**Why**: once P2 lands, `h_diff_pi_smul_g` is mechanically identical with
shifted index. A trivial closure relative to P2.

**Action**: copy the closing chain with `h_mod_pi₃`-side smul.

**Estimated**: 10–20 LOC.

### P5 — `_structure.h_epi` helper staging

**Why**: still needs project-local `SheafOfModules.epi_of_epi_presheaf` (Mathlib
does not provide). Once available, `h_epi` reduces to pointwise
`KaehlerDifferential.map_surjective` via `PresheafOfModules.epi_iff_surjective`.

**Estimated**: 30–50 LOC for the helper, 20–30 LOC for the closure.

### P6 — `_structure.h_exact` helper staging

**Why**: still needs the dual helper `SheafOfModules.exact_iff_stalkwise`. Once
available, `h_exact` reduces to ring-level `KaehlerDifferential.exact_mapBaseChange_map`
applied stalkwise.

**Lower priority** than P5 because (a) Mathlib may have a stalkwise-exactness
lemma under a different name (worth a `lean_local_search` against
`SheafOfModules.exact` / `SheafOfModules.stalk` first), and (b) the stalkwise
route involves nontrivial localisation chains.

**Estimated**: 40–60 LOC for the helper, 20–40 LOC for the closure.

### P7 — Build environment repair (still critical)

**Why**: persistent since iter-068 (now **7 consecutive iterations**).
`.lake/packages/*` root-owned; `lake env lean` fails with `unknown module
prefix 'Mathlib'`; LSP `lean_goal` returns `goals: null`, `lean_multi_attempt`
returns `goals: []`, and `lean_run_code` silently swallows import-bearing
compile errors. Iter-074 specifically gates the Lane 2 per-summand
distribution on live LSP.

**Action**: the plan agent must (continue to) flag for user action:
1. `sudo chown -R $(id -u):$(id -g) .lake/packages/`.
2. `lake update && lake build` to regenerate `.lake/build/lib/Mathlib/**.olean`.
3. `sync_leanok` and the LSP resume working.

This blocks not the work but the verification of the work. Continue treating
post-edit `error_count: 0` reports as "provisionally clean from cached olean
view" rather than authoritative.

## Do NOT assign (blocked / deferred)

- **`Jacobian.nonempty_jacobianWitness`** (Jacobian.lean L177) — Albanese existence;
  absorbs genus-0 rigidity. Multi-month effort.
- **`PicardFunctor.representable`** (Picard/Functor.lean L190) — intentionally deferred.
- **`relativeDifferentialsPresheaf_isSheaf`** (Differentials.lean L122) — large;
  lower priority than `_structure` closure.
- **`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`**
  (Differentials.lean downstream of `_structure`) — do not assign until `_structure`
  is complete.
- **BasicOpenCech.lean L495, L819, L847** (Cluster (a) extra-degeneracy substeps) —
  confirmed dead-end across four iterations; do not retry.
- **BasicOpenCech.lean L1156** (`LocalizedModule.map ... = sorry` in `h_a₀_fun` region)
  — blocked behind `h_diff_pi_smul_{f,g}` and `h_loc_exact`; secondary target only.

## Reusable patterns to propagate

1. **6-of-7-steps committed-with-trailing-sorry pattern** *(NEW iter-074)*. When
   a closure is structurally well-understood but the residual `simp`-or-`rw`
   step requires LSP to land, commit the first N–1 steps as concrete tactics
   (compiling clean against cached oleans) and leave the trailing residual as
   a single labelled `sorry`. The next prover starts from a strictly smaller,
   more concrete goal.
2. **`try`-wrapped full-recipe-with-fallback-sorry pattern** *(confirmed
   iter-074, iter-073)*. When the entire chain is speculative under broken
   env, wrap each step in `try` to preserve compile-cleanness, then `sorry`
   at the bottom. Strictly safer than committing untested unwrapped tactics
   for the env-broken regime.
3. **`set`-alias rebinding after `unfold + simp [...]`** *(NEW iter-074)*. After
   `unfold` exposes inlined morphism expressions, immediately re-introduce
   local names via `set φ_g' : ... := ...` so subsequent universal-property
   handles (`isUniversal' φ_g'`) elaborate. Prevents the goal from carrying
   anonymous nested compositions.
4. **Adjunction-injection + universal-property scaffold** *(iter-073, extended
   iter-074)*. For cross-space sheaf-of-modules zero-composition statements:
   `pullbackPushforwardAdjunction.homEquiv.injective` → `homAddEquiv_zero` +
   `homEquiv_naturality_right` → `SheafOfModules.hom_ext` →
   `isUniversal'.postcomp_injective` → `Derivation @[ext]` reduces to a
   pointwise Derivation equation discharged by `Derivation'.d_app` on the
   adjunction-coherence factor.
5. **Witness-Π-family routing** *(iter-073)*. Bundle all existence data +
   universal-property predicate as `predicate : ∀ x, P x J`. Every consumer
   becomes a single-line `(witness).predicate x . field`.
6. **Embedded reduction recipes for opaque sorries** *(iter-073)*. When a
   sorry cannot be closed, embed the complete `dsimp only [...]` recipe +
   Mathlib leverage names + step list as comments above the sorry.

## Process notes

- **Build environment caveat persists.** Seven iterations. Continue treating
  fresh post-edit verification as unavailable until the user repairs
  `.lake/packages/*` permissions.
- **LSP degradation is now measurable.** `lean_goal` returns `goals: null`,
  `lean_multi_attempt` returns `goals: []`. The provers' only viable signal
  is `lean_diagnostic_messages`'s `clean: true`/`error_count: 0`.
- **Process discipline held.** Two parallel lanes confined edits to their
  assigned files. Zero new axioms. Protected signatures preserved verbatim.
  `archon-protected.yaml` unchanged.
- **Lane budget calibration**: realistic for iter-075 is **−1 to −3 sorries**
  (single-step closures on Lane 1 P1 + optional Lane 2 P2 if LSP works).

## Suggested iter-075 dispatch (2 lanes)

1. **Lane A (Differentials, P1+P3)**: stage `Derivation.postcomp_comp` and
   close `_structure.h_zero` Step 7. Tight scope; fastest expected closure.
2. **Lane B (BasicOpenCech, P2)**: under live LSP, probe the iter-074
   `try`-chain and close `h_diff_pi_smul_f` via per-summand
   `algebraMap_naturality`. Conditional on env repair; if env still broken,
   merge into Lane A or skip.

Net target for iter-075: **−1 to −3 sorries** (from 15 to 12–14).

If user repairs env mid-iteration, add **Lane C (Differentials, P4)**
(mechanical `h_diff_pi_smul_g` copy after Lane B) and possibly **Lane D
(Differentials, P5)** (`h_epi` helper staging + closure).
