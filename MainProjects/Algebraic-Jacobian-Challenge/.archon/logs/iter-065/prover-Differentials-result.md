# AlgebraicJacobian/Differentials.lean

## Summary

Iter-065 work on `Differentials.lean`:

1. **CRITICAL: Fixed compilation errors blocking the file.** The previous state had three compile-blocking errors in `moduleKPresheafOfModules` (heartbeat timeouts at L167, L204, and a failed `rfl` at L201) plus two cascading "unknown identifier" errors at L216 and L227. The file as-received did not compile. After refactoring, the file now compiles cleanly with only the expected `declaration uses 'sorry'` warnings.

2. **Refactored `moduleKPresheafOfModules`** by extracting the inline smul-naturality proof and the inline `map` field as named helpers (`moduleKPresheafOfModules_obj`, `moduleKPresheafOfModules_smul_compat`, `moduleKPresheafOfModules_map`, `moduleKPresheafOfModules_map_forget₂`). This unblocks `serre_duality_genus` and any other downstream consumers of the restriction-of-scalars helper.

3. **Decomposed `relativeDifferentialsPresheaf_isSheaf`** (priority 1 objective) with a detailed three-substep strategy documented inline and a new helper lemma `relativeDifferentialsPresheaf_obj_kaehler` closed (definitional).

Result: file compiles, 6 sorries unchanged (5 of which are top-level; one is the nested `by sorry` inside `ShortComplex.mk`).

## File status

- **LOC**: 353 (was ~246).
- **Sorries**: 6 (top-level reported by diagnostics: 5 at L113, L169, L185, L201, L345; plus nested `by sorry` at L174 inside `ShortComplex.mk`).
- **Errors / non-sorry warnings**: none.
- **Axioms added**: none.

## Declarations

| Line | Declaration | Type | Status |
|------|-------------|------|--------|
| 63 | `relativeDifferentialsPresheaf` | `X.PresheafOfModules` | Compiles (noncomputable def) |
| 95 | `relativeDifferentialsPresheaf_obj_kaehler` | `(relativeDifferentialsPresheaf f).presheaf.obj V = CommRingCat.KaehlerDifferential _` | **CLOSED iter-065** (rfl, definitional) |
| 113 | `relativeDifferentialsPresheaf_isSheaf` | `Presheaf.IsSheaf _ ...` | sorry (decomposed, see below) |
| 128 | `relativeDifferentials` | `X.Modules` | Compiles (noncomputable def) |
| 138 | `universalDerivation` | morphism of abelian presheaves | **No sorry** (proof present, closes via `d'.d_map`) |
| 169 | `cotangent_exact_sequence` | existence + exactness + epi | sorry + nested `by sorry` |
| 185 | `smooth_iff_locally_free_omega` | smoothness iff locally free | sorry |
| 201 | `cotangent_at_section` | section pullback locally free | sorry |
| 215 | `moduleKPresheafOfModules_obj` | `ModuleCat.{u} k` | **CLOSED iter-065** (definitional) |
| 226 | `moduleKPresheafOfModules_smul_compat` | smul-naturality | **CLOSED iter-065** (helper lemma) |
| 264 | `moduleKPresheafOfModules_map` | restriction map | **CLOSED iter-065** (uses helper) |
| 273 | `moduleKPresheafOfModules_map_forget₂` | `(forget₂).map (_) = M.val.presheaf.map f` | **CLOSED iter-065** (simp lemma) |
| 286 | `moduleKPresheafOfModules` | `Cᵒᵖ ⥤ ModuleCat k` | **CLOSED iter-065** (compiled, replaces the broken iter-064 version) |
| 312 | `moduleKPresheafOfModules_isSheaf` | sheaf condition | **CLOSED iter-065** (was broken before; reduces via `isSheaf_iff_isSheaf_comp` to `M.isSheaf`) |
| 323 | `moduleKSheafOfModules` | `Sheaf _ (ModuleCat k)` | **CLOSED iter-065** (constructor from helpers) |
| 345 | `serre_duality_genus` | rank equality | sorry |

## relativeDifferentialsPresheaf_isSheaf (L113) — Priority 1 objective

### Attempt 1 — direct closure
- **Approach:** Search Mathlib for an existing "Kähler differentials presheaf is a sheaf" theorem.
- **Result:** FAILED — Mathlib has `KaehlerDifferential.isLocalizedModule` and `KaehlerDifferential.isLocalizedModule_map` (the ring-level localisation compatibility), but no scheme-level packaging that gives the sheaf condition directly. `SheafOfModules.IsQuasicoherent` is a property OF a `SheafOfModules`, so it cannot be used to prove the sheaf condition — circular.
- **Dead end:** Do not search for a one-line closure; this theorem requires substantial development.

### Attempt 2 — decomposition
- **Approach:** Decompose the proof into three layers per the blueprint:
  1. **Localisation compatibility** — `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]` (Mathlib has this as `KaehlerDifferential.isLocalizedModule`).
  2. **Sheaf condition on the basis of basic opens** — derived from step 1 applied to each `fᵢ` of a basic-open cover.
  3. **Globalisation** — restrict-to-basis sheaf condition (`TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` style).
- **Result:** IN PROGRESS — sorry remains, but proof structure is now documented in the file (lines 78–122).
- **Helper landed:** `relativeDifferentialsPresheaf_obj_kaehler` (L95) — a definitional `rfl` lemma identifying the sections with `CommRingCat.KaehlerDifferential`. This will be the bridge between the scheme-level statement and the ring-level localisation theorems.

### Attempt 3 — sheafification route
- **Approach:** Use `PresheafOfModules.sheafify` and show the unit map is an iso.
- **Result:** FAILED — this requires knowing the presheaf is already a sheaf, which is what we want to prove. Circular.
- **Dead end:** Do not pursue sheafification-adjunction approach without first establishing the basic-open sheaf condition.

### Next steps for iter-066+
- Build a scheme-language version of `KaehlerDifferential.isLocalizedModule` that talks about `relativeDifferentialsPresheaf` restricted to basic opens of an affine open of `X`.
- Use `TopCat.Presheaf.IsSheaf.isSheafFor` / restrict-to-basis machinery to globalise.
- Estimated effort: 200–400 LOC, multi-iteration.

## moduleKPresheafOfModules cluster — fixing the broken iter-064 leftover

### Issue
The state of the file as received had:
- L167 `whnf` timeout (the entire `moduleKPresheafOfModules` def was timing out at elaboration).
- L201 `rfl` failure inside `map_id`.
- L204 `isDefEq` timeout inside `map_comp`.
- L216, L227 unknown-identifier errors cascading from the failed def above.

### Fix
- Extracted the smul-naturality proof from the inline `(fun r => by ...)` in `map` into a named lemma `moduleKPresheafOfModules_smul_compat`. This is the main reason the elaborator was timing out: the inline proof had many nested `have` terms whose types Lean was struggling to elaborate.
- Extracted the `map` field into a named def `moduleKPresheafOfModules_map`, which uses `ModuleCat.homMk` + the smul-naturality lemma.
- Replaced the failing `map_id`/`map_comp` proofs with proofs that use `M.val.presheaf.map_id` / `M.val.presheaf.map_comp` directly (the previous proofs assumed `rfl` after rewrites, but the rewrites did not bring the goal to the `rfl` form).
- Added a `@[simp] lemma moduleKPresheafOfModules_map_forget₂` so the `map_id`/`map_comp` proofs can rewrite mechanically.
- Result: **CLOSED**.

### Lint fixes
- Replaced `show` with `change` in `moduleKPresheafOfModules_smul_compat` (per `linter.style.show`).
- Reformatted two long lines (>100 chars).

## Other sorries — not attacked this iteration

- **`cotangent_exact_sequence` (L169 + nested L174)** — substantial; requires ring-level cotangent exact sequence + scheme gluing. ~500+ LOC effort.
- **`smooth_iff_locally_free_omega` (L185)** — substantial; Jacobian criterion + Nakayama. ~500+ LOC.
- **`cotangent_at_section` (L201)** — corollary of the above two. Depends on them.
- **`serre_duality_genus` (L345)** — Serre duality on a smooth proper curve; multi-iteration. Now unblocked by the working `moduleKSheafOfModules` helper.

## Mathlib API points consulted

- `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` and `.derivation'` and `.isUniversal'` — the construction primitives.
- `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_obj` — sections are `CommRingCat.KaehlerDifferential`.
- `PresheafOfModules.presheaf` and `.presheaf_map_apply_coe` — bridge to the abelian-group presheaf.
- `PresheafOfModules.homMk`, `PresheafOfModules.ofPresheaf` — construction primitives at the presheaf level.
- `PresheafOfModules.toPresheaf`, `.forgetToPresheafModuleCat` — forgetful functors.
- `ModuleCat.homMk`, `ModuleCat.forget₂_map_homMk`, `ModuleCat.smul_naturality`, `ModuleCat.restrictScalars` — `ModuleCat`-level primitives used in `moduleKPresheafOfModules_map`.
- `KaehlerDifferential.isLocalizedModule`, `.isLocalizedModule_map`, `.span_range_map_derivation_of_isLocalization` — the localisation-compatibility theorems that will be needed for the substep-2 closure of `relativeDifferentialsPresheaf_isSheaf`.
- `AlgebraicGeometry.Scheme.Modules.isSheaf` — the `X.Modules → sheaf` extractor (but only after the sheaf condition is known).
- `Presheaf.isSheaf_iff_isSheaf_comp` — drops sheaf condition to a forgetful image.
- `toModuleKSheaf.kToSection`, `.algebraMap_eq_kToSection`, `.algebraMap_naturality` — bridge from `kToSection` to the existing algebra structure.

## Blueprint alignment

The blueprint declarations remain at:
- `def:relative_kaehler_presheaf` → `relativeDifferentialsPresheaf` (compiled)
- `def:relative_kaehler_sheaf` → `relativeDifferentials` (compiled, dependent on the sorry above)
- `def:universal_derivation` → `universalDerivation` (closed; no sorry — iter-064 closure preserved)
- `thm:cotangent_exact_sequence` → `cotangent_exact_sequence` (sorry)
- `thm:smooth_iff_locally_free_omega` → `smooth_iff_locally_free_omega` (sorry)
- `cor:cotangent_at_section` → `cotangent_at_section` (sorry)
- `thm:serre_duality_genus` → `serre_duality_genus` (sorry; unblocked by working `moduleKSheafOfModules` helper)

No blueprint marker updates required from the prover (per protocol — review agent handles those).

## Recommendations for iter-066

1. **`relativeDifferentialsPresheaf_isSheaf`** is now well-decomposed. The natural next iteration objective is the **substep 2** of the decomposition: a scheme-language version of `KaehlerDifferential.isLocalizedModule` that gives the sheaf condition on the basis of basic opens of an affine open. The required Mathlib API is in `Mathlib.RingTheory.Kaehler.TensorProduct` and `Mathlib.RingTheory.Etale.Kaehler`.

2. **`moduleKSheafOfModules`** is now working. `serre_duality_genus` can now be attacked (statement-level changes no longer blocked by the helper).

3. **`cotangent_exact_sequence`** is the natural next big closure target after `relativeDifferentialsPresheaf_isSheaf` — it gives the right-exact sequence needed for `smooth_iff_locally_free_omega`.

4. **DO NOT** revert the iter-065 refactor of `moduleKPresheafOfModules`. The extracted helpers (`_obj`, `_smul_compat`, `_map`, `_map_forget₂`) are load-bearing: an inline rewrite would re-trigger the elaboration timeout that blocked iter-064/iter-065.
