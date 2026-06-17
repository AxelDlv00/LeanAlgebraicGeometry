# Lean ↔ Blueprint Check Report

## Slug
tos

## Iteration
241

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1212 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (4597 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`, blueprint ~L2827)

- **Lean target exists**: yes — `noncomputable def pullbackUnitIso` at Lean L1066
- **Signature matches**: yes — both blueprint and Lean state
  `(Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`
  for an arbitrary scheme morphism `f : Y ⟶ X`.
- **`\leanok` in blueprint statement block**: yes ✓
- **Proof follows sketch**: **NO — blueprint↔Lean prose mismatch (see below)**
- **Notes**:

  **The blueprint proof is factually wrong and now obsolete.** At blueprint L2861–2866 the proof states: *"For a general morphism `f` the comparison functor need not be `Final` globally, so the isomorphism is established by reduction to local charts."* This premise is **false**: `(TopologicalSpace.Opens.map f.base).Final` holds **unconditionally** for every scheme morphism `f` (the preimage functor on opens is a frame homomorphism, hence representably flat, so `final_of_representablyFlat` applies). Consequently the Mathlib instance `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` fires for ALL `f`, and `pullbackObjUnitToUnit f` is an iso on the nose without any chart-chase.

  **The actual Lean proof (L1066–1070) is a one-liner:**
  ```lean
  haveI : (TopologicalSpace.Opens.map f.base).Final := final_of_representablyFlat _
  pullbackObjUnitToUnitIso f
  ```
  **The blueprint describes a full affine chart-chase** (cover Y by affine charts, factor `V.ι ≫ f = g ≫ U.ι` with `g = f.resLE U V`, use `pullbackObjUnitToUnit_comp` to assemble a composite of three isomorphisms per chart, invoke `isIso_of_isIso_restrict` to globalize) that **is not carried out in the Lean proof at all**.

  **Stale `\uses` in the blueprint proof block** (blueprint L2844–2845):
  ```latex
  \uses{def:scheme_modules_tensorobj, lem:pullbackObjUnitToUnit_comp,
        lem:unitToPushforwardObjUnit_comp}
  ```
  `lem:pullbackObjUnitToUnit_comp` and `lem:unitToPushforwardObjUnit_comp` are cited as dependencies of the proof, but neither is consumed by the actual Lean proof of `pullbackUnitIso`. (Both ARE proven Lean lemmas, and they ARE consumed by other things like the anticipated Phase-2 `pullbackTensorIso` build, but NOT by `pullbackUnitIso`.)

  **Recommendation**: Simplify the blueprint proof to reflect the actual one-liner argument:
  > The preimage functor `Opens.map f.base` is a frame homomorphism (hence representably flat), so `final_of_representablyFlat` supplies `(Opens.map f.base).Final` unconditionally. The Mathlib instance `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` then directly delivers `IsIso (pullbackObjUnitToUnit f.toRingCatSheafHom)` for every `f`. No chart-chase or composition coherence is needed.

  Remove `lem:pullbackObjUnitToUnit_comp` and `lem:unitToPushforwardObjUnit_comp` from the proof block's `\uses{...}` (they remain correct as standalone blueprinted lemmas, just not dependencies of *this* proof).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:pullbackObjUnitToUnit_comp`, blueprint ~L2776)

- **Lean target exists**: yes — `lemma pullbackObjUnitToUnit_comp` at Lean L923
- **Signature matches**: yes — blueprint and Lean both express the composition coherence
  `pbu(h≫f) = (pullbackComp h f).inv.app 𝒪_X ≫ (pullback h).map (pbu f) ≫ pbu h`
- **`\leanok` in blueprint**: yes ✓
- **Proof follows sketch**: yes — adjunction-mate transport from pushforward-side coherence matches the Lean proof structure
- **Notes**: Correctly blueprinted. Not consumed by `pullbackUnitIso` (see above), but this lemma is the right scaffolding for the harder Phase-2 `pullbackTensorIso`.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (chapter: `lem:unitToPushforwardObjUnit_comp`, blueprint ~L2738)

- **Lean target exists**: yes — `lemma unitToPushforwardObjUnit_comp` at Lean L882
- **Signature matches**: yes
- **`\leanok` in blueprint**: yes ✓
- **Proof follows sketch**: yes — blueprint says "both sides are `rfl` after ext-chain" matches `apply SheafOfModules.Hom.ext; ... intro a; rfl` at Lean L888–894
- **Notes**: Correctly blueprinted and closed.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (chapter: `lem:pullback_tensor_iso`, blueprint ~L2622)

- **Lean target exists**: **no** — no `def pullbackTensorIso` anywhere in the Lean file. A `/- HANDOFF -/` comment block at L1120–1172 documents that Phase 2 is blocked and identifies the wall.
- **`\leanok` in blueprint statement block**: **absent** ✓ (correctly unformalized)
- **Signature matches**: N/A (declaration does not exist)
- **Proof follows sketch**: N/A
- **Notes**: The `\lean{...}` pin is aspirational — the intended future declaration name. No `\leanok` is correct. The Lean file explicitly documents that the sectionwise-`extendScalars` recipe is blocked (`(Scheme.Modules.pullback f)` is an abstract left adjoint with no sectionwise formula at the pinned Mathlib commit) and identifies the local-chart-finality pivot as the recommended next approach. This status is consistent with the blueprint state.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: `lem:isinvertible_pullback`, blueprint ~L2905)

- **Lean target exists**: **no** — no declaration `IsInvertible.pullback` in the Lean file.
- **`\leanok` in blueprint statement block**: **absent** ✓ (correctly unformalized)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Aspirational pin. No `\leanok` is correct. Phase 3 depends on Phase 2 (`lem:pullback_tensor_iso`), which is itself blocked; the absence of this declaration is expected.

---

## Red flags

### Placeholder / suspect bodies

- `exists_tensorObj_inverse` at Lean L715: body is `sorry`. This is **pre-known and authorized** — the directive confirms sorry count stayed 2→2 this iter. The blueprint has no `\leanok` for `lem:tensorobj_inverse_invertible` (the corresponding block). **Not a new finding.**
- `addCommGroup_via_tensorObj` at Lean L1205: body is `sorry`. **Pre-known and authorized** — the directive confirms this is one of the two persistent sorry residuals. **Not a new finding.**

### Excuse-comments

None in the new Phase-1 declarations (`isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom`, `pullbackUnitIso`). The HANDOFF comment block at L1120–1172 is analytical (it identifies a wall and a pivot), not an excuse-comment.

### Axioms / `Classical.choice` on non-trivial claims

None in the new Phase-1 declarations. `Classical.choice` is used in `picInv` at L816 to extract the membership witness of `IsInvertible`, which is the intended design (the inverse is existentially carried by `IsInvertible M`). This is blueprinted behavior, not a red flag.

---

## Unreferenced declarations (informational)

The following Lean declarations in this file have no `\lean{...}` reference in the blueprint chapter:

- **`isIso_pbu_of_final`** (private, L1041): isolates the `Final` TC witness for `pullbackObjUnitToUnitIso`; helper, correctly private and unbluepinted.
- **`pullbackObjUnitToUnitIso`** (L1049): bundled-Iso wrapper over `pullbackObjUnitToUnit` for a `Final` functor; helper for `pullbackUnitIso`; reasonable to leave unbluepinted or add as a minor `\lean{...}`-only note.
- **`pullbackObjUnitToUnitIso_hom`** (L1056): `@[simp]` reduction lemma for `pullbackObjUnitToUnitIso.hom`; helper.
- **`sheafifyTensorUnitIso`** (private, L1084): the "sheafification is monoidal up to the unit" reconciliation brick for Phase 2. Correctly private. Will need blueprinting once Phase 2 becomes the active target.
- **`restrictIsoUnitOfLE`** (L394): "refine trivialisation to a smaller open" helper. Not blueprinted as a standalone block (it is used inside `tensorObj_isLocallyTrivial`). Minor.

None of these suggest blueprint completeness failures — they are reasonable helper lemmas beneath the level of blueprint granularity.

---

## Blueprint adequacy for this file

- **Coverage**: All substantive Phase-1 declarations proven this iter have a corresponding `\lean{...}` block in the chapter. The 3 new bricks (`isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom`) are implementation helpers below blueprint granularity — acceptable. Phase-2 and Phase-3 declarations (`pullbackTensorIso`, `IsInvertible.pullback`) have `\lean{...}` pins without `\leanok`, which is the correct state.

- **Proof-sketch depth**: **Under-specified / factually wrong** for `lem:pullback_unit_iso`. The blueprint's proof sketch contains the false premise that `(Opens.map f.base).Final` does not hold generally, leading it to describe an elaborate chart-chase that the actual Lean proof bypasses entirely. A prover following the blueprint's proof sketch would not have arrived at the simple one-liner proof; they would have spent iterations on the chart-chase approach. The blueprint is thus an active misdirection here.

  All other proof sketches in the chapter that were verified this iter are adequate.

- **Hint precision**: **Precise** — the `\lean{...}` pins match the actual Lean declaration names exactly.

- **Generality**: **Matches need** — no parallel API drift detected.

- **Recommended chapter-side actions**:
  1. **[REQUIRED, major]** Rewrite the proof body of `lem:pullback_unit_iso` (blueprint L2843–2901) to: "The preimage functor `Opens.map f.base` is representably flat (frame homomorphism), so `final_of_representablyFlat` gives `(Opens.map f.base).Final` unconditionally. The Mathlib instance `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` then delivers `IsIso (pullbackObjUnitToUnit f.toRingCatSheafHom)` directly. No chart-chase is needed."
  2. **[REQUIRED, major]** Remove `lem:pullbackObjUnitToUnit_comp` and `lem:unitToPushforwardObjUnit_comp` from the proof block `\uses{...}` of `lem:pullback_unit_iso`. (Both lemmas remain correctly blueprinted; only their citation as proof dependencies of `lem:pullback_unit_iso` is wrong.)
  3. **[MINOR]** The inline note at blueprint L2861 ("For a general morphism f the comparison functor need not be Final globally") should be deleted or corrected: it is factually wrong and was the root cause of the chart-chase misdirection.
  4. **[MINOR]** Consider adding a brief `\lean{...}` note (below blueprint granularity) for `sheafifyTensorUnitIso` when Phase 2 opens as the active target — it is the RHS-reconciliation brick that `pullbackTensorIso` will consume.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:pullback_unit_iso` blueprint proof describes obsolete chart-chase, contains false factual claim that `Final` doesn't hold generally | **major** |
| Stale `\uses{...lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` in `lem:pullback_unit_iso` proof block | **major** |
| `lem:pullback_tensor_iso` has `\lean{...}` pin to non-existent decl (Phase 2 open) | informational (expected, no `\leanok`) |
| `lem:isinvertible_pullback` has `\lean{...}` pin to non-existent decl (Phase 3 open) | informational (expected, no `\leanok`) |
| 3 new Phase-1 helpers unreferenced by blueprint (`isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom`) | minor |
| `sheafifyTensorUnitIso` private brick unbluepinted | minor |
| `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` still sorry | pre-known, not new |

**No must-fix-this-iter findings.** The Lean declaration `pullbackUnitIso` is correct, axiom-clean, and its signature matches the blueprint statement exactly. The major findings are all blueprint-side prose that should be updated by a blueprint-writer pass: the proof description for `lem:pullback_unit_iso` is now factually wrong and over-engineered relative to the actual one-liner Lean proof.

**Overall verdict**: `pullbackUnitIso` landed correctly — statement pin resolves, `\leanok` is accurate, declaration is axiom-clean; the chapter's chart-chase proof for `lem:pullback_unit_iso` is now obsolete (contains a false premise) and should be simplified to reflect the one-liner proof; `pullbackTensorIso` and `IsInvertible.pullback` correctly carry open `\lean{...}` pins with no `\leanok`. 2 declarations checked (new this iter: pullbackUnitIso), 2 major blueprint-side prose flags (no Lean-side red flags).
