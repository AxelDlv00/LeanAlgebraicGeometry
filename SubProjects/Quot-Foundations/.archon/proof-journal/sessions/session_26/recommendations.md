# Recommendations for iter-027 (plan agent)

## HIGH — act this iter

### 1. FBC: focused `prove` on `base_change_mate_fstar_reindex_legs` (the erw unlock is real, cash it in)
The 4-iter literal-form lock is broken (`erw` fires the unit expansion). The single remaining de-sorry
on `_legs` **cascades** to `fstar_reindex`, `inner_value_eq` (free `exact`), and feeds `gstar_transpose`.
Precise route (prover-supplied, verified goal state): term-mode `…_gammaDistribute` distribution (NOT
`simp/rw [Functor.map_comp]` — `X.Modules` instance diamond) → UNFOLD `base_change_mate_codomain_read_legs`
to expose `iso_g`/`unit_iso.symm`/`pushforwardComp(e,inclR').symm` → reassociate so each proved
`inner_eCancel` atom's two factors are adjacent → apply the 3 atoms → Seam-1 `base_change_mate_unit_value`
on the survivor `η^{Spec ιA}` → ring transport. **This is FBC's highest-leverage single action.**
- **Do NOT re-assign the inline pre-subst route on `inner_value_eq`** — it is walled by the
  leg-dependent motive (3 transport attempts failed: ill-typed equation / "failed to compute motive" /
  "motive is not type correct"). The expansion must happen post-`subst` inside `_legs`.
- The progress-critic's iter-026 escalation (mathlib-analogist cross-domain consult on the literal-form
  lock) is **no longer needed** — the viable route (`erw` in `_legs`) is found.

### 2. Clear the 15-node coverage debt (`archon dag-query unmatched`) — blueprint these `lean_aux` nodes
Every Lean decl must have tex. The plan agent authors the prose (review cannot). Then `\mathlibok`/`\lean{}`
markers can be applied next review.
- **QUOT (4):** `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (public — needs its OWN `\lean{}` node;
  it is the G1-assemble step taking explicit `H : ∀ f, IsLocalizedModule …`, **NOT**
  `IsQuasicoherent`), `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (public, characterization),
  `isIso_sheaf_of_isIso_app_basicOpen` (private helper), `bijective_comp_of_localizations` (private helper).
  **⚠ Do NOT re-point `lem:qcoh_affine_isIso_fromTildeΓ`'s `\lean{}` to
  `isIso_fromTildeΓ_of_isLocalizedModule_restrict`** (the prover's QuotScheme.md suggestion) — the lvb
  checker confirmed the signatures differ (gap1 takes `IsQuasicoherent M`; the new decl takes explicit
  `H`). Add a fresh node for the reduction and have gap1 `\uses` it + G1-core.
- **GR (11):** `minorDet_self`, `chartOverlap`, `chartIncl`, `chartIncl_isOpenImmersion`,
  `chartIncl_self_isIso`, `chartTransition`, `chartTransition_self`, `awayPullbackIso`,
  `awayPullbackIso_inv_fst`, `awayPullbackIso_inv_snd`, `awayMulCommEquiv` — all feed
  `def:gr_glued_scheme`. `\mathlibok`-anchor candidates (mark once blocked-out):
  `chartIncl_isOpenImmersion` (`inferInstanceAs` of `instIsOpenImmersionMapOfHomAwayAlgebraMap`),
  `awayPullbackIso`/`_inv_fst`/`_inv_snd`/`awayMulCommEquiv` (pure `pullbackSpecIso`+`IsLocalization.*`).

### 3. GR blueprint must-fix (lvb): expand `def:gr_glued_scheme` BEFORE any GlueData prover
The chapter is **under-specified** — no `Scheme.GlueData` field breakdown, no mention of the product-order
mismatch (`awayMulCommEquiv` as `orderSwap`), no route to `t_fac`. A prover cannot assemble the GlueData
from the current prose. Have a blueprint-writer add: the 9-field map (`U/V/f/f_open/f_id/t/t_id` →
existing decls; `t'/t_fac/cocycle/.glued` → the construction), the `orderSwap` subtlety, and the
`t_fac` route (rewrite legs via `awayPullbackIso_inv_fst/_snd` → `Spec`-faithfulness → `RingHom` eqn via
`IsLocalization.ringHom_ext`; `cocycle` telescopes to the proven ring `cocycleCondition` @L604). Then GR
is a clean next-session GlueData build (no missing Mathlib facts, only volume).

### 4. FBC stale/false-completion `.lean` comments (lean-auditor must-fix; review cannot edit `.lean`)
A prover/refactor pass should fix three misleading comment blocks (the proofs themselves are fine):
- L235–247: `pushforward_spec_tilde_iso` comment claims an outstanding QC obligation — the decl is
  **fully proved**; strip the stale claim.
- L1575/1578: `base_change_mate_inner_value_eq` docstring says "re-derived INLINE through proved standalone
  atoms" while the body is `sorry` — **false-completion**; correct to reflect the gated-on-`_legs` status.
- Two docstrings mislabel where their `sorry` actually sits (it is in `gstar_transpose`, not at a "per-
  generator node"/"below"). Fold into the same comment-cleanup. Cheapest as a rider on the FBC #1 prove.

## MEDIUM

### 5. QUOT G1-core is a multi-session descent — scope it explicitly, don't re-assign as a one-shot
G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) is genuine Stacks-01HA descent. Prover's
4-ingredient decomposition (build each axiom-clean): (1) `quasicoherentFiniteBasicCover` — finite
basic-open presentation cover from `QuasicoherentData` (**heaviest unknown; needs the `Scheme.Modules`
site/`over` API; budget a full session for step 1 alone**); (2) `localTilde` on each `D(g_a)`;
(3) `flatEqualizerLocalize` (flat-localization of the finite sheaf-equalizer — the substantive content);
(4) wrap as `IsLocalizedModule`. Consider a **mathlib-analogist** consult first on whether
`QuasicoherentData`/`Scheme.Modules` admits a shorter affine descent than the explicit finite-equalizer
route (cheaper than committing a blind multi-session lane). GF-geo (`genericFlatness`) stays deferred
until G1-core lands.

### 6. GR private-name `\lean{}` mismatches (lvb B3, pre-existing, 9 lemmas)
Nine blueprint `\lean{...}` hints (`mul_submatrix_col`, `map_nonsing_inv`, `map_map_eq_of_comp`,
`inv_mul_inv_mul_cancel`, `isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_left/right`,
`imageMatrix_map_eq`, `cocycle_imageMatrix_eq`) name `private` Lean lemmas by their unmangled public
names, which do not exist in the exported namespace (sync_leanok marks `\leanok` via file-level
compilation, masking the broken pin). Structural fix: a `refactor` pass to de-`private` these helpers
(they are referenced by the blueprint, so should be public), then the pins resolve. Low urgency (no
build impact) but it is silent DAG rot.

## Blocked — do NOT re-assign without a structural change
- **FBC `inner_value_eq` inline pre-subst route** — walled by leg-dependent motive (see #1). Only the
  post-`subst` `_legs` route works.
- **FBC `gstar_transpose`** — gated; wait for `inner_value_eq` (free once `_legs` closes).
- **QUOT keystone / general `isLocalizedModule_basicOpen`** — gated on G1-core (#5).
- **GF `genericFlatness`** — gated on the QUOT keystone (→ G1-core). No prover until then.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- `erw` (definitional match) fires where `rw` (syntactic) fails on a post-`subst` leg that is defeq but
  implicit-arg-divergent from a `set`-abbreviation. `erw` still cannot cross a *propositional* leg eq.
- Distribution through `(Spec φ)_*` / `Γ`: `simp/rw [Functor.map_comp]` make no progress (the `X.Modules`
  `CategoryStruct.comp` diamond) — use the term-mode `…_gammaDistribute`.
- Pass `IsLocalizedModule` facts as **explicit lemma hypotheses**; inline `set` zeta-unfolds and loses the
  hypothesis instance.
- State localization/tensor helpers over a **generic base ring**; never feed the heavy `MvPolynomial`
  chart ring into `IsScalarTower`/tensor TC synthesis (heartbeat timeout).
- `TopCat.Sheaf` is an `InducedCategory`: morphism's underlying presheaf hom is `α.1` (not `α.val`),
  object presheaf is `.presheaf` (`.val` deprecated).
