# Lean ↔ Blueprint Check Report

## Slug
ts-iter203

## Iteration
203

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.tensorObj` at line 113.
- **Signature matches**: yes.
  LSP type: `{X : Scheme} (M N : X.Modules) : X.Modules`.
  Blueprint: "M, N ∈ Scheme.Modules X → M ⊗_X N ∈ Scheme.Modules X." Exact agreement.
- **Proof follows sketch**: yes.
  Blueprint: "underlying presheaf of M ⊗ N is `PresheafOfModules.Monoidal.tensorObj` of the
  underlying presheaves of M and N, composed with the sheafification functor on the small
  Zariski site of X."
  Lean body:
  ```lean
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)
  ```
  Precisely the composition described: `sheafification.obj (presheafTensorObj M.val N.val)`.
- **Axiom check**: clean — `{propext, Classical.choice, Quot.sound}`, no `sorryAx`.
- **Blueprint `\leanok`**: definition block has `\leanok` (blueprint line 176). Body is
  substantive. Marker is correct.
- **notes**: The docstring still reads "iter-202 Lane TS scaffold: the body is a typed `sorry`" —
  stale (body is now substantive). This is a minor documentation lag, not a code issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` at line 129.
- **Signature matches**: yes.
  LSP type: `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : M.tensorObj N ⟶ M'.tensorObj N'`
  (dot-notation unfolding of `tensorObj M N ⟶ tensorObj M' N'`).
  Blueprint: "a pair of morphisms f : M → M' and g : N → N' determines a morphism
  f ⊗ g : tensorObj M N → tensorObj M' N'." Exact agreement.
- **Proof follows sketch**: yes.
  Blueprint: "all four pieces of natural-isomorphism data (λ, ρ, α, β) are inherited verbatim
  from the corresponding data on `PresheafOfModules.Monoidal.tensorObj` under sheafification."
  Lean body:
  ```lean
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
    (MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) f.val g.val)
  ```
  Applies the sheafification functor's `.map` to `tensorHom f.val g.val` on the presheaf level —
  i.e., lifts the presheaf-level morphism data under sheafification, exactly as the blueprint
  prescribes.
- **Axiom check**: clean — `{propext, Classical.choice, Quot.sound}`, no `sorryAx`.
- **Blueprint `\leanok`**: statement block (blueprint line 214) and proof block (blueprint
  line 254) both carry `\leanok`. Body is substantive. Both markers are correct.
- **notes**: Same stale-docstring issue as `tensorObj`: "iter-202 Lane TS scaffold: the body is
  a typed `sorry`" is no longer accurate. Minor documentation lag.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` (chapter: `thm:scheme_modules_monoidal`)

- **Lean target exists**: yes — `noncomputable instance monoidalCategory` at line 150.
- **Signature matches**: yes.
  LSP type: `{X : Scheme} : MonoidalCategory X.Modules`.
  Blueprint: "Scheme.Modules X carries a canonical symmetric MonoidalCategory structure." Agrees.
- **Proof follows sketch**: N/A — body is `:= sorry` (intentional contamination guard per directive).
  LSP diagnostic: `warning: declaration uses 'sorry'` at line 150.
- **Blueprint `\leanok`** on statement block (blueprint line 274): correct — sorry body present,
  marker semantics satisfied ("at least a sorry present").
- **Blueprint `\leanok`** on proof block (blueprint line 291): **INCORRECT**. The proof block
  `\leanok` semantics require "proof closed, no sorry" (per CLAUDE.md). The Lean instance body
  is `:= sorry`; the proof is NOT closed. The marker misrepresents the proof status.
  This is the primary finding of this report (see Red Flags below).
- **notes**: The sorry is intentional per the directive (contamination guard); the Lean code
  itself is not defective. The defect is the erroneous proof-block `\leanok` in the blueprint.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)

- **Lean target exists**: yes — `noncomputable def addCommGroup_via_tensorObj` at line 221,
  in namespace `AlgebraicGeometry.Scheme.PicSharp`.
- **Signature matches**: yes.
  LSP type: `{S C T : Scheme} (πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`.
  Blueprint: "carries a canonical AddCommGroup structure … on Quotient (RelPicPresheaf.preimage_subgroup πC πT)." Exact agreement.
- **Proof follows sketch**: N/A — body is `:= sorry` (intentional per directive; iter-204+ target).
- **Blueprint `\leanok`** on statement block (blueprint line 461): correct — sorry body present.
- **Blueprint `\leanok`** on proof block: the malformed `\uses{\leanok lem:tensorobj_lift_onproduct}` at blueprint lines 521–522 places the `\leanok` token INSIDE the `\uses{}` argument, not as a standalone proof-block marker. Consequently no proof-block `\leanok` is actually present. Since the body is `:= sorry`, absence of a proof-block `\leanok` is correct. The malformed `\uses` is the known structural defect already on the fix-list; confirmed here.
- **notes**: The `def` (not `instance`) choice is explained in the docstring (avoids diamond
  with existing `PicSharp.addCommGroup` in `RelPicFunctor.lean`). This is consistent with the
  blueprint prose and is correct design.

---

## Red flags

### Blueprint marker inconsistency

- **`thm:scheme_modules_monoidal` proof block, blueprint line 291**: `\leanok` appears inside
  `\begin{proof}...\end{proof}` for the `monoidalCategory` instance. Per project conventions
  (CLAUDE.md), a proof-block `\leanok` asserts "proof closed, no sorry." But the Lean instance
  body is `:= sorry` (LSP diagnostic confirms; `sorryAx` is NOT in the axiom set of the
  definition itself — wait, no: the axiom check for `monoidalCategory` was not run because the
  `lean_verify` tool call for it was not issued; the sorry warning from LSP at line 150 is
  definitive). This `\leanok` is incorrect and should be removed from the proof block.
  **Classification: major.** (Not must-fix because the Lean code is intentionally a typed sorry
  per the contamination-guard directive; the defect is purely a blueprint marker error.)

### Confirmed known structural defect (already on fix-list)

- **`thm:rel_pic_addcommgroup_via_tensorobj` proof block, blueprint lines 521–522**: the `\leanok`
  token appears INSIDE the `\uses{}` argument (`\uses{thm:scheme_modules_monoidal,` / `\leanok`
  / `lem:tensorobj_lift_onproduct, ...}`). This is the malformed `\uses{\leanok lem:...}` cited
  in the directive. Confirmed; already on fix-list; no separate severity assigned.

### Stale docstrings (minor)

- `tensorObj`, line 109–112: "iter-202 Lane TS scaffold: the body is a typed `sorry`; the
  iter-203+ body lifts…" — the iter-203+ body has now landed; the "scaffold" framing is stale.
- `tensorObj_functoriality`, lines 125–128: same pattern — "iter-202 Lane TS scaffold: the body
  is a typed `sorry`; the iter-203+ body inherits…" — stale.
  These are minor documentation lags, not excuse-comments in the sense of active misdirection.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file are not `\lean{...}`-pinned (blueprint characterises
them as PUSH-BEYOND helpers):

| Declaration | Line | Blueprint label | Status |
|---|---|---|---|
| `Scheme.Modules.tensorObj_isLocallyTrivial` | 169 | `lem:tensorobj_preserves_locally_trivial` | typed sorry, by design |
| `Scheme.Modules.exists_tensorObj_inverse` | 182 | `lem:tensorobj_inverse_invertible` | typed sorry, by design |
| `Scheme.Modules.tensorObjOnProduct` | 194 | `lem:tensorobj_lift_onproduct` | substantive body (delegates to sorried lemmas) |

All three are covered by blueprint prose (each corresponds to a named lemma block); they simply
lack `\lean{...}` pins because the blueprint marks them as PUSH-BEYOND. No flag needed. If the
plan agent promotes them to pinned status in a later iter, it should add `\lean{...}` entries.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 `\lean{...}`-pinned declarations have corresponding blueprint blocks.
  Unreferenced: 3 helpers (acceptable — PUSH-BEYOND, have named blocks without pins).
- **Proof-sketch depth**: adequate. Both `tensorObj` and `tensorObj_functoriality` are now
  closed, and the bodies track the sketch exactly (sheafification of the presheaf-level operation;
  morphism map under sheafification). The `monoidalCategory` and `addCommGroup_via_tensorObj`
  sketches are detailed enough to guide the iter-203+/204+ prover work.
- **Hint precision**: precise. Both newly-closed declarations use the exact names from `\lean{...}`
  pins (`AlgebraicGeometry.Scheme.Modules.tensorObj`,
  `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality`). The Lean names match perfectly.
- **Generality**: matches need. The blueprint targets `Scheme.Modules X` (the sheaf level), and
  the Lean constructions land there. No parallel API gap detected.
- **Recommended chapter-side actions**:
  - **Remove `\leanok` from the proof block of `thm:scheme_modules_monoidal`** (blueprint
    line 291). The proof is not closed; the marker is wrong. The statement-block `\leanok` (line
    274) should remain.
  - **Fix the malformed `\uses{}`** in the proof block of `thm:rel_pic_addcommgroup_via_tensorobj`
    (blueprint lines 521–522): move `\leanok` outside the `\uses{}` closing brace (or to a
    standalone line after `\uses{...}` closes) when the proof is eventually closed. For now,
    the `\leanok` should simply be removed from inside `\uses{}`.
  - **Update the "scaffold" docstrings** for `tensorObj` and `tensorObj_functoriality` in the
    Lean file to reflect their closed state (minor; can be batched with a cleanup sweep).

---

## Severity summary

| Finding | Severity |
|---|---|
| Incorrect `\leanok` on proof block of `thm:scheme_modules_monoidal` (blueprint line 291) | **major** |
| Malformed `\uses{\leanok …}` in proof of `thm:rel_pic_addcommgroup_via_tensorobj` | confirmed known / fix-listed |
| Stale "iter-202 scaffold" docstrings in `tensorObj` and `tensorObj_functoriality` | **minor** |

**Overall verdict**: The two defs closed this iter (`tensorObj`, `tensorObj_functoriality`) are
axiom-clean and match the blueprint precisely in name, signature, and body strategy; no Lean-side
issues. One major blueprint marker error: the proof block of `thm:scheme_modules_monoidal` carries
an erroneous `\leanok` that claims the `monoidalCategory` proof is closed when the body is still
`:= sorry`; the review agent should remove it.
