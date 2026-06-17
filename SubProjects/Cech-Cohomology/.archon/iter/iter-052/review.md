# iter-052 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both pre-existing & frozen: `CechAcyclic.lean:110` dead
  `affine`; `CechHigherDirectImage.lean:780` protected P5b `cech_computes_higherDirectImage`. All 6
  new decls are 0-sorry.
- **Build:** GREEN. Review re-verified first-hand: `lean_verify` on `affine_serre_vanishing` AND
  `affine_cech_vanishing_qcoh` = `{propext, Classical.choice, Quot.sound}` (line-30 `local instance`
  warning = intentional `hasExtModules` reactivation). Prover ran full `lake env lean` (EXIT 0) on
  AffineSerreVanishing + `lake build` on CechHigherDirectImage.
- **Lanes planned 2, ran 2.** Lane A (`AffineSerreVanishing.lean`) **SOLVED** (+3 axiom-clean).
  Lane B (`CechHigherDirectImage.lean`) **PARTIAL** (+3 axiom-clean upstream Step-2 site lemmas; the
  top theorem file-placement-blocked, no sorry). **+6 axiom-clean decls, 0 new sorries.**
- **dag-query:** gaps = 0; unmatched = 5 (4 new + pre-existing dead `CechAcyclic.affine`).
  `sync_leanok` ran iter-052 (sha `8ce6ddb`, +13/−0, chapter `Cohomology_CechHigherDirectImage.tex`).
  **blueprint-doctor: no structural findings.**

## Headline — BOTH 02KG tops are now UNCONDITIONAL (Lane A)
The iter-049→051 arc is closed at the top. `affine_cech_vanishing_qcoh` (qcoh Čech vanishing on the
affine cover system) and `affine_serre_vanishing` (`Ext (jShriekOU ⊤) F p = 0` for `p > 0`) are now
axiom-clean unconditional theorems. The discharge was purely mechanical: a private reshaper
`affine_tildeVanishing` bundles iter-051's `sectionCech_homology_exact_of_localizationAway` into the
`ULift (Fin n)`-indexed `htilde` shape, then two one-line specializations of the existing
`_of_tildeVanishing` reductions. The crisp residual that iters 049/050/051 chipped down is gone.

## Lane B — honest PARTIAL, file-placement blocker (not a math gap)
The prover correctly adopted the planner's D1 sections/sheafification route (which avoids the
iter-051 stalkwise-criterion gap), then discovered `cechAugmented_exact` **cannot be proved in
`CechHigherDirectImage.lean`**: every route ingredient (`homologyIsoSheafify`,
`sectionCech_affine_vanishing`/`…_of_localizationAway`, `sectionCechComplex`, `affineCoverSystem`,
`qcoh_iso_tilde_sections`) lives in a file that transitively imports this most-upstream file ⇒ import
cycle. No sorry, no weakened stand-in under the pinned name — the theorem was left absent per the
invariant. The prover instead landed the 3 pure-Mathlib Step-2 site lemmas UPSTREAM (where they have
no downstream deps), so the relocated theorem can import them. This is exactly the right call: it
converts a wasted iter into reusable upstream infra + a precise routing handoff.

## This iter's analysis
- **No forced mathematics, no papering.** The `mathlib-build` no-sorry invariant held on both lanes:
  Lane A closed fully; Lane B stopped at an honest routing wall rather than insert a hole.
- **Soundness independently confirmed three ways:** (1) review's first-hand `lean_verify` on both
  Lane-A tops; (2) **lean-auditor `iter052`: 0 critical / 0 major / 7 minor** (all pre-existing style
  lints) — explicitly confirmed the new decls are non-vacuous, the `of_W` iso-direction is correct, the
  missing `[IsQuasicoherent]` on the private helper is intentional/correct, and NO kernel-soundness
  (subsingleton-coherence) trap was used; (3) lvb `asv` (Lane-A theorems faithful + sorry-free, 0
  must-fix) + lvb `chdi` (confirmed the import-cycle blocker + the upstream site-lemma placement).
- **The decisive routing finding (now a reframed Known Blocker):** iter-051 framed the
  `cechAugmented_exact` blocker as a missing Mathlib stalkwise-exactness criterion. That framing is
  superseded — the sections/sheafification route avoids stalkwise entirely; the real wall is FILE
  PLACEMENT. The fix is a planner routing decision (relocate downstream), not new Mathlib infra.
- **Blueprint coverage debt (planner domain, no soundness impact):** lvb `chdi` flagged 2 major
  blueprint-adequacy gaps — the 3 new site lemmas have no `\lean{}` blocks, and the
  `lem:cech_augmented_resolution` proof sketch silently assumes co-location. Both surfaced to the
  planner in `recommendations.md`; I updated the block's `% NOTE` with the routing finding.
- **Stale markers cleaned:** the iter-049 `% NOTE`s on `lem:affine_serre_vanishing` /
  `lem:affine_cech_vanishing_qcoh` claimed the targets were "not yet" Lean decls — false now. Refreshed.

## Markers / coverage
- **Manual marker edits (3 `% NOTE` refreshes):** see "Blueprint markers updated (manual)" in
  `session_52/summary.md`. No `\leanok`/`\mathlibok`/`\notready` touched.
- **Coverage debt (unmatched = 5):** listed in `session_52/recommendations.md` for the planner;
  recommend deleting the dead `CechAcyclic.affine` stub to drop sorry 2→1.

## Subagent skips
- (none — all review-phase highly-recommended subagents dispatched: lean-auditor `iter052`,
  lean-vs-blueprint-checker `asv` + `chdi`.)
