# Lean ↔ Blueprint Check Report

## Slug
lbc258

## Iteration
258

## Files audited
- Lean: `AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- Blueprint: `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover}` (chapter: `lem:lbc_trivializing_cover`)

- **Lean target exists**: yes — line 130
- **Signature matches**: yes
  - Blueprint: index set `I`, family of affine opens covering `X`, for each `i` an isomorphism `M|_{U_i} ≅ O_{U_i}`.
  - Lean: `∃ (I : Type u) (U : I → X.Opens), (∀ i, IsAffineOpen (U i)) ∧ iSup U = ⊤ ∧ ∀ i, Nonempty (M.restrict (U i).ι ≅ SheafOfModules.unit (U i : Scheme).ringCatSheaf)`. The `Nonempty` wrapper on the iso is the standard non-constructive formulation; the blueprint does not specify choice vs non-choice, so this is fine.
- **Proof follows sketch**: yes — proof uses `I := X`, assigns each point its `(hM x).choose` neighbourhood, checks coverage by `mem_iSup`. Matches the blueprint sketch exactly.
- **Blueprint markers**: `\leanok` on both statement and proof blocks. ✓

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chartPresentation}` (chapter: `lem:lbc_chart_presentation`)

- **Lean target exists**: yes — line 228
- **Signature matches**: yes
  - Blueprint: on each trivialising chart `U`, `M|_U` admits a finite free presentation.
  - Lean: `noncomputable def IsLocallyTrivial.chartPresentation (M : X.Modules) (U : X.Opens) (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) : (M.over U).Presentation`. The signature takes the iso `e` as an explicit argument, which matches the blueprint's "transporting along the trivialisation `e_i`".
- **Proof follows sketch**: yes — `Presentation.ofIsIso (chartOverIso M U e).inv (unitPresentation ...)` matches "transport the canonical finite presentation along the iso via `Presentation.ofIsIso`". The local `chartOverIso` is now a redirect to `Scheme.Modules.chartOverIso`, carrying no sorry.
- **Blueprint markers**: `\leanok` on both statement and proof blocks. ✓
- **Notes**: The proof block contains a stale `% NOTE (review iter-257):` comment — see Red Flags below.

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFinitePresentation}` (chapter: `thm:lbc_isFinitePresentation`)

- **Lean target exists**: yes — line 250
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) : M.IsFinitePresentation`. Matches blueprint exactly.
- **Proof follows sketch**: yes — obtains trivialising cover, assembles `QuasicoherentData`, `shrink`s the index, applies `IsFinitePresentation.mk`. Blueprint proof sketch describes each step.
- **Blueprint markers**: `\leanok` on both statement and proof blocks. ✓

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFiniteType}` (chapter: `cor:lbc_isFiniteType`)

- **Lean target exists**: yes — line 278
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) : M.IsFiniteType`. Matches blueprint.
- **Proof follows sketch**: yes — one-liner via `haveI := hM.isFinitePresentation; infer_instance`, matching the "immediate from finite presentation" sketch.
- **Blueprint markers**: `\leanok` on both statement and proof blocks. ✓

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chart_free_rank_one}` (chapter: `lem:lbc_rank_flat`)

- **Lean target exists**: yes — line 293
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) (x : X) : ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧ Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)`. Blueprint says "at each point x, a chart U ∋ x together with the trivialising iso M|_U ≅ O_U"; Lean wraps the iso in `Nonempty`, consistent with `exists_trivializing_cover`.
- **Proof follows sketch**: yes — body is `exact hM x`, which is exactly "immediate from the trivialisation".
- **Blueprint markers**: `\leanok` on both statement and proof blocks. ✓

---

## Red flags

### Stale blueprint comment claiming a local sorry

**`lem:lbc_chart_presentation` proof block (blueprint lines 207–217):**

```tex
% NOTE (review iter-257): this sketch elides the over<->restrict CATEGORICAL
% BRIDGE. The given e_i lives in SheafOfModules (U_i:Scheme).ringCatSheaf
% (open-subscheme site), whereas Presentation.ofIsIso must act in
% SheafOfModules (X.ringCatSheaf.over U_i) (slice site J.over U_i) -- DIFFERENT
% categories. The Lean bridges them through an iso `chartOverIso`
% (M.over U ≅ unit (X.ringCatSheaf.over U)), which is the SOLE remaining
% sorry of this file ...
% Blueprint-writer must add a block for the bridge; see informal/chartOverIso.md
% and task_results/lean-vs-blueprint-checker-lvb-lbc257.md.
```

**Why this is stale (iter-258):** The local `chartOverIso` is no longer a `sorry`. It has been redirected to the shared-root `Scheme.Modules.chartOverIso` in `AlgebraicJacobian/Picard/SheafOverEquivalence.lean` (the iter-258 shared-root pivot). The file is now locally sorry-free. Two claims in the NOTE are now false:
1. `"the SOLE remaining sorry of this file"` — the file has **zero** local sorries.
2. `"Blueprint-writer must add a block for the bridge"` — the bridge is the iter-258 shared-root construction; this file delegates to it. No blueprint block for `chartOverIso` is needed in this chapter (it belongs to the `SheafOverEquivalence` chapter).

**Severity: major.** The `\leanok` markers on statement and proof are correctly set; the automated sync reflects the true state. The stale NOTE does not prevent downstream work. However, leaving it in place could mislead a future reader of the `.tex` source into thinking a sorry still exists, or prompt an unnecessary blueprint-writing dispatch.

**Recommended fix:** Replace the `% NOTE (review iter-257):` block with a brief updated comment, e.g.:
```tex
% NOTE (updated iter-258): The over<->restrict categorical bridge is now handled
% by the shared-root `Scheme.Modules.chartOverIso` in
% `AlgebraicJacobian.Picard.SheafOverEquivalence`; the local `chartOverIso` def
% in this file is a redirect to that construction and carries no sorry.
% No blueprint block for the bridge is needed in this chapter.
```

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Type | Assessment |
|---|---|---|
| `freeUnitIso` (line 156) | noncomputable def | Infrastructure helper for `unitPresentation`; not a pinned declaration. Acceptable. |
| `unitGenerators` (line 162) | noncomputable def | Infrastructure helper for `unitPresentation`; acceptable. |
| `unitPresentation` (line 172) | noncomputable def | Canonical finite presentation of `unit R`; consumed by `chartPresentation`. A blueprint block would be nice but it's strictly a helper. |
| `(unitPresentation).IsFinite` instance (line 187) | instance | Instance confirming `unitPresentation` is finite. Helper, acceptable. |
| `chartOverIso` (line 217) | noncomputable def | Local redirect to `Scheme.Modules.chartOverIso`. Not a pinned declaration (the target lives in `SheafOverEquivalence`). Acceptable; the Lean docstring explains the iter-258 redirect. |
| `(IsLocallyTrivial.chartPresentation).IsFinite` instance (line 235) | instance | Instance propagating finiteness through the iso. Helper, acceptable. |

None of these are missing blueprint blocks that indicate a gap. The three `unit*` helpers are internal scaffolding for `chartPresentation`.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 pinned declarations have a corresponding `\lean{...}` block. All 6 unreferenced declarations are helpers; none require dedicated blueprint blocks.
- **Proof-sketch depth**: adequate. Each proof block describes the mathematical steps at a level the formalizer can follow. The `chartPresentation` sketch correctly says "transport via `Presentation.ofIsIso`"; the categorical bridge (`chartOverIso`) is handled by delegation to the shared root.
- **Hint precision**: precise. All five `\lean{...}` hints name the correct fully-qualified Lean identifiers and match their informal statements.
- **Generality**: matches need. The chapter addresses the exact level of generality the Lean code formalizes.
- **Recommended chapter-side actions**:
  - **[major]** Update the stale `% NOTE (review iter-257):` comment in the `lem:lbc_chart_presentation` proof block. Replace it with a short note reflecting the iter-258 state: `chartOverIso` is now a redirect to the shared-root construction in `SheafOverEquivalence`, and the file is locally sorry-free. No new `\lean{...}` block is needed in this chapter.

---

## Severity summary

| Finding | Location | Severity |
|---|---|---|
| Stale `% NOTE` in `lem:lbc_chart_presentation` proof claims "SOLE remaining sorry" and "blueprint-writer must add block for bridge" — both false as of iter-258 | `Picard_LineBundleCoherence.tex`, proof of `lem:lbc_chart_presentation` | **major** |

No must-fix-this-iter findings. The five pinned declarations all exist, have correct signatures, follow their blueprint proof sketches, carry no sorries, and are properly annotated with `\leanok`. The sole issue is a stale commentary note in one proof block.

**Overall verdict**: The Lean file and blueprint are aligned on all 5 pinned declarations; the only action needed is a minor blueprint maintenance edit to remove the now-false claim that `chartOverIso` is a local sorry.
