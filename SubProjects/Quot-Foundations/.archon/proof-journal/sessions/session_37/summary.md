# Session 37 (iter-037) — Review Summary

## Metadata
- **Iteration**: 037 · **Session**: session_37 · **Model**: claude-opus-4-8 (provers)
- **Active sorry per file (before → after)**:
  - `FlatBaseChange.lean` 4 → 4 (sites @1700 `_legs_conj`, @2167 `gstar_transpose`, @2348 A2 `affineBaseChange_pushforward_iso`, @2370 `flatBaseChange_pushforward_isIso`). **NOT edited this iter.**
  - `QuotScheme.lean` 4 → 4 (the 4 protected scaffold stubs `hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`Grassmannian.representable`; the 2 new decls add ZERO sorry).
  - `GrassmannianCells.lean` 0 → 0 (+3 new axiom-clean decls).
- **Targets attempted**: 3 lanes (FBC-A1 `gstar_transpose`, QUOT-Hfr, GR-E3full).
- **Net**: +5 axiom-clean declarations (GR 3, QUOT 2); 0 sorry eliminated. GR-E3full lane **CLOSED**.
- **Build**: GREEN (GrassmannianCells 8317 jobs/33s; QuotScheme 8317 jobs; FBC unchanged green). All new decls `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
- **sync_leanok** (iter 37, sha `a4c1e7d`): **+6 `\leanok`, 0 removed** (chapters: Picard_GrassmannianCells, Picard_QuotScheme).
- **leandag**: gaps=0, unmatched=14 (coverage debt — see recommendations).
- **blueprint-doctor**: 0 findings (no orphan chapters, no broken refs/uses, no axioms).

## Per-target detail

### GR-E3full — `existence_factor_through_valuationRing` (SOLVED, lane closed)
The last open matrix-algebra gap of the Grassmannian valuative-criterion existence step. Three axiom-clean decls:
- **`det_one_updateCol`** (private, @1645): `((1).updateCol p v).det = v p`. Route: `Matrix.cramer_apply` (reverse) → `(1).cramer v p`, then `Matrix.mulVec_cramer` + `Matrix.one_mulVec` + `Matrix.det_one` + `one_smul`. KEY: `Matrix.det_updateColumn` does NOT exist; the column-substituted-identity determinant has **no sign** — it is exactly `v p`.
- **`exists_minorDet_eq_free_entry`** (NEW public, @1661): for `q ∉ J`, row `p`, ∃ `K' = insert q (J.erase j_p)` (card `d`) with `minorDet J K' = ± X(p,⟨q,hq⟩)`. Route: column map `colMap k := if k=p then q else J.orderIsoOfFin hJ k`; submatrix `X^J.submatrix id colMap = (1).updateCol p v` (uses `X^J_J = 1`); `Matrix.det_permute'` + `Int.units_eq_one_or` give the ± sign. Pitfalls handled: `set`-bound functions need `simp only [hdef]` beta-reduce before `rw [if_pos/if_neg]`; `Matrix.ext` (not bare `ext`, which descends into `MvPolynomial.coeff`); fixed `Finset.card_insert_of_not_mem` → `_notMem`.
- **`existence_factor_through_valuationRing`** (pinned `lem:gr_existence_factor_through_valuation_ring`, @1775): `g = f' ∘ θ̃_{I,J}` sends every generator into `(algebraMap R K).range`. `hminorR` (minor values land in R) via `existence_lift_transitionPreMap_minorDet_mul` + `hJmax` bound + `le_of_mul_le_mul_right` cancel of the nonzero `v(f(P^I_J))` + `ValuationRing.range_algebraMap_eq`/`Valuation.mem_integer_iff`; `hgen` via `exists_minorDet_eq_free_entry` (+`neg_mem`); closure via `MvPolynomial.induction_on` (tags **`C`/`add`/`mul_X`**, NOT `h_C`/`h_add`/`h_X`). The defeq `g x = lift(θ̃ x)` holds via `key := fun _ => rfl`.

### QUOT-Hfr — two transport bridges (PARTIAL: ingredients landed, assembly deferred)
Two Mathlib-absent `IsLocalizedModule`-transport bridges, both axiom-clean, non-private:
- **`isLocalizedModule_of_ringEquiv_semilinear`** (@1670, ingredient I): transport `IsLocalizedModule S g` to `IsLocalizedModule (S.map σ) h` across a ring iso `σ : R ≃+* R'` + a pair of σ-semilinear `AddEquiv`s. Direct three-field construction; `map_units` via `Module.End.isUnit_iff` (the `N₂`-End conjugate via `e₂` to the unit `M₂`-End); `surj`/`exists_of_eq` pull/push through `eᵢ`. Mathlib only has same-ring `of_linearEquiv`/`_right` — crossing a ring iso is the genuine gap. Pitfall: submonoid-smul vs R-smul mismatches fixed by defeq `have`s.
- **`isLocalizedModule_restrictScalars_powers_algebraMap`** (@1720, ingredient II): from `IsLocalizedModule (powers (algebraMap R Rr f)) g` (`g` Rr-linear), prove `IsLocalizedModule (powers f) (g.restrictScalars R)`. Each field maps `f^n ↔ (algebraMap R Rr f)^n` via `map_pow` + `algebraMap_smul`; `map_units` via `Module.End.isUnit_iff` (same underlying function).
- **Hfr assembly + named `isLocalizedModule_basicOpen_descent` + gap1 — NOT attempted as compiling decls.** Blocker: the **semilinearity of `gammaPullbackImageIso.hom` over the per-stage structure-sheaf ring iso** `σ_V : Γ(Y, j ''ᵁ V) ≃+* Γ(U,V)` — a SheafOfModules-pullback / open-immersion module-structure compatibility, its own substantial sub-build. With (I)+(II) in hand the assembly reduces to producing those `σ`'s + semilinearity, then a mechanical three-stage chain (`pullback (q.X i).ι`, `pullback (...⁻¹ᵁ D(r)).ι`, `pullback isoSpec.inv`). **Dead-end recorded:** do NOT apply (I) with `σ := (R_r ≅ R)` — `R_r` and `R` are NOT isomorphic; the `σ`'s are between section rings of isomorphic opens, the `R_r → R` descent is (II)'s job.

### FBC-A1 — `gstar_transpose` (BLOCKED — clean assembly pass closed nothing; TRIPWIRE FIRED)
No code edits this iter. The investigation confirmed every "sentence" of the proof is already a named lemma (Sentence 1 `gstar_counit_transport`/`huce` master identity, Sentence (b) `gstar_generator_close`), but **both** the inline step-(a) reindex AND the crux `base_change_mate_fstar_reindex_legs_conj` (@1647, sorry @1700) are the SAME obstruction:
- The concrete-leg route is walled by a **dependent-motive obstruction** — `pullback.fst` is only *propositionally* equal to `e.hom ≫ Spec ιA`, and the codomain-read argument bakes the leg into its type, so `rw [hfst]`/`subst` fail "motive is not type correct" (confirmed directly: `rw [← hW]` on the main goal → "motive is not type correct").
- The parametrised-leg conjugate discharge `_legs_conj` needs three UNBUILT pieces: the conjugate-injective **reframing keystone** (express the post-`subst` section composite as a single `conjugateEquiv` component so `.injective`/`.surjective` apply), `conj-2b` `…_reindex_conj_pullbackLeg`, and `conj-2d` `…_reindex_conj_crossLayer`. (`conj-2c` `…_reindex_conj_pushforwardCollapse` @1626 is proved.)
- Step (c) telescoping: `rw [← Functor.map_comp]` cleanly fuses the two Γ-factors of `huce` into the section-identity shape, but the remaining ~100-LOC glue (isolate `ε_g` via `huce` at sheaf level + `β`-naturality + dictionary cancellation) is unbuilt and explicitly off the blind-`rw` route (X.Modules-diamond do-not-retry notes).

**TRIPWIRE FIRED** (closed neither `gstar_transpose` nor a compiling inline step-(a) lemma). Per the enforced protocol, iter-038 dispatches a **mathlib-analogist** (cross-domain-inspiration) on the reframing keystone — NOT another assembly/helper round, NOT user escalation.

## Key findings / patterns discovered
- **Column-substituted-identity determinant via cramer (no sign).** `((1).updateCol p v).det = v p` through `Matrix.cramer_apply` + `Matrix.mulVec_cramer` — Mathlib lacks a direct `det_updateColumn`; the result has no sign.
- **`IsLocalizedModule` across a ring iso is Mathlib-absent.** Build the three fields directly with σ-semilinear `AddEquiv`s as plain-equation hypotheses (`eᵢ (a • x) = σ a • eᵢ x`) to avoid semilinear-composition typeclass plumbing; conjugate the `End`-units via `e₂`.
- **`MvPolynomial.induction_on` case tags are `C`/`add`/`mul_X`** (not `h_C`/`h_add`/`h_X` — that errors "Invalid alternative name").
- **The FBC concrete-leg dependent-motive wall is confirmed structural, not tactical.** `rw [← hW]` reproduces "motive is not type correct" on the main goal — step (a) and `_legs_conj` are a single obstruction; building `conj-2b` in isolation is cosmetic until the reframing keystone exists.

## Subagent reports (review phase)
- **lean-auditor `iter037`** (both edited files): **0 must-fix**, 4 major (pre-existing scaffold excuse-comments on the 4 QuotScheme stubs — directive-acknowledged, not new), 1 minor (a `task_results/.../QuotScheme.md` doc-comment uses a vague `...` path). All 5 new decls confirmed honest + axiom-clean; no new sorry. Report: `task_results/lean-auditor-iter037.md`.
- **lean-vs-blueprint-checker `gr037`**: **0 must-fix**, 2 major (blueprint coverage — `exists_minorDet_eq_free_entry` is public with no `\lean{}` block; cofactor sub-step under-specified, suggest label `lem:gr_free_entry_eq_signed_minor`), 1 minor (`existence_factor_through_valuationRing` proves range-membership = equivalent to the prose's "factors as `(R↪K)∘g'`"). Report: `task_results/lean-vs-blueprint-checker-gr037.md`.
- **lean-vs-blueprint-checker `quot037`**: **0 must-fix**, 2 major (coverage — the two new transport theorems lack proper `\lean{}` blocks; only a NOTE mention), +1 pre-existing major (`Grassmannian.representable` pin under-delivers prose — authorized scaffold), 3 minor (pending-gap NOTEs should track the two transports as gating). Report: `task_results/lean-vs-blueprint-checker-quot037.md`.

## Blueprint markers updated (manual)
- None this iter. No new Mathlib-alias decls (no `\mathlibok` warranted — the 5 new decls are bespoke proofs using Mathlib lemmas, not re-exports); no `\lean{}` renames flagged (all names match); no stale `\notready` present. The 3 coverage-debt blocks and the `Grassmannian.representable` strengthening are **planner blueprint-authoring tasks** (informal prose — not the review agent's domain) — listed in `recommendations.md`.

## Recommendations
See `recommendations.md`. Headline: GR lane proceeds to E4; QUOT next builds the section-iso semilinearity + Hfr chain; **FBC must NOT get another assembly/helper round** — the tripwire mandates a mathlib-analogist consult first. Planner owes 3 coverage-debt blueprint blocks.
