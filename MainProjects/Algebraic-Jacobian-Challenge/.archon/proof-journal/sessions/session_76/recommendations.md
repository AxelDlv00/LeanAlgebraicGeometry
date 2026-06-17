# Recommendations for the next plan-agent iteration (iter-077)

## TL;DR

iter-076 successfully RESTORED COMPILATION on both `Differentials.lean` and `BasicOpenCech.lean` (was the explicit repair goal). Net cost: +2 sorries (14 → 16), within plan budget. The project is back to "all files compile cleanly" — the prerequisite for any forward feature work. iter-077 should resume targeted closure attempts, now with the corrected `lean_diagnostic_messages`-per-edit dev loop.

---

## Highest-priority closure targets for iter-077

### Priority 1 — `Differentials.lean : cotangentExactSeqAlpha` (currently sorry, L207)

**Plan-agent had a complete error inventory this iter; the prover rolled back rather than apply the fixes (correct triage when 5 errors land together). Iter-077 should re-apply the fixes one-at-a-time with `lean_diagnostic_messages` after each.**

Specific re-attempt recipe (per plan-agent's iter-076 instructions + prover's lane-1 task result):

1. **L244** (`d_target.d`'s `AddMonoidHom.mk'` additivity): replace `(by intro a b; simp)` with `(by intro a b; rw [(f.c.app U).hom.map_add, D_X.d_add])`.
2. **L248** (`d_target.d_mul`): prepend `show D_X.d ((f.c.app U).hom (a * b)) = a • D_X.d ((f.c.app U).hom b) + b • D_X.d ((f.c.app U).hom a)` before the `rw`, then `rw [(f.c.app U).hom.map_mul, D_X.d_mul]; rfl`.
3. **L256** (`d_target.d_map`): type-annotate the `h` in `congr_arg` — `congr_arg (fun h : _ ⟶ _ => (ConcreteCategory.hom h) x) (f.c.naturality f')`, or pre-bind via `let h_eq := f.c.naturality f'`.
4. **L258** (same shape as L248): insert explicit `show` to commit `(f.c.app V).hom (Y.presheaf.map f' x)` form before the `rw`.
5. **L266** (`d_target.d_app`'s `hcomm` step): derive `hcomm : φ_g' ≫ f.c = adj_f.unit ≫ pushforward.map φ_fg'` via `Adjunction.homEquiv_naturality` + `Equiv.symm_apply_eq` (NOT `rfl` — the adjunction-coherence across `(f ≫ g).base = g.base ≫ f.base` is not definitional).

After each fix lands cleanly: re-attempt the next one. Iter-076 prover's rollback comment names each blocker site.

### Priority 2 — `Differentials.lean : cotangentExactSeqBeta` (currently sorry, L232)

**Recovery routes for iter-077 (both viable)**:
- **Route A (simpler)**: prepend `set_option maxHeartbeats 400000 in noncomputable def cotangentExactSeqBeta ...`. Eliminates the L297/L342/L343 200k-hb timeout.
- **Route B (cleaner)**: inline `η` rather than `set η`-ing it. The `set` introduces an opaque alias that the downstream rewrites have to unfold each time, blowing heartbeats.

Either route + removal of the redundant `exact h4` at original L332 should land Beta. Apply with `lean_diagnostic_messages` after each save.

### Priority 3 — `Differentials.lean : cotangentExactSeq_structure` (currently single sorry, L266)

**Blocked behind Priorities 1+2**. Once `cotangentExactSeqAlpha` and `cotangentExactSeqBeta` compile, re-enable the disabled `h_zero` Steps 1–7 chain preserved verbatim as a `/- ITER-076 disabled chain ... -/` block comment in the file. The chain was structurally well-understood before iter-076; re-enabling should produce two sub-sorries (`h_exact`, `h_epi`) matching the pre-iter-076 state, with the residual `_structure.h_zero` Step 7 sorry that iter-075 had narrowed.

### Priority 4 — `BasicOpenCech.lean : f_R.map_smul' / g_R.map_smul'` (currently sorry, L1106 / L1116)

**Root cause diagnosed iter-076**: `convert h` for `h_mod_X_i` produces an instance that is propositionally — not definitionally — equal to `e_i.toAddEquiv.module R`. The `r • x = e_i.symm (r • e_i x)` step fails by `rfl` because the smul comes from the convert-derived instance, not from `e_i.toEquiv.smul R`.

**Iter-077 recipe**:
1. **Rebuild `h_mod_X_i` via explicit `Eq.mpr`** over a manual `↑scK₀.X_i = ↑(∏ᶜ Z_i)` equality. For X₃ specifically, use the iter-076-verified pattern `have h_eq : scK₀.X₃ = K₀.X (n + 1) := by show K₀.X ((ComplexShape.up ℕ).next n) = K₀.X (n + 1); rw [CochainComplex.next]; rw [h_eq]; ...` BEFORE the dsimp. Goal: ensure the resulting `Module R scK₀.X_i` instance is LITERALLY `e_i.toAddEquiv.module R`.
2. With that instance in hand, the iter-072 `calc` chains in `f_R.map_smul'` / `g_R.map_smul'` work as written — the `congr 1` for `r • x = e_i.symm (r • e_i x)` closes by `rfl`.

### Priority 5 — `BasicOpenCech.lean : h_diff_pi_smul_f` (currently sorry, L1077)

**Blocked behind Priority 4**. Once `h_mod_X_i` is rebuilt with literal-canonical instances, re-attempt via the documented S1–S8 + sign-peel + sign-free 5-step recipe preserved in the rollback comment header. The iter-073/074/075 staircase hopeful framing (`Finset.sum_congr rfl fun k _ => ?_` after a 5-layer simp set) is unreachable — the simp set does NOT expose alternating-sum form. The S1–S8 recipe (per-summand decomposition before the simp) is the correct approach.

---

## Reusable proof patterns discovered iter-076

1. **`ComplexShape.next` opaqueness bridge**: any term of the form `K.X ((ComplexShape.up α).next i)` (similarly `prev`) needs an **explicit rewrite** via Mathlib `CochainComplex.next : (ComplexShape.up α).next i = i + 1` (resp. `prev`). The dsimp set will NOT unfold it because `ComplexShape.next` is defined via `Classical.choose` over `Rel`. Verified on `h_mod_X₃` repair, iter-076.

2. **Instance literality via type-equality pre-rewrite**: when downstream tactics need a canonical instance (`e.toAddEquiv.module R`), pre-rewrite the carrier type via `Eq.mpr` over a manual type equality BEFORE building the instance — don't use `convert` (which produces propositionally-but-not-definitionally equal instances).

3. **`lean_diagnostic_messages`-per-edit dev loop**: the corrected feedback loop. Edit → save → diagnostics. Replaces the iter-074/075 "commit credible tactics without LSP verification" policy that produced the iter-076 broken state.

4. **Block-comment hygiene for reference blocks**: `/- ... -/` (not `/-! ...`) with stray `sorry` inside neutralized as `-- (sorry)` to avoid lean counting them syntactically.

---

## Targets the plan agent should NOT assign iter-077

- **`Jacobian.lean : nonempty_jacobianWitness`** (L177) — Phase C re-opened iter-076 but Lean-side closure is iter-085+ at earliest (Modules.Monoidal scaffolding due iter-077 via refactor subagent).
- **`Picard/Functor.lean : PicardFunctor.representable`** — gated on C0–C3.
- **`BasicOpenCech.lean : h_π_split` analogue (L819)** — confirmed dead-end since iter-064. Stays sorry.
- **`BasicOpenCech.lean : extra-degeneracy substeps (L495, L847)`** — confirmed dead-ends since iter-061+. Stay sorry.
- **`BasicOpenCech.lean : h_loc_exact (L1145, was L1260)`** — downstream of Priorities 4+5 above. Don't attack directly; comes for free once `h_diff_pi_smul_f` closes.
- **`Differentials.lean : relativeDifferentialsPresheaf_isSheaf` (L122)** — multi-iteration Phase B placeholder; one-line Mathlib closure confirmed dead-end. Stays sorry.
- **`Differentials.lean : smooth_iff_locally_free_omega (L543), cotangent_at_section (L559), serre_duality_genus (L703)`** — downstream Phase B/D placeholders.

---

## Cross-iteration meta-observations

1. **The iter-074/075 commit-without-verification policy produced the iter-076 broken state.** Five+ iterations of the P-1 staircase pattern (each iteration narrowing the trailing sorry's footprint) had accumulated tactic chains that were never verified against actual diagnostics. The "build env broken" framing masked this — `lean_diagnostic_messages` worked fine all along.

2. **Plan-agent's iter-076 corrective dispatch (repair-only, no new feature work, diagnostics-per-edit, accept rollbacks)** was the right move. Both lanes landed within budget. Iter-077 should preserve this discipline.

3. **`lean_multi_attempt` returns empty `diagnostics: []` for failing snippets** — flagged via `.debug-feedback/`. Provers should not infer success from empty multi_attempt diagnostics; use edit + `lean_diagnostic_messages` as the source of truth.

4. **Realistic iter-077 closure target**: under the corrected dev loop, **−2 to −4 sorries** is achievable. Priority 1+2 should land in iter-077; Priority 3 cascades to two sub-sorries (which need `SheafOfModules.epi_of_epi_presheaf` and similar helpers — still confirmed absent from Mathlib, must remain sorries unless plan-agent reverses the "no thin helpers" feedback policy specifically for these). Priority 4 (instance-literality rebuild) is a single-iter closure if `Eq.mpr` route works as designed. Priority 5 is iter-078+.

---

## Open question for plan agent

The iter-075 PROJECT_STATUS noted the project needs the helpers `SheafOfModules.epi_of_epi_presheaf` and `SheafOfModules.exact_iff_stalkwise` (Mathlib gaps confirmed iter-074/075). These do not violate the "no chains of thin helpers across iterations" feedback memory — they are **single Mathlib-gap fillers**, not chains. Suggestion: explicit plan-agent ruling that staging *one* such helper per iteration is acceptable, distinct from the forbidden "chains of thin helpers" pattern. Otherwise iter-077's Priority 3 (`cotangentExactSeq_structure.h_zero`/`h_exact`/`h_epi` closure) remains blocked indefinitely.
