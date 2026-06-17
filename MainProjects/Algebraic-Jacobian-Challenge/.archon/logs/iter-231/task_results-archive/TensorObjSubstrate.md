# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-230

## Summary
- **Sorry count in file: 3 → 3** (unchanged: L691 `isLocallyInjective_whiskerLeft_of_W`,
  L2210 `exists_tensorObj_inverse`, L2256 `addCommGroup_via_tensorObj`). **NO new sorry.**
- **Build: GREEN** (`lean_diagnostic_messages` severity=error → empty; only the 3
  pre-existing sorry warnings + pre-existing deprecation/style warnings).
- **Net Lean change:** one `/-! … -/` documentation block (the C-wiring diagnostic finding)
  added before `exists_tensorObj_inverse`. The diagnostic *def* was built, run, inspected, and
  removed (it would have pinned a new sorry, which the HARD-TRIPWIRE directive forbids).

## The binding probe — C-wiring diagnostic: **OUTCOME (ii)** (report mandated by the directive)

I built (in scratch) `dual_restrict_iso : (dual M).restrict f ≅ dual (M.restrict f)` for an
open immersion `f : Y ⟶ X`, mirroring `tensorObj_restrict_iso` verbatim with
`Monoidal.tensorObj M.val N.val` → `PresheafOfModules.dual M.val`.

**Steps 1–3 + H1 all TYPECHECK** (`lean_diagnostic_messages` clean except the residual sorry).
The residual goal, verified live with `lean_goal`:
```
⊢ (PresheafOfModules.pushforward β).obj M.val.dual ≅ (M.restrict f).val.dual
```
`change`-confirmed (live, via `lean_multi_attempt`) defeq to:
```
⊢ (PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)
    ≅ PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)
```
— exactly the "pushforward commutes with the presheaf dual" residual iter-228/229 predicted.

**The shared root `overSliceSheafEquiv` does NOT discharge this — outcome (ii), NOT (i).**
Three independent mismatches, all confirmed live:
1. **Sheaf vs presheaf.** Root codomain is `Sheaf …`; the residual is `PresheafOfModules …`
   (Step 3 stripped the outer sheafification). `overSliceSheafEquiv` is not even in scope at the
   site and is type-incompatible (`exact (… overSliceSheafEquiv …)` → "Unknown constant").
2. **Fixed value-cat vs varying-ring module fibration.** Root is parametric in a FIXED `A`; the
   residual is a `ModuleCat`-over-`𝒪_Y(V)` iso. The per-`V` module action is precisely what the
   fixed-value-cat equivalence does not transport for free — the module fibration cost
   strategy-critic ts230 named.
3. **Whole-`U` slice site vs per-open slices.** `dual` uses `restr W = pushforward₀ (Over.forget W)`
   (slice over a single `W`); the root is over `(gt X).over U`, the whole-`U` slice site.

**Conclusion: C wired ⇒ (ii). The substrate grew a 4th time. 80→79 did NOT land.** This is the
HARD-TRIPWIRE condition: no further autonomous infra round is warranted on this lane.

Full statement of the genuine missing ingredient (the presheaf+module-level per-`V` slice
internal-hom comparison + ring-iso transport) written to
`informal/dual_restrict_iso.md`.

## SECONDARY / assembly — NOT attempted
- `homOfLocalCompat` (A-engine, value cat `Type`): directive gates it behind "only if C is
  clean". C is NOT clean (ii). NOTE for the planner: the A-engine is the case the sheaf root
  genuinely DOES serve (value cat `Type`, no varying-ring transport) — it is independently
  buildable, but on its own it cannot close `exists_tensorObj_inverse`, which needs C too.
- `dual_unit_iso : dual 𝒪 ≅ 𝒪`: probed; it also routes through the `Over`-slice `restr`
  machinery (`internalHom 𝟙_ 𝟙_ ≅ 𝟙_`, needing `pushforward₀ (Over.forget W)` to preserve the
  unit + `End_{slice}(𝟙_) ≅ R(W)`), with the namespace shadow (`_root_.PresheafOfModules`
  required inside `Scheme.Modules`). Not a quick orthogonal win, and cannot move 80→79 while
  `dual_restrict_iso` is (ii)-blocked. NOT committed (would risk a sorry).
- `exists_tensorObj_inverse` (L2210): unchanged — blocked on the C-bridge above.

## Informal agent
`MOONSHOT_API_KEY`/Kimi present but returns **401 Invalid Authentication**; no other relevant
key set (`DEEPSEEK`/`OPENROUTER`/`OPENAI`/`GEMINI_API_KEY` absent). Informal agent UNAVAILABLE.

## Why I stopped — Partial progress (the C-wiring diagnostic, as the directive defines it)
This is the **valid tripwire outcome**, not premature termination. The iter-230 directive made
the session's deliverable the binding C-probe with an explicit instruction: *"State explicitly
which of (i)/(ii) you hit. If (ii): STOP at a precise decomposition — do NOT stub, do NOT pin a
sorry, do NOT force a shortcut."* I executed the probe to completion (Steps 1–3+H1 verified to
typecheck; residual goal extracted and `change`-confirmed live; root incompatibility confirmed
live on all three axes) and determined **(ii)**. Committing a sorry-bearing `dual_restrict_iso`
or `dual_isLocallyTrivial` would directly violate the directive; so the file is left at its
clean 3-sorry GREEN state and the finding is documented in code (the diagnostic block) and in
`informal/dual_restrict_iso.md`.

Honest accounting: **no sorry was closed (80→80 expected-fail per the tripwire), and no new
compiling sub-lemma was landed** — the two candidate sub-lemmas (`dual_unit_iso`, the
presheaf-slice comparison) both bottom out on the same `Over`-slice + varying-ring-module build
that constitutes the (ii) blocker, so neither is a cheap orthogonal win, and the directive
forbids pinning their sorries. The measurable progress is the **decisive (i)/(ii)
determination** (previously only suspected; now empirically settled with live goal extraction)
plus the precise decomposition of the required new build.

## Recommendation to the planner (HARD TRIPWIRE per progress-critic ts230)
80→79 did not land; C wired = (ii). Per the directive this is the tripwire: do NOT plan iter-231
as another infra round. **Escalate the fork to the USER** — either lift the ROUTE C PAUSE to
pivot `Pic⁰` to the divisor/Abel–Jacobi route (discarding the substrate), or explicitly sanction
the presheaf+module per-`V` slice-internal-hom comparison (`informal/dual_restrict_iso.md`,
~150–300 LOC, real `Over.map` coherence risk that thinness does NOT kill here) as a multi-iter
sub-build. The A-engine `homOfLocalCompat` (value cat `Type`) remains the one piece the existing
sheaf root cleanly serves, but it cannot close `exists_tensorObj_inverse` alone.

## Dead-end warnings (do NOT retry)
- Do NOT try to close `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)` with
  `overSliceSheafEquiv`: type-incompatible (Sheaf vs PresheafOfModules) AND value-cat-fixed vs
  varying-ring-module. Confirmed live ("Unknown constant" + the structural argument).
- Do NOT expect Steps 1–3+H1 to be the blocker — they mirror `tensorObj_restrict_iso` and
  typecheck unchanged. The whole cost is the post-H1 presheaf-dual-commutation residual.
- Do NOT pin a sorry on `dual_restrict_iso`/`dual_isLocallyTrivial`/`dual_unit_iso` this lane:
  the directive forbids it and it does not advance 80→79.
