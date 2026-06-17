# Lean ↔ Blueprint Check Report

## Slug
iter076

## Iteration
076

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}` (chapter: `lem:isZero_of_faithful_preservesZeroMorphisms`, bp line 7179)
- **Lean target exists**: yes (line 53)
- **Signature matches**: yes — faithful + preserves zero morphisms → reflects zero objects; types match prose exactly
- **Proof follows sketch**: yes — `IsZero.iff_id_eq_zero` + `Functor.map_injective` + `map_id`/`map_zero` three-liner matches the blueprint's "identity equals zero" proof sketch verbatim
- **notes**: Blueprint block at line 7176 has NO `\leanok` on the statement (blank line after `\begin{lemma}` without `\leanok`). Lean body is complete. This is a blueprint-side staleness issue.

### `\lean{AlgebraicGeometry.isZero_homology_of_homotopy_id_zero}` (chapter: `lem:isZero_homology_of_homotopy_id_zero`, bp line 7476)
- **Lean target exists**: yes (line 77)
- **Signature matches**: yes — preadditive `C`, complex `D`, `Homotopy (𝟙 D) 0` → `IsZero (D.homology p)`
- **Proof follows sketch**: yes — `Homotopy.homologyMap_eq` + `homologyMap_id` + `homologyMap_zero` + `IsZero.iff_id_eq_zero`; matches the three-step blueprint sketch exactly
- **notes**: `\leanok` present in blueprint (line 7474). No issues.

### `\lean{AlgebraicGeometry.isZero_homology_of_iso_homotopy_id_zero}` (chapter: `lem:isZero_homology_of_iso_homotopy_id_zero`, bp line 7498)
- **Lean target exists**: yes (line 90)
- **Signature matches**: yes — `D ≅ D'` + `Homotopy (𝟙 D') 0` → `IsZero (D.homology p)` in preadditive `C` with `CategoryWithHomology`
- **Proof follows sketch**: yes — `IsZero.of_iso` + `homologyFunctor.mapIso` + `isZero_homology_of_homotopy_id_zero`; blueprint says "isomorphism induces an isomorphism on homology; an object isomorphic to a zero object is itself zero"
- **notes**: `\leanok` present in blueprint (line 7495). No issues.

### `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}` (chapter: `lem:isZero_presheafToSheaf_of_locally_isZero`, bp line 7207)
- **Lean target exists**: yes (line 112)
- **Signature matches**: yes — covering sieve `S ∈ J U` with all members landing on `IsZero (Q.obj (op V))` → `IsZero ((presheafToSheaf J AddCommGrpCat).obj Q)`
- **Proof follows sketch**: yes — introduces constant zero presheaf `Z`, shows `0 : Q → Z` is locally injective (sections are subsingletons) and locally surjective (target is zero), invokes `isZero_presheafToSheaf_obj_of_isLocallyBijective`; matches blueprint proof faithfully
- **notes**: `\leanok` present (line 7204). No issues.

### `\lean{AlgebraicGeometry.cechSection_isZero_homology}` (chapter: `lem:cechSection_isZero_homology`, bp line 9491)
- **Lean target exists**: yes (line 155)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (V : Opens X) (i : 𝒰.I₀) (hiV : V ≤ coverOpen 𝒰 i) (p : ℕ)` → `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)`. The blueprint says "Let `V ≤ coverOpen 𝒰 i`. Then for every degree `p` the homology `H^p(D•)` of the augmented Čech complex evaluated at `V` is a zero object." — matches.
- **Proof follows sketch**: yes — one-liner `isZero_homology_of_iso_homotopy_id_zero (cechSection_complex_iso 𝒰 F V) p (cechSection_contractible 𝒰 F V i hiV)`, corresponding exactly to blueprint proof steps: iso via `lem:cechSection_complex_iso`, homotopy via `lem:cechSection_contractible`, zero-homology conclusion via `lem:isZero_homology_of_iso_homotopy_id_zero`.
- **notes**:
  1. Blueprint block at line 9489 has **NO `\leanok`** marker (the `\begin{lemma}` is immediately followed by `[Local vanishing…]` without `\leanok`). Lean is complete. Blueprint-side staleness.
  2. Blueprint `\uses` (line 9493) lists `lem:cechSection_complex_iso`, `lem:cechSection_contractible`, `lem:isZero_homology_of_homotopy_id_zero`. The Lean directly calls `isZero_homology_of_iso_homotopy_id_zero` — the iso variant — not `isZero_homology_of_homotopy_id_zero` directly. The dependency `lem:isZero_homology_of_iso_homotopy_id_zero` is missing from the `\uses` list (it is included only transitively via the listed `lem:isZero_homology_of_homotopy_id_zero`). The math is correct but the `\uses` graph omits the direct intermediate.

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`, bp line 7234)
- **Lean target exists**: yes (line 202)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated] (F : X.Modules) (hF : F.IsQuasicoherent)` → `∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)`. Matches the blueprint statement about finite affine cover with affine intersections and quasi-coherent F.
- **Proof follows sketch**: yes — four-step structure in the Lean mirrors the blueprint exactly:
  - Step 1 (line 208): `apply isZero_of_faithful_preservesZeroMorphisms (SheafOfModules.toSheaf …)` — matches blueprint Step 1 (reflect through faithful forgetful functor)
  - Step 2 (lines 215–218): `IsZero.of_iso` composed with `SheafOfModules.toSheaf.mapIso (homologyIsoSheafify …) ≪≫ (sheafificationCompToSheaf …).app P` — matches blueprint Step 2 (homology sheaf = sheafification of presheaf homology, transported across sheafification square)
  - Step 3 (lines 221–258): `apply isZero_presheafToSheaf_of_locally_isZero` with covering sieve `{V | ∃ i, V ≤ coverOpen 𝒰 i}` — matches blueprint Step 3 (locally vanishing presheaf)
  - Step 3(d) closure (line 243): **`exact cechSection_isZero_homology 𝒰 F V i hiV p`** — matches blueprint Step 3(d) exactly: "Items (a)–(d) together are exactly the content of `lem:cechSection_isZero_homology`, which is the single residual obligation discharging this step."
- **notes**: `\leanok` present (line 7231). Step 4 (augmentation node) is handled uniformly by the same `cechSection_isZero_homology` call (degree `p = 0` falls under the uniform `∀ p` statement), consistent with the blueprint remark that the homotopy extends to the augmentation term. No issues.

---

## Red flags

None found.

- No `:= sorry` bodies.
- No `:= True` / `:= rfl` on non-trivial claims.
- No axiom declarations.
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- wrong but works`).

---

## Unreferenced declarations (informational)

All five top-level declarations in the Lean file have corresponding `\lean{...}` references in the blueprint:
- `isZero_of_faithful_preservesZeroMorphisms` → `lem:isZero_of_faithful_preservesZeroMorphisms`
- `isZero_homology_of_homotopy_id_zero` → `lem:isZero_homology_of_homotopy_id_zero`
- `isZero_homology_of_iso_homotopy_id_zero` → `lem:isZero_homology_of_iso_homotopy_id_zero`
- `isZero_presheafToSheaf_of_locally_isZero` → `lem:isZero_presheafToSheaf_of_locally_isZero`
- `cechSection_isZero_homology` → `lem:cechSection_isZero_homology`
- `cechAugmented_exact` → `lem:cech_augmented_resolution`

No unreferenced declarations. 6/6 substantive declarations are blueprint-pinned.

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 Lean declarations have a corresponding `\lean{...}` block. 0 helpers, 0 substantive unreferenced. Full coverage.
- **Proof-sketch depth**: adequate. The blueprint proof for `lem:cech_augmented_resolution` is highly detailed (Steps 1–4, sub-items (a)–(e)), and the blueprint proof for `lem:cechSection_isZero_homology` precisely names the three lemmas the Lean proof invokes. No step required reasoning the blueprint omits.
- **Hint precision**: precise. `\lean{...}` pins in all six blocks resolve unambiguously to the Lean declaration names used.
- **Generality**: matches need. No parallel APIs were introduced; all blueprint-level constructions are at the right generality.
- **Recommended chapter-side actions**:
  1. **Add `\leanok` to `lem:cechSection_isZero_homology`** (between `\begin{lemma}` and `\label{...}` at bp line 9489): the Lean is complete and the `\leanok` marker is missing. Also add `\leanok` to its `\begin{proof}` block (line 9502).
  2. **Add `\leanok` to `lem:isZero_of_faithful_preservesZeroMorphisms`** (between `\begin{lemma}` and `\label{...}` at bp line 7176): same situation, Lean body is complete.
  3. **Add `lem:isZero_homology_of_iso_homotopy_id_zero` to the `\uses` list of `lem:cechSection_isZero_homology`** (bp line 9493): the Lean proof calls the iso-variant directly; the `\uses` list should reflect this direct dependency rather than only listing the underlying `lem:isZero_homology_of_homotopy_id_zero`.

---

## Severity summary

| Finding | Side | Severity |
|---|---|---|
| `lem:cechSection_isZero_homology` missing `\leanok` (statement + proof) | Blueprint | **major** |
| `lem:isZero_of_faithful_preservesZeroMorphisms` missing `\leanok` | Blueprint | **major** |
| `lem:cechSection_isZero_homology` `\uses` omits direct dep `lem:isZero_homology_of_iso_homotopy_id_zero` | Blueprint | **minor** |

No Lean-side findings. No must-fix-this-iter items.

**Overall verdict**: The Lean file is mathematically faithful to the blueprint in all six declarations — signatures match, proofs follow the sketches, Step 3(d) closure is exactly `cechSection_isZero_homology` as the blueprint prescribes, and there are no red flags. Two blueprint `\leanok` markers are stale (major, blueprint-side), and one `\uses` entry is a minor gap.
