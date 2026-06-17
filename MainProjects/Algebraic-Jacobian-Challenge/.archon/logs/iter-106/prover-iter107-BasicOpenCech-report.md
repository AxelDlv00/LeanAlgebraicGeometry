# AlgebraicJacobian/Cohomology/BasicOpenCech.lean (iter-107 prover)

## Summary

- **Sorry count**: 6 (unchanged from iter-107 entry; hard cap respected).
- **File compiles**: YES (`lean_diagnostic_messages` severity=error returns `[]`).
- **L1145 closure (target)**: PARTIAL — `h_iter104` staged as a body-local `have`; full closure blocked by smul + eqToHom-bridge.
- **L1779 (Step 2 stretch)**: not attempted (L1145 closure prerequisite not met).
- **Iter-107 outcome relative to budget**: ACCEPTABLE (6 = hard cap respected, no new sorries, no axioms, file compiles). Target (5) and stretch (4) NOT MET.

## `cechCofaceMap_pi_smul` trailing sorry (was L1145, now L1158)

### Attempt 1 — Option 3 direct scalar pullback (post-L1114 LinearMap-chain form)
- **Approach**: After L1114 (the iter-103 simp), apply `rw [ModuleCat.hom_zsmul, ModuleCat.hom_zsmul]` to push `(-1)^↑i •` outside `.hom`.
- **Result**: FAILED — `(deterministic) timeout at whnf, maximum number of heartbeats (1600000) has been reached`. The pattern-match on the anonymous-closure Pi.lift triggers whnf reduction over the inner `Pi.π Z₁ (i_1 ∘ (SimplexCategory.δ i).toOrderHom)` binder, exceeding the heartbeat budget.
- **Dead end**: same root cause as the iter-100/101/103/106 reports — discrim-tree pattern unification on anonymous-closure Pi.lift body.

### Attempt 2 — generalize the ℤ-sign to a free variable
- **Approach**: `generalize hσ : ((-1 : ℤ) ^ (↑i : ℕ)) = σ` to abstract the scalar, then `rw [ModuleCat.hom_zsmul]` (with σ a free ℤ).
- **Result**: PARTIAL (generalize succeeds; subsequent rw still times out).
- **Key finding**: Generalizing the scalar to a fresh variable does NOT bypass the whnf timeout. The whnf cost is in the Pi.lift body, not in the scalar.

### Attempt 3 — body-local rfl-helper with free binders (mimicking `key₂` at L1052)
- **Approach**: `have h_zsmul : ∀ {Mc Nc} (c : ℤ) (f : Mc ⟶ Nc) (z : Mc), (ModuleCat.Hom.hom (c • f)) z = c • (ModuleCat.Hom.hom f) z := fun _ _ _ ↦ rfl` then `rw [h_zsmul, h_zsmul]`.
- **Result**: FAILED — same whnf timeout. The discrim-tree refusal is at the pattern-match level, not at the lemma-statement level. Even FREE binders don't help here because `rw` instantiates `?f := Pi.lift (...)` and then `whnf`-reduces.
- **Dead end**: body-local helpers are NOT a workaround for the anonymous-closure issue (despite `key₂` working at L1052 — different goal shape).

### Attempt 4 — `simp only [ModuleCat.hom_smul]` / `simp only [ModuleCat.hom_smul, LinearMap.smul_apply]`
- **Result**: `simp made no progress` — `ModuleCat.hom_smul`'s pattern `(s • f).hom = s • f.hom` (with `S : Monoid`, `DistribMulAction S ↑N`, `SMulCommClass R S ↑N`) doesn't unify on the anonymous-closure form. (Same root cause as Attempt 1.)

### Attempt 5 — reverse L1114's simp to recover the categorical composite form
- **Approach**: `rw [← LinearMap.comp_apply, ← ModuleCat.hom_comp, ← LinearMap.comp_apply, ← ModuleCat.hom_comp]` to undo L1114 and recover `ModuleCat.Hom.hom ((σ • F) ≫ eqToHom ≫ Pi.π Z₂ j') z` form. At that level, `Preadditive.zsmul_comp` could pull σ out at the categorical level.
- **Result**: FAILED — `← LinearMap.comp_apply` and `← ModuleCat.hom_comp` both whnf-time-out (same anonymous-closure obstacle on the goal's Pi.lift output).
- **Dead end**: even REVERSING the simp at L1114 (which decomposes the categorical composite) is blocked by the discrim-tree issue.

### Attempt 6 — `change`/`show` with named family + explicit eqToHom proof
- **Approach**: `change` the goal so the inner Pi.lift becomes `cechCofaceMap_summand_family s₀ n i` (which it equals definitionally) and the eqToHom's proof is `(by dsimp only [Z₂]; congr 1; ...)`.
- **Result**: FAILED — the type-equality proof obligation decomposes into `Fin ((prev n) + 2) → ↥s₀ = Fin (n+1) → ↥s₀` family equality, which `omega` cannot solve (Fin.cast required but families are heterogeneous-equal not propositional-equal).
- **Dead end**: object-level eqToHom proofs between `∏ᶜ` products with different Fin-indexing cannot be discharged by `omega` alone; requires explicit Fin.cast-based construction.

### Final partial state (committed on disk at L1115–L1158)

```lean
  -- iter-107 option 3 attempt (PARTIAL).
  have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega
  have h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'
  -- [comprehensive comment block explaining the attempts and iter-108 strategy]
  sorry
```

`h_iter104 : e_int_lemma ((cechCofaceMap_summand_family s₀ n i).hom (e₁_lemma.symm (r' • y'))) = r' • e_int_lemma (...)` is staged in scope. `hRel' : (prev n) + 2 = n + 1` is also in scope.

### Iter-108 inlining strategy (recommended next route, ~80–120 LOC)

Mirror iter-104's binder-level proof of `cechCofaceMap_summand_family_R_linear` (L502–L603), with the eqToHom-bridge baked into the per-coord step. The closely-related wrapper proof `cechCofaceMap_summand_family'_R_linear` (L676–L734) already does this for the wrapper, and iter-108 can adapt it directly. Key steps:
1. From `h_iter104`, derive the per-coord version at `j_int := j' ∘ Fin.cast hRel'` via `congrFun` + `Pi.smul_apply`.
2. Bridge from `(Pi.π Z_int j_int).hom (F.hom z)` to `(Pi.π Z₂ j').hom (eqToHom_outer.hom (F.hom z))` via a categorical identity. Mathlib's `Pi.π_comp_eqToHom` (verified iter-107 via `lean_leansearch`) is for INDEX equality, not OBJECT equality. The bridge requires either:
   - Manual construction via `Pi.hom_ext` + `eqToHom`-lemma chain, OR
   - `rcases n with _ | n_` to symbolically eliminate `(prev n)`, reducing the eqToHom to `eqToHom rfl = 𝟙`.
3. Handle σ-smul via `congrArg (σ • ·)` on both sides + `smul_comm` between the ℤ-action and R-action on `Z₂ j'`.

The `rcases n` approach (option 2b) likely requires re-doing L998–L1013 (which produced the eqToHom via `dif_pos hRel`); the manual Pi.hom_ext approach (option 2a) is more localized but needs ~30 LOC of eqToHom-manipulation.

## Other sorries (unchanged this iter, all OFF-LIMITS)

- L1250 (was L1237): substep (a) augmented Čech — deferred to iter-108+.
- L1574 (was L1561): outer scaffolding localised-Čech identification — deferred.
- L1602 (was L1589): substep (a) for `s₀` — deferred.
- L1792 (was L1779): `g_R.map_smul'` — Step 2 stretch not attempted (prerequisite L1145 not closed).
- L1821 (was L1808): `h_loc_exact` — Mathlib gap-fill, iter-108+.

## Sorry count verification

`grep -nE '^[[:space:]]*sorry|^[^-/]*[[:space:]]sorry[[:space:]]*$|:=[[:space:]]*sorry'` confirms 6 syntactic sorries at L1158, L1250, L1574, L1602, L1792, L1821. No new sorries introduced. No new axioms.

## Final diagnostic state (mandatory closing artefact)

`mcp__archon-lean-lsp__lean_diagnostic_messages` on the file with `severity=error` returns:

```
{"result":{"success":true,"items":[],"failed_dependencies":[]}}
```

File compiles successfully.

## Blueprint state

No blueprint edits this iter. `cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family*`, `alternating_*` helpers are project-local without `\lean{...}` entries — no marker changes warranted. Blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § Čech acyclicity engine prose remains "soon" per blueprint-reviewer-iter105.

## Notes for next iter

- The progress-critic-iter105 STUCK verdict on this slot is reinforced by this iter (now 7 consecutive PARTIAL iters: 099/100/101/103/105/106/107). The plan's iter-108 abort policy (STRATEGY.md) should be triggered: escalate to `strategy-critic` or `refactor` before continuing wrapper-style engineering.
- The fundamental obstacle is FUNDAMENTAL: discrim-tree pattern unification + whnf reduction on the anonymous-closure Pi.lift body is a Lean elaboration limit, not a missing lemma. Workaround paths all require structural changes (rcases n, manual Pi.hom_ext, or named-family substitution with eqToHom bridge).
- The h_iter104 `have` staged at L1124 IS load-bearing partial progress: iter-108 can build directly on it.
