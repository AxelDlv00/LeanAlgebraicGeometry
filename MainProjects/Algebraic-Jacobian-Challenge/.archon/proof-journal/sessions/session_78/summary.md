# Session 78 — iter-078 review

## Metadata

- **Archon iteration**: 078
- **Stage**: prover (three substantive lanes — Differentials, BasicOpenCech, Modules/Monoidal)
- **Sorry count before iter-078**: 17 active syntactic sorry sites (per iter-077 review).
- **Sorry count after iter-078**: **15** active syntactic sorry sites.
  - Per-file (verified via `grep -nE` on project source):
    - `Differentials.lean`: **5** (L122, L458, L742, L759, L901) — was 6.
    - `Cohomology/BasicOpenCech.lean`: **6** (L502, L826, L854, L1110, L1150, L1179) — unchanged.
    - `Jacobian.lean`: **1** (L179) — unchanged.
    - `Picard/Functor.lean`: **1** (L190) — unchanged.
    - `Modules/Monoidal.lean`: **2** (L112, L124) — was 3.
- **Net change**: **−2 sorries** (active prover closures −2; no refactor; no introduced sorries).
- **Compilation status**: All affected files compile cleanly. Final `lean_diagnostic_messages` per file returns `error_count: 0`.
- **Env state**: 23 `lean_diagnostic_messages` invocations (8 clean terminators); 0 `lake build` calls; 22 source edits; 24 lemma searches; 0 `lean_run_code` pre-validation (per user policy).

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Differentials.lean` | **DONE** (target closed) | **−1** | yes |
| 2 | `Cohomology/BasicOpenCech.lean` | IN PROGRESS (no closure) | 0 | yes |
| 3 | `Modules/Monoidal.lean` | PARTIAL (1 of 3 closed) | **−1** | yes |

---

## Lane 1 — `Differentials.lean`: close `cotangentExactSeqAlpha.d_app`

**Status**: DONE. The iter-077 internal `sorry` inside `cotangentExactSeqAlpha`'s `d_app` field (at iter-077 L260) is closed. File now has 5 syntactic sorries (was 6). Final `lean_diagnostic_messages`: 0 errors (log line 119).

### Final proof structure

The ζ-bridge construction (PROGRESS.md route 1, mirroring iter-077's η-bridge for `cotangentExactSeqBeta`):

```lean
let τ : (TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf ⟶
      (TopCat.Presheaf.pushforward CommRingCat f.base).obj
        ((TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf) :=
  ((adj_g).homEquiv S.presheaf _).symm (adj_fg.unit.app S.presheaf)
have hτ : τ ≫ (pushforward f).map φ_fg' = φ_g' ≫ f.c := by
  apply adj_g.homEquiv.injective
  rw [Adjunction.homEquiv_naturality_right,
      Adjunction.homEquiv_naturality_right]
  have eq1 : … = (f≫g).c := by
    have h1 : adj_g.homEquiv τ = adj_fg.unit.app S.presheaf := by
      dsimp only [τ]; exact Equiv.apply_symm_apply _ _
    rw [h1]
    change adj_fg.homEquiv S.presheaf X.presheaf φ_fg' = _
    dsimp only [φ_fg']; exact Equiv.apply_symm_apply _ _
  have eq2 : … = (f≫g).c := by
    have h4 : adj_g.homEquiv φ_g' = g.c := by
      dsimp only [φ_g']; exact Equiv.apply_symm_apply _ _
    rw [h4]; rfl
  rw [eq1, eq2]
change D_X.d ((f.c.app U).hom ((φ_g'.app U).hom a)) = 0
have happ : … = (φ_fg'.app _).hom ((τ.app U).hom a) := by
  have h := congr_arg (fun h : _ ⟶ _ => (ConcreteCategory.hom (h.app U)) a) hτ.symm
  simpa using h
rw [happ]; exact D_X.d_app _
```

### Significant attempts (from `attempts_raw.jsonl` for Differentials.lean)

The lane's diagnostic trail (4 diagnostics; 4 edits) shows a tight repair loop on top of the basic bridge construction:

**Attempt 1 — Initial bridge body** (log lines ~110–113)
- `code_tried`: full ζ-bridge as above with `show ... = ...` instead of `change` (two sites: lines that became 121 and 122 in the current file).
- `lean_error` (log line 114, err_count=1): `Tactic 'rewrite' failed: Did not find an occurrence of the pattern (adj_fg.unit.app S.presheaf) ≫ (pushforward (f ≫ g)).map φ_fg' in the target expression`.
- `insight`: the linter complained about `show` (style); deeper issue was that `show` changes the goal display but does not normalize the head to the form needed for `rw`.

**Attempt 2 — Switch `show ... = ...` → `change ... = ...`** (edit at log line 121)
- `code_tried`: replace first `show` with `change ... = _` (inside the `eq1` proof).
- `lean_error` (log line 116, err_count=0): clean. The `change` form rewrites the LHS to the explicit `homEquiv ... φ_fg' = _` form, after which `Equiv.apply_symm_apply` closes via `dsimp only [φ_fg']`.

**Attempt 3 — Same fix on the outer `D_X.d (...) = 0` site** (edit at log line 122)
- `code_tried`: replace the second `show` (re-stating the outer goal in terms of `ConcreteCategory.hom`) with `change`.
- `lean_error`: clean. Final diagnostic at log line 119 reports 0 errors.

### Key learnings (Lane 1)

- **ζ-bridge ≡ dual of η-bridge**: `cotangentExactSeqAlpha.d_app` parallels `cotangentExactSeqBeta` (iter-077) with the bridge direction reversed. The same identity `(f≫g).c = g.c ≫ pushforward(g).map f.c` (`rfl` at the Scheme level — iter-077 learning) carries both proofs.
- **`change` over `show` for goal-rewriting**: where `show` triggers the `linter.style.show` warning (changes goal rather than just annotates) and can leave the goal in a form that does not immediately accept the next `rw`, `change` produces both lint-clean output and the desired post-state.
- **Adjunction coherence via injectivity + double `homEquiv_naturality_right`**: the strategy "apply `homEquiv` to both sides, naturalize, collapse via `Equiv.apply_symm_apply`" gives a mechanical recipe for any composed-adjunction-coherence proof. This is now a confirmed pattern for both α and β.
- The `set_option maxHeartbeats 16000000 in` from iter-077 was retained.

**`lean_verify` axiom profile**: per the task report, `cotangentExactSeqAlpha`'s axioms are identical to `cotangentExactSeqBeta` (`propext`, `sorryAx`, `Classical.choice`, `Quot.sound`). The `sorryAx` is inherited from `relativeDifferentialsPresheaf_isSheaf` (still sorry'd upstream), not introduced by this closure.

---

## Lane 2 — `Cohomology/BasicOpenCech.lean`: close `h_diff_pi_smul_f`

**Status**: IN PROGRESS. No sorry-count change (6 → 6). File compiles. The internal `sorry` at L1110 (`h_diff_pi_smul_f` body) remains.

### What was achieved

- A heartbeat-lift `set_option maxHeartbeats 800000 in` was added directly above `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (now around L411). This is a prerequisite for any future tactic work inside the `h_diff_pi_smul_f` block — without it, even the `intro r y; funext j; sorry` prefix triggers a `whnf` heartbeat timeout at the theorem head.
- The `sorry` body is reduced to the S1-prefix `intro r y; funext j; sorry`. After `funext j`, the goal reduces to the per-output-index form:
  ```
  e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = (r • e₂ ((scK₀.f).hom (e₁.symm y))) j
  ```

### Significant attempts (13 edits, 12 diagnostics on this file)

**Attempt 1 — Add `rw [Pi.smul_apply]` after `funext j`** (log line ~48, edit; diagnostic at log line 49)
- `code_tried`:
  ```lean
  intro r y
  funext j
  rw [Pi.smul_apply]
  ```
- `lean_error`: `Tactic 'rewrite' failed: Did not find an occurrence of the pattern (?a • ?f) ?i in the target expression e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) j = (r • e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm y))) j`.
- `insight`: the RHS smul `r • e₂ (...)` does not unify with `Pi.instSMul` because the smul instance on `↑scK₀.X₂` is the `h_mod_pi₂`-mediated `RingHom.toModule (presheaf.map …).hom` builder, not `Pi.instSMul` directly.

**Attempt 2 — Try `show e₂ (…) j = r • (e₂ (…)) j` to expose per-component smul** (log line ~56)
- `code_tried`: a `show` that rewrites the RHS to apply smul at output index `j`.
- `lean_error` (log line 57, err_count=1): `failed to synthesize instance of type class HSMul ↑R ↑(Z₂ j) ?_`.
- `insight`: there is no standalone R-action on `Z₂ j`; only on the product `∏ᶜ Z₂` via `h_mod_pi₂`'s opaque builder.

**Attempt 3 — Restore `rw [Pi.smul_apply]` after adding `set_option maxHeartbeats 800000 in`** (log line ~71–72)
- `code_tried`: `set_option maxHeartbeats 800000 in` prefixed to the surrounding theorem, with the `funext j; rw [Pi.smul_apply]` body restored.
- `lean_error` (log line 72, err_count=1): same `rewrite` failure.
- `insight`: the heartbeat lift does not change pattern-matching behaviour — the `Pi.smul_apply` simp lemma cannot fire because the smul on the RHS is not syntactically `Pi.instSMul`.

**Attempt 4 — Try `simp only [Pi.smul_apply]`** (log line ~73)
- `code_tried`: replaced `rw` with `simp only`.
- `lean_error` (log line 75): "unused simp argument" warning. No closure.

**Attempt 5 — Roll back simp arg; preserve heartbeats-lift and `intro/funext` prefix** (final edit, log line 87)
- `code_tried` (final state):
  ```lean
  set_option maxHeartbeats 800000 in
  -- (iter-078 prover: with heartbeats lift, attempt S1 prefix.)
  ...
  intro r y
  funext j
  -- Goal: `e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = r • e₂ ((scK₀.f).hom (e₁.symm y)) j`
  sorry
  ```
- `lean_error`: clean.
- `insight`: the lane lands at `funext j; sorry` with the heartbeat lift in place. The substantive S2–S8 content remains unattempted.

### What remains (S2–S8, per task report)

The remaining recipe is documented in detail in the task report — five steps from the unfolded 5-layer functor stack through `Pi.smul_apply`, `Finset.smul_sum`, `Finset.sum_congr`, per-summand R-linearity via presheaf-restriction functoriality, and the final `rfl`/`ring`. Two specific obstacles are now identified:

1. **`Pi.smul_apply` does not fire**: the RHS smul is `h_mod_pi₂`-mediated, not literal `Pi.instSMul`. Workaround: `change` to a concrete per-component formula via `h_mod_pi₂`'s component-projection lemma before invoking `Pi.smul_apply`.
2. **`K₀.d ↔ objD` opacity**: the `K₀.d (prev n) n` map is built via `CochainComplex.of` + an `(up ℕ).Rel (prev n) n` case-split; `dsimp` does not unfold it without explicit `CochainComplex.of_d_eq_succ` rewrites for the `up ℕ` shape.

### Key learnings (Lane 2)

- **Heartbeat lift is a prerequisite for tactic work inside the smul-naturality block**. Removing `set_option maxHeartbeats 800000 in` will re-trigger the iter-074/075 `whnf` cascade at the theorem head.
- **`Pi.smul_apply` does not fire against `h_mod_pi₂`-mediated smul**. The next-iter prover should `change` to a concrete per-component formula via `h_mod_pi₂`'s builder before any `Pi.*` rewrite.
- **`show` to a goal demanding `HSMul ↑R ↑(Z₂ j) ?_` fails**: there is no standalone R-action on each fibre `Z₂ j`; the R-action lives only on the product. Any rewrite that exposes a per-component smul must factor through the product-level R-action.

---

## Lane 3 — `Modules/Monoidal.lean`: fill all three scaffold bodies

**Status**: PARTIAL. 1 of 3 sorries closed (`tensorObj`); 2 remain (`instMonoidalCategoryStruct`, `instMonoidalCategory`). File compiles cleanly with two expected `sorry` warnings.

### Final state

```lean
noncomputable def tensorObj (M N : X.Modules) : X.Modules :=
  letI : MonoidalCategoryStruct (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategoryStruct
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  (_root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)
```

### Significant attempts (4 edits, 6 diagnostics)

**Attempt 1 — Direct sheafification body without `_root_` qualification or `letI` instance-shadow** (log line ~189–190)
- `code_tried`:
  ```lean
  (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)
  ```
- `lean_error` (log line 190, err_count=1): `failed to synthesize instance of type class MonoidalCategoryStruct (_root_.PresheafOfModules X.ringCatSheaf.obj)`.
- `insight`: the Mathlib instance `PresheafOfModules.monoidalCategoryStruct` is declared on `R ⋙ forget₂ CommRingCat RingCat` (a `RingCat`-valued presheaf). `X.ringCatSheaf.obj` is `X.sheaf.obj ⋙ forget₂ CommRingCat RingCat` only via the `sheafCompose` adjustment — *definitionally* the same form but not the form the instance is registered on.

**Attempt 2 — Use ambient `PresheafOfModules` name without `_root_`** (log line ~203–204)
- `code_tried`: same as Attempt 1 but with `PresheafOfModules` instead of `_root_.PresheafOfModules`.
- `lean_error` (log line 204, err_count=1): `Application type mismatch: The argument X.ringCatSheaf.obj has type (TopologicalSpace.Opens ↥X)ᵒᵖ ⥤ RingCat but is expected to have type Scheme in the application PresheafOfModules X.ringCatSheaf.obj`.
- `insight`: there are two `PresheafOfModules` names in scope — Mathlib's general one and `AlgebraicGeometry.Scheme.PresheafOfModules X` (taking a `Scheme` argument). The `_root_` prefix is required for disambiguation.

**Attempt 3 — `letI : MonoidalCategoryStruct (_root_.PresheafOfModules X.ringCatSheaf.obj) := inferInstance` direct** (log line ~205)
- `lean_error` (err_count=1): same instance-synth failure as Attempt 1.
- `insight`: `inferInstance` cannot synthesise on the un-folded form; it needs an explicit `show ... from inferInstance` to be told which type to elaborate against.

**Attempt 4 — Add the `show ... from inferInstance` shadow + `_root_` prefix everywhere** (final, log line ~205)
- `code_tried`: full body as shown above.
- `lean_error`: clean (err_count=0).
- `insight`: with the `show MonoidalCategoryStruct (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u}))` shadow, the instance is registered locally on the form the Mathlib instance is declared on; the `letI` then lets the outer body's `⊗` infer through. All other instance lookups (locally-bijective for `𝟙`, `HasWeakSheafify`, `WEqualsLocallyBijective`) succeed automatically.

### What remains (`instMonoidalCategoryStruct`, `instMonoidalCategory`)

The task report identifies the **single substantive gap-fill**: an `MorphismProperty.IsMonoidal` instance for the `inverseImage` class of `PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)` on `PresheafOfModules X.ringCatSheaf.obj`. Concretely:

```lean
instance : ((MorphismProperty.isomorphisms (SheafOfModules X.ringCatSheaf)).inverseImage
            (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))).IsMonoidal := …
```

This is the bookkeeping that `sheafification` (a left adjoint, hence colimit-preserving) preserves whisker-iso-ness on each variable, because the presheaf tensor product is colimit-preserving in each variable.

Once supplied, both `instMonoidalCategoryStruct` and `instMonoidalCategory` follow by `inferInstance` chains through `LocalizedMonoidal (L := sheafification _) (W := …) (Iso.refl _)` (Mathlib `CategoryTheory.Localization.Monoidal.Basic`). The Mathlib precedent at `CategoryTheory.Sheaf.monoidalCategory` (`Sites/Monoidal.lean`) is the exact pattern, adapted from the fixed-value case to the presheaf-of-modules formalism.

### Key learnings (Lane 3)

- **Two `PresheafOfModules` names in the open scope**: `_root_.PresheafOfModules` (Mathlib) takes a presheaf of rings; `AlgebraicGeometry.Scheme.PresheafOfModules X` takes a `Scheme`. The `_root_` prefix is mandatory for the Mathlib spelling when the file is inside `namespace AlgebraicGeometry.Scheme.Modules`.
- **Sheafification instance-discovery requires `show ... from inferInstance`**: the Mathlib `PresheafOfModules.monoidalCategoryStruct` is registered on the form `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`. The project-side `X.ringCatSheaf.obj` is definitionally that form but not syntactically. A local `letI` with an explicit `show` shadow exposes the right form for synthesis.
- **`LocalizedMonoidal` is the canonical resolution for sheaf-monoidal-via-sheafification**: instead of building the associator/unitors/braiding by hand at the SheafOfModules level (which never terminates — the source/target objects of the sheaf-side iso are not the sheafifications of the corresponding presheaf-side iso's source/target), build them via the localization-monoidal machinery in `CategoryTheory.Localization.Monoidal`.

---

## Cross-lane learnings

1. **`change` is preferred over `show` for goal-rewriting** (Lane 1; reinforces iter-077's L172 / `linter.style.show` finding): `change` is both lint-clean and produces a goal state suitable for subsequent `rw` patterns. `show` may change display only, leaving the underlying goal in a form `rw` cannot match.
2. **The η-bridge / ζ-bridge pattern is now a confirmed two-iteration recipe** (Lanes 1 vs. iter-077 Beta): `set η/τ := adj.homEquiv.symm (...)` + `have hcoherence : ... := by apply adj.homEquiv.injective; rw [homEquiv_naturality_right]; ...; rw [Equiv.apply_symm_apply]; rfl` works for any composed-adjunction-coherence proof. The Scheme-level identity `(f≫g).c = g.c ≫ pushforward(g).map f.c` is `rfl` and carries both proofs.
3. **`Pi.smul_apply` does not fire against `RingHom.toModule`-built smul** (Lane 2): the smul instance on the codomain product is not syntactically `Pi.instSMul`. Workaround: `change` to a concrete per-component formula via the builder's component-projection lemma, then invoke `Pi.smul_apply`.
4. **Heartbeat lift is a per-theorem tactic-budget knob** (Lane 2): tactic-block heartbeat sensitivity can be addressed by `set_option maxHeartbeats 800000 in` directly above the theorem — even pre-`intro` whnf normalization at the theorem head benefits.
5. **`_root_` namespace prefix in `Modules/Monoidal.lean`** (Lane 3): when there's a project-side name shadowing a Mathlib name (here `PresheafOfModules`), the `_root_` qualification is required at every use site to disambiguate.
6. **Instance-discovery on definitionally-equal-but-not-syntactic forms** (Lane 3): `inferInstance` matches syntactically. When the canonical type form differs from the registered instance's form by definitional equalities (`sheafCompose`, `forget₂` chain, etc.), use `show ... from inferInstance` to elaborate against the registered form.

---

## Blueprint markers updated (manual)

None this session. Reasoning:

- No prover renames of declarations (all closures hit pre-existing names that already have `\lean{...}` macros in the chapters).
- No protected-decl path changes — `archon-protected.yaml` unchanged.
- No new Mathlib-backed declarations to add `\mathlibok` for. The two closures are project-level constructions whose proofs invoke Mathlib lemmas but whose statements remain project-level (no re-export pattern).
- No stale `\notready` markers identified on landed declarations.

The deterministic `sync_leanok` phase that ran before me has already adjusted `\leanok` based on the new sorry state. For reference:

- `Differentials.tex`: `def:cotangent_alpha` previously had `\leanok` (the construction existed even with the internal `d_app` sorry); the closure should now propagate `\leanok` to the *proof block* of `lem:cotangent_exact_structure` if/when the structure-level assembly lands (currently still sorry'd at L458). The `\leanok` on the definition itself was correct before and remains correct.
- `Modules_Monoidal.tex`: `def:Modules_tensorObj` previously had `\leanok` (the signature was scaffolded with a `sorry` body); with the body closed, `\leanok` remains. `thm:Modules_MonoidalCategory` retains `\leanok` on its statement-block (the signature is scaffolded) but the proof block's `\leanok` is now incorrect to the extent that two sorries remain — the deterministic `sync_leanok` phase handles this.

---

## Sorry-count budget tracking

| Lane | Plan target | Plan hard cap | Actual delta | Within target? |
|---|---|---|---|---|
| 1 Differentials | ≤5 (close d_app) | 6 (no regression) | 6 → 5 (−1) | YES (hit target) |
| 2 BasicOpenCech | ≤5 (close h_diff_pi_smul_f) | 6 (no regression) | 6 → 6 (0) | UNDER target (hit cap) |
| 3 Modules/Monoidal | ≤0 (close all 3) | 3 (no regression) | 3 → 2 (−1) | UNDER target (hit 2/3) |
| **Project total** | n/a | n/a | **17 → 15 (−2)** | n/a |

Constraints:
- No new project-local helper lemmas (user policy 2026-05-11). Confirmed.
- No new axioms. Confirmed.
- No `lean_run_code` pre-validation. Confirmed (per attempts log, only `lean_diagnostic_messages`, `lean_hover_info`, `lean_leansearch`, `lean_loogle`, `lean_local_search`).
- Protected signatures (`archon-protected.yaml`) unchanged. Confirmed.

---

## Process discipline (iter-078 retro)

- Plan-agent's three-lane parallel dispatch worked cleanly with no cross-lane interference (independent files).
- Iter-077's η-bridge recipe transferred to Lane 1 essentially mechanically — the ζ-bridge dual closes `cotangentExactSeqAlpha.d_app` with the same identity, the same heartbeat lift, and the same `Adjunction.homEquiv_naturality_right` + `Equiv.apply_symm_apply` combinator. **Two iterations of evidence now support this as a reusable pattern.**
- Lane 2 progress (zero closures but heartbeat-lift + S1 prefix landed) is preparatory: it puts the file in a state from which the iter-079 prover can attack S2–S8 directly without re-litigating heartbeats.
- Lane 3 closes 1/3 with a clean architectural diagnosis: the remaining 2 sorries reduce to a single Mathlib-gap-fill (`MorphismProperty.IsMonoidal` for the inverseImage class). The next-iter prover has a precise target.
- 23 `lean_diagnostic_messages` invocations (8 clean terminators); the per-edit feedback loop continues to function reliably.
- No `lean_run_code` pre-validation (per user policy 2026-05-11).
- One environment hiccup recorded (log line 140): a `lean_diagnostic_messages` invocation against `AlgebraicJacobian/Modules/Monoidal.lean` (relative path) failed with "no lean-toolchain ancestor". The prover recovered by using the absolute path; the issue does not need user attention.
