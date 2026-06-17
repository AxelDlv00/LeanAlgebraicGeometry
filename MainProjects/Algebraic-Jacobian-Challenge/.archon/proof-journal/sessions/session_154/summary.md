# Session 154 — review summary

## Metadata

- **Iteration / session**: iter-154 = session_154.
- **Prover mode**: parallel, single lane on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.
- **Sorry count**: **8 → 7** (NET −1, declaration-level bare `sorry` bodies).
- **Target attempted**: `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM) — the chart-algebra critical-path lemma. **CLOSED, axiom-clean.**
- **Prover activity** (`attempts_raw.jsonl`): 11 edits, 1 goal check, 8 diagnostic checks, 2 builds, 5 lemma searches. No protected-signature change; no new axioms.

## Headline outcome — KDM CLOSED (independently verified)

`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` was a `sorry` blocked
across iters 149–153. It was declared **mathematically false as a bare B-only
lemma** (iter-151, two counterexamples `B = k×k`, `ℚ(√2)/ℚ`), repaired by the
iter-152 `[IsAlgClosed k]+[IsDomain B]` pivot, and its residual step **FT.3**
was classified a **genuine Mathlib gap behind a STRATEGY.md bright-line**
(iter-153). The iter-154 `mathlib-analogist` consult **OVERTURNED** that gap
verdict, supplying a verified single-element / perfect-field / Jacobi–Zariski
`H1Cotangent` route. The prover formalized it this iter.

**Independently verified this review:**
- `lean_verify AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  → axioms `{propext, Classical.choice, Quot.sound}` — **no `sorryAx`**.
- `lean_verify AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart`
  (downstream one-line delegate) → same three axioms — **no `sorryAx`**. The
  iter-151/152 `sorryAx`-laundering of this consumer is now genuinely resolved.
- `lean_diagnostic_messages` on `ChartAlgebra.lean` → `[]` (no errors, no warnings,
  no sorry). The file is **0-sorry and axiom-clean**.
- Both review subagents (lean-auditor, lean-vs-blueprint-checker) independently
  re-verified axiom-cleanliness and confirmed the proof is genuine, constructive,
  not vacuous, and matches the blueprint FT.1–FT.3 prose step-for-step.

## The closure (proof structure)

The proof is the analogist-verified route (`analogies/ftthree-kernel-iter154.md`),
three steps + two new private helpers:

- **(FT.1)** `set K := FractionRing B`; push `D_B b = 0` to `D_K (algebraMap B K b) = 0`
  via `← KaehlerDifferential.map_D k k B K b` + `map_zero`. `suffices algebraMap B K b ∈
  range(algebraMap k K)`, pulled back along the injective `B ↪ K`
  (`IsFractionRing.injective` + `IsScalarTower.algebraMap_apply`).
- **(FT.2)** `apply _algebraic_mem_range`; `by_contra` ⟹ `Transcendental k bK` ⟹
  `Function.Injective (Polynomial.aeval bK)` (`transcendental_iff_injective`). Embed
  `F := FractionRing (Polynomial k)` into `K` via `IsFractionRing.lift hg` (`letI :
  Algebra F K`); build `IsScalarTower k F K` via `IsScalarTower.of_algebraMap_eq` +
  `IsFractionRing.lift_algebraMap` + `Polynomial.aeval_C`. Then `EssFiniteType k K`
  (`.comp`) ⟹ `EssFiniteType F K` (`.of_comp`); `PerfectField F`
  (`PerfectField.ofCharZero`) ⟹ `FormallySmooth F K`
  (`Algebra.FormallySmooth.of_perfectField`) ⟹ `mapBaseChange k F K` injective (via
  `injective_iff_map_eq_zero` + `Algebra.H1Cotangent.exact_δ_mapBaseChange` +
  `Subsingleton.elim`). Identity `mapBaseChange (1 ⊗ D_F X_F) = D_K bK = 0`
  (`mapBaseChange_tmul` + `one_smul` + `map_D`) ⟹ `1 ⊗ D_F X_F = 0` ⟹ (faithful
  flatness, `Module.FaithfullyFlat.one_tmul_eq_zero_iff`) `D_F X_F = 0`.
- **(FT.3)** `_ratfunc_D_X_ne_zero` gives `D_F X_F ≠ 0` — contradiction ⟹ `bK`
  algebraic; `_algebraic_mem_range` lands it in range over alg-closed `k`.

### New private helpers
- `_ratfunc_D_X_ne_zero` (FT.3 base case): `D_{Frac(k[X])} X ≠ 0`, via
  `KaehlerDifferential.isLocalizedModule_map` + `IsLocalizedModule.eq_zero_iff` +
  `polynomialEquiv_D` + `nonZeroDivisors.coe_ne_zero`.
- `_algebraic_mem_range` (FT.3 closer): `IsAlgebraic k b → b ∈ range` over alg-closed
  `k`, via `IntermediateField.adjoin.finiteDimensional` + `Algebra.IsIntegral.of_finite`
  + `IsAlgClosed.algebraMap_bijective_of_isIntegral`.

### Two corrections to the analogist citation table (verified by the prover)
1. `KaehlerDifferential.isLocalizedModule_map` lives in `Mathlib.RingTheory.Etale.Kaehler`,
   NOT `...Kaehler.Localization` as the analogist table listed.
2. `isLocalizedModule_map` needs **all four explicit args** `R S T M`; the analogist's
   bare `_` did not unify here.

### Imports / opens added
- Imports: `Mathlib.RingTheory.Etale.Kaehler`, `...Kaehler.JacobiZariski`,
  `...Smooth.Field`, `...Flat.FaithfullyFlat.Basic`,
  `Mathlib.FieldTheory.IntermediateField.Adjoin.Basic`, `Mathlib.FieldTheory.Perfect`.
- Opens: `open scoped IntermediateField TensorProduct` (the `k⟮b⟯` adjoin notation and
  `⊗[F]`/`⊗ₜ` tensor notation are both `scoped`).

### Hygiene done by the prover
- Removed the dead `_mvPoly_*` free-case helpers (4 declarations + the `(BR.5) helper
  machinery` doc block) — they targeted the abandoned transcendence-basis route.
- Rewrote the KDM docstring + file-header status bullet to describe the closed route
  (removed the stale "Mathlib gap / bright-line STOP / residual sorry" narrative).

## Per-file sorry tally at iter-154 close (re-verified)

- `Cotangent/ChartAlgebra.lean` — **0** (was 1; KDM closed).
- `Cotangent/ChartAlgebraS3.lean` — 4 (off-path, **orphaned** — see Findings).
- `Cotangent/GrpObj.lean` — 0.
- `Jacobian.lean` — 2 (L197 `genusZeroWitness`, L223 `positiveGenusWitness`).
- `RigidityKbar.lean` — 1 (L88 `rigidity_over_kbar`).
- **Total: 7.**

## Review-phase subagents (2 dispatched, both COMPLETE, mutually + prover-consistent)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-auditor` | iter154 | **0 must-fix** / 5 major / 4 minor | "The iter-154 KDM rewrite is the real thing — compiles, axiom-clean, no sorry, not vacuous, comments match the proof." Majors: (1) **`ChartAlgebraS3.lean` fully orphaned** (4 dead sorries + dead import at `ChartAlgebra.lean:6`); (2) `GrpObj.lean` `shearMulRight` falsely tagged `NEEDS_MATHLIB_GAP_FILL` (fully proven); (3) `GrpObj.lean` piece-(i.b) headers narrate iter-145-excised lemmas as live; (4)+(5) pre-existing authorized scaffold sorries (Jacobian, RigidityKbar). |
| `lean-vs-blueprint-checker` | chartalgebra-iter154 | **0 must-fix** / 2 major / 2 minor | KDM closure faithful + axiom-clean; FT.1–FT.3 prose matches Lean step-for-step; signatures exact. 2 major = stale blueprint `% NOTE`s asserting an eliminated KDM `sorryAx` (L1934–1943 + L2509–2517) — **both fixed this review** (see Blueprint markers). Minor: stale statement-block `\uses` at L2340 (deferred). |

Reports: `task_results/lean-auditor-iter154.md`,
`task_results/lean-vs-blueprint-checker-chartalgebra-iter154.md`.

## Key findings / patterns

- **The analogist-verified-by-compilation route is high-leverage.** The 8 type-checking
  `example` blocks in `analogies/ftthree-kernel-iter154.md` let the prover formalize a
  research-grade lemma (declared a Mathlib gap one iter earlier) in a single ~841s lane.
  The two citation-table corrections the prover had to make (module path + explicit
  args) were small relative to the verified spine.
- **`lean_verify` axiom-check confirms the laundering is genuinely resolved**, not just
  relabelled: both KDM and its delegate are now `sorryAx`-free. This is the first time
  since iter-151 that the warning-based sorry count does NOT undercount the unsound
  surface in this file.
- **Cleanup opportunity surfaced**: `ChartAlgebraS3.lean` (4 sorries) is now provably
  orphaned dead weight under the alg-closed pivot — deleting it would drop the global
  count 7 → 3. See recommendations.

## Blueprint markers updated (manual)

- `RigidityKbar.tex`, `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  proof-block NOTE (L1934–1943): replaced the stale iter-152 `sorryAx`-laundering
  warning with an iter-154 NOTE recording that KDM is closed axiom-clean and the
  delegate is now genuinely `sorryAx`-free (verified).
- `RigidityKbar.tex`, `lem:Scheme_Over_ext_of_diff_zero` NOTE (L2509–2517): refreshed
  the stale iter-147 "KDM still carries a structured sorry" gate to record the iter-154
  KDM closure (gate lifted).
- No `\mathlibok` added (the closed declarations are project proofs, not Mathlib
  re-exports). No `\leanok` touched (sync_leanok's domain). No `\lean{...}` rename needed.

## Recommendations for next session

See `recommendations.md`. Headline: KDM closed ⟹ `rigidity_over_kbar`
(`RigidityKbar.lean:88`, M2.a keystone) is the unblocked next critical-path target.
Strongly consider the `ChartAlgebraS3.lean` deletion (7 → 3 sorries) and the GrpObj
stale-comment cleanup.
