# AlgebraicJacobian/Differentials.lean — iter-082

## Outcome

**Sorry count: 5 → 5 (no regression). Net delta zero.**

Key structural advance: `h_zero` of `cotangentExactSeq_structure` is now closed
**in active code** via the Route (c) chain (was a comment block in iter-081).
The remaining `h_exact ∧ h_epi` conjunction is consolidated into a single
absorbed `sorry`, matching the iter-081 single-sorry budget.

The plan's stretch goal (close `h_epi` via Route 2 and introduce
`SheafOfModules.exact_iff_stalkwise` for `h_exact`, both 1-for-1 shift) was
attempted but blocked. Per the plan's conditional clause, this preserves
the iter-081 5-sorry state without regression.

## Concrete changes

### 1. `cotangentExactSeq_structure` body — restructured (L488–L578)

- **Before (iter-081):** Body was `sorry` (single absorbed conjunction). The
  Route (c) chain for `h_zero` was documented in a comment block.
- **After (iter-082):**
  - `refine ⟨?h_zero, ?h_rest⟩` (splits ∃-witness from the And-conjunction).
  - `case h_zero` closes the first conjunct via active Route (c) tactics —
    no `sorry` in this branch.
  - `case h_rest` carries the absorbed `sorry` for `h_exact ∧ h_epi` with a
    documentation block explaining the remaining work.

The `set_option maxHeartbeats 16000000 in` annotation is preserved on the
lemma (with a maxHeartbeats-linter-required comment explaining the budget).

### 2. `_root_.PresheafOfModules.Derivation.postcomp_comp` (L454–L465)

Preserved byte-for-byte from iter-081 (fully closed). Used inside the
new `h_zero` chain.

### 3. `_root_.SheafOfModules.epi_of_epi_presheaf` (L438–L444)

Preserved byte-for-byte from iter-079 (fully closed). Reserved for the
future `h_epi` closure (Route 2).

### 4. Docstring on `cotangentExactSeq_structure`

Updated to reflect iter-082 status: `h_zero` closed, `h_epi` via Route 2
attempted, `h_exact` pending `exact_iff_stalkwise`.

## Attempt log

### `h_zero` — RESOLVED via Route (c)

**Chain (L490–L559)**:
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
-- [setup φ_g', φ_fg', φ_2', adj_f locals]
-- [build hcoh, hcoh_app, hd_app, hβ_fac]
simp only [PresheafOfModules.Derivation.postcomp_d_apply]
dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
unfold cotangentExactSeqBeta
change (((isUniversal' φ_fg').desc _).app (op _)).hom
    ((derivation' φ_fg').d ((f.c.app U).hom b)) = _
rw [hβ_fac _ ((f.c.app U).hom b)]
exact hd_app
```

**Key fixes from iter-081 transcript**:
- `congr_arg` for `hcoh_app` required explicit lambda annotation:
  `fun (h : Y.presheaf ⟶ (TopCat.Presheaf.pushforward CommRingCat f.base).obj X.presheaf) => …`
  (the un-annotated form failed elaboration in iter-082's compiled state).
- `hβ_fac` proof: replaced `simpa [postcomp_d_apply] using hpt` with
  `simp only [postcomp_d_apply] at hpt; exact hpt` (the `simpa` form over-fired
  `Universal.fac`, collapsing `hpt` to `True`).

### `h_epi` — IN PROGRESS (Route 2 attempted, blocked)

**Approach attempted (Route 2 from plan)**:
1. `apply SheafOfModules.epi_of_epi_presheaf; rw [PresheafOfModules.epi_iff_surjective]; intro U`.
2. Set up `φ_fg', φ_2', adj_f, adj_fg, η` locals (same as iter-076 chain).
3. Re-derive `hη : η ≫ φ_2' = φ_fg'` (the η-coherence, ≈30 lines).
4. Build `fac : η.app U ≫ φ_2'.app U = φ_fg'.app U ≫ 𝟙 _`.
5. Set up algebra instances via `letI` for `A_fg → B`, `A_2 → B`, `A_fg → A_2`.
6. Establish `IsScalarTower A_fg A_2 B` via `IsScalarTower.of_algebraMap_eq'`.
7. Use `_root_.KaehlerDifferential.map_surjective` to get a preimage at the
   unbundled level; transfer via `Submodule.span_induction` + the identity
   `((cotangentExactSeqBeta f g).val.app U).hom = _root_.KaehlerDifferential.map _ _ _ _`.

**Blockers encountered**:
1. **Type-class coercion** (`Algebra ↑(... .obj U) ↑(X.presheaf.obj U)` not synthesized):
   the `.obj U` projection produces a `CommRingCat`, requiring explicit
   `↑(...)` carrier coercion or `: Type _` annotation for `Algebra _ _` to
   accept the source/target.
2. **`IsScalarTower.of_algebraMap_eq'` mismatch**: the argument shape
   `algebraMap R A = (algebraMap S A).comp (algebraMap R S)` did not unify
   with `congrArg CommRingCat.Hom.hom fac` (the `CommRingCat.Hom.hom` of the
   CommRingCat-level coherence square), even after `simpa [CommRingCat.hom_comp, Category.comp_id]`.
3. **`Submodule.span_induction` motive ambiguity**: after the algebra letI's,
   the span induction's `(p := fun w _ => …)` failed to unify the motive
   against the goal shape.

**Specific tactics tried (all failed)**:
| Tactic | Failure |
|---|---|
| `letI A_fg_algebra : Algebra (… : Type _) (… : Type _) := (φ_fg'.app U).hom.toAlgebra` | "failed to synthesize instance of type class Algebra ↑(…) ↑(…)" (the `: Type _` annotation triggers re-elaboration without the toAlgebra instance) |
| `exact _root_.KaehlerDifferential.map_surjective` | Type mismatch — `KaehlerDifferential.map R S B B` has Mathlib type, not the descent's bundled type |
| `convert _root_.KaehlerDifferential.map_surjective ?_ ?_ ?_ using 1` | Same type mismatch, plus 4 unsolved metavariables for `R S B` |
| `algebraize [(φ_fg'.app U).hom, (φ_2'.app U).hom, (η.app U).hom]` | Not attempted in detail (the algebraize tactic would set up instances but the subsequent identification still requires `KaehlerDifferential.ext` over the bundled vs unbundled forms) |

**Pattern matching diagnostics**: When attempting
`Submodule.span_induction ?_ ?_ ?_ ?_ hz` for `hz : x ∈ Submodule.span B (Set.range (D _ _))`
under the bundled `Algebra` setup, the `D b` case `rintro _ ⟨b, rfl⟩` failed
with "`x✝ : ?m.2809` is not an inductive datatype" — indicating Lean could
not unfold the bundled goal to expose the `_root_.KaehlerDifferential`-level
inductive structure.

### `h_exact` — NOT ATTEMPTED standalone

Per the iter-082 plan's conditional clause: with `h_epi` not closing, the
`exact_iff_stalkwise` helper was NOT introduced (introducing it without
closing `_structure` would push the file to 6 sorries, a regression
5 → 6). `h_exact` remains absorbed inside the conjunction `sorry`.

## Iter-083+ recipe (concrete)

### Option A — Refactor approach for `h_epi`

The cleanest path is a small refactor (refactor-subagent eligible):

1. Extract the η-coherence as a top-level helper:
   ```lean
   lemma cotangentExactSeqBeta_hη (f : X ⟶ Y) (g : Y ⟶ S) :
       ∃ (η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
              (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf),
         η ≫ φ_2'-of-f = φ_fg'-of-fg
   ```
   Re-prove `cotangentExactSeqBeta` to use this helper. This removes
   the ~30-line `hη` re-derivation inside `h_epi`.

2. With `hη` available externally, write `h_epi` using `algebraize` for
   the algebra+tower setup, then `convert _root_.KaehlerDifferential.map_surjective using 1`
   to identify the descent.

### Option B — Direct in-line route (current iter-082 attempt continued)

Continue the iter-082 attempt but with cleaner type handling:

1. Use named `let A_fg : Type _ := (... .obj U).carrier` bindings instead
   of `(... .obj U : Type _)` inline coercions — this prevents the
   re-elaboration that breaks `toAlgebra` instance synthesis.
2. Build `fac_ring : algebraMap _ _ = (algebraMap _ _).comp (algebraMap _ _)`
   directly without going through `CommRingCat.Hom.hom` of `≫`.
3. Use `show ∃ x, _root_.KaehlerDifferential.map _ _ _ _ x = y` (after
   establishing the descent equals the map at the function level) instead
   of trying to apply `map_surjective` directly to the descent.

### Option C — Stalkwise-only approach (skip `h_epi` Route 2)

Drop the `h_epi`-via-`KaehlerDifferential.map` identification entirely:

1. Prove `SheafOfModules.exact_iff_stalkwise` (the deferred helper) with
   the multi-iteration TopCat-stalk preserves-exactness chain.
2. Use the stalkwise criterion to close BOTH `h_exact` AND `h_epi`
   (the `h_epi` stalkwise reduction gives surjectivity at each stalk,
   which follows from the ring-level `KaehlerDifferential.map_surjective`).

This avoids the bundled-vs-unbundled `KaehlerDifferential.map` identification
entirely, at the cost of building stalkwise infrastructure.

## Sorries

| Line | Decl | Status |
|---|---|---|
| 113 | `relativeDifferentialsPresheaf_isSheaf` | unchanged (out of scope iter-082) |
| 483 | `cotangentExactSeq_structure` (single absorbed `h_exact ∧ h_epi`) | iter-082: `h_zero` closed in code; conjunction documented |
| 850 | `smooth_iff_locally_free_omega` | unchanged (out of scope iter-082) |
| 866 | `cotangent_at_section` | unchanged (out of scope iter-082) |
| 1010 | `serre_duality_genus` | unchanged (out of scope iter-082) |

**File total: 5 sorries** (was 5; no regression).

## Mathlib leverage confirmed iter-082

Verified used inside the closed `h_zero` chain:

- `Adjunction.homAddEquiv_zero` (additive adjunction zero preservation).
- `Adjunction.homEquiv_naturality_right` (right-naturality).
- `Equiv.apply_symm_apply` (homEquiv-symm collapse).
- `SheafOfModules.hom_ext` (SheafOfModules → PresheafOfModules ext).
- `PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective`
  (universal-property injectivity).
- `PresheafOfModules.Derivation.postcomp_comp` (project-local, iter-081).
- `PresheafOfModules.Derivation.Universal.fac` (auto `@[simp]`).
- `PresheafOfModules.Derivation.postcomp_d_apply` (auto `@[simps! d_apply]`).
- `PresheafOfModules.Derivation.ext` (Derivation extensionality).
- `PresheafOfModules.Derivation.congr_d` (pointwise extraction).
- `PresheafOfModules.Derivation'.d_app` (universal derivation vanishes).
- `(adj_f.homEquiv _ _) φ_2' = f.c` via `Equiv.apply_symm_apply` (rfl chain
  for the adjunction-coherence `hcoh`).

Researched but blocked by type-class issue (for the planned `h_epi`):
- `CommRingCat.KaehlerDifferential.map` (the bundled descent map).
- `CommRingCat.KaehlerDifferential.map_d`, `CommRingCat.KaehlerDifferential.ext`.
- `_root_.KaehlerDifferential.map_surjective` / `_root_.KaehlerDifferential.map_surjective_of_surjective`.
- `_root_.KaehlerDifferential.span_range_derivation`.
- `IsScalarTower.of_algebraMap_eq'`.
- `Submodule.span_induction`, `ModuleCat.restrictScalarsId'App` (for the
  `restrictScalars 𝟙.hom` collapse).

## Blueprint markers (read-only summary for review agent)

- `lem:cotangent_exact_structure`: still has an absorbed `sorry` in body —
  proof block should NOT carry `\leanok`. Statement block already has `\leanok`.
- `lem:derivation_postcomp_comp`: unchanged from iter-081, `\leanok` correct.
- `lem:sheafOfModules_epi_of_epi_presheaf`: unchanged from iter-079, `\leanok` correct.
- `lem:sheafOfModules_exact_iff_stalkwise`: helper NOT introduced this iter
  (would have caused 5 → 6 regression without `h_epi` closing). The blueprint
  entry remains an unrealized declaration; the Lean side does not exist.
