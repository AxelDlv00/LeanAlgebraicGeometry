# Session 65 — iter-065 review

## Metadata

- **Archon iteration**: 065
- **Stage**: prover (continue substep component (i) on BasicOpenCech; un-block Differentials)
- **Plan-agent work this iteration (pre-prover)**:
  - Two parallel prover lanes dispatched: `Cohomology/BasicOpenCech.lean` (continue component-(i) `h_transport` scaffold) and `Differentials.lean` (repair iter-064's broken file + decompose `relativeDifferentialsPresheaf_isSheaf`).
- **Sorry count before iter-065 prover round**: 20 file-counted (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` + 4 `BasicOpenCech.lean` + 7 `Differentials.lean`).
- **Sorry count after iter-065 prover round**: 29 file-counted (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` + 14 `BasicOpenCech.lean` + 6 `Differentials.lean`).
- **Net change**: +9 sorries — entirely from the *decomposition* of one BasicOpenCech sorry into 11 fine-grained sub-targets. Two real mathematical closures (`let π := sorry` and `universalDerivation`); four new fully-closed helper declarations in Differentials.
- **Clean diagnostics**: Both files compile with 0 errors. `BasicOpenCech.lean` has 1 expected `declaration uses 'sorry'` warning. `Differentials.lean` has 5 expected `declaration uses 'sorry'` warnings.
- **Critical regression repair**: `Differentials.lean` was *broken* at the start of iter-065 (three heartbeat timeouts at L167, L201, L204; plus two cascading unknown-identifier errors at L216 and L227). The prover unblocked the file with a structural refactor of `moduleKPresheafOfModules`. **The iter-064 "all compiles" claim in the previous review was inaccurate.**

## Target 1 — `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (BasicOpenCech.lean)

**Status**: Partial. One real closure (`let π := sorry` replaced by a concrete Mathlib term). One previously-monolithic substep decomposed into 11 fine-grained sub-targets.

### Attempt 1 — Concrete construction of the refinement map `π : K ⟶ K₀` (raw log events ~248–278)

- **Goal before** (raw log event with `lean_goal` at L667):
  ```
  k : Type u
  inst✝ : Field k
  C : Over (Spec (CommRingCat.of k))
  U : TopologicalSpace.Opens ↑C.left.toTopCat
  hU : IsAffineOpen U
  s : Set ↑Γ(C.left, U)
  hs : Ideal.span s = ⊤
  n : ℕ
  hn : 0 < n
  h_a : ...
  -- need: HomologicalComplex.Hom K K₀
  ```

- **Strategy**: Assemble `π` via three Mathlib API layers:
  1. `g_FC : (FormalCoproduct.mk ↑s₀ _) ⟶ (FormalCoproduct.mk s _)` — index-inclusion (subtype) on indices, identity on objects (since `basicOpenCover s ⟨j.1, _⟩ = C.left.basicOpen j.1 = basicOpenCover ↑s₀ j` definitionally).
  2. `Limits.FormalCoproduct.cechFunctor.map g_FC` — promote to a simplicial-object morphism.
  3. `Functor.whiskerLeft (FormalCoproduct.evalOp _ _) ((Functor.whiskeringLeft _ _ _).map g_simp.rightOp) ◫ 𝟙 (alternatingCofaceMapComplex _)` evaluated at the underlying presheaf of `toModuleKSheaf C` — pass through the contravariant `cosimplicialObjectFunctor` (so direction-of-arrow is `K ⟶ K₀`, not `K₀ ⟶ K`).

- **Code applied** (L685–703, inside `h_transport`):
  ```lean
  let g_FC :
      (Limits.FormalCoproduct.mk (↑s₀ : Set Γ(C.left, U))
          (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))) ⟶
      (Limits.FormalCoproduct.mk s
          (basicOpenCover (C := C) (U := U) s)) :=
    { f := fun j => ⟨j.1, h_sub j.2⟩
      φ := fun _ => 𝟙 _ }
  let g_simp := Limits.FormalCoproduct.cechFunctor.map g_FC
  let π : HomologicalComplex.Hom K K₀ :=
    ((Functor.whiskerLeft (Limits.FormalCoproduct.evalOp _ (ModuleCat.{u} k))
        ((Functor.whiskeringLeft _ _ _).map g_simp.rightOp)) ◫
      𝟙 (AlgebraicTopology.alternatingCofaceMapComplex (ModuleCat.{u} k))).app
      ((sheafToPresheaf _ _).obj (toModuleKSheaf C))
  ```

- **Lean errors encountered en route** (raw log events):
  - `Unknown identifier evalOp` at L700:32 — fixed by qualifying with `Limits.FormalCoproduct.evalOp`.
  - `Type mismatch ((FormalCoproduct.evalOp ...).whiskerLeft ...)` — initial composition order had `whiskerLeft` on the wrong side; fixed by swapping argument order in the `◫` horizontal composition.

- **Result**: success. The term type-checks against `HomologicalComplex.Hom K K₀` and `lean_verify` confirms no new axioms.

- **Insight**: `cosimplicialObjectFunctor = evalOp ⋙ ((whiskeringLeft).obj rightOp ·)` is **contravariant** in its argument. The inclusion `↑s₀ ⊆ s` lifts to `g_FC : FormalCoproduct ↑s₀ ⟶ FormalCoproduct s`; after `cechFunctor` and `cosimplicialObjectFunctor`, this *flips* to a morphism `K ⟶ K₀` (the desired refinement projection). Documented in a 24-line comment block (L661–684) so iter-066 has the variance subtlety in front of it.

### Attempt 2 — Decomposition of `h_K₀_exact` body (raw log events 1–11, BasicOpenCech edits)

- **Strategy**: The original substep-(b2)+(c) sorry at L720 was a single `sorry` claiming exactness of `K₀` via `exact_of_localized_span`. Decompose into 11 named obligations matching the 5-step strategy (install `Module R` instance on each `scK₀.X_i`; repackage Čech differential as `R`-linear; install `IsLocalizedModule.Away` instances; prove per-`f` localised exactness; apply `exact_of_localized_span`).

- **Sub-targets introduced** (all remain `sorry`):
  - L793–795: `h_mod_X₁/X₂/X₃ : Module R scK₀.Xᵢ` (3 sorries)
  - L802–803: `f_R / g_R : scK₀.X_i →ₗ[R] scK₀.X_j` (2 sorries)
  - L804–805: `hf_eq / hg_eq : ⇑f_R = ⇑(ConcreteCategory.hom scK₀.f)` etc. (2 sorries)
  - L812–816: `h_loc_X₁/X₂/X₃` (3 sorries, `IsLocalizedModule.Away f.1` instances)
  - L824: `h_loc_exact (f : ↑s₀)` (1 sorry, per-`f` localised exactness)
  Then `exact exact_of_localized_span ...` closes the surrounding goal.

- **Two further new transient sorries inside `h_transport`**:
  - L708: `h_π_split (i : ℕ) : SplitEpi (π.f i)` — splitting of the refinement projection.
  - L723: kernel-of-π + LES argument that combines `h_π_split` with `h_exact_K₀`.

- **Result**: success — file compiles cleanly. Lake build of the whole project succeeds. `lean_verify` reports only the standard axioms (`[propext, sorryAx, Classical.choice, Quot.sound]`).

### Failed approaches, recorded as dead ends in the task result

- **Direct construction of `h_π_split` via category-theoretic splitting** (~100 LOC universal-property plumbing required to unpack the cochain factor as a finite product). Deferred.
- **Direct `Module R` install on `scK₀.X_i` via `Pi.module`** (requires an explicit `K₀.X i ≅ ∏ᶜ_x M_x` iso via `ModuleCat.piIsoPi`; cochain factor's product structure hidden behind `cosimplicialObjectFunctor`). Deferred.
- **Bypass `s₀` refinement entirely** by going `s` → `exact_of_localized_span` directly. Confirmed dead end — this is the iter-061→063 path obstructed by infinite-product-localisation.

## Target 2 — `Differentials.lean` (regression repair + decomposition)

**Status**: Partial. File compilation **restored**. Six declarations (`relativeDifferentialsPresheaf_obj_kaehler`, `universalDerivation`, and the four-piece `moduleKPresheafOfModules` cluster, plus `moduleKPresheafOfModules_isSheaf` and `moduleKSheafOfModules`) **fully closed**. Six sorries remain (5 top-level + 1 nested-in-type).

### Critical regression context

The file received at the start of iter-065 did **not compile**. Diagnostic events from the prover log show:

- L167: `(deterministic) timeout at 'whnf', maximum number of heartbeats (200000) has been reached` — inside the inline `map` field of the iter-064 `moduleKPresheafOfModules` definition.
- L201: `rfl` failure in `map_id`.
- L204: `(deterministic) timeout at 'isDefEq'` in `map_comp`.
- L216, L227: cascading `unknown identifier moduleKPresheafOfModules` — the file's symbol failed to elaborate, so downstream references could not resolve.
- Plus failed type-class synthesis errors on `Module k ↑(M.val.obj V)` and `Module ↑(CommRingCat.of k) ↑(M.val.obj U)`.

This means the iter-064 PROJECT_STATUS.md report that both files compiled was **incorrect**: the iter-064 final write of `Differentials.lean` introduced an inline definition that the elaborator could not type-check. iter-065 is in part a regression repair.

### Attempt 1 — Restructure `moduleKPresheafOfModules` via named helpers (raw log events 12–73)

- **Strategy**: extract the inline smul-naturality proof and the inline `map` field into named declarations so the elaborator sees each in isolation, eliminating the heartbeat timeout.

- **New helper declarations introduced**, all closed:
  - `moduleKPresheafOfModules_obj` (L215) — `noncomputable abbrev` giving `ModuleCat.{u} k` via `ModuleCat.restrictScalars (kToSection C U).hom`. Definitional.
  - `moduleKPresheafOfModules_smul_compat` (L225) — smul-naturality lemma: `M.val.presheaf.map f ≫ ((_obj C M V).smul r) = ((_obj C M U).smul r) ≫ M.val.presheaf.map f`. Proof routes through `ModuleCat.smul_naturality`, `algebraMap_eq_kToSection`, `algebraMap_naturality`.
  - `moduleKPresheafOfModules_map` (L275) — `noncomputable def` building the restriction map as `ModuleCat.homMk (M.val.presheaf.map f) (_smul_compat ...)`.
  - `moduleKPresheafOfModules_map_forget₂` (L283) — `@[simp]` lemma reducing the `forget₂`-image of `_map` to `M.val.presheaf.map f`. Used by `map_id` / `map_comp` proofs.
  - `moduleKPresheafOfModules` (L299) — the assembled functor; `map_id` and `map_comp` now use `(forget₂).map_injective` + the `_forget₂` simp lemma + `M.val.presheaf.map_id / map_comp`.
  - `moduleKPresheafOfModules_isSheaf` (L319) — sheaf condition via `Presheaf.isSheaf_iff_isSheaf_comp _ _ (forget₂ ...)` reducing to `M.isSheaf`.
  - `moduleKSheafOfModules` (L330) — the sheaf, packaged as `⟨moduleKPresheafOfModules C M, moduleKPresheafOfModules_isSheaf C M⟩`.

- **Lean errors hit en route to the working version** (~30+ edits):
  - `failed to synthesize instance Module k ↑(M.val.obj V)` — fixed by routing through `ModuleCat.restrictScalars` rather than relying on automatic instance search.
  - `Function expected at ModuleCat.restrictScalars (CommRingCat.Hom.hom ...)` — fixed by switching to `(toModuleKSheaf.kToSection C U).hom` (no double `.hom`).
  - Repeated `HEq` issues in the `_isSheaf` proof — eventually replaced by `convert M.isSheaf using 1` after splitting the functor-extensionality lemma into a manual `Functor.ext`/`congr` chain (took ~15 trial edits in `_isSheaf`, then settled on `convert ... using 1`).

- **Result**: all seven helper declarations are `sorry`-free, file compiles, `lean_verify` shows only standard axioms.

### Attempt 2 — `universalDerivation` closure (raw log events 12–13)

- **Goal before**:
  ```
  X Y S : Scheme
  f : X ⟶ S
  ⊢ X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶
      (relativeDifferentials f).val.presheaf
  ```

- **Strategy**: Use the Mathlib presheaf-of-modules derivation primitive. The pullback adjunction gives `φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c`. Apply `PresheafOfModules.DifferentialsConstruction.derivation'` to get `d'`, and bundle each component with `AddCommGrpCat.ofHom (d'.d (X := U))`. Naturality is `d'.d_map`.

- **Code**:
  ```lean
  noncomputable def universalDerivation (f : X ⟶ S) :
      X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶
        (relativeDifferentials f).val.presheaf := by
    let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
      f.c
    let d' := PresheafOfModules.DifferentialsConstruction.derivation' φ'
    refine { app := fun U ↦ AddCommGrpCat.ofHom (d'.d (X := U)), naturality := ?_ }
    case naturality =>
      ext x
      simp only [sheafCompose_obj_obj, ...]
      suffices d'.d (...) = (...) (d'.d x) by simpa using this
      exact d'.d_map g x
  ```

- **Result**: closed. No sorry. `noncomputable` modifier added during iter-065 (it wasn't there in iter-064's broken state).

### Attempt 3 — `relativeDifferentialsPresheaf_obj_kaehler` closure

A definitional `rfl`-lemma introduced as a bridge:
```lean
theorem relativeDifferentialsPresheaf_obj_kaehler (f : X ⟶ S)
    (V : (TopologicalSpace.Opens X.toTopCat)ᵒᵖ) :
    ((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) =
      CommRingCat.KaehlerDifferential
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
          f.base).homEquiv _ _).symm f.c |>.app V) :=
  rfl
```
This will be the bridge used by the (still-`sorry`) `relativeDifferentialsPresheaf_isSheaf` to talk about sections as ring-level `KaehlerDifferential`s.

### Failed approaches on `relativeDifferentialsPresheaf_isSheaf`

- **Attempt**: search Mathlib for a packaged "Kähler differentials presheaf is a sheaf" theorem. **Outcome**: only ring-level `KaehlerDifferential.isLocalizedModule` and `KaehlerDifferential.isLocalizedModule_map`. `SheafOfModules.IsQuasicoherent` was considered but is a property OF an `X.Modules` (presupposes the sheaf condition). **Dead end documented inline.**
- **Attempt**: sheafification (`PresheafOfModules.sheafify` + show unit is iso). **Outcome**: circular — requires the presheaf to already be a sheaf. **Dead end documented inline.**
- **Decomposition that landed**: three-substep proof skeleton documented in inline comments (L64–84): (1) Kähler-localisation compatibility; (2) sheaf condition on the basis of basic opens; (3) globalisation. Sorry retained.

## Other unchanged sorries

- `cotangent_exact_sequence` (L169) — the statement contains a `(by sorry)` inside the `ShortComplex.mk α β (by sorry)` argument, which is structural (asserting `α ≫ β = 0` as part of the existential bundle). Theorem body is also `sorry` (L176). Not attacked this iteration.
- `smooth_iff_locally_free_omega` (L185, body sorry at L192) — not attacked.
- `cotangent_at_section` (L201, body sorry at L209) — not attacked.
- `serre_duality_genus` (L345, body sorry at L351) — not attacked (but now *unblocked* by the working `moduleKSheafOfModules` helper).

## Key findings

- **Variance subtlety on `cosimplicialObjectFunctor`**: precomposition with `_.rightOp` flips the direction of the natural transformation. Inclusion `↑s₀ ⊆ s` produces `g_FC : FormalCoproduct ↑s₀ ⟶ FormalCoproduct s`, but after `cechFunctor` and `cosimplicialObjectFunctor`, the resulting cochain-complex morphism goes `K ⟶ K₀` (refinement *projection*, not refinement *inclusion*). Documented inline so iter-066 can attack `h_π_split` with the correct shape.
- **Elaboration timeouts from inline smul-naturality proofs**: nested `have` chains inside a `where`-style field declaration push the elaborator past its heartbeat budget. The fix is to **extract every smul-naturality / map-naturality proof into a named lemma** before plugging it into a structure or definition. This pattern likely applies to future module-cat constructions.
- **`convert _ using 1` is the right hammer for `Functor.ext`/`HEq` failures** on `comp`/`forget` chains. Attempts using `Functor.ext`, `Functor.hext`, `congr`, `conj_eqToHom_iff_heq` all required deep manual unfolding; `convert M.isSheaf using 1` after the `isSheaf_iff_isSheaf_comp` reduction is what closed the `moduleKPresheafOfModules_isSheaf` proof.
- **Decomposition trade-off**: turning one substep sorry into 11 named sub-targets makes the **next step's surface area** much wider, but each sub-target now has a precise type signature and can be attacked independently. iter-066+ should pick the 1–2 most tractable sub-targets per round, not try all 11.

## Blueprint markers updated (manual)

- `Differentials.tex`, `thm:cotangent_exact_sequence`: added `% NOTE: the Lean statement contains a `(by sorry)` inside the `ShortComplex.mk α β (by sorry)` argument; the existential bundle therefore does not assert α ≫ β = 0 mathematically until that nested sorry is closed.`

No `\mathlibok` markers added — every Differentials chapter declaration is project-side construction (no direct Mathlib re-export). No `\lean{...}` renames (prover preserved every declaration name). No `\notready` strips (none present).

`\leanok` markers were left untouched as instructed; the deterministic `sync_leanok` phase ran before this review.

## Recommendations for next session

See `recommendations.md`.
