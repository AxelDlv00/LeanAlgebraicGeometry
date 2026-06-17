# Recommendations for the next plan iteration (post-iter-247)

## CRITICAL / HIGH

### H1. Lane TS D2' η-bridge — the reversing signal is at its trigger threshold
iter-247 armed (plan.md): *"if the η-bridge returns ANOTHER named-residual PARTIAL (no goal closure, no D3'
brick), the sorry-stasis exemption is EXHAUSTED → iter-248 must classify STUCK and escalate to the user."*
**This iter's outcome is exactly that shape** — D2' did NOT close; the residual was reduced one further level
(to the square equation `hsq`) with 2 axiom-clean helper bricks (`presheafUnit_comp_map_eta`,
`isIso_sheafifyEta_of_unitSquare`), but neither the η-goal closed nor a D3' brick landed.
- **Action:** the next dispatch of Lane TS may make ONE bounded attempt at the square `hsq` via the prover's
  paper-complete 7-step telescope (it is documented, all lemmas exist, hardest sub-step is #3 — the
  composite-adjunction `homEquiv` factorisation; verify the exact form of `(adj1.comp adj2).homEquiv` via
  `lean_hover_info` on `Adjunction.comp` first). **If that attempt returns another named-residual PARTIAL
  with no goal closure, classify the route STUCK and escalate to the user** (run progress-critic to confirm;
  do NOT pivot the route a 4th time, do NOT dispatch a 5th helper round). The diagnostic for STUCK is "did
  `hsq` close OR did D2' close?" — not "did a sorry disappear."
- **Do NOT** re-dispatch D2' as "land another reduction brick" — that is the churn the signal guards against.

### H2. `\leanok`-inside-`\uses{}` — persistent (2 iters), now 4 occurrences, in actor deadlock
Blueprint-doctor flagged 4 "broken cross-refs"; **all 4 target labels exist** — the breakage is a stray
`\leanok` lodged inside multi-line `\uses{}` braces (sync-inserted at a wrong line offset):
- `Picard_RelPicFunctor.tex` L143–150 (`lem:rel_pic_sharp_groupoid` proof) → `thm:relative_pic_quotient_well_defined`
  (exists `Picard_LineBundlePullback.tex:331`).
- `Picard_TensorObjSubstrate.tex` L1462–1464 (`lem:tensorobj_assoc_iso` proof) → `lem:islocallyinjective_whiskerleft_via_stalk`
  (exists L2223).
- `Picard_TensorObjSubstrate.tex` ~L3862 (`IsInvertible.tensorObj` proof) → `lem:tensorobj_comm_iso` (exists L1593).
- `Picard_TensorObjSubstrate.tex` ~L3970 (`IsInvertible.inverse_unique` proof) → `lem:tensorobj_assoc_iso_invertible`
  (exists L3747).

iter-246 review already documented this gotcha (PROJECT_STATUS L4239) and prescribed a blueprint-writer fix —
**it was not done and the count grew 1 → 4.** The actor deadlock: `sync_leanok` owns `\leanok` add/remove
(but cannot strip a `\leanok` nested inside `\uses{}` — it only scans expected statement/proof positions);
the blueprint-writer is forbidden from typing `\leanok`; the review agent is forbidden from touching it.
- **Action (pick one, explicitly):**
  (a) Dispatch a blueprint-writer with a directive to **reflow these 4 proof-block `\uses{}` onto a single
  line and DELETE the stray `\leanok` token** — frame it as a LaTeX-syntax repair of a corrupted `\uses{}`
  list, not a marker edit (the proofs are sorry-containing, so no proof-block `\leanok` is warranted; deletion
  is correct). This is the lvb-recommended fix. OR
  (b) If the writer's `\leanok`-prohibition makes (a) untenable, surface to the USER (USER_HINTS / a TO_USER
  note) that `sync_leanok`'s insertion logic mis-places markers when `\uses{` is the first multi-line element
  of a proof, and either the tooling or a manual edit is needed.
  **Do not let this slide a 3rd iter** — every iter it persists, 4 dependency edges are missing from the
  blueprint graph and the doctor re-warns.

### H3. RPF `.lean` docstrings are factually stale after the iter-247 `addCommGroup` landing
lean-auditor (2 must-fix + 3 major) and lvb-rpf both flag: `RelPicFunctor.lean` L30, L32–34, L44–49,
L477–490, L524–535 still describe "the single remaining file-local sorry is the `addCommGroup` body" and the
`Scheme.Modules` monoidal-structure gap as the active gate. After this iter, `addCommGroup` has a real body
(0 local sorry); the real gate for the functor layer is now Lane TS D4' (`pullback_tensor_iso_loctriv`) plus
the unbuilt `functorial`. The `PicSharp` docstring's word **"placeholder"** on a load-bearing definition is an
excuse-comment.
- **Action:** these are `.lean` prose (prover domain — review/plan cannot edit). Schedule a **prover
  comment-fix on the next RPF touch** (or a `refactor`-style comment sweep): correct the module header to say
  the local construction is complete modulo upstream `exists_tensorObj_inverse`, and restate the `PicSharp` /
  `functorial` / `presheaf` gates as "blocked on Lane TS D4' + the unbuilt `functorial` morphism action."

## MEDIUM

### M1. RPF functor layer (PicSharp / functorial / presheaf / etSheaf) is placeholder — do NOT "finish" it pre-D4'
These are PRE-EXISTING PUnit/zero placeholders (NOT iter-247 regressions). `functorial`'s `map_add` needs the
loc-triv comparison iso = **Lane TS D4'**, not yet landed. The prover correctly declined to fake it with a new
local sorry.
- **Action:** keep RPF on HOLD for the functor-layer upgrade until Lane TS lands D4'. When it does, build
  `functorial` as a real `AddMonoidHom` (`map_zero' ← pullbackUnitIso`, `map_add' ← pullback_tensor_iso_loctriv`),
  then re-point `PicSharp`/`presheaf` object maps off the `PUnit` placeholder. Do NOT re-dispatch RPF before
  then — there is no reachable local work left (lvb-rpf: "everything within this file's scope is done").

### M2. RPF proof-sketch Step 2–4 divergence (blueprint adequacy)
lvb-rpf (major): the `lem:rel_pic_sharp_groupoid` proof sketch (tex L143–239) describes a 4-step construction
(group on carrier → `π_T^*` homomorphism → setoid reconciliation → transport), but the Lean `addCommGroup`
realizes only Step 1 (the carrier `preimage_subgroup` IS the iso-class relation, so Steps 2–4's
quotient-by-`H_T` is a different future carrier). The divergence is documented only in a `%` comment.
- **Action:** dispatch a blueprint-writer to move the Step-2–4 caveat from the `%` comment into the visible
  proof sketch (so a future prover isn't misled), noting the current Lean realizes Step 1 only.

### M3. Two new TS supplements + moved `tensorObjOnProduct` — blueprint bookkeeping
- `presheafUnit_comp_map_eta` and `isIso_sheafifyEta_of_unitSquare` (axiom-clean, iter-247) implement
  η-bridge components the D2' sketch describes but lack `\lean{...}` pins. Pin them (or add `% NOTE:`) when
  D2' closes — premature pinning of staging lemmas is not urgent.
- `Modules.tensorObjOnProduct` moved to `RelPicFunctor.lean` (import-cycle fix) but its pin lives under the
  TensorObjSubstrate chapter and that chapter's `archon:covers` header does not list `RelPicFunctor.lean`.
  The fully-qualified name is unchanged so the pin still resolves; update the `covers:` header or add a
  `% NOTE:` to keep the chapter↔file mapping honest.
- `lem:tensorobj_unit_iso` statement block is missing `\leanok` although `tensorObj_left_unitor` /
  `tensorObj_right_unitor` are both sorry-free — a `sync_leanok` miss to watch (do not hand-fix).

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS Knowledge Base)
- **Presheaf-side mate driver via `Adjunction.unit_app_unit_comp_map_η`** — instantiate at the
  `PresheafOfModules` pullback-pushforward adjunction; needs `haveI : (pushforward φ').IsRightAdjoint :=
  (pullbackPushforwardAdjunction φ').isRightAdjoint` in scope so the `OplaxMonoidal (pullback φ')` instance
  fires. Yields the unit-side analog of `pullbackObjUnitToUnit_comp` axiom-clean.
- **Factor an `IsIso (composite)` conclusion into a lemma that takes the defining square as a hypothesis** —
  isolates the genuine content (the square equation) and makes the IsIso half mechanical
  (`Iso.inv_comp_eq`/`Iso.eq_comp_inv` + `IsIso.comp_isIso'`); avoids whole-composite `infer_instance` misses.
- **Trivialise the structure sheaf on an affine chart via `restrictFunctorIsoPullback ≪≫ pullbackUnitIso`** —
  side-steps the iter-246 `IsIso (pullbackObjUnitToUnit φ)` `Final`-instance synthesis quirk by routing
  through the proven `pullbackUnitIso`. Axiom-FREE.

## Do-NOT-retry / hold list
- Do NOT revive the general strong-monoidal pullback build (iter-244 D2/D3) — abandoned, off-path; D1 decls
  retained off-path only.
- Do NOT dispatch RPF to upgrade the functor layer before Lane TS D4' lands (M1).
- Do NOT re-dispatch Lane TS D2' as "land another reduction brick" (H1) — next PARTIAL without goal closure
  is STUCK + user escalation.
- Do NOT have a prover paper over `exists_tensorObj_inverse` with a local copy — it is the single tracked
  upstream reverse bridge.
