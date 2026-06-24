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

## Terminal — `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`) — `TensorObjInverse.lean` — GREEN-mod-sorry (3); ENGINE + Cone A DONE; remaining = Cone B-consuming S3/S4a + telescope
STATE: **B1/B2 ENGINE LAYER COMPLETE** (B2 iter-050; B1-crux iter-053). **S2 CLOSED iter-054.** **S4b
(= Cone A) CLOSED end-to-end iter-065**: L3 `pullbackUnitIso_whisker_eq_sheafify_eta_whisker` (central
leg = arg-1 q=𝟙 reuse of proven `sheafifyTensorUnitIso_hom_natural`) + bridge-3 assembly
`pullbackTensorMap_left_unitality`; keystone `image_collapse` + L2 closed iter-064. **3 sorries left:**
S3 `dual_restrict_iso_restrict_compat` (~L1099), S4a `dual_unit_iso_restrict_compat` (~L1123),
`trivialisation_restrict_compat` (~L1891).
- **S4c** `trivialisation_uIota_restrict_compat` — CLOSED iter-041, sorry-free (transitively on B2).
- **S3 / S4a — DUAL FLANK. iter-068 DIAGNOSIS (0 close): both bridges pinned to fixable causes;
  iter-069 CORRECTIVE applied.** dual-B1 `dual_restrict_iso_eq_comparison` DONE (rfl); B2 leg + ρ-cancel
  discharged; S3 reaches the exact `case e_β` residual. iter-068 pinned: **(b)** blocked by Sq1 being
  `private` (FIXED iter-069: refactor un-privated `sheafificationCompPullback_comp`+2 helpers in
  `TensorObjSubstrate.lean`, root EXIT 0); **(c)** blocked because the θ-cocycle could not typecheck —
  the iter-068 sheaf-level statement (middle θ at `M|_{ι_U}`) mismatched the pushforward codomain of
  `(pullback j)(θ_{ι_U})`. **iter-069 reframe (blueprint re-broken, HARD GATE PASS):** state (c) as the
  exact dual of the PROVEN `pullbackTensorMap_restrict` — middle θ at the PUSHFORWARD object
  `(pushforward β_{ι_U}).obj M.val`, reconciled by presheaf `pullbackComp`/`pushforwardComp(=refl)`,
  threaded through NEW **c.1** object-id iso `pushforwardObjValRestrictIso`
  (`(pushforward β).obj M.val ≅ (M|_f).val` = H1∘(RFIP;SCP).val) to land in the `M|_{ι_U}` form S3 wants.
  Chain now: dual-B1(DONE) → B2(DONE) → (b)[Sq1 now public, one-liner] → **c.1** objId (NEW, foundational,
  deps done) → **c.2** `presheafDualPullbackComparison_restrict` (cocycle) → S3 assemble → S4a.
  NOT monoidality; NOT `pullbackDualMap`. (c.2) proof: sectionwise from crux + pushforwardComp; mate-vs-
  poset-thin closure UNCONFIRMED (blueprint `% NOTE`) — if it needs a fresh mate computation, report.
- **`trivialisation_restrict_compat`** (~L1891) — telescope of the 5 squares; only after they close. DEAD probes:
  `restrictFunctorComp.hom.naturality φ` (morphism, iter-040); subst/rcases on `hVU:V≤U`, `simp[restrictIsoUnitOfLE]`,
  `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`. `erw`/term-`exact` not `rw` ([[tensorobjinverse-red-at-source]]).
- **Cocycle `exists_tensorObj_inverse`** — CLOSED modulo `trivialisation_restrict_compat` (iter-038, green). Full
  iso-algebra reduction in-code; `have ht` uses term-mode `exact` (every `rw`/`simp` of a category lemma misses on
  the defeq-not-syntactic SheafOfModules `≫`). NEVER sheafify-the-eval (d.2 dead-end). DEAD: `rfl`, `simp
  [tensorObjIsoOfIso_trans/refl, dualIsoOfIso_trans/refl]` (iso-level, goal is `.val.app`-section level).
- **Residual B** — CLOSED iter-026. Recipe `rem:dual_discharges_inverse`. Non-critical branch (seed-3
  `map_add` rides seed-1→K1).

## Cone B — dual base-change naturality — c.1 DONE iter-069; (a) DONE iter-070; c.2 FACTORS CLEANLY (iter-071); iter-072 builds the forward-apply brick in `SliceTransport.lean`; 2 off-path sorries DEFERRED
STATE: **c.1 `pushforwardObjValRestrictIso` CLOSED iter-069** (`Iso.refl`). **(a) `presheafDualH1Cocycle`
CLOSED iter-070 sorry-free** (NEW generic engine `Adjunction.leftAdjointUniq_leftAdjointCompIso_comm` +
2 mate helpers; axiom-clean). **iter-071 BREAKTHROUGH (supersedes iter-070 "interleaved non-factoring
merge"): c.2 FACTORS CLEANLY** — reduces by ONE ordinary `H1_h.hom` NatTrans naturality at `θ_f.hom`
(after substituting CLOSED (a)) to a SINGLE isolated residual (∗∗) `FC.hom.app dM ; sDT_{h≫f} =
pushβ_h.map(sDT_f) ; sDT_h(M|f) ; dualIsoOfIso(rfc).hom` = pushforward-flank `sliceDualTransport`
pseudofunctoriality. Verified in code (adjunctions + `hcoc` instantiate; build EXIT 0). Close pinned to
TWO bricks: (1) abstract tail whnf-bombs across the `≫` seam → LOCAL copies of the generic
`comp_cancel_mid`/`comp_slide_nested`/`comp_cancel_three_lr` (they are **`private`** at
TensorObjSubstrate.lean:2981+, NOT public) applied by `exact`; (2) (∗∗) needs FORWARD
`sliceDualTransport_app_apply` in `SliceTransport.lean` (mirror of the `:= rfl` inverse L563).
**iter-072 lane (this iter):** SOLO `mathlib-build` on `SliceTransport.lean` ADDS the forward apply lemma
(progress-critic CHURNING but ENDORSES the pivot; trip-wire: if it is NOT a clean `rfl`/short mirror,
restructure — do not grind). c.2 brick-tail close + (∗∗) follow NEXT iter on `PresheafDualPullback.lean`
against the green sibling. Leg-4: `restrictFunctorComp`/`dualIsoOfIso` (NOT `pushforwardComp` — whnf-bombs
at concrete β). NEVER `ext` the conjugate-headed goal.
SOLO (one import chain SliceTransport→…→PresheafDualPullback→TensorObjInverse; co-dispatch = build race).
The 2 abandoned off-path sorries (L377/L434) are NOT objectives — leave untouched.
**CRUX `presheafDual_pullback_restrict_natural` CLOSED axiom-clean iter-066**
(the lemma S3/S4a consume) — by θ.hom's BUILT-IN `PresheafOfModules.Hom` naturality
(`funext φ; naturality_apply θ.hom (homOfLE j).op φ`), NOT the planned L1;L2;L3a chain. Also closed: L3b,
L2 `dualPrecompHom_restrict_apply`, `dualPrecompHom` def. θ-def `presheafDualPullbackComparison`. NOT yet
imported into the main tree (the iter-067 S3/S4a lane adds the import).
- **2 remaining sorries — OFF every critical path (the crux bypasses them), DEFERRED to post-terminal
  cleanup:** L1 `presheafDual_pullback_comparison_eval_apply` (needs forward `sliceDualTransport_app_apply`
  in `SliceTransport.lean`) + L3a helper `evalLin_restrict_commute_aux` (needs private
  `restr_map_homMk`/`hom_app_heq` re-exposed in `PresheafInternalHom.lean`). Both cross-file-blocked +
  UPSTREAM of `TensorObjInverse` → fixing now = build race with the active S3/S4a lane. checker-confirmed
  no other `.lean` references them → may DELETE as dead weight in the cleanup pass. Blueprint marks them
  off-critical-path (`coneb-prose-iter067`).

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
