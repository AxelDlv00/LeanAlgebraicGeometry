# Lean ↔ Blueprint Check Report

## Slug
quot-iter031

## Iteration
031

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (iter-031 new declarations)

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictIso}` (chapter: `lem:over_restrict_iso`)

- **Lean target exists**: yes (line 980–982)
- **Signature matches**: yes

  Blueprint NOTE (line 3030) states verbatim:
  > `overRestrictIso : (overRestrictEquiv U).functor.obj (M.over U) ≅ (restrictFunctor U.ι).obj M`

  Lean type (line 980–982):
  ```lean
  noncomputable def overRestrictIso (M : X.Modules) :
      (overRestrictEquiv U).functor.obj (M.over U) ≅ (restrictFunctor U.ι).obj M :=
    (overRestrictFunctorIso U).app M
  ```
  Exact match — the statement IS routed through the step-3 equivalence functor as the blueprint anticipated.

- **Proof follows sketch**: yes

  The blueprint's 4-step proof sketch maps directly to the Lean implementation:
  - **Step 1** (topological layer — `overEquivalence_sheafCongr`): Implemented via the `OverSiteSheafEquivalence` section above (lines 776–882), which provides `overEquivalence_sheafCongr` used inside `overRestrictEquiv`.
  - **Step 2** (geometric ring-sheaf identification): Collapsed to `rfl` as the NOTE records. The `overRestrictEquiv` body passes `Sheaf.Hom.mk (𝟙 _)` for the second comparison morphism, confirming the definitional equality.
  - **Step 3** (lift to modules via `pushforwardPushforwardEquivalence`): Implemented as `overRestrictEquiv` (lines 930–955), which calls `SheafOfModules.pushforwardPushforwardEquivalence` explicitly.
  - **Step 4** (object-level): `overRestrictIso` is defined as `(overRestrictFunctorIso U).app M`, which is the object-level application of `overRestrictFunctorIso` (the functor identification of step 4). The blueprint explicitly says "the literal Lean statement is phrased through the step-3 equivalence functor" — exactly what the Lean does.

  The blueprint further says step 4 composes with `restrictFunctorIsoPullback` to land on the pullback form; in Lean this is the separate `overRestrictPullbackIso`, consistent with the blueprint's remark.

- **notes**: Axiom-clean per blueprint NOTE: `#print axioms = {propext, Classical.choice, Quot.sound}` (standard Lean 4 axioms only). Body is non-sorry.

---

### `AlgebraicGeometry.Scheme.Modules.overRestrictEquiv` (NO blueprint block)

- **Lean target exists**: yes (lines 929–955)
- **Signature matches**: N/A — no `\lean{}` pin to compare against
- **Proof follows sketch**: N/A — no blueprint block
- **notes**: Substantive declaration (the step-3 module-category equivalence `SheafOfModules (X.ringCatSheaf.over U) ≌ U.toScheme.Modules`). Body is a genuine `SheafOfModules.pushforwardPushforwardEquivalence` call with non-trivial coherence proofs (two `ext : 2` proofs, `erw`/`simp` reasoning). **Coverage debt.**

---

### `AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso` (NO blueprint block)

- **Lean target exists**: yes (lines 963–971)
- **Signature matches**: N/A — no `\lean{}` pin
- **Proof follows sketch**: N/A — no blueprint block
- **notes**: Substantive functor identification `(SheafOfModules.pushforward (𝟙 _)) ⋙ (overRestrictEquiv U).functor ≅ restrictFunctor U.ι`. Body is `pushforwardComp _ _ ≪≫ pushforwardCongr (by cat_disch)`. It is the functor-level form of `overRestrictIso`; `overRestrictIso` is just `.app M` of this. **Coverage debt.**

---

### `AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso` (NO blueprint block)

- **Lean target exists**: yes (lines 990–992)
- **Signature matches**: N/A — no `\lean{}` pin
- **Proof follows sketch**: N/A — no blueprint block
- **notes**: The pullback form of the bridge: `(overRestrictEquiv U).functor.obj (M.over U) ≅ (Scheme.Modules.pullback U.ι).obj M`. Body is `overRestrictIso U M ≪≫ (restrictFunctorIsoPullback U.ι).app M`. This is the form the downstream P1 presentation transport (`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`) consumes, and the blueprint's step-4 prose ("composed with `restrictFunctorIsoPullback` to land ... `U.ι^* M`") describes its content. **Coverage debt.**

---

## Red flags

*(None found for the iter-031 in-scope declarations.)*

### Placeholder / suspect bodies
None in the 4 new declarations. The 4 `sorry`-bodied declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) are pre-existing authorized stubs, all explicitly annotated with "iter-176 file-skeleton / iter-177+: the body …" docstrings — out of scope per directive.

### Excuse-comments
None. The five occurrences of "TODO" in the Lean file (lines 758, 763, 785, 814, 871) are all inside doc-comments describing the upstream Mathlib gap that the local code fills — not excuse-comments attached to code.

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations anywhere in the file. The blueprint NOTE confirms `overRestrictIso` is axiom-clean at `{propext, Classical.choice, Quot.sound}` (standard Lean 4 axioms, not extras).

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no corresponding `\lean{}` blueprint pin (excluding authorized stubs):

| Declaration | Assessment |
|---|---|
| `Scheme.Modules.overRestrictEquiv` | Substantive — step-3 equivalence; **should be pinned** (coverage debt, see above) |
| `Scheme.Modules.overRestrictFunctorIso` | Substantive — functor-level form of `overRestrictIso`; **should be pinned** (coverage debt) |
| `Scheme.Modules.overRestrictPullbackIso` | Substantive — pullback form; consumed by P1 transport; **should be pinned** (coverage debt) |
| `isIso_sheaf_of_isIso_app_basicOpen` (private) | Private helper for `isIso_fromTildeΓ_of_isLocalizedModule_restrict`; helper-only, acceptable |
| `bijective_comp_of_localizations` (private) | Private helper for `isIso_fromTildeΓ_of_isLocalizedModule_restrict`; helper-only, acceptable |

---

## Blueprint adequacy for this file

*(Scoped to the iter-031 work: the `OverRestrictBridge` section and the 4 new declarations.)*

- **Coverage**: 1/4 of the new declarations has a corresponding `\lean{}` block (`overRestrictIso` → `lem:over_restrict_iso`). The other 3 (`overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictPullbackIso`) are unreferenced in the chapter. Count: 1 pinned, 3 coverage-debt substantive declarations.

- **Proof-sketch depth**: **adequate** for `overRestrictIso`. The 4-step sketch in `lem:over_restrict_iso` (lines 3057–3100) is detailed enough to guide the formalization faithfully:
  - Step 1 is separately formalized in the preceding `OverSiteSheafEquivalence` section.
  - Step 2 (`rfl`) matches the Lean `(Sheaf.Hom.mk (𝟙 _))` witness.
  - Step 3 names `pushforwardPushforwardEquivalence` by name.
  - Step 4 explains why the statement is phrased via the step-3 functor (not the pullback form).
  
  The sketch does **not** preview the `overRestrictEquiv` or `overRestrictFunctorIso` implementations, but since the prover builds them bottom-up before `overRestrictIso`, and the prose gives the blueprint-level narrative correctly, this was not a blocker in practice.

- **Hint precision**: **precise** for `overRestrictIso`. The NOTE in the blueprint (lines 3025–3033) explicitly records the expected Lean signature down to the exact functor application, and the `\lean{}` pin names the correct namespace (`AlgebraicGeometry.Scheme.Modules.overRestrictIso`). The three coverage-debt declarations have no hints at all.

- **Generality**: **matches need** for `overRestrictIso`. The statement is fully general (arbitrary scheme `X`, arbitrary open `U`). The three coverage-debt declarations are also appropriately general.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add a `\begin{definition}` block for `overRestrictEquiv` with `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}`, describing it as the step-3 module-category equivalence `SheafOfModules (O_X.over U) ≌ U.toScheme.Modules`, and a proof sketch naming `SheafOfModules.pushforwardPushforwardEquivalence` and the two ring-sheaf comparison morphisms (unit of `overEquivalence` and `id`).
  2. Add a `\begin{lemma}` block for `overRestrictFunctorIso` with `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}`, noting it is the functor-level form: the composite `(SheafOfModules.pushforward (𝟙_)) ⋙ (overRestrictEquiv U).functor ≅ restrictFunctor U.ι`, proved via `pushforwardComp` and `pushforwardCongr`.
  3. Add a `\begin{lemma}` block for `overRestrictPullbackIso` with `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}`, noting it composes `overRestrictIso` with `restrictFunctorIsoPullback` to produce the pullback form `(overRestrictEquiv U).functor.obj (M.over U) ≅ (pullback U.ι).obj M` consumed by the P1 transport.

---

## Severity summary

- **must-fix-this-iter**: *none*. No placeholder bodies, no signature mismatches, no excuse-comments, no unauthorized axioms in the 4 iter-031 declarations. The 4 pre-existing sorried stubs are authorized and out of scope.

- **major** (3 findings):
  1. `overRestrictEquiv` lacks a `\lean{}` blueprint block. It is the step-3 equivalence — a substantive declaration the chapter's proof narrative describes but does not pin.
  2. `overRestrictFunctorIso` lacks a `\lean{}` blueprint block. It is the functor-level carrier of `overRestrictIso`.
  3. `overRestrictPullbackIso` lacks a `\lean{}` blueprint block. It is the pullback form consumed by the next open gap (P1 transport); its absence from the chapter creates a dead reference in the P1 proof.

- **minor**: *none*.

**Overall verdict**: `lem:over_restrict_iso` is correctly formalized, axiom-clean, and signature-matches the blueprint verbatim; the 4-step proof sketch was adequate to guide the formalization. Three substantive helper declarations (`overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictPullbackIso`) are missing `\lean{}` coverage in the chapter — major findings, non-blocking for this iter.
