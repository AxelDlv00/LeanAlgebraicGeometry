# Blueprint Review Report

## Slug
iter056-recheck

## Iteration
056

## Scope
Scoped re-check of `Cohomology_CechHigherDirectImage.tex` only, targeting the single must-fix
from iter-056 (`lem:open_immersion_pushforward_comp` proof detail (2) — change-of-scheme Serre
transport) plus explicit verdicts on the Sub-brick A chain and `lem:affine_serre_vanishing_general_open`.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **RESOLVED (iter-056 must-fix)**: `lem:open_immersion_pushforward_comp` proof detail (2) has been
    fully rewritten as a three-part split (2a)/(2b)/(2c); see detailed findings below. No must-fix
    items remain.
  - **INFORMATIONAL (residual)**: 2 isolated lean_aux nodes remain (down from 7 in iter-056);
    both are correctly `keep` — see Dependency & isolation findings.

---

## Detailed findings by directive scope

### (a) `lem:open_immersion_pushforward_comp` — transport sub-lemmas

**RESOLVED.** The must-fix from iter-056 is fully discharged. The proof detail (2) has been
replaced by a three-sub-step structure:

**(2a)** Reduces the residual to an Ext vanishing over the abstract affine scheme `U`, using the
corepresentability isomorphism (`lem:sectionsFunctorCorepIso`) upgraded to right derived functors
by `lem:rightDerivedNatIso`. Both of these lemmas now have blueprint entries.

**(2b) (Need #1)** Transports Ext along the whole-scheme isomorphism `U ≅ Spec Γ(U, O_U)`
(`lem:modules_isoSpec_ext_transport`). This is a TODO build target — see item (c2) below.

**(2c) (Need #2)** Applies general-affine-open Serre vanishing over `Spec Γ U`
(`lem:affine_serre_vanishing_general_open`). Also a TODO build target — see item (c1) below.

The `\uses{}` edges in both the statement block (lines 7959–7965) and the proof block (line 8003)
now explicitly list:
`lem:rightDerivedNatIso, lem:sectionsFunctorCorepIso, lem:affine_serre_vanishing_general_open,
lem:modules_isoSpec_ext_transport`.

`leandag build --json` reports `unknown_uses: []` — all `\uses{}` labels resolve.

**DEAD-END remark (mathematically correct):** The remark at lines 8114–8125 correctly explains why
the open-subscheme transport route fails. The argument is:
- `j^{-1}(V) ↪ U` is an open immersion, not an isomorphism; the open-subscheme isoSpec gives
  `j^{-1}(V) ≅ Spec Γ(j^{-1}(V))` but NOT an equivalence `U.Modules ≅ (j^{-1}(V)).Modules`.
- Using it forces the restriction functor `H ↦ H|_{j^{-1}(V)}`, and the derived comparison
  `Ext^q_U(j_!O_{j^{-1}(V)}, H) ≅ H^q(j^{-1}(V), H|_{j^{-1}(V)})` requires the restriction
  to preserve injectives — infrastructure not available in the present formalism (restriction along
  an open immersion does not generally preserve injectives in Mathlib's sheaf-of-modules API).
- The correct route keeps isoSpec at the level of the *whole* affine `U` (where it is a genuine
  isomorphism of schemes) and handles the general affine open ambiently in Spec Γ U.

This is mathematically correct and well-stated.

**Three new `\mathlibok` anchors verified against Mathlib:**
- `lem:isoSpec_scheme_mathlib` → `AlgebraicGeometry.Scheme.isoSpec`:
  exists at `Mathlib/AlgebraicGeometry/AffineScheme.lean:68`.
- `lem:ext_mapExactFunctor_mathlib` → `CategoryTheory.Abelian.Ext.mapExactFunctor`:
  exists at `Mathlib/Algebra/Homology/DerivedCategory/Ext/Map.lean:126`.
- `lem:modules_pushforward_mathlib` → `AlgebraicGeometry.Scheme.Modules.pushforward`:
  exists at `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:151`.
  All three form/signature descriptions match Mathlib.

---

### (b) Sub-brick A chain (`lem:cech_backbone_left_sigma` … `lem:cechSection_contractible`)

**CLEAN.** No issues. All 6 lemmas have detailed statements and proof sketches; all `\uses{}`
labels resolve; the misleading `\uses{lem:cech_acyclic_affine}` in `lem:cechSection_contractible`
is now accompanied by an explicit prose clarification at lines 7711–7714:

> "Lemma~\ref{lem:cech_acyclic_affine} is cited only as the Lean home of the `dep*` engine
> declarations — its standard-cover Čech-vanishing *conclusion* is *not* a mathematical
> dependency of the present contractibility argument"

This directly addresses the informational finding from iter-056.

---

### (c1) `lem:affine_serre_vanishing_general_open` — Need #2 target

**Well-formed build target.** Checklist:
- **Statement**: complete (lines 8297–8307). Quantifies over `R` a ring, `V` any affine open of
  `Spec R`, `H` quasi-coherent, concludes `Ext^q(j_!O_V, H) = 0` for `q ≥ 1`.
- **Informal proof** (lines 8308–8338): concrete and prover-ready. Instantiates
  `lem:cech_to_cohomology_on_basis` at the affine cover system with basis `B` enlarged from
  distinguished opens to all affine opens. The three cover-system fields are discharged
  individually; the `surj_of_vanishing` generalization is explained (quasi-compactness of any
  affine open replaces quasi-compactness of `D(f)`).
- **`\uses{}` edges** (both statement and proof blocks): `lem:cech_to_cohomology_on_basis`,
  `lem:affine_surj_of_vanishing`, `lem:standard_cover_cofinal`, `def:affine_cover_system`,
  `lem:affine_faces_mem`, `lem:injective_cech_acyclic`, `def:absolute_cohomology` — all resolve.
- **`\lean{}` pin**: `AlgebraicGeometry.affine_serre_vanishing_general_open_TODO` with `% NOTE:`
  comment explicitly marking it as a build target.
- **No `\leanok` or `\mathlibok` marker**: confirmed.

**Legitimately "to be built"**, not a defect.

---

### (c2) `lem:modules_isoSpec_ext_transport` — Need #1 target

**Well-formed build target.** Checklist:
- **Statement**: complete (lines 8349–8360). Quantifies over affine `U`, affine open `V ⊆ U`,
  quasi-coherent `H`; states that `Scheme.isoSpec` induces an isomorphism of `Ext^q` groups
  (transported objects identified).
- **Informal proof** (lines 8362–8382): assembles the module-category equivalence `Φ` from
  `Scheme.Modules.pushforward` coherences; applies `Ext.mapExactFunctor` to `Φ` and its
  quasi-inverse; identifies images of both Ext arguments.
- **`\uses{}` edges** (both blocks): `lem:isoSpec_scheme_mathlib`, `lem:ext_mapExactFunctor_mathlib`,
  `lem:modules_pushforward_mathlib`, `lem:jshriek_corepr` — all resolve.
- **`\lean{}` pin**: `AlgebraicGeometry.modulesIsoSpecExtTransport_TODO` with `% NOTE:` comment.
- **No `\leanok` or `\mathlibok` marker**: confirmed.

**Legitimately "to be built"**, not a defect.

---

## Dependency & isolation findings

**`leandag build --json` summary** (post-rewrite):
- `blueprint_nodes`: 218, `lean_aux_nodes`: 2, `proved`: 82, `mathlib_ok`: 43
- `isolated`: 2 (down from 7 in iter-056)
- `unknown_uses`: [] (no broken `\uses{}` edges)
- `conflicts`: []

**Remaining isolated lean_aux nodes (2):**

1. `lean:AlgebraicGeometry.jShriekOU_homEquiv_nat` (`OpenImmersionPushforward.lean`, proved):
   `private lemma` — internal helper for `sectionsFunctorCorepIso`, not expected to have a
   blueprint entry. **keep**.

2. `lean:AlgebraicGeometry.CechAcyclic.affine` (`CechAcyclic.lean`, has sorry):
   Dormant superseded sorry with no DAG path to the main theorem (`rdep_count = 0`).
   Unchanged from iter-056. **keep** (future cleanup pass can delete the sorry).

**5 formerly isolated nodes now wired up:** `lem:rightDerivedNatIso`, `lem:sectionsFunctorCorepIso`,
`lem:sectionsFunctor_additive`, `lem:toPresheafOfModules_additive`,
`lem:isZero_homology_of_iso_homotopy_id_zero` — all have blueprint entries with statements,
proof sketches, and `\lean{}` hints. This resolves the SOON finding from iter-056.

---

## Rendering integrity

`archon blueprint-doctor --json` output: `malformed_refs: []`, `broken_refs: []`,
`orphan_chapters: []`, `covers_problems: []`. Clean.

---

## Resolved iter-056 "soon" items

For completeness:
1. Stale `affine_serre_vanishing` body prose ("currently formalized in reduced form pending
   residual"): **DELETED** — no such text remains.
2. 6 isolated lean_aux nodes: **5 of 6 wired up** with blueprint entries; 1 private helper
   remains (`keep`).
3. `lem:cechSection_contractible` `\uses{lem:cech_acyclic_affine}` misleading as math dependency:
   **RESOLVED** with inline prose clarification.

---

## Hard Gate verdict

### `CechSectionIdentification.lean` (Sub-brick A chain)

**GATE CLEARS.** The consolidated chapter `Cohomology_CechHigherDirectImage.tex` is now
`complete: true`, `correct: true` with no must-fix findings. The Sub-brick A section itself
(6 lemmas, `lem:cech_backbone_left_sigma` through `lem:cechSection_contractible`) is internally
clean: all statements are detailed, all proof sketches are prover-ready, all `\uses{}` labels
resolve. Dispatch `CechSectionIdentification.lean` is unblocked.

### `AffineSerreVanishing.lean` (Need #2 general-affine-open Serre vanishing)

**GATE CLEARS.** `lem:affine_serre_vanishing_general_open` is a well-formed build target: complete
statement, concrete proof strategy (enlarge the basis `B` in the affine cover system from `{D f}`
to all affine opens, reuse `cech_to_cohomology_on_basis`), all `\uses{}` edges resolve,
`_TODO`-suffixed `\lean{}` pin present, no premature markers. Dispatch `AffineSerreVanishing.lean`
is unblocked.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings. Both prover lanes unblocked.

---

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `complete: true`, `correct: true`; the
iter-056 must-fix (change-of-scheme Serre transport proof gap) is fully resolved via the two-need
split with verified `\mathlibok` anchors and well-formed TODO build targets; the hard gate clears
for both `CechSectionIdentification.lean` and `AffineSerreVanishing.lean`.
