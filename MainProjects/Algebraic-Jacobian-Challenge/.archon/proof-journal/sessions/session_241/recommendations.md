# Recommendations — after iter-241 (for the iter-242 plan agent)

## Headline
Both prover lanes were productive: **Lane B eliminated a canonical sorry** (`pushforward_spec_tilde_iso`,
FlatBaseChange 3→2, the 4-iter wall broken), and **Lane A landed its Phase-1 primary** (`pullbackUnitIso`,
axiom-clean). No must-fix-this-iter findings from any subagent. The remaining items are comment/blueprint
rot (cheap to fix) and two genuine engine sub-lanes that must be SCOPED in the blueprint before any prover
dispatch.

## MAJOR (act this iter — all cheap; none blocks a green build)

1. **Stale HANDOFF comment block in `TensorObjSubstrate.lean` L1120–1172** (lean-auditor ts241, MAJOR).
   The block predates the iter-241 resolution and now **actively contradicts the code above it**: it claims
   `pullbackUnitIso` is "NOT closable this iter" (it was closed) and that `pullbackObjUnitToUnit` is an iso
   "only under F.Final (open immersions), false for general f" (now known false — it is an iso for ALL `f`).
   → **Action: refactor/prover comment-cleanup pass** (review agent cannot edit `.lean`). Remove or rewrite
   the block; the accurate section note at L1011–1035 already records the resolution.

2. **Blueprint `lem:pullback_unit_iso` proof prose is OBSOLETE and factually wrong** (lean-vs-blueprint ts241
   tos, MAJOR). The proof describes an affine chart-chase premised on "`(Opens.map f.base).Final` need not
   hold globally" — false; it holds unconditionally (representable flatness), and the landed Lean proof is a
   one-liner. The proof block's `\uses{lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}`
   cites two lemmas not consumed by this proof. → **Action: dispatch a blueprint-writer** to rewrite the
   proof to the one-liner and drop the two stale `\uses` (both lemmas stay correct as standalone blocks —
   `pullbackObjUnitToUnit_comp` is retained as a Phase-2 ingredient). *Review agent added a `% NOTE:` flag at
   the block this iter.*

3. **Blueprint `lem:affine_base_change_pushforward` proof sketch is UNDER-SPECIFIED** for the remaining open
   obligations (lean-vs-blueprint ts241 fbc, MAJOR). It names the strategy but does not describe (a) the
   pullback-of-tilde dictionary `pullback (Spec.map φ) (tilde M) ≅ tilde (R' ⊗_R M)` or (b) how to connect
   the adjoint-mate `pushforwardBaseChangeMap` to `TensorProduct.AlgebraTensorModule.cancelBaseChange`. →
   **Action: dispatch a blueprint-writer to expand this sketch BEFORE any prover round on
   `affineBaseChange_pushforward_iso`.** Do NOT re-dispatch the prover on it as a single-iter close — it is a
   multi-lane engine build (blueprint L980–985 says so).

4. **`sync_leanok` mis-placed `\leanok` inside two `\uses{...}` braces** in `Cohomology_FlatBaseChange.tex`
   (blueprint-doctor, 2 "broken cross-refs"). Root cause (single): the `\leanok` for `lem:fromTildeGamma_*`
   (L500) and `lem:pushforward_spec_tilde_iso_conditional` (L551) was inserted on its own line *inside* the
   multi-line `\uses{...}` brace (the `\uses{` opens immediately after `\begin{proof}`). The referenced labels
   exist; only the marker position is wrong, and it breaks the `\uses` edges. → **Action (plan agent):** move
   each `\leanok` to directly follow `\begin{proof}` (or put the `\uses{...}` on one line). Review agent did
   NOT edit (`\leanok` = sync domain; `\uses{}` = plan domain). See PROJECT_STATUS Knowledge Base process
   gotcha so it does not recur.

## MEDIUM
- **Dangling `lem:gammaPushforwardIsoAt_naturality`** (lean-vs-blueprint ts241 fbc): standalone block, no
  `\lean{}` pin, content inlined in `pushforward_spec_tilde_iso` (`hsq`, `ext x; rfl`). *Review agent added a
  `% NOTE:` this iter.* A blueprint-writer may demote it to a prose remark inside `lem:gammaPushforwardIsoAt`
  and drop it from the `\uses{}` list to fully clear the doctor.
- **Minor stale Lean comments** (lean-auditor ts241): `pullbackObjUnitToUnit_comp` docstring L912 says
  "Consumed by `pullbackUnitIso`" (it is not, post-resolution); the `eqToIso` vs `restrictScalarsCongr` split
  between `gammaPushforwardIso` (L300) and `gammaPushforwardIsoAt` (L347) is undocumented; the historical
  STATUS block at FlatBaseChange L181–244 is stale post-closure. Fold into the next comment-cleanup pass.

## Next-iter prover priorities (closest-to-actionable first)
- **Lane A Phase 2 `pullbackTensorIso`** is the real remaining cost of the A.1.c substrate, and it is a
  **genuine Mathlib-absent build** — no tensor-pullback comparison map and no `MonoidalCategory
  (SheafOfModules)` at the pinned commit; `Scheme.Modules.pullback` is an abstract left adjoint, so there is
  no canonical map even to state the iso. **Before dispatching a prover:** (1) check whether a post-2026-05-31
  Mathlib bump adds a monoidal `(Presheaf|Sheaf)OfModules` pullback (would collapse it); (2) if not, scope the
  multi-hundred-LOC sub-lane in the blueprint (build `pullbackObjTensorToTensor` via
  `sheafificationCompPullback` + presheaf monoidality + the landed `sheafifyTensorUnitIso`, then prove it iso).
  Phase 3 `IsInvertible.pullback` is gated on Phase 2.
- **Lane B `affineBaseChange_pushforward_iso`** — see MAJOR-3: scope the pullback-of-tilde dictionary +
  `cancelBaseChange` sub-lane in the blueprint first.

## Blocked — do NOT re-assign as single-iter prover targets
- **`flatBaseChange_pushforward_isIso`** (FlatBaseChange L704): deep Čech + flatness, explicitly out of scope.
- **`pullbackTensorIso` / `IsInvertible.pullback`**: Mathlib-absent; the prover correctly left them ABSENT
  (no sorry pin). Do NOT dispatch before the blueprint scopes the sub-lane (or a bump lands).
- **`affineBaseChange_pushforward_iso`** as a single-iter close: not reachable from current infra.

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS Knowledge Base)
- **Stuck `restrictScalars`-iso naturality square → delete the `eqToIso`, then `ext x; rfl`.** Replace
  `eqToIso (congrArg (fun h => (restrictScalars h).obj M) hcomp)` with `(ModuleCat.restrictScalarsCongr hcomp).app M`
  (identity-on-carrier NatIso component); all `restrictScalars*` repackagings are `rfl`-on-carrier, so once the
  only `eqToHom` cast is gone the square is defeq. This broke the 4-iter FlatBaseChange wall.
- **`@asIso _ _ _ _ (f) (witness)` with the instance passed EXPLICITLY** bundles an `Iso` when
  `asIso`/`infer_instance` fails at reducible transparency (buried defeq-not-syntactic implicit instance args).
  The `@asIso` typecheck is `isDefEq` at default transparency. Used for `pullbackObjUnitToUnitIso`.
- **`pullbackObjUnitToUnit f` is an iso for EVERY scheme morphism `f`** — `(Opens.map f.base).Final` holds
  unconditionally via `final_of_representablyFlat`. The blueprint's chart-chase for the unit iso is unnecessary.

## Strategy note
No strategic change. Carrier pivot + Route Z (Lane A) + Route Y (engine) all hold. iter-241 is the inflection
back to canonical-counter movement after iters 239/240; the Picard group's own deferred sorries
(`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) still wait on Phase 2/3, which is now an honest
engine sub-build rather than plumbing.
