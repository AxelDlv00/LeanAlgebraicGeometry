# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
041

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks `lem:qcoh_section_equalizer` and `lem:tile_section_localization`, and their
   supporting machinery)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_section_equalizer}` (chapter: `lem:qcoh_section_equalizer`)

- **Lean target exists**: yes — `theorem qcoh_section_equalizer` at Lean line 592
- **Signature matches**: partial (Lean is strictly more general; see notes)
- **Proof follows sketch**: yes — injectivity via `section_ext`, exactness at middle via
  `existsUnique_gluing'`; no sorry; no suspect bodies
- **`\leanok` status**: correctly set on statement (line 4293) and proof (line 4319)
- **notes**: The Lean declaration takes an **arbitrary** index type `ι` and an abstract open
  cover `U : ι → (Spec R).Opens` satisfying `∀ i, U i ≤ W` and `W ≤ ⨆ U i`. The blueprint
  states the specific `U i = W ∩ D(gᵢ)` instance. The generalization is documented and
  intentional: `% NOTE:` at tex lines 4297–4303 explains the Lean decl subsumes the stated
  one and names the downstream specialisations (`W = ⊤, U = D(gᵢ)` / `W = D(f), U = D(fgᵢ)`).
  **No action required on the Lean side; minor blueprint wording update acceptable.**

---

### `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}` — NO BLUEPRINT BLOCK

- **Lean target exists**: yes — `lemma isLocalizedModule_powers_restrictScalars_of_algebraMap`
  at Lean line 662, in `section BaseRingDescent`
- **Blueprint `\lean{}` pin**: **NONE** — no block in the chapter references this declaration
- **Signature matches**: N/A — no blueprint block to compare against
- **Proof follows sketch**: N/A
- **notes**: This is a substantive ~40-line proof of the converse of Mathlib's
  `IsLocalizedModule.of_restrictScalars`: an `A`-linear map that is a localization at
  `powers (algebraMap R A f)` (over the larger ring `A`) is, `R`-linearly, a localization at
  `powers f` (over `R`). It is the base-ring descent brick that `tile_section_localization`
  needs. Neither the statement block nor the proof block of `lem:tile_section_localization`
  include it in `\uses{...}`. The directive notes it informally as "the descent" but the
  blueprint gives no `\lean{}` target. **This is a major finding (blueprint coverage gap).**

---

### `\lean{AlgebraicGeometry.tile_section_localization}` (chapter: `lem:tile_section_localization`)

- **Lean target exists**: **NO** — declaration `AlgebraicGeometry.tile_section_localization`
  is absent from `QcohTildeSections.lean` (and from any Lean file in the project, based on
  the file structure)
- **`\leanok` status on blueprint block**: correctly absent (no `\leanok`; lines 4351–4363)
- **Proof follows sketch**: N/A (to-build; non-existence is expected)
- **Blueprint proof sketch adequacy**: **INADEQUATE** — see `## Blueprint adequacy` below
- **notes**: The non-existence is deliberate. The prover found the planned `restrict_obj`-rfl
  / section-comparison-wiring recipe unsound (iter-041 context). The real obstruction is the
  base-ring change: `section_isLocalizedModule_of_presentation` produces
  `IsLocalizedModule (powers (algebraMap R R_g f))` over `R_g`, but the keystone
  comparison requires `IsLocalizedModule (powers f)` over `R`. This conversion needs
  `isLocalizedModule_powers_restrictScalars_of_algebraMap`, which the Lean file provides but
  the blueprint proof sketch does not mention.

---

### `\lean{AlgebraicGeometry.res_trans_apply}` — private, bundled

- **Lean target exists**: yes — `private lemma res_trans_apply` at Lean line 576
- **Separate blueprint block**: none; bundled by `% NOTE:` under `lem:qcoh_section_equalizer`
  (tex line 4302–4303)
- **notes**: Correct handling; private helper, no separate block needed.

---

### Other Lean declarations, unreferenced from any blueprint block

| Declaration | Line | Assessment |
|---|---|---|
| `qcoh_iso_tilde_sections_hom` | 80 | `@[simp]` helper exposing `.hom = inv fromTildeΓ`; pure simp lemma |
| `qcoh_iso_tilde_sections_inv` | 86 | `@[simp]` helper exposing `.inv = fromTildeΓ`; pure simp lemma |
| `coversTop_iSup_eq_top` | 528 | **private** in Lean, but pinned as `AlgebraicGeometry.coversTop_iSup_eq_top` under `lem:qcoh_finite_presentation_cover`; private decls have mangled Lean 4 names so the pin doesn't resolve |
| Private helpers in `SpanCoverLocalization` | 209–322 | Same issue: 7 private lemmas listed by their intended public names in `\lean{...}` for `lem:isLocalizedModule_of_span_cover`; the blueprint NOTE acknowledges this pragmatic bundling |

---

## Red flags

### Placeholder / suspect bodies

None. Every formalized declaration has a complete proof body; no `:= sorry`.

### Excuse-comments

None that apply to the Lean file itself.

### Axioms / Classical.choice on substantive claims

None found.

### `\lean{...}` target does not resolve

1. `AlgebraicGeometry.tile_section_localization` — pinned at tex line 4353 but does not exist
   in any Lean file. Status: **expected** (no `\leanok` on the block); the issue is the
   sketch adequacy, not a stale pin.

2. `AlgebraicGeometry.coversTop_iSup_eq_top` — pinned at tex line 4096 but is declared
   `private` in Lean (line 528). Private declarations in Lean 4 have mangled names; the
   public form won't resolve for `sync_leanok` or the blueprint web. **Minor.**

3. Seven private helpers for `lem:isLocalizedModule_of_span_cover` — same issue (lines 4961–4963).
   Blueprint NOTE at 4965–4967 says "sync_leanok resolves them as [leanok]" but this claim is
   optimistic if `sync_leanok` checks exact Lean names. **Minor.**

---

## Unreferenced declarations (informational)

**Substantive, should probably have a blueprint block:**
- `isLocalizedModule_powers_restrictScalars_of_algebraMap` (line 662): base-ring descent for
  `IsLocalizedModule`; ~40-line proof; needed by `tile_section_localization`; currently has no
  `\lean{}` pin anywhere in the chapter. **Flagged as major** (see Per-declaration above).

**Mechanical helpers (acceptable):**
- `qcoh_iso_tilde_sections_hom` (line 80): `@[simp]` for `.hom`
- `qcoh_iso_tilde_sections_inv` (line 86): `@[simp]` for `.inv`

---

## Blueprint adequacy for this file

### Coverage
13/15 public declarations have a `\lean{...}` reference in the chapter. Two unreferenced:
- `qcoh_iso_tilde_sections_hom` / `_inv` (simp helpers — acceptable)
- **`isLocalizedModule_powers_restrictScalars_of_algebraMap`** — substantive, flagged

### Proof-sketch depth: **under-specified**

The sketch for `lem:tile_section_localization` (tex lines 4364–4387) omits the base-ring
descent step. The proof argues:

> "Apply `lem:section_isLocalizedModule_of_presentation` to `F_{(g)}` and `\bar f = algebraMap R R_g f`.
> Under the section comparison of `lem:restrict_obj_mathlib`, the powers of `\bar f` correspond
> to the powers of `f`."

The hand-wave is "correspond to the powers of `f`." `section_isLocalizedModule_of_presentation`
delivers `IsLocalizedModule (Submonoid.powers (algebraMap R R_g f))` of a map whose source and
target are `R_g`-modules. The keystone comparison requires `IsLocalizedModule (Submonoid.powers f)`
of the same map, viewed `R`-linearly. Bridging these requires a non-trivial lemma (the
`isLocalizedModule_powers_restrictScalars_of_algebraMap` in the Lean file). The blueprint gives
no guidance on this step, no `\uses{}` pointer to any base-ring descent lemma, and critically
fails to distinguish the `R_g`-localization from the `R`-localization. This is not a wiring
issue: it is a genuine ~100-150 LOC formalization subtlety that the sketch leaves implicit.

The `\uses{}` for the proof block is:
```
\uses{lem:presentation_modulesRestrictBasicOpen, lem:section_isLocalizedModule_of_presentation,
  lem:restrict_obj_mathlib}
```
It should also include a `\lean{}` pin for the base-ring descent lemma, which does not yet have
a blueprint block.

### Hint precision: **loose**
The `\lean{AlgebraicGeometry.tile_section_localization}` pin is a forward reference to a
to-build declaration. Once the declaration is written, the hint precision can be assessed
properly. Current precision for `lem:qcoh_section_equalizer` and the other formalized blocks
is **precise**.

### Generality: **matches need**
The `qcoh_section_equalizer` is formalized at greater generality than the blueprint states —
the blueprint documents this via `% NOTE:` and the downstream specialisations are clearly named.
The generalization is architecturally justified (the theorem is invoked for both `W = ⊤` and
`W = D(f)` covers).

### Recommended chapter-side actions (for the blueprint-writing subagent)

1. **Add a `\begin{lemma} ... \end{lemma}` block for `isLocalizedModule_powers_restrictScalars_of_algebraMap`.**
   Content: state the converse of `of_restrictScalars` — if an `A`-linear map is a localization
   at `powers (algebraMap R A f)` (with `IsScalarTower R A M`, `IsScalarTower R A N`), its
   `R`-linear restriction is a localization at `powers f`. Label it
   `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` and pin
   `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}`.

2. **Strengthen the proof sketch for `lem:tile_section_localization`.**
   After the step "apply `lem:section_isLocalizedModule_of_presentation` to `F_{(g)}` and
   `\bar f`", add an explicit step: "Since `\bar f = algebraMap R R_g f`, the resulting
   `IsLocalizedModule (powers \bar f)` over `R_g` descends to `IsLocalizedModule (powers f)`
   over `R` by base-ring descent
   (Lemma~\ref{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}), using the
   `IsScalarTower R R_g` structure on the section modules." Add that lemma to `\uses{}`.

3. **Optional / minor**: Decide whether to state `lem:qcoh_section_equalizer` in its full
   generality (arbitrary open cover of `W`) rather than the basic-open specialisation. The
   current `% NOTE:` is adequate for now but the downstream references (`lem:qcoh_section_kernel_comparison`
   proof sketch) invoke both specialisations; stating the general form avoids the implicit
   "subsumes" language.

4. **Investigate private-name mismatches**: `coversTop_iSup_eq_top` and the seven
   `SpanCoverLocalization` private helpers are listed in `\lean{...}` pins by their intended
   public names but are declared `private` in Lean 4. Either promote them (remove `private`)
   or replace their blueprint `\lean{}` pins with a NOTE comment, matching the pattern used for
   `res_trans_apply`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:tile_section_localization` proof sketch omits base-ring descent step; the sketch is insufficient to guide correct formalization (the naive `restrict_obj`-wiring recipe is unsound, as confirmed by the prover) | **must-fix-this-iter** |
| `isLocalizedModule_powers_restrictScalars_of_algebraMap` (substantive, ~40-line Lean proof) has no `\lean{}` blueprint block and is not in `\uses{}` of any block that needs it | **major** |
| `qcoh_section_equalizer`: Lean is strictly more general (arbitrary cover vs basic-open); blueprint NOTE documents this but prose still states the narrow form | **minor** |
| `coversTop_iSup_eq_top` is `private` in Lean but pinned by its intended public name | **minor** |
| Seven `SpanCoverLocalization` private helpers listed by public names in `\lean{}` (blueprint NOTE acknowledges this) | **minor** |
| `qcoh_iso_tilde_sections_hom` / `_inv` simp lemmas unreferenced from the blueprint | **minor** |

**Overall verdict**: The Lean file is sound — all formalized declarations compile without sorry and match their blueprint blocks where blocks exist. The critical gap is on the blueprint side: `lem:tile_section_localization`'s proof sketch does not acknowledge the base-ring descent step (`isLocalizedModule_powers_restrictScalars_of_algebraMap`) that the Lean file implements as a standalone lemma, making the sketch insufficient to guide correct formalization of the to-build declaration.
