# Picard/TensorObjSubstrate.lean — iter-254 (Lane TS-cmp)

## Summary
- **Sorry count: 3 → 2.** Closed **STEP A** (`sheafifyTensorUnitIso_hom_natural`, the D1′ helper
  blocker, ~L1914) **axiom-clean** (`propext`/`Classical.choice`/`Quot.sound` only).
- Remaining sorries: `exists_tensorObj_inverse` (L690, **guardrailed — not touched**) and
  `pullbackTensorMap_natural` (D1′/STEP B, L2004 — **advanced + scaffolded**, see below).
- Added one new axiom-clean private helper `sheafifyTensorUnitIso_hom_eq'`.
- Attempted STEP B beyond the assigned-minimum: verified + encoded the Square-2 merge fix; hit a
  **named structural blocker** (ring-spelling `MonoidalCategory` synthesis in `δ_natural`) that is the
  planner's spelling-pin decision.
- File compiles GREEN (exit 0); DualInverse.lean (importer) unaffected (no signature change).

## STEP A — `sheafifyTensorUnitIso_hom_natural` (RESOLVED, axiom-clean)
### Approach (tscmp254 `tensorHom`-pin, executed)
The recast onto δ/μ single-sided naturality as literally prescribed did **not** apply directly
(`sheafifyTensorUnitIso` is `a.map (η_P ⊗ η_Q)` of the sheafification *unit* η, not a `δ`/`μ` of a
monoidal functor). The decisive realization that made the same *principle* work:

1. **New helper `sheafifyTensorUnitIso_hom_eq'`**: states `(sheafifyTensorUnitIso P Q).hom` as a SINGLE
   `a.map (MonoidalCategory.tensorHom (C := …⋙ forget₂…) η_P η_Q)` — i.e. the comparison as ONE
   `tensorHom`, keeping every term in the single monoidal instance on the `⋙ forget₂` carrier. Proved by
   `rw [sheafifyTensorUnitIso_hom_eq, ← Functor.map_comp]; congr 1;
    exact (MonoidalCategory.tensorHom_def (C := …) _ _).symm` — the explicit `(C := …)` is REQUIRED
   (the `_ _` form leaves `MonoidalCategory ?C` a stuck metavariable), and `exact` (defeq) absorbs the
   `restrictScalars (𝟙)` wrapper on η's codomain that blocks a syntactic `← tensorHom_def`.
2. Naturality: `rw [hom_eq', hom_eq']; erw [← Functor.map_comp, ← Functor.map_comp]; congr 1` reduces to
   the PRESHEAF bifunctoriality `(p⊗q) ≫ (η_{P'}⊗η_{Q'}) = (η_P⊗η_Q) ≫ (a.map p ⊗ a.map q)`. The merge
   needs **`erw`** (not `rw`) — the connecting tensor object is defeq-but-not-syntactic.
3. Close: the unit squares `hp`/`hq` (`simpa [restrictScalarsId_map] using unit.naturality`), then the
   bifunctoriality is `MonoidalCategory.tensorHom_comp_tensorHom` applied **as a defeq-matched TERM**:
   `refine (tensorHom_comp_tensorHom (C := …) _ _ _ _).trans ?_; rw [hp, hq];
    exact (tensorHom_comp_tensorHom (C := …) _ _ _ _).symm`.

### Key reusable findings (the whole iter's lesson)
- **Mathlib name**: it is `MonoidalCategory.tensorHom_comp_tensorHom`
  (`(f₁⊗f₂)≫(g₁⊗g₂) = (f₁≫g₁)⊗(f₂≫g₂)`). **`MonoidalCategory.tensor_comp` does NOT exist** (Unknown
  constant) — an early `lean_multi_attempt` reported a false `goals:[]` for it (tooling trap: trust the
  file diagnostic, not multi_attempt's empty-goals).
- **Instance poisoning**: the goal's `⊗ₘ`/whiskers carry a non-canonical `MonoidalCategory` instance
  (from `Monoidal.tensorObj`/`instMS` cast leaking through `sheafifyTensorUnitIso`), so `rw`/`erw` of
  `tensorHom_def`/`tensorHom_comp_tensorHom`/`← Functor.map_comp` all fail ("pattern not found", even
  for terms clearly present). The remedy is to apply the monoidal lemmas **as TERMs** via `refine
  …trans`/`exact` (defeq-based, instance-tolerant) with an explicit **`(C := …)`** so the instance
  resolves. `← Functor.map_comp` similarly fails but `erw [← Functor.map_comp]` bridges it.

## STEP B — `pullbackTensorMap_natural` (D1′) — advanced, then NAMED structural blocker
### Real code progress encoded in the proof
- **Square-2 merge SOLVED** (iter-253 BLOCKER was misdiagnosed): the two `a_Y.map`s are
  right-associated, so `← Functor.map_comp` cannot see them as one `≫`'s operands. Fix =
  **`erw [← Functor.map_comp_assoc]`** (reassoc form) — verified to merge
  `a.map(Fp.map(a.val⊗b.val)) ≫ a.map(δ_{M',N'}) ≫ rest` into `a.map(Fp.map(a.val⊗b.val) ≫ δ_{M',N'}) ≫ rest`.
  This step is now IN the proof body (the proof advances past the dsimp before the sorry).

### Named blocker (STEP-B reversing signal → planner structural decision)
- Square-2's δ commutation needs `Functor.OplaxMonoidal.δ_natural (F := Fp) a.val b.val`, but **building
  that term FAILS**: `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)`. δ
  naturality needs a `MonoidalCategory` on Fp's DOMAIN ring (spelled `X.ringCatSheaf.obj` here), but the
  instance is registered ONLY on the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling
  (`Presheaf/Monoidal.lean:32,104-105`). Defeq, but instance synthesis is syntactic → never fires. The
  STEP-A `(C := …)` term-level bridge does **NOT** transfer (no argument slot to inject the instance
  into δ_natural's domain-ring).
- **The fix is the tscmp254 SPELLING PIN** flagged "if forced": restate `pullbackTensorMap` + helper
  isos with Fp's domain ring on the canonical `⋙ forget₂` spelling so `δ_natural` synthesizes by
  construction. That is a structural restatement of the defs (must keep D2′
  `pullbackTensorMap_unit_isIso` GREEN) — per the STEP-B reversing-signal protocol this is the
  **planner's next structural decision**, not a tactic fix. Documented precisely in-file at L2004.
- After the pin: Sq2 = `← δ_natural`, Sq3 = `sheafifyTensorUnitIso_hom_natural` (CLOSED this iter),
  Sq4 = `pullbackValIso_hom_natural` (CLOSED) + `tensorHom_comp_tensorHom`, all via the STEP-A term-level
  device.

## Blueprint marker
- `lem:sheafofmodules_*` / the D1′-helper block for `sheafifyTensorUnitIso_hom_natural`: now sorry-free
  → ready for `\leanok` (sync will apply). `lem:pullback_tensor_map_natural` still has its sorry.

## Cleanup done
- Header (~L43) updated: "THREE residuals" → "TWO" + STEP-A-closed note; stale `~L699` ref → `~L686`.

## Why I stopped
**Real progress**: closed 1 sorry — `sheafifyTensorUnitIso_hom_natural` (STEP A, the PRIMARY
reversing-signal target), axiom-clean; sorry 3→2. Built 1 new axiom-clean helper
(`sheafifyTensorUnitIso_hom_eq'`). For STEP B: **partial code progress** — encoded the verified
Square-2 `erw [← Functor.map_comp_assoc]` merge into the proof body (the proof now advances strictly
further before the sorry), then hit a **specific named obstacle**: `δ_natural` cannot synthesize
`MonoidalCategory` on the `X.ringCatSheaf.obj` domain-ring spelling, which requires the structural
spelling-pin refactor of `pullbackTensorMap` (the planner's call per the STEP-B reversing-signal
protocol — not a tactic-level fix, and risky vs the CLOSED D2′ consumer). No banned approach retried,
no 4th pivot invented. File left GREEN (exit 0).
