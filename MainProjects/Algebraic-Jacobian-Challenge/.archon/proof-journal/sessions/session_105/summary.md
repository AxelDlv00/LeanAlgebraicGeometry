# Session 105 — iter-105 review (project narrative iter-107)

## Metadata

- **Archon iteration**: 105 (= session_105)
- **Project-narrative label**: iter-107 (single substantive prover lane committed to option 3 per progress-critic-iter105 STUCK verdict)
- **Iteration shape**: 1 prover lane on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (plus 4 plan-phase subagents: blueprint-reviewer, progress-critic, strategy-critic, refactor; 3 parallel blueprint-writers; 2 review-phase subagents: lean-auditor, lean-vs-blueprint-checker).
- **Sorry count before** (iter-104 close, after refactor lane): 14 (BasicOpenCech 6, Differentials 5, Monoidal 1, Jacobian 1, Picard.Functor 1).
- **Sorry count after** (iter-105 close): **14** (unchanged). BasicOpenCech 6 → 6; no closure, no addition; the L1120 sorry (was L1145 pre-iter-105 refactor; now stable at L1120) remains.
- **Hard cap of 6** met; iter-105 PROGRESS.md target of 5 missed by 1; stretch of 4 (also close L1754 `g_R.map_smul'`) not attempted per plan's escalation rule.
- **Compile-verified at close**: yes (`lean_diagnostic_messages` severity=error returns `[]` end-to-end). **Thirteenth consecutive compile-verified prover iteration** (iter-092 onwards).
- **Total file events** (per `attempts_raw.jsonl` summary): 92 events; 17 edits; 5 goal checks; 20 diagnostic checks; 0 builds (the prover relied on LSP, not full `lake build`); 7 lemma searches; 12 error states; 9 clean diagnostics.
- **Prover model**: Sonnet (via Archon harness).
- **STREAK STATUS**: 7 consecutive PARTIAL iters on the `cechCofaceMap_pi_smul` slot (iter-099/100/101/103/105/106/107). Iter-104 was a different target (L536). Progress-critic-iter105 STUCK verdict fires for the second time; strategy-critic-iter105 sunk-cost flag #1 active. **Iter-108 abort policy is now triggered.**

## Target 1: `cechCofaceMap_pi_smul` trailing sorry at L1120

### Iter-105 plan recipe (Option 3 — direct in-line per-coord scalar pullback, wrapper bypassed)

```
At the post-L1114 LinearMap-chain goal (∀ i ∈ Finset.univ, hG-per-summand R-linearity),
replace the iter-105 wrapper invocation at L1115–L1144 with a direct application
of cechCofaceMap_summand_family_R_linear (iter-104). The call-site Pi.lift body is
DEFINITIONALLY equal to cechCofaceMap_summand_family s₀ n (Fin.cast hRel'.symm i),
so iter-104's R-linearity applies directly at index Fin ((prev n) + 2) — no wrapper
transport, no eqToHom-vs-Pi.π identification.
```

### Attempts (verbatim from `attempts_raw.jsonl`)

| # | Tactic | Result | Insight |
|---|--------|--------|---------|
| 1 | `rw [ModuleCat.hom_zsmul, ModuleCat.hom_zsmul]` (direct, post-S5 frame) | FAILED — `(deterministic) timeout at whnf, maximum number of heartbeats (1600000) has been reached` | Discrim-tree pattern unification on anonymous-closure Pi.lift triggers whnf cascade. Same root cause as iter-100/101/103/106. |
| 2 | `generalize hσ : ((-1 : ℤ) ^ (↑i : ℕ)) = σ` (abstract the scalar) | PARTIAL (succeeds; subsequent rw still times out) | Generalizing scalar to a fresh variable does NOT bypass whnf timeout — cost is in the Pi.lift body, not the scalar. Reconfirms iter-100 finding. |
| 3 | `have h_zsmul : ∀ {Mc Nc} (c : ℤ) (f : Mc ⟶ Nc) (z : Mc), (ModuleCat.Hom.hom (c • f)) z = c • (ModuleCat.Hom.hom f) z := fun _ _ _ ↦ rfl; rw [h_zsmul, h_zsmul]` | FAILED — same whnf timeout | Body-local rfl-helper with free binders does NOT help. The discrim-tree refusal is at pattern-match level, not at lemma-statement level. `rw` instantiates `?f := Pi.lift (...)` and then whnf-reduces. Reconfirms iter-099 E1 dead-end in the post-S5 frame. |
| 4 | `simp only [ModuleCat.hom_smul, LinearMap.smul_apply]` | FAILED — `simp made no progress` | `ModuleCat.hom_smul`'s `(s • f).hom = s • f.hom` typeclass-chain `[Monoid S][DistribMulAction][SMulCommClass]` doesn't unify on anonymous-closure form. |
| 5 | `rw [← LinearMap.comp_apply, ← ModuleCat.hom_comp, ← LinearMap.comp_apply, ← ModuleCat.hom_comp]` (reverse simp at L1114 to recover categorical composite, then `Preadditive.zsmul_comp`) | FAILED — same whnf timeout | Even REVERSING the L1114 simp is blocked by the discrim-tree issue. Confirms the blocker is at the smul-Pi.lift interface, robust to forward AND backward composition reasoning. |
| 6 | `change (ModuleCat.Hom.hom (Pi.π Z₂ j')) ((ModuleCat.Hom.hom (eqToHom (by dsimp only [Z₂]; congr 1; ext; omega))) ...) = ...` (named family with explicit eqToHom proof) | FAILED — `Application type mismatch: eqToHom ⋯ has type ?m.1418 ⟶ ?m.1418 but is expected to have type (∏ᶜ ...) ⟶ (∏ᶜ Z₂)`; secondary `omega could not prove the goal` on Fin family-equality | The type-equality proof obligation `Fin ((prev n) + 2) → s₀ = Fin (n+1) → s₀` requires Fin.cast-based construction, not `omega`. Same class as iter-100 `_`-codomain ascription failure. |
| 7 | **Committed final partial**: `have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega; have h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'; sorry` | PARTIAL (file compiles; `h_iter104` staged in scope) | Iter-104 binder-level R-linearity is now in the body's tactic-state as `h_iter104`. Iter-108 can derive per-coord version at `j_int := j' ∘ Fin.cast hRel'` via `congrFun` + `Pi.smul_apply`, then bridge from `(Pi.π Z_int j_int).hom` to `(Pi.π Z₂ j').hom (eqToHom_outer.hom (...))`. Not closure, but load-bearing infrastructure. |

### Final state (L1120)

Committed at L1115–L1120:
```lean
  -- iter-107 option 3 PARTIAL: iter-104 R-linearity staged in scope as
  -- `h_iter104`; full closure blocked by smul + eqToHom bridge (see
  -- task_results/Cohomology_BasicOpenCech.lean.md for the attempt log).
  have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega
  have h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'
  sorry
```

- `h_iter104 : (Pi.π Z_int j_int).hom (cechCofaceMap_summand_family s₀ n i ≫ ...).hom (e₁.symm (r' • y')) = r' • (Pi.π Z_int j_int).hom (cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y')` — binder-level R-linearity at index `Fin ((prev n) + 2) → s₀`, ready for `congrFun` specialization.
- `hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1` — Fin-index equation also in scope.

### Root cause (L1120, restated)

The fundamental obstacle is FUNDAMENTAL: **discrim-tree pattern unification + whnf reduction on the anonymous-closure Pi.lift body is a Lean elaboration limit, not a missing lemma.** Across 7 prover lanes the same recurring blocker phrases appear:

- "anonymous-closure Pi.lift codomain" — 6 of 6 audited iters (100, 101, 103, 105, 106, 107).
- "discrim-tree pattern-unification" — 6 of 6 iters.
- "whnf timeout at 1600000 heartbeats" — 4 of 6 iters.
- "eqToHom-vs-Pi.π transport" — 4 of 4 iters that attempted bridging.
- "Fin index mismatch `Fin ((prev n) + 2)` vs `Fin (n+1)`" — multi-iter.

Workaround paths all require structural changes:
- (i) rcases n with _ | n_ to symbolically eliminate `(prev n)`,
- (ii) manual Pi.hom_ext with eqToHom-lemma chain,
- (iii) named-family substitution with eqToHom bridge,
- (iv) refactor of the anonymous-closure Pi.lift definition itself (progress-critic-iter105's primary corrective option 2).

## Targets 2-6: deferred sorries (untouched this iter)

- L1212 (substep (a) augmented Čech) — deferred.
- L1536 (was L1573 in iter-104 numbering; `K → K₀` finite-subspanning transport) — deferred.
- L1564 (substep (a) for `s₀` extra-degeneracy) — deferred.
- L1754 (`g_R.map_smul'`; Step 2 stretch) — correctly skipped per escalation rule.
- L1783 (`h_loc_exact`; assembly via `exact_of_localized_span`) — deferred.

## Plan-phase subagent results (consumed during plan; quoted here for review continuity)

| Subagent | Slug | Outcome |
|----------|------|---------|
| blueprint-reviewer | iter105 | 3 must-fix items (broken `\uses` MV / SSMK; LineBundle prose drift). Plan dispatched 3 blueprint-writers in parallel — all COMPLETE. |
| progress-critic | iter105 | **STUCK** on `cechCofaceMap_pi_smul` route. 7 consecutive PARTIAL iters; helpers accumulating; target residual not moving. Primary corrective: route pivot (option 3 / refactor / strategy-critic). |
| strategy-critic | iter105 | CHALLENGE/REJECT verdicts on Phase A iter-108 abort policy, Phase C1 underspec, Phase C2 underspec, Phase C3 (50-150 iters realistic, must adopt JacobianWitness deferral or alternative); sunk-cost flag on wrapper engineering. Plan agent updated STRATEGY.md: committed Phase A iter-108 abort policy, Phase C3 exit policy adopted (JacobianWitness pattern), D/E re-statused as BLOCKED-ON-C3-WITNESS. |
| refactor | iter107-cleanup | COMPLETE — BasicOpenCech 7 → 6 (Route 1 lemma removed); 4 stale "Body left as sorry" docstrings rewritten; iter-107 deferral block replaced with single breadcrumb line; Differentials 238-LOC ITER-076 dead-code block deleted. |
| blueprint-writer | mv-fix | COMPLETE — fixed broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` → `def:Scheme_HModule_prime_eq_HModule_linearEquiv`. |
| blueprint-writer | ssmk-fix | COMPLETE — fixed broken `\uses{def:Scheme_HModule'}` → `def:Scheme_HModule_prime`. |
| blueprint-writer | linebundle-status | COMPLETE — added Lean-state note + `% NOTE:` markers documenting the C1 approximation. |

## Review-phase subagent results

### lean-auditor (slug iter105)

- **4 must-fix-this-iter** findings:
  1. `Picard/LineBundle.lean:85-86` — **Weakened-wrong definition** `LineBundle X := CommRing.Pic Γ(X, ⊤)` — iter-104 critical finding STILL UNFIXED. Author's own docstring admits "strict subgroup of true Picard group (trivial for projective space, true Pic is ℤ)". Propagates to `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, `nonempty_jacobianWitness`.
  2. `Modules/Monoidal.lean:166-173` — **`sorry`-bodied instance** `instIsMonoidal_W`. Docstring falsely advertises "no consumers" but `instMonoidalCategoryStruct` + `instMonoidalCategory` in the same file transitively consume it via `LocalizedMonoidal`'s instance signature. Iter-104 critical finding STILL UNFIXED.
  3. `Cohomology/StructureSheafModuleK.lean:27-31` — **Stale status block** claiming "8 declarations scaffolded as `sorry`. iter-006 responsible." All 8 closed ~100 iters ago.
  4. `Rigidity.lean:19-23` — **Stale status block** claiming `eq_of_eqOnOpen` body is `sorry`. Body has been a closed ~25-line proof since session 2; stale 80+ iters out of date.

- **4 major**: Differentials L27-31 stale status block; Picard/Functor L26-36 honest-deferral framing must move when LineBundle fixed; MayerVietorisCore `HModule'_*` parallel-API (Mathlib upstream candidate); BasicOpenCech L1115-1117 active-prover scaffold comment (borderline, honest in-flight status).

- **4 minor**: Genus L39-61 archeological sketch; BasicOpenCech accumulating iter-history comments (L1037-1051 etc.); heartbeat-budget bumps (long-term refactor); Differentials L633-636 verbose status.

- **Iter-104 stale docstrings RESOLVED**: 4 "Body left as 'sorry' for iter-XXX prover" docstrings at BasicOpenCech L488/L760/L823/L871 have been rewritten by iter-105 refactor. Differentials L675–L912 ITER-076 dead-code block has been deleted.

- **Overall verdict**: iter-104 critical findings on `LineBundle` and `instIsMonoidal_W` still uncorrected; two new stale-status docstrings (StructureSheafModuleK, Rigidity) actively misrepresent closed declarations; iter-105 refactor cleaned the BasicOpenCech + Differentials targets it directed, but the load-bearing wrongness flagged at iter-104 has not been addressed.

Report archived to `.archon/logs/iter-105/lean-auditor-iter105-report.md`.

### lean-vs-blueprint-checker (slug basicopencech)

- **0 must-fix, 0 major, 2 minor**:
  - Blueprint Step 2 of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` could explicitly mention `R`-linearity of the localized differential to justify the R-linearity scaffolding (`cechCofaceMap_pi_smul`, `f_R`/`g_R`).
  - `thm:cechCohomology_subsingleton_of_cechCochain_exactAt` (L1139) and `def:Scheme_splitEpi_pi_lift_of_injective` (L1121) lack `\uses{...}` annotations.

- **mv-fix verified**: broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` now reads `def:Scheme_HModule_prime_eq_HModule_linearEquiv`; no remaining occurrences of the broken label.

- **14/23 declarations have blueprint blocks**; 9 unreferenced declarations are all proof-scaffolding helpers (iter-stamped docstrings, no suspect bodies).

- **Overall verdict**: Lean file follows the blueprint faithfully; chapter gives the prover enough detail modulo the minor R-linearity-wording gap and two missing `\uses{...}` already flagged as soon-followups in mv-fix's own report.

Report archived to `.archon/logs/iter-105/lean-vs-blueprint-checker-basicopencech-report.md`.

## Key findings — this session

1. **Option 3 has now failed.** The progress-critic-iter105 STUCK verdict on `cechCofaceMap_pi_smul` is reinforced for the 8th consecutive iter (counting iter-104 which switched targets). The plan's iter-108 abort policy — "if iter-107 option 3 also fails, escalate to deeper refactor or re-dispatch strategy-critic mid-iter on a revised Phase A strategy; do NOT continue wrapper engineering, heartbeat budget escalation, or scalar-extraction tactic accumulation" — must fire now. See `recommendations.md` § "Must-fire iter-108 abort policy" for the precise three-option menu.

2. **The `h_iter104` body-local have is the iter-107 deliverable.** Iter-104's R-linearity is now staged in the tactic state. Iter-108's *first* prover lane (under any of the three abort-policy options) should consume this `have` if pursuing iter-108 option 3 continuation; if pivoting to refactor, the `have` is portable.

3. **Iter-104 lean-auditor critical findings on `LineBundle` and `instIsMonoidal_W` still stand.** Plan-phase did not address these (iter-105 plan ratified the JacobianWitness deferral pattern via STRATEGY.md update but did not surface `LineBundle` to `TO_USER.md`). The lean-auditor-iter105 has re-promoted both to must-fix-this-iter. **These are user-decision strategic items**, not iter-108 prover work.

4. **Two new stale-status docstrings discovered** (StructureSheafModuleK, Rigidity) — both lie about closed code being `sorry`. These are plan-phase prose tasks for iter-108 and are mechanical to fix.

5. **mv-fix label correction landed cleanly.** lean-vs-blueprint-checker-basicopencech confirms the fix is exhaustive across the blueprint tree.

## Blueprint markers updated (manual)

- `Cohomology_MayerVietoris.tex` — verified by lean-vs-blueprint-checker that the iter-105 `blueprint-writer-mv-fix` correctly replaced `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` with `\uses{def:Scheme_HModule_prime_eq_HModule_linearEquiv}` at L779; no broken-label remnants. **No manual edit needed this iter** — the writer's edit suffices, and `sync_leanok` handles `\leanok` placement.
- `Cohomology_StructureSheafModuleK.tex` — verified by iter-105 `blueprint-writer-ssmk-fix` that the broken `\uses{def:Scheme_HModule'}` was replaced with `def:Scheme_HModule_prime` at L629. **No manual edit needed.**
- `Picard_LineBundle.tex` — verified by iter-105 `blueprint-writer-linebundle-status` that the C1-approximation note was added. **No manual edit needed.**
- **No other blueprint manual edits this iter.** `\mathlibok` is not warranted on any new declaration (all iter-105 helpers are project-local R-linearity scaffolding, not Mathlib aliases). No `\lean{...}` renames were flagged by either reviewer.

## Notes section (LOW-severity)

- L1115–1117 BasicOpenCech active-prover scaffold comment (lean-auditor major): borderline excuse-comment — the technical blocker is specifically named (smul + eqToHom bridge) and the helper lemma `cechCofaceMap_summand_family_R_linear` is concretely staged at L1119. Leave for the iter-108 plan to triage when the L1120 sorry closes or pivots.
- BasicOpenCech accumulating iter-history scaffold comments (lean-auditor minor): each enclosing sorry's closure should trigger a triage; postpone until iter-108's L1120 disposition is decided.
- Heartbeat-budget bumps (lean-auditor minor): long-term refactor target after Phase A stabilises; not iter-108 work.
- Genus L39-61 archeological sketch (lean-auditor minor): trivial cleanup, plan-phase prose pass.
