# Session 79 — iter-079 review

## Metadata

- **Archon iteration**: 079
- **Stage**: prover (three substantive lanes — Differentials, BasicOpenCech, Modules/Monoidal)
- **Sorry count before iter-079**: 15 active syntactic sorry sites (per iter-078 review).
- **Sorry count after iter-079**: **14** active syntactic sorry sites.
  - Per-file (verified via `grep -nE '^\s*sorry\s*$|^\s*sorry\s+--|^\s*sorry\s*\)|=\s*sorry\s*$|=\s*sorry\s+--|^\s*sorry\s+}|sorry\s*}'` on project source):
    - `Differentials.lean`: **5** (L122, L487, L771, L788, L930) — unchanged in count, but L460 was renumbered to L487 after docstring expansion + the new `epi_of_epi_presheaf` gap-fill landed at ~L437.
    - `Cohomology/BasicOpenCech.lean`: **6** (L502, L826, L854, L1145, L1185, L1214) — unchanged in count; L1110 renumbered to L1145 after an iter-079 expanded comment block at the `h_diff_pi_smul_f` site.
    - `Modules/Monoidal.lean`: **1** (L126: `instIsMonoidal_W`) — was 2 (L112, L124); both originally-targeted sorries CLOSED via `LocalizedMonoidal` route, opening exactly the single explicitly-permitted gap-fill.
    - `Jacobian.lean`: **1** (L179) — unchanged (off-limits).
    - `Picard/Functor.lean`: **1** (L190) — unchanged (off-limits).
- **Net change**: **−1 sorry** (Monoidal: 2 → 1; Differentials/BasicOpenCech: no net change; one new project-local gap-fill `SheafOfModules.epi_of_epi_presheaf` landed with a complete proof, no sorry).
- **Compilation status**: All affected files compile cleanly. Final `lean_diagnostic_messages` per file returns `error_count: 0`.
- **Env state**: 21 `lean_diagnostic_messages` invocations (multiple clean terminators); 0 `lake build` calls; 14 source edits; 5 `lean_goal` checks; 40 lemma searches across `lean_local_search` / `lean_leansearch` / `lean_loogle` / `lean_multi_attempt`; 0 `lean_run_code` pre-validation (per user policy).

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Differentials.lean` | PARTIAL (gap-fill landed; `cotangentExactSeq_structure` body still sorry) | 0 (gap-fill compiles; body unchanged) | yes |
| 2 | `Cohomology/BasicOpenCech.lean` | IN PROGRESS (one new `change` step; no closure) | 0 | yes |
| 3 | `Modules/Monoidal.lean` | **PARTIAL (2 targets closed via single permitted gap-fill)** | **−1** | yes |

---

## Lane 1 — `Differentials.lean`: close `cotangentExactSeq_structure`

**Status**: PARTIAL. The new gap-fill `SheafOfModules.epi_of_epi_presheaf` landed cleanly with a complete proof at L437–443 (one of the two explicitly permitted gap-fills). The central `cotangentExactSeq_structure` body remains a single `sorry` because the iter-076 preserved chain's `simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]` step fails under the iter-078 elaboration shape. File now has **5 sorries** (no regression; same as start).

### Closure artefact: `SheafOfModules.epi_of_epi_presheaf` (gap-fill #2 of plan-permitted pair)

```lean
lemma _root_.SheafOfModules.epi_of_epi_presheaf
    {C : Type*} [Category C] {J : CategoryTheory.GrothendieckTopology C}
    {R : CategoryTheory.Sheaf J RingCat} {F G : SheafOfModules R} (f : F ⟶ G)
    (h : CategoryTheory.Epi f.val) : CategoryTheory.Epi f := by
  have : CategoryTheory.Epi ((SheafOfModules.forget R).map f) := by
    rw [SheafOfModules.forget_map]; exact h
  exact (SheafOfModules.forget R).epi_of_epi_map this
```

Flagged with `-- GAP-FILL (iter-079, Lane 1):` comment. Compiles cleanly. Provides the SheafOfModules→PresheafOfModules epi-reflection bridge that `h_epi` will consume in iter-080.

### Why `cotangentExactSeq_structure` did not close

Two confirmed elaboration shifts between iter-076 (when the chain was first authored) and iter-078 (when `cotangentExactSeqAlpha.d_app` closed via the ζ-bridge) invalidate the preserved chain's central simp step:

1. **`(f ≫ g).val` is reduced eagerly** to the raw structure form `{ app := …, naturality := … }.val.app x` (verified via `dsimp only [CategoryStruct.comp, SheafOfModules.instCategory]`). After `apply SheafOfModules.hom_ext`, the iter-076 simp lemma `SheafOfModules.comp_val` finds no redex — `rw [SheafOfModules.comp_val]` errors with "did not find an occurrence of the pattern `(?f ≫ ?g).val`".

2. **`SheafOfModules.pushforward_map_val` is stale**: this Mathlib lemma is about the *continuous-functor* `SheafOfModules.pushforward`, not the project-local `AlgebraicGeometry.Scheme.Modules.pushforward`. The latter is its own definition (in `Mathlib.AlgebraicGeometry.Modules.Sheaf`) with its own `Hom.app` / `pushforward_map_app` API.

### Attempts (Lane 1)

#### Attempt 1 — Add `SheafOfModules.epi_of_epi_presheaf` gap-fill

- **Approach.** `Functor.epi_of_epi_map` plus `SheafOfModules.instFaithfulPresheafOfModulesValRingCatForget` plus `SheafOfModules.forget_map`.
- **Result.** SUCCESS. Single declaration, ~7 lines, compiles cleanly. Stamped with `-- GAP-FILL (iter-079, Lane 1):` per user policy.

#### Attempt 2 — Inline iter-076 preserved chain in body of `cotangentExactSeq_structure`

- **Approach.** `apply ((pullbackPushforwardAdjunction f).homEquiv _ _).injective; rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]; unfold cotangentExactSeqAlpha; simp only [Equiv.apply_symm_apply]; apply SheafOfModules.hom_ext; simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]`.
- **Error.** `` `simp` made no progress ``.
- **Root cause.** Documented above: eager reduction of `(f ≫ g).val` + stale `pushforward_map_val` name.

#### Attempt 3 — Probe alternative reductions via `lean_multi_attempt`

- `simp only [SheafOfModules.comp_val]` alone — `simp made no progress`.
- `rw [SheafOfModules.comp_val]` — pattern not found.
- `rfl` after `apply SheafOfModules.hom_ext` — not defeq.
- `change _ = (0 : _ ⟶ _).val` — `0` infers to `ℕ` without type-class hints; field-projection error.
- `dsimp only [CategoryStruct.comp, SheafOfModules.instCategory]` — succeeds but unfolds to the raw `{ app := … }.val.app x` form, NOT a redex for the iter-076 chain.
- `apply PresheafOfModules.Hom.ext` after `hom_ext` — fails to unify (goal is not yet in per-app form).

#### Attempt 4 — Roll back to single `sorry` with detailed in-body diagnostic comments

- **Approach.** Preserve the disabled-chain block (L480–717) verbatim for iter-080 reuse. Document inline exactly which simp step fails and why.
- **Result.** PARTIAL. Body retains a single `sorry` at L487. The second permitted gap-fill `SheafOfModules.exact_iff_stalkwise` was deliberately NOT introduced: doing so with a `sorry` body would push the file to 6 sorries (over the iter-079 hard cap), and a proof requires the `TopCat.Presheaf.stalkFunctor`-preserves-exactness chain (multi-iteration infrastructure).

### Lemmas leveraged this lane (confirmed iter-079)

- `SheafOfModules.forget R : SheafOfModules R ⥤ PresheafOfModules R.val` — faithful (`SheafOfModules.instFaithfulPresheafOfModulesValRingCatForget`).
- `SheafOfModules.forget_map` : `(SheafOfModules.forget R).map f = f.val`.
- `Functor.epi_of_epi_map` / `Functor.reflectsEpimorphisms_of_faithful`.
- `PresheafOfModules.epi_iff_surjective` — for iter-080.
- `KaehlerDifferential.map_surjective` / `KaehlerDifferential.span_range_derivation` / `KaehlerDifferential.exact_mapBaseChange_map` — for iter-080.

---

## Lane 2 — `Cohomology/BasicOpenCech.lean`: close `h_diff_pi_smul_f`

**Status**: IN PROGRESS. One additional structural step (a `change` to expose the RHS smul explicitly as `h_mod_pi₂.toSMul.smul r _ j`) landed on top of iter-078's `intro r y; funext j`. Sorry count unchanged 6 → 6. The substantive S2–S8 chain is still blocked by the same `Pi.smul_apply`-against-`RingHom.toModule`-builder hazard documented iter-078.

### The advance this iteration

```lean
change e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) j =
  h_mod_pi₂.toSMul.smul r
    (e₂ ((ConcreteCategory.hom scK₀.f) (e₁.symm y))) j
```

Closes by `change` (definitional). After this step the LSP reduces the RHS automatically to `SMul.smul r _ j`. Confirms the implicit `(r • _) j` smul on the RHS is *definitionally* equal to `h_mod_pi₂.toSMul.smul r _ j` — sidesteps `simp [Pi.smul_apply]` failures by naming the smul explicitly. This is a genuine advance: the iter-078 prover noted that `simp` and `rw` both fail with "did not find the pattern" because the smul instance is `RingHom.toModule`-built with anonymous per-i instances.

### The remaining blocker (precisely)

After the `change`, the natural next step is `rw [Pi.smul_apply]` to evaluate the RHS componentwise as `(perJ).smul r ((e₂ …) j)` where `perJ : Module R (Z₂ j)` is the j-th anonymous per-i Module instance bound inside `h_mod_pi₂`'s `Pi.module` builder. This still fails because `perJ` is anonymous — typeclass search cannot find it. Confirmed by attempting `letI mod_Z₂_per : ∀ i, Module R (Z₂ i) := …` with an identical constructor: even with the parallel `letI` in scope, `Pi.smul_apply` still does not fire — the smul in the goal is from `h_mod_pi₂.toSMul`, NOT the new `letI` instance, and Lean does not bridge the two Pi-builders at the instance level.

### Attempts (Lane 2)

| # | Approach | Result | Insight |
|---|---|---|---|
| 1 | `change … = h_mod_pi₂.toSMul.smul r _ j` | SUCCESS (defeq) | Smul names match; explicit form unblocks further targeting. |
| 2 | `rw [Pi.smul_apply]` after the `change` | FAILED ("did not find the pattern") | Smul keyed on `h_mod_pi₂.toSMul`, not `Pi.instSMul`. |
| 3 | `letI mod_Z₂_per : ∀ i, Module R (Z₂ i) := …` + `letI : ∀ i, SMul R (Z₂ i) := …` + `rw [Pi.smul_apply]` | FAILED (same pattern error) | Parallel instances do not unify with `h_mod_pi₂`-mediated smul. |
| 4 | `rfl` after the `change` | FAILED (not defeq) | LHS still needs S2 5-layer dsimp + S3 alternating-sum exposure. |
| 5 | `show … = (Pi.instSMul.smul r _) j` | FAILED (not defeq) | `Pi.instSMul` ≠ `h_mod_pi₂.toSMul` syntactically. |
| 6 | `change … = (@HSMul.hSMul _ _ _ Pi.instHSMul …)` | FAILED (`Pi.instHSMul` not a global identifier) | — |

### Recommended path iter-080 (from prover task result)

Refactor `h_mod_pi₂` at L921–930 (and symmetrically `h_mod_pi₁` at L911 and `h_mod_pi₃` at L931) to use a named per-i instance:

```lean
letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
  apply RingHom.toModule; refine (C.left.presheaf.map (homOfLE ?_).op).hom; …
have h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
-- or: letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := inferInstance
```

After this refactor, `[∀ i, SMul R (Z₂ i)]` is synthesisable from `perI₂`, and `Pi.smul_apply` fires directly. This is **not** a "new project-local helper lemma" — it's a literal expansion of the existing `Pi.module` construction into named pieces, preserving the same Module structure byte-for-byte.

### Constraints respected

- ✓ No new project-local helper lemmas added (only the `change` step).
- ✓ No new axioms.
- ✓ No `lean_run_code` pre-validation.
- ✓ `set_option maxHeartbeats 800000 in` at L418 preserved.
- ✓ iter-078 `funext j` at L1094 preserved.

---

## Lane 3 — `Modules/Monoidal.lean`: supply `W.IsMonoidal`, close both `MonoidalCategory(Struct)` instances

**Status**: PARTIAL — net **−1 sorry** (2 → 1). Both originally-targeted sorries closed via `LocalizedMonoidal`. The substantive remaining content is concentrated in the single explicitly permitted gap-fill `instIsMonoidal_W`, exactly as the iter-079 plan directed.

### Closure architecture

1. **`sheafificationFunctor X`** introduced as `noncomputable abbrev` for `PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)`.
2. **`W X`** introduced as `(MorphismProperty.isomorphisms _).inverseImage (sheafificationFunctor X)`.
3. **`instMonoidalCategoryPresheaf`** (structural bridge): `MonoidalCategory (_root_.PresheafOfModules X.ringCatSheaf.obj) := show … from inferInstance` — installs the Mathlib instance through the definitional equality `X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ CommRingCat RingCat`. Required at top-level (not `letI`) because `(W X).IsMonoidal` and `LocalizedMonoidal` references occur in the *types* of subsequent instances.
4. **`instIsMonoidal_W`** (single permitted gap-fill, sorry): `MorphismProperty.IsMonoidal.mk' _ fun {…} f g hf hg => …; simp only [MorphismProperty.inverseImage_iff, MorphismProperty.isomorphisms.iff] at hf hg ⊢; sorry`. Substantive content (iso-stability of sheafification under presheaf-tensor whiskering) is the gap.
5. **`instMonoidalCategoryStruct`** closed: `inferInstanceAs (MonoidalCategoryStruct (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))`.
6. **`instMonoidalCategory`** closed analogously.
7. **`tensorObj`** at L60–66 **preserved byte-for-byte** from iter-078 per plan constraint.

### Why the gap-fill is hard (3 routes investigated)

1. **`tensorHom_def` decomposition** (`f ⊗ₘ g = (f ▷ Y₁) ≫ (X₂ ◁ g)`): reduces to `whiskerLeft`/`whiskerRight` stability — same condition, no progress.

2. **`sheafificationCompToSheaf` reduction**: would route through `(presheafToSheaf AddCommGrpCat).map ((toPresheaf R₀).map h)`. **Blocked because** `toPresheaf R₀` is NOT monoidal — the presheaf-of-modules tensor on `PresheafOfModules R₀` evaluates pointwise as the `R₀(U)`-balanced tensor `M(U) ⊗_{R₀(U)} N(U)`, whereas the abelian-presheaf tensor is the ℤ-tensor. `J.W.IsMonoidal` for `AddCommGrpCat` (Mathlib `Sites/Monoidal.lean:149`, braided+closed) does not transfer.

3. **Closedness via internal hom** (Mathlib `Sites/Monoidal.lean:165` template): would need `MonoidalClosed (PresheafOfModules R₀)` + `HasFunctorEnrichedHom` for presheaves of modules **with varying R₀**. Mathlib only has the fixed-ring case (`ModuleCat/Monoidal/Closed.lean`). Substantial multi-PR upstream effort.

### Attempts (Lane 3)

#### Attempt 1 — Add `sheafificationFunctor` + `W` abbreviations

- **Code.**
  ```lean
  noncomputable abbrev sheafificationFunctor : _root_.PresheafOfModules.{u} X.ringCatSheaf.obj ⥤ X.Modules :=
    _root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)
  abbrev W (X : Scheme.{u}) :
      MorphismProperty (_root_.PresheafOfModules X.ringCatSheaf.obj) :=
    (MorphismProperty.isomorphisms _).inverseImage (sheafificationFunctor X)
  ```
- **Result.** SUCCESS.

#### Attempt 2 — Add bridging instance `instMonoidalCategoryPresheaf`

- **Code.**
  ```lean
  noncomputable instance instMonoidalCategoryPresheaf :
      MonoidalCategory (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategory
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u}))
      from inferInstance
  ```
- **Result.** SUCCESS. Structural bridge — not a "thin helper" in the user-policy sense.

#### Attempt 3 — `instMonoidalCategoryStruct` via `inferInstanceAs`

- **Code.**
  ```lean
  noncomputable instance instMonoidalCategoryStruct : MonoidalCategoryStruct (X.Modules) :=
    inferInstanceAs (MonoidalCategoryStruct
      (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))
  ```
- **Result.** SUCCESS — `Localization.Monoidal.monoidalCategoryStruct` (`Basic.lean:172`) inhabits.

#### Attempt 4 — `instMonoidalCategory` via `inferInstanceAs`

- **Code.** Symmetric; uses `Localization.Monoidal.MonoidalCategory` instance (`Basic.lean:440`).
- **Result.** SUCCESS.

#### Attempt 5 — Try to close `instIsMonoidal_W` gap-fill

- **Code.**
  ```lean
  refine MorphismProperty.IsMonoidal.mk' _ fun {X₁ X₂ Y₁ Y₂} f g hf hg => ?_
  simp only [MorphismProperty.inverseImage_iff,
    MorphismProperty.isomorphisms.iff] at hf hg ⊢
  sorry
  ```
- **Result.** PARTIAL. Reduction step succeeds; substantive iso-stability remains.

### Mathlib references leveraged (confirmed iter-079)

- `CategoryTheory.LocalizedMonoidal` — `Localization/Monoidal/Basic.lean:86`. Type synonym for `D`.
- `Localization.Monoidal.monoidalCategoryStruct` — `Basic.lean:172`.
- `Mathlib instance MonoidalCategory (LocalizedMonoidal ...)` — `Basic.lean:440`.
- `MorphismProperty.IsMonoidal.mk'` — `Basic.lean:50–54`.
- `Adjunction.isLocalization` — `Localization/Adjunction.lean:139`. Right-adjoint Full+Faithful ⇒ left adjoint is localization.
- `PresheafOfModules.sheafificationAdjunction` — `ModuleCat/Presheaf/Sheafification.lean:124`. Right adjoint Full (`:168`) and Faithful (`:171`).
- `PresheafOfModules.monoidalCategory` — `ModuleCat/Presheaf/Monoidal.lean:125`.

### Constraints respected

- ✓ Both originally-targeted closures realised; net −1 sorry.
- ✓ One bridging instance added (`instMonoidalCategoryPresheaf`) — purely structural, bridges a definitional equality, authorised per user policy.
- ✓ `tensorObj` (L60–66) preserved byte-for-byte from iter-078.
- ✓ One semantic gap-fill (`instIsMonoidal_W`) retained per plan permission, flagged with the docstring noting the Mathlib gap.
- ✓ No new axioms; no `lean_run_code` pre-validation; hard cap honoured (2 → 1).

---

## Key findings / proof patterns discovered iter-079

- **`change` as smul-instance-renamer when `Pi.smul_apply` fails** *(NEW iter-079)*. When a smul `(r • y) j` is mediated by a `Pi.module`-built `RingHom.toModule` family (anonymous per-i builders), `Pi.smul_apply` does not fire (rw or simp). Use `change e (…) j = INST.smul r _ j` where `INST` is the named outer `Module` term — this is defeq, exposes the smul explicitly, and unblocks downstream rewrites. NOT sufficient to close per-component R-linearity (still need the underlying refactor to name the per-i instances), but it's the first step.
- **`LocalizedMonoidal + inferInstanceAs` closes Mathlib-template monoidal-category instances on localizations** *(confirmed iter-079; foreshadowed iter-078)*. When `L : C ⥤ D` is a localization at `W` (via `Adjunction.isLocalization` + `Full + Faithful` right adjoint) and `W.IsMonoidal` holds, `MonoidalCategoryStruct D` and `MonoidalCategory D` both close as `inferInstanceAs (… (LocalizedMonoidal L W (Iso.refl _)))`. The substantive content concentrates entirely in `W.IsMonoidal`.
- **Structural bridging instance via `show … from inferInstance` is mandatory, not optional, at top-level when the bridged type appears in subsequent instance *types*** *(NEW iter-079)*. The iter-078 prover used `letI : MonoidalCategory ... := show ... from inferInstance` inside each `instMonoidalCategoryStruct` / `instMonoidalCategory` proof body. Iter-079 lifts this to a top-level `noncomputable instance` (`instMonoidalCategoryPresheaf`) because `(W X).IsMonoidal` references the bridged type in its type-class search context.
- **Faithful-functor epi-reflection bridges PresheafOfModules → SheafOfModules** *(NEW iter-079, gap-fill)*. `Functor.epi_of_epi_map` applied to `SheafOfModules.forget R` (faithful, `:instFaithfulPresheafOfModulesValRingCatForget`) plus `SheafOfModules.forget_map` (`= f.val`) yields a 7-line bridge `Epi f.val → Epi f`. This is one of the two permitted gap-fills for `cotangentExactSeq_structure.h_epi`.
- **`SheafOfModules.comp_val` and `SheafOfModules.pushforward_map_val` are STALE simp lemmas for iter-078-shape goals** *(NEW iter-079 blocker)*. After elaboration normalises `(f ≫ g).val` to `{ app := … }.val.app x` and Mathlib's `pushforward_map_val` is about the *continuous-functor* variant (not project-local `Scheme.Modules.pushforward`). Use per-section route via `Scheme.Modules.Hom.ext` + `Scheme.Modules.Hom.comp_app` + `Scheme.Modules.pushforward_map_app` instead.

---

## Blueprint markers updated (manual)

None this iteration.

Rationale:
- **No `\mathlibok` warranted**: the new `SheafOfModules.epi_of_epi_presheaf` is a project-local gap-fill that uses Mathlib infrastructure but is itself a new declaration (not a Mathlib re-export). The plan-permitted gap-fill, by definition, *is* the project-side content.
- **No `\lean{...}` corrections**: no prover task result reports a rename or relocation of a chapter-referenced declaration. The `\lean{...}` macros pointing at `cotangentExactSeq_structure`, `instMonoidalCategoryStruct`, `instMonoidalCategory`, etc. all still resolve correctly.
- **No `% NOTE:`**: the unformalized chapter blocks (e.g. `relativeDifferentialsPresheaf_isSheaf`, `serre_duality_genus`) are blocked by mathematical infrastructure depth, not by translation gaps. The plan-agent prose already correctly reflects this.
- **No stale `\notready`**: a project-wide search for `\notready` returns zero hits.
- **`\leanok` (deterministic phase)**: handled by `sync_leanok` (commit `archon[078/marker-sync]`). I did not touch any `\leanok` marker.

---

## Recommendations for next iteration

See `recommendations.md` in this directory.

---

## Self-validation checklist

- [x] milestones.jsonl has valid JSON on every line (verified via per-line `jq -e .`).
- [x] Each milestone has `target.file`, `target.theorem`, `status`.
- [x] Each non-blocked milestone has multiple attempts with `code_tried` and `strategy`.
- [x] Number of attempts per milestone is proportional to the edit + diagnostic counts in `attempts_raw.jsonl` (14 edits across 3 files; 5+4+5 attempts logged).
- [x] summary.md includes specific code and errors, not high-level hand-waving.
- [x] recommendations.md (separate file) has actionable next steps.
- [x] I did NOT add or remove any `\leanok` marker.
- [x] No declaration newly Mathlib-backed reported — no `\mathlibok` added.
- [x] No `\lean{...}` macro rename flagged in any `task_results/*.md`.
- [x] No `\notready` remains anywhere in `blueprint/src/chapters/`.
- [x] No `.lean` file edited; no proof body written by review agent.
