# Strategy

## Goal

Build the **comparison-isomorphism substrate on line bundles** — the A.1.c.sub work
package carved from Merten's Jacobian challenge (`references/challenge.lean.ref`). Three
seed nodes + their 108-node cone, zero inline `sorry`, kernel-only axioms:

- `lem:pullback_tensor_iso_loctriv` — `Modules.pullbackTensorIsoOfLocallyTrivial`: loc-triv comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N`.
- `lem:dual_isLocallyTrivial` — `Modules.dual_isLocallyTrivial`: dual of a loc-triv module is loc-triv.
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj`: the `AddCommGroup` on `Pic♯_{C/k}`.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| Terminal — squares TENSOR flank (S4b = **Cone A**, `TensorObjInverse.lean`) | **DONE iter-065 — Cone A complete end-to-end.** S4b CLOSED: L3 `pullbackUnitIso_whisker_eq_sheafify_eta_whisker` (central leg = arg-1 q=𝟙 reuse of proven `sheafifyTensorUnitIso_hom_natural`) + bridge-3 assembly `pullbackTensorMap_left_unitality` both closed iter-065 (sorry 5→3). Keystone `image_collapse` + L2 064; S2 054; body+inner 055/056 | 0 | ~30–60 | **`OplaxMonoidal (PresheafOfModules.pullback φ)` ALREADY EXISTS sorry-free** (root `:1115`, via Mathlib `leftAdjointOplaxMonoidal`); `left_unitality_hom` free + already consumed (`:1346`). | iter-056 analogist (`analogies/pullback-monoidal-scope.md`): the "missing `Functor.Monoidal` instance" was a STALE premise — instance exists; do NOT build `Functor.Monoidal` (globally FALSE: δ not iso for general modules, `Γ(ℙ¹,𝒪(1))=0` obstruction). Inner seam = **Cone A**: sheafification-seam TRANSPORT of the existing presheaf `left_unitality_hom` to sheaf maps `pullbackTensorMap`/`pullbackUnitIso` (3 bridge lemmas, B1 idiom; template `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` 80% there). Low-med risk. progress-critic iter-056: CHURNING → this pivot is the corrective. |
| Terminal — squares DUAL flank (S3/S4a, `TensorObjInverse.lean`) + telescope | **iter-068 DIAGNOSIS pinned both S3 bridges; iter-069 UNBLOCKED both + cleared gate.** dual-B1 `dual_restrict_iso_eq_comparison` DONE (rfl); B2 + ρ-cancel discharged; S3 at the exact `case e_β` residual. **(b)** UNBLOCKED iter-069 (refactor un-privated Sq1 `sheafificationCompPullback_comp`; now a one-liner). **(c)** REFRAMED iter-069: the iter-068 "cannot state" wall was a misframe from stating the cocycle at sheaf level; restated as the exact dual of PROVEN `pullbackTensorMap_restrict` (middle θ at the PUSHFORWARD obj, not `M|_f`), threaded through NEW **c.1** object-id iso `pushforwardObjValRestrictIso` (`(pushforward β).obj M.val ≅ (M|_f).val` = H1∘(RFIP;SCP).val). Chain: dual-B1(DONE)→B2(DONE)→(b)[1-liner]→c.1[DONE iter-069, `Iso.refl`]→c.2 cocycle→S3→S4a. **iter-069 closed c.1; c.2 STATED + reversal CONFIRMED** (residual = genuine TWO-immersion pseudofunctoriality, NOT from the single-immersion crux). **iter-070 CLOSED (a) `presheafDualH1Cocycle` sorry-free** (dual of proven keystone, via NEW generic engine `leftAdjointUniq_leftAdjointCompIso_comm`). **iter-071 BREAKTHROUGH (supersedes the iter-070 "interleaved non-factoring merge" framing): c.2 FACTORS CLEANLY.** It reduces by ONE ordinary `H1_h.hom` NatTrans naturality (after substituting CLOSED cocycle (a)) to a SINGLE isolated residual (∗∗) = the pushforward-flank `sliceDualTransport` pseudofunctoriality `FC.hom.app dM ; sDT_{h≫f} = pushβ_h.map(sDT_f) ; sDT_h(M|f) ; dualIsoOfIso(rfc).hom`. Two named bricks remain to close c.2: (1) the abstract H1-cancel tail whnf-bombs across the `≫` seam → needs local copies of the generic `comp_cancel_mid`/`comp_slide_nested`/`comp_cancel_three_lr` bricks (they are `private`, not public) applied by `exact`; (2) (∗∗) needs a FORWARD `sliceDualTransport_app_apply` in `SliceTransport.lean` (only the `:= rfl` inverse exists). **iter-072 corrective (progress-critic CHURNING → build the named missing upstream brick):** SOLO `mathlib-build` lane on `SliceTransport.lean` ADDS the forward apply lemma (mirror of the proven `:= rfl` inverse) — the critic-endorsed unblock. c.2 brick-tail close + (∗∗) follow next iter against the green sibling. | ~1–3 | ~60–120 | bespoke internal-hom base-change naturality (NO Mathlib oplax/strong dual-preservation API). c.1 DONE (`Iso.refl`). (a) CLOSED (dual of proven keystone). Forward `sliceDualTransport_app_apply` = `:= rfl` mirror of the proven inverse. | **Cone B** (NOT monoidality). (a) + clean-factorisation reduction DONE; remaining = 2 named mechanical/cross-file bricks, NOT research. **progress-critic iter-072 = CHURNING (≥3 PARTIAL, 2× over budget) but ENDORSES the SliceTransport pivot as the correct corrective.** Standing AUTONOMOUS directive overrides "escalate to user"; TRIP-WIRE: if the forward apply lemma is NOT a clean `rfl`/short mirror, restructure — do not grind a 6th iter. S4a rides on S3 + (b)-bridge + θ-unit id `presheafDualUnitIso_naturality`. Telescope gated on all 5. SOLO: SliceTransport→…→PresheafDualPullback→TensorObjInverse one import chain (build race). |
| Consumer seed-3 (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | `addCommGroup_via_tensorObj`; gated on terminal close (seed-1 done). |
| Coverage + file-split cleanup | DEFERRED | ~1–2 | ~0 (tex/private) | — | ~99 `lean_aux` isolated nodes + `TensorObjSubstrate.lean` (>4800 LOC) split; after terminal lands. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|-------|----------------------|-----|-------|-------------|---------------------|----------|
| DUAL dual-inverse | 015 · ~6 | ~250 | `DualInverse*.lean` | `sliceDualTransport` sorry-free; seed `dual_isLocallyTrivial` | leg-B `inv ε` rotated morphism-level (`IsIso.inv_comp_eq`), never pointwise; `maxHeartbeats 1600000` for inline `≃ₗ` | pointwise `inv ε` heartbeat-bombs; import-race green→red on shared-dep edits — isolate |
| D3′ base-change substrate | 019 · ~9 | ~600 | `TensorObjSubstrate.lean` | `pullbackTensorMap_natural`/`_restrict` cone sorry-free; substrate for seed-1 + terminal | generic `[Category C]` lemmas applied by `exact` across the SheafOfModules defeq wall; `conjugateEquiv_comp` for Sq1 | `rw/erw [Category.assoc]` whnf-bombs; top-level monoidal-carried extraction fails — keep IN-PROOF |
| D4′ seed-1 (`pullbackTensorIsoOfLocallyTrivial`) | 042 · ~24 | ~700 | `TensorObjSubstrate.lean` | `restrictScalarsMonoidalOfBijective`, `μIso`, `leftAdjointUniq` | K1 `hδ` via abstract `isIso_oplaxδ_of_conj` ← `deltaConjOfMuComparison`/`pushforward_mu_appIso_collapse` (δ-conjugation), NOT the planned `pullbackTensorMap_presheafDelta_eq` (never realized) | **LSP stale-green masked a RED root for 3 iters (039–041) — ALWAYS `lake build`, never trust LSP**; carrier diamond; whnf bombs |
| Shared keystone `conjugateEquiv_restrictFunctorComp_inv` (root) | 048 · ~5 (046–048) | ~30 | `TensorObjSubstrate.lean` | restrict-side mirror of `conjugateEquiv_pullbackComp_inv`; the B2 + B1-crux bridge | INSTANTIATE `leftAdjointCompIso` on `pushforwardComp` (do NOT equate it with `restrictFunctorComp`); `exact conjugateEquiv_leftAdjointCompIso_inv`, residual concrete iso-hom eq closes by MAP-level merge + `Subsingleton.elim` | iter-046 falsely declared it "irreducible"; the whnf-bomb was `ext` on the conjugate-headed goal — NEVER `ext` before the abstract rewrite. Also: scaffold-keyword needed in objective line for sorry-free files (no-op filter) |
| Bridge B2 `restrictFunctorIsoPullback_comp_compat` (terminal) | 050 · ~3 (048–050) | ~120 | `TensorObjInverse.lean` | pseudonaturality of `restrictFunctorIsoPullback` across `j;ι_U=ι_V`; 6 axiom-clean lemmas (5 per-leg + assembled `_hom`) | conjugateEquiv.injective → LHS-collapse keystone (`= 𝟙`) → N explicit `← conjugateEquiv_comp` splits over fixed `(C,D)=(X.Mod,V.Mod)` → per-leg pushforward values → cancel `pushforwardComp` pair → `conjugateEquiv_reindexCongr`. **`mateEquiv_hcomp/vcomp` UNNEEDED** (all legs share (C,D)) | fine-grained the telescope into atomic per-leg sub-lemmas was the breakthrough after CHURNING on whole-`hNat`; collision RED from a stale private stub of the keystone FQ name (delete it) |
| B1-crux engine `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq` (terminal) | 053 · ~4 (050–053) | ~250 | `TensorObjInverse.lean` | sheafification-boundary unit coherence; H1inv body + residual both sorry-free, axiom-clean | forget-faithful (`fullyFaithfulForget.map_injective`) + INNER presheaf-pullback transpose + INVERSE-`leftAdjointUniq` triangle (`hAcancel`=`leftAdjointUniq_inv_app`+`unit_leftAdjointUniq_hom_app`) + `sheafificationCompPullback_eq_leftAdjointUniq`; term-mode assembly across the SheafOfModules `≫` seam | CHURNED 3 iters (050–052) on the whole-composite homEquiv transposition (PROVEN circular) before the inner-adjunction/forget-faithful route landed; mathlib-analogist cross-domain (`analogies/ofisrightadjoint-unit.md`) was the unblock |

## Routes

Seeds 1 (D4′) and 2 (DUAL) delivered. The terminal route is the sole open lane.

### D4′ seed-1 (`pullbackTensorIsoOfLocallyTrivial`) — DELIVERED iter-042
Root `TensorObjSubstrate.lean` green (`lake build` EXIT 0), K1 closed. K1 `hδ` (presheaf oplax
`δ (pullback φ')` iso) realized via the abstract sandwich `isIso_oplaxδ_of_conj` fed the
δ-conjugation identity `pushforward_mu_appIso_collapse` (built on `deltaConjOfMuComparison`),
which conjugates `δ (pullback φ')` to the strong `δ (Gβ)` of `pushforward₀ ⋙ restrictScalars β'`
via `leftAdjointUniq`. This SUPERSEDED the planned helpers `pullbackTensorMap_presheafDelta_eq`/
`pullbackTensorComparison` (never realized). Witness K1 `pullbackTensorMap_isIso_of_isOpenImmersion`
is PUBLIC (L4770). HAZARD CONFIRMED: iters 039–041 "delivered" were LSP stale-green — `lake build` only.

### Terminal `exists_tensorObj_inverse` (`TensorObjInverse.lean`) — ACTIVE (unblocked iter-042)
`L⁻¹ := dual L` (loc-triv by C-bridge `dual_isLocallyTrivial`); glue local left-unitor
contractions `(L⊗dual L)|_U ≅ 𝒪_U` via A-bridge `homOfLocalCompat` + `tensorObj_restrict_iso`;
globalise via B-bridge `isIso_of_isIso_restrict`. Object + C/A/B bridges + cocycle skeleton
done. `trivialisation_restrict_compat` (overlap cocycle `hf`: real ab-group section maps, NOT
global `subsingleton`) decomposes into 5 restriction-naturality squares S2–S4c + reindex defs
(ρ `restrictCompReindex`, u_ι `unitRestrictIso`). **Bridge B2 (`restrictFunctorIsoPullback_comp_compat`)
FULLY CLOSED iter-050** (leg-by-leg `conjugateEquiv_comp`, NOT `mateEquiv_vcomp`). S4c CLOSED
iter-041. **Engine DONE: B1-crux `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq`
both sorry-free iter-053.** Remaining = the 5 restriction-naturality squares: TENSOR flank S2/S4b
(ACTIVE iter-054, B1-route, all ingredients proven) → DUAL flank S3/S4a (BLOCKED, dual-B1 gap) →
telescope `trivialisation_restrict_compat` (gated on all 5).

**Route of record (iter-042, direct base-change — replaces the iter-040/041 per-leg + the
rejected monoidal-packaging attempts).** Keystone **B1**
(`tensorObj_restrict_iso_eq_pullbackTensorMap`): relate the structural iso to the comparison
MAP, `tensorObj_restrict_iso f = restrictFunctorIsoPullback f ≫ asIso(pullbackTensorMap f) ≫
reindex`. Both share the `restrictFunctorIsoPullback`/`sheafificationCompPullback` prefix; after
cancelling it B1 is the presheaf-level core `δ = leftAdjointUniq∘μIso`, discharged by the SAME
δ-conjugation K1 used (`pushforward_mu_appIso_collapse`/`isIso_oplaxδ_of_conj`) + `leftAdjointUniq`
uniqueness (bounded, no `MonoidalCategory`). Squares S2/S4b (tensor) then follow from `pullbackTensorMap_restrict` +
`pullbackTensorMap_natural` (sorry-free D3′ cone) + B1 transported along
`restrictFunctorIsoPullback`; S3/S4a are the dual analogue. Telescope wires the 5 squares.
**B1 unblocked iter-044:** the root δ-conjugation lemmas (`pushforward_mu_appIso_collapse`,
`deltaConjOfMuComparison`, `isIso_oplaxδ_of_conj`, `pushforward_lax_mu_comparison(_lhs/_rhs_tmul)`)
were `private`; de-privatized iter-044 (refactor, signature-preserving, root stays green EXIT 0).
Lane SOLO/race-free (root frozen-green again post-edit).

### Consumer seed-3 `addCommGroup_via_tensorObj` (`RelPicFunctor.lean`) — BLOCKED
Group on loc-triv iso-classes: `map_add` ← seed-1 comparison iso; `map_zero` ←
`pullbackUnitIso`; inverse ← `exists_tensorObj_inverse`. Gated on seed-1 (done) + terminal.

## Open strategic questions

- Monoidal packaging of `pullback f`: REJECTED — `MonoidalCategory (X.Modules)` absent
  (`#synth` fails; Mathlib has it only at presheaf level). Direct base-change route chosen.
- `Functor.Monoidal (pullback φ)` refactor: **RESOLVED — DO NOT BUILD (analogist iter-056,
  `analogies/pullback-monoidal-scope.md`).** (1) The OPLAX instance already exists sorry-free (`:1115`);
  the S4b residual was never "missing monoidality" — it is sheaf-transport (Cone A). (2) A STRONG
  `Functor.Monoidal` is globally FALSE: δ=`pullbackTensorMap` is not iso for general modules
  (`Γ(ℙ¹,𝒪(1))=0`), iso only on line bundles via the chart-chase. (3) Even a strong instance would NOT
  close S3/S4a — Mathlib has no monoidal/closed dual-preservation matching `f^*`. Dual = bespoke Cone B.
- Dual side S3/S4a: route SETTLED = **Cone B** bespoke internal-hom base-change naturality
  (generalize `presheafDualUnitIso_naturality` to the immersion `j`); NOT the abandoned
  `pullbackDualMap` cone nor the subsingleton route. Land after Cone A validates the seam pattern.
- Coverage debt: ~97 unmatched `lean_aux` decls; scheduled cleanup phase (blueprint blocks for
  load-bearing helpers, `private` for internals). `TensorObjSubstrate.lean` split next refactor.
- Consumer (when unblocked): blueprint must state which group axioms ride the associator vs the
  comparison iso, so the consumer assumes no more than additivity-of-pullback.
- Out of scope (sibling extracts): A.2.c/Quot, Čech, A.3/A.4, Route-C — disjoint cones.

## Mathlib gaps & new material

Gaps to fill:
- A-bridge `homOfLocalCompat` (+ `homOfLocalCompat_restrictFunctor_map`) — glue compatible local
  module morphisms to a global one; built project-side. DONE.
- B1 presheaf core `δ = leftAdjointUniq∘μIso` — by hand via `pushforward_mu_appIso_collapse`
  + `leftAdjointUniq` uniqueness (NOT a Mathlib gap; bounded sectionwise mate identity).

New project material:
- By-hand `AddCommGroup` on loc-triv iso-classes (no `MonoidalCategory (X.Modules)`; modeled on
  Mathlib `CommRing.Pic.mapAlgebra`).
- `IsInvertible M := ∃N, M⊗N≅𝒪` carrier for `Pic X` (Stacks 0B8K/01CX).
