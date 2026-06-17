# Recommendations for the next plan-agent iteration (iter-085)

## Net iter-084 summary

- **Sorry count**: 14 → 14 (no syntactic regression; but a meaningful Phase B advance landed on Lane 2 — `h_epi` of `cotangentExactSeq_structure` is now fully closed; the conjunction was split so only `h_exact` carries the remaining sorry).
- **Two lanes ran** (BasicOpenCech, Differentials). Modules/Monoidal off-limits.
- **Lane 2 closure target hit**: `h_epi` of `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` closed via `Submodule.span_induction` over `_root_.KaehlerDifferential.span_range_derivation` + `ModuleCat.Derivation.desc_d`. **Key insight that unblocks iter-083's typeclass barrier**: use implicit-type membership `hspan ▸ (Submodule.mem_top : y ∈ ⊤)` instead of explicit `Submodule.span ↑R ↑M ...` form — the latter forces synthesis of a bundled `Module` instance that doesn't exist.
- **Lane 1 structural advance**: both iter-083 typeclass barriers cleared (`letI` under literal `↑(∏ᶜ Z_i)` source-type + explicit `show … rw [LinearEquiv.apply_symm_apply]` smul-commutation). No closure landed; per-summand `Φ_j` construction with explicit `map_smul'` deferred to iter-085+ (~50–80 LOC).
- **Zero new axioms**; **zero new project-local helper lemmas** (both lanes preserved iter-079/081/082/083 helpers byte-for-byte).
- 17 source edits (2 Lane 1, 15 Lane 2); 17 `lean_diagnostic_messages`; 16 `lean_goal`; 23 lemma searches; 0 `lake build`; 0 `lean_run_code` pre-validation.

---

## Headline targets (highest leverage for iter-085)

### 1. **Lane 2 priority — `Differentials.cotangentExactSeq_structure.h_exact` closure (L640)**

This is the *natural follow-up* to iter-084's Lane 2 closure: `h_epi` is done, only `h_exact` remains on the lemma. Estimated **highest-leverage** path: ~40–80 LOC, two new project-local helpers OK.

**Recommended path**:

1. **Introduce `SheafOfModules.exact_iff_stalkwise` as a new project-local helper** (alongside `SheafOfModules.epi_of_epi_presheaf` from iter-079). The Mathlib blueprint says: "A short complex of sheaves of $\mathcal R$-modules is exact iff its image under each stalk functor $(-)_x$ is exact." Implementation: multi-iteration TopCat-stalk preserves-exactness chain bridging `TopCat.Presheaf.stalkFunctor` to `SheafOfModules`. The blueprint already names this as `lem:sheafOfModules_exact_iff_stalkwise` (Differentials.tex L98–102). **Open question**: is the corresponding Mathlib helper present? Provers should `lean_local_search` + `lean_leansearch` for `SheafOfModules exact stalk` before assuming a gap.

2. **Identify the stalk** of `relativeDifferentials` with `_root_.KaehlerDifferential` over the local-ring stalks `(((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf).stalk x, X.presheaf.stalk x)`. Once the algebra-instance bridge holds, the ring-level Mathlib lemma applies.

3. **Apply Mathlib's `_root_.KaehlerDifferential.exact_mapBaseChange_map`** at each stalk. This closes the ring-level exactness.

4. **Hard constraints**:
   - Preserve byte-for-byte: `cotangentExactSeqBeta_hη` (iter-083, L341–411), `SheafOfModules.epi_of_epi_presheaf` (iter-079, L472–478), `Derivation.postcomp_comp` (iter-081, L489–500), Route (c) `h_zero` chain (iter-082, L522–593), `set_option maxHeartbeats 16000000 in` markers.
   - Preserve iter-084's `h_epi` proof (L641–677) byte-for-byte.
   - Use the iter-084 proven recipe (`hspan ▸ Submodule.mem_top` implicit-type + `Submodule.span_induction`) as a stylistic reference for any new span-induction work.

**Risk**: `SheafOfModules.exact_iff_stalkwise` may itself require a chain of stalk-functor preservation properties that aren't all in Mathlib. Plan agent should sequence: (a) attempt to find Mathlib lemma directly; (b) if absent, scope this as a Phase B multi-iter target with helper introduction allowed.

### 2. **Lane 1 — `BasicOpenCech.h_diff_pi_smul_f` Phase B closure (L1383)**

Both iter-083 typeclass barriers are now resolved by iter-084. The residual is genuine R-linearity content (~50–80 LOC of mechanical decomposition).

**Recommended path** (per the iter-084 task report's "Next session recipe"):

1. **Pick up at the post-rw form**: `Foo (r • e₁.symm y) = r • Foo (e₁.symm y)` where `Foo = (Pi.π Z₂ j).hom ∘ (eqToHom ∘ₗ Σ.hom)` and the two `letI hmod_pi_Z₁/Z₂` instances are in scope.
2. `generalize hz : (ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y = z` (or define a local R-linear map `Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)` via `LinearMap.mk` with explicit `map_smul'`).
3. Distribute the j-projection past `eqToHom ∘ₗ Σ.hom` via `LinearMap.coe_comp` + `Function.comp_apply` + `Finset.sum_apply`.
4. **Per-summand at fixed i**: identify the summand via `Pi.lift_π` + `Pi.π Z₁ k (e₁.symm z) = z k`.
5. `Pi.smul_apply` (with the named `perI₁` from iter-080) + `RingHom.map_mul` + `← C.left.presheaf.map_comp` to close the per-summand step.
6. `Finset.smul_sum` on RHS + `Finset.sum_congr rfl` to reassemble.

**Hard constraints**:
- Preserve byte-for-byte: the iter-084 `letI hmod_pi_Z₁/Z₂` + `show … rw [LinearEquiv.apply_symm_apply]` block at L1325 ff., the iter-080 `letI` refactor at L920–949, the iter-081 S2+S3+S4 chain at L1102–1153, the iter-082 S5 prelude at L1161–1170.
- Preserve `set_option maxHeartbeats 800000 in` at L418.
- Hard cap = 6 active sorries (no regression).

### 3. **Bonus — explore Lane 2 `h_exact` Mathlib status preemptively**

Before iter-085's main prover assignment, the plan agent should **read `Mathlib.Algebra.Category.ModuleCat.Sheaf.EpiMono` and adjacent files** to see whether `SheafOfModules.exact_iff_stalkwise` (or anything equivalent) exists upstream. If it does, the Lane 2 closure shrinks to ~20–40 LOC + apply existing lemma. If not, helper introduction is the iter-085 work.

---

## Approaches showing promise (carry-overs)

1. **Implicit-type span-membership via `hspan ▸ Submodule.mem_top`** *(NEW iter-084, KEY pattern)*: pivotal for any span-induction inside a bundled-ModuleCat / forget₂-image setup. Reusable across Lane 2 follow-ups (`h_exact` will likely need similar implicit-type membership for its stalkwise reduction) and potentially Lane 1 (if the per-summand decomposition uses `Submodule.span` anywhere). **Recommend documenting in `STRATEGY.md` proof-pattern table.**

2. **`refine ⟨?h_exact, ?h_epi⟩` conjunction split** *(iter-084)*: when a single absorbed sorry packages multiple semantically-distinct sub-claims, splitting them at the `refine` step lets the prover close one independently. Preserves the "no syntactic regression" rule (split sorry counts as one explicit sorry in the closed subgoal).

3. **`unfold cotangentExactSeqBeta` + `ModuleCat.Derivation.desc_d`** *(NEW iter-084, Differentials mem case)*: collapses `(isUniversal'.desc d).app U) (d b) = d.d b`. Reusable for any descent-vs-generator identification.

4. **`rw [map_add/map_smul, ha₁, ha₂]; rfl`** *(NEW iter-084, Differentials add/smul cases)*: when `rw` leaves a residual structural-equality goal `x + y = x + y`, trailing `rfl` closes it. `simp` overshoots and breaks the structural form. Reusable across all span-induction add/smul cases.

5. **`letI` binding under the literal target type** *(NEW iter-084, BasicOpenCech)*: `letI : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁` succeeds where `letI : Module ↑R ↑scK₀.X₁ := h_mod_X₁` fails, even though the two types are rfl. Typeclass search is syntactic. Reusable for any HSMul / typeclass-synthesis blocker where the goal's source type differs syntactically from the canonical abbreviation.

---

## Blocked targets (plan agent: do NOT assign these as primary)

| Target | Reason | Status |
|---|---|---|
| `Modules/Monoidal.lean L173 instIsMonoidal_W` | Mathlib gap on `PresheafOfModules.stalk_tensorObj` for varying-ring R₀ | Off-limits since iter-081 |
| `Jacobian.lean L179 nonempty_jacobianWitness` | Packages Phase C/E existence content | Indefinitely deferred (iter-086+) |
| `Picard/Functor.lean L190 PicardFunctor.representable` | Gated on Phase C C0–C3 scaffolding | Indefinitely deferred |
| `BasicOpenCech.lean L502, L826, L854` | Substep (a) and h_π_split blockers, gated on user-supplied hypothesis | Long-standing transients |
| `Differentials.lean L122, L961, L978, L1120` | Phase B infrastructure pending (`relativeDifferentialsPresheaf_isSheaf`, `smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`) | Long-standing transients |
| `BasicOpenCech.lean L1428 g_R.map_smul'` | Downstream of Lane 1 (`h_diff_pi_smul_f`) closure | iter-085+ after Lane 1 |
| `BasicOpenCech.lean L1457 h_loc_exact` | Needs `IsLocalizedModule.Away f.1` infrastructure | iter-085+ |

---

## Realistic iter-085 target

**Net −1 to −2 sorries (12–13 active)**. Best-case path:
- Lane 2 `h_exact` closure via stalkwise reduction (5 → 4 in Differentials).
- Lane 1 `h_diff_pi_smul_f` closure via per-summand `Φ_j` (6 → 5 in BasicOpenCech).

If `SheafOfModules.exact_iff_stalkwise` is absent from Mathlib and requires multi-iter helper construction, scope Lane 2 to **helper introduction** rather than `h_exact` closure (iter-085 lands the helper; iter-086 closes `h_exact`).

---

## Reusable proof patterns discovered (iter-084 — add to STRATEGY.md proof-pattern table)

1. **Implicit-type span-membership** (`have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)`): use this whenever the explicit-type `have hy : y ∈ Submodule.span ↑R ↑M ...` form forces synthesis of an unavailable bundled `Module` instance.

2. **`Submodule.span_induction` four-case template** (`induction hy using Submodule.span_induction with | mem | zero | add | smul`): standardized scaffold. `mem`: `obtain ⟨b, rfl⟩ := hx; refine ⟨preimage, ?_⟩; unfold the_map; exact KEY_d_lemma`. `zero`: `exact ⟨0, map_zero _⟩`. `add` / `smul`: `obtain ⟨…⟩; refine ⟨…, ?_⟩; rw [map_add, ha₁, ha₂]; rfl` (trailing `rfl` needed for the structural residual).

3. **`letI` under literal source type** (NOT the defeq abbreviation): typeclass search is syntactic.

4. **`show … rw [LinearEquiv.apply_symm_apply]` for `AddEquiv.module`'s smul-commutation**: `simp [Equiv.smul_def]` does NOT fire; explicit show + rw is the closer.

5. **Conjunction-split via `refine ⟨?h_A, ?h_B⟩`**: enables closing one branch independently of the other, even when a single absorbed sorry previously packaged both.
