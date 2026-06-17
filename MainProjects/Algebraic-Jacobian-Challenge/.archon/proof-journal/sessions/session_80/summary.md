# Session 80 — iter-080 review

## Metadata

- **Archon iteration**: 080
- **Stage**: prover (three substantive lanes — BasicOpenCech, Differentials, Modules/Monoidal)
- **Sorry count before iter-080**: 14 active syntactic sorry sites (per iter-079 review).
- **Sorry count after iter-080**: **14** active syntactic sorry sites (verified via `sorry_analyzer.py`).
  - Per-file: `Differentials.lean` 5; `Cohomology/BasicOpenCech.lean` 6; `Modules/Monoidal.lean` 1; `Jacobian.lean` 1; `Picard/Functor.lean` 1.
- **Net change**: **0** sorries. All three lanes respected hard cap; none hit the closure target.
- **Compilation status**: All affected files compile cleanly (verified by 28 `lean_diagnostic_messages` invocations, final state clean).
- **Env state**: 27 source edits, 28 `lean_diagnostic_messages` calls, 11 `lean_goal` checks, 23 lemma searches, 0 `lean_run_code` pre-validation (per user policy).

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | IN PROGRESS (named-per-i refactor landed; `Pi.smul_apply` now fires; S2–S8 chain pending) | 0 (6 → 6) | yes |
| 2 | `Differentials.lean` | PARTIAL (Route A reaches `ext U b`; `hα_fac` unifier loop on inline `d_target`) | 0 (5 → 5) | yes |
| 3 | `Modules/Monoidal.lean` | BLOCKED on Mathlib gap (varying-ring `stalk_tensorObj`) | 0 (1 → 1) | yes |

---

## Lane 1 — `BasicOpenCech.lean`: `h_diff_pi_smul_f` structural unblock

**Status**: IN PROGRESS. Refactor of `h_mod_pi₁/₂/₃` to named per-i instances landed cleanly; the iter-076/078/079 confirmed blocker (`Pi.smul_apply` failing against `RingHom.toModule`-built smul) is now **closed**. The remaining S2–S8 mechanical chain is unblocked but not yet completed (multi-iteration patience required per the file's `(up ℕ).Rel` opacity).

### Concrete delivery

```lean
-- BEFORE (iter-072 anonymous per-i builder, blocker for Pi.smul_apply):
have h_mod_pi₂ : Module R (∀ i, Z₂ i) :=
  @Pi.module (Fin (n + 1) → ↑s₀) (fun i => Z₂ i) R _ _ (fun i => by
    apply RingHom.toModule; refine (C.left.presheaf.map ...).hom; ...)

-- AFTER (iter-080 named per-i builder, both letI-registered):
letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
  apply RingHom.toModule; refine (C.left.presheaf.map ...).hom; ...
letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
```

Both bindings are `letI` (transparent + instance-registered). Symmetric refactor applied to `h_mod_pi₁` and `h_mod_pi₃`. The semantic content of each `h_mod_pi_n` is byte-for-byte identical to iter-072 — only typeclass visibility of the per-i builders changes. **NOT a new project-local helper** per user policy 2026-05-11.

### Goal-state verification (from `attempts_raw.jsonl`)

After `intro r y; funext j`:
```
GOAL BEFORE simp only [Pi.smul_apply]:
  e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = (r • e₂ ((scK₀.f).hom (e₁.symm y))) j
GOAL AFTER simp only [Pi.smul_apply]:
  e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = r • e₂ ((scK₀.f).hom (e₁.symm y)) j
```

The iter-079 `change h_mod_pi₂.toSMul.smul …` step is **no longer needed** — `Pi.smul_apply` directly produces the desired component form.

### Attempts tried, errors logged

| Tactic | Result | Diagnostic |
|---|---|---|
| `simp only [Pi.smul_apply]` after refactor | ✓ FIRES | clean diagnostic |
| `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]` | ✓ WORKS | verified via `lean_multi_attempt`; exposes inner `FormalCoproduct` term but surfaces `K₀.d (prev n) n` opacity |
| `exact map_smul (scK₀.f.hom) r _` | ✗ FAIL | `failed to synthesize SMul ↑R ↑(∏ᶜ Z₁)` — scK₀.f is k-linear, not R-linear; the R-linearity is the *construct* |
| `module` tactic | ✗ FAIL | not a pure linear-combination shape; sides involve presheaf restriction maps |
| `rfl` after S2 dsimp | ✗ FAIL | sides not defeq without `(up ℕ).Rel` case-split + `Pi.lift` decomposition |
| Several `change` variants on the f-side RHS (mid-edit) | ✗ FAIL (rolled back) | `'change' tactic failed, pattern …` — pre-refactor; the iter-079 form depended on `h_mod_pi₂.toSMul.smul` projection |

The structural advance is the refactor + `Pi.smul_apply` firing. The remaining chain (S2–S8) is mechanical:
- **S2**: `dsimp` chain ✓ done.
- **S3**: `K₀.d (prev n) n = objD X (prev n)` via `CochainComplex.of_d_eq_succ` + `(up ℕ).Rel` case-split — pending.
- **S4**: `objD X m = ∑ k : Fin (m+2), (-1)^k • X.δ k` via `AlternatingCofaceMapComplex.objD` — pending.
- **S5–S8**: `Pi.smul_apply` (LHS) + `Finset.smul_sum` (RHS) + per-summand `RingHom.map_mul` + `← presheaf.map_comp` collapsing the V_j → V_{j∘δ_k} → U restrictions — pending.

Sorry count: 6 → 6 (hard cap respected; target ≤ 5 not hit).

---

## Lane 2 — `Differentials.lean`: `cotangentExactSeq_structure` Route A

**Status**: PARTIAL. Route A (per-section extensionality via `SheafOfModules.hom_ext`) structurally advances `h_zero` past the iter-076 stale `simp` step. After `apply postcomp_injective + ext U b`, the goal reduces to a ModuleCat-level equation. The next step `rw [hα_fac _ b]` fails to unify against the inline `d_target` Derivation' structure, and `erw` deterministically times out at `whnf` (200000 heartbeats).

Per the iter-080 plan's **conditional clause** ("if Route A fails and `_structure` cannot close, do NOT introduce `exact_iff_stalkwise` as a free-floating sorry — that would be a regression"), the body is left as a single absorbed `sorry`. The body now documents three iter-081 unblock recipes for the next plan agent.

### Goal-state trace (from `attempts_raw.jsonl`)

Initial goal at `cotangentExactSeq_structure` body:
```
X Y S : Scheme
f : X ⟶ Y
g : Y ⟶ S
⊢ ∃ (h : cotangentExactSeqAlpha f g ≫ cotangentExactSeqBeta f g = 0),
    { X₁ := …, X₂ := …, X₃ := …, f := …, g := …, zero := h }.Exact
    ∧ Epi (cotangentExactSeqBeta f g)
```

After Route A chain inside `h_zero`:
```
(ModuleCat.Hom.hom ((desc d_target).app U ≫ ((pushforward _).map β.val).app U))
   ((derivation' φ_g').d b) = 0
```
where `d_target` is the inline `{ d := …, d_mul := …, d_map := …, d_app := … }` structure that emerges from `unfold cotangentExactSeqAlpha`.

### Attempts tried, errors logged

| Tactic | Result | Diagnostic |
|---|---|---|
| Route A chain (`apply SheafOfModules.hom_ext` + explicit `show` + `apply postcomp_injective` + `ext U b` + standard simp set) | ✓ STRUCTURAL ADVANCE | clean — goal reduces to the equation above |
| `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` after the main simp | ✗ FAIL | "made no progress" |
| `rw [ModuleCat.hom_comp]` directly | ✗ FAIL | "Did not find an occurrence of the pattern `ModuleCat.Hom.hom (?f ≫ ?g)`" |
| `change ... = 0` (with explicit `.hom.comp ... .hom`) + `rw [LinearMap.comp_apply]` | ✓ partial | succeeds, distributes application |
| Then `rw [hα_fac _ b]` | ✗ FAIL | "Did not find an occurrence of the pattern `(ModuleCat.Hom.hom (((isUniversal' φ_g').desc ?m).app U)) ((derivation' φ_g').d b)`" |
| `erw [hα_fac _ b]` | ✗ FAIL | deterministic timeout at `whnf`, 200000 heartbeats |
| `simp only [hα_fac]` | ✗ FAIL | "made no progress" |
| `simp [Universal.fac]` (after `apply postcomp_injective`, no `ext`) | ✗ FAIL | reports `Universal.fac` as unused |
| `cat_disch` from top of body | ✗ FAIL | aesop failed |
| `exact?` from top of body | ✗ FAIL | could not close the goal |

### Diagnosis

**Metavariable-elaboration mismatch** when matching `hα_fac _ b`'s pattern against the inline `d_target` term. The pattern is `(ModuleCat.Hom.hom (((isUniversal' φ_g').desc ?d_t).app U)) ((derivation' φ_g').d b)` where `?d_t` is the metavariable to unify against the let-bound inline structure that emerged from `unfold cotangentExactSeqAlpha`. The `erw` timeout supports this — the unifier is trying to compute the type-class instance for the inline structure against the abstract metavariable's class, which loops or balloons.

The `change`-based split succeeds because it uses Lean's transparency configuration directly. But the subsequent `rw` falls back to the unifier, which fails.

Sorry count: 5 → 5 (no regression; conditional clause respected).

---

## Lane 3 — `Modules/Monoidal.lean`: `instIsMonoidal_W` experimental stalks route

**Status**: BLOCKED on Mathlib gap. The stalks-level argument route reduces to identifying `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗_{R₀.stalk x} N.stalk x` for varying-ring `PresheafOfModules R₀`. Mathlib provides this for fixed-ring `ModuleCat R` (`Mathlib/Algebra/Category/ModuleCat/Tilde.lean`) and `stalkFunctor`-preserves-colimits is abstractly available, but the explicit identification for `PresheafOfModules R₀` with varying `R₀` is **absent**.

### Attempts tried, errors logged

| Step | Result | Diagnostic |
|---|---|---|
| `rw [MonoidalCategory.tensorHom_def, Functor.map_comp]` | ✓ WORKS | verified via `lean_multi_attempt`; goal reduces to `IsIso (L (f ▷ Y₁) ≫ L (X₂ ◁ g))` |
| Search Mathlib for `stalk_tensorObj` (varying-ring) | ✗ ABSENT | `lean_leansearch` + grep on `Mathlib/Algebra/Category` for `stalk.*tensor`, `tensor.*stalk` returned nothing relevant; only `tensorLeft.PreservesColimitsOfSize` / `tensorRight.PreservesColimitsOfSize` (abstract colimit preservation) |
| Direct `infer_instance` after the `tensorHom_def` rewrite | ✗ FAIL | cannot synthesize `IsIso ((sheafificationFunctor X).map (f ▷ Y₁) ≫ (sheafificationFunctor X).map (X₂ ◁ g))` — the two whisker isos are not derivable without the stalk identification |
| `exact MorphismProperty.tensorHom_mem _ _ _ hf hg` | ✗ FAIL | requires the very `W.IsMonoidal` instance we are constructing (circular) |

### Decision

Per plan-agent instruction ("If the route fails, preserve the existing `MorphismProperty.IsMonoidal.mk' _ fun … => by simp …; sorry` shape, with `lean_diagnostic_messages` confirming the same diagnostic as iter-079"), no code change to the proof body was saved. The `Functor.map_comp` investigation lived only in `lean_multi_attempt` probes.

Docstring augmented with iter-080 investigation findings: precise Mathlib gap identification (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀ is the missing piece) and the three confirmed-blocked alternative routes from iter-079.

Sorry count: 1 → 1 (no change, per "experimental, failure acceptable" framing).

---

## Key findings and proof patterns (iter-080)

### Pattern discovered: `letI`-bound named per-i builders for `Pi.module` *(NEW iter-080)*

When `simp [Pi.smul_apply]` (or `Pi.smul_def`) fails against a `Pi.module`-built smul whose per-i `Module R (β i)` instance is buried inside the `Pi.module` constructor as an anonymous `fun i => …` term, the unblock is to **expand into named pieces**:

```lean
-- BLOCKING (anonymous):
have h : Module R (∀ i, β i) := @Pi.module … (fun i => by …construct…)

-- UNBLOCKING (named, both letI):
letI perI : ∀ i, Module R (β i) := fun i => by …construct…
letI h : Module R (∀ i, β i) := Pi.module _ _ _
```

Both bindings must be `letI` so the body of `h` unfolds to `Pi.module _ _ _ perI .toSMul = Pi.instSMul` and `Pi.smul_apply` can fire.

This is **byte-for-byte equivalent** to the anonymous construction — only typeclass-visibility of the per-i builder changes. Per user policy 2026-05-11 this is NOT a new project-local helper lemma (literal expansion of an existing construction).

### Anti-pattern confirmed: inline anonymous structures in `unfold`-target identifiers *(NEW iter-080)*

When a declaration like `cotangentExactSeqAlpha` defines its output via an inline anonymous `{ d := …, d_map := … }` Derivation'-style structure inside its body, `unfold cotangentExactSeqAlpha` surfaces that inline structure at the goal head. Downstream `rw`/`erw`/`simp` against a lemma containing a metavariable that should unify with that structure (e.g. `Universal.fac`-style `desc d_t = …`) **fails to unify** — the unifier cannot bind the metavariable to the let-bound inline term. The fix is one of:
- bind the structure to a named handle via `set d_target := { … } with hd_target` BEFORE invoking the universal property, OR
- refactor the original declaration to expose the structure as a named `noncomputable def`, OR
- introduce a Mathlib-shape helper that composes the universal-property factorisation away from `ext U b`.

This is a generalisable hazard for any project-local declaration that uses inline anonymous structures in its body.

### Pattern reconfirmed: `lean_multi_attempt` for tactic-attempt previews *(iter-079, used iter-080)*

`lean_multi_attempt` is allowed and useful for testing tactic candidates at a position without saving them to the file. Used in Lane 1 to verify the `dsimp only [scK₀, K₀, …]` chain reduces correctly, and in Lane 3 to confirm `rw [MonoidalCategory.tensorHom_def, Functor.map_comp]` rewrites cleanly. Under user policy 2026-05-11, `lean_run_code` pre-validation of candidate bodies is forbidden, but `lean_multi_attempt` for position-bound tactic previews is allowed.

---

## Blueprint markers updated (manual)

No semantic-judgement marker changes this iteration:
- No new Mathlib-backed declarations to add `\mathlibok` for.
- No `\lean{...}` renames flagged in any task result.
- No `\notready` stales to strip.
- No `% NOTE:` additions warranted (the iter-080 partials are well-documented in the task result files and in the `cotangentExactSeq_structure` body comments themselves; the blueprint chapters' informal prose already reflects the iter-079 plan-agent rewrites).

The deterministic `sync_leanok` phase ran before this review and handles `\leanok` placement automatically.

---

## Recommendations for next session

See `recommendations.md`.
