# Recommendations for iter-003 (plan agent)

## Reviewer reports (read these before planning)
- `task_results/lean-auditor-iter002.md` — 0 must-fix, 3 major, 3 minor.
- `task_results/lean-vs-blueprint-checker-fbc.md` — 2 major (both informational/known).
- `task_results/lean-vs-blueprint-checker-gf.md` — 2 major (blueprint adequacy).

## HIGH — blueprint expansion gates the next GF prover round
The GF lane's two remaining sorries are **not ready to re-dispatch as-is.** The
lean-vs-blueprint-checker (gf) found both proof blocks under-specified: neither
`thm:generic_flatness_algebraic` (dévissage residue) nor `genericFlatness` (geometric
globalization) names the Lean APIs needed to close the sorry. **Action:** before any GF
prover round, dispatch a blueprint-writer (and likely an **effort-breaker**) to:
- Decompose the dévissage residue of `genericFlatnessAlgebraic` into a `\uses`-linked
  chain: (1) prime filtration of `M` as finite `B`-module → `M = B/𝔭`; (2) Noether
  normalisation of `B_K/K` (`exists_integral_inj_algHom_of_fg`) + clear denominators;
  (3) induction on `dim supp_{B_K} M_K`; (4) base case lands the finite-`A` branch already
  discharged. This is a multi-lemma build — the polynomial-ring core (finite module over
  `A[X₁..X_d]` is generically free) is genuinely Mathlib-absent (verified).
- Expand the `genericFlatness` globalization block to name the coherent-sheaf-to-finite-
  module dictionary on affine opens (the deep part) and the flat-locality close
  (`Module.flat_of_isLocalized_maximal`, `Module.Flat.of_free`).
Re-dispatching a prover at these sorries WITHOUT this expansion will churn.

## HIGH — FBC-A mate lemma is the live frontier crux; decompose before re-dispatch
`pushforward_base_change_mate_cancelBaseChange` is the single highest-leverage sorry:
`affineBaseChange_pushforward_iso` and the whole affine close consume it. Its proof is the
4-step mate trace, blocked on identifying `pullback.fst/snd` over the generic square with
`Spec`-of-tensor inclusions via `pullbackSpecIso`. **Action:** consider an **effort-breaker**
to split the mate trace into: (i) the `pullbackSpecIso` identification of `f'/g'` with
`Spec`-maps; (ii) the two-dictionary domain/codomain reads (steps 1–2); (iii) the generator
trace landing on `cancelBaseChange⁻¹` (step 3); (iv) the iso conclusion (step 4). Then a
prover can attack (i) in isolation. Do NOT re-dispatch the monolithic mate sorry.

## MEDIUM — the affine-reduction sorry in `affineBaseChange_pushforward_iso` is downstream
Obligation 1 (restriction-compatibility of `pushforwardBaseChangeMap`) is gated on the mate
lemma; it is Mathlib-absent and a multi-hundred-LOC build. Keep it deferred until the mate
lemma lands. Do not assign it as an independent target yet.

## MEDIUM — `base_change_map_affine_local` blueprint proof now over-describes the Lean
The plan-phase blueprint-writer added a 3-step derivation for this lemma's proof, but the
prover closed it as a one-liner (`.mpr` of `Modules.isIso_iff_isIso_app_affineOpens`). The
lean-vs-blueprint-checker flagged the divergence (proof doesn't follow the 3-step sketch).
This is harmless (the one-liner is axiom-clean and correct), but the blueprint proof prose
is now heavier than the Lean. **Optional:** a blueprint-writer could trim the 3-step proof
to match, or leave a `% NOTE:` that the Lean took the direct locality-criterion route. Low
priority — not blocking.

## MEDIUM — phantom hypotheses on `base_change_map_affine_local` (design decision to confirm)
The lean-auditor (without strategy bias) flagged `[IsAffineHom f]` / `[F.IsQuasicoherent]`
as unused by the current one-liner proof. They are carried *deliberately* per the blueprint
(the per-open hypothesis `H` is only obtainable under them downstream), but right now they
are inert. **Action for planner:** confirm these binders are still wanted on the final
signature, or drop them to keep the lemma maximally general. If kept, a `% NOTE:` in the
chapter explaining why the locality lemma carries them would prevent re-flagging next audit.

## LOW — deprecation + stale-comment cleanup (FlatBaseChange.lean)
- 22 sites use deprecated `CategoryTheory.Sheaf.val` (compiler: use `ObjectProperty.obj`).
  Inherited from extraction, not introduced this iter. A refactor pass would clear the
  warning noise; not urgent.
- Stale docstring at `FlatBaseChange.lean:233–244` describes `pushforward_spec_tilde_iso`'s
  QC obligation as pending, but that lemma is already complete + `lean_verify`-clean. The
  prover may correct this comment next time it owns the file (review agent cannot edit .lean).
- Stale iter-number references (e.g. "iter-242") from the source project linger in comments.

## Coverage debt (1-to-1 graph correspondence) — for the planner to blueprint
`dag-query unmatched` = 4 `lean_aux` nodes with no blueprint entry (all pre-existing, not
created this iter). Author thin blueprint entries (statement + `\lean{}` + `\uses{}`) so the
dependency graph is complete:
- `AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite`
  (Picard/FlatteningStratification.lean) — finite `A`-module ⟹ flat after localization away.
- `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite`
  (Picard/FlatteningStratification.lean) — finite `A`-module ⟹ free after localization away;
  the helper `genericFlatnessAlgebraic`'s primary branch calls. Depends on
  `Module.FinitePresentation.exists_free_localizedModule_powers`.
- `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite`
  (Picard/FlatteningStratification.lean) — variant by module-finiteness.
- `AlgebraicGeometry.gammaPushforwardNatIso` (Cohomology/FlatBaseChange.lean) — the
  right-adjoint natural iso underpinning the `conjugateIsoEquiv` route for the tilde
  dictionaries.

## Closest-to-completion / what is genuinely ready
- Nothing is one-step-from-done. The mate lemma (FBC-A) is the closest high-value target but
  needs decomposition first. `dag-query frontier` = 0 ready (all open sorries have
  Mathlib-absent or under-specified-blueprint dependencies).

## Do NOT retry without a structural change
- Do NOT re-dispatch the monolithic `pushforward_base_change_mate_cancelBaseChange` sorry,
  the `genericFlatnessAlgebraic` dévissage residue, or the `genericFlatness` globalization
  as single targets. All three need blueprint expansion / effort-breaker decomposition first
  (this is the first prover iter, so no repeated-blocker history yet — but the reviewers
  already flagged the blueprint adequacy gap, so act on it now rather than burning a churn iter).
