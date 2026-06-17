# Session 82 — iter-082 review

## Metadata

- **Archon iteration**: 082
- **Stage**: prover (two substantive lanes — BasicOpenCech, Differentials; Modules/Monoidal off-limits per plan).
- **Sorry count before iter-082**: 14 active syntactic sorry sites.
- **Sorry count after iter-082**: **14** active syntactic sorry sites
  (verified via `grep -nE '^\s*sorry\b|:= sorry\b|:= by sorry\b' AlgebraicJacobian/**/*.lean`).
  - Per-file (active sites):
    - `Cohomology/BasicOpenCech.lean`: 6 — L502, L826, L854, L1240, L1285, L1314.
    - `Differentials.lean`: 5 — L122, L576, L860, L877, L1019.
    - `Modules/Monoidal.lean`: 1 — L173.
    - `Jacobian.lean`: 1 — L179.
    - `Picard/Functor.lean`: 1 — L190.
- **Net change**: **0** sorries (hard cap respected on both lanes; closure target not hit on either active lane).
- **Compilation status**: All files compile cleanly at end-of-iteration. Final `lean_diagnostic_messages`
  on `BasicOpenCech.lean` (event 59, line 135 in JSONL): 0 errors. Final on `Differentials.lean`
  (event 183, line 422): 0 errors.
- **Env state (from `attempts_raw.jsonl` summary line)**:
  186 total events; **15 source edits**; 4 `lean_goal`; 15 `lean_diagnostic_messages`;
  29 lemma searches; 31 file reads; 38 bash; 0 `lake build`; 0 `lean_run_code` pre-validation
  (per user policy 2026-05-11). 5 transient diagnostic-error spikes (all self-resolved in the
  next edit pass).

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | PARTIAL ADVANCE — S5 prelude landed: `j`-projection now pushed past `piIsoPi Z₂`. The `h_diff_pi_smul_f` sorry is now at L1240 (was L1196), with goal in shape `(Pi.π Z₂ j).hom (...)`. S6 path-(a) blocked by `LinearMap.comp_apply` ∘ₛₗ-vs-∘ₗ unification mismatch. | 0 (6 → 6) | yes |
| 2 | `Differentials.lean` | PARTIAL — Route (c) chain for `h_zero` **reinstated in active code** (~70 LOC at L488–559); `h_exact ∧ h_epi` consolidated into a single absorbed `sorry` at L576. Stretch (`exact_iff_stalkwise` introduction + `h_epi` via Mitigation Route 2) attempted, blocked by typeclass-coercion issues identical to iter-081. Conditional clause respected. | 0 (5 → 5) | yes |
| 3 | `Modules/Monoidal.lean` | not assigned (deferred pending Mathlib upstream gap) | — | unchanged |

---

## Lane 1 — `BasicOpenCech.lean`: S5 prelude landed, S6 path-(a) blocked

**Status**: PARTIAL ADVANCE. One substantive structural edit landed (the S5 prelude
that pushes the j-projection past `piIsoPi Z₂`). All iter-078/080/081 prerequisites
(maxHeartbeats annotation, `letI perI_n`/`letI h_mod_pi_n` refactor, iter-081
S2+S3+S4 chain) preserved byte-for-byte. Sorry line shifted L1196 → L1240 due to
the inline expansion of the S5 prelude.

### Concrete delivery — S5 prelude (events 4/13 = first 2 substantive edits)

```lean
-- Re-fold the `limit.isoLimitCone ⟨productCone, productConeIsLimit⟩` shape that the
-- iter-081 `simp [..., ModuleCat.piIsoPi, ...]` exposed back into the
-- `ModuleCat.piIsoPi` API form so `piIsoPi_hom_ker_subtype_apply` can fire.
rw [show (limit.isoLimitCone
      ⟨ModuleCat.productCone Z₂, ModuleCat.productConeIsLimit Z₂⟩)
      = ModuleCat.piIsoPi Z₂ from rfl,
    show (limit.isoLimitCone
      ⟨ModuleCat.productCone Z₁, ModuleCat.productConeIsLimit Z₁⟩)
      = ModuleCat.piIsoPi Z₁ from rfl]
show (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j =
    r • (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j
rw [ModuleCat.piIsoPi_hom_ker_subtype_apply,
    ModuleCat.piIsoPi_hom_ker_subtype_apply]
```

After this prelude, both sides of the goal at L1240 are in the shape:
```
(Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv (r • y)))
  = r • (Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv y))
```
with the inner alternating sum `Σ_hom = ∑ i : Fin (prev n + 2), (-1)^i • Pi.lift _`.

### Goal trace at the sorry (from `attempts_raw.jsonl` events 42/44, line 1209/1212)

Verified via `lean_goal`: after the S5 prelude, `(Pi.π Z₂ j).hom` is adjacent to
the differential application; the alternating sum structure is preserved; the
remaining work is the per-summand R-linearity argument S6–S8.

### Attempts tried, errors logged (15 edits total, but only 4 substantive edits on BasicOpenCech)

| Attempt | Tactic | Result | Diagnostic |
|---|---|---|---|
| 1 | First-pass `rw [show ... from rfl]` with `{cone := …, isLimit := …}` brace syntax | ✗ FAIL | parser error: `unexpected identifier; expected '}'` at L1161 col 72 (event 38, log line 88). The `{ ... }` brace anon-constructor syntax conflicts with `show`-expression scoping. |
| 2 | Rewrite to `⟨ModuleCat.productCone Z₂, ModuleCat.productConeIsLimit Z₂⟩` anonymous-constructor syntax | ✓ SUCCESS | event 41 clean diagnostic (log line 95). |
| 3 | `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply, ModuleCat.piIsoPi_hom_ker_subtype_apply]` to push `j`-projection past the iso (both sides) | ✓ SUCCESS | event 53 clean diagnostic (log line 121). |
| 4 | S6 path-(a): `simp only [LinearMap.comp_apply]` to split `(eqToHom_hom ∘ₗ Σ_hom) z` → `eqToHom_hom (Σ_hom z)` | ✗ FAIL | reported in task result: Mathlib `LinearMap.comp_apply` matches the semilinear `∘ₛₗ` pattern, not the homogeneous `∘ₗ` shape in goal; higher-order unification fails to bridge them despite definitional equality. |
| 5 | Workaround: `simp only [LinearMap.coe_comp, Function.comp_apply]` | ✗ FAIL | no progress; the `(... ∘ₗ ...) z` form has no explicit `⇑(... ∘ₗ ...)` coercion to rewrite. |
| 6 | Workaround: explicit `RingHomCompTriple (σ := RingHom.id k)` annotation | ✗ FAIL | also no match. |
| 7 | Workaround: `change` to the explicitly unfolded form | ✗ FAIL | the `eqToHom` cast type is not directly displayable in surface syntax (the implicit type proof `eqToHom ⋯` cannot be written out). |
| 8 | Workaround: `dsimp only []` | ✗ FAIL | no progress. |
| 9 | Workaround: `rfl` | ✗ FAIL | sides are NOT defeq (the smul on Z₂ at j routes through `perI₂ j` while the LHS goes through the differential; the equality is non-trivial). |

### Sorry-count budget

- 6 (start) → 6 (end). Hard cap respected. Target (≤ 5 = close `h_diff_pi_smul_f`) **NOT hit**.
- The structural advance shifts the obstruction from "differential not yet exposed
  as alternating sum at the j-component" (iter-081) to "comp-of-LinearMaps not
  splittable as a single `rw` step" (iter-082).
- Dead-end warning recorded in body comments (L1180–1196): do NOT spend cycles on
  `LinearMap.comp_apply` rewrites against the homogeneous `∘ₗ` notation. The path
  forward is one of:
  - **Path (a)**: introduce a `let M : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := eqToHom_hom ∘ₗ Σ_hom`
    abbreviation BEFORE the iter-081 simp so the comp lives behind a named definition,
    then promote `M` to R-linear via per-summand reasoning.
  - **Path (b)**: take the per-summand approach DIRECTLY without splitting the comp
    first — use `Pi.lift_apply` and `Finset.sum_apply` / `Finset.smul_sum` from a
    different angle (commute through the comp at the function-evaluation level).

### Approaches preserved as inline dead-end warnings (DO NOT re-attempt)

The iter-082 prover wrote DEAD-END comment blocks at L1171–1196 of the file:
- `LinearMap.comp_apply` (with `∘ₛₗ` signature) cannot bridge the homogeneous `∘ₗ`.
- `simp only [LinearMap.coe_comp, Function.comp_apply]` has no coercion to fire on.
- `change` to the unfolded form fails on the implicit `eqToHom ⋯` type proof.
- `rfl` (sides not defeq).

---

## Lane 2 — `Differentials.lean`: Route (c) chain for `h_zero` reinstated; `h_epi` blocker unchanged

**Status**: PARTIAL. The iter-081 verified-working Route (c) chain for `h_zero` is
now reinstated in **active code** at L488–559 (was a comment block in iter-081).
The remaining `h_exact ∧ h_epi` conjunction is consolidated into a single absorbed
`sorry` at L576, matching the iter-081 single-sorry budget. The plan's stretch goal
(close `h_epi` via Route 2 + introduce `SheafOfModules.exact_iff_stalkwise` for
`h_exact`, both 1-for-1 shift) was attempted but blocked.

### Concrete delivery: `cotangentExactSeq_structure` body restructured (L488–576)

- **Before iter-082**: body was a single `sorry` (with Route (c) chain in a
  comment block at L496–525 documenting the iter-081 verified-working chain).
- **After iter-082**:
  - `refine ⟨?h_zero, ?h_rest⟩` splits ∃-witness from the `And`-conjunction.
  - `case h_zero` closes the first conjunct via the active Route (c) chain
    (L489–559) — no `sorry` in this branch.
  - `case h_rest` carries the absorbed `sorry` at L576 for `h_exact ∧ h_epi`
    with a documentation block (L560–575) explaining the remaining work.

The `set_option maxHeartbeats 16000000 in` annotation on the lemma is preserved.

### `h_zero` chain (L488–559, fully closed in active code)

```lean
apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
unfold cotangentExactSeqAlpha
simp only [Equiv.apply_symm_apply]
apply SheafOfModules.hom_ext
change (PresheafOfModules.DifferentialsConstruction.isUniversal' _).desc _ ≫
    (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).map
      (cotangentExactSeqBeta f g).val = 0
apply (PresheafOfModules.DifferentialsConstruction.isUniversal' _).postcomp_injective
rw [PresheafOfModules.Derivation.postcomp_comp]
simp only [PresheafOfModules.Derivation.Universal.fac]
apply PresheafOfModules.Derivation.ext
ext U b
-- [reintroduce named φ_g'/φ_fg'/φ_2'/adj_f]
-- [build hcoh : adj_f.unit ≫ pushforward.map φ_2' = f.c]
-- [build hcoh_app : (f.c.app U).hom b = φ_2'.app _ . hom ((adj_f.unit.app Y.presheaf).app U b)]
-- [build hd_app : (derivation' φ_2').d ((f.c.app U).hom b) = 0  via hcoh_app + Derivation'.d_app]
-- [build hβ_fac : pointwise universal-property fac with `simp only [postcomp_d_apply] at hpt; exact hpt`]
simp only [PresheafOfModules.Derivation.postcomp_d_apply]
dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
unfold cotangentExactSeqBeta
change (((isUniversal' φ_fg').desc _).app _).hom ((derivation' φ_fg').d ((f.c.app U).hom b)) = _
rw [hβ_fac _ ((f.c.app U).hom b)]
exact hd_app
```

### Key fix from iter-081 transcript reinstatement (task result note)

- `congr_arg` for `hcoh_app` required explicit lambda annotation:
  `fun (h : Y.presheaf ⟶ (TopCat.Presheaf.pushforward CommRingCat f.base).obj X.presheaf) => …`
  (the un-annotated form failed elaboration in iter-082's compiled state).
- `hβ_fac` proof: replaced `simpa [postcomp_d_apply] using hpt` with
  `simp only [postcomp_d_apply] at hpt; exact hpt` — the `simpa` form over-fired
  `Universal.fac`, collapsing `hpt` to `True`.

### `h_epi` — IN PROGRESS (Route 2 attempted, blocked)

Plan-recommended Route 2 attempted: identify the descent with `CommRingCat.KaehlerDifferential.map`
using the η-coherence square, then apply `_root_.KaehlerDifferential.map_surjective`.

**Approach attempted** (per task result):
1. `apply SheafOfModules.epi_of_epi_presheaf; rw [PresheafOfModules.epi_iff_surjective]; intro U`.
2. Set up `φ_fg', φ_2', adj_f, adj_fg, η` locals.
3. Re-derive `hη : η ≫ φ_2' = φ_fg'` η-coherence inline (≈30 lines).
4. Build `fac : η.app U ≫ φ_2'.app U = φ_fg'.app U ≫ 𝟙 _`.
5. Set up algebra instances via `letI` for `A_fg → B`, `A_2 → B`, `A_fg → A_2`.
6. Establish `IsScalarTower A_fg A_2 B` via `IsScalarTower.of_algebraMap_eq'`.
7. Use `_root_.KaehlerDifferential.map_surjective` to get a preimage at the
   unbundled level; transfer via `Submodule.span_induction` + the identity
   `((cotangentExactSeqBeta f g).val.app U).hom = _root_.KaehlerDifferential.map _ _ _ _`.

**Attempts tried, errors logged** (subset of the 13 substantive edits on Differentials):

| Tactic | Result | Diagnostic |
|---|---|---|
| `set_option maxHeartbeats 16000000 in` lifted above `cotangentExactSeq_structure` | ✓ accepted (event 113, log line 263 clean) | needed for the new active body |
| Initial misplacement of `set_option` (above a docstring) | ✗ FAIL | event 133, log line 307: `unexpected token 'set_option'; expected 'lemma'` — `set_option` cannot sit above a docstring; must sit between docstring and `lemma`. |
| `letI A_fg_algebra : Algebra (… : Type _) (… : Type _) := (φ_fg'.app U).hom.toAlgebra` | ✗ FAIL | "failed to synthesize instance of type class Algebra ↑(…) ↑(…)" — the `: Type _` annotation triggers re-elaboration that drops the toAlgebra instance hypothesis. |
| `exact _root_.KaehlerDifferential.map_surjective` | ✗ FAIL | type mismatch — Mathlib's `KaehlerDifferential.map R S B B` has the unbundled type, not the descent's bundled `ModuleCat (forget₂-image)` type. |
| `convert _root_.KaehlerDifferential.map_surjective ?_ ?_ ?_ using 1` | ✗ FAIL | same type mismatch + 4 unsolved metavariables for `R S B`. |
| `congr_arg ConcreteCategory.hom fac` (build `fac_ring`) | ✗ FAIL | event 136, log line 314: `Function expected at ConcreteCategory.hom (…)` — `ConcreteCategory.hom` is not a function in the partial-application shape used. |
| `calc`-style chain `algebraMap _ _ = (algebraMap _ _).comp (algebraMap _ _)` | ✗ FAIL | event 157, log line 359: `invalid 'calc' step, failed to synthesize Trans` — the `calc` syntax does not have the transitivity instance for `RingHom`-shaped equalities in that exact form. |
| `change ∃ x, _ = (y : _root_.KaehlerDifferential A B)` to unbundle the goal | ✗ FAIL | event 168, log line 386: `Application type mismatch: U has type (TopologicalSpace.Opens ↑X)ᵒᵖ but is expected to have type …` — bundled/unbundled type mismatch on the projection. |
| `Submodule.span_induction (p := fun w _ => …) ?_ ?_ ?_ ?_ hz` with bundled Algebra setup | ✗ FAIL | the `D b` case `rintro _ ⟨b, rfl⟩` fails with "`x✝ : ?m.2809` is not an inductive datatype" — Lean cannot unfold the bundled goal to expose `_root_.KaehlerDifferential`'s inductive structure. |

After multiple rounds, the prover reverted the `h_epi` body to the consolidated absorbed
`sorry`. **`exact_iff_stalkwise` was NOT introduced** (per the iter-081 conditional clause:
introducing it without `h_epi` closing would shift 5 → 6, a regression). Final state at
event 183/log line 422: 0 errors, 5 sorries, all expected `declaration uses sorry` warnings.

### Sorry-count budget

- 5 (start) → 5 (end). Stretch target (4 if `exact_iff_stalkwise` body closes) **NOT hit**.
- The `h_zero` reinstatement is a structural advance: the conjunction is now narrower
  (`h_exact ∧ h_epi` only, not the full `h_zero ∧ h_exact ∧ h_epi`).
- Sorry locations table (from prover task result):

  | Line | Decl | Status |
  |---|---|---|
  | 122 | `relativeDifferentialsPresheaf_isSheaf` | unchanged (out of scope) |
  | 576 | `cotangentExactSeq_structure` (now narrower: `h_exact ∧ h_epi`) | iter-082: `h_zero` closed in code; conjunction documented |
  | 860 | `smooth_iff_locally_free_omega` | unchanged (out of scope) |
  | 877 | `cotangent_at_section` | unchanged (out of scope) |
  | 1019 | `serre_duality_genus` | unchanged (out of scope) |

### Approaches confirmed dead-end (DO NOT retry per iter-082 task result)

- `letI A_fg_algebra : Algebra (… : Type _) (… : Type _)` with explicit `: Type _`
  annotation triggers re-elaboration that loses `toAlgebra` instance.
- Direct `exact _root_.KaehlerDifferential.map_surjective` against the bundled descent.
- `Submodule.span_induction` under the bundled Algebra setup — the bundled goal does
  not expose the inductive structure that `rintro _ ⟨b, rfl⟩` needs.

### Iter-083+ recipe (from prover task result)

**Option A — Refactor approach** (refactor-subagent eligible):
1. Extract the η-coherence as a top-level helper `cotangentExactSeqBeta_hη`.
2. With `hη` available externally, write `h_epi` using `algebraize` for algebra+tower setup,
   then `convert _root_.KaehlerDifferential.map_surjective using 1`.

**Option B — Direct in-line route continued** (current iter-082 attempt, cleaner type handling):
1. Use named `let A_fg : Type _ := (... .obj U).carrier` bindings instead of
   `(... .obj U : Type _)` inline coercions — prevents the re-elaboration breakage.
2. Build `fac_ring : algebraMap _ _ = (algebraMap _ _).comp (algebraMap _ _)` directly,
   not through `CommRingCat.Hom.hom` of `≫`.
3. `show ∃ x, _root_.KaehlerDifferential.map _ _ _ _ x = y` (after establishing the
   descent equals the map at the function level) before applying `map_surjective`.

**Option C — Stalkwise-only approach** (skip `h_epi` Route 2):
Drop the `KaehlerDifferential.map` identification; instead build `SheafOfModules.exact_iff_stalkwise`
(multi-iter TopCat-stalk preserves-exactness chain) and use it to close BOTH `h_exact`
AND `h_epi`. This avoids the bundled-vs-unbundled identification entirely.

---

## Lane 3 — `Modules/Monoidal.lean`: deferred (off-limits this iter)

Not assigned. Mathlib gap (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀)
unchanged. Sorry count: 1.

---

## Key findings / patterns surfaced this session

### Pattern (NEW iter-082): `rw [show ... = ... from rfl]` re-fold for limit/iso transport

When `simp` exposes a `limit.isoLimitCone ⟨productCone, productConeIsLimit⟩` shape
but downstream simp lemmas (e.g. `piIsoPi_hom_ker_subtype_apply`) are stated against
the `ModuleCat.piIsoPi` API form, re-fold via `rw [show … = ModuleCat.piIsoPi … from rfl]`.
**Watch the syntax**: use `⟨..., ...⟩` anonymous-constructor brackets, NOT
`{cone := …, isLimit := …}` brace syntax — the latter conflicts with `show`-expression
scoping (event 38: `unexpected identifier; expected '}'`).

### Anti-pattern (CONFIRMED iter-082): `LinearMap.comp_apply` does NOT rewrite homogeneous `∘ₗ`

Mathlib's `LinearMap.comp_apply` is stated for the semilinear `∘ₛₗ` notation with an
explicit `RingHomCompTriple`. When the goal has the homogeneous `∘ₗ` shape (which IS
`LinearMap.comp` with `RingHom.id`), higher-order unification fails to bridge the two
even though they are definitionally equal. **Workaround**: either (a) introduce a
named `let M : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := eqToHom_hom ∘ₗ Σ_hom` abbreviation so the
comp lives behind a single name, then work with `M` directly, or (b) bypass the split
entirely via per-summand reasoning at the function-evaluation level (`Pi.lift_apply`
+ `Finset.sum_apply` from a different angle).

### Anti-pattern (CONFIRMED iter-082): `set_option maxHeartbeats N in` above a docstring

The `set_option` annotation cannot sit *above* a docstring `/-- … -/` — it must sit
*between* the docstring and the `lemma`/`theorem` keyword. Misplacement triggers
`unexpected token 'set_option'; expected 'lemma'` (event 133, log line 307).

### Anti-pattern (CONFIRMED iter-082): `Submodule.span_induction` under bundled Algebra setup

When working with `ModuleCat (forget₂-image)`-valued goals, `Submodule.span_induction`'s
`rintro _ ⟨b, rfl⟩` for the `D b` case fails with "`x✝ : ?m.2809` is not an inductive
datatype" — the bundled goal does not expose `_root_.KaehlerDifferential`'s inductive
structure even after `change` / `letI`. Reinforces the iter-081 finding: structurally
identify the descent with `CommRingCat.KaehlerDifferential.map` BEFORE invoking
surjectivity arguments, rather than fighting the typeclass synthesizer.

### Pattern (reaffirmed iter-082): `set_option maxHeartbeats N in` lifted on the enclosing theorem

The iter-082 work needed `set_option maxHeartbeats 16000000 in` on
`cotangentExactSeq_structure` to accommodate the now-active Route (c) chain
(~70 LOC of inline tactic work). The annotation sits between the docstring and
the `lemma`, propagating to pre-`intro` whnf as expected.

---

## Blueprint markers updated (manual)

None this iter.

The blueprint chapter `Differentials.tex` already carries `\lean{...}` macros for
both `cotangentExactSeq_structure` (Lemma `lem:cotangent_exact_structure`) and
`PresheafOfModules.Derivation.postcomp_comp` (Lemma `lem:derivation_postcomp_comp`).
Both `\lean{...}` lines were correctly set by the plan agent in earlier iterations and
no rename occurred this iter. The deterministic `sync_leanok` phase that ran between
the prover and this review will have managed `\leanok` on the proof blocks based on
actual sorry counts:
- `cotangentExactSeq_structure`'s body still has an absorbed `sorry` at L576 — the
  proof block should NOT have `\leanok`, and the statement block keeps `\leanok`
  (the declaration exists with a `sorry`-bearing body).
- `Derivation.postcomp_comp`'s body remains fully closed — both statement and proof
  blocks should have `\leanok`.

`SheafOfModules.exact_iff_stalkwise` was NOT introduced this iter (per conditional
clause). The blueprint chapter's `\lean{SheafOfModules.exact_iff_stalkwise}` macro
(if present) continues to point at a non-existent declaration; `sync_leanok` will
not have added `\leanok`. No `% NOTE:` action needed: this is a planned helper, not
a translation failure.

No `\notready` markers in active chapters this iter. No `\lean{...}` renames detected.
No `\mathlibok` adds appropriate (the closed `h_zero` chain uses Mathlib pieces
internally but the lemma itself is a project-local non-Mathlib statement).

---

## Recommendations for next session

See `recommendations.md`.
