# Pending Tasks
<!-- Current open-task set, last-known state only. Per-attempt detail → iter sidecars. -->

## Seed 1 — `pullbackTensorIsoOfLocallyTrivial` (D4′) — `TensorObjSubstrate.lean` — DONE iter-042 → see task_done.md
DELIVERED: root GREEN (`lake build` EXIT 0, 8321 jobs), sorry-free. K1 `hδ` via `isIso_oplaxδ_of_conj` ←
`pushforward_mu_appIso_collapse` (δ-conjugation on `deltaConjOfMuComparison`), SUPERSEDING the phantom
`pullbackTensorMap_presheafDelta_eq`/`pullbackTensorComparison`. K1 witness PUBLIC (L4770). iters 039–041
"delivered" were LSP stale-green — `lake build` is the only authority. Blueprint reconciled iter-043.

## ROOT gap-fill — `conjugateEquiv_restrictFunctorComp_inv` (`TensorObjSubstrate.lean`) — DONE iter-048 → see task_done.md
CLOSED public, axiom-clean (lake EXIT 0). iter-046 "irreducible" verdict overturned (abstract
`leftAdjointCompIso`-on-`pushforwardComp` route; NEVER `ext` the conjugate-headed goal). Now consumable by terminal.

## Terminal — `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`) — `TensorObjInverse.lean` — GREEN-mod-sorry (4); ENGINE DONE, S2 CLOSED, S4b active (iter-055)
STATE: **B1/B2 ENGINE LAYER COMPLETE** (B2 iter-050; B1-crux iter-053). **S2 CLOSED iter-054** (5→4, B1-route,
sorry-free). Remaining 4 sorries: S3 (L1099), S4a (L1123), S4b (L1139), `trivialisation_restrict_compat` (L1270).
- **iter-055 PRIMARY = S4b `tensorObj_unit_iso_restrict_compat` (L1139), via the CORRECTED bespoke unitor route.**
  The prior S4b blueprint route (through Bridge B1 / `pullbackTensorMap`) was MATHEMATICALLY WRONG:
  `tensorObj_unit_iso` (root L310) = `sheafification.mapIso (λ_ 𝟙_) ≪≫ counit`, NOT pullback-based (unlike
  `tensorObj_restrict_iso`, root L477, which IS — why B1 applied to S2 not S4b). The iter-054 prover correctly hit
  this wall. Corrected iter-055 (analogist `analogies/s4b-unitor.md` → blueprint-writer rewrite → blueprint-reviewer
  HARD GATE PASS). Route: peel the sheafify+counit form → INNER presheaf-unitor seam (Mathlib
  `Functor.Monoidal.map_leftUnitor` SHAPE only, no monoidal instance; δ-leg=S2 proven L1027, η-leg=S4c proven L1146)
  + OUTER sheafify–counit seam (formal, `toSheafify`/`mapIso`/counit naturality). Reuse iter-054's 9 helpers +
  whnf-seam idiom. progress-critic iter-055: CONVERGING. If THIS (first correct-route) pass stalls → effort-break
  inner vs outer seam next iter.
- **S4c** `trivialisation_uIota_restrict_compat` — CLOSED iter-041, sorry-free (transitively on B2).
- **S3** (L1099) / **S4a** (L1123) — DUAL FLANK, genuinely BLOCKED (iter-054 confirmed): the "dual analogue of B1"
  (`pullbackDualMap`/internal-hom base-change cone) does NOT exist (grep empty). Strategy decision (build dual cone
  vs analogist's `Functor.Monoidal (pullback φ)` refactor, which would supply the dual cone too) deferred until S4b
  lands. Do NOT prove this iter.
- **`trivialisation_restrict_compat`** (L1270) — telescope of the 5 squares; only after they close. DEAD probes:
  `restrictFunctorComp.hom.naturality φ` (morphism, iter-040); subst/rcases on `hVU:V≤U`, `simp[restrictIsoUnitOfLE]`,
  `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`. `erw`/term-`exact` not `rw` ([[tensorobjinverse-red-at-source]]).
- **Cocycle `exists_tensorObj_inverse`** — CLOSED modulo `trivialisation_restrict_compat` (iter-038, green). Full
  iso-algebra reduction in-code; `have ht` uses term-mode `exact` (every `rw`/`simp` of a category lemma misses on
  the defeq-not-syntactic SheafOfModules `≫`). NEVER sheafify-the-eval (d.2 dead-end). DEAD: `rfl`, `simp
  [tensorObjIsoOfIso_trans/refl, dualIsoOfIso_trans/refl]` (iso-level, goal is `.val.app`-section level).
- **Residual B** — CLOSED iter-026. Recipe `rem:dual_discharges_inverse`. Non-critical branch (seed-3
  `map_add` rides seed-1→K1).

## Scaffold target — seed 3 `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)
STATE: not in Lean. Gated on seed-1 (map_add ← comparison iso) + `exists_tensorObj_inverse` (group inverse).

## Tracked debt
- Coverage: 5 iter-019 helpers are `private` generic plumbing (no node owed) except
  `sheafificationCompPullback_comp_inv` (pinned `lem:pullback_val_iso_comp_scpb`). Bulk ~99 `lean_aux`
  decls remain; scheduled `Coverage + file-split` phase.
- File-split: `TensorObjSubstrate.lean` >3600 LOC (over 1000-LOC policy) — split scheduled after the
  active seed-1 lane lands (avoid disrupting the warm file).

## Completeness audit (user-requested) — DONE
3-seed cone COMPLETE vs AJC: 108/108 nodes, cone sizes 52/36/32 exact. Diffs = AJC dead-code Lan block
(not ported) + out-of-scope Route-A. Nothing required missing.
