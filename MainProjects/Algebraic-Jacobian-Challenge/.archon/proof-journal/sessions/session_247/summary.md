# Session 247 (iter-247) — review summary

## Metadata
- **Session / iter:** 247 (review of iter-247).
- **Lanes:** 2 prover lanes, both model `opus`.
  - Lane TS — `Picard/TensorObjSubstrate.lean`, mathlib-build, critical path (η-bridge D2').
  - Lane RPF — `Picard/RelPicFunctor.lean`, prove (rewire bridges to upstream substrate).
- **Architecture-first refactor (plan-side, this iter):** the `TensorObjSubstrate ↔ RelPicFunctor`
  import cycle was broken (dependency now `LineBundlePullback → TensorObjSubstrate → RelPicFunctor`),
  enabling Lane RPF to cite the real upstream substrate.
- **Sorry counts (touched files):**
  - TensorObjSubstrate.lean: **1 → 1** (only the pre-existing `exists_tensorObj_inverse` L670/L692; 2 new
    axiom-clean decls added, no new pin).
  - RelPicFunctor.lean: **local 4 → 0** (the 4 iter-246 stopgap typed-`sorry` bridges all eliminated; the
    sole remaining cone sorry is the upstream `Modules.exists_tensorObj_inverse`).
- **Net project sorry:** **−3** (RPF stopgap bridges retired; the iter-246 +3 regression is reversed).
- **Build:** GREEN both files. `sync_leanok` ran at sha `1dbd1b97`, **+21 / −1** across
  `Picard_RelPicFunctor.tex` + `Picard_TensorObjSubstrate.tex`.

## Axioms re-verified first-hand (review agent)
- `Modules.presheafUnit_comp_map_eta` → `{propext, Classical.choice, Quot.sound}` ✓
- `Modules.isIso_sheafifyEta_of_unitSquare` → `{propext, Classical.choice, Quot.sound}` ✓
- `PicSharp.isLocallyTrivial_unit` → `[]` (axiom-FREE) ✓
- `PicSharp.addCommGroup` → `{propext, sorryAx, Classical.choice, Quot.sound}` — `sorryAx` solely from
  upstream `exists_tensorObj_inverse`, as documented ✓
- The `lean_verify` "opaque" flag at L465 is the WORD in a prose comment (verified L462–465) — not laundering.

---

## Lane TS — η-bridge D2' (PARTIAL, genuine convergence)

The whole comparison-iso stack funnels (since iter-245/246) through one residual: the η-bridge
`IsIso (a_Y.map (η (pullback φ')))`. This iter landed **2 axiom-clean declarations** that reduce that
residual to a single morphism equation:

- **`presheafUnit_comp_map_eta` (~L1495)** — the presheaf-side mate identity
  `adj.unit.app 𝟙_ ≫ pushforward.map (η (pullback φ')) = ε (pushforward φ')`, = Mathlib's
  `Adjunction.unit_app_unit_comp_map_η` instantiated at the `PresheafOfModules` pullback-pushforward
  adjunction. The non-trivial content is that it TYPECHECKS for this adjunction (forces the project's
  `presheafPushforwardLaxMonoidal` / `presheafPullbackOplaxMonoidal` to be `Adjunction.IsMonoidal`-compatible);
  needs `haveI : (pushforward φ').IsRightAdjoint` in scope so the `OplaxMonoidal (pullback φ')` instance fires.
  This is the genuinely-new mathematical driver (unit-side analog of `pullbackObjUnitToUnit_comp`).
- **`isIso_sheafifyEta_of_unitSquare` (~L1518)** — given the commuting square
  `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η F) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit f.toRingCatSheafHom`,
  concludes `IsIso (a_Y.map (η F))`. Mechanical: `pullbackObjUnitToUnit φ` iso via `isIso_pbu_of_final`
  (`Opens.map f.base` always `Final`), `pullbackValIso`/`sheafifyUnitIso` isos, rearrange via
  `Iso.inv_comp_eq`/`Iso.eq_comp_inv`, then `IsIso.comp_isIso'`.

**Not closed:** the square equation `hsq` itself (the hypothesis of `isIso_sheafifyEta_of_unitSquare`). The
prover transposed it across `pullbackPushforwardAdjunction.homEquiv.injective` to the concrete pushforward-side
identity (**) and captured a **paper-complete 7-step telescoping recipe** (in the task result), each step a
named Mathlib lemma (`unit_naturality`, `homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`,
`leftAdjointOplaxMonoidal_η`, `presheafUnit_comp_map_eta`). It is NOT a Mathlib gap — it is a long,
ordered, defeq-friction-laden manual mate-telescope across three nested adjunction layers. `simp` /
`aesop_cat` / targeted `simp only` with the glue lemmas make no progress (preconditions need prior ordered
massaging — confirmed via `lean_multi_attempt`). The prover left it unpinned (mathlib-build forbids a sorry
pin) rather than half-built. **No new sorry; no laundering.** lvb-ts: chapter is honest — D2'/D3'/D4' are
correctly NOT `\leanok`-marked.

### Reversing signal status (Lane TS) — ARMED, approaching its limit
iter-247 plan armed: *"if the η-bridge returns ANOTHER 'named concrete residual' PARTIAL (no goal closure,
no D3' brick), the sorry-stasis exemption is EXHAUSTED → iter-248 must classify STUCK and escalate to the
user (do NOT pivot a 4th time)."* **This iter's outcome is exactly a named-residual PARTIAL with no goal
closure** — D2' did NOT close; instead the residual was reduced one more level (square equation) with 2
helper bricks. The diagnostic was "did the η-goal close OR a D3' brick land?" → **neither.** The signal is
now at its trigger threshold; iter-248 must treat one more named-residual PARTIAL as STUCK.

---

## Lane RPF — bridge rewire (SOLVED locally)

With the import cycle broken, the prover eliminated the 4 iter-246 stopgap bridges and 5 local pure-Mathlib
substrate copies, retargeting ~10 use sites to upstream `Modules.*` citations:
- `pTensor_isLocallyTrivial` → `Modules.tensorObj_isLocallyTrivial` (deleted; cited).
- `pAssoc` → `Modules.tensorObj_assoc_iso` (deleted; cited).
- `exists_pTensor_inverse` → `Modules.exists_tensorObj_inverse` (deleted; cited — the single tracked
  upstream reverse bridge).
- `isLocallyTrivial_unit` → **real axiom-FREE proof** on an affine chart via
  `restrictFunctorIsoPullback ≪≫ pullbackUnitIso`, side-stepping the iter-246 `IsIso (pullbackObjUnitToUnit)`
  synthesis quirk by routing through the proven `pullbackUnitIso`.
- `relTensorObj` → `Modules.tensorObjOnProduct` (the decl the refactor moved into this file); `relNeg`,
  `relAdd`, and all `addCommGroup` group axioms → upstream unitors/braiding/associator/inverse.

`PicSharp.addCommGroup` is now a real `AddCommGroup` whose only `sorryAx` is the upstream
`exists_tensorObj_inverse` (verified). Local sorry 4 → 0. This meets the plan's "4 → 1" target (1 = upstream
cone) and the progress-critic ts247 CONVERGING monitoring condition.

### Caveat surfaced by both review subagents (NOT new damage, but now mis-documented)
The **functor layer above `addCommGroup` is still entirely placeholder** and PRE-EXISTING:
- `PicSharp` = `(Functor.const _).obj (AddCommGrpCat.of PUnit)` — constant functor at the trivial group.
- `PicSharp.functorial` = `0` (zero `AddMonoidHom`).
- `PicSharp.presheaf` = `PicSharp _C` (re-exports the placeholder); `PicSharp.etSheaf` sheafifies it.

These are honest-deferred (the blueprint has NOTE blocks documenting the divergence) and gated on Lane TS D4'
(`pullback_tensor_iso_loctriv`), which is not yet landed. **What IS an iter-247 issue:** the RPF `.lean`
docstrings (L30–49, L477–490, L524–535) now cite the *now-resolved* `addCommGroup` sorry / the
`Scheme.Modules` monoidal-structure gap as the active gate — **factually stale** after this iter's landing.
lean-auditor flagged 2 must-fix + 3 major; lvb-rpf flagged the 4 placeholders must-fix. These are `.lean`
prose fixes (prover domain) — see recommendations.

---

## Blueprint structural issue — `\leanok` inside `\uses{}` (PERSISTENT, now 4 occurrences)

Blueprint-doctor flagged 4 "broken cross-refs". **First-hand finding: all 4 target labels EXIST.** The
breakage is a stray `\leanok` lodged INSIDE the multi-line `\uses{}` braces of a proof block, which the
leanblueprint parser folds into the first label after it, producing an unmatchable token:
- `Picard_RelPicFunctor.tex` L143–150 (proof of `lem:rel_pic_sharp_groupoid`) — target
  `thm:relative_pic_quotient_well_defined` exists at `Picard_LineBundlePullback.tex:331`.
- `Picard_TensorObjSubstrate.tex` L1462–1464 (`lem:tensorobj_assoc_iso` proof) — target
  `lem:islocallyinjective_whiskerleft_via_stalk` exists (L2223).
- `Picard_TensorObjSubstrate.tex` ~L3862 (`IsInvertible.tensorObj` proof) — `lem:tensorobj_comm_iso` exists (L1593).
- `Picard_TensorObjSubstrate.tex` ~L3970 (`IsInvertible.inverse_unique` proof) — `lem:tensorobj_assoc_iso_invertible`
  exists (L3747).

This is the SAME class of bug iter-246 review already documented (PROJECT_STATUS L4239) and prescribed a
blueprint-writer fix for — it was NOT fixed and has spread from 1 RPF occurrence to 4 across both chapters.
**Actor deadlock:** only `sync_leanok` adds/removes `\leanok` (so this was sync-inserted at a wrong line
offset, landing mid-`\uses{`); the blueprint-writer is forbidden from touching `\leanok`; the review agent is
forbidden from touching `\leanok`. The correct fix (per lvb): *remove* the embedded `\leanok` (these proofs
are sorry-containing, so no proof-block `\leanok` is even warranted) and reflow the `\uses{}`. This now needs
explicit plan-agent attention — see recommendations (escalated).

The review agent did NOT touch any `\leanok` (constraint + precedent).

---

## Blueprint markers updated (manual)
- None. No `\mathlibok` applicable (the 2 new TS decls are project proofs, not Mathlib re-exports). No
  `\lean{...}` renames (the moved `tensorObjOnProduct` kept its fully-qualified name, so its pin still
  resolves). No `\notready` present in the touched chapters. The `\leanok`-in-`\uses` bugs are sync-owned —
  NOT touched (flagged for plan/writer/escalation instead).

## Subagent reports (full reports linked; do not re-read raw)
- `task_results/lean-auditor-iter247.md` — 2 must-fix (RPF stale module-header state claim L32–34;
  `PicSharp` excuse-comment "placeholder" + weakened-wrong body L477), 3 major, several minor.
- `task_results/lean-vs-blueprint-checker-rpf-iter247.md` — 4 must-fix (PicSharp/functorial/presheaf/etSheaf
  placeholders), 1 major (`\leanok`-in-`\uses`), proof-sketch Step 2–4 divergence (major).
- `task_results/lean-vs-blueprint-checker-ts-iter247.md` — NO must-fix; chapter honest. Minor: 3
  `\uses{\leanok}` syntax bugs, missing `\leanok` on `lem:tensorobj_unit_iso` (sync miss), 2 new supplements
  unpinned.

## Key findings / recommendations (see recommendations.md for actions)
1. Lane TS reversing signal is at threshold — one more named-residual PARTIAL on D2' = STUCK + user escalation.
2. The `\leanok`-in-`\uses` bug is persistent (2 iters) and in actor-deadlock — needs plan-agent escalation.
3. RPF `.lean` docstrings are factually stale post-addCommGroup — schedule a prover comment-fix on next RPF touch.
4. RPF functor layer (PicSharp/functorial/presheaf/etSheaf) is placeholder, gated on Lane TS D4' — do NOT
   dispatch RPF to "finish" it until D4' lands.
