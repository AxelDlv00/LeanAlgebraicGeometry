# Recommendations — after iter-028 (for the iter-029 planner)

## MUST-FIX (lean-vs-blueprint-checker `fbc`, 2 blueprint-adequacy failures — blueprint-writer this iter)
The FBC chapter is now the failure mode (not the Lean). Before re-dispatching the FBC lane, dispatch a
**blueprint-writer** on `Cohomology_FlatBaseChange.tex` to fix:
1. **`lem:base_change_mate_inner_eCancel_assemble` is under-specified** — its proof sketch does not describe
   the `X.Modules` instance-diamond obstruction (composed-`⋙` vs nested-`obj` `Functor.map` domains) that
   the prover hit, nor the diamond-robust term-mode-congruence mechanism the formalization clearly needs. A
   prover cannot formalize the remaining telescoping from the current prose. Expand it (ideally after the
   mathlib-analogist consult below supplies the mechanism).
2. **`gstar_transpose`/Seam-3 proof sketch cites a sorry-backed dependency** as if available — make the
   chapter honest that `inner_eCancel_assemble`/`_legs` remains open and the downstream theorem bodies are
   closed-but-transitively-sorry-backed. (Report: `task_results/lean-vs-blueprint-checker-fbc.md`, 52 decls,
   5 red flags; routing itself is consistent.)

## MUST-FIX (lean-auditor `iter028`, 2 findings — both `.lean` docstrings; a prover must correct)
Review/plan cannot edit `.lean`; route a prover (FBC lane) to correct these wording bugs:

1. **`FlatBaseChange.lean:1837`** — docstring of `base_change_mate_section_identity` asserts *"This theorem
   itself is **sorry-free**."* The proof `exact base_change_mate_gstar_transpose ψ φ M` defers to a theorem
   with `sorry@1817`. The body has no *inline* sorry but is transitively sorry-backed. Correct to e.g.
   *"this theorem's proof body has no inline sorry; the crux lives in `base_change_mate_gstar_transpose`."*
   (The docstring already names the residual location, so this is a wording sharpening, not a math error —
   but the bare "sorry-free" mis-signals to planning/marker logic.)
2. **`FlatBaseChange.lean:1907`** — docstring of `pushforward_base_change_mate_cancelBaseChange` asserts the
   same "sorry-free"; the chain is `generator_trace → section_identity → gstar_transpose → sorry@1817`
   (3 hops). Its `IsIso` conclusion is consumed by `affineBaseChange_pushforward_iso`, so false "proved"
   accounting is load-bearing. Same correction.

> These two docstrings were *over-corrected this iter* (the prover's rider cleanup changed them from the old
> false "typed sorry below" to the new misleading "sorry-free"). Bundle the fix as a rider on the next FBC lane.

## HIGH — the cross-lane blocker: the instance diamond (do NOT retry the same tactics)
Both FBC `_legs` (@1445) and the GR `cocycle` finish are gated by the **`X.Modules` / `HasPullback` instance
diamond** (composed-`⋙` vs nested-`obj` domains; the *same literal* term elaborates to different instance
terms in def-body vs fresh-term vs statement). Confirmed dead for FBC `_legs`: `rw` / `simp only` /
`erw` / explicit-`have` + `rw` (all four tried this iter).

- **FBC `_legs` (and `gstar_transpose` beneath it):** per the planner's iter-028 tripwire, the next action is
  **a mathlib-analogist consult** (cross-domain mode) on a *diamond-robust term-mode congruence* — rewriting a
  single factor inside a long `Γ ∘ (Spec φ)_*`-image composite when the factor's `Functor.map` implicit domain
  is in the wrong (`obj`-nested vs `⋙`-composed) syntactic form, with **no head-symbol `rw`**. **Do NOT assign
  a 3rd helper round on the same recipe** (progress-critic flagged FBC CHURNING; this is the escalation).
  The proven `hpfc` already shows each cancellation atom is individually available — what's missing is the
  *application mechanism*.
- **GR `cocycle`:** this is NOT diamond-blocked at the residual — the categorical reduction is solved and the
  remaining `Φ = RingHom.id` is a clean ring goal (no pullback objects). It is *ready to prove* (see below).

## Closest-to-completion / ready-to-prove (prioritize)
1. **GR `cocycle` → `theGlueData` → `Grassmannian.scheme`** — the categorical reduction is done (HANDOFF block
   in-file). Residual = the rotated ring identity
   `Φ = RingHom.id (Localization.Away (minorDet I J * minorDet I K))`,
   `Φ := cocycleΘIJ.comp(swap_J.comp(cocycleΘJK.comp(swap_K.comp(cocycleΘKI.comp swap_I))))`. Prove via
   `IsLocalization.ringHom_ext (Submonoid.powers (minorDet I J * minorDet I K))` → chart-ring generators → the
   matrix cocycle (reuse `cocycle_imageMatrix_eq`). ~30–50 LOC, ring-level. Then assemble
   `Scheme.GlueData` (`U:=affineChart`, `V:=chartOverlap`, `f:=chartIncl`, `t:=chartTransition`,
   `t_id:=chartTransition_self`, `t':=chartTransition'`, `t_fac:=chartTransition'_fac`, `cocycle:=…`) and
   `Grassmannian.scheme := theGlueData.glued`. **Caveat:** `f_id`/`f_hasPullback` are `by infer_instance`
   fields — the same diamond may need `chartIncl`-form `HasPullback` instances supplied explicitly. This lane
   is the highest-leverage *fully-unblocked* target.

## Blocked — do NOT re-assign without a structural change
- **FBC `base_change_mate_fstar_reindex_legs` @1445** — diamond (4 tactic routes exhausted this iter). Needs
  the analogist consult above before any new tactic attempt.
- **FBC `base_change_mate_gstar_transpose` @1817** — same diamond class + gated on `_legs`. Do not assign
  until `_legs` has a working application mechanism.
- **QUOT full G1-core `isLocalizedModule_basicOpen_of_isQuasicoherent`** — the `QCoh(Spec R) ≃ Mod R`
  essential-image gap; the whole content is the one lemma `isIso_fromTildeΓ_of_isQuasicoherent`. **Do NOT
  re-assign the full target directly.** Instead dispatch the named **Step-1 sub-build** (the planner's
  escalation): a standalone
  ```
  exists_isIso_fromTildeΓ_basicOpen_cover :
    ∀ (M) [M.IsQuasicoherent], ∃ finite {g}, (⨆ D(g) = ⊤) ∧ ∀ g, IsIso ((M|_{D g}).fromTildeΓ)
  ```
  via `PrimeSpectrum.isBasis_basic_opens` + `CompactSpace (PrimeSpectrum R)` + the site-`over` ↔
  scheme-pullback presentation transport across `D(g) ≅ Spec R_g`. The Mayer–Vietoris gluing induction then
  ports `exists_eq_pow_mul_of_isCompact_of_isQuasiSeparated` (`QuasiSeparated.lean:306`) via
  `TopCat.Sheaf.existsUnique_gluing` / `eq_of_locally_eq'`. **Note:** the G1-core blueprint prose should be
  corrected — G1-core ≡ gap1 ≡ `isIso_fromTildeΓ_of_isQuasicoherent`; the 3-field constructor is over-stated
  (`surj`/`exists_of_eq` are already delivered in-file for the iso case).

## MAJOR — blueprint prose rewrites (lean-vs-blueprint-checker quot + gr)
- **QUOT G1-core prose over-stated** (`quot` checker, major): the chapter still describes a direct 3-field /
  compact-open-induction proof of G1-core. The Lean's `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`
  (@653) establishes **G1-core ↔ gap1**; the single missing ingredient is `isIso_fromTildeΓ_of_isQuasicoherent`,
  and `isLocalizedModule_restrict_of_isIso_fromTildeΓ` delivers all three fields at once. Replace the
  surj/exists_of_eq compact-open paragraphs with the iff reduction. (Aligns with the QUOT "do not re-assign
  full G1-core" note above.)
- **GR**: `def:gr_glued_scheme` `% NOTE:` (formalization status of cocycle/theGlueData/scheme) — **DONE this
  review** (review agent added it). The two missing `\lean{}` anchors (`def:gr_chart_transition'` for
  `chartTransition'`, `lem:gr_chartTransition'_fac` for `chartTransition'_fac`) are the coverage-debt items
  below — planner authors them.
- **QUOT minor**: two `private` decls (`isIso_sheaf_of_isIso_app_basicOpen`, `bijective_comp_of_localizations`)
  carry blueprint `\lean{...}` pins that automated tooling can't resolve — a de-`private` refactor (or a
  documented exception) would restore DAG matching. Low priority.

## Coverage debt — 6 unmatched `lean_aux` nodes need blueprint blocks (planner authors prose)
`archon dag-query unmatched` lists 6 new helpers with no blueprint entry. The planner should add blocks
(then `\lean{...}` anchors; `sync_leanok` handles `\leanok`):
- `AlgebraicGeometry.Grassmannian.chartTransition'` — the `t'`-field. Deps: `awayPullbackIso`, `cocycleΘIJ`,
  `awayMulCommEquiv`. `def:gr_glued_scheme` describes `t'` in prose; needs its own `def:gr_chart_transition_prime`.
- `AlgebraicGeometry.Grassmannian.chartTransition'_fac` — the `t_fac`-field. Deps: `awayPullbackIso_inv_fst`,
  `awayPullbackIso_inv_snd`, `chartTransition'_ringIdentity`, `Iso.inv_comp_eq`.
- `AlgebraicGeometry.Grassmannian.chartTransition'_ringIdentity` — ring content of `t_fac`. Deps:
  `IsLocalization.ringHom_ext`, `awayInclRight_comp_algebraMap`, `awayMulCommEquiv_comp_algebraMap`,
  `IsLocalization.Away.lift_comp`.
- `AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_algebraMap` — helper. Deps: `IsLocalization.algEquiv.commutes`.
- `AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation` — basic-open restriction localizes for a
  globally-presented `M`. Deps: Mathlib `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) + file's
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ`. Suggested `lem:qcoh_section_localization_of_presentation`.
- `AlgebraicGeometry.map_units_restrict_basicOpen` — the `map_units` field of G1-core, any `M`. Deps: Mathlib
  `tilde.isUnit_algebraMap_end_basicOpen` (Tilde.lean:182). Suggested `lem:qcoh_map_units_basicOpen`.

## Reusable proof patterns discovered
- **HasPullback-diamond recipe (GR `t_fac`):** keep iso `.hom`/`.inv` from ONE source
  (`(Iso.inv_comp_eq _).mp (awayPullbackIso_inv_fst _ _)`), fire the snd-leg with `erw [awayPullbackIso_inv_snd]`
  (defeq), close assoc-laden goals with `exact congrArg (_ ≫ ·) hXY` (associativity by defeq inside `exact`).
- **Internal iso-pair cancellation goes via `simp` only when both ends share a source** (GR cocycle: both
  `apXY.inv ≫ apXY.hom` pairs come from the `chartTransition'` def → matched instances → `simp` fires).
- **`map_units` from a ready Mathlib lemma:** `tilde.isUnit_algebraMap_end_basicOpen M f` works for *any*
  `M : (Spec R).Modules`; `.pow n` handles `Submonoid.powers f`. Avoid `infer_instance` on `let`-bound carriers.
