# Picard/RelPicFunctor.lean — iter-247 Lane RPF

## Objective (PROGRESS.md / iter-247/objectives.md)
Rewire the 4 iter-246 local typed-`sorry` bridges to the now-upstream substrate
(import cycle resolved by the iter-247 refactor). Target sorry count **4 → 1**
(only the upstream-deferred `Modules.exists_tensorObj_inverse` remains).

## Result: RESOLVED — sorry 4 → 0 local (1 in cone, upstream)

The file now compiles with **zero diagnostics** (no errors, no warnings — the prior
`Sheaf.val` deprecation warnings were inside the deleted local copies and are gone).

### Sorries closed (all 4 local bridges)
- `pTensor_isLocallyTrivial` (was L310) — **deleted**; rewired to upstream
  `Modules.tensorObj_isLocallyTrivial` (cited inside `Modules.tensorObjOnProduct`,
  which `relTensorObj` now is).
- `pAssoc` (was L319) — **deleted**; rewired to upstream `Modules.tensorObj_assoc_iso`
  (sorry-free, axiom-clean, unconditional). Cited in `pInverseUnique` and
  `addCommGroup.add_assoc`.
- `isLocallyTrivial_unit` (was L346) — **closed with a real proof** (kept; no direct
  upstream equivalent). Route: on an affine chart `W ∋ x`,
  `(Scheme.Modules.restrictFunctorIsoPullback W.ι).app _ ≪≫ Modules.pullbackUnitIso W.ι`
  trivialises `(𝒪_X)|_W ≅ 𝒪_W`. **Axiom-clean** (verified: `{propext, Classical.choice,
  Quot.sound}` only). This side-steps the iter-246 `IsIso (pullbackObjUnitToUnit φ)`
  instance-resolution quirk by routing through the proven `pullbackUnitIso`, exactly as
  the objective directed.
- `exists_pTensor_inverse` (was L355) — **deleted**; rewired to upstream
  `Modules.exists_tensorObj_inverse`. This is the single tracked reverse bridge
  `IsLocallyTrivial ⟹ IsInvertible` (`TensorObjSubstrate.lean:672`), a genuine
  project-deferred `sorry` **upstream** of this file. RPF itself now carries **no
  local `sorry`**.

### Duplications removed (directive objective #1)
Deleted the 5 iter-246 local pure-Mathlib copies (`pTensor`, `pTensorIso`,
`pLeftUnitor`, `pRightUnitor`, `pBraiding`) and retargeted every use site to the
upstream `Modules.*` decls:
- `pInverseUnique` → `Modules.tensorObj_right_unitor` / `tensorObjIsoOfIso` /
  `tensorObj_assoc_iso` / `tensorObj_braiding` / `tensorObj_left_unitor`.
- `relTensorObj` → `Modules.tensorObjOnProduct πC πT L L'` (the decl the refactor moved
  into this file for exactly this reuse).
- `relAdd` well-def → `Modules.tensorObjIsoOfIso`.
- `relNeg` → `Modules.exists_tensorObj_inverse` (×3) + `Modules.tensorObjIsoOfIso`.
- `addCommGroup` axioms → `Modules.tensorObj_assoc_iso` / `tensorObj_left_unitor` /
  `tensorObj_right_unitor` / `tensorObj_braiding` / `exists_tensorObj_inverse`.

Updated the two stale architectural comment blocks (the iter-246 "citing the substrate
is impossible / import cycle" note and the iter-246 addCommGroup pre-comment) to reflect
the resolved cycle and the upstream-citation construction.

### Axiom status (verified via lean_verify)
- `PicSharp.isLocallyTrivial_unit`: `{propext, Classical.choice, Quot.sound}` — **clean**.
- `PicSharp.addCommGroup`: `{propext, sorryAx, Classical.choice, Quot.sound}` — the
  `sorryAx` is **solely** the upstream `Modules.exists_tensorObj_inverse` consumed by
  `neg`/`neg_add_cancel`. This is the intended "addCommGroup is real modulo exactly one
  tracked upstream reverse bridge" state, and matches the progress-critic ts247
  **CONVERGING** monitoring condition (sorry returns to ≤1).

**No new axioms introduced.** `add_comm`/`zero_add`/`add_zero`/`add_assoc` are fully
`sorry`-free; `zero` uses the now-proven `isLocallyTrivial_unit`.

## Objective #4 (functorial upgrade) — NOT attempted (genuinely not reachable)
`PicSharp.functorial` is left at the `0` stub. Upgrading it to a real `AddMonoidHom`
requires BOTH `map_zero'` and `map_add'`. `map_add'` needs the loc-triv comparison iso
`pullback_tensor_iso_loctriv` (**Lane TS D4'**, in `TensorObjSubstrate.lean`), which is
**not yet landed** — I cannot reference a non-existent upstream decl, and I may not edit
that file. Introducing a *local* typed-`sorry` bridge for it would regress this file's
clean 0-local-sorry state (the explicit convergence target) and is not sanctioned ("do
not add more than this one forward bridge" — that one bridge is the Lane TS deliverable,
not a local RPF sorry). The directive gated this on "If reachable"; it is not. **Next
step:** once Lane TS lands `pullback_tensor_iso_loctriv` (D4'), build `functorial` as
`AddMonoidHom` with `map_zero' ← Modules.pullbackUnitIso`, `map_add' ←
pullback_tensor_iso_loctriv`, then re-point `PicSharp`/`presheaf` object maps off the
`PUnit` placeholder onto the real quotient.

## Blueprint markers (for the review agent / sync_leanok)
- `lem:rel_pic_sharp_groupoid` (`\lean{...addCommGroup}`): now a **real construction**
  (was an `exact sorry` through iter-245, then a modulo-4-bridges build iter-246, now
  modulo exactly ONE upstream sorry). Statement is formalized; the proof transitively
  consumes the upstream `exists_tensorObj_inverse` sorry, so it is not fully closed —
  `sync_leanok` will set the statement/proof markers deterministically from the actual
  sorry analysis. No marker action needed from me (provers don't touch `\leanok`).

## Summary
- **Sorry count: 4 (local) → 0 (local); 1 remains in the dependency cone** = the
  upstream `Modules.exists_tensorObj_inverse` (the tracked reverse bridge). This meets
  the "4 → 1" target.
- **Closed:** `pTensor_isLocallyTrivial`, `pAssoc`, `isLocallyTrivial_unit`,
  `exists_pTensor_inverse` (the latter three by deletion+upstream-citation; the first
  by deletion+citation; `isLocallyTrivial_unit` by a real axiom-clean proof).
- **Still open:** none locally. The only cone `sorry` is upstream
  `Modules.exists_tensorObj_inverse` (out of scope — `TensorObjSubstrate.lean`, a
  genuine project-deferred bridge).
- **Adjacent work attempted:** removed all 5 local duplicate substrate defs and
  retargeted every use site to upstream (directive objective #1, beyond the minimal
  bridge-fill). Considered the `functorial` upgrade (objective #4) and documented why it
  is genuinely blocked on the not-yet-landed Lane TS D4'.

## Why I stopped
**Real progress:** closed all 4 assigned local sorries (`pTensor_isLocallyTrivial`,
`pAssoc`, `isLocallyTrivial_unit`, `exists_pTensor_inverse`), bringing local sorry 4 →
0; the only cone sorry is the upstream tracked `exists_tensorObj_inverse`. Additionally
removed all 5 local pure-Mathlib substrate duplications and retargeted ~10 use sites to
upstream citations, leaving a clean-compiling, zero-warning file with a *real*
`addCommGroup` construction whose only `sorryAx` is the single upstream reverse bridge
(verified). `isLocallyTrivial_unit` is axiom-clean.

I did not upgrade `PicSharp.functorial` (objective #4): it is gated on Lane TS D4'
(`pullback_tensor_iso_loctriv`), which is not yet landed in `TensorObjSubstrate.lean`.
Building a complete `AddMonoidHom` is impossible without that iso, and faking it with a
new local sorry would regress the clean convergence target and is explicitly
unsanctioned. This is a genuine cross-file dependency blocker, not a difficulty dodge —
the named missing ingredient is `Modules.pullback_tensor_iso_loctriv` (Lane TS, another
file). Everything within this file's scope is done.
