# Blueprint Reviewer Directive

## Slug
iter142

## Strategy snapshot

Iter-142 prover lane target: `AlgebraicJacobian/Cotangent/GrpObj.lean`
piece (i.b) Step 2 BUNDLED 3-sub-sorry closure:
- `basechange_along_proj_two_inv_derivation` d_app at L624 (closure: categorical chase via `Derivation.map_algebraMap` + factoring witness `h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`; **NEEDS_MATHLIB_GAP_FILL** ~40–80 LOC bespoke chase).
- `basechange_along_proj_two_inv_derivation` d_map at L643 (closure: 3-step `simp only [PresheafOfModules.pushforward_obj_map_apply']` + `NatTrans.naturality` for ψ + `relativeDifferentials'_map_d` chase; **ALIGN_WITH_MATHLIB** ~30–50 LOC).
- `relativeDifferentialsPresheaf_basechange_along_proj_two` IsIso residual at L689 inside `isIso_of_app_iso_module ... (fun _ => sorry)` (per-open IsIso check via Route (b'2); ~195–365 LOC bundled per `analogies/isiso-basechange-along-proj-two-inv.md`).

The corresponding blueprint chapter is `RigidityKbar.tex` (1349 LOC after iter-141 Wave 3 blueprint-writer expansion: +125 LOC over the iter-139 1224 LOC close). Iter-141 Wave 3 directive landed all 4 updates (d_app Implementation note naming `ModuleCat.Derivation.d_map`; d_map named-lemma + `whnf`-disabled advisory + three-step chase recipe; negative-lesson note distinguishing d_add/d_mul-style `change` from d_map; IsIso gap-items framing repair tagging iter-140 closed items vs iter-141+ open items; iter-139 NOTE block staleness annotation). LaTeX block counts balanced per the writer's self-check.

The pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` (82 LOC) cross-references `RigidityKbar.tex` for substantive content.

The strategy is over-k operational default with revert wiring (triggers
(a')/(b)/(c)). M2 critical path: pile pieces (i.a) DONE iter-132 →
(i.b) IN-FLIGHT iter-134→iter-142+ (Step 1 DONE iter-134, Step 3
DONE iter-136, Step 2 in-flight) → (i.c) iter-142+ → (ii) iter-143+
→ (iii) iter-144+ → M2.a body iter-151+ → M2.b body + terminal-object
cluster iter-153+ → M2 closure iter-157+. M3 user-escalation
RESOLVED iter-126 (off-critical-path; documentation only per iter-141
Edit 2). Sorry count at iter-142 entry: 6 declarations / 7 inline sorries.

## Routes

Single primary route (over-k cotangent-vanishing pile on `AlgebraicJacobian/Cotangent/GrpObj.lean`).

Active "revert option" routes documented but not active:
- Revert to over-`k̄` + restore M2.c (triggered by (a')/(b)/(c) per STRATEGY.md § Sequencing).
- Chart-algebra-vs-bundled re-evaluation gate iter-144 (per iter-140 Must-fix #3; chart-algebra route 450–900 LOC bypasses scheme-Frobenius PHANTOM at piece (iii)).
- Fibre-free piece (i) reformulation (per iter-132 M4 must-fix; trigger renormalised iter-138 to 1000 LOC cumulative).

## References

- `references/challenge.lean`: original AI challenge file by Christian Merten; authoritative signatures for the 9 protected declarations.

## Focus areas

- `RigidityKbar.tex` after iter-141 Wave 3 +125 LOC expansion: verify the d_app + d_map + IsIso recipes are prover-ready for iter-142 dispatch on `basechange_along_proj_two_inv_derivation` (L573–L643) + `relativeDifferentialsPresheaf_basechange_along_proj_two` (L670–L690) sub-sorries. The HARD GATE rule should green-light `Cotangent/GrpObj.lean` iter-142 prover lane if recipes are complete + correct.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` pointer chapter — verify it cross-references the substantive content in `RigidityKbar.tex` cleanly (it received a 2-bullet plan-agent update at iter-139 close).
- Any latent `\leanok` mis-mark concerns (iter-141 carry-over: `RigidityKbar.tex:505` `\leanok` on the proof block of `lem:GrpObj_omega_basechange_proj` while Lean has sorries at L624 + L643 + L689; sync_leanok mis-handling of `(fun _ => sorry)`-bearing bodies).

## Known issues

- Project sorry count: 6 declarations / 7 inline sorries (4 in `Cotangent/GrpObj.lean`, 2 in `Jacobian.lean`, 1 in `RigidityKbar.lean`).
- The `Jacobian.lean` + `RigidityKbar.lean` sorries are downstream scaffolds (M2.b/M2.a/M3) gated on the cotangent-vanishing pile; iter-142 is not addressing those.
- The piece (i.b) main `mulRight_globalises_cotangent` at `Cotangent/GrpObj.lean:817` (L817) is the iter-143+ post-Step-2-closure target.
