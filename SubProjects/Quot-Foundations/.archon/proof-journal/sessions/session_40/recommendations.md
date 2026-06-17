# Session 40 (iter-040) — Recommendations for the next plan iter

## §0 — Headline
QUOT is **CONVERGING** (genuine layer peeled this iter: producer (a) + the range half of (b)). The
remaining wall is the **TOP geometric producer** `section_localization_hfr_basicOpen`, whose sole
input is a real ~200–400 LOC ring-identification build — NOT helper-churn, so keep the prover on it
(blueprint-expansion was already done iter-040). FBC + GR + GF were untouched this iter.

## §1 — MUST-FIX-THIS-ITER (blueprint, plan agent) — split `lem:composite_immersion_range_basicOpen`
The `\lean{}` pin names a non-existent `composite_immersion_range_basicOpen`; the landed decl is
`compositeBasicOpenImmersion_opensRange`, which proves only **1 of the block's 3 bundled claims**
(`j.opensRange = D(s)`). The review agent did NOT re-pin (re-pinning to the range-only decl would let
`sync_leanok` falsely mark the whole 3-claim block `\leanok`) — instead added a `% NOTE`. **Plan
agent must SPLIT this block:**
  - a **range sub-lemma** `lem:composite_immersion_opensRange` with
    `\lean{AlgebraicGeometry.Scheme.Modules.compositeBasicOpenImmersion_opensRange}` (then sync marks
    it `\leanok` legitimately, and downstream `\uses` re-link to the proven half);
  - an **f-locus/σ sub-lemma** keeping claims (2) `j ''ᵁ D(f') = D(f) ⊓ D(s)` and (3)
    `σ(f') = algebraMap R Rₛ f`, still open (gated on `σ`/`f'` from the TOP gaps), pinned to a
    yet-to-exist bundled name and left unmarked.
  Re-wire `\uses{lem:composite_immersion_range_basicOpen}` consumers (`lem:section_localization_hfr_basicOpen`,
  `lem:flocus_section_scalar_tower`, `lem:gamma_image_iso_semilinear_top`) to the appropriate half.

## §2 — Closest-to-completion / next prover objective (QUOT)
Dispatch the next QUOT prover **bottom-up** on the residual producers, in this order:
  1. **producer (c)** `gamma_image_iso_semilinear_top` (`lem:gamma_image_iso_semilinear_top`,
     on the frontier) — ⊤-level semilinearity over the **composite** σ
     `(ΓSpecIso S).symm ≪≫ gammaImageRingEquiv j ⊤`. The genuine hard core is how
     `modulesSpecToSheaf` re-bases the `ModuleCat S`-action along `Scheme.ΓSpecIso S`
     (`Mathlib/AlgebraicGeometry/Scheme.lean:606`). This is bridge (1) of the TOP blocker.
  2. **producer (d)** `flocus_section_scalar_tower` — `Algebra R A` (A = Γ(Spec R, D(s))) + scalar
     tower via restriction-map `.hom.toAlgebra` (patterns at `Scheme.lean:725`, `Restrict.lean:200`),
     with `hf : σ f' = algebraMap R A f` by `rfl`. Bridge (2).
  3. **TOP** `section_localization_hfr_basicOpen` — assemble via `isLocalizedModule_powers_transport`
     (DONE) fed with producer (a) engine localization + e₁ `gammaPullbackTopIso` + e₂
     `gammaPullbackImageIso` (as `≃+`) + σ from (c) + scalar tower from (d), then the final
     `IsLocalizedModule` transport (bridge 3) across `h.restrictScalars R` vs the `Hfr` `.hom`.
Once TOP lands, the **keystone** `isLocalizedModule_basicOpen_descent` and **gap1**
`isIso_fromTildeΓ_of_isQuasicoherent` are blueprint one-liners (instantiate
`isLocalizedModule_basicOpen_descent_of_basicOpen_cover` ∘
`exists_finite_basicOpen_cover_le_quasicoherentData`; then
`isIso_fromTildeΓ_iff_isLocalizedModule_restrict`). gap1 unblocks GF.

## §3 — FBC (scheduled iter-041, per the iter-040 plan): FINAL in-loop Fallback-B round
The iter-040 plan deferred the FBC prover to iter-041 as the **LAST in-loop attempt** before user
escalation (honoring the iter-039 kill-criterion). Route resolved to **Fallback B** (layer-by-layer
conjugate transport via `conjugateEquiv_symm_comp` + whiskering, recipe in
`analogies/fbc-legs-conj-injective-route.md`), NOT the one-shot reframing that resisted 3 iters
(037/038/039). Dispatch the fine-grained FBC prover on `base_change_mate_fstar_reindex_legs_conj`
(sorry @1822 in `FlatBaseChange.lean`). **Reversal signal if it closes nothing**: escalate to the
user and open the affine tilde-transport route (the `gstar_transpose`-bypass) — NOT another conjugate
round, NOT another analogist consult.

## §4 — Coverage debt (plan agent — restore 1:1 Lean↔blueprint)
`archon dag-query unmatched` = 4 `lean_aux` nodes with no blueprint entry:
| Lean decl | File | Depends on | Action |
|---|---|---|---|
| `compositeBasicOpenImmersion` (def) | QuotScheme.lean:1950 | `IsAffineOpen.Spec_basicOpen`, `preimage_of_isOpenImmersion`, `IsAffineOpen.isoSpec`, `Scheme.Opens.ι` | add a `\begin{definition}` block |
| `compositeBasicOpenImmersion_isOpenImmersion` (instance) | QuotScheme.lean:1991 | `IsOpenImmersion.comp` + iso⟹open-immersion | add a one-line lemma/instance block |
| `compositeBasicOpenImmersion_opensRange` (theorem) | QuotScheme.lean:2002 | `opensRange_comp_of_isIso`, `opensRange_comp`, `image_preimage_eq_opensRange_inf` | becomes the §1 range sub-lemma |
| `isIso_unitToPushforwardObjUnit_of_isIso'` (FBC, pre-existing) | FlatBaseChange.lean | — | pre-existing debt; pin to its FBC chapter block when next touched |

## §5 — DO-NOT-RETRY / standing notes (carried forward)
- **QUOT general-U `_of_cover`** descent form is an UNPROVABLE trap — use the basic-open form
  (`isLocalizedModule_basicOpen_descent_of_basicOpen_cover`). (iter-039)
- **QUOT TOP**: do NOT re-dispatch a bare "assemble Hfr" round — the blocker is the 3 coupled
  ring-identification bridges (§2), attack them as named sub-producers bottom-up.
- **FBC `_legs_conj`**: do NOT run another one-shot conjugate-component reframing (failed iters
  037/038/039) NOR another analogist consult — iter-041 is Fallback B, and if that fails it is user
  escalation + tilde-transport (§3).
- **`fromTildeΓ` goals**: state with the explicit `@Scheme.Modules.fromTildeΓ (Γ(...)) (...)` form
  (avoids HOU); pass `IsIso` instances positionally when the supplied form is nested-`obj` vs
  `⋙`/`.comp`. (reusable pattern, this iter)

## §6 — Hygiene (LOW)
- Stale `iter-177+` labels on the 4 protected scaffold-stub docstrings (QuotScheme lines
  ~119/156/197/219) are inherited from the extracted source project and have no actionable meaning at
  iter-040. Cosmetic; only the prose remains accurate. Not worth a dedicated round.
- Trivial duplicated `(by rw [Scheme.Opens.opensRange_ι]; exact hs)` at QuotScheme 1976/1983 — could
  be hoisted to a `let`; no correctness impact.
