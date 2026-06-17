# Session 104 — iter-104 review (project narrative iter-106)

## Metadata

- **Archon iteration**: 104 (= session_104)
- **Project-narrative label**: iter-106 (single substantive prover lane, hard-stop close)
- **Iteration shape**: 1 prover lane on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- **Sorry count before** (iter-103 close): 14 (BasicOpenCech 6, Differentials 5, Monoidal 1, Jacobian 1, Picard.Functor 1)
- **Sorry count after** (iter-104 close): **15**. **BasicOpenCech 6 → 7** — net +1 from Route 1 transient lemma signature. No sorry closed. Hard cap of 7 met at exactly the upper budget; iter-104 plan's "acceptable: 6" missed by 1 (the plan accepted "Route 1 lemma added but body still sorry; L1147 still sorry — bank the infrastructure for iter-107").
- **Targets attempted** (in lane order):
  - **Route 1 lemma** `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` at L732–L751 — signature elaborates; body PARTIAL (rcases + omega + hPrev, then `sorry`).
  - **`cechCofaceMap_pi_smul` L1147 → L1179** (~shifted +32 lines by Route 1 lemma insertion) — five new attempts on the trailing sorry, all failed. Iter-105 partial-proof scaffold preserved byte-for-byte at L1112–L1178.
- **Compile-verified at close**: yes (`lean_diagnostic_messages` severity=error returns `[]`). **Twelfth consecutive compile-verified prover iteration** (iter-092 onwards).
- **Total file events** (per `attempts_raw.jsonl` summary): 95 events; 4 edits; 7 goal checks; 8 diagnostic checks; 18 lemma searches; 0 builds; 6 clean diagnostics; 2 error states (1 sandbox path bug, 1 whnf timeout).
- **Prover model**: Sonnet (via Archon harness).

## Target 1: Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`

### iter-104 plan recipe (Primary Route 1)

```
1. Add top-level lemma signature stating
   F (Fin.cast hRel.symm i) ≫ eqToHom hCod = wrapper at i
2. refine Pi.hom_ext _ _ (fun j_new => ?_)
3. unfold both sides via cechCofaceMap_summand_family / cechCofaceMap_summand_family'
4. rw [Pi.lift_π] on both sides + Fin.cast round-trip
5. close via rfl / eqToHom_naturality
```

### Attempts (verbatim from `attempts_raw.jsonl`)

| # | Tactic | Result | Insight |
|---|--------|--------|---------|
| 1 | `rcases n with _ | n'; · omega; · have hPrev := by simp [...]; sorry` (signature + induction scaffold) | PARTIAL — signature elaborates clean | hPrev computed but not used; zero case dispatched via hn |
| 2 | `refine Limits.Pi.hom_ext _ _ (fun j_new => ?_); rw [Category.assoc]; unfold ...; rw [Pi.lift_π, Pi.lift_π]` | FAILED | Pi.lift_π fires on RHS only; LHS has eqToHom between Pi.lift and Pi.π so the discrim tree cannot locate the Pi.lift pattern |
| 3 | `simp only [eqToHom_refl, Category.id_comp]` | FAILED | eqToHom_refl requires literal rfl syntactic match on the proof object; hCod is propositional |
| 4 | `have hRfl : hCod = rfl := rfl` | FAILED | LHS and RHS of hCod sit at distinct types `Fin ((prev (n'+1)) + 2) → s₀` vs `Fin (n'+1+1) → s₀` until hPrev substitutes — cannot construct rfl-proof directly |
| 5 | `subst hPrev` | FAILED | subst direction needs a variable on the LHS; hPrev's LHS `(prev (n'+1))` is computational, not a variable |
| 6 | `simp only [hPrev] at hCod` / `at *` | FAILED | `simp made no progress` — hPrev does not rewrite the type-level Fin index occurring inside the product's index family |
| 7 | `aesop_cat` | FAILED | `tactic 'aesop' failed, failed to prove the goal after exhaustive search` — no rule for eqToHom-vs-Pi.π across object-equality between products with different Fin index types |

### Final state (Route 1 lemma)

Committed at L728–L751 with body:
```lean
  rcases n with _ | n'
  · omega
  · have hPrev : (ComplexShape.up ℕ).prev (n' + 1) = n' := by
      simp [ComplexShape.prev, ComplexShape.up_Rel]
    sorry
```

- Signature elaborates clean (eqToHom transport type-level meta resolution OK).
- Zero case dispatched via `omega` on hn (vacuous).
- `hPrev` is set up but **never used** before the trailing `sorry` — the lean-auditor flagged this as a **major dead-end scaffold** (see Knowledge Base "Audit findings"). For iter-107, either complete the proof or revert to a single `sorry` until the proof is ready.

### Root cause (Route 1)

The Mathlib lemma `Limits.Pi.π_comp_eqToHom` covers eqToHom from **index** equality (eqToHom from `i = j`), but `cechCofaceMap_pi_smul` needs the **object** equality case (`∏ᶜ Z₁ = ∏ᶜ Z₂` from `Fin a = Fin b`). The standard `eqToHom_naturality` is for naturality of single morphisms, not for transporting `Pi.π` through eqToHom that arises from index-type equality. **Mathlib gap**, would need a project-local helper.

## Target 2: `cechCofaceMap_pi_smul` L1179 trailing sorry (was L1147 before Route 1 lemma insertion)

### iter-104 plan recipe (Primary)

Apply Route 1 lemma to identify `F_at_i ≫ eqToHom_outer` with `wrapper at i`, then re-use iter-105's `h_wrap_pt` directly.

### Attempts (verbatim from `attempts_raw.jsonl`)

| # | Tactic | Result | Insight |
|---|--------|--------|---------|
| 1 | `simp only [ModuleCat.piIsoPi_hom_ker_subtype_apply] at h_wrap_pt` | FAILED ("simp made no progress") | Reconfirms iter-099/105 finding: e₂ x j' (LinearEquiv coercion) masks the discrim-tree key for piIsoPi_hom_ker_subtype_apply |
| 2 | `change (Pi.π Z₂ j').hom (((-1)^↑i • _) ≫ eqToHom _ ≫ Pi.π Z₂ _).hom _ = _` + `rw [← ConcreteCategory.comp_apply (×4)]` | PARTIAL (chain fuses) | iter-099 S1-S3 fuse pattern still works |
| 3 | After fuse: `rw [Preadditive.zsmul_comp]` to extract `(-1)^↑i •` | FAILED — `(deterministic) timeout at whnf, maximum number of heartbeats (1600000) has been reached` | The smul-Pi.lift discrim-tree match through `∏ᶜ (fun i_1 ↦ ...)` triggers a whnf cascade exceeding 1600000 heartbeats. SAME ROOT CAUSE CLASS as iter-099/101/103 |
| 4 | `rw [ModuleCat.hom_zsmul]`, `rw [ModuleCat.hom_smul]`, `rw [ModuleCat.hom_nsmul]`, `simp only [ModuleCat.hom_smul]` | FAILED | No occurrence of `ModuleCat.Hom.hom ((-1)^↑i • _)`. The smul instance is elaborated via a different path than the standard hom_smul/hom_zsmul pattern keys |
| 5 | `set F_at_i := Pi.lift (...)` to name the smul-target | FAILED | set folds syntactically but discrim-tree still unfolds the anonymous-closure codomain. Reconfirms iter-099 in-place E2 dead-end |

### Final state (L1179)

Committed at L1112–L1179 — iter-105's structured partial-proof scaffold is **preserved byte-for-byte**:
- `have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega` (L1152)
- `have h_wrap := cechCofaceMap_summand_family'_R_linear hU s₀ n hn (Fin.cast hRel' i)` (L1156)
- `have h_wrap_pt := congrFun (h_wrap r' y') j'` (L1157)
- `simp only [Pi.smul_apply] at h_wrap_pt` (L1158)
- iter-106 comment block at L1167–L1178 updated with the whnf-timeout finding and the iter-107 plan-agent re-route guidance
- Trailing `sorry` at L1179

## Substantive structural advance: NONE (this iter)

This iter committed a **new top-level lemma signature** (Route 1) but its body remains `sorry`, AND the iter-105 trailing sorry at L1179 is unchanged. Net effect: 1 transient sorry added to the project total; 0 sorries closed.

The iter-104 plan's "acceptable" outcome (Route 1 lemma added + L1147 still sorry, banking infrastructure for iter-107) is achieved. The iter-104 plan's "target" outcome (close L1147 + optionally close new lemma body) is not.

## Key findings

1. **`Pi.π_comp_eqToHom` covers index equality, not object equality** *(NEW iter-106)*: Mathlib exposes `Limits.Pi.π_comp_eqToHom` for eqToHom from `i = j` index renaming, but the `cechCofaceMap_pi_smul` blocker needs the **object-equality** case (`∏ᶜ Z₁ = ∏ᶜ Z₂` from `Fin a = Fin b`). No direct Mathlib lemma covers this — a project-local helper proved via `Limits.Pi.hom_ext` + per-coord `Pi.lift_π_apply` + `Fin.cast_cast` is required. Route 1 lemma is precisely that helper, but its body is the iter-106 blocker.
2. **Preadditive.zsmul_comp whnf-timeout on Pi.lift-anonymous-closure smul, even with maxHeartbeats=1600000** *(NEW iter-106)*: the `((-1)^↑i • F_at_i) ≫ eqToHom_outer ≫ Pi.π Z₂ j'` discrim-tree match triggers a whnf cascade that exceeds the 1600000-heartbeat budget at the theorem head. Same structural class as iter-101's literal `show` (also whnf-timeout at 1600000). The smul-Pi.lift interface is whnf-prohibitive at this budget.
3. **Iter-104 lemma scaffolding pattern: `rcases n with _ | n'` + auxiliary `hPrev`** *(NEW iter-106, anti-pattern)*: introducing `hPrev : (ComplexShape.up ℕ).prev (n' + 1) = n'` via simp computes the value but does NOT propagate into the indexing types inside `hCod` (the `∏ᶜ` argument family). `simp only [hPrev] at hCod` reports "no progress" because hPrev is a term-level equation that doesn't fire on type-position Fin indices. **Plan-directive lesson**: design future eqToHom-bridge lemmas WITHOUT relying on rcases-then-hPrev substitution; instead use `simp only [show (ComplexShape.up ℕ).prev n + 1 = n+1 by ...]` at the goal directly, or define the type-family abstractly with `Fin.cast` from the start.
4. **The Route 1 lemma's `have hPrev := ... sorry` body is a dead-end scaffold** *(audit finding, major)*: hPrev is computed but never used. For iter-107: either complete the proof (replacing sorry) or revert to a single `sorry` to clear the orphan hypothesis.
5. **The iter-105 wrapper R-linearity helper continues to work in context** *(reconfirmed iter-106)*: `cechCofaceMap_summand_family'_R_linear hU s₀ n hn (Fin.cast hRel' i)` plus `congrFun ... j'` + `simp only [Pi.smul_apply] at h_wrap_pt` are accepted as a clean partial. The remaining gap is purely the morphism-level F_at_i-vs-wrapper identification under eqToHom — exactly the Route 1 lemma's purpose.

## Audit findings (lean-auditor `iter104`)

Full report at `.archon/task_results/lean-auditor-iter104.md`. Severity counts: critical 1, major 7, minor 4.

- **CRITICAL — `Picard/LineBundle.lean:85`**: `def LineBundle X := CommRing.Pic Γ(X, ⊤)` is admitted by its own docstrings (L51–52, L80–84) to be the global-sections approximation, a strict subgroup of the true Picard group on non-affine schemes. Load-bearing for all of Phase C. **Not actionable this iter** — Phase B/C step 2+ refactor; recorded in recommendations.md for the plan agent.
- **MAJOR ×4 — `BasicOpenCech.lean` stale docstrings at L488/L760/L823/L871**: docstrings declare `"Body left as 'sorry' for the iter-XXX prover. Proof sketch: ..."` but the bodies are now **fully closed**. The blueprint markers script does not catch this (it only manages `\leanok`); fixing requires manual prose rewrite. **Actionable for iter-107**: dispatch a small plan-agent edit pass to rewrite each docstring to describe what the body actually does.
- **MAJOR — `BasicOpenCech.lean:732`**: the Route 1 lemma's `have hPrev` is unused dead-end scaffold (see Key Finding 4 above).
- **MAJOR — `BasicOpenCech.lean:1170`**: the iter-107 "lift maxHeartbeats to 3200000+" comment defers the fix without applying it. **This is exactly the iter-107 plan task** — the comment is forward-pointing, not stale.
- **MAJOR — `Differentials.lean:675-912`**: ~240-line `/- ITER-076 disabled chain ... -/` block contains commented-out tactic source with two embedded `sorry`s. Documentation belongs in blueprint/docstring; live source should not carry this much disabled tactic source.

## Blueprint markers updated (manual)

None this iteration. No `\mathlibok`, `\lean{...}`, or `% NOTE:` changes needed:
- The iter-106 Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` is project-local infrastructure (no `\lean{...}` entry in any chapter).
- No file's blueprint-relevant declaration was renamed or moved.
- No `\notready` markers remain on declarations that have since landed.
- The lean-auditor's stale-docstring findings are a Lean-side source issue, not a blueprint marker issue. They are captured in recommendations.md for the plan agent (who owns informal blueprint prose).

The deterministic `sync_leanok` phase ran prior to this review; per CLAUDE.md the review agent does NOT touch `\leanok`.

## Streak status

- **iter-106 substantive lanes on `cechCofaceMap_pi_smul` slot**: iter-099 (S1–S3), iter-100 (funext pivot), iter-101 (planning round — refactor pair iter-102/103), iter-103 (S4–S5), iter-104 (target L536 elsewhere), iter-105 (wrapper helpers + partial proof), iter-106 (Route 1 lemma + same L1179 sorry). That makes **iter-106 the 6th substantive prover lane** with this slot as primary or co-primary target.
- iter-106 differs from iter-099/100/101/103 in that the structural infrastructure (Route 1 lemma signature) was committed, but the body remains sorry, and the L1179 trailing sorry is unchanged. **No new sorry was closed, AND no new R-linearity helper body was closed** — this is the first iter in the chain where the prover added a transient sorry without closing anything.
- **Recommendation for iter-107 plan**: this is the trigger for moderate streak escalation (not full refactor, but a re-design of Route 1). See recommendations.md.

## Recommendations for next session

See `recommendations.md`. Top-priority items:
1. **Lift heartbeats** on `cechCofaceMap_pi_smul` head from 1600000 to 3200000–6400000 and retry the attempt 3 chain. This is the iter-106 prover's own first recommendation, and it directly addresses the whnf timeout.
2. **Re-design Route 1** to avoid the eqToHom object-equality structure entirely: parameterise by `i : Fin ((prev n) + 2)` directly (not `Fin (n+1)`) to eliminate `Fin.cast hRel.symm i`.
3. **Clean the Route 1 lemma's `have hPrev` dead-end scaffold** (lean-auditor major finding).
4. **Plan-agent docstring sweep** on `BasicOpenCech.lean` to fix the 4 stale "Body left as sorry" docstrings (audit major findings ×4).
