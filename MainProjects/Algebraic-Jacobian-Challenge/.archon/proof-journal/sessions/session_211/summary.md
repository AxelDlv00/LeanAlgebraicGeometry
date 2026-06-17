# Session 211 — review of iter-211

## Metadata

- **Iteration / session**: 211
- **Sorry count**: 80 → **81** (net **+1**, one new *scaffolded* sorry `tensorObj_assoc_iso`).
- **Build**: GREEN, 0 errors (`lean_diagnostic_messages` clean on the touched file).
- **Axioms**: 0 `axiom` declarations project-wide (blueprint-doctor confirms). The gate
  lemma `W_whiskerLeft_of_flat` verified axiom-clean (`propext`, `Classical.choice`,
  `Quot.sound` — **NO `sorryAx`**).
- **File touched**: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (only).
- **Model**: opus. Prover status: `done`. `sync_leanok`: iter-211, sha `18c2c89d`, +3 / −0.

## The headline — the go/no-go gate CLEARED; the 5-iter recession pattern broke

This was the **first prover dispatch since iter-208** (iters 209/210 were the sanctioned
no-prover restructure iters: 209 pivoted to ⊗-invertibility, 210 tested+cleared the gate's
buildability and corrected the realization). The iter-211 objective front-loaded the
load-bearing **go/no-go gate** `PresheafOfModules.W_whiskerLeft_of_flat`
(`J.W g → J.W (F ◁ g)` for flat `F`) with a pre-committed reversal: *if it bottoms out in
`MonoidalClosed` / a strong-monoidal pushforward → STOP and ESCALATE to USER.*

**The gate CLEARED, axiom-clean, and the reversal trigger did NOT fire.** The
flat-whiskering route uses **no** `MonoidalClosed` and **no** strong-monoidal pushforward —
realization (2) of `analogies/ts-assoc-gate210.md` is confirmed buildable from present
Mathlib. After 4 iters (205–208) where every "almost there" framing was DISPROVEN on
contact, and 2 deliberate restructure iters, this is the first iter to land genuine,
sorry-free, critical-path infrastructure on the ⊗-group law.

## Targets and attempts

### `PresheafOfModules.W_whiskerLeft_of_flat` — SOLVED (the gate)
- **Approach**: package the two halves (`isLocallySurjective_whiskerLeft`,
  `isLocallyInjective_whiskerLeft_of_flat`) into `J.W` via
  `GrothendieckTopology.W_iff_isLocallyBijective`.
- **Code**: `rw [GrothendieckTopology.W_iff_isLocallyBijective] at hg ⊢; exact ⟨…hg.1, …hg.2⟩`.
- **Key insight**: the localizer is over `Ab.{u}` (the target of `PresheafOfModules.toPresheaf`);
  the instance binder **must** be `Ab.{u}` with the explicit universe or synthesis fails
  (`Ab` defaults to a different universe). `PresheafOfModules.IsLocallySurjective J g` is
  *defeq* to `Presheaf.IsLocallySurjective J ((toPresheaf _).map g)`, so the helper output
  slots directly into the `W_iff` unfolding.

### `isLocallyInjective_whiskerLeft_of_flat` — SOLVED (bug fix)
- One half of the gate was **erroring at file open** after a Mathlib bump: the `simp` closing
  `(F.map f.op) a ⊗ₜ 0 = 0` stopped firing because the first tensor factor elaborates in
  `(ModuleCat.restrictScalars (R.map f.op)).obj (F.obj X)`, so `TensorProduct.tmul_zero`'s
  `Module` instance is not synthesizable on the displayed (restrictScalars-wrapped) type.
- **Fix**: `erw [TensorProduct.tmul_zero]; rfl` (erw matches up to the restrictScalars defeq;
  the trailing `0 = 0` needs an explicit `rfl`).
- **Dead ends**: `rw [TensorProduct.tmul_zero]`, `exact TensorProduct.tmul_zero _`,
  `simp [TensorProduct.tmul_zero]`, `module`, `abel` — all fail on the wrapped module.

### `IsInvertible` — SOLVED (def created)
- `def IsInvertible (M) : Prop := ∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`.
- Scheme-level analogue of `Module.Invertible`; carries the inverse existentially so the dual
  is definitional. Resolves the blueprint-reviewer's "IsInvertible does not exist in Lean" concern.

### `tensorObj_left_unitor` / `tensorObj_right_unitor` / `tensorObj_braiding` — SOLVED
- All three via the `sheafification.mapIso (coherence) ≪≫ (asIso counit).app M` pattern.
- **Shared dead-end + fix**: `λ_ M.val` / `ρ_ M.val` / `β_ M.val N.val` FAIL — the
  `MonoidalCategory` / `BraidedCategory` instance lives on
  `PresheafOfModules (X.presheaf ⋙ forget₂ …)`, but `M.val : PresheafOfModules X.ringCatSheaf`
  is not *syntactically* that form, and a type ascription is transparent (does not redirect
  instance resolution). **Force the instance**:
  `(PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val` /
  `BraidedCategory.braiding (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ …)) M.val N.val`.
  A `BraidedCategory (PresheafOfModules …)` instance **does** exist in Mathlib.

### `tensorObj_assoc_iso` — PARTIAL (NEW scaffolded sorry, single residual pinned)
- Recipe scaffolded (blueprint 3-step composite). **Single residual = the bridge
  `IsIso (a.map f)` from `J.W ((toPresheaf _).map f)`** (`a` = PoM sheafification). This is
  **NOT** a Mathlib one-liner — there is no `PresheafOfModules.sheafification`-level
  "map is iso iff underlying in `J.W`" lemma. Must be built from: (a) `toPresheaf` reflecting
  isomorphisms; (b) the underlying `AddCommGrpCat`-sheafification being a localization at `J.W`
  (`GrothendieckTopology.W_iff_isIso_map_of_adjunction` + a `toPresheaf ∘ sheafification ≅
  AddCommGrp-sheafify ∘ toPresheaf` compatibility); (c) the `IsInvertible ⇒ sectionwise
  Module.Flat` derivation feeding the gate. Plus `W_whiskerRight_of_flat` (cheap — conjugate
  the gate by the braiding). **Est. ~80–150 LOC of sheafification-localization plumbing — a
  focused follow-up, NOT a blocker on the gate.** (Topology `J` is the small-site one of
  `X.ringCatSheaf`, NOT `Scheme.zariskiTopology` — that probe failed.)

### Off-path / downstream — left as typed sorry (per objective)
- `tensorObj_restrict_iso` (off the critical path under the pivot — do NOT re-dispatch),
  `exists_tensorObj_inverse` (off-path), `addCommGroup_via_tensorObj` (downstream consumer,
  needs the full group-law engine: associator + commMonoid).

## Review-phase subagents (this review dispatched both)

- **lean-vs-blueprint-checker ts211**: 0 must-fix, 0 major, 1 cosmetic minor (blueprint prose cites
  `lTensor_preserves_injective_linearMap` but the proof uses the equivalent `lTensor_exact`). All five
  new decls match the chapter exactly. Report: `task_results/lean-vs-blueprint-checker-ts211.md`.
- **lean-auditor ts211**: 0 must-fix, **2 major** (deprecated `CategoryTheory.Sheaf.val` cluster — 10
  uses across all 7 new non-sorry defs, sweep to `ObjectProperty.obj` before the next Mathlib pin; +
  the known-stale module docstring), 5 minor. No excuse-comments, no wrong defs. Report:
  `task_results/lean-auditor-ts211.md`. Findings folded into recommendations.md §2b.

## Subagent findings (plan-phase, folded into recommendations)

- **blueprint-reviewer ts211**: HARD GATE CLEARS (`complete: true`, `correct: true`, 0 must-fix).
  Two `soon` findings (both non-blocking): the `IsInvertible` vs `IsLocallyTrivial` carrier
  mismatch (bridge `IsLocallyTrivial → IsInvertible` not blueprinted), and three "stale `\leanok`"
  on sorry decls — see note below. Two `informational`: thin general-M unitor sketch; stale Lean
  module-level docstring.
- **progress-critic ts211**: CONVERGING; pivot GENUINE (the new ingredients do not overlap the
  old `pullback.Monoidal`/`MonoidalClosed` gap); throughput SLIPPING (warned iter-211 must close
  ≥1 sorry). NOTE: the "close ≥1 sorry" bar was NOT met numerically (sorry +1), but the gate
  clearance is the more important signal — see review.md.

## Note on the "stale `\leanok`" finding (resolved — not laundering)

The reviewer flagged `\leanok` on three sorry-bodied decls (`tensorobj_restrict_iso`,
`tensorobj_inverse_invertible`, `rel_pic_addcommgroup_via_tensorobj`) as inconsistent and
expected `sync_leanok` to clear them. First-hand audit: these are **statement-block** `\leanok`
markers, which per the marker vocabulary are **legitimate** ("statement block: declaration is
formalized — at least a sorry present"). `sync_leanok` ran at iter-211 (current tree) and
removed 0, confirming they are correct statement-block markers, not proof-block laundering. No
action needed; the reviewer conflated statement-block `\leanok` (legit) with proof-block
`\leanok` (which would be laundering).

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:flat_whisker_localizer`: corrected
  `\lean{AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat}` →
  `\lean{PresheafOfModules.W_whiskerLeft_of_flat}` (prover placed the gate in the
  `PresheafOfModules` namespace where its `C/R/J` variables live). This unblocks the
  `\leanok` on this label at the next `sync_leanok` (iter-212) — it could not be added this
  iter because the old pin named a non-existent declaration.

No `\mathlibok` added: all five new decls carry genuine project proofs (not Mathlib
re-exports/aliases), so they are `\leanok`-only (handled by `sync_leanok`). No `\notready`
present to strip.

## Blueprint doctor

No structural findings (no orphan chapters, all `\ref`/`\uses` resolve, no new axioms).

## Recommendations (see recommendations.md)

Close `tensorObj_assoc_iso` via the pinned single residual (build
`isIso_sheafification_map_of_W` + `W_whiskerRight_of_flat`, ~80–150 LOC). Then the
`IsInvertible`-based CommMonoid and `addCommGroup_via_tensorObj` consumer. Do NOT re-dispatch
the off-path `tensorObj_restrict_iso`.
