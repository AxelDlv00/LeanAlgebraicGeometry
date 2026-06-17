# Recommendations for the next plan-agent iteration (iter-080)

## Headline targets (highest leverage)

### 1. **Lane priority — `BasicOpenCech.h_diff_pi_smul_f`**: refactor `h_mod_pi₁/₂/₃` to named per-i instances, then complete S2–S8

The iter-079 prover delivered a precise actionable blocker note. The single concrete change that unblocks the S2–S8 chain is a *literal expansion* of the existing `Pi.module` construction at L911 / L921 / L931:

```lean
-- Currently (L921–930):
have h_mod_pi₂ : Module R (∀ i, Z₂ i) :=
  @Pi.module (Fin (n + 1) → ↑s₀) (fun i => Z₂ i) R _ _ (fun i => by …)

-- Refactor to:
letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by …
have h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
-- or: letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := inferInstance
```

This is not a "new project-local helper lemma" (user policy 2026-05-11 compliant) — it's expansion of an existing `Pi.module` into named pieces. The semantic content of `h_mod_pi₂` is unchanged byte-for-byte; only typeclass-visibility changes. Apply symmetrically to `h_mod_pi₁` (L911) and `h_mod_pi₃` (L931).

After the refactor, `[∀ i, SMul R (Z₂ i)]` is synthesisable from `perI₂`, and `Pi.smul_apply` fires directly. Then the proverbial S2–S8 chain proceeds as the iter-073 recipe directed:

- **S2** — 5-layer `dsimp` to expose `(scK₀.f).hom = objD X (prev n)`.
- **S3** — `objD` identification via `AlternatingCofaceMapComplex.objD` + `CochainComplex.of_d_eq_succ` to expose the alternating sum.
- **S4** — `Pi.smul_apply` on LHS (now fires).
- **S5** — `Finset.smul_sum`.
- **S6** — `Finset.sum_congr rfl fun k _ => ?_` per-summand.
- **S7** — per-summand RingHom distributivity + presheaf functoriality.
- **S8** — `rfl` or `ring`.

**Sorry-count budget for the lane**: 6 → 5 (close `h_diff_pi_smul_f`). Hard cap 6 (no regression).

**Risk**: if the refactor breaks downstream usage of `h_mod_pi₂.toSMul.smul` elsewhere in the same proof, recover by keeping `h_mod_pi₂` *plus* the new `perI₂` (parallel availability) and using both names as appropriate.

### 2. **Lane priority — `Differentials.cotangentExactSeq_structure.h_zero`**: per-section route via `Scheme.Modules.Hom.ext`

The iter-079 attempt rolled back the iter-076 preserved chain because the central `simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]` is now stale under iter-078 elaboration. Two viable replacements:

**Route A** (recommended) — per-section extensionality:
```lean
apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
unfold cotangentExactSeqAlpha
simp only [Equiv.apply_symm_apply]
-- Replace `SheafOfModules.hom_ext` route with project-local:
apply AlgebraicGeometry.Scheme.Modules.Hom.ext
intro U b
simp only [Scheme.Modules.Hom.comp_app, Scheme.Modules.pushforward_map_app]
-- The rest of the iter-076 chain (after this re-targeted simp) should now match.
```

**Route B** (fallback) — manual `change` to expose the composition's `.val.app x` form, then proceed with `dsimp [CategoryStruct.comp, SheafOfModules.instCategory]` to unfold to the explicit `{ app := …, naturality := … }.val.app x` shape, then a per-`U` reduction.

### 3. **Lane priority — `cotangentExactSeq_structure.h_exact`**: introduce gap-fill #1 (`SheafOfModules.exact_iff_stalkwise`)

This is the *second* of the two plan-permitted semantic gap-fills for the `Differentials.lean` file. Iter-079 deliberately did not introduce it because adding it as `sorry` would push the file from 5 → 6 sorries (over the hard cap), and a complete proof requires the `TopCat.Presheaf.stalkFunctor`-preserves-exactness chain (multi-iteration infrastructure).

**Recommended iter-080 strategy**: dispatch `SheafOfModules.exact_iff_stalkwise` as its own lane with a **dedicated higher-LOC budget**. Plan agent should:
- Either authorise it to land with a `sorry` body in iter-080 (intentional sorry-count regression on Differentials.lean: 5 → 6, gated on resolving in iter-081), OR
- Bundle the `stalkFunctor`-preserves-exactness chain into iter-080's Lane 1 directly so the gap-fill lands fully closed.

Once both gap-fills (`epi_of_epi_presheaf` — landed iter-079; `exact_iff_stalkwise` — pending) are in place, `cotangentExactSeq_structure` closes in 3–4 tactic lines per the iter-076 recipe.

### 4. **`Modules/Monoidal.instIsMonoidal_W`**: defer to iter-081+

The substantive content (iso-stability of sheafification under presheaf-tensor whiskering) is genuinely hard:
- **Cleanest long-term**: upstream `MonoidalClosed (PresheafOfModules R₀)` + `HasFunctorEnrichedHom` for varying-ring case to Mathlib (multi-PR effort), then transfer via `Sites/Monoidal.lean`. Recommend kicking off Mathlib PR drafting now, but not gating any iter-080 lane on it.
- **Stopgap tractable in ~100–200 LOC**: stalks-level argument via `Presheaf.IsLocallyInjective` / `Presheaf.IsLocallySurjective` on `1 ⊗ f`.

**Downstream impact assessment**: `instIsMonoidal_W` sorry does NOT block downstream uses of `MonoidalCategory X.Modules` — only consumers of `(W X).IsMonoidal` as a hypothesis (rare; the typical user wants `MonoidalCategory X.Modules` itself, which is now an instance). Phase C step C1 (`LineBundle` refactor to invertible 𝒪_X-modules using `MonoidalCategory.Invertible`) is **unblocked**. Plan agent may proceed to iter-080 LineBundle refactor without first closing this gap-fill.

## Reusable proof patterns landed this iteration

- **`change` as a smul-instance-renamer** when `Pi.smul_apply` fails against `RingHom.toModule`-built smul. Use `change e (…) j = INST.smul r _ j`. Defeq, lint-clean, exposes the smul explicitly.
- **`LocalizedMonoidal + inferInstanceAs`** for closing `MonoidalCategoryStruct D` and `MonoidalCategory D` when `D` is a localization at `W` with `W.IsMonoidal` available. Concentrates substantive content in the single `W.IsMonoidal` instance.
- **Top-level bridging instance** `instX : C (WrappedType X) := show C (UnwrappedType X) from inferInstance` for definitional-equality plumbing, when the wrapped type appears in *types* of subsequent instances (not just bodies). Iter-078 used `letI` inline; iter-079 lifted to top-level.
- **`Functor.epi_of_epi_map` + faithful forgetful** as a 7-line bridge from layer-N+1 epi to layer-N epi. Pattern: `Functor.epi_of_epi_map ((forget R).map f) where Faithful (forget R)`. Generalises to any faithful inclusion of a structured category into its underlying category.

## Blockers — do NOT retry in iter-080

- The iter-076 chain's `simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]` step in `cotangentExactSeq_structure`. Confirmed stale. Use per-section route (Route A above) instead.
- `simp/rw [Pi.smul_apply]` against `h_mod_pi₂.toSMul`-built smul in BasicOpenCech without first refactoring the per-i builders. Confirmed three times (iter-076, iter-078, iter-079). The `change` step (iter-079) is the only useful intermediate.
- The closedness route to `(W X).IsMonoidal` via Mathlib's `Sites/Monoidal.lean` template — requires variable-ring `MonoidalClosed (PresheafOfModules R₀)`, absent from Mathlib.
- `letI`-based parallel instance to bypass `h_mod_pi₂`-anonymity for `Pi.smul_apply` — does not unify (iter-079 confirmed: parallel `letI` does not bridge to the existing `h_mod_pi₂`-mediated smul).
- All previously-confirmed blockers in `PROJECT_STATUS.md` (no new ones invalidated this iteration).

## Targets to stay off-limits iter-080

- `AlgebraicJacobian/Jacobian.lean` `nonempty_jacobianWitness` (L179) — Phase C step C3, iter-085+ at earliest.
- `AlgebraicJacobian/Picard/Functor.lean` `representable` — gated on Phase C C0–C3.
- `BasicOpenCech.lean` L502, L826, L854 — confirmed multi-iter dead-ends.
- `BasicOpenCech.lean` L1185 `g_R.map_smul'`, L1214 `h_loc_exact` — gated on Lane 2 landing.
- `Differentials.lean` L122 `relativeDifferentialsPresheaf_isSheaf`, L771 `smooth_iff_locally_free_omega`, L788 `cotangent_at_section`, L930 `serre_duality_genus` — Phase B infrastructure not yet consolidated.

## Realistic iter-080 outcome estimate

If the plan agent dispatches three lanes per iter-079's pattern:
- **Lane 1** (Differentials, Route A): close `cotangentExactSeq_structure` if `exact_iff_stalkwise` gap-fill is permitted with `sorry` body. Net: −1 sorry (5 → 4) **or** net 0 (gap-fill stays sorry but body closes via `epi_of_epi_presheaf` + Route A's h_zero work, requires re-evaluation).
- **Lane 2** (BasicOpenCech, refactor + S2–S8): close `h_diff_pi_smul_f`. Net: −1 sorry (6 → 5).
- **Lane 3** (LineBundle Phase C step C1 refactor, OR Differentials Phase B follow-ons): net 0 (refactor lane) **or** net −1.

**Plausible iter-080 closure**: 14 → 12 active sorries (net −2). Stretch: 14 → 11.

## Process notes for the plan agent

- The iter-079 prover dispatch worked cleanly: 3 lanes, no cross-interference, all task results substantive and actionable. Continue the three-lane pattern.
- Iter-079 prover reports include precise blocker analyses with concrete proposed unblock paths (e.g. the BasicOpenCech `h_mod_pi₂` refactor). The plan agent should fold these into the next round's `Recipe.` sections verbatim.
- Per user policy 2026-05-11: no chains of thin helpers across iterations. The two permitted gap-fills for `Differentials.lean` (`epi_of_epi_presheaf` landed; `exact_iff_stalkwise` pending) are the *only* project-local helpers authorised for this declaration. No additional helpers should be introduced.
- Prover task results this iteration occasionally reference `lean_multi_attempt` probes — those are not pre-validation of candidate bodies (they're position-bound tactic-attempt previews via the LSP), which is fine per the policy. No `lean_run_code` was invoked.
