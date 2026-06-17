# Iter-260 objectives (detail)

## Lane 1 (PRIMARY, the only prover lane): `Picard/TensorObjSubstrate/DualInverse.lean`
**Close `sliceDualTransport` (L184) → `dual_restrict_iso` (L327) via the route-(1) consumer of the
now-green shared root.** [prover-mode: prove]

Gate: `Picard_TensorObjSubstrate.tex` (consolidated, covers DualInverse.lean) — Sq2b must-fix
corrected this iter (bw-tos260); HARD-GATE re-confirmed by br260 (fast path).

### Route (the strategy's chosen close — confirmed by the iter-258/259 probes)
- Add `import AlgebraicJacobian.Picard.SheafOverEquivalence` (now fully green + stable — no more
  cross-lane race; the file is sorry-free and will NOT be edited this iter).
- `sliceDualTransport f M V` is the per-open localization to `V` of `Scheme.Modules.overEquivalence`
  (functor `pushforward (phiOver U)`). The reduced `𝒪_Y(V)`-linear equivalence is
  `(restr fV' M.val ⟶ restr fV' 𝟙_X) ≃ₗ[𝒪_Y(V)] (restr V (pushforward β M.val) ⟶ restr V 𝟙_Y)`,
  `fV' = f.opensFunctor.obj V.unop`.
- Consume `restrictOverIso` (`lem:sheafofmodules_restrict_over_iso`) + `unitOverIso`
  (`lem:sheafofmodules_unit_over_iso`) localized to `V`, plus the bridge `f ≅ U.ι`, `U := f.opensRange`.
- LHS `Module 𝒪_Y(V)` is NOT auto-synthesized — supply via
  `letI _ : Module … := Module.compHom … (β.app V)` (exactly as `restrictScalarsRingIsoDualEquiv`,
  PresheafInternalHom.lean ~L234). Return `e.toModuleIso` from `LinearEquiv.toModuleIso`.
- Once `sliceDualTransport` is concrete, `dual_restrict_iso`'s `isoMk` naturality closes for free
  (`by cat_disch` / `Subsingleton.elim` — the family is no longer opaque).
- Fix the stale STATUS NOTE L295–318 (aud259 major): route (1) is no longer "gated" — the shared root
  IS green. Update to reflect the executed close.

### pc260 calibration + reversing signal (ARMED)
- This is **1–2 prover iters of plumbing**, not a literal `exact`. First move: `refine
  LinearEquiv.toModuleIso ?_` to confirm the goal synthesizes; then de-risk the `f ≅ U.ι` bridge and
  the sectionwise application of `restrictOverIso`/`unitOverIso` BEFORE building the equivalence body.
- **Reversing signal:** if `restrictOverIso`/`unitOverIso` do NOT apply sectionwise in the expected
  form (i.e. the localization-to-`V` of the sheaf-level isos doesn't match the reduced `≃ₗ`), leave a
  typed sorry + report the EXACT failing step. Do NOT switch to the route-(2) ~200-LOC sectionwise
  fallback unilaterally — report and let the planner decide.
- Keep all other DualInverse decls green; do NOT touch `dual_unit_iso`/`dual_isLocallyTrivial` bodies
  (they consume `dual_restrict_iso` and close transitively).

### Bar
Close `sliceDualTransport` + `dual_restrict_iso` axiom-clean ⇒ `dual_isLocallyTrivial` becomes
axiom-clean ⇒ unblocks the RPF group inverse `exists_tensorObj_inverse` (next iter, in
TensorObjSubstrate.lean). This is the twin payoff of the shared-root arc.

## HELD this iter
- **`Picard/TensorObjSubstrate.lean` (D3′)** — HELD (race: DualInverse imports it). pc260 CHURNING
  corrective prepared THIS iter (analogist `ana-pclm260` on `pushforwardComp_lax_μ` →
  `analogies/pushforwardcomp-lax-mu260.md`). iter-261 folds the recipe into the chapter, then
  re-dispatches D3′ in-place (tree stable post-DualInverse). The residual is self-contained
  (`pushforwardComp_lax_μ` typed sorry at L2143, clean signature) — no staleness risk.
- **`Picard/LineBundleCoherence.lean`** — DONE (engine `IsFinitePresentation` axiom-clean). No edits.
- **DualInverse downstream** (`dual_isLocallyTrivial`) + **RPF/FGA** — gated on this close / D4′.
