# Iter-213 objectives (per-task detail)

## Lane TS — `Picard/TensorObjSubstrate.lean` — associator via ROUTE (c)

**Mode:** prove (default). Concrete recipe exists (`analogies/ts-monoidal213.md` + the rewritten
blueprint route-(c) proof), so this is a body-attempt lane, not a scaffold.

**Gate status:** CLEARED this iter via fast path (blueprint-reviewer ts213fp: chapter
complete+correct, route (c) sound + detailed; no must-fix touches the chapter).

**Target sorries (in dependency order):**
1. `tensorObj_assoc_iso` (line ~568) — re-scope hypotheses `IsInvertible → LineBundle.IsLocallyTrivial`
   (decl NOT protected), then close via the 3-step composite (Steps A+B below).
2. `tensorObjIsoclassCommMonoid` (`lem:tensorobj_isoclass_commgroup`) — NEW decl to add; Step C
   (stretch). Carrier = `Units(Skeleton)`-shaped iso-classes of locally-trivial objects.

**Route-(c) ingredient map (verified-present Mathlib, this iter):**
- `isLocallySurjective_whiskerLeft` (file line 222) — surjectivity half, free.
- `isLocallyInjective_toSheafify` — `η = toSheafify` is locally injective. [verified]
- `restrictIsoUnitOfLE` (file line 587) — descends `IsLocallyTrivial` to the cover; `P|_V ≅ 𝒪_V`.
- `isIso_sheafification_map_of_W` (file line 373, closed iter-212) — inverts a `J.W` map under `a`.
- `isLocallyInjective_of_*` blocks in `Mathlib.CategoryTheory.Sites.LocallyInjective` — the
  local-on-cover characterization of `Presheaf.IsLocallyInjective`. [verified present]
- Sieve template: existing `isLocallyInjective_whiskerLeft_of_flat` (lines 255–321) — KEEP the sieve
  bookkeeping, SWAP the `Module.Flat.lTensor_exact` step for the trivialization-on-cover step.

**Known friction (iter-212):** `X.ringCatSheaf.val` is only DEFEQ (not syntactically eq) to
`X.presheaf ⋙ forget₂ CommRingCat RingCat` → monoidal `▷`/`◁` notation + instance synthesis hit
heartbeat timeouts. Workaround used iter-212: set the ring carrier explicitly. Plumbing, not a wall.

**DEAD ENDS — do not attempt:**
- `∀ U, Module.Flat (𝒪_X(U)) (M.val U)` from `IsInvertible` (false, non-affine opens).
- `W_whisker{Left,Right}_of_flat` with `F = M.val/P.val` (the flatness hypothesis is the dead step).
- Bundled `MonoidalCategory (SheafOfModules)` / monoidal `sheafification` (MonoidalClosed-absent).
- `tensorObj_restrict_iso` route (strong-monoidal pushforward absent; abandoned).

**Reversal trigger (pre-committed):** if Step A's local-on-cover injectivity ingredient cannot be
built from present Mathlib + the sieve template, STOP and report the precise residual — all four
realizations exhausted → next iter ESCALATES the substrate design to USER. Do NOT pivot a fifth time.

**Off-path sorries left as-is:** `tensorObj_restrict_iso`, `exists_tensorObj_inverse`,
`addCommGroup_via_tensorObj` (the last may close as a bonus if Step C lands).
