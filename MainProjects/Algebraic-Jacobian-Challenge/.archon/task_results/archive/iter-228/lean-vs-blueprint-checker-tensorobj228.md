# Lean ↔ Blueprint Check Report

## Slug
tensorobj228

## Iteration
228

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (for each `\lean{...}` block in the chapter)

Only the blocks directly relevant to this iter's changes are reviewed in detail; all other existing pins are noted under "pre-existing" at the end.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, blueprint ~L2782)
- **Lean target exists**: **no** — the declaration `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` does not appear anywhere in the Lean file as a `def`, `lemma`, or `theorem`. It is referenced only in comments (`-- (C) \`dual_isLocallyTrivial\`` at L2151; `closes (see body comment): the C-bridge \`dual_isLocallyTrivial\`` at L2137; doc-string comment at L1602, L1696). The C-bridge did not land.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A (declaration absent)
- **Notes**:
  - The `% NOTE` is present (blueprint lines 2785–2803), added this iter, documenting: the verbatim-mirror proof sketch is incorrect past Step 3/H1; the residual after H1 is `(pushforward β)(dual A) ≅ dual((pushforward β)(A))`; this is the SLICE internal-hom vs sectionwise mismatch (the open-immersion slice-site equivalence, ~150–300 LOC, Mathlib-absent); `restrictScalarsRingIsoDualEquiv` does NOT discharge it because `dual` is a slice internal-hom (morphism-module over `Over U`), not a sectionwise `restrictScalars`-image. The note explicitly states the writer must correct Steps/H2′ before this lemma is re-dispatched.
  - The lemma's statement block carries **no** `\leanok` marker, correctly reflecting that the declaration is absent.
  - The fake `\lean{...}` pin is actively documented by the NOTE; the pin itself should be replaced or kept only as a forward placeholder with explicit "not yet formalized" signposting.

---

## New declarations (iter-228) — Lean → Blueprint check

### `PresheafOfModules.dualPrecompEquiv` (Lean L1558)
- **Blueprint block exists**: **no** — no `\lean{PresheafOfModules.dualPrecompEquiv}` pin and no prose block anywhere in `Picard_TensorObjSubstrate.tex`. Confirmed by exhaustive grep of all `\lean{...}` pins in the chapter.
- **Signature in Lean**: `{M M' : PresheafOfModules R₀} (e : M ≅ M') (U : D) : (restr U M' ⟶ restr U (𝟙_ _)) ≃ₗ[R₀.obj (op U)] (restr U M ⟶ restr U (𝟙_ _))` — precomposition `R(U)`-linear equivalence on dual sections induced by a presheaf-of-modules isomorphism.
- **Body**: full proof body (no `sorry`); axiom-clean per the directive context.
- **Role**: described in its docstring as "the section-level core of `dualIsoOfIso` (the dual is contravariantly functorial in isomorphisms)"; feeds the presheaf-level `dualIsoOfIso` below.

### `PresheafOfModules.dualIsoOfIso` (Lean L1603)
- **Blueprint block exists**: **no** — no `\lean{PresheafOfModules.dualIsoOfIso}` pin and no prose block in the chapter.
- **Signature in Lean**: `{M M' : PresheafOfModules R₀} (e : M ≅ M') : dual M' ≅ dual M` — presheaf dual is contravariantly functorial in isomorphisms, assembled sectionwise from `dualPrecompEquiv`.
- **Body**: `PresheafOfModules.isoMk (fun U => (dualPrecompEquiv e U.unop).toModuleIso)` — no `sorry`, axiom-clean.
- **Role**: docstring calls it the "`\leanok`-ready ingredient that transports a local trivialisation `L|_U ≅ 𝒪_U` to `dual (L|_U) ≅ dual 𝒪_U` in the assembly of `dual_isLocallyTrivial`."

### `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (Lean L1698)
- **Blueprint block exists**: **no** — no `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` pin and no prose block in the chapter.
- **Signature in Lean**: `{X : Scheme} {M M' : X.Modules} (e : M ≅ M') : dual M' ≅ dual M` — scheme-level dual is contravariantly functorial in isomorphisms, sheafifying `PresheafOfModules.dualIsoOfIso` of the underlying presheaf iso.
- **Body**: `(PresheafOfModules.sheafification ...).mapIso (PresheafOfModules.dualIsoOfIso ...)` — no `sorry`, axiom-clean.
- **Role**: docstring calls it "the reusable 'dual respects isos' ingredient (the dual analogue of `tensorObjIsoOfIso`) feeding the assembly of `dual_isLocallyTrivial`."

---

## Red flags

### Placeholder / suspect bodies
- **`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`** at L2143: body is `:= sorry`. Blueprint `lem:tensorobj_inverse_invertible` claims a substantive statement with an infrastructure-blocked but real mathematical route. This is a **pre-existing** sorry (iter-222+), not introduced this iter. The blueprint proof body is marked "Infrastructure-blocked" with a detailed deferred route. The blueprint carries no `\leanok` on the proof block.
- **`AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`** at L2208: body is `sorry`. Blueprint `thm:rel_pic_addcommgroup_via_tensorobj` carries a `\leanok` on the statement block (blueprint L2079). This is a **pre-existing** sorry. The `\leanok` on the statement block is correctly set because a typed scaffold (even `sorry`) satisfies the `sync_leanok` criterion for the statement block.
- **`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`** at L1834: body is sorry-transitive through `isLocallyInjective_whiskerLeft_of_W` (which itself depends on the open route-(d)/(e) obligation). This is **pre-existing** and documented in the file.

### Fake / placeholder `\lean{...}` pins (blueprint → Lean)
- **`\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`** (blueprint L2782): declaration absent from Lean file. Documented by the iter-228 `% NOTE:` in the proof body. **See Per-declaration entry above.**
- **`\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}`** (blueprint L1870): declaration absent from Lean file. Pre-existing; the body of `addCommGroup_via_tensorObj` is `sorry` and stands in for it. Not new this iter.
- **`\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}`** (blueprint L1741): declaration absent from Lean file. Pre-existing. Not new this iter.
- **`\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`** (blueprint L2939): declaration absent from Lean file. Pre-existing. Not new this iter.

---

## Unreferenced declarations (informational)

The following substantive Lean declarations have **no** `\lean{...}` reference in the blueprint chapter and are not explicitly flagged as helper-only. The first three are the new iter-228 additions and are the main findings:

| Declaration | Lean Line | Blueprint status | Comment |
|---|---|---|---|
| `PresheafOfModules.dualPrecompEquiv` | 1558 | **Missing pin** | Feeds `dualIsoOfIso`; named as "section-level core of `dualIsoOfIso`" |
| `PresheafOfModules.dualIsoOfIso` | 1603 | **Missing pin** | Named as "`\leanok`-ready ingredient" for `dual_isLocallyTrivial`; substantive |
| `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` | 1698 | **Missing pin** | Scheme-level dual functor-of-isos; substantive, "dual analogue of `tensorObjIsoOfIso`" |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` | 1733 | No pin | Helper; less critical |
| `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` | 1749 | No pin (variant of L1508 pin) | Minor: `tensorObj_left_unitor`/`tensorObj_right_unitor` are pinned; `tensorObj_unit_iso` (unit⊗unit) is not, but it's a supporting helper |
| `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` | 1889 | No pin | Helper for `tensorObj_restrict_iso` |
| Various presheaf-level helpers (stalk, whisker, route-(e)) | Various | No pin | Documented as superseded-route; acceptable to be unpinned |

---

## Blueprint adequacy for this file

- **Coverage**: The chapter covers 26 of the ~40 Lean declarations via `\lean{...}` blocks. The 3 new iter-228 declarations (`dualPrecompEquiv`, presheaf `dualIsoOfIso`, scheme `dualIsoOfIso`) are not covered. Several older declarations also lack pins (`tensorObjIsoOfIso`, `restrictIsoUnitOfLE`), but these are less critical helpers.
- **Proof-sketch depth**: **adequate** for the existing pinned blocks. The `lem:dual_isLocallyTrivial` proof block contains a detailed (now-incorrect) verbatim-mirror sketch plus a corrective `% NOTE:` that accurately identifies the real blocker. The three new declarations are sufficiently described in their Lean docstrings but have NO blueprint coverage whatsoever.
- **Hint precision**: **loose** for the three missing pins — the blueprint does mention the need for "dual respects isos" ingredient informally in the `dual_isLocallyTrivial` proof sketch, but there is no formal `\lean{...}` pin. For all existing pins, hint precision is good.
- **Generality**: **matches need** for existing blocks. No parallel API written outside the blueprint's scope.

**Recommended chapter-side actions** (for the blueprint-writing agent):
1. Add a new `\begin{lemma}` block for `PresheafOfModules.dualPrecompEquiv` with `\lean{PresheafOfModules.dualPrecompEquiv}` pin. Prose: "Precomposition `R(U)`-linear equivalence on dual sections induced by a presheaf-of-modules isomorphism `e : M ≅ M'`; the section-level core of the presheaf dual's contravariant functoriality in isomorphisms."
2. Add a new `\begin{lemma}` block for `PresheafOfModules.dualIsoOfIso` with `\lean{PresheafOfModules.dualIsoOfIso}` pin. Prose: "An isomorphism `e : M ≅ M'` of presheaves of modules induces `dual M' ≅ dual M`, assembled sectionwise from `dualPrecompEquiv`." Mark with `\leanok`.
3. Add a new `\begin{lemma}` block for `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` with `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` pin. Prose: "An isomorphism `e : M ≅ M'` in `X.Modules` induces `dual M' ≅ dual M`, obtained by sheafifying `PresheafOfModules.dualIsoOfIso`." Mark with `\leanok`.
4. The `% NOTE:` on `lem:dual_isLocallyTrivial` is accurate and sufficient for this iter. The `\lean{...}` pin should be retained as a forward pointer; the proof block should remain unmarked until the slice-site equivalence lands.

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `PresheafOfModules.dualPrecompEquiv` (L1558): substantive axiom-clean declaration with no blueprint block or `\lean{...}` pin | **major** |
| 2 | `PresheafOfModules.dualIsoOfIso` (L1603): substantive axiom-clean declaration with no blueprint block or `\lean{...}` pin | **major** |
| 3 | `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (L1698): substantive axiom-clean declaration with no blueprint block or `\lean{...}` pin | **major** |
| 4 | `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (blueprint L2782): fake pin — declaration does not exist in the Lean file; `% NOTE:` present and accurate | **major** (documented; no `\leanok` claimed; NOTE explicitly names the real blocker) |
| 5 | `exists_tensorObj_inverse` `:= sorry` (pre-existing, acknowledged) | informational |
| 6 | `addCommGroup_via_tensorObj` `:= sorry` (pre-existing) | informational |
| 7 | Pre-existing fake pins for `tensorObjIsoclassCommMonoid`, `pullback_tensorObj_iso`, `homOfLocalCompat` | informational (pre-existing, not introduced this iter) |

**Overall verdict**: Three new axiom-clean declarations (`dualPrecompEquiv`, presheaf `dualIsoOfIso`, scheme `dualIsoOfIso`) were landed this iter without corresponding blueprint blocks — major gaps that the plan agent should close with new prose blocks and `\lean{...}` pins; the `dual_isLocallyTrivial` fake pin is accurately documented by the iter-228 `% NOTE:` and requires no immediate correction beyond the prose blocks for items 1–3. — 3 new decls checked (all new, all axiom-clean, all missing blueprint pins), 1 confirmed fake/placeholder pin, 0 must-fix-this-iter findings.
