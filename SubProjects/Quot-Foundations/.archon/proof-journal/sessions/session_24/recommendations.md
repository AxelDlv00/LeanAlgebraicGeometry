# Recommendations for iter-025 (from session_24 review)

## CRITICAL / HIGH (act first)

1. **FBC Seam A `inner_value_eq` — blueprint-writer round BEFORE re-dispatch (lvb-fbc-iter024 MAJOR).**
   The chapter block `lem:base_change_mate_inner_value_eq` is mathematically correct but
   **under-specified for the literal-form-lock**, which is the actual blocker. A prover following the
   prose-as-written implements step-(ii) Γ-collapse first and then finds the eCancel atoms cannot be
   applied to the locked-form goal (exactly what happened this iter). Have a blueprint-writer prescribe
   ONE of the two named tactical routes in the proof block:
   - **(a) positional close** — a `conv`/`Eq.mpr` congruence that targets the surviving
     `pushforwardComp.hom`-factor by POSITION, then rewrites with atom 2 there; or
   - **(b) pre-subst free-form distribution** — re-derive the inner composite via
     `pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` WHILE the legs are still the free
     composite `e.hom ≫ Spec inclA`, BEFORE they lock into `pullback.fst/snd`, so the three atoms apply
     to free-form factors.
   This is the documented `fbc-subst-legs-literal-form-lock` wall; do NOT re-dispatch a Seam A prover on
   the current thin block — it will churn on the same lock. Once the block prescribes a route, Seam A is
   a high-confidence close (all 3 atoms proved, scaffold in place), and `gstar_transpose` cascades.

2. **Stale `.lean` comment — FBC gstar `REMAINING CRUX` (lean-auditor MF-1, major; review cannot edit
   `.lean`).** `base_change_mate_gstar_transpose` (~L1797–1809 of `FlatBaseChange.lean`) still lists
   item (b) — the generator close — as outstanding, but `base_change_mate_gstar_generator_close` was
   proved this iter. The `sorry` itself is correct; only the comment is stale. Fold a one-line comment
   fix into the next FBC prover's objective (or a no-prover cleanup slot).

## MEDIUM

3. **Coverage debt — 2 new QUOT theorems need blueprint blocks (lvb-quot-iter024 MAJOR;
   `dag-query unmatched` count = 2).** Both are axiom-clean `lean_aux` nodes invisible to the graph.
   Add lemma blocks between `lem:isLocalization_basicOpen_mathlib` and
   `lem:qcoh_section_localization_basicOpen`:
   - `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` — "Basic-open restriction of a `tilde`
     sheaf is a module localization." Depends on the Mathlib instance
     `IsLocalizedModule (.powers f) (tilde.toOpen N (basicOpen f)).hom`, `tilde.isoTop`, `tilde.toOpen_res`,
     `IsLocalizedModule.of_linearEquiv_right`. (Part 2's Spec-local core of the keystone.)
   - `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` — "Basic-open restriction
     localizes for a sheaf in the essential image of `tilde`." `\uses` the previous lemma +
     `isIso_fromTildeΓ_iff`. (The affine engine consumed by the still-open general keystone.)
   Then expand the keystone `lem:qcoh_section_localization_basicOpen` proof sketch to cite these two in
   `\uses{}` and to flag gap2 (the affine transport) explicitly (lvb-quot-iter024).

4. **Keystone gap1/gap2 must be blueprinted before ANY keystone/GF-G1 prover.** The general
   `isLocalizedModule_basicOpen` is gated on (gap1) `IsQuasicoherent M → IsIso M.fromTildeΓ`
   (descent-level, Mathlib-absent) and (gap2) the affine `U ↦ Spec Γ(X,U)` transport with Ab↔ModuleCat
   reconciliation. Add blueprint blocks for both (gap1 is the real math — recommend a
   reference-retriever + blueprint-writer pass; the Stacks "QCoh = essential image of tilde" tag is the
   source). **Do NOT dispatch a keystone prover until gap1 has a Lean target** — the prover this iter
   built the affine engine to its ceiling and confirmed there is no affine shortcut past gap1. The plan
   agent's retarget (build the keystone once in QuotScheme) was correct; the remaining work is now
   gap1 → then `isLocalizedModule_restrict_of_isIso_fromTildeΓ` specialised → then lift across
   `hU.fromSpec` mirroring `AffineScheme.isLocalization_basicOpen`.

5. **GF-geo G1/G3 still deferred — unblocks only after the keystone lands.** `genericFlatness` @2264
   bottoms at G1 (`gf_qcoh_fintype_finite_sections`, `\uses{lem:qcoh_section_localization_basicOpen}`)
   and G3 (flat-locality). G1 cannot be built until the keystone (or gap1) exists. Keep GF-geo deferred;
   once the keystone lands, decide shared-extraction vs the QuotScheme import for FlatteningStratification
   (FlatteningStratification does NOT import QuotScheme — a self-contained G1 copy would be a parallel API
   the PARALLELISM directive warns against).

## DO NOT RETRY without a structural change

- **FBC Seam A `inner_value_eq` via pattern-applying the atoms (`rw`/`simp only`/explicit
  `have…rw`).** All three forms fail the literal-form-lock (goal subterm vs lemma LHS differ in invisible
  implicit args, despite identical pretty-print). Must switch to positional (`conv`/`Eq.mpr`) or the
  pre-subst free-form route — see HIGH #1. (Recurring wall; `memory/fbc-subst-legs-literal-form-lock`.)
- **Keystone `isLocalizedModule_basicOpen` via a tilde-based affine shortcut bypassing gap1.** There is
  none on an affine scheme without the QCoh≃Mod equivalence — confirmed this iter. Build gap1 first.
- **FBC `base_change_mate_fstar_reindex_legs` (@1421).** Dead code (consumed by nothing live); awaiting a
  removal refactor. Do not re-attempt; do not count its sorry against the live FBC frontier.

## Reusable proof patterns discovered (also folded into PROJECT_STATUS Knowledge Base)
- Term-mode `congr_map`/`map_id` chain to collapse a functor over a `𝟙` through a composed-functor
  position where `rw [Functor.map_id]` is ambiguous/won't-match (FBC atom 2).
- Pointwise `LinearMap.ext; change; rw [e.apply_symm_apply]` to discharge `↑e ∘ₗ ↑e.symm = id` for a
  `set`/`let`-bound `LinearEquiv` where `simp`/`rw` stall (QUOT tilde-restrict).
- `(TopCat.Sheaf.forget _ _).map φ` to reach the presheaf NatTrans of a sheaf morphism (no `.val`/`.1`
  on `InducedCategory.Hom`); close the resulting defeq-not-syntactic map identity in term mode; pass
  `of_linearEquiv`/`_right` args by name and build multi-step localization transports explicitly
  (QUOT restrict-of-isIso).
- `rfl` closes the Seam-B generator residual `ρ.hom x = regroupEquiv.inv (1 ⊗ₜ x)` — always
  `lean_multi_attempt` `rfl` on a residual element identity before authoring helper lemmas.
