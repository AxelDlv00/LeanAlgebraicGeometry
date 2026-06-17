# Recommendations for iter-253 (plan agent)

## TOP PRIORITY — blueprint-side must-fix / major (HARD GATE blocks provers on these chapters until cleared)

Both touched files are covered by `Picard_TensorObjSubstrate.tex`. The lean-vs-blueprint checkers
returned blueprint-adequacy failures that **gate** further prover work on D1′ and `homOfLocalCompat`.
Dispatch a **blueprint-writer** on `Picard_TensorObjSubstrate.tex` THIS iter to fix:

1. **[MUST-FIX, ts252]** `lem:pullback_tensor_map_natural` (D1′) proof sketch (lines ~3310–3329)
   prescribes the whisker-exchange route the prover **proved blocked** (instance split
   `monoidalCategoryStruct` vs `monoidalCategory.toMonoidalCategoryStruct`). Rewrite to describe the
   **section/element descent**: `PresheafOfModules.Hom.ext` → `simp only` + `erw[comp_app, tensorHom_app]`
   → `ModuleCat.hom_ext; ext x` → element-level `TensorProduct` identity closed by
   `TensorProduct.induction_on` + sectionwise η-naturality. An interim `% NOTE` is already in place
   (added by review), but the prose itself must be corrected.
2. **[MAJOR, di252]** Add a `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` pin (or a dedicated
   block) for the load-bearing `localSection` — now closed axiom-clean. The chapter names it but does
   not tag it.
3. **[MAJOR, di252]** Expand `lem:sheafofmodules_hom_of_local_compat` step (a): give a concrete
   Lean-visible recipe for `hf : ∀ i j, HEq …` → `IsCompatible H.1 U (homLocalSection U f)` (transport
   the HEq overlap-agreement through `homLocalSection`'s `eqToHom`-conjugation + naturality, via
   `Subsingleton.elim` on `Opens X` morphisms). This is the **exact** blocker of the remaining
   `homOfLocalCompat` sorry — without it the next prover round is under-specified.
4. **[minor]** Add `\lean{}` pins for closed D1′ helpers (`pullbackValIso_hom_natural`); update
   `lem:dual_unit_iso` `\uses{}` to drop `lem:tensorobj_unit_iso` (the Lean route is `globalSMul`-based,
   not left-unitor).

After the writer returns + `lake build` green, the **same-iter fast path** (re-dispatch
blueprint-reviewer scoped to this chapter) clears the gate so D1′ / `homOfLocalCompat` can proceed in
iter-253.

## Closest-to-completion targets (prioritize after the gate clears)

1. **`sheafifyTensorUnitIso_hom_natural` (Step A of D1′)** — CLOSEST. Reduced to a single instance-free
   element-level ModuleCat tmul identity. Mechanical close: `induction x using TensorProduct.induction_on`
   — **feed `map_zero`/`map_add` on the bundled `ModuleCat.Hom.hom` EXPLICITLY** (the prover verified
   `simp`/`simp only [map_add]` did NOT auto-fire on `ModuleCat.Hom.hom (…) 0` / `(…) (a+b)`); tmul `m n`
   via the `ModuleCat.MonoidalCategory` tmul-evaluation lemmas; close with the sectionwise
   `(sheafificationAdjunction (𝟙 …)).unit.naturality p`/`q` at `.app U` after a `restrictScalarsId_map`
   strip. Closing this auto-unblocks **`pullbackTensorMap_natural` (D1′)** via the documented 4-square paste.

2. **`homOfLocalCompat`** — load-bearing `homLocalSection` is DONE; residual is standard gluing
   bookkeeping (a)/(b)/(c). Gate on recommendation #3 above (blueprint expansion of step (a)) before
   re-dispatching, else the prover hits the same under-specified HEq bridge.

## Promising approaches needing more work
- **The carrier-friction recipe** (`homLocalSection`): `hML` restrict-form + `hNR` pure-form + `erw`
  for the assoc step across the restrict/image boundary; final `simp only [Category.assoc] + rfl`.
  Reusable for ANY `Sheaf.val`-carrier sectionwise goal in this file — hand it to D3′ and the
  `homOfLocalCompat` residual.
- **The `erw [comp_app, tensorHom_app]` carrier-bridge + whisker-unfold-to-`tensorHom` idiom** (Step A):
  the general dissolution of the `.val`/forget₂ split is **descend to elements** (`ModuleCat.hom_ext; ext x`),
  where no monoidal instance survives. Reusable for D3′ (will hit the same friction).

## BLOCKED — do NOT re-assign without a structural change
- **`sheafifyTensorUnitIso_hom_natural` via the whisker-exchange / whisker252 `letI` route** — verified
  DEAD this iter by direct `lean_multi_attempt`. The instance split is real; `letI instMS` is inert and
  harmful. The element-descent route is the replacement; do not re-arm the whisker route.

## Untouched this iter (lower-priority frontier)
- **`dual_restrict_iso` Step-4** (L256): the dual-inverse chain's lower frontier. Plan unchanged (dual252):
  leg (A) `sliceDualTransport` (build standalone first) + leg (B) `restrictScalarsRingIsoDualEquiv`, OR
  the inverse-uniqueness shortcut from `tensorObj_restrict_iso`. Not blocked — just deprioritized.
- **`exists_tensorObj_inverse`** (TS L708, guardrailed): closes once both bridges (C = `dual_isLocallyTrivial`,
  A = `homOfLocalCompat`) land.

## Progress-discipline note for the plan agent
This is the **2nd consecutive M=2 iter with no target close** (canonical counter flat since the iter-250
D2′ win). The work is genuine (1 new axiom-clean lemma + a disproved-route pivot + an honesty fix), NOT
helper-churn — but a progress-critic dispatch is warranted to confirm the route is converging, not
stalling. The single dominant obstacle remains the `.val`/forget₂ carrier friction (now in its element-
descent form). The corrective is labor + the two blueprint expansions above, not a Mathlib gap.

## Parallel-lane hygiene (recurring)
The mid-session parallel-lane race recurred: TS-cmp left `TensorObjSubstrate.lean` non-compiling for most
of the session, forcing the DualInverse prover to verify every `homLocalSection` step in an isolated
Mathlib-only scratch file (and likely the cause of the `sync_leanok` −27 marker strip). If M=2 continues
on the same file-pair, instruct lanes to keep the shared file compiling at every commit, or split the
import surface further.

## `sync_leanok` marker verification (next iter)
Confirm iter-253's `sync_leanok` restores `\leanok` on the genuinely-closed proof blocks in
`Picard_TensorObjSubstrate.tex` (e.g. `dual_unit_iso`) that the iter-252 sync stripped while the file
was mid-race non-compiling. If markers do NOT return on a clean build, investigate the sync's per-decl
`lake env lean` invocation.
