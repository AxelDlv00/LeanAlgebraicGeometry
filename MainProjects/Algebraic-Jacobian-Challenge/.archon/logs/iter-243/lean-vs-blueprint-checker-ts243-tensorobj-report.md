# Lean ↔ Blueprint Check Report

## Slug
ts243-tensorobj

## Iteration
243

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: `\lem:pullback_tensor_map`)

- **Lean target exists**: yes — L1220
- **Signature matches**: yes
  - Blueprint: `f : Y → X`, `M N : X.Modules` arbitrary, morphism (NOT iso)
    `(Scheme.Modules.pullback f).obj (M ⊗_X N) → tensorObj ((Scheme.Modules.pullback f).obj M) ((Scheme.Modules.pullback f).obj N)`
  - Lean:
    ```lean
    noncomputable def pullbackTensorMap {X Y : Scheme.{u}} (f : Y ⟶ X) (M N : X.Modules) :
        (Scheme.Modules.pullback f).obj (tensorObj M N) ⟶
          tensorObj ((Scheme.Modules.pullback f).obj M) ((Scheme.Modules.pullback f).obj N)
    ```
    Exact match: general `M N`, morphism only (no iso claim), fully general `f`.
- **Proof follows sketch**: yes
  - Blueprint says: use `sheafificationCompPullback`, apply oplax `δ`, reconcile RHS via `sheafifyTensorUnitIso`, then compose with `pullbackValIso` on the tensor factors.
  - Lean proof (4-step `refine` chain):
    1. `sheafificationCompPullback φ` app on `tensorObj M.val N.val` — Step 1 ✓
    2. `a_Y.map (Functor.OplaxMonoidal.δ ...)` — applies presheaf-level `δ` ✓
    3. `sheafifyTensorUnitIso` — right-hand-side tensor reconciliation ✓
    4. `a_Y.map (tensorHom (pullbackValIso f M) (pullbackValIso f N))` — bridges abstract sheaf pullback to substrate `tensorObj` via `pullbackValIso` ✓
  - Mathematical content exactly matches the blueprint's proof sketch.
- **No sorry**: body is sorry-free (verified by grep).
- **Blueprint `\leanok`**: present on this block — correctly set.
- **notes**: CLEAN. Pin name correct. Statement faithful. No weakening. 

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial}` (chapter: `\lem:isinvertible_implies_locallytrivial`)

- **Lean target exists**: no — declaration not present in the Lean file (grep confirms no `isLocallyTrivial` def/lemma under the `IsInvertible` namespace).
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A (absent)
- **Blueprint `\leanok`**: NOT present — correctly absent. Blueprint has a `% NOTE: iter-243 — confirmed Mathlib-scale, NOT formalized (no decl, no sorry pinned).` comment documenting the blocker.
- **notes**: PINNED-BUT-ABSENT (expected, not an error). The `\lean{...}` pin names the intended future declaration correctly. No sorry pinned; no placeholder inserted. Two Mathlib-scale blockers documented: (1) stalk-invertibility plumbing (~150 LOC absent), (2) finite-presentation spreading-out at SheafOfModules/scheme level. This is consistent with the prover's task result.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: `\lem:isinvertible_pullback`)

- **Lean target exists**: no — declaration not present (grep confirms no `IsInvertible.pullback` or nearby sorry-placeholder).
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A (absent)
- **Blueprint `\leanok`**: NOT present — correctly absent. No `% NOTE:` comment, but the dependency structure `\uses{..., lem:isinvertible_implies_locallytrivial, ...}` makes the block's gating on item 3 above clear.
- **notes**: PINNED-BUT-ABSENT (expected, not an error). Blocked on `lem:isinvertible_implies_locallytrivial`. Pin name `AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback` matches the intended decl name consistent with project namespace conventions. No placeholder sorry.

---

## Red flags

None for the new iter-243 declarations.

**Pre-existing sorries (not new this iter, informational only):**
- L715: `exists_tensorObj_inverse := sorry` — pre-existing, documented in file header.
- L1269: `addCommGroup_via_tensorObj := sorry` — pre-existing, iter-202 scaffold.

No axioms introduced anywhere in the file.
No placeholder/fake bodies in any new declaration.
No excuse-comments on new declarations.

---

## Unreferenced declarations (informational)

### `pullbackValIso` (L1203) — helper, unpinned

`pullbackValIso` is a helper constructing the canonical iso
`sheafify (presheaf-pullback M.val) ≅ (Scheme.Modules.pullback f).obj M`.
It is not `\lean{...}`-referenced from the blueprint, but is clearly an internal
bridge used only by `pullbackTensorMap`'s proof. Its docstring explains its role
precisely. This is an acceptable unreferenced helper; the name does not suggest it
should be a blueprint-level declaration.

---

## Blueprint adequacy for this file

### Coverage
- 3 new `\lean{...}` pins audited: 1 implemented (`pullbackTensorMap`), 2 pinned-but-absent (`IsInvertible.isLocallyTrivial`, `IsInvertible.pullback`). The absent ones are intentionally unformalized, properly `% NOTE:`-documented, and carry no `\leanok`.

### Proof-sketch depth
- **`lem:pullback_tensor_map`**: adequate — the four-step assembly (sheafificationCompPullback + δ + sheafifyTensorUnitIso + pullbackValIso reconciliation) is spelled out in the blueprint's proof body, and the Lean proof follows it step-for-step.
- **`lem:isinvertible_implies_locallytrivial`**: adequate for future formalization — the proof body cites specific Stacks lemmas (`lemma-invertible`, `lemma-invertible-is-locally-free-rank-1`, `lemma-finite-presentation-stalk-free`), explains the stalk-tensor step via `stalkTensorIso`, and the `% NOTE:` block identifies exactly which Mathlib-absent ingredients block formalization. A future prover would know precisely what to build.
- **`lem:isinvertible_pullback`**: adequate — the proof strategy (local trivialisation + `pullbackTensorMap` + `pullbackUnitIso` + `isiso_of_isiso_restrict`) is written out in full, with a chain-of-isomorphisms diagram and all `\uses{...}` dependencies listed.

### Hint precision
- Precise. All three `\lean{...}` pins name fully qualified identifiers consistent with the `AlgebraicGeometry.Scheme.Modules` namespace and project naming conventions.

### Generality
- Matches need. `pullbackTensorMap` is stated for arbitrary `M N` (not restricted to invertibles), as required by its downstream consumer `lem:isinvertible_pullback`.

### Recommended chapter-side actions
- None required this iter. The `% NOTE:` annotation on `lem:isinvertible_implies_locallytrivial` is already informative. The review agent may wish to add a symmetric `% NOTE:` to `lem:isinvertible_pullback` (e.g. "blocked on lem:isinvertible_implies_locallytrivial, iter-243") for symmetry, but this is optional (minor).

---

## Severity summary

No must-fix-this-iter findings. No major findings. One minor informational item:
- **minor** — `pullbackValIso` helper is unreferenced in the blueprint; a one-line `% (helper: pullbackValIso)` annotation in `lem:pullback_tensor_map`'s proof would improve traceability.

**Overall verdict**: CLEAN — 3 blueprint pins checked, 1 axiom-clean implemented declaration confirmed faithful (signature + proof match), 2 correctly absent pins with no sorry and proper `% NOTE:` documentation; no red flags.
