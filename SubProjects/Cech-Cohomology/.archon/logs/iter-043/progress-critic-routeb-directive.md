# Progress-critic directive — iter-043

Assess convergence of the single active route below. Fresh-context: you do NOT see STRATEGY/blueprint/iter narrative — only the extracted signals.

## Active route: 01I8 keystone (sheaf-axiom equalizer) — file `QcohTildeSections.lean`

The keystone for the project's critical path is, for a quasi-coherent `F` and `f : R`,
`IsLocalizedModule (powers f)` of the global-section restriction `Γ(X,F) → Γ(D(f),F)`. It is
reached by a linear chain of leaves on the tilde tiles (NOT on global sections). Each iter lands
axiom-clean declarations; the residual leaf-set shrinks toward the keystone.

### Signals, last 4 iters (sorry count is project-wide; both sorries are frozen/superseded, never the active file)

| Iter | File worked | Decls added (axiom-clean) | Prover status | Project sorry | Recurring blocker phrase |
|------|-------------|---------------------------|---------------|---------------|--------------------------|
| 039  | QcohRestrictBasicOpen | 0 (noop-drop: objective never dispatched — keyword trap, not a prover run) | n/a | 2 → 2 | (no prover ran) |
| 040  | QcohRestrictBasicOpen | +4 (`overBasicOpenIsoRestrict` B3 obj-iso, `presentationModulesRestrictBasicOpen` B4, +2 helpers) | COMPLETE | 2 → 2 | none |
| 041  | QcohTildeSections | +3 (`qcoh_section_equalizer` = degree-0/1 sheaf-axiom equalizer; `isLocalizedModule_powers_restrictScalars_of_algebraMap` base-ring descent; private `res_trans_apply`) | COMPLETE (1 of 2 planned leaves; 2nd correctly NOT papered with sorry — discovered its sketch was unsound) | 2 → 2 | "tile section is not restrict_obj-rfl" |
| 042  | QcohTildeSections | +1 (`tile_image_opens_identities` = Sub-lemma A, opens identities) | COMPLETE (named target `tile_section_localization` deferred, no sorry papered; confirmed Sub-lemma B is genuinely non-definitional via clean `lake env lean`) | 2 → 2 | "Sub-lemma B section comparison is non-definitional" |

### Decomposition state of the remaining keystone work (for context)
- `tile_section_localization` (last tile leaf) needs three ingredients: Sub-lemma A (DONE iter-042),
  the base-ring descent (DONE iter-041), and **Sub-lemma B `tile_section_comparison`** (NOT yet
  attempted — iter-042 only *confirmed* it is non-definitional; it did not attempt the construction).
- Sub-lemma B is a ~100–150 LOC natural `R_g`-linear section-comparison iso (bridging the global-ring
  `modulesSpecToSheaf.obj` functor and the local-ring `Γ(M,-)` functor). It is the genuine remaining cost.
- Downstream (gates on the keystone, not yet started): `qcoh_section_kernel_comparison` → keystone
  `qcoh_section_isLocalizedModule` → Route-B assembly.

### Strategy estimate for this route (verbatim from STRATEGY `## Phases & estimations`)
- Phase: "01I8 `F≅~(ΓF)` via section-localization (Route B)" — Status ACTIVE, **Iters left ~2**, LOC ~120–250.
- Route entered the sheaf-axiom-equalizer sub-phase at iter-041 (re-route iter); 2 elapsed iters since.

### This iter's (043) objective proposal
- ONE prover lane: `QcohTildeSections.lean` → build Sub-lemma B `tile_section_comparison`, then assemble
  the last tile leaf `tile_section_localization`. mathlib-build mode. (Sub-lemma B is a NEW target — first
  genuine construction attempt; iter-042 only confirmed it is needed.)

## Question
Is this route CONVERGING / CHURNING / STUCK / UNCLEAR? In particular: is dispatching a prover at Sub-lemma B
a genuine next step, or repeated-blocker churn? Is the iters-left estimate (~2) credible given the elapsed
trajectory? If CHURNING/STUCK, name the corrective TYPE.
