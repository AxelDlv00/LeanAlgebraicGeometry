# Recommendations for the next plan-agent iteration (iter-071)

## Context

Iter-070 was blueprint-only per user directive. The prover attempts captured in `attempts_raw.jsonl` made zero net progress. Iter-071 should resume the three parallel prover tracks suspended at iter-069.

## Priority ranking

### P1 — Close `h_π_split` in BasicOpenCech.lean

**Why highest:** `h_π_split` is the gate to closing `h_transport` (step 3 of the Čech acyclicity proof). Without it, the 8 remaining sub-targets (`f_R`, `g_R`, `hf_eq`, `hg_eq`, `h_loc_Xᵢ`, `h_loc_exact`) cannot be applied. This has been the top blocker for three consecutive iterations.

**Strategy:** The 5 failed attempts in iter-070 (and 3 in iter-069) all converge on the same gap: no simp/rewrite lemma exposes the component-wise form of `π.f i` as `Pi.lift (fun b => Pi.π M (g_FC.f ∘ b))`. Two concrete routes:

1. **Mathlib search (fast)**: Search for `AlternatingCofaceMapComplex.map_f` or `FormalCoproduct.cechFunctor_map_app_f` — any lemma computing the degree-`i` component of the cochain complex map induced by a cosimplicial natural transformation. If such a lemma exists, the proof closes in ~10 lines.

2. **Project-side helper (fallback)**: If no Mathlib lemma exists, add a small helper in `BasicOpenCech.lean`:
   ```lean
   lemma alternatingCofaceMapComplex_map_f {C D : Category} (F : C ⥤ D) (τ : X ⟶ Y) (i : ℕ) :
       ((alternatingCofaceMapComplex D).map (whiskerLeft F τ)).f i = ...
   ```
   This is ~20–40 LOC of category-theoretic plumbing. The plan agent should estimate whether this is a single-iteration target.

3. **Avoid the convert route**: The prover's attempts with `convert splitEpi_pi_lift_of_injective ... using 2` fail because the equality subgoal cannot be closed by simp. A better strategy might be to prove `π.f i = Pi.lift (...)` directly via `funext` + component-wise calculation, bypassing `convert` entirely.

**Do NOT assign** the full `h_transport` closure in one iteration — it is too large. Focus on `h_π_split` alone.

### P2 — Close `cotangentExactSeqAlpha` in Differentials.lean

**Why:** `cotangentExactSeqAlpha` is the remaining ingredient for the full cotangent exact sequence. With `cotangentExactSeqBeta` now closed (iter-069), the sequence is half-complete. The iter-070 prover redundantly re-implemented `cotangentExactSeqBeta` instead of attacking `cotangentExactSeqAlpha`.

**Strategy:** The base-change map `f^* Ω_{Y/S} ⟶ Ω_{X/S}` requires:
1. Constructing a natural transformation `relativeDifferentials g ⟶ (pushforward f).obj (relativeDifferentials (f ≫ g))`.
2. Using the adjunction `pullbackPushforwardAdjunction f` to convert this to a morphism from the pullback.
3. The local description is `KaehlerDifferential.mapBaseChange`, which exists in Mathlib.

The prover's Differentials task result (iter-069) already outlines the exact strategy. Estimated 150–250 LOC.

### P3 — Continue `h_K₀_exact` sub-targets after `h_π_split`

Once `h_π_split` is available, the next easiest wins are:
1. **`f_R` / `g_R`** (repackage Čech differential as R-linear maps): requires unfolding `alternatingCofaceMapComplex` to show each face map is an R-algebra homomorphism, hence R-linear.
2. **`hf_eq` / `hg_eq`** (equality of underlying maps): should follow from `f_R` construction by `rfl` or `funext` + `simp`.
3. **`h_loc_Xᵢ`** (localized module instances): finite product of localizations commutes with localization; `IsLocalizedModule.pi` should apply.
4. **`h_loc_exact`** (per-f localized exactness): follows from the hypothesis `h_a₀_fun` once the localized differentials are identified.

### P4 — Environment fix: doc-gen4 permission issue

The `.lake/packages/doc-gen4` directory has broken filesystem permissions, blocking `lake build` and `lake update`. The next plan agent should either:
- Ask the user to fix permissions (`sudo chown -R $(whoami) .lake/packages/doc-gen4`), or
- Temporarily comment out doc-gen4 from `lakefile.toml` for the prover round (the iter-069/070 prover already did this manually).

### Do NOT assign (blocked)

- The 5 `Jacobian.lean` genus > 0 sorries — still blocked on symmetric powers / quotients / Picard representability (Phase C).
- The 3 `AbelJacobi.lean` sorries — downstream of `Jacobian C` construction.
- `PicardFunctor.representable` — still deferred per directive.
- `relativeDifferentialsPresheaf_isSheaf` — large target requiring basic-open sheaf-condition infrastructure; better to close `cotangentExactSeqAlpha` first for momentum.

## Reusable patterns to propagate

1. **`ModuleCat.piIsoPi` + `e.toAddEquiv.module R` transport** — any future target that needs a `Module R` instance on a categorical product in `ModuleCat` should use this exact 5-step pattern.
2. **Adjunction factorization + derivation lift** — the `cotangentExactSeqBeta` strategy (build `η` with `η ≫ φ2' = φ1'`, then repackage derivation) is the template for `cotangentExactSeqAlpha`.
3. **Conditional definition with `split_ifs`** — the Jacobian genus-0/genus>0 pattern should be reused if any other declaration needs case-splitting on genus.
