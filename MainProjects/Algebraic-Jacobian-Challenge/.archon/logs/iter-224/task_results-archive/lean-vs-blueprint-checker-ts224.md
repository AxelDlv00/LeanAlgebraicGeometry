# Lean ↔ Blueprint Check Report

## Slug
ts224

## Iteration
224

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.internalHomEval}` (chapter: `lem:internal_hom_eval`)

- **Lean target exists**: yes — `noncomputable def internalHomEval` at line 1457
- **Signature matches**: yes
  - Blueprint: "ev_M : M ⊗_R M^∨ → R, s ⊗ φ ↦ φ(s)"
  - Lean: `PresheafOfModules.Monoidal.tensorObj M (dual M) ⟶ 𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))`
  - `dual M` = `InternalHom.internalHom M (𝟙_)` = M^∨ ✓; `𝟙_` = the structure presheaf as a module = R in the blueprint ✓; simple-tensor action `s ⊗ φ ↦ φ(s)` confirmed by `internalHomEvalApp_tmul : ... (s ⊗ₜ φ) = evalLin M X φ s` (`:= rfl`) ✓
- **Proof follows sketch**: yes (mathematical content matches), with additional technical depth not captured in the blueprint
  - Blueprint sketch: "For V ⊆ U: evaluating then restricting equals restricting both arguments then evaluating (φ(s)|_V = (φ|_V)(s|_V)); hence the open-by-open contractions are natural."
  - Lean proof: six-step argument using `ModuleCat.MonoidalCategory.tensor_ext`, `erw [ModuleCat.hom_comp, ...]`, `internalHomEvalApp_tmul`, `PresheafOfModules.naturality_apply`, `restr_map_homMk` (the definitional identity for `Over.homMk f.unop`), and `hom_app_heq`+`eq_of_heq` (for the `Over.map` pseudofunctoriality coherence `Over.mk (𝟙 Y.unop ≫ f.unop) = Over.mk f.unop`).
  - The key "restrict-then-evaluate = evaluate-then-restrict" step maps to the `naturality_apply` step (step 4) and the `hdt` identification (step 5); the mathematical heart matches. The `Over`-category machinery and `Category.id_comp` coherence are Lean bookkeeping not previewed in the blueprint.
- **Proof body is sorry-free**: yes — no `sorry` in the body; axioms are `{propext, Classical.choice, Quot.sound}` per the docstring (standard Lean foundations)
- **notes**: The declaration is correctly the `PresheafOfModules`-namespaced one (inside `namespace PresheafOfModules`, `section Dual` → after `end InternalHom`). The proof body comments are accurate documentation of the iter-224 fix, not excuses.

### `\lean{PresheafOfModules.dual}` (chapter: `def:presheaf_dual`)

- **Lean target exists**: yes — `noncomputable def dual` at line 1356, inside `namespace PresheafOfModules` → `section Dual` (after `end InternalHom` at line 1334), so fully-qualified name is `PresheafOfModules.dual` ✓
- **Signature matches**: yes — `(M : PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)) : PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)` matches blueprint "the internal hom into the monoidal unit: M^∨(U) = (M|_U → R|_U)"
- **Proof follows sketch**: N/A (definition; body is `InternalHom.internalHom M (𝟙_ ...)`)
- **notes**: `\leanok` is present on the statement block in the blueprint. ✓

### `\lean{PresheafOfModules.InternalHom.restrictionMap}` (chapter: `lem:presheaf_internal_hom_restriction`)

- **Lean target exists**: yes — `noncomputable def restrictionMap` at line 1146, inside `namespace PresheafOfModules` → `namespace InternalHom` (opened at line 1005, closed at line 1280), fully-qualified name `PresheafOfModules.InternalHom.restrictionMap` ✓
- **Signature matches**: yes — `{U V : C} (g : V ⟶ U) (φ : restr U M ⟶ restr U N) : restr V M ⟶ restr V N` matches "further-restriction map φ ↦ φ|_V"
- **Proof follows sketch**: N/A (definition by pullback along `Over.map`)
- **notes**: `\leanok` is present on the statement block in the blueprint. ✓

---

## Red flags

### Placeholder / suspect bodies

No `sorry` in `internalHomEval` or any of the three pin-targeted declarations. The three remaining `sorry`s in the file (lines 641, 1935, 1981) are:
- `isLocallyInjective_whiskerLeft_of_W` (line 641): route-(e) residual, heavily documented as blocked on d.1-bridge + d.2 Mathlib gaps; blueprint does not claim proof completion for this block.
- `exists_tensorObj_inverse` (line 1935): blocked at step 1 on missing sheaf-level dual/evaluation infrastructure; blueprint `lem:tensorobj_inverse_invertible` does not claim proof completion.
- `addCommGroup_via_tensorObj` (line 1981): iter-202 scaffold `sorry`; blueprint `thm:rel_pic_addcommgroup_via_tensorobj` does not claim completion.

None of these three are claimed complete in the blueprint. **No must-fix plaseholder issue.**

### Excuse-comments

None found on the three pinned declarations. The iter-224 comments in `internalHomEval`'s proof body are accurate historical notes (the stale bomb diagnosis was documented and correctly described as stale), not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims

None unauthorized. The docstring cites `{propext, Classical.choice, Quot.sound}` — standard Lean 4 foundations, consistent with the project's axiom baseline.

---

## Blueprint adequacy for this file

### Note staleness (per directive, **major**)

The `% NOTE:` block at lines 2614–2620 of the blueprint chapter is **stale**:

```tex
% NOTE: The per-open building block is already built as the declaration
% \texttt{PresheafOfModules.internalHomEvalApp}: the \(R(U)\)-bilinear contraction
% \((M|_U) \otimes_{R(U)} (M|_U \to R|_U) \to R(U)\), \(s \otimes \varphi \mapsto
% \varphi(s)\), together with its supporting linearity lemmas. The remaining
% obligation for the full morphism \texttt{internalHomEval} is exactly the
% naturality/assembly step over the restriction maps; \texttt{internalHomEval} is
% the correct future target name.
```

Written when only `internalHomEvalApp` existed and `internalHomEval`'s naturality was an open obligation, this NOTE's two claims are now incorrect:
- "The remaining obligation ... is exactly the naturality/assembly step" — **this obligation is discharged** (iter-224, axiom-clean).
- "`internalHomEval` is the correct future target name" — `internalHomEval` **is** the present declaration; the "future" qualifier is wrong.

**Recommended action for the review agent**: remove or replace the NOTE with a brief update, e.g.:
```tex
% NOTE (iter-224): internalHomEval is CLOSED axiom-clean. The full morphism
% assembles internalHomEvalApp sectionwise; naturality follows from the
% evaluate/restrict commutation argument in the proof body.
```

### Missing `\leanok` on the proof block of `lem:internal_hom_eval` (**major**)

The statement block of `lem:internal_hom_eval` (line 2610) carries `\leanok` ✓. However, the proof block (lines 2651–2673) does **not** carry `\leanok`. Per the blueprint marker vocabulary:
- `\leanok` in a proof block means the proof is closed with no sorry.

Since `internalHomEval`'s proof is now axiom-clean (iter-224), the proof block should carry `\leanok`. `sync_leanok` is the authoritative phase responsible for this; the absence suggests `sync_leanok` either did not process the proof block or has a gap at this declaration. The review agent should flag this to the infrastructure; the marker itself is managed by `sync_leanok`, not by the review agent.

### Coverage

- 3/3 `\lean{...}`-pinned declarations exist with correct names and signatures.
- Unreferenced declarations (helpers, not substantive enough to blueprint): `evalLin`, `evalLin_add`, `evalLin_smul`, `termRingMap_terminal`, `internalHomEvalApp`, `internalHomEvalApp_tmul`, `restr_map_homMk` (private). All are supporting helpers for `internalHomEval`; their absence from the blueprint is acceptable.

### Proof-sketch depth: **under-specified** (minor)

The blueprint proof sketch (lines 2651–2673) correctly identifies the mathematical key ("evaluating then restricting = restricting both arguments then evaluating") but does not preview:
- The `Over` category machinery (`Over.homMk`, `Over.mk (𝟙 Y.unop ≫ f.unop) = Over.mk f.unop`)
- The `hom_app_heq` + `eq_of_heq` trick for `Over.map` pseudofunctoriality coherence
- The `evalLin` helper (how the dual section's terminal value is unwrapped)
- The `termRingMap_terminal` fact (that the terminal ring self-map is identity)
- The need for `erw` rather than `rw` at the composition split step

A prover familiar with the `Over`-category dual construction could navigate from the blueprint sketch, but the gap between sketch and actual proof is significant enough that it required several non-trivial iter-specific insights (documented in iter-222/223/224 MEMORY). The blueprint is adequate at the mathematical level but under-specified for Lean implementation. **No must-fix** (the formalization is correct); recommended action: expand the proof sketch to mention the `Over`-category step.

### Hint precision: **precise**

All three checked `\lean{...}` pins name correct, fully-qualified declarations that exist in the Lean file.

### Generality: **matches need**

`internalHomEval` is defined for all `PresheafOfModules` over a `CommRingCat`-valued presheaf, matching the blueprint's stated generality.

### Recommended chapter-side actions

1. **(major)** Remove or update the stale `% NOTE:` at lines 2614–2620 (obligation discharged; "future target name" language obsolete). Review agent action.
2. **(major)** Follow up with the `sync_leanok` infrastructure: the proof block of `lem:internal_hom_eval` should receive `\leanok` since the proof is now axiom-clean. If `sync_leanok` is responsible and didn't set it, this is a tooling discrepancy.
3. **(minor)** Consider expanding the proof sketch of `lem:internal_hom_eval` to mention the `Over`-category coherence step and the `evalLin` unwrapping, so future provers can follow the blueprint more directly.

---

## Severity summary

- **must-fix-this-iter**: none
- **major**:
  1. Stale `% NOTE:` at blueprint lines 2614–2620 (obligation is discharged; "future target" language is wrong). Should be updated/removed by the review agent.
  2. Missing `\leanok` on the proof block of `lem:internal_hom_eval` (proof is now axiom-clean; `sync_leanok` should have set it; absence is an infrastructure discrepancy).
- **minor**:
  1. Blueprint proof sketch is under-specified relative to the Lean proof's `Over`-category mechanics (did not prevent correct formalization, but is inadequate as a standalone guide for future provers).

**Overall verdict**: `internalHomEval` is correctly closed axiom-clean with a faithful signature and mathematically correct naturality proof; no must-fix issues on the Lean side. Two major blueprint-state items require attention (stale NOTE, missing proof-block `\leanok`). — 3 declarations checked, 0 red flags on Lean side, 2 major blueprint-state discrepancies.
