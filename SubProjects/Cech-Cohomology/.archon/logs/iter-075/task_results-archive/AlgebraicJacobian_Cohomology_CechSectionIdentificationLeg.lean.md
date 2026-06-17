# AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

## Session iter-074 (current, IN PROGRESS — supersedes the earlier 074 report below the fold)

State at session start: 2 sorries — `backboneIncl_proj` (line 747, prior session hit a
12.8M-heartbeat elaboration wall on the layer-peeling assembly) and
`pushPull_interLegHom_sections` (line 903, chunk D / sheaf seam, not started).

### pushPull_interLegHom_sections — Attempt 1 (scratch-validated, merge pending)
- **Approach:** 5-step restrict-world decomposition, developed + compiler-verified in
  `/tmp/csileg_scratch.lean` (lake env lean against the real Base .olean):
  - **Step 0 `unit_pushforward_rFIP_inv`** [COMPILES]: `η^j ≫ j_*((rFIP j).inv.app N) = u_j.app N`
    (from `Adjunction.unit_leftAdjointUniq_hom_app`; `rFIP := restrictFunctorIsoPullback` IS
    `leftAdjointUniq (restrictAdjunction j) (pullbackPushforwardAdjunction j)` — defeq-typed have).
  - **Step 1 `restrict_unit_comp` (K5)** [COMPILES]: `u_q ≫ q_*(u_c) ≫ q_*c_*((rfComp c q).inv.app F)
    = u_{c≫q}.app F` — by `Scheme.Modules.hom_ext` + the Mathlib rfl-app lemmas
    (`restrictAdjunction_unit_app_app`, `restrictFunctorComp_inv_app_app`, `restrict_map`) +
    map-fusion + `Subsingleton.elim` on Opens-homs. KEY TRICK: state the all-`F.presheaf.map`
    version as a `have key` and `exact key` (kernel-defeq) — simp does NOT reliably fire here.
  - **`inner_beta_chain`** [COMPILES]: `η^c ≫ c_*(c^*(rFIPq.inv) ≫ rFIPc.inv ≫ rfComp.inv) =
    rFIPq.inv ≫ u_c ≫ c_*(rfComp.inv)` (unit naturality + Step 0).
  - **Step 2 `pullbackComp_rFIP_compat` (K4)** [COMPILES]: `(pullbackComp c q).hom.app F ≫
    rFIP(c≫q).inv.app F = c^*(rFIPq.inv.app F) ≫ rFIPc.inv.app (F.restrict q) ≫ rfComp.inv.app F`
    — by injectivity of `((ppAdj q).comp (ppAdj c)).homEquiv` + `Adjunction.homEquiv_unit`/
    `comp_unit_app`; side A via `pushPull_unit_comp` + `pushforwardComp_hom_app_id` + Step 0;
    side B via unit-naturality + Step 0 + Step 1.
  - **Step 3' `pushPull_toRestrict_comm`** [pending current compile]: `pushPullMap F (Over.homMk c wC)
    ≫ pC_*(rFIPpC.inv.app F) = q_*(rFIPq.inv.app F) ≫ q_*(u_c.app (F.restrict q)) ≫
    q_*c_*(rfComp.inv.app F) ≫ (pushforwardCongr wC).hom.app _ ≫ pC_*((restrictFunctorCongr wC).hom.app F)`
    — proof by `subst wC` + `rawPushPullMap_self` + Step 2 + inner_beta_chain; the two Congr-isos
    at `rfl` are identities (hom_ext + rfl-app + eqToHom_refl + `rfl`-finish for the
    defeq-but-not-syntactic 𝟙-objects). IMPORTANT: the tail uses pushforwardCongr/restrictFunctorCongr
    (whose `.app.app` are RFL F-restriction maps) instead of an X.Modules `eqToHom` — this makes the
    ENTIRE RHS section-level rfl-computable, killing the eqToHom_map juggling downstream.
  - **Step 4 assembly** [pending current compile]: `pls_eq` (pushPull_leg_sections.hom unfolds BY RFL
    to `Γ_V(j_*(rFIP.inv.app F)) ≫ eqToHom` — VERIFIED rfl works), `thin_resid5` (generic 4-restriction
    + 2-transport thin-category fusion, by subst + `show ...𝟙...` + map-fusion + Subsingleton), then
    the goal = congrArg-chain over `Γ_V(Step 3')` with all factors kernel-defeq to `P.map _.op` forms.
- **Dead ends this session:**
  - `calc` blocks FAIL with `Trans Eq Eq ?m` synthesis errors whenever intermediate terms have
    defeq-but-not-syntactic types (`(c≫q)_*` vs `q_*c_*`): instance synthesis matches at REDUCIBLE
    transparency. Use explicit `Eq.trans`/`refine Eq.trans ... ?_` chains instead — these unify at
    default transparency. (Step 0's homogeneous calc is fine.)
  - `simp only [Functor.map_comp] at h` does NOT fire on `(sectionFunctorV V).map (a ≫ b)` — avoid;
    G.map distributes over ≫ BY DEFEQ (Hom.comp_app is rfl), so no distribution is needed at all.
  - Instance synthesis `IsOpenImmersion (Scheme.Opens.ι (coverInterOpen 𝒰 σ'))` fails inside a
    positional application (mid-elaboration mvars) though `inferInstance` proves it standalone —
    use `@`-explicit application.
  - `set_option ... in` must precede the docstring, not sit between docstring and lemma.

### backboneIncl_proj — Attempt (restructure, scratch-validated combo, assembly pending)
- **Approach:** kill the elaboration wall by (a) ONE new abstract lemma
  `ι_reindex_wpci_inv_overWPproj` [COMPILES in /tmp/csileg_scratch2.lean] combining the
  whiskerEquiv-reindex layer + `ι_wpci_inv_overWPproj` in the abstract pre-extensive context
  (cheap there), and (b) generic reassociation lemmas `entry_chain`/`glue_chain` proved in a CLEAN
  abstract category context (where rw/simp are reliable), so the concrete proof is: `entry_chain ha2`
  → `rw [hexp]` (hexp: cechBackbone_left_sigma.inv = its five layers, BY RFL) → one `glue_chain`
  application (hypotheses: ι_sigmaMapIso_inv, htail hwZ, combo+assoc, hred) → `habs`. No
  per-layer congrArg-prefix re-elaboration.
- **Status:** concrete assembly compiling now in scratch2 (with a sorried copy of the proved
  `ι_wpci_inv_overWPproj` — elaboration-equivalent test).

### Status update (mid-session)
- `backboneIncl_proj`: scratch2 GREEN end-to-end → **merged into the Leg file** (combo lemma at the
  end of the WPCIproj section; `entry_chain`/`glue_chain` after it; new assembly tail replacing the
  sorry; heartbeats 3200000 + synthInstance 400000). Early validation via a truncated-file compile
  is running.
- Section seam: Steps 0–3' GREEN in scratch; Step-4 endgame iterating (fixes applied:
  `Scheme.Hom.comp_image` instead of bare `simp` for the image-of-composite Eq;
  `simp only [← Scheme.homOfLE_ι X hle]` for the two transport-Eqs — bare `rw [Scheme.homOfLE_ι]`
  on an image-typed goal FAILS with motive-not-type-correct because `''ᵁ` carries the
  IsOpenImmersion instance; preimage `⁻¹ᵁ` is instance-free and safe).

## Remaining work in session
1. Confirm both scratch compiles; fix residuals.
2. Merge into the Leg file: combo lemma into the WPCIproj section; entry/glue + new
   backboneIncl_proj body; Steps 0-3' + pls_eq + thin_resid5 + Step 4 body before/at
   pushPull_interLegHom_sections. Per-lemma `set_option maxHeartbeats 1600000 in` +
   `set_option synthInstance.maxHeartbeats 400000 in` (file relies on defaults otherwise).
3. Full-file `lake env lean` verification (baseline measured: 27m19s, EXIT=0 with the 2 sorries).

## Summary (interim)
- Sorry count: 2 → (target 0); no file edits yet — all new material compiler-verified in scratch
  against the real Base module first, because each full-file check costs ~27 min.

## Why I stopped (interim placeholder — will be updated)
Session in progress.
