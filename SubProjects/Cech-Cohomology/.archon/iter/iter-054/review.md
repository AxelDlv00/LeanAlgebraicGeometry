# iter-054 review

## Overall progress this iter
- **Total sorry:** 5 → 5 (no regression, no new sorry, **none forced/papered** — the `mathlib-build`
  no-sorry-fabrication invariant held on both lanes). Breakdown: CechAugmentedResolution:205 (residual
  SHARPENED this iter), OpenImmersionPushforward:224 (`_acyclic` deep clean reduction) + 290 (`_comp`,
  re-signed, blocked on `_acyclic`), CechHigherDirectImage:780 (frozen protected P5b), CechAcyclic:110
  (dead `affine`).
- **Build:** GREEN. Prover ran full `lake env lean` (exit 0) on both touched files. Review re-verified
  first-hand: `lean_verify` on `isZero_homology_of_homotopy_id_zero` and
  `isZero_presheafToSheaf_of_sections_locally_zero` = `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned 2, ran 2.** Both PARTIAL-with-progress. **+5 axiom-clean decls** (1 Lane 1 + 4 Lane 2).
- **dag-query:** gaps = 0; unmatched = 6 (5 new + pre-existing dead `CechAcyclic.affine`). `sync_leanok`
  ran iter-054 (sha `e570e7a`, +4/−0). **blueprint-doctor: no structural findings.**

## Headline — the shared L1 bridge is now NAMED; the D1 reversal signal is triggered (Lane 1)
The decisive finding of the iteration is not a closed theorem but a precise diagnosis. The prover built
the Step-3(d) brick `isZero_homology_of_homotopy_id_zero` (a clean, reusable `Homotopy (𝟙 D) 0 → IsZero
(D.homology p)` for any preadditive `C`) and wired it into `cechAugmented_exact`, sharpening the single
residual from `IsZero (…homology p)` to the exact contracting-homotopy obligation `Homotopy (𝟙 D) 0`. In
doing so it proved that this residual is **Sub-brick A** — the per-degree section identification
`Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` — which is the **same L1 categorical→combinatorial bridge that
has kept `CechAcyclic.affine` open** (CechAcyclic.lean:106-109). The two lanes share ONE irreducible
obstruction.

`cechAugmented_exact` has now been PARTIAL for 4 consecutive iters (051 object layer → 052 import-cycle →
053 collapse-to-residual → 054 residual re-shaped). The planner's own iter-054 D1 reversal signal ("2nd
consecutive Lane-1 PARTIAL with the residual unchanged") is met. The correct next move is the structural
one the prover spelled out: extract `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` as a standalone foundational
lemma reusable by BOTH lanes (pushforward half is DEFINITIONAL via `pushforward_obj_obj`; remaining =
pullback-along-open-immersion sections + `coverCechNerveOver` backbone geometry + differential match), and
promote the `private` `CombinatorialCech.Dependent` engine to a public home so Sub-brick B (the
prepend-`i_fix` contractibility) becomes a one-call consumer. NOT a 5th plain re-dispatch.

## Lane 2 — honest deep reduction to the known 02kg Serre leaf
`higherDirectImage_openImmersion_acyclic` is wired axiom-clean (toSheaf-reflect → `sheafificationCompToSheaf`
→ sectionwise site lemma → affine-basis sieve → restriction factoring) down to ONE precisely-typed residual:
`IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` for affine `W`, `q>0` (Serre vanishing on
`j⁻¹W`). Four axiom-clean helpers fell out, of which `isZero_presheafToSheaf_of_sections_locally_zero` is the
notable one — the *sectionwise* strengthening required because the affine opens are not downward-closed.
`_comp` was re-signed to the canonical `A ≅ B` per planner D2 (now matches the blueprint) but its body is
correctly blocked on `_acyclic`. This is a route converging onto its true foundation, not churn.

## This iter's analysis
- **No forced mathematics, no papering.** Both lanes stopped at honest residuals; auditor + both lvb
  checkers found no fake/placeholder/vacuous statements, no excuse-comments, no `Classical.choice` smuggling.
- **Soundness confirmed three ways:** (1) review's first-hand `lean_verify` on the two key new completed
  lemmas; (2) **lean-auditor `iter054`: 0 must-fix / 1 major / 3 minor** — explicitly confirmed all 3 sorries
  are honest holes with verified goal states and that the `congr 1` (thin-cat `op a = op b` → proof
  irrelevance) and `Subsingleton.elim` (genuine zero object) steps are NOT the subsingleton-coherence kernel
  trap, and the explicit `instAdditiveComp` chain masks no wrong instance; (3) lvb `cechaug`
  (`isZero_homology_of_homotopy_id_zero` a faithful realization of Step 3(d); residual = the blueprint's named
  gap) + lvb `openimm` (both signatures match incl. the D2 re-sign; `_acyclic` reduced to the correct leaf).
- **One substantive blueprint-CORRECTNESS gap (planner domain):** lvb `openimm` found that Bridge (3) of the
  open-immersion proof sketch MISDIRECTS — it points to the objectwise `isZero_presheafToSheaf_of_locally_isZero`,
  but the proof necessarily used the sectionwise `…_of_sections_locally_zero` because affine opens are not
  downward-closed. A blueprint-writer must correct Bridge (3) + its `\uses{}` and add the sectionwise lemma
  block, or the next prover hits this wall blind.
- **One overstated subagent finding, refuted first-hand:** lvb `openimm` flagged the
  `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` pin as "broken because the decl is `private`".
  `lean_verify` resolves the qualified name (axiom-clean) and `dag-query unmatched` matched it — private Lean-4
  decls keep their real qualified name in tooling lookups. No marker change made; flagged in recommendations so
  the planner doesn't chase it.
- **Blueprint coverage debt (planner domain):** 5 new `lean_aux` decls need `\lean{}` blocks (listed in
  `session_54/recommendations.md`). One is a deliberate duplicate (`isZero_of_faithful_preservesZeroMorphisms`,
  copied for import reasons) — auditor flagged the duplication (major) and recommends a shared `Utils.lean`.

## Subagent skips
- None — all three highly-recommended review subagents (lean-auditor, two lean-vs-blueprint-checkers, one per
  prover-touched file) were dispatched.

## Manual blueprint markers updated
- None this iter. No Mathlib re-export aliases (⇒ no `\mathlibok`); no renames (⇒ no `\lean{}` corrections);
  no stale `\notready`; the suspected broken `private` pin was verified resolvable (no correction needed).
