# Session 83 — iter-083 review

## Metadata

- **Archon iteration**: 083
- **Stage**: prover (two substantive lanes — BasicOpenCech, Differentials; Modules/Monoidal off-limits per plan).
- **Sorry count before iter-083**: 14 active syntactic sorry sites.
- **Sorry count after iter-083**: **14** active syntactic sorry sites
  (verified via `grep -nE '^\s*sorry\b|:= sorry\b|:= by sorry\b' AlgebraicJacobian/**/*.lean`).
  - Per-file (active sites):
    - `Cohomology/BasicOpenCech.lean`: 6 — L502, L826, L854, **L1323** (was L1240), **L1368** (was L1285), **L1397** (was L1314). Line numbers shifted +83 LOC due to documentation block expansion at L1198+.
    - `Differentials.lean`: 5 — L122, **L645** (was L576), **L929** (was L860), **L946** (was L877), **L1088** (was L1019). Lines shifted +69 LOC due to insertion of the top-level `cotangentExactSeqBeta_hη` helper (~70 LOC).
    - `Modules/Monoidal.lean`: 1 — L173.
    - `Jacobian.lean`: 1 — L179.
    - `Picard/Functor.lean`: 1 — L190.
- **Net change**: **0** sorries (hard cap respected on both lanes; closure target not hit on either active lane; but Lane 2 landed one helper top-level fully closed).
- **Compilation status**: All files compile cleanly at end-of-iteration.
  - `BasicOpenCech.lean`: final `lean_diagnostic_messages` event 124 (line 124 in JSONL): 0 errors, 0 warnings — clean. The line 143 follow-up shows the expected sorry warnings only.
  - `Differentials.lean`: final `lean_diagnostic_messages` event 190: 0 errors, 0 warnings — clean.
- **Env state (from `attempts_raw.jsonl` summary line, event 1)**:
  144 total events; **9 source edits**; 3 `lean_goal`; 12 `lean_diagnostic_messages`; 35 lemma searches; 0 `lake build`; 0 `lean_run_code` pre-validation
  (per user policy 2026-05-11). Errors line shows 2 total transient errors across the session, both self-resolved by the next edit.

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | PARTIAL ADVANCE — Two `letI := h_mod_X_n` statements landed pre-sorry (surface R-module instances into typeclass cache); ~80-line documentation block records two new structural findings (typeclass-coercion barrier persistence; non-rfl smul commutation through `e₁`). No closure. | 0 (6 → 6) | yes |
| 2 | `Differentials.lean` | PARTIAL — Helper `cotangentExactSeqBeta_hη` **extracted top-level FULLY CLOSED** (no sorry, ~70 LOC at L341–411); `cotangentExactSeqBeta` refactored to use the helper via `.choose`/`.choose_spec` (since `obtain ⟨η, hη⟩ := ...` fails inside a `noncomputable def` body — `Exists.casesOn` cannot eliminate into `Type`). `h_exact ∧ h_epi` of `cotangentExactSeq_structure` remains the absorbed `sorry` at L645 (was L576). Three Route 2 attempts on `h_epi` documented as failing on the bundled-vs-unbundled `KaehlerDifferential.map` identification. | 0 (5 → 5, but 1 helper closed) | yes |
| 3 | `Modules/Monoidal.lean` | not assigned (deferred pending Mathlib upstream gap) | — | unchanged |

---

## Lane 1 — `BasicOpenCech.lean`: `letI` surface + structural findings, no S6 closure

**Status**: PARTIAL ADVANCE. No closure landed. The iter-083 plan's path (a) "named-comp abbreviation" recipe ran aground on a deeper structural barrier than iter-082 documented. The prover delivered two `letI` no-ops and a substantial documentation block to set up iter-084.

### Concrete delivery — `letI` surface + comment block (events 120, 124)

```lean
        letI := h_mod_X₁
        letI := h_mod_X₂
```

inserted before the existing L1240 sorry. These surface the R-module instances
`h_mod_X₁ : Module R ↑scK₀.X₁` and `h_mod_X₂` (defined via `AddEquiv.module R e_i.toAddEquiv`)
into the typeclass cache. Sorry shifted L1240 → L1323 after the comment block landed at L1198+.

### Concrete attack record (iter-083)

**Attempt 1** (event 25, `lean_multi_attempt`): `simp only [LinearMap.comp_apply, LinearMap.coe_comp, Function.comp_apply]`
- Goal head (truncated): `(ConcreteCategory.hom (Pi.π Z₂ j)) (...(piIsoPi Z₁).inv (r • y)...)`
- Result: `simp made no progress`.
- **Insight**: Mathlib's `LinearMap.comp_apply` signature is `(?f ∘ₛₗ ?g) ?x` (semilinear); HOU does not bridge to homogeneous `∘ₗ` even though they are definitionally equal.

**Attempt 2** (event 28): direct `rw [LinearMap.comp_apply]`
- Result: "Did not find an occurrence of the pattern `(?f ∘ₛₗ ?g) ?x` in the target expression."
- **Insight**: same root cause as Attempt 1.

**Attempt 3** (event 33, multi_attempt): `show` with explicit `LinearMap` form via `∑ i, (-1)^(↑i : ℤ) • _`
- Result: "failed to synthesize instance of type class `Fintype ℤ`".
- **Insight**: `(-1)^(↑i : ℤ)` casts the index to ℤ inside the `Fin` indexing, triggering a wrong instance synthesis attempt.

**Attempt 4** (event 35, multi_attempt): `clear h_a_fun h_a; subst hRel`
- Result: "Tactic 'subst' failed: 'n' occurs at `(ComplexShape.up ℕ).prev n + 1`."
- **Insight**: `subst` direction wrong — `n` is the *referenced* variable inside `prev n`, not a fresh substitutable.

**Attempt 5** (event 37, multi_attempt): `rw [hRel] at *`
- Result: succeeds but creates duplicate hypotheses `Z₁✝, Z₂✝, Z₃✝, hn✝, …`.
- **Insight**: rewriting at `*` breaks downstream context references; `clear` fails due to dependencies.

**Attempt 6** (events 51, 53, 55, 57): `letI := h_mod_X₁; letI := h_mod_X₂` then `have : ((e₁.symm (r • y)) : ↑scK₀.X₁) = (r • (e₁.symm y : ↑scK₀.X₁) : ↑scK₀.X₁) := rfl`
- Result: failed with TWO new diagnostic findings (NEW iter-083):

**NEW FINDING 1 (typeclass barrier persistence)** — even after surfacing `h_mod_X₁` / `h_mod_X₂` into typeclass cache via `letI`, the ascription `(r • e₁.symm y : ↑scK₀.X₁)` fails: `failed to synthesize HSMul ↑R ↑(∏ᶜ Z₁) ?m`. Outer type-ascription `: ↑scK₀.X₁` propagates inward; Lean tries `HSMul ↑R ↑(∏ᶜ Z₁) ↑scK₀.X₁` rather than `HSMul ↑R ↑scK₀.X₁ ↑scK₀.X₁`. Defeq `↑(∏ᶜ Z₁) = ↑scK₀.X₁` (verified via `lean_multi_attempt`: `:= rfl` succeeds) does NOT propagate through instance synthesis.

**NEW FINDING 2 (non-rfl smul commutation)** — `e₁.symm (r • y) = r •_{h_mod_X₁} e₁.symm y` is NOT `rfl`. Despite `h_mod_X₁ = e₁.toAddEquiv.module R` defining `r •_{X₁} z := e₁.symm (r •_{Pi.module} e₁ z)`, this identity requires `e₁.apply_symm_apply` on the inner argument — a *lemma*, not `rfl`.

### Iter-083 finding implications for path forward

The iter-083 task result explicitly **revises** the plan-recipe's ~30 LOC estimate
for path (a): the actual closure requires packaging per-summand R-linearity as a
genuine `Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)` constructed via `LinearMap.mk` with
explicit `map_smul'` proved by `Finset.sum_apply` + `Pi.smul_apply (perI₁)` +
`RingHom.map_mul` + `presheaf.map_comp` + project-local `algebraMap_naturality`
(StructureSheafModuleK.lean L161). Estimate revised to **50–80 LOC, multi-iter**.

### Preserved iter-080/081/082 advances

- `set_option maxHeartbeats 800000 in` at L418 (iter-078) — preserved.
- iter-080 `letI` refactor at L920–949 (per-i `Pi.module` named instances) — preserved byte-for-byte.
- iter-081 S2+S3+S4 chain at L1102–1153 — preserved byte-for-byte.
- iter-082 S5 prelude at L1161–1170 (`rw [show … from rfl]` re-fold + `piIsoPi_hom_ker_subtype_apply`) — preserved byte-for-byte.

---

## Lane 2 — `Differentials.lean`: helper `cotangentExactSeqBeta_hη` closed top-level

**Status**: PARTIAL — one *helper* closure (no net sorry change in the file, but reduces inline complexity for iter-084).

### Concrete delivery — `cotangentExactSeqBeta_hη` (NEW, fully closed, L341–411)

Top-level lemma extracted from `cotangentExactSeqBeta`'s former inline body:

```lean
lemma cotangentExactSeqBeta_hη (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
            (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf),
        η ≫ ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
              Y.presheaf X.presheaf).symm f.c =
          ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
              (f ≫ g).base).homEquiv S.presheaf X.presheaf).symm (f ≫ g).c := by
  refine ⟨η, ?_⟩
  change …
  …  -- verbatim iter-082 inline body
```

Body is the **verbatim iter-082 inline proof** of `hη` lifted out, wrapped in
`refine ⟨η, ?_⟩` + `change`. `set_option maxHeartbeats 16000000 in` annotation
preserved.

**Type correction during extraction**: the η codomain is `(pullback f.base).obj Y.presheaf`
(NOT `(pushforward f.base).obj ((pullback f.base).obj Y.presheaf)` as the plan-recipe
suggested). The actual inline `let η` in iter-082's body produces the former.

### `cotangentExactSeqBeta` refactor (event before/after split)

```lean
noncomputable def cotangentExactSeqBeta (f : X ⟶ Y) (g : Y ⟶ S) :
    relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f := by
  let φ1' := …
  let φ2' := …
  let η := (cotangentExactSeqBeta_hη f g).choose
  have hη : η ≫ φ2' = φ1' := (cotangentExactSeqBeta_hη f g).choose_spec
  …
```

**Important nuance (iter-083 NEW finding)**: cannot use `obtain ⟨η, hη⟩ := cotangentExactSeqBeta_hη f g` inside a `noncomputable def` body — `obtain` (which uses `cases`) fails with "recursor `Exists.casesOn` can only eliminate into `Prop`". The `.choose`/`.choose_spec` pattern is the correct workaround.

### Concrete attack record on `h_exact ∧ h_epi` (preserved single absorbed sorry, L645)

Three attempts on `h_epi` via Route 2:

**Attempt 1**: `convert _root_.KaehlerDifferential.map_surjective`
- Result: produces iff residual whose RHS is the FULL Π-statement of `map_surjective`:
  ```
  Function.Surjective ⇑(ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U)) ↔
    ∀ (R S B : Type _) [CommRing R] [CommRing S] [Algebra R S] [CommRing B] …,
      Function.Surjective ⇑(KaehlerDifferential.map R S B B)
  ```
- **Blocker**: cannot close iff residual without identifying the descent with `_root_.KaehlerDifferential.map` for specific `R,S,B`.

**Attempt 2**: `convert _root_.KaehlerDifferential.map_surjective using 1`
- Result: same iff residual but with `ModuleCat.Hom.hom` exposed on LHS via `show ... .hom`.
- **Blocker**: identical to Attempt 1.

**Attempt 3**: `exact _root_.KaehlerDifferential.map_surjective`
- Result: type mismatch — `map_surjective` is a `∀ R S B …` Π-type needing concrete instances.

### Underlying structural blocker (iter-083 consolidated documentation)

The descent `(isUniversal' φ1').desc d1 .app U` and `CommRingCat.KaehlerDifferential.map fac`
agree on generators `d b` (both via `desc_d` + `map_d` + universal property), so they
should be equal by `CommRingCat.KaehlerDifferential.ext`. But the identification requires:

1. A `fac` coherence (obtainable from `congr_arg (NatTrans.app · U) hη` + `Category.comp_id` — now externally available via the new helper).
2. The bundled `Module ((relativeDifferentials f).val.obj U)` instance is over the `forget₂`-image ring, NOT directly over `X.presheaf.obj U`. `Submodule.span_induction` over this bundled module fails ("`x✝ : ?m.N` is not an inductive datatype").
3. `algebraize [...]` introduces fresh Algebra/IsScalarTower instances that don't unify with the bundled `letI := f.hom.toAlgebra` instance inside `CommRingCat.KaehlerDifferential`'s body.

Iter-084+ paths (a) bundled `CommRingCat.KaehlerDifferential.map_surjective` API (Mathlib gap-fill), (b) `KaehlerDifferential.ext`-based identification chain, (c) direct `Submodule.range = ⊤` via `KaehlerDifferential.span_range_derivation`.

### Decision on `_root_.SheafOfModules.exact_iff_stalkwise`

The iter-083 plan's Option C (introduce `exact_iff_stalkwise` as a free-floating sorry) was correctly **NOT pursued** by the prover — that would have been a 5 → 6 regression. Lane 2 conditional clause respected.

### Preserved iter-079/081/082 advances

- `_root_.SheafOfModules.epi_of_epi_presheaf` at L438–444 (iter-079) — preserved.
- `_root_.PresheafOfModules.Derivation.postcomp_comp` at L454–465 (iter-081) — preserved.
- Reinstated Route (c) chain for `h_zero` (~70 LOC at L488–559, iter-082) — preserved (now living at the shifted offset due to the new helper above).
- `set_option maxHeartbeats 16000000 in` at L467 — preserved.

---

## Helpers landed across iter-079 / 081 / 083 chain (cumulative)

| Helper | Iter | Status | File location (post iter-083) |
|--------|------|--------|-------------------------------|
| `_root_.SheafOfModules.epi_of_epi_presheaf` | 079 | closed | Differentials.lean L496–502 |
| `_root_.PresheafOfModules.Derivation.postcomp_comp` | 081 | closed | Differentials.lean L512–523 |
| `cotangentExactSeqBeta_hη` | 083 | **closed (NEW)** | Differentials.lean L341–411 |
| `_root_.SheafOfModules.exact_iff_stalkwise` | (pending) | not introduced | — |

---

## Key findings / proof patterns discovered

1. **`letI`-surfaced R-module instance does NOT bridge `HSMul ↑R ↑(∏ᶜ Z₁)` when type-ascription propagates inward** (NEW iter-083). Even when `(↑(∏ᶜ Z₁) : Type _) = ↑scK₀.X₁ := rfl` holds, the instance synthesis path for `(r • z : ↑scK₀.X₁)` tries the source-side carrier `↑(∏ᶜ Z₁)` rather than the target-side `↑scK₀.X₁`. **Fix**: construct the per-summand R-linear map at the *target* carrier explicitly (`Φ_j : (∀ i, Z₁ i) →ₗ[R] ↑(Z₂ j)`) instead of trying to commute smul across `e₁.symm`.

2. **`e₁.symm (r • y) = r •_{AddEquiv.module} e₁.symm y` is NOT rfl** (NEW iter-083). The `AddEquiv.module R e` instance defines smul as `r • z := e.symm (r • e z)`, so the would-be identity requires `e.apply_symm_apply` collapse on the inner argument. Lemma, not definitional.

3. **`subst hRel` fails when the bound variable occurs inside its own substitution target** (NEW iter-083). `subst` requires the substituted variable to appear "freshly" — `n` inside `prev n + 1` is a reference, not a substitutable.

4. **`.choose`/`.choose_spec` is the correct destructuring pattern inside `noncomputable def` bodies** (NEW iter-083). `obtain ⟨a, b⟩ := h` fails when the surrounding return type is `Type _` and `h : ∃ ...` is in `Prop`. The `cases`/`Exists.casesOn` recursor cannot eliminate `Prop` into `Type`. Use `.choose` instead.

5. **Bundled-vs-unbundled `KaehlerDifferential.map` identification is a multi-iter Phase B blocker** (iter-081 reaffirmed, iter-083 documented). Mathlib's `KaehlerDifferential.map_surjective` is `∀ R S B ...`-quantified; the bundled `Module ((relativeDifferentials f).val.obj U)` instance is built over `forget₂`-image rings, not the direct `X.presheaf.obj U`. `algebraize` introduces fresh instances that don't unify.

---

## Blueprint markers updated (manual)

- `Differentials.tex`, `lem:cotangent_exact_seq_beta_hη` (line 129): fixed structural typo `\end{lemma>` → `\end{lemma}` (LaTeX environment-close was malformed; flagged by the iter-083 Lane 2 prover task report).

**No other manual `\mathlibok` / `% NOTE:` / `\notready` changes this iter.** The deterministic `sync_leanok` phase that ran before this review should have added `\leanok` to `lem:cotangent_exact_seq_beta_hη` (the new helper is sorry-free; line 120 already shows `\begin{lemma}\leanok` consistent with that). No `\lean{...}` macro renames were flagged by either prover.

## Compilation snapshot

- `Cohomology/BasicOpenCech.lean`: 6 sorries, clean compile.
- `Differentials.lean`: 5 sorries, clean compile (the new `cotangentExactSeqBeta_hη` adds no sorry).
- All other files unchanged.

## Recommendations for next session

See `recommendations.md`.
