# Session 41 (iter-041) — review

## Metadata
- **Iteration:** 041. **Lanes planned:** 1, **ran:** 1 (`mathlib-build`, `QcohTildeSections.lean`).
- **Sorry count:** 0 → 0 in the prover file (file stays sorry-free); project inline-sorry 2 → 2 (both
  frozen/superseded: dead `CechAcyclic.affine`, frozen P5b).
- **New decls:** +3 axiom-clean (`qcoh_section_equalizer`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`,
  private `res_trans_apply`). New import: `Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing`.
- **Build:** GREEN. `lake env lean … QcohTildeSections.lean` EXIT 0 (prover). Both public decls re-verified
  by review with `lean_verify` → axioms = `{propext, Classical.choice, Quot.sound}`.
- **Targets attempted:** `qcoh_section_equalizer` (DONE), `tile_section_localization` (BLOCKED — not added,
  no sorry).

## Headline
The keystone re-route to the sheaf-axiom equalizer (planner D1, iter-041) is vindicated: its first frontier
leaf `qcoh_section_equalizer` landed axiom-clean — and **more general than blueprinted** (arbitrary index
`ι` + abstract open cover of `W`, not just basic opens). The second leaf `tile_section_localization` was
**correctly NOT forced**: the prover discovered the objective's premise ("mostly wiring DONE pieces via
`restrict_obj`-rfl", carried from `bridge.md` B6) is FALSE, proved it with a concrete `run_code` defeq
failure, built one of the two missing ingredients (the base-ring descent helper Mathlib lacks), and stopped
on a precisely-decomposed real gap rather than papering it with a sorry. This is exactly the keystone trap
the prior iter's planner memory warned about — now confirmed in Lean.

## Target 1 — `qcoh_section_equalizer` (SOLVED, axiom-clean) — PRIMARY OBJECTIVE #1
- **Statement (Lean, more general than blueprint):** for `F : (Spec R).Modules`, open `W`, arbitrary family
  `U : ι → (Spec R).Opens` with `∀ i, U i ≤ W` and `W ≤ ⨆ U i`:
  `Function.Injective ρ ∧ Function.Exact ρ δ`, where `ρ` is the product of restrictions
  `Γ(W,F) → ∏ Γ(Uᵢ,F)` and `δ` the difference of the two overlap restrictions into `∏ Γ(Uⱼ⊓Uₖ,F)`.
  Sections are the `ModuleCat R`-valued `(modulesSpecToSheaf.obj F).presheaf.obj (op ·)`.
- **Proof structure:** pure sheaf axiom, no route deps. Injectivity ← `TopCat.Presheaf.IsSheaf.section_ext`;
  `range ρ ⊆ ker δ` ← presheaf functoriality (private `res_trans_apply`: `res∘res = res` across `A≤B≤C`);
  `ker δ ⊆ range ρ` ← `δ t = 0 ↔ TopCat.Presheaf.IsCompatible` + `TopCat.Sheaf.existsUnique_gluing'`.
- **Key error fixed:** `have hsheaf : P.presheaf.IsSheaf := P.cond` → `CategoryTheory.Sheaf.cond` is
  DEPRECATED (use `ObjectProperty.FullSubcategory.property`). Resolved to `:= P.2`. (See KB.)
- **Verified:** `lean_verify` axiom-clean; full `lake env lean` EXIT 0.

## Target 2 — `isLocalizedModule_powers_restrictScalars_of_algebraMap` (SOLVED, axiom-clean) — keystone helper
- The **converse** of Mathlib's `IsLocalizedModule.of_restrictScalars` (R→A ascent); Mathlib LACKS the A→R
  descent. For `R`-algebra `A`, `A`-modules `M N` with scalar tower, `φ : M →ₗ[A] N`: if
  `IsLocalizedModule (powers (algebraMap R A f)) φ` over `A` then
  `IsLocalizedModule (powers f) (φ.restrictScalars R)` over `R`.
- **Proof:** direct over the 3 clauses; `map_units` via `Module.End.isUnit_iff` (base-independent
  bijectivity), surj/exists via `(algebraMap R A f)^k • x = f^k • x` (`algebraMap_smul` + `map_pow`, scalar
  tower). Earlier `rw` of the pointwise pow-of-algebraMap form failed to match — the `Module.End.isUnit_iff`
  reduction sidesteps it.
- This is ingredient #4 of `tile_section_localization`.

## Target 3 — `tile_section_localization` (BLOCKED — not added, no sorry) — PRIMARY OBJECTIVE #2
- **The objective premise was FALSE.** Planned as "mostly wiring DONE pieces via `restrict_obj`-rfl". The
  prover ran the concrete defeq check:
  `rfl` between `↥((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (op ⊤))` and
  `↥((modulesSpecToSheaf.obj F).presheaf.obj (op (specBasicOpen g)))` → **`rfl` FAILS**.
- **Why:** `restrict_obj : Γ(M.restrict f,U) = Γ(M, f ''ᵁ U)` IS rfl, but only for `SheafOfModules`
  sections valued in `ModuleCat (Γ(U,O))` (the LOCAL ring). This file uses `modulesSpecToSheaf.obj F` =
  `forgetToSheafModuleCat ⋙ restrictScalars (R ≅ Γ(⊤,O))`, valued in `ModuleCat R` (the GLOBAL ring) — it
  does NOT commute with `restrict` definitionally. The carriers differ by (i) base ring `R_g` vs `R`
  (handled by the new descent helper) AND (ii) the open `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ ⊤)`
  vs `specBasicOpen g` (provably equal, not rfl).
- **Precise decomposition left for next iter** (the genuine remaining gap):
  - **Sub-lemma A (opens identities):** `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ ⊤) = specBasicOpen g`
    and the `D(gf)` version (`PrimeSpectrum.basicOpen_mul`).
  - **Sub-lemma B (`modulesSpecToSheaf ∘ restrict` section comparison, ~100–150 LOC):** an `R_g`-linear iso
    `Γ_{R_g}(V, tile) ≅ Γ_R((specBasicOpen g).ι ''ᵁ (iso.inv ''ᵁ V), F)` natural in `V`, intertwining
    restriction. THIS is the load-bearing piece.
  - **Assembly:** transport step-2's `IsLocalizedModule (powers f̄)` (from `section_isLocalizedModule_of_presentation`,
    DONE) across Sub-lemma B, then apply the DONE descent helper to land over `R`.

## Key findings / patterns
- The "keystone reconciliation is not rfl" trap (the project memory note) is now confirmed in Lean with a
  concrete defeq failure — see Known Blockers in PROJECT_STATUS.md.
- `CategoryTheory.Sheaf.cond` deprecated → use `.2` (FullSubcategory.property).
- Mathlib has `IsLocalizedModule.of_restrictScalars` only as R→A ascent; the A→R descent is project-local.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_section_equalizer`: added `% NOTE:` recording that the
  Lean decl is STRICTLY MORE GENERAL (arbitrary index `ι` + abstract cover of `W`, vs the basic-open
  statement) and that private helper `res_trans_apply` is part of this proof (DAG coverage bundles here).
- No `\leanok` touched (owned by sync_leanok — it added `\leanok` to `lem:qcoh_section_equalizer`'s
  statement + proof this iter, `sha d60347f`, +2/−2).
- No `\mathlibok` added (all new decls are project theorems, not Mathlib re-exports).
- No `\lean{...}` rename (the planner's pre-written `\lean{AlgebraicGeometry.qcoh_section_equalizer}`
  matches the prover's chosen name).

## Subagent / doctor notes
- **blueprint-doctor:** clean (no orphan chapters, all refs/uses resolve, no `axiom` decls).
- Review subagent skips recorded in `iter/iter-041/review.md`.

## Recommendations
See `recommendations.md`. Headline: next iter builds Sub-lemma A + Sub-lemma B (do NOT re-dispatch
`tile_section_localization` as "wiring"); `qcoh_section_equalizer` is done and ready to consume in the
kernel-comparison leaf.
