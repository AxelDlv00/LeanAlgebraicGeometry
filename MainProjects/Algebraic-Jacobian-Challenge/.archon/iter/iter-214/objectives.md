# Iter-214 objectives (detail)

## Dispatched (1 file)

### `Picard/TensorObjSubstrate.lean` — ROUTE (e), [prover-mode: mathlib-build]

Goal: build the line-bundle ⊗-group law by instantiating Mathlib's monoidal-localization API.
Sole genuinely-new obligation: `(J.W).IsMonoidal` for the module sheafification localizer.

- **Step 0** make-or-break: is monoidal `SheafOfModules` / `IsMonoidal` for the module
  sheafification localizer already in Mathlib or one-liner-transportable? (search
  `…/ModuleCat/Sheaf/Localization.lean`, `…/Presheaf/Sheafification.lean`, `…/Presheaf/Sheafify.lean`).
  If yes → instantiate, STOP, report.
- **Step A** discharge `isLocallyInjective_whiskerLeft_of_W` (L411 sorry), flatness-free, via
  (d.1) module `J.W` ⟺ stalkwise-iso on `Opens X`; (d.2) stalk ⊗ relative tensor. Template:
  `Sites/Point/IsMonoidalW.lean`. mathlib-build: prove or leave absent (no pins), hand off decomposition.
- **Step B** package `MorphismProperty.IsMonoidal (J.W)` (fields = `W_whiskerLeft/Right_of_W`),
  instantiate `LocalizedMonoidal` → `MonoidalCategory (SheafOfModules X.ringCatSheaf)`; retire the
  hand-assembled `tensorObj_assoc_iso`.
- **Step C** (stretch) `tensorObjIsoclassCommMonoid` = `Units(Skeleton(Scheme.Modules X))` à la `CommRing.Pic`.

Recipe (decl names verified on disk): `analogies/ts-monoidalloc214.md`.
Blueprint: `chapters/Picard_TensorObjSubstrate.tex` § `sec:tensorobj_route_e`.
Reversal: substrate ESCALATES to USER only if `(J.W).IsMonoidal` has NO route from present Mathlib +
the `IsMonoidalW` template (not merely "multi-iter").

## Not dispatched

All other lanes HELD (see PROGRESS.md `## Held lanes`): RPF, FGA, A.2.c engine, Albanese Route-1/2,
WD, RCI, A.3.* — gated behind TS or USER directives.

## Entering state

Build GREEN; project sorry 81; 0 project axioms. iter-213 closed `W_whiskerLeft/Right_of_W` +
assembled `tensorObj_assoc_iso` (migrated to task_done).
</content>
