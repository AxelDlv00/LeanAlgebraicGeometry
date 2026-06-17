# Lean ↔ Blueprint Check Report

## Slug
lvb-lbc257

## Iteration
257

## Files audited
- Lean: `AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- Blueprint: `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

---

## Per-declaration

### `\lean{IsLocallyTrivial.exists_trivializing_cover}` (chapter: `lem:lbc_trivializing_cover`)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover` at line 121
- **Signature matches**: yes — the existential `∃ (I : Type u) (U : I → X.Opens), (∀ i, IsAffineOpen (U i)) ∧ iSup U = ⊤ ∧ ∀ i, Nonempty (M.restrict (U i).ι ≅ SheafOfModules.unit (U i : Scheme).ringCatSheaf)` matches the blueprint prose exactly (index set I, affine opens U_i covering X, isomorphism M|_{U_i} ≅ struct(U_i))
- **Proof follows sketch**: yes — blueprint says "take I := X, U_x := chosen neighbourhood, cover because each x lies in U_x"; Lean does exactly this (refine ⟨X, fun x => ..., fun x => ..., ..., fun x => ...⟩ with iSup = ⊤ by TopologicalSpace.Opens.mem_iSup)
- **notes**: axiom-clean, fully closed ✓; `\leanok` on statement block is correct

### `\lean{IsLocallyTrivial.chartPresentation}` (chapter: `lem:lbc_chart_presentation`)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chartPresentation` at line 214
- **Signature matches**: yes — `(M : X.Modules) (U : X.Opens) (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) : (M.over U).Presentation` matches the intent (finite free presentation of M on a trivialising chart)
- **Proof follows sketch**: partial — the blueprint sketch says "transport the canonical presentation of unit (U_i).ringCatSheaf along the isomorphism e_i using Presentation.ofIsIso" but the actual Lean body first goes through `chartOverIso` (a typed `sorry`) to convert `e` from the restricted category to the slice category, then calls `ofIsIso`. The blueprint sketch **elides this categorical bridge entirely** — see the critical finding below.
- **notes**: SORRY-TRANSITIVE via `chartOverIso` (line 203-206 `:= sorry`); body itself is real code. Statement-level `\leanok` is consistent with "at least a sorry present"; absence of proof-level `\leanok` is correct.

### `\lean{IsLocallyTrivial.isFinitePresentation}` (chapter: `thm:lbc_isFinitePresentation`)
- **Lean target exists**: yes — line 236
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) : M.IsFinitePresentation` matches
- **Proof follows sketch**: yes — blueprint says "choose cover, assemble QuasicoherentData with `chartPresentation` at each index, feed to `IsFinitePresentation.mk`"; Lean does exactly this (obtain cover, build `q : M.QuasicoherentData`, shrink index, call `SheafOfModules.IsFinitePresentation.mk`)
- **notes**: sorry-transitive via `chartOverIso`; proof structure is faithful; statement-level `\leanok` correct; proof-level `\leanok` absent (correct, proof not fully closed)

### `\lean{IsLocallyTrivial.isFiniteType}` (chapter: `cor:lbc_isFiniteType`)
- **Lean target exists**: yes — line 264
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) : M.IsFiniteType` matches
- **Proof follows sketch**: yes — blueprint says "Finite presentation implies finite type by Mathlib's instance"; Lean does `haveI := hM.isFinitePresentation; infer_instance`
- **notes**: sorry-transitive via `chartOverIso`; statement-level `\leanok` correct

### `\lean{IsLocallyTrivial.chart_free_rank_one}` (chapter: `lem:lbc_rank_flat`)
- **Lean target exists**: yes — line 279
- **Signature matches**: yes — `{M : X.Modules} (hM : IsLocallyTrivial M) (x : X) : ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧ Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)`; matches blueprint ("a chart U ∋ x together with the trivialising iso M|_U ≅ struct(U)")
- **Proof follows sketch**: yes — blueprint says "Immediate from the trivialisation"; Lean body is `exact hM x` which literally unfolds the definition
- **notes**: axiom-clean, fully closed ✓; `\leanok` on statement block is correct

---

## Red flags

### Placeholder / suspect bodies

- **`chartOverIso`** at line 203–206: body is `:= sorry`. This declaration is NOT blueprint-pinned (`\lean{chartOverIso}` does not appear in the chapter). However, it is the unique transitive dependency of `chartPresentation`, `isFinitePresentation`, and `isFiniteType`, all three of which ARE blueprint-pinned and have `\leanok` on their statement blocks. The sorry is acknowledged and described in the module docstring as a Mathlib-scale wall (the over↔restrict modules-level equivalence, same as the dual lane). The blueprint's `lem:lbc_chart_presentation` proof sketch is incomplete: it says to use `e_i : M.restrict U.ι ≅ unit (U:Scheme).ringCatSheaf` directly with `Presentation.ofIsIso`, but `e_i` lives in `SheafOfModules (U:Scheme).ringCatSheaf` while `ofIsIso` must work in `SheafOfModules (X.ringCatSheaf.over U)` — the two are different categories, and bridging them requires precisely `chartOverIso`.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` pin in the chapter:

| Declaration | Line | Status | Note |
|---|---|---|---|
| `freeUnitIso` | 147 | axiom-clean | Helper for `unitPresentation`; the blueprint mentions "canonical free presentation" informally but doesn't pin this |
| `unitGenerators` | 153 | axiom-clean | Implementation detail of `unitPresentation`; acceptable as helper |
| `unitPresentation` | 163 | axiom-clean | The chapter's proof sketch for `lem:lbc_chart_presentation` refers to "the canonical unit-presentation" but does not pin this; could be promoted |
| `unitPresentation.IsFinite` instance | 178 | axiom-clean | Instance, acceptable as helper |
| **`chartOverIso`** | 203 | `:= sorry` | **Critical un-blueprinted helper** — see Red flags and Blueprint adequacy below |
| `chartPresentation.IsFinite` instance | 221 | axiom-clean (body; sorry-transitive) | Instance |

Of these, `chartOverIso` is the only one that should concern the plan agent: it is sorry-carrying, on the critical path of three pinned theorems, and the blueprint does not describe it.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean theorem/lemma declarations have a corresponding `\lean{...}` block. Unreferenced declarations: 6 helpers (listed above); of these, `chartOverIso` is substantive and warrants blueprint treatment (flagged below as must-fix).

- **Proof-sketch depth**: **under-specified** for `lem:lbc_chart_presentation`. The sketch says:

  > "The chart presentation is obtained by transporting the canonical finite presentation of unit (U_i).ringCatSheaf along the isomorphism e_i, using SheafOfModules.Presentation.ofIsIso."

  This is **categorically wrong as a guide**: the isomorphism `e_i : M.restrict U.ι ≅ unit (U:Scheme).ringCatSheaf` lives in `SheafOfModules (U:Scheme).ringCatSheaf`, but `Presentation.ofIsIso` must work in `SheafOfModules (X.ringCatSheaf.over U)` (the slice category). These are different categories (`restrict` vs `over`); bridging them requires the over↔restrict equivalence (`chartOverIso`), which is precisely the un-blueprinted sorry. A prover following the sketch verbatim would hit an immediate type mismatch with no guidance on resolution.

  The remaining sketches (`lem:lbc_trivializing_cover`, `thm:lbc_isFinitePresentation`, `cor:lbc_isFiniteType`, `lem:lbc_rank_flat`) are adequate.

- **Hint precision**: precise — all five `\lean{...}` names match the actual declarations with correct namespacing.

- **Generality**: matches need — no parallel API was needed beyond the un-blueprinted `chartOverIso` bridge.

- **Recommended chapter-side actions**:

  1. **Must-do**: Add a new blueprint block (or expand the `lem:lbc_chart_presentation` proof sketch) to describe the over↔restrict bridge `chartOverIso`. The block should:
     - State what `chartOverIso` does: given `e : M.restrict U.ι ≅ unit (U:Scheme).ringCatSheaf`, produce `M.over U ≅ unit (X.ringCatSheaf.over U)`, bridging the open-subscheme category and the slice category.
     - Note that the two categories are equivalent via `Opens.overEquivalence U` and the modules-level shadow of `overSliceSheafEquiv`, but this equivalence is not yet in Mathlib — so the block is currently a sorry and should be marked accordingly (NOT `\leanok` on proof; consider a `% NOTE:` annotation).
     - Either add a `\lean{AlgebraicGeometry.Scheme.LineBundle.chartOverIso}` pin (the declaration exists in the Lean file) or describe the bridge inline in the `lem:lbc_chart_presentation` proof with a `% NOTE: the over↔restrict bridge chartOverIso is sorry here; see informal/chartOverIso.md`.
  2. Optionally pin `unitPresentation` (`\lean{AlgebraicGeometry.Scheme.LineBundle.unitPresentation}`) since the proof sketch for `lem:lbc_chart_presentation` references it by name.

---

## Severity summary

| Finding | Severity | Location |
|---|---|---|
| Blueprint `lem:lbc_chart_presentation` proof sketch elides the over↔restrict categorical bridge (`chartOverIso`), misleading any prover following only the chapter | **must-fix-this-iter** | `Picard_LineBundleCoherence.tex`, proof of `lem:lbc_chart_presentation` |
| `chartOverIso` at Lean line 203 has `:= sorry`, is critical path for 3 pinned theorems, and has no blueprint pin; the blueprint chapter gives no indication this step exists or is unresolved | **must-fix-this-iter** | `LineBundleCoherence.lean:203`, `Picard_LineBundleCoherence.tex` |
| `freeUnitIso`, `unitGenerators`, `unitPresentation` are un-blueprinted but axiom-clean helpers; `unitPresentation` is referenced by name in the blueprint sketch without a pin | **minor** | `LineBundleCoherence.lean:147–182` |

**Overall verdict**: The five blueprint-pinned declarations are correctly named, faithfully signed, and proof-sketch-faithful (modulo the known Mathlib-scale `chartOverIso` sorry), but the chapter has a must-fix blueprint adequacy failure: the proof sketch for `lem:lbc_chart_presentation` elides the over↔restrict categorical bridge (`chartOverIso`) that is the sole remaining blocker and leaves the prover with a type mismatch and no guidance. The blueprint should add an explicit note or new declaration block for `chartOverIso`. — 5 declarations checked, 2 red flags (both from the same `chartOverIso` gap).
