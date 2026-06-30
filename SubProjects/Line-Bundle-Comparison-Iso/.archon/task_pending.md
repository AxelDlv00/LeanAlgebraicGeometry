# Pending Tasks
<!-- Current open-task set, last-known state only. Per-attempt detail → iter sidecars. -->

## ✅ v4.31.0 REGRESSION RECOVERY — COMPLETE (iter-089 → iter-096); all recovery targets closed
A Jun-27 toolchain bump (v4.30.0-rc2 → v4.31.0) `sorry`-isolated/dropped ~36 fragile proofs. **Every
regressed decl has now been recovered, all axiom-clean, all builds EXIT 0:** DualInverse 6→0 (089);
TensorObjSubstrate 5→1-dead-dup (090) + the DELETED ~690-LOC δ/η-collapse ROOT block re-ported as 13 decls
incl. the keystone `pushforward_mu_appIso_collapse` (093); B1 `tensorObj_restrict_iso_eq_pullbackTensorMap`
(094, ZERO fixes); K1 `pullbackTensorMap_isIso_of_isOpenImmersion` relocated to monster-free leaf
`TensorObjSubstrate/PullbackTensorMapIso.lean` + filled (095, 1 fix); **S2 `tensorObj_restrict_iso_restrict_compat`
filled in place (096, 4 fixes — one recurring `⋙`-obj defeq axis; see task_done.md).** Recovery recipe source =
parent commit `117100c4` (v4.30.0-rc2 PRE-bump); fix axes in `task_results/…DualInverse/…TensorObjSubstrate.lean.md`.
- **REMAINING (NOT regressions — genuine open math, sorried even in v4.30):** the **dual-unit FLANK**.
  iter-098 closed the L1′ leaf; iter-099 closed (b) `dualUnitIso_dualIsoOfIso` + (d) `exists_tensorObj_inverse`.
  `TensorObjInverse.lean` = **2 sorries**: (a) `dual_unit_iso_restrict_assemble` L1609 (keystone, live) +
  (c) `trivialisation_restrict_compat` L2396 (gated on (a)). Plus the dead private `exists_tensorObj_inverse`
  dup in `TensorObjSubstrate.lean` (deletion candidate).
- **Build viability:** `lake build …TensorObjInverse` viable (monster upstream, not re-elaborated). **OOM
  caution FULLY RETIRED iter-098 — host is now 2 TB RAM (~1.1 TB free), not legacy 2 GB; building
  `PresheafDualUnitPullback`/`PresheafDualPullback` directly runs fine (37 s, no Exit 137).** That stale "don't
  build the leaf" rule had left `PresheafDualUnitPullback` RED-undetected through the whole recovery (6 v4.31
  α-NatTrans errors masked by grep's 1-sorry count). NEVER bare `lake build`. Trust `lake` EXIT 0 only, never
  LSP, never grep sorry-count for a monster-importing file.

## ✅ keystone (a) `dual_unit_iso_restrict_assemble` — CLOSED (iter-102), axiom-clean
iter-100 ASSEMBLED (a) → 2 named residuals; iter-101 closed RES1; **iter-102 closed RES2
`pullbackUnit_sheafify_reconcile` (L1+L2+`adj_unit_counit_collapse`) ⇒ (a) sorry-free, `[propext,
Classical.choice, Quot.sound]`.** L2 closed via a transpose-free (†)-factorisation (cleaner than the
blueprint's template-mirror). `lake build …TensorObjInverse` EXIT 0 (8567 jobs). See task_done.md.

## ACTIVE (iter-103) — close (c) `trivialisation_restrict_compat` (`TensorObjInverse.lean`, prove)
(a) closing UNBLOCKS (c) (S4a now supplied). (c) is the LAST keystone sorry (L2660, effort 4097). iter-103
**effort-broke** the telescope ASSEMBLY (not the 5 already-proven squares) into a 3-link chain (effort 4097→2018;
blueprint-reviewer `iter103` GATE CLEARED, progress-critic `iter103` CONVERGING). **ONE prover lane (`prove`)**:
create the 3 private sub-lemmas + assemble the target.
- **Seam 1 `trivialisation_restrict_eM_split`** — `restrict j` applied to `tensorObjIsoOfIso eM (dual-chain)`
  splits via `tensorObjIsoOfIso_trans` into the eM-leg (`restrictIsoUnitOfLE hVU eM = restrict j eM`) +
  dual-chain leg (`dualIsoOfIso_trans` carries `(dualIsoOfIso eM)⁻¹` through `restrict j`); HEAVIEST (≈1215).
- **Seam 2 `trivialisation_telescope_assemble`** — GENERIC abstract-`{C}[Category C]` cocycle collapse
  (sibling of `c2_assemble`/`dual_scp_assemble`/`unit_assemble`): given the 5 square eqs, adjacent ρ cancel,
  leaving outer hobjU/hobjV. Applied by `exact` — confines ALL `SheafOfModules ≫` seam-crossing (≈861).
- **Seam 3 `trivialisation_restrict_sectionwise`** — thread the 2 outer `eqToHom`s (`image_preimage_of_le`)
  + evaluate `.val.app` over `ι_U⁻¹(V)` (≈584).
- **Seam discipline:** apply Seam-2 generic lemma by `exact`/`refine`, NEVER `rw`/`ext` a conjugate-headed goal.
- **NO-GRIND GUARD:** if a seam resists after focused effort, leave a single clean sorry on THAT seam + report
  which; do NOT grind the monolith or reintroduce a whole-(c) sorry. Seam 1 is the re-break candidate (split
  the eM-leg identification from the 3-leg dual-chain carry).

## Seed 1 — `pullbackTensorIsoOfLocallyTrivial` (D4′) — `TensorObjSubstrate.lean` — DONE iter-042 → see task_done.md
DELIVERED: root GREEN (`lake build` EXIT 0, 8321 jobs), sorry-free. K1 `hδ` via `isIso_oplaxδ_of_conj` ←
`pushforward_mu_appIso_collapse` (δ-conjugation on `deltaConjOfMuComparison`), SUPERSEDING the phantom
`pullbackTensorMap_presheafDelta_eq`/`pullbackTensorComparison`. K1 witness PUBLIC (L4770). iters 039–041
"delivered" were LSP stale-green — `lake build` is the only authority. Blueprint reconciled iter-043.

## ROOT gap-fill — `conjugateEquiv_restrictFunctorComp_inv` (`TensorObjSubstrate.lean`) — DONE iter-048 → see task_done.md
CLOSED public, axiom-clean (lake EXIT 0). iter-046 "irreducible" verdict overturned (abstract
`leftAdjointCompIso`-on-`pushforwardComp` route; NEVER `ext` the conjugate-headed goal). Now consumable by terminal.

## Terminal cone (dual-unit FLANK) — `TensorObjInverse.lean` + `PresheafDualUnitPullback.lean` — BLUEPRINT-FIRST iter-097
STATE (recipe history; v4.30 pre-bump engine): **B1/B2 ENGINE COMPLETE** (B2 050; B1-crux 053). **S2 054.
S4b (=Cone A) 065. S4c 041.** **Cone B DUAL-crux substrate COMPLETE iter-079** (PresheafDualPullback.lean
sorry-free). **(b) CLOSED iter-080. S3 + L1 STEP-B CLOSED iter-084. S4a BODY CLOSED iter-085** (rides L2′).
**Live (post-recovery, iter-097):** 4 genuine-open sorries — the L1′ FLANK (†) leaf
(`PresheafDualUnitPullback.lean` L183), L2′ `dual_unit_iso_restrict_assemble` (TensorObjInverse L1583),
`dualUnitIso_dualIsoOfIso` (L2387), `trivialisation_restrict_compat` (L2370) → terminal
`exists_tensorObj_inverse` (L2444). All gated on the ∞-source informal proof (see ACTIVE section above).
- **L1 `dual_restrict_iso_comp` (L1302; STEP-B CLOSED iter-084)** — winning idiom (REUSABLE): `apply
  Iso.ext`→syntactic `.hom` flatten→generic abstract `dual_scp_assemble` by `exact` (objects opaque ⇒ no
  whnf bomb). NEW helper `dual_scp_assemble`. DEAD: STEP-B as a standalone lemma (whnf-bombs — kept INLINE).
- **L1′** `presheafDualUnitIso_pullback_natural` (`PresheafDualPullback.lean:1208`) — **iter-086: STATED
  whnf-safe + H1-telescope PROVEN; 3 comparators built sorry-free** (`presheafPushforwardBetaMonoidal`
  strong-monoidality; q=`presheafPushforwardUnitIso`=`(εIso (pushforward β)).symm`; p=`presheafPullbackUnitIso`
  =`(H1.app 𝟙_X).symm ≪≫ q` via H1 reconciliation — NOT literal `η(pullback)`, which IS the unproven D2′
  η-bridge). Reduced to ONE residual `FLANK`(†) [now leaf L183] = the sectionwise pushforward-flank identity
  `sDT.hom ≫ (dualIsoOfIso q).inv ≫ pdY.hom = (pushforward β).map pdX.hom ≫ q.hom`. Verified opening
  `erw [sliceDualTransport_app_apply]`. **iter-087 = INFRA-BLOCKED (0 edits): editing 1313-LOC
  `PresheafDualPullback.lean` re-elaborates the 12.8M-HB monster (~28 min) → 900 s watchdog Exit 137 before
  FLANK reached. iter-088 CORRECTIVE (refactor): L1′ frontier (3 comparators + L1′ + FLANK) HOISTED to NEW
  leaf `PresheafDualUnitPullback.lean` (L1′ at L118, FLANK at L183; imports PresheafDualPullback warm-olean;
  ~222 LOC, fast); `PresheafDualPullback.lean` now sorry-free. iter-088 ACTIVE: SOLO `prove` ON THE LEAF —
  (STEP1) AUTHOR the named linchpin `pushforwardBetaUnitEpsAppOne` in the leaf** (unit-side analogue of
  `pushforward_mu_appIso_collapse`; sectionwise carrier value at `1` of `q.hom = (εIso (pushforward β)).inv`,
  split via `Functor.Monoidal.comp` into ε of `pushforward₀OfCommRingCat` (1↦1) + ε of `restrictScalars β`
  (1↦1, template `restrictScalars_oplaxMonoidal_η_app_one`, `analogies/eta-plumbing.md §1`); axiom-clean);
  **(STEP2) close FLANK** — reduce RHS `(pushforward β).map pdX.hom .app V` + `q.hom` via the linchpin to the
  `f.appIso`-conjugated `evalLin 𝟙_X (op fV) φ 1`, close by `linearEndo_apply_comm`-style commutativity
  exactly as `presheafDualUnitIso_naturality` (DualInverse:317). gate CLEARED iter-087 (writer/clean/reviewer
  PASS). **HARD no-new-sorry gate (progress-critic iter-087 CHURNING must-fix): close FLANK; NO relocation,
  NO new sorry.** Carrier-diamond hazard: full `simp`/`letI` re-adds the `restrictScalars` carrier diamond —
  use sectionwise/`εIso`-component + `simp(zeta:=false)`+`erw`, not `simp`. If FLANK+linchpin don't BOTH land
  → STOP, report the exact residual; next iter pivots to mathlib-analogist on the composite carrier diamond.
- **L2′** `dual_unit_iso_restrict_assemble` (TensorObjInverse L1601, flattened to `.hom` residual iter-085)
  — **next iter** (different file, gated on L1′ landing): dual-B1 `dual_restrict_iso_eq_comparison` → θ-leg
  by L1′ → `RFIP;SCP` by bridge (b) `sheafificationCompPullback_comp` (SAME seam as S3) → fold by counit
  naturality + `dualIsoOfIso` functoriality + generic `dual_scp_assemble`-style `exact`. **S4a target =
  CLOSED iter-085** (rides L2′). DEAD: `rw`/`simp`/`erw` of a category lemma across the SheafOfModules `≫` seam.
- **`trivialisation_restrict_compat`** (L2387) — telescope of the 5 squares; only after L2′/S4a close. DEAD probes:
  `restrictFunctorComp.hom.naturality φ` (morphism, iter-040); subst/rcases on `hVU:V≤U`, `simp[restrictIsoUnitOfLE]`,
  `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`. `erw`/term-`exact` not `rw` ([[tensorobjinverse-red-at-source]]).
- **Cocycle `exists_tensorObj_inverse`** — CLOSED modulo `trivialisation_restrict_compat` (iter-038, green). Full
  iso-algebra reduction in-code; `have ht` uses term-mode `exact` (every `rw`/`simp` of a category lemma misses on
  the defeq-not-syntactic SheafOfModules `≫`). NEVER sheafify-the-eval (d.2 dead-end). DEAD: `rfl`, `simp
  [tensorObjIsoOfIso_trans/refl, dualIsoOfIso_trans/refl]` (iso-level, goal is `.val.app`-section level).
- **Residual B** — CLOSED iter-026. Recipe `rem:dual_discharges_inverse`. Non-critical branch (seed-3
  `map_add` rides seed-1→K1).

## Cone B — dual base-change naturality (PresheafDualPullback.lean) — COMPLETE iter-079 → see task_done.md
DONE: crux `presheafDual_pullback_restrict_natural` (066), c.1 `pushforwardObjValRestrictIso` (069), (a)
`presheafDualH1Cocycle` (070), c.2 `presheafDualPullbackComparison_restrict` `case hstar` ★ (079, thin-poset
proof-irrelevance keystone + `hstar_naturality`). **PresheafDualPullback.lean fully sorry-free, axiom-clean.**
The 2 off-critical-path sorries flagged iter-067 (`presheafDual_pullback_comparison_eval_apply`,
`evalLin_restrict_commute_aux`) were superseded — file is sorry-free. Unblocks the terminal cone below.

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
