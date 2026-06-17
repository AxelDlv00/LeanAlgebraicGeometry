# Session 43 (iter-043) — Review Summary

## Metadata
- Sorry count: QUOT 4→4 (protected iter-176 scaffold stubs only), FBC 4→4. Net active sorry unchanged.
- New axiom-clean decls: **1** (`isLocalizedModule_basicOpen_of_hP1`, QuotScheme.lean ~2456).
- Targets attempted: QUOT gap2 (Piece B ✓ / Piece A blocked), FBC `sections_direct` (reversal — blocked).
- Build: both prover-touched files GREEN. `lean_verify` on the new decl (re-checked this phase) =
  `{propext, Classical.choice, Quot.sound}` (the line-2025 "opaque" warning is a docstring word, not a decl).
- sync_leanok (iter 43, sha 061213c): **+4 `\leanok`, 0 removed** (Picard_QuotScheme only).
- blueprint-doctor: **0 findings**. leandag: gaps=0, frontier=7, unmatched=1.

## Target 1 — QUOT gap2 Piece B `isLocalizedModule_basicOpen_of_hP1` — SOLVED (axiom-clean)
The mechanical eqToHom bridge from the gap2-core to the consumer-facing `restrictBasicOpenₗ`. Final structure:
- Instantiate `section_localization_hfr_aux_general` at `j = hU.fromSpec` (`S = Γ(X,U)`), slice elt `f' = f`,
  image section `f_im := gammaImageRingEquiv j ⊤ ((ΓSpecIso Γ(X,U)).inv f)` (`hf'` = `rfl`).
- Section ring iso `ρ := (asIso (X.presheaf.map (eqToHom eT.symm).op)).commRingCatIsoToRingEquiv`, with
  `eT : j ''ᵁ ⊤ = U` (`image_top_eq_opensRange ▸ opensRange_fromSpec`) and
  `eB : j ''ᵁ D(f) = X.basicOpen f` (Mathlib `IsAffineOpen.fromSpec_image_basicOpen`).
- `ρ f_im = f` via the proven crux `fromSpec_image_top_section_coherence`, then two `Iso.inv_hom_id_apply`.
- Bridge (I) `isLocalizedModule_of_ringEquiv_semilinear ρ … e₁ e₂` + `Submonoid.map_powers`.

Key errors learned (each closed):
- `have core := section_localization_hfr_aux_general …` → **typeclass instance problem is stuck**
  (`Module Γ(X, j''ᵁ ?) Γ(M, j''ᵁ D f)`); then **failed to synthesize `IsLocalizedModule (powers f_im)
  (have this := M.restrictₗ ii; this)`**. Fix: state `core` with the explicit
  `show Γ(M,j''ᵁ⊤) →ₗ[Γ(X,j''ᵁ⊤)] Γ(M,j''ᵁD(f)) from restrictₗ M ii` wrapper AND a matching
  `letI : Module … := Module.compHom …`; pass the SAME `show…from` as `g` so `haveI := core` matches by
  keyed-matching (defeq alone insufficient). (Both confirmed from iter-042 memory.)
- `Iso.commRingCatIsoToRingEquiv_symm_apply` / `_apply` → **Unknown constant** (only `_toRingHom` exists).
  Fix: unfold via `CommRingCat.comp_apply` + `change` to the explicit hom/inv composite, then
  `rw [Iso.inv_hom_id_apply, Iso.inv_hom_id_apply]`. Prefer `change` over `show` (avoids an elaboration reorder).
- Needs `set_option maxHeartbeats 1600000`.

## Target 2 — QUOT gap2 Piece A `isQuasicoherent_pullback_fromSpec` — BLOCKED (Mathlib-absent, flagged)
The only remaining input to the final gap2 `isLocalizedModule_basicOpen`. Confirmed Mathlib-absent (no
pullback/restriction-preserves-QC lemma; `IsQuasicoherent`/`QuasicoherentData` appear only in
`Tilde.lean` + `Quasicoherent.lean`). `hU.fromSpec` is an open immersion, so Piece A = the special case of
"pullback of QC along an open immersion is QC". To use `IsQuasicoherent.of_coversTop` one must show
`IsQuasicoherent (N.over (W i))` for the abstract slice sheaf — needs a geometric→slice back-transport.
Bounded attempt at the route-1 gateway `overRestrictUnitIsoInv` (dual of `overRestrictUnitIso`) hit:
(1) `Functor.IsContinuous` for `(Opens.overEquivalence U).functor` does NOT auto-synthesize inside
`unitToPushforwardObjUnit`; (2) supplying it exposes a coercion mismatch `↥V` vs `↥↑V`
(`unitToPushforwardObjUnit` infers `K` from `R := V.toScheme.ringCatSheaf`, space `↥↑V`, vs
`Opens.grothendieckTopology ↥V`). Draft removed to keep the file green; precise 5-step decomposition
recorded in task_results. **`% NOTE:` added to `lem:qcoh_pullback_fromSpec` blueprint block this phase** so
iter-044 doesn't re-discover the friction.

## Target 3 — FBC `pushforward_base_change_mate_sections_direct` — BLOCKED (REVERSAL, escalate)
**The iter-042-planned "affine tilde-transport" pivot is illusory.** The direct
`TensorProduct.induction_on` of `Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt` does NOT bypass the section-level mate: in the
concrete affine square the inner `g^*(f_*M)`-unit is the `g' = pullback.fst` unit (NOT a `Spec`-map), with
no element normal form (iter-035, FlatBaseChange.lean:2245). Evaluating `Γ(α)` on a generator forces transit
through the tilde dictionaries — the conjugate intertwining. Concretely `sections_direct` needs
`base_change_mate_inner_value_eq` (@2061) → `base_change_mate_fstar_reindex_legs` → the open keystone
`_legs_conj` (@1848). BOTH routes funnel through the single keystone. The prover attacked the keystone
directly (4 entry tactics, all "no match" — see milestones); the bespoke 5-layer composite `conjugateEquiv
adjL adjR` + assembled `β` is the genuine 5-iter wall (037–041). **0 decls added, correctly so** (any honest
`sections_direct` is sorry-backed). Recorded as a Known Blocker; FBC `cancelBaseChange` is not a dependency
of QUOT/GF/GR.

## Key findings / patterns
- gap2 Piece B eqToHom-bridge recipe → PROJECT_STATUS Knowledge Base (Proof Patterns).
- FBC affine-tilde-transport pivot illusory → PROJECT_STATUS Known Blockers.
- Both reusable elaboration gotchas (`show…from` + `letI compHom` instance plumbing; `change`-over-`show`)
  confirmed live.

## Subagent reports (this phase)
- **lean-auditor `quot-iter043`** (4/2/10): new decl clean, honest, genuine transport, no defeq abuse; the
  `letI compHom + show…from restrictₗ` idiom legitimate; all `Subsingleton.elim`/`eqToHom` steps sound. The
  4 "must-fix" are the pre-existing PROTECTED scaffold stubs (not new). Majors → recommendations §2.
  `logs/iter-043/lean-auditor-quot-iter043-report.md`.
- **lean-vs-blueprint-checker `quot-iter043`** (0 must-fix / 2 major): coverage-debt block for
  `isLocalizedModule_basicOpen_of_hP1` (own sub-lemma block, not folded into part (2)); under-specified
  `lem:qcoh_pullback_fromSpec` sketch (`% NOTE` re coercion — ADDED this phase). Minor: private `descent_*`
  pins want a `% NOTE`. → recommendations §1/§3.
  `logs/iter-043/lean-vs-blueprint-checker-quot-iter043-report.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:qcoh_pullback_fromSpec`: added `% NOTE:` recording the iter-043
  `↥V`/`↥↑V` coercion + `Functor.IsContinuous` non-synthesis friction at the `overRestrictUnitIsoInv`
  gateway, so the iter-044 Piece A prover doesn't re-discover it.
- No `\leanok` override needed (sync_leanok current, iter 43). No `\mathlibok` added (no Mathlib-backed
  decl this iter). No `\lean{...}` rename (the new decl is net-new, not a rename).

## Recommendations for next session
See `recommendations.md`. Headline: (1) blueprint a block for `isLocalizedModule_basicOpen_of_hP1` (coverage
debt); (2) dispatch Piece A `isQuasicoherent_pullback_fromSpec` as its own iter-044 lane (5-step route-1);
(3) FBC keystone needs user escalation or a dedicated multi-LOC build — do NOT re-dispatch in-loop conjugate
or `sections_direct` rounds.
