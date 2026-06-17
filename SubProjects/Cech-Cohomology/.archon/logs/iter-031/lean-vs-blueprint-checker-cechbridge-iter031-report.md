# Lean ↔ Blueprint Check Report

## Slug
cechbridge-iter031

## Iteration
031

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (iter-031 focus: `…Fam` additions)

### `\lean{AlgebraicGeometry.sectionCechComplexMapOpIsoFam}` (chapter: `lem:section_cech_complex_mapop_iso`, line 2602–2603)

- **Lean target exists**: yes — `def sectionCechComplexMapOpIsoFam` at line 1056, within `section FamilyParameterizedBridge` (section variable `{ι : Type u} [Finite ι] (U : ι → TopologicalSpace.Opens ↥X)`)
- **Signature matches**: yes — `F : X.PresheafOfModules` argument, returns `((preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj (HomologicalComplex.op (cechFreePresheafComplexFam U)) ≅ sectionCechComplex U F`. Cover-agnostic: `U : ι → Opens ↥X` with no covering hypothesis, no `X.OpenCover`. Exactly matches blueprint prose ("cover-agnostic raw-finite-family mirror", "no covering hypothesis", lines 2626–2628).
- **Proof follows sketch**: yes — `(homCechComplexMapOpIsoFam U F).symm ≪≫ cechComplex_hom_identificationFam U F`. Blueprint says it is `homCechComplexMapOpIso⁻¹` followed by `cechComplex_hom_identification` (line 2620–2621). The Fam proof mirrors this exactly.
- **Notes**: no `sorry`, body complete.

---

### `\lean{AlgebraicGeometry.injective_cech_acyclicFam}` (chapter: `lem:injective_cech_acyclic`, line 2664)

- **Lean target exists**: yes — `theorem injective_cech_acyclicFam` at line 1075, within the same `section FamilyParameterizedBridge`
- **Signature matches**: yes — `(I : X.Modules) [Injective I] (p : ℕ) (hp : 0 < p)` returning `IsZero ((sectionCechComplex U ((Scheme.Modules.toPresheafOfModules X).obj I)).homology p)`. No covering hypothesis on `U`. Blueprint prose lines 2700–2715 describe exactly this: "arbitrary finite family of opens {U_i}_{i∈ι}, with no covering hypothesis … parameterized by a raw finite family {U_i}_{i∈ι} of opens (ι finite) carrying no covering hypothesis; it consumes the family-form resolution quasi-isomorphism `cechFreeComplex_quasiIsoFam`." The Lean proof indeed calls `cechFreeComplex_quasiIsoFam U` at line 1078.
- **Proof follows sketch**: yes — two-part argument mirrors blueprint proof sketch (Part 1: injective-as-presheaf via `injective_toPresheafOfModules`; Part 2: quasi-iso transport via `sectionCechComplexMapOpIsoFam`). Degree-0 source vanishing uses `coverStructurePresheafFam` (parallel to `coverStructurePresheaf` in the OpenCover version).
- **Notes**: `set_option maxHeartbeats 2000000` in force (same as `injective_cech_acyclic`), no `sorry`.

---

## Supporting `…Fam` helpers — blueprint coverage status

The `FamilyParameterizedBridge` section (lines 934–1113) introduces **11 declarations** total besides the 2 named targets (8 named targets + 3 private helpers below the two names):

### Public (non-private) — 6 unmatched helpers

| Lean name | Line | Blueprint `\lean{}` pin? |
|---|---|---|
| `homCechCosimplicialFam` | 941 | **none** |
| `homCechComplexFam` | 945 | **none** |
| `homCechSectionIsoAppFam` | 949 | **none** |
| `homCechSectionCosimplicialIsoFam` | 980 | **none** |
| `cechComplex_hom_identificationFam` | 1006 | **none** |
| `homCechComplexMapOpIsoFam` | 1045 | **none** |

These are mechanical mirrors of the OpenCover-indexed helpers already pinned in `lem:cech_complex_hom_identification` (`homCechComplex`, `homCechCosimplicial`, `homCechSectionIsoApp`, `homCechSectionCosimplicialIso`, `cechComplex_hom_identification`) and `lem:cech_complex_op_identification` (`homCechComplexMapOpIso`). None of the 6 appear in any `\lean{}` list.

### Private — 3 helpers (pinning not expected)

| Lean name | Line |
|---|---|
| `homCechSectionIsoApp_hom_πFam` | 961 |
| `homCechCosimplicial_δFam` | 1013 |
| `homCechComplex_d_eqFam` | 1020 |

Private declarations; correct to omit from blueprint.

**Planner note:** The 6 public Fam helpers should be bundled into the `\lean{}` lists of their parallel blueprint blocks:
- `homCechCosimplicialFam`, `homCechComplexFam`, `homCechSectionIsoAppFam`, `homCechSectionCosimplicialIsoFam`, `cechComplex_hom_identificationFam` → append to `\lean{...}` in `lem:cech_complex_hom_identification`
- `homCechComplexMapOpIsoFam` → append to `\lean{...}` in `lem:cech_complex_op_identification`

---

## Red flags

None found.

### Placeholder / suspect bodies
None. The entire `FamilyParameterizedBridge` section (lines 934–1113) is sorry-free. `grep -n "sorry"` returns empty output.

### Excuse-comments
None. The `set_option maxHeartbeats 2000000` on `injective_cech_acyclicFam` is accompanied by a legitimate explanatory comment ("defeq checks exceed the default heartbeat budget", same as on `injective_cech_acyclic`) — not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following public declarations in `CechBridge.lean` appear in no `\lean{}` block:

1. **`homCechCosimplicialFam`** — family form of `homCechCosimplicial`; parallel version exists in blueprint. Bundle into `lem:cech_complex_hom_identification`.
2. **`homCechComplexFam`** — family form of `homCechComplex`. Same.
3. **`homCechSectionIsoAppFam`** — family form of `homCechSectionIsoApp`. Same.
4. **`homCechSectionCosimplicialIsoFam`** — family form. Same.
5. **`cechComplex_hom_identificationFam`** — family form of `cechComplex_hom_identification`. Same.
6. **`homCechComplexMapOpIsoFam`** — family form of `homCechComplexMapOpIso`. Bundle into `lem:cech_complex_op_identification`.

Pre-existing unreferenced public declarations (not introduced this iter):
- `homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`, `homCechSectionCosimplicialIso` — all pinned in `lem:cech_complex_hom_identification` ✓
- `homCechComplexMapOpIso` — pinned in `lem:cech_complex_op_identification` ✓
- `sectionCechComplexMapOpIso` — pinned in `lem:section_cech_complex_mapop_iso` ✓

---

## Blueprint adequacy for this file

- **Coverage**: Named targets `sectionCechComplexMapOpIsoFam` and `injective_cech_acyclicFam` are correctly pinned. 6/8 public Fam helpers are unmatched. Pre-existing OpenCover declarations: all pinned. Private helpers: correctly omitted. Overall: 2/8 public Fam decls pinned (the 2 named targets); 6 are `lean_aux` needing bundling.

- **Proof-sketch depth**: **adequate** for both named targets. Blueprint prose for `lem:section_cech_complex_mapop_iso` (lines 2626–2628) explicitly names the Fam variant and its "no covering hypothesis" character. Blueprint proof sketch for `lem:injective_cech_acyclic` (lines 2740–2789) describes the two-part assembly clearly and matches the Lean code.

- **Hint precision**: **precise** — both `\lean{}` pins use the exact Lean declaration names. The blueprint prose for the Fam variant of `lem:injective_cech_acyclic` (line 2713) correctly names the consumed quasi-iso lemma `cechFreeComplex_quasiIsoFam`.

- **Generality**: **matches need** — the Fam forms are parameterized by `{ι : Type u} [Finite ι] (U : ι → Opens ↥X)` with no covering hypothesis, exactly as the downstream consumer `BasisCovSystem.injective_acyclic` needs (any open, not just `X`).

### `lean_decls` and HTML out of sync — major workflow issue

The `blueprint/lean_decls` file (368 entries) does **not** contain `sectionCechComplexMapOpIsoFam`, `injective_cech_acyclicFam`, or any other `…Fam` declaration added this iter. The HTML web output (`blueprint/web/chap-Cohomology_CechHigherDirectImage.html`) for `lem:section_cech_complex_mapop_iso` (Lemma 63) shows only the pre-iter `lean_decl` link for `sectionCechComplexMapOpIso`; the Fam variant does not appear. Neither `lem:section_cech_complex_mapop_iso` nor `lem:injective_cech_acyclic` carries a `\leanok` marker in the `.tex` source.

The `.tex` blueprint source is correct (Fam names are present). The derived files are stale. Since `sync_leanok` may use `lean_decls` as its declaration registry, it may not have added `\leanok` to these blocks even though the Lean code is sorry-free.

**Recommended chapter-side actions:**
1. **Regenerate `lean_decls` and HTML web output** — run `leanblueprint` to pick up the two new Fam `\lean{}` pins. Once `lean_decls` includes `sectionCechComplexMapOpIsoFam` and `injective_cech_acyclicFam`, `sync_leanok` will be able to verify and set `\leanok` on those blocks.
2. **Bundle the 6 public Fam helpers** into the `\lean{}` lists of `lem:cech_complex_hom_identification` and `lem:cech_complex_op_identification` (see "Planner note" above).

---

## Severity summary

- **must-fix-this-iter**: none.
- **major** (1):
  - `lean_decls` and HTML web output not regenerated after the blueprint was updated with `sectionCechComplexMapOpIsoFam` and `injective_cech_acyclicFam`. `sync_leanok` cannot set `\leanok` on `lem:section_cech_complex_mapop_iso` and `lem:injective_cech_acyclic` until `lean_decls` is regenerated. The Lean code is correct; the gap is in the blueprint tooling state.
- **minor** (1):
  - 6 public Fam helpers (`homCechCosimplicialFam` … `homCechComplexMapOpIsoFam`) are not yet bundled into their parallel blueprint `\lean{}` blocks.

**Overall verdict**: The two named targets `sectionCechComplexMapOpIsoFam` and `injective_cech_acyclicFam` are correctly formalized — cover-agnostic, no covering hypothesis, sorry-free, signatures match the blueprint prose. The 6 unregistered public Fam helpers are legitimate lean_aux. The sole blocking workflow issue is that `lean_decls` and the HTML web output need regenerating to track the new pins, which is a build-tooling task for the planner.
