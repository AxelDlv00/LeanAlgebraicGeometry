# Iter-204 objectives — per-lane detail (reference-driven)

## Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT) — SOLE prover lane

**Mode**: `prove` (default). The two primary targets have concrete affine-descent
recipes (sorry-closing); `monoidalCategory` is a deferred-large stretch handled
with mathlib-build discipline (no new sorry — leave the `:= sorry` stub if blocked).

**Blueprint**: `chapters/Picard_TensorObjSubstrate.tex` — HARD GATE CLEARED this iter
(blueprint-reviewer `ts-fastpath`: complete + correct, 0 findings). The 4 lemma
pins were added this iter (`tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`,
`tensorObjOnProduct`) and the stray laundering `\leanok` was removed.

**References**:
- `Mathlib.CategoryTheory.Monoidal.PresheafOfModules` —
  `PresheafOfModules.sheafification` (confirmed axiom-clean & existing iter-203;
  the multi-iter "sheafification is a Mathlib gap" premise was FALSE).
- Stacks **01CR** (invertible modules / Picard group; backs
  `lem:tensorobj_inverse_invertible` — dual of a line bundle is a two-sided
  tensor inverse, `L ⊗ L⁻¹ ≅ O_X`).
- Affine descent of free rank-one modules (tensor/dual of free rank-one is free
  rank-one) — backs `lem:tensorobj_preserves_locally_trivial`.

**Targets (ordered)**:
1. **`tensorObj_isLocallyTrivial`** (L169) — PRIMARY, sorry-closing.
   Recipe (blueprint `lem:tensorobj_preserves_locally_trivial` + recs #3):
   intersect the trivialising affine covers of `M` and `N`; on each `U_i`,
   `(L⊗L')|U_i ≅ O_{U_i}` since tensor of free rank-one is free rank-one. The one
   genuinely new ingredient is `tensorObj`-commutes-with-`restrict`; model on
   `IsLocallyTrivial.pullback` (existing).
2. **`exists_tensorObj_inverse`** (L182) — PRIMARY, sorry-closing.
   Recipe (blueprint `lem:tensorobj_inverse_invertible`, Stacks 01CR): dual
   `L⁻¹ := Hom(L, O_X)` is locally free rank-one; the contraction
   `L ⊗ Hom(L,O_X) → O_X` is a global iso (it is the free rank-one contraction
   `A ⊗_A A → A` on each trivialising open). Depends on target 1.
3. **`monoidalCategory`** (L150) — STRETCH (deferred-large). Transport the monoidal
   structure through the `sheafification ⊣ forget` reflective adjunction; do NOT
   hand-discharge pentagon/triangle/hexagon. **CONTAMINATION GUARD**: keep
   `:= sorry` unless FULLY closed; add no axiom-clean declaration that synthesizes
   `MonoidalCategory X.Modules` until the instance body is filled.
4. **`addCommGroup_via_tensorObj`** (L221) — attempt ONLY if `monoidalCategory`
   lands (it is the swap-in target for the RPF `addCommGroup` honest sorry).

**Reusable gotcha (recs #3)**: `HasSheafify (Opens.grothendieckTopology Y)
AddCommGrpCat.{u}` synthesizes ONLY under the current name `AddCommGrpCat` — the
deprecated alias `AddCommGrp` does NOT carry the instance. Ascribe sheafification
results to the unfolded `SheafOfModules X.ringCatSheaf`, not `X.Modules`, or `?R`
stays a stuck metavariable.

**HARD BAR**: close ≥1 of {`tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`}
axiom-clean. **Stretch**: both (→ 4 sorries to 2) + `monoidalCategory` +
`addCommGroup_via_tensorObj`.

**Scope fence**: do not synthesize a `MonoidalCategory X.Modules` instance from the
sorried `monoidalCategory` (contamination guard).

## COE — NOT dispatched (escalation honored)

See plan.md `## Decision made`. Lane COE is paused pending a USER proof-strategy
decision on Stacks 02JK (Step A2). No prover dispatch; no further substrate round.

## Held lanes (triggers unchanged)

- **RPF** (`Picard/RelPicFunctor.lean`) — HELD. Re-opens once Lane TS lands
  `addCommGroup_via_tensorObj`. **At re-engagement**: FIRST replace the dishonest
  `PicSharp := const PUnit` (L330) + `functorial := 0` (L377) with the real
  construction consuming the new substrate (NOT a sorry-now-then-rebuild two-step).
  See plan.md `## Deferred must-fix`.
- **FGA / T32 / WD / RCI / AlbaneseUP** — held; triggers per task_pending.md.
