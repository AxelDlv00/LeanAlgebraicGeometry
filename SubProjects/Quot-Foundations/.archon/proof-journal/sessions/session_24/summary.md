# Session 24 (iter-024) — Review Summary

## Metadata
- **Iteration / session:** iter-024 / session_24
- **Model:** claude-opus-4-8
- **Prover lanes (2):** FBC fine-grained (FlatBaseChange.lean) + QUOT keystone mathlib-build (QuotScheme.lean)
- **Sorry counts (per prover-edited file):**
  - `FlatBaseChange.lean`: 6 → 5 (−1; Seam B `gstar_generator_close` eliminated)
  - `QuotScheme.lean`: 4 → 4 (unchanged; the 4 are pre-existing protected stubs. Two NEW axiom-clean
    theorems added carrying no sorry)
- **Net active sorry this iter:** −1; **+6 axiom-clean declarations** (3 FBC eCancel atoms + Seam B
  generator_close + 2 QUOT affine localization theorems).
- **Build:** both modules `lake build` GREEN (FBC 8318 jobs, QUOT 8317). Both `lean_verify`
  axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **sync_leanok:** ran on this tree (iter 24, sha `abf7575`, +7 `\leanok`, chapters_touched =
  `Cohomology_FlatBaseChange.tex`, `Picard_QuotScheme.tex`).
- **blueprint-doctor:** 0 findings (no orphan chapters, no broken refs/uses, no new axioms).

## Headline
The iter-021/022 effort-breaker decomposition of the FBC `gstar_transpose` wall **paid off**: all
**three `inner_eCancel` atoms closed axiom-clean** as small one-/three-line lemmas, and **Seam B
`gstar_generator_close` closed by `rfl`** — the conjectured element-lemma re-break (`inner_value_apply`
/ `regroupEquiv_inv_one_tmul`) was unnecessary. On QUOT, the GF/QUOT-shared keystone retarget produced
**two axiom-clean affine-localization theorems** (the Spec-affine engine of the keystone); the general
keystone itself stays blocked on two confirmed Mathlib-absent ingredients.

## FBC — `FlatBaseChange.lean` (fine-grained pass)

### Solved (axiom-clean)
- **`base_change_mate_inner_eCancel_eUnit`** — "the `e`-unit is an iso". Body:
  `haveI := pullback_isEquivalence_of_iso e; infer_instance`.
- **`base_change_mate_inner_eCancel_pushforwardComp`** — "the surviving `pushforwardComp` factor has
  identity Γ-image". The blueprint hint `rw [h, Functor.map_id, Functor.map_id]` FAILS twice (ambiguous
  with monadic `Functor.map_id`; pattern `(pushforward (Spec.map φ)).map (𝟙 ?X)` won't match through the
  composed-functor position). Working form is the **term-mode chain**
  `rw [h]; exact ((moduleSpecΓFunctor).congr_map ((pushforward (Spec.map φ)).map_id _)).trans (moduleSpecΓFunctor.map_id _)`.
- **`base_change_mate_inner_eCancel_pullbackComp`** — "the `pullbackComp` factor cancels its inverse".
  The blueprint hint's `intro _ _; …` FAILS (`letI`/`let` signature binders are auto-introduced); bare
  `exact (Scheme.Modules.pullbackComp _ _).hom_inv_id_app (tilde M)` closes it.
- **`base_change_mate_gstar_generator_close` (Seam B)** — residual element identity
  `ρ.hom x = regroupEquiv.inv (1 ⊗ₜ x)` after the existing `ext`/counit scaffold closes by **`rfl`**
  (both sides reduce definitionally to `(1 : A ⊗_R R') ⊗ₜ[A] x`). `lean_multi_attempt` confirmed `rfl`
  before the edit. The iter-023 conjectured re-break was unnecessary.

### Blocked / partial
- **`base_change_mate_inner_value_eq` (Seam A)** — PARTIAL, `sorry` retained @1617. The step-(ii)
  Γ-collapse scaffold (`Functor.map_comp ×3` + `simp only [gammaMap_pushforwardComp_inv_eq_id,
  gammaMap_pushforwardCongr_hom, Category.assoc]`) is in place and the three atoms it needs are now
  proved. **Blocker = the recurring literal-form-lock** (`memory/fbc-subst-legs-literal-form-lock`):
  after the collapse the surviving
  `moduleSpecΓFunctor.map ((pushforwardComp (pullback.fst …) (Spec.map φ)).hom.app …)` factor prints
  **verbatim identical** to atom 2's LHS, yet `rw`, `simp only`, and even
  `have h := gammaMap_pushforwardComp_hom_eq_id …; rw [h]` (where `h`'s LHS prints the same) ALL fail
  "did not find an occurrence of the pattern" — invisible implicit-argument divergence. The atoms are
  correct but cannot be *applied by pattern* against the locked goal.
  **Named next routes:** (a) a `conv`/`Eq.mpr` congruence targeting the factor by POSITION not pattern;
  or (b) re-derive the inner composite via `pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)`
  BEFORE the legs lock into `pullback.fst/snd` (distribute the `(g')`-unit while it is still the free
  composite `e.hom ≫ Spec inclA`), so the atoms apply to free-form factors.
- **`base_change_mate_gstar_transpose` (Seam 3)** — PARTIAL, `sorry` @1800, gated on `inner_value_eq`.
  Crux (a) = `inner_value_eq` (still sorry), crux (b) = `gstar_generator_close` (now CLOSED). Once
  Seam A closes, gstar_transpose cites both directly. Not attempted further this session.

## QUOT — `QuotScheme.lean` (keystone mathlib-build)

### Solved (axiom-clean, both NEW; no blueprint block yet → coverage debt)
- **`AlgebraicGeometry.isLocalizedModule_tilde_restrict`** (~L456) — basic-open restriction of a `tilde N`
  sheaf is `IsLocalizedModule (powers f)` over `R`. Route: Mathlib already supplies
  `IsLocalizedModule (.powers f) (tilde.toOpen N (basicOpen f)).hom`; since `tilde.toOpen N ⊤` is an iso
  (`tilde.isoTop`) and `tilde.toOpen N (D f) = tilde.toOpen N ⊤ ≫ restriction` (`tilde.toOpen_res`),
  pre-compose with the inverse iso via `IsLocalizedModule.of_linearEquiv_right`. **Pitfall:**
  `↑e ∘ₗ ↑e.symm = id` does NOT close with `simp`/`rw` when `e` is `set`/`let`-bound (simp → `↑(e.symm ≪≫ₗ e)`
  then stalls; rw hits `∘ₗ` associativity / semilinear-vs-linear mismatch). Fix: pointwise
  `LinearMap.ext; intro x; change …; rw [e.apply_symm_apply]`.
- **`AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ`** (~L510) — transports the above
  to any `M : (Spec R).Modules` with `[IsIso M.fromTildeΓ]`. Route: `modulesSpecToSheaf.map M.fromTildeΓ`
  is an iso; forget to the presheaf via `(TopCat.Sheaf.forget …).map` to get iso NatTrans `ψ`; its
  naturality square for `D(f) ⟶ ⊤` intertwines the restriction maps; post-/pre-compose
  `isLocalizedModule_tilde_restrict` with the two component isos. **Pitfalls:** a `TopCat.Sheaf` morphism
  has NO `.val`/`.1` field (it is an `InducedCategory.Hom`) — use `(forget _ _).map φ`; `(forget).obj S`
  is defeq to `S.presheaf` but NOT syntactic, so the final map-identity must close in **term mode**
  (`refine (?_ : _=_).trans hc.symm; congr 1; exact …`), not `rw [hc]`; `of_linearEquiv`/`_right` are
  instances — pass `(S:=)(f:=)(e:=)` by NAME (positional mis-binds `S`); two-deep auto-`inferInstance`
  chaining does NOT fire — build the two steps explicitly.

### Blocked
- **`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`** (general `X`, affine `U`,
  arbitrary quasi-coherent `F`) — NOT added (would require a sorry). Gated on two confirmed
  Mathlib-absent ingredients:
  1. **gap1** — QCoh(Spec R) ≃ Mod R, i.e. `IsQuasicoherent M → IsIso M.fromTildeΓ`. Mathlib has only
     `isIso_fromTildeΓ_iff` (essImage) and `isIso_fromTildeΓ_of_presentation` (global `Presentation`),
     NOT the quasicoherent→iso bridge (descent-level; the Tilde source comment confirms it is unbuilt
     at the pin). **This is the bottleneck** — `isLocalizedModule_restrict_of_isIso_fromTildeΓ` takes
     exactly `[IsIso M.fromTildeΓ]` as hypothesis, so closing gap1 makes the affine-QC case immediate.
  2. **gap2** — affine transport `X`-open `U ↦ Spec Γ(X,U)` + reconciling the project's `Ab`-valued
     `Γ(F,U)` with the `ModuleCat R`-valued tilde world (the modules analogue of
     `AffineScheme.isLocalization_basicOpen`).
  - Informal agent unavailable (no `DEEPSEEK/MOONSHOT/OPENROUTER/OPENAI/GEMINI_API_KEY` in env). No
    affine shortcut past gap1 exists.

## Subagent reports (review phase)
- `lean-auditor` (`iter024`): **PASS with 1 must-fix (MF-1, major)** — stale "REMAINING CRUX" comment
  in `base_change_mate_gstar_transpose` (~L1797–1809) still names item (b) generator_close as
  outstanding though it was proved this iter. All 6 new decls verified correct; QUOT section docstring
  accurate; no unexpected sorry across all 8 files. Report:
  `.archon/task_results/lean-auditor-iter024.md`.
- `lean-vs-blueprint-checker` (`fbc-iter024`): 3 eCancel atoms axiom-clean with exact signature
  matches; `gstar_generator_close` faithfully described; **1 major** — `lem:base_change_mate_inner_value_eq`
  is mathematically correct but under-specified for the literal-form-lock (chapter should prescribe the
  pre-subst distribution order or the `conv`/position approach); 2 minor. Report:
  `.archon/task_results/lean-vs-blueprint-checker-fbc-iter024.md`.
- `lean-vs-blueprint-checker` (`quot-iter024`): **sound, 0 red flags; major coverage debt** — the 2 new
  theorems have no `\lean{}` blocks; the keystone `% NOTE` is accurate; the keystone proof sketch needs
  the two new intermediates in `\uses{}` + gap2 flagged. Report:
  `.archon/task_results/lean-vs-blueprint-checker-quot-iter024.md`.

## Key findings / patterns
- **Effort-breaker decomposition delivered.** The 3 atoms + Seam B closed cheaply once frontier-ready —
  vindicating the iter-021→024 STUCK-corrective chain (decompose, don't re-dispatch the monolith).
- **rfl beat a conjectured element-lemma re-break** (Seam B): always `lean_multi_attempt` `rfl` on a
  residual element identity before authoring helper lemmas.
- **Literal-form-lock is now the live FBC wall** (recurring; `memory/fbc-subst-legs-literal-form-lock`):
  pattern-applying an atom whose LHS prints identically to the goal subterm fails on invisible implicit
  args. The fix is positional (`conv`/`Eq.mpr`) or pre-subst free-form distribution, NOT another atom.
- **Tilde-localization affine engine** (QUOT): `of_linearEquiv` / `of_linearEquiv_right` over the
  `tilde.toOpen` Mathlib localization instance + `tilde.isoTop` is the route to "sections localize on a
  basic open" for `tilde`/essImage sheaves — but the general QC case is gated on the unbuilt QCoh≃Mod
  bridge.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:qcoh_section_localization_basicOpen`: added
  `% NOTE (iter-024 review)` recording that the pinned Lean decl `isLocalizedModule_basicOpen` does NOT
  yet exist, naming the two affine ingredients the prover DID build and the two Mathlib-absent
  prerequisites (gap1 QCoh≃Mod, gap2 affine transport). Pin left unmarked (correct).
- No `\leanok` touched (sync-owned). No `\mathlibok` warranted (both new theorems are project proofs,
  not Mathlib re-exports). No `\lean{}` rename needed (FBC atom names match the planned blueprint pins;
  the 2 QUOT theorems have no blocks yet — listed as coverage debt in recommendations).

## Recommendations
See `recommendations.md`. Headlines: (1) blueprint-writer round on `lem:base_change_mate_inner_value_eq`
to prescribe the literal-form-lock workaround BEFORE re-dispatching Seam A; (2) coverage-debt blueprint
blocks for the 2 new QUOT theorems; (3) comment-cleanup for the stale FBC gstar `REMAINING CRUX` block
(lean-auditor MF-1, review cannot edit `.lean`); (4) gap1/gap2 blueprint blocks before any keystone
prover.
