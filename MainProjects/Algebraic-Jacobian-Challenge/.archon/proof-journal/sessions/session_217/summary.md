# Session 217 (iter-217) — review summary

## Metadata
- **Session / iter**: 217 (review of iter-217 prover work).
- **Sorry count**: **81 → 80** (net **−1**). **First sorry elimination in 7 iters** — the
  iter-211→216 flat-at-81 window is broken.
- **File `Picard/TensorObjSubstrate.lean`**: code sorries **4 → 3**.
- **Target attempted**: BUILD the de-risked H1 ingredient (presheaf-level pushforward adjunction)
  and CLOSE the substrate linchpin `tensorObj_restrict_iso`. **MET.**
- **Build**: GREEN (`lake env lean … TensorObjSubstrate.lean` → exit 0; review re-ran first-hand).
- **Axioms**: `tensorObj_restrict_iso` `#print axioms` = `{propext, Classical.choice, Quot.sound}`
  — NO `sorryAx`, no project axiom (review re-verified via `lean_verify`; same for
  `pushforwardPushforwardAdj` and `restrictScalarsMonoidalOfBijective`). The `lean_verify`
  "opaque" warning at L1301 is the known docstring comment-scan false positive ("opaque" appears
  in a comment explaining the `let`-vs-`have` choice).

## The headline — the linchpin is closed, axiom-clean

After 6 consecutive net-zero iters (211–216) that each landed real axiom-clean bricks while the
critical-path residual stayed a `sorry`, iter-217 **closed the substrate linchpin
`tensorObj_restrict_iso`** (L1259). The planner's iter-217 bet — rebutting a `progress-critic`
STUCK verdict on the strength of a `mathlib-analogist` on-disk de-risking, and dispatching a
**fine-grained** round structured to drop the count rather than add another helper — paid off.

Two independent review subagents confirm the work is genuine:
- **lean-auditor ts217**: axiom-verified `tensorObj_restrict_iso` clean; "the closure proof has no
  `sorry`/`admit`/`native_decide`/axiom-weakening anywhere"; all 5 new declarations are "real
  proofs with no sorry routing"; file compiles with 0 errors. Verdict: *the prover work is genuine.*
- **lean-vs-blueprint-checker ts217**: the closed proof is an **exact 4-step match** to the
  blueprint's claimed route (H1 + H2) with no mathematical divergence.

## How the closure was achieved (per `attempts_raw.jsonl`, first-hand verified)

The blueprint's 4-step composite:
- **Step 1** `restrictFunctorIsoPullback f` (Mathlib) — reduce `restrict` to the abstract pullback.
- **Step 2** `SheafOfModules.sheafificationCompPullback` (Mathlib) — move pullback inside sheafification.
- **Step 3** `sheafification.mapIso` — strip the outer sheafification, leaving the presheaf goal
  `(pullback φ).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.
- **Step 4a — H1** (sole Mathlib-ABSENT ingredient): built three presheaf-level helpers by
  de-sheafifying `Sheaf/PushforwardContinuous.lean` (`pushforwardNatTrans` L840, `pushforwardCongr`
  L871, `pushforwardPushforwardAdj` L908), then closed `pushforward β ≅ pullback φ` in one call:
  `hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)` — the
  `pullbackPushforwardAdjunction` already exists (`Presheaf/Pullback.lean:50`), NOT re-derived.
- **Step 4b — H2**: `β` sectionwise-bijective ⇒ `restrictScalars β` strong monoidal via the new
  `restrictScalarsMonoidalOfBijective` (L958) + `isIso_of_isIso_app` (L940); compose with the
  Mathlib-`Monoidal` `pushforward₀OfCommRingCat` and take `Functor.Monoidal.μIso`.

### Three failed attempts that taught the gotchas (from the raw log)
1. **Hand-rolled triangle lemma** — `exact congr($h0 x)` with a local `h0 : (f.appIso U.unop).inv ≫
   … = 𝟙 _`: `lean_multi_attempt` returned `unexpected identifier`/failed forms. **Fix**: use
   Mathlib's `f.appIso_inv_app_presheafMap` → `exact congr($(f.appIso_inv_app_presheafMap U.unop) x)`.
2. **Opaque `set`/`have` bindings** — keeping `φR`/`β`/the adjunction as `set`/`have` makes
   `adj.unit` opaque and breaks the `congr` defeq on the unit/counit triangle goals. **Fix**: keep
   them as zeta-transparent `let` and INLINE `f.isOpenEmbedding.isOpenMap.adjunction` (matches
   Mathlib's sheaf `restrictAdjunction` style).
3. **Local `MonoidalCategory` on the `X.ringCatSheaf.obj` base** — produced a
   `⊗`-vs-`Monoidal.tensorObj` instance DIAMOND the **kernel rejects** (20 `declaration type
   mismatch` errors, captured in the raw log). **Fix**: build `μIso` over the SYNTACTIC
   `_ ⋙ forget₂` base (canonical instance), then `exact (μIso …).symm` against the goal whose base
   is only DEFEQ — `(pushforward β).obj M.val = (M.restrict f).val` is definitional.

The full recipe + gotchas are now in PROJECT_STATUS.md Knowledge Base (top Proof Pattern) and memory
`[[ts-assoc-flatness-gap]]` / `analogies/ts217.md`.

## 5 new reusable, axiom-clean declarations
| Decl | Line | Note |
|---|---|---|
| `PresheafOfModules.pushforwardNatTrans` (+`_app_app_apply`) | 840 | de-sheafify of sheaf `:154` — **upstream-PR candidate** |
| `PresheafOfModules.pushforwardCongr` (+`_hom/inv_app_app`) | 871 | de-sheafify of sheaf `:73` — **upstream-PR candidate** |
| `PresheafOfModules.pushforwardPushforwardAdj` | 908 | de-sheafify of sheaf `:226` — **upstream-PR candidate** |
| `PresheafOfModules.isIso_of_isIso_app` | 940 | sectionwise-iso ⇒ iso via `isoMk` |
| `PresheafOfModules.restrictScalarsMonoidalOfBijective` | 958 | presheaf-level H2 (pairs with iter-216's `…OfRingEquiv`) |

## Findings carried from review subagents (full reports linked)

### MUST-FIX this iter (for the plan agent — see recommendations.md)
- **`\leanok` inserted INSIDE two multi-line `\uses{...}` blocks** (`Picard_TensorObjSubstrate.tex`
  ~L1377-1379 and ~L2044-2046). Confirmed by blueprint-doctor, lean-vs-blueprint-checker ts217, and
  first-hand review. These are spurious proof-block `\leanok` on **sorry** bodies (`tensorObj_assoc_iso`
  and `addCommGroup_via_tensorObj` are both `sorry`) AND they corrupt 7 dependency edges
  (`lem:whisker_of_W`, `lem:islocallyinjective_whisker_of_W`, `lem:pullback_compatible_with_tensorobj`,
  `def:scheme_modules_isinvertible`, `lem:tensorobj_isoclass_commgroup`,
  `thm:relative_pic_quotient_well_defined`, `lem:rel_pic_sharp_groupoid`). **Review did NOT edit these**
  — `\leanok` is `sync_leanok`'s domain and the fix requires reflowing the `\uses{}` (prose); flagged
  for the plan agent / a blueprint-writer instead. Report: `task_results/lean-vs-blueprint-checker-ts217.md`.

### MAJOR
- **Stale `.lean` docstrings** (lean-auditor ts217): `tensorObj` (L987-991) and `tensorObj_functoriality`
  (L997-1007) docstrings falsely claim "the body is a typed `sorry`" — both bodies are real; the module
  Status block (L37-85) is 15 iters stale; `tensorObj_assoc_iso` docstring (L1115) says "iter-212 status
  (typed sorry)" but it's closed. (Prover-fixable next iter, not review's domain.)
- **5 new decls unreferenced in the blueprint** (lvb ts217): need `\lean{...}` pins; the first three are
  blueprint-PR candidates. (Plan agent / blueprint-writer.)
- **Blueprint prose/pin inconsistency** for `lem:islocallyinjective_whisker_of_W` (lvb ts217): prose says
  "declarations are being removed" but the `\lean{}` pin + Lean decl remain.
- **`@[implicit_reducible]` on the sorry-body `addCommGroup_via_tensorObj`** (L1414, lean-auditor ts217):
  a `def` (not `instance`) so not auto-synthesized, but the attribute makes it reducible — opacity/soundness
  risk if it ever enters an instance chain. Soundness watch.
- **17× deprecated `CategoryTheory.Sheaf.val`** (lean-auditor ts217): systematic; breaks when Mathlib
  removes the alias. Use `ObjectProperty.obj`. (Mechanical sweep, prover/refactor.)

## Blueprint markers updated (manual)
- None. `\leanok` is `sync_leanok`'s domain (ran this iter: sha `7d935493`, +9/−1). No `\mathlibok`
  applies (the 5 new decls are project-built de-sheafifications, not Mathlib re-exports). No stale
  `\notready` found. The malformed `\leanok`-in-`\uses` was deliberately NOT touched (flagged for the
  plan agent — see must-fix above).

## Notes (LOW)
- Minor linter items (lean-auditor ts217): `ext` unused pattern `r` at L309; 3 lines >100 chars at
  L1317-1319; unused `hM/hN/hP` in `tensorObj_assoc_iso` (intentional, matches blueprint pin).
- The blueprint-doctor report (`logs/iter-217/blueprint-doctor.md`) flagged exactly the two broken
  `\uses` edges above; no orphan chapters, no new `axiom`s.

## Recommendations for next session
See `recommendations.md`. Headline: the linchpin closure UNGATES the associator re-route
(`tensorObj_assoc_iso` onto the now-closed `restrict_iso`), after which the vestigial
`isLocallyInjective_whiskerLeft_of_W` (L600) can be deleted for a further count drop; then the
critical path is `exists_tensorObj_inverse` → `tensorObjIsoclassCommMonoid` →
`addCommGroup_via_tensorObj`. Fix the malformed `\uses{}` blocks first (must-fix).
