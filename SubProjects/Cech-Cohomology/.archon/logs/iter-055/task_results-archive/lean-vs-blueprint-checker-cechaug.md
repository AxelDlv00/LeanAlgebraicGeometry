# Lean ↔ Blueprint Check Report

## Slug
cechaug

## Iteration
054

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (focused on blocks for `CechAugmentedResolution.lean`: lines 7177–7447)

---

## Directive checks (iter-054 specific)

### (a) `cechAugmented_exact` signature vs blueprint

**CONFIRMED MATCH.** Lean signature:
```lean
theorem cechAugmented_exact (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)
```

Blueprint statement (lines 7275–7293): quasi-coherent `F`, finite affine open cover with all
intersections affine (encoded via `[X.IsSeparated]`), conclusion `∀ p, IsZero (…homology p)`.
The `\leanok` is present on the statement block (line 7229, correctly set by `sync_leanok`); the
proof block (lines 7307–7447) correctly lacks `\leanok` because the proof contains a `sorry`.

### (b) Residual sorry vs blueprint gap

**CONFIRMED ALIGNMENT.** The sorry at line 205 has goal (verified via `lean_goal`):
```
⊢ Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0
```
where `GV` = evaluation-at-`V` through `toPresheaf`, and `Kp` is the augmented Čech complex
under `forget ⋙ restrictScalars`. This is exactly the prepend-`i_fix` contracting-homotopy term
described in Steps 3(b)+(c) of the blueprint proof: identify the abstract evaluated complex with
the concrete section complex and apply `cechEnginePrepend_spec`. The blueprint's Step 3(b)
explicitly calls this "the project-side work of this step." No divergence.

### (c) `isZero_homology_of_homotopy_id_zero` vs Step 3(d)

**CONFIRMED FAITHFUL REALIZATION.** Blueprint Step 3(d) (lines 7407–7413):
> "by homotopy-invariance the map induced on degree-p homology by the identity equals the map induced
> by the zero map; the former is the identity of D•'s degree-p homology and the latter is zero, so
> that identity equals zero, which is the criterion for the homology to be a zero object. (This
> composes the homotopy-invariance of the induced homology map with the identity/zero computations
> and the 'identity equals zero' characterization…)"

Lean proof (lines 78–81):
```lean
  refine (IsZero.iff_id_eq_zero _).mpr ?_
  rw [← HomologicalComplex.homologyMap_id, ho.homologyMap_eq p, HomologicalComplex.homologyMap_zero]
```
Three tactics, exactly matching the described three-part mechanism: `IsZero.iff_id_eq_zero`
(criterion), `Homotopy.homologyMap_eq` (homotopy-invariance), `homologyMap_id` +
`homologyMap_zero` (identity/zero computations). The Lean proof is a precise mechanical
realization of the blueprint step. ✓

---

## Per-declaration

### `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}` (chapter: `lem:isZero_of_faithful_preservesZeroMorphisms`)
- **Lean target exists**: yes (line 52)
- **Signature matches**: yes — faithful functor between HasZeroMorphisms categories reflecting IsZero
- **Proof follows sketch**: yes — 3-line proof using `IsZero.iff_id_eq_zero` + `F.map_injective` matches the blueprint's described mechanism exactly
- **Notes**: `\leanok` present on both statement (line 7179) and proof (line 7190); proof closed, no sorry. ✓

### `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}` (chapter: `lem:isZero_presheafToSheaf_of_locally_isZero`)
- **Lean target exists**: yes (line 97)
- **Signature matches**: yes — Grothendieck topology, locally-zero abelian presheaf → sheafification is zero; `[HasSheafify J AddCommGrpCat]` and `[J.WEqualsLocallyBijective AddCommGrpCat]` as instance binders match blueprint note about abelian setting
- **Proof follows sketch**: yes — constructs constant zero presheaf `Z`, local injectivity from local subsingleton hypothesis, local surjectivity from zero-target, then calls `isZero_presheafToSheaf_obj_of_isLocallyBijective`; matches blueprint §`lem:isZero_presheafToSheaf_of_locally_isZero` proof
- **Notes**: `\leanok` present on both statement (line 7201) and proof (line 7214); proof closed, no sorry. ✓

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`)
- **Lean target exists**: yes (line 162)
- **Signature matches**: yes (see directive check (a) above)
- **Proof follows sketch**: partial — Steps 1, 2, 3 (local vanishing + sieve assembly) are wired axiom-clean; the single residual at line 205 (`Homotopy (𝟙 D) 0`) correctly corresponds to Steps 3(b)+(c) of the blueprint proof; Step 3(d) is handled by `isZero_homology_of_homotopy_id_zero`
- **Notes**: `\leanok` on statement (line 7229), absent from proof block (correct — sorry present). The proof route (reflect via `toSheaf` → `homologyIsoSheafify` → `sheafificationCompToSheaf` → `isZero_presheafToSheaf_of_locally_isZero` → covering sieve from `iSup_opensRange`) matches the blueprint's §Steps 1–3. ✓ structurally. 1 open sorry.

---

## Red flags

### Placeholder / suspect bodies
- `cechAugmented_exact` at line 205: `sorry` for `Homotopy (𝟙 D) 0`. This is a **legitimate open
  obligation**, not a placeholder on a claimed-done statement — the blueprint's `\leanok` is only on
  the statement block, not the proof block. No must-fix-this-iter status; the sorry is the named
  remaining gap.

*(No other sorries, no `:= True`, no trivially-vacuous bodies, no `axiom` declarations.)*

### Excuse-comments
None. The planner-strategy comment (lines 129–148) is a design note, not an excuse.

### Axioms / Classical.choice on non-trivial claims
None.

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.isZero_homology_of_homotopy_id_zero` (lines 76–81)
**No `\lean{}` reference exists in the blueprint.**

This is a standalone mathematical lemma (homological algebra: `Homotopy (𝟙 D) 0 → IsZero (D.homology p)`) that the Lean file extracted from the Step-3(d) mechanism. It is not a helper that falls naturally out of another declaration; it is a reusable result that other provers could consume. The blueprint describes its mechanism in Step 3(d) of the proof block of `lem:cech_augmented_resolution`, but does not promote it to a standalone `\begin{lemma}...\end{lemma}` block with a `\lean{}` pin.

**Classification: major** — a substantive declaration present in the Lean file that the blueprint should reference explicitly.

---

## Blueprint adequacy for this file

- **Coverage**: 3/4 Lean declarations have a `\lean{}` block (75%). 1 unreferenced substantive declaration: `isZero_homology_of_homotopy_id_zero`.
- **Proof-sketch depth**: **under-specified** for the residual sorry. The blueprint's two helper blocks `lem:cech_free_eval_prepend_homotopy` (line 2240) and `lem:cech_free_eval_prepend_homotopy_spec` (line 2304) explicitly state "This block carries no standalone `\lean{}` pin: the evaluated-complex form … is not a separate Lean declaration." This is accurate for those blocks in isolation (they live in FreePresheafComplex.lean), but it misleads about the proof obligation inside `cechAugmented_exact`. The sorry goal is `Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0` — a term that must connect the abstract doubly-composed functor complex to the concrete engine complex and package `cechEnginePrepend_spec` as a `HomologicalComplex.Homotopy`. The blueprint does not name what Lean declaration provides this, nor does it acknowledge this is a distinct obligation *inside* the proof of `cechAugmented_exact`. A prover navigating only the blueprint would know *what* to prove (Step 3(b)+(c)) but not *which Lean constructions* to reach for.
- **Hint precision**: **loose** for the residual. The blueprint points to `lem:cech_free_eval_nonempty` in its `\uses` (line 7233), whose pinned declarations are `cechFreeEval_quasiIso_of_nonempty`, `cechEngineComplexAug_quasiIso`, etc. — quasi-isomorphism results, not a packaged `Homotopy` term. There is no `\lean{}` handle that points a prover directly to the construction needed for the sorry.
- **Generality**: matches need. No parallel API required.
- **Recommended chapter-side actions**:
  1. Add a standalone `\begin{lemma}...\end{lemma}` block for `isZero_homology_of_homotopy_id_zero` with `\lean{AlgebraicGeometry.isZero_homology_of_homotopy_id_zero}` and a 1-sentence statement ("if `Homotopy (𝟙 D) 0` then `IsZero (D.homology p)` for every `p`") and `\uses{lem:cech_augmented_resolution}` (or a general homological algebra location). Promote Step 3(d) from an inline proof note to a proper lemma block.
  2. Add a `% NOTE:` annotation to the proof of `lem:cech_augmented_resolution` clarifying that the Step-3(b)+(c) sorry is *not* discharged by a "transport" of `cechEnginePrepend_spec` in one line but by constructing `Homotopy (𝟙 ((eval V).mapHomologicalComplex).obj (forget ⋙ restrict).obj K) 0` directly, using the engine complex identification + `cechEnginePrepend` / `cechEnginePrepend_spec`.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `isZero_homology_of_homotopy_id_zero` missing `\lean{}` tag | **major** |
| Blueprint underspecifies the Step-3(b)+(c) Homotopy construction in `cechAugmented_exact` | **major** |
| `hF : F.IsQuasicoherent` in signature not used by the current (partial) proof body | **minor** (matches blueprint statement; will be used by no path per Step-4 remark; consider noting in blueprint that the hypothesis is vacuous for this specific theorem — tracked as informational) |

**Overall verdict**: The Lean file is faithful to the blueprint; `isZero_homology_of_homotopy_id_zero` is a correct and precise realization of Step 3(d); the single sorry corresponds exactly to the named gap (prepend-`i_fix` homotopy on the evaluated section complex); the only action items are a missing `\lean{}` reference for `isZero_homology_of_homotopy_id_zero` and a blueprint prose gap about the concreteness of the Step-3(b)+(c) construction — 4 declarations checked, 2 major findings (both blueprint-side), 0 must-fix-this-iter.
