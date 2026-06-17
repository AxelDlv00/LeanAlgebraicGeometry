# AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

## Session iter-075 (IN PROGRESS — verification running)

State at session start: 1 sorry — `pushPull_interLegHom_sections` (the last CSI leaf).

## pushPull_interLegHom_sections (was line 1003, now line 1416)
### Attempt 1 (this session): merge the iter-074 scratch-validated Steps 0–4
- **Approach:** The iter-074 session left the complete 5-step route in `/tmp/csileg_scratch.lean`
  (still on disk, timestamped this morning), including the previously-pending Step-4 assembly:
  - Step 0 `unit_pushforward_rFIP_inv`, Step 1 `restrict_unit_comp` (K5), `inner_beta_chain`,
    Step 2 `pullbackComp_rFIP_compat` (K4), Step 3′ `pushPull_toRestrict_comm` — transcribed
    verbatim into the Leg file before the target lemma, each with per-lemma
    `set_option maxHeartbeats 1600000 in` + `set_option synthInstance.maxHeartbeats 400000 in`
    (the scratch had these file-wide).
  - Private helpers `thin_resid5` (thin-category 4-restriction + 2-transport fusion) and
    `pls_eq` (`pushPull_leg_sections … .hom` unfolds by `rfl` to
    `Γ_V(j_*((rFIP j).inv.app F)) ≫ eqToHom`).
  - The Step-4 assembly body replaced the `sorry`: `pls_eq` rewrites at source/target,
    `congrArg (sectionFunctorV V).map` over Step 3′, reassociation by explicit
    `Eq.trans`/`Category.assoc` (NOT `calc` — `Trans` instance synthesis fails at reducible
    transparency on the defeq-but-not-syntactic `(c≫q)_*` vs `q_*c_*` middle objects), and a
    final `thin_resid5` application discharging the residual thin-category chain.
- **Result:** IN PROGRESS — two blocking verifications running:
  1. `lake env lean /tmp/csileg_scratch.lean` (the scratch as-is, vs the real Base `.olean`) —
     early signal for the lemma text itself;
  2. `lake env lean AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean` (the merged
     file, authoritative; baseline ≈27 min).
- **Key insight:** identical local definitions (`sectionFunctorV` abbrev, `interLegHom` def) in
  scratch and Leg file make the transcription elaboration-equivalent; all referenced engine lemmas
  (`rawPushPullMap_self`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`,
  `pushforwardCongr_hom_app_app`, `restrictFunctorCongr_hom_app_app`) come from
  `CechHigherDirectImage`/Base, both already built.

## Needs blueprint entry
(if the merge verifies — these are the new public/private declarations added to the Leg file)
- `AlgebraicGeometry.unit_pushforward_rFIP_inv` — Step 0; uses `Adjunction.unit_leftAdjointUniq_hom_app`.
- `AlgebraicGeometry.restrict_unit_comp` — Step 1 (K5); uses `Scheme.Modules.hom_ext`, thin-category `Subsingleton.elim`.
- `AlgebraicGeometry.inner_beta_chain` — β-chain collapse; uses unit naturality + Step 0.
- `AlgebraicGeometry.pullbackComp_rFIP_compat` — Step 2 (K4); uses `Adjunction.homEquiv` injectivity, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`.
- `AlgebraicGeometry.pushPull_toRestrict_comm` — Step 3′; uses `rawPushPullMap_self`, Steps 0–2.
- `private thin_resid5`, `private pls_eq` — endgame helpers (private; bundle into the
  `lem:pushPull_interLegHom_sections` `\lean{}` pin or a related block per the unmatched policy).

## Summary
Interim — verification running; will update.

## Why I stopped
Session in progress.
