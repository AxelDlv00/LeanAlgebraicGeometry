<!-- ARCHON_MEMORY.md — condensed project knowledge for all agents.
     Written by the plan agent and archon discuss. Read by all agents.

     HARD LIMITS: max 10 bullets · ~600 chars total.
     Prune before adding. Only keep what would surprise an agent reading
     the code fresh. Do NOT duplicate things obvious from the codebase.

     Good candidates: dead-end tactics, files not to touch, Mathlib gap
     coordinates, protected invariants, per-file hazards, standing routes
     to avoid, axioms that must not be accepted.

     Bad candidates: things already obvious from the code or PROGRESS.md,
     current sorry counts, task-specific details that change every iter.
-->

- FBC: SHEAF-LEVEL mate route DEAD; seeds via concrete-tilde chain. Apparatus `base_change_mate_*`/`pushforward_base_change_mate_*` COMPILE-DEAD (seeds=bare sorry) — excise in a DEDICATED iter (sync blueprint `\uses`), never with an FBC prover; KEEP `base_change_mate_regroupEquiv`+`base_change_map_affine_local`. CRUX (`pst` ring-square pseudofunctoriality) uses CONJUGATE-mate, route LIVE: the 3 lemmas `iterated_mateEquiv_conjugateEquiv`/`conjugateEquiv_mateEquiv_vcomp`/`mateEquiv_conjugateEquiv_vcomp` DO EXIST (`…Adjunction.Mates`, v4.30; bp009 loogle false-neg). HAZARD: `mateEquiv` is `TwoSquare`-valued (recover NatTrans via `.natTrans`/`equivNatTrans`; whiskerings are TwoSquare pasting, not `Functor.whiskerLeft`); the `homEquiv.injective` hand-peel is a DEAD END (strands a unit-prefixed eq). `conjugateEquiv_pullbackComp_inv`/`pullbackComp_eq_leftAdjointCompIso` are COMMENT-FICTION.
- `X.Modules`/value-ModuleCat diamond: positional `rw`/`simp`/`erw`/`comp_apply`/`hom_comp` fail → term-mode + `change`-to-nested-application.
- SNAP: carrier `AddCommGrpCat`; coherence via `Localization.Monoidal` `LocalizedMonoidal L W ε` synonym (full `MonoidalCategory(X.Modules)` DEAD; Option A redefine rejected). HAZARD: `⊗_loc` NOT defeq `tensorObj` → bridges object-iso-CONJUGATED via `tensorObjLocalizedIso=μ⁻¹;counit`, NOT bare `α=α^loc` (type error). `tensorObjAssoc` is a 5-segment composite; its bridge is NOT a clone of the braiding bridge — DECOMPOSED into 4 seams. HAZARD: whiskered unit `(η_P▷Q)^#` relates to μ ONLY via the `μ_natural_left/right` square (it joins two sheafified presheaf tensors, NOT a `⊗_loc`); a literal "whiskered-unit = μ component" is FALSE. `sectionMul_assoc_core` BRIDGE-FREE (section-η). Stalkwise DEAD. ASSEMBLY μ-pair WON'T cancel on the full goal (3 rfl-defeq folds: `comp_obj`+opaque `toPresheafOfModules`+opaque `tensorObj`); NO zero-restate coherence exists (analogist iter-011). Cancel ONLY by: isolate `hK_lhs`/`hK_rhs`, `show`-pin both μ's to ONE literal form (small-goal full-transparency defeq), then `Iso.hom_inv_id_assoc`; canonical-keystone restatement alone INSUFFICIENT. Lower-fragility structural route: `Localization.Monoidal.associator_hom_app`.
- Build `lake build <module>` (LSP hides kernel timeouts); never `maxHeartbeats 1e6`. No LLM API key.
