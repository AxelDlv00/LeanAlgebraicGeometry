# Recommendations for the next plan-agent iteration (iter-084)

## Net iter-083 summary

- Sorry count: 14 → 14 (no regression; no source-level closure).
- Two lanes ran (BasicOpenCech, Differentials). Modules/Monoidal off-limits.
- **One helper landed top-level fully closed**: `cotangentExactSeqBeta_hη` at Differentials.lean L341–411. This is a *structural* advance: the iter-082 inline 30-LOC `hη` construction is now externally callable, removing one obstacle from `cotangentExactSeqBeta`'s body and unblocking iter-084's `h_epi` work.
- **Two structural findings** on BasicOpenCech that revise iter-082's path-(a) recipe:
  - **NEW Finding 1**: `letI`-surfaced R-module on ↑scK₀.X₁ does NOT bridge `HSMul ↑R ↑(∏ᶜ Z₁)` when type-ascription propagates inward. Defeq `↑(∏ᶜ Z₁) = ↑scK₀.X₁ := rfl` does not flow through instance synthesis.
  - **NEW Finding 2**: `e₁.symm (r • y) = r •_{AddEquiv.module} e₁.symm y` is not rfl — requires `e₁.apply_symm_apply` collapse on the inner argument.
- Lane 2 conditional clause respected (no 5 → 6 regression via free-floating `exact_iff_stalkwise`).
- The iter-083 plan's path (a) "named-comp abbreviation" with ~30 LOC estimate is now **revised to 50–80 LOC, multi-iter** based on the new typeclass-coercion barrier findings.

The plan agent should now commit to a **single chosen path** on each lane for iter-084
rather than the iter-076 → 083 pattern of attempting multiple routes serially without
closure. Crucially, the iter-083 prover task report identifies the correct construction
to pursue on each lane — adopt those verbatim.

---

## Headline targets (highest leverage)

### 1. **Lane priority — `BasicOpenCech.h_diff_pi_smul_f` Phase B closure via per-summand `Φ_j` construction**

**Iter-083 finding revises iter-082's path-(a) recipe.** Do NOT pursue the
"name M then prove M.map_smul'" route — the new findings show the typeclass
barrier persists across `letI` surfacing AND the smul-commutation step is not rfl.

**Recommended iter-084 path — per-summand R-linear map at target carrier**:

1. **Skip** the `let M : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := …` k-linear abbreviation. k-linear is the wrong refinement (k ≠ R).

2. **Construct directly** the per-summand R-linear map
   ```lean
   Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)
   ```
   via `LinearMap.mk` with explicit `map_smul'`. The `map_smul'` proof unfolds the
   sum, fires `Pi.smul_apply` on `(r • y) (j ∘ δ_i.toOrderHom)` for each summand,
   uses `(perI₁ (j ∘ δ_i.toOrderHom)).smul r (y _) = ((presheaf.map _ _).hom r) * y _`
   per the iter-080 named-perI₁ lemma, and applies `RingHom.map_mul` on
   `(toModuleKPresheaf C).map (φ_i j).op .hom`. The presheaf chain collapses
   via `← C.left.presheaf.map_comp`; the result matches `r •_{perI₂ j} (Φ_j y)`.

3. **Bridge to the goal** via `Φ_j.map_smul r y` then `congr 1` on the outer
   `(Pi.π Z₂ j).hom`. The eqToHom cast on either side is over the same restriction
   map (since both sides are at the same presheaf level), so it collapses
   per-summand.

4. **Hard constraints (preserve byte-for-byte)**:
   - `set_option maxHeartbeats 800000 in` at L418.
   - iter-080 `letI` refactor at L920–949.
   - iter-081 S2+S3+S4 chain at L1102–1153.
   - iter-082 S5 prelude at L1161–1170.
   - iter-083 `letI := h_mod_X₁; letI := h_mod_X₂` no-ops at L1240 (now L1321).

5. **Sorry budget**: starts at 6; target ≤ 5 (close `h_diff_pi_smul_f`); hard cap 6.

**Estimated cost**: 50–80 LOC of `Φ_j` construction + map_smul' proof; likely 1
prover session if the construction is sequenced cleanly, possibly 2 if `Φ_j`'s
type elaboration requires intermediate `letI`s.

**Mathlib references** (verified iter-083):
- `LinearMap.mk` (builder).
- `Pi.smul_apply`, `Finset.sum_apply`, `Finset.smul_sum`.
- `LinearMap.coe_sum`, `LinearMap.pi`.
- `RingHom.map_mul`, `← C.left.presheaf.map_comp`.
- Project-local `algebraMap_naturality` (StructureSheafModuleK.lean L161).

**Approaches confirmed dead-end iter-083** (do NOT re-attempt):
- `simp only [LinearMap.comp_apply, LinearMap.coe_comp, Function.comp_apply]` —
  no progress (`∘ₛₗ`-vs-`∘ₗ` HOU mismatch).
- `rw [LinearMap.comp_apply]` — pattern not found.
- `show … ((... ∘ₗ ...) _) = _` with explicit `∑ i, (-1)^(↑i : ℤ) • _` —
  `Fintype ℤ` synthesis failure.
- `subst hRel` — `n` occurs inside `prev n` as reference.
- `rw [hRel] at *` — duplicate var pollution; `clear` fails due to dependencies.
- `(r • e₁.symm y : ↑scK₀.X₁) := rfl` ascription — typeclass-propagation source-side mismatch.
- `letI := h_mod_X₁; letI := h_mod_X₂` alone (sufficient to surface instances, not to bridge defeq through synthesis).

---

### 2. **Lane priority — `Differentials.cotangentExactSeq_structure h_epi` via `span_range_derivation`**

**Iter-083 helper landed**: `cotangentExactSeqBeta_hη` at L341–411 is now externally
callable via `.choose`/`.choose_spec`. This *unblocks* the next attempt because
the inline `hη` derivation no longer interferes with `letI`-sequencing.

**Recommended iter-084 path — Option (c) from iter-083 task report: `Submodule.range = ⊤` via `span_range_derivation`**.

This route SKIPS the bundled-vs-unbundled `KaehlerDifferential.map` identification
entirely. Instead:

1. **`h_epi`**: apply `_root_.SheafOfModules.epi_of_epi_presheaf` + `PresheafOfModules.epi_iff_surjective` to reduce to surjectivity of `((cotangentExactSeqBeta f g).val.app U).hom` at each open `U`.

2. **Show surjectivity directly via range = ⊤**: use `_root_.KaehlerDifferential.span_range_derivation` (or its `_root_.PresheafOfModules.Derivation.span_range_derivation` analogue if it exists, verify with `lean_local_search`) to show the range contains all `d b` and is therefore the whole module.

3. **Key step**: the descent's action on `d b` is computable via `desc_d`. Use the now-external `hη` (from `cotangentExactSeqBeta_hη.choose_spec`) + `congr_arg (NatTrans.app · U) hη` + `Category.comp_id` to identify the action with `d (η.app U .hom b)` for the right η component.

4. **Carefully sequence `letI := f.hom.toAlgebra` etc. OUTSIDE the goal context** (not inside) to avoid the bundled `Module ((relativeDifferentials f).val.obj U)` instance clash. The iter-083 task report explicitly notes that fresh-instance introductions via `algebraize` clash with the bundled `letI` inside `CommRingCat.KaehlerDifferential`'s body.

**Sorry budget**: starts at 5; target ≤ 4 if `h_epi` closes alone (leaves `h_exact` as remaining absorbed sorry — would require splitting `case h_rest` into separate `h_exact` and `h_epi` cases, adding one new sorry at intermediate but closing one). **Decision**: split case h_rest into `⟨?h_exact, ?h_epi⟩` only IF `h_epi` is genuinely going to close — otherwise leave the absorbed sorry to preserve 5 → 5.

**Conditional clause for iter-084 (mandatory)**: if `h_epi` does NOT close, the prover MUST revert any split and preserve the single absorbed sorry. Lane 2 must not regress 5 → 6.

**Mathlib references** (verify with `lean_local_search` before invoking):
- `_root_.KaehlerDifferential.span_range_derivation` — surjectivity of the derivation map.
- `_root_.KaehlerDifferential.map` + `map_d` — derivation action on generators.
- `_root_.SheafOfModules.epi_of_epi_presheaf` (iter-079, preserved).
- `_root_.PresheafOfModules.epi_iff_surjective` (Mathlib).
- `Category.comp_id`, `congr_arg (NatTrans.app · U) hη` (extracting per-open coherence).

**Approaches confirmed dead-end iter-083** (do NOT re-attempt):
- `convert _root_.KaehlerDifferential.map_surjective` — iff residual with full Π-type RHS.
- `convert ... using 1` — identical iff residual with `.hom` exposed.
- `exact _root_.KaehlerDifferential.map_surjective` — type mismatch on Π-type.
- `obtain ⟨η, hη⟩ := cotangentExactSeqBeta_hη f g` inside the `noncomputable def` body — `Exists.casesOn` cannot eliminate into `Type _`. **MUST USE `.choose`/`.choose_spec`**.

---

### 3. **DO NOT assign — long-standing blocked targets**

- `Modules/Monoidal.lean` L173 `instIsMonoidal_W` — Mathlib gap (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀). Defer pending Mathlib PR or user-authorised axiom.
- `Jacobian.lean` L179 `nonempty_jacobianWitness` — packages Phase C/E existence. Scheduled iter-086+.
- `Picard/Functor.lean` L190 `PicardFunctor.representable` — gated on Phase C C0–C3.

### 4. **DO NOT assign — secondary BasicOpenCech sorries**

- L502, L826, L854 — extra-degeneracy and `h_π_split` substeps; multi-iter blockers.
- L1368 `g_R.map_smul'`, L1397 `h_loc_exact` — downstream of `h_diff_pi_smul_f`, gated on Lane 1 closure.

### 5. **DO NOT assign — secondary Differentials sorries**

- L122 `relativeDifferentialsPresheaf_isSheaf` — Phase B step 1, deferred.
- L929 `smooth_iff_locally_free_omega`, L946 `cotangent_at_section`, L1088 `serre_duality_genus` — Phase B downstream, deferred.

---

## Reusable proof patterns discovered iter-083

1. **`.choose`/`.choose_spec` inside `noncomputable def` body** — when destructuring `∃ ...` inside a non-Prop-returning `def`, `obtain ⟨a, b⟩ := h` fails because `Exists.casesOn` cannot eliminate `Prop` into `Type _`. Use `Classical.choose` / `Classical.choose_spec` (or `.choose`/`.choose_spec` notation) instead.

2. **`change` over `show` when linter style is strict** — `show` triggers `linter.style.show` warnings when it changes the goal direction; `change` is the safer rewriter for matching elaborated goal forms.

3. **Helper extraction protocol for noncomputable defs** — when an inline `let η := ...; have hη : ... := ...` block can be lifted to a top-level lemma, package it as `∃ η, <coherence>` (existential, not `def` with bundled property) so that the caller can use `.choose`/`.choose_spec` inside their own `noncomputable def` body. This sidesteps the `Exists.casesOn` elimination restriction.

4. **Documentation as structural advance** — when no source-level closure lands, embedding a substantial findings block (~80 LOC) inline in the file BEFORE the sorry is a legitimate iter contribution: it makes the next iter's prover work cheaper and prevents redundant attack repetition. iter-083 Lane 1 used this pattern.

---

## Suggested iter-084 lane configuration

- **Lane 1**: BasicOpenCech `h_diff_pi_smul_f` via per-summand `Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)` construction. Target 6 → 5; hard cap 6.
- **Lane 2**: Differentials `h_epi` via `span_range_derivation` route (Option c). Target 5 → 4 if `h_epi` closes alone (split case h_rest); hard cap 5 (must revert split if `h_epi` fails).
- **Lane 3**: not assigned (Modules/Monoidal remains off-limits).

Realistic iter-084 target: **net −1 to −2 sorries** (12–13 active).
Best-case: Lane 1 Phase B closure (6 → 5) + Lane 2 `h_epi` closure (5 → 4) = **12 active**.
Worst-case: both lanes preserve current state with further structural advances (still 14, but with reduced barrier surface).

---

## Process discipline notes

- iter-083 ran 9 source edits (4 on BasicOpenCech: 2 `letI` insertions + 1 comment block + 1 task_result write; 5 on Differentials: helper extraction + cotangentExactSeqBeta refactor + 3 Route 2 attempts).
- 0 `lean_run_code` pre-validation (per user policy 2026-05-11).
- 12 `lean_diagnostic_messages` calls (within budget).
- 35 lemma searches (the highest of the iter-079 → 083 chain — reflects the careful Mathlib-API hunting on both lanes).
- `lean_multi_attempt` used productively for position-bound tactic-attempt previews on Lane 1 (events 25, 33, 35, 37, 51, 53, 55, 57).
- Both lanes' conditional clauses respected (no free-floating sorry regressions).
- One helper successfully extracted and closed top-level, demonstrating that the "helpers in prover's own session" policy (user 2026-05-11) works when the helper is self-contained.
