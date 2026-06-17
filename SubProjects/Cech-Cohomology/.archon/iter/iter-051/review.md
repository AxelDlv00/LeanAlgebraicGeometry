# iter-051 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both pre-existing & frozen: `CechAcyclic.lean:110`
  dead `affine`; `CechHigherDirectImage.lean:780` protected P5b `cech_computes_higherDirectImage`.
  All 10 new decls are 0-sorry.
- **Build:** GREEN. Prover `lake env lean` on both touched files = exit 0 (sorry warnings only — the
  real kernel check, excludes the LSP-accept/kernel-reject thin-cat trap). Every new decl
  `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned 2, ran 2.** Lane 1 (`CechAcyclic.lean`) **SOLVED** (+4 axiom-clean). Lane 2
  (`CechHigherDirectImage.lean`) **PARTIAL** (+6 axiom-clean object layer; top theorem
  missing-infra-blocked, no sorry). **+10 axiom-clean decls, 0 new sorries.**
- **dag-query:** gaps = 0; unmatched = 10 (9 new helpers + pre-existing dead `CechAcyclic.affine`).
  `sync_leanok` ran iter-051 (sha `8330303`, +0/−0). **blueprint-doctor: no structural findings.**

## Headline — the 02KG residual `htilde` is now a real theorem (Lane 1)
This closes the single crisp obligation both iter-049 reductions bottomed out at: positive-degree
section Čech vanishing of `~M` over a standard cover of a **proper** `D(f)`. The decisive finding:
the iter-049 prediction that this needs a *change-of-space iso of section Čech cochain complexes*
(comparable to the keystone chain) was **avoided**. The private `SectionCechModule` core is
`{R}[CommRing R]`-polymorphic, so route B re-instantiates `dDiff_exact` over `R_f = Localization.Away f`
at the **module** level (0 sheaf infra) and ladder-transports exactness back to `R`. The route-B pivot
the planner selected in iter-050 (change-of-ring, co-located in `CechAcyclic.lean`) was correct and
landed exactly as scoped (~120 LOC, the analogist's polymorphism finding held).

The remaining work to make both 02KG tops **unconditional** is a small ready downstream lane: plug
`sectionCech_homology_exact_of_localizationAway` into `AffineSerreVanishing.lean`'s two `_of_tildeVanishing`
forms. That is the top recommendation for iter-052.

## Lane 2 — honest PARTIAL, genuine Mathlib gap
The prover built the entire augmented-complex object + augmentation layer (6 axiom-clean decls) the
planner asked to build first, then stopped at the exactness theorem `cechAugmented_exact` because it
needs an `X.Modules` **stalkwise-exactness criterion absent from Mathlib** (verified by
loogle/leansearch — no `SheafOfModules.stalk`, no stalkwise-exactness reflection). No sorry was
inserted; the gap is a documented decomposition (steps 1–2 = the ~150–250 LOC stalkwise-exactness
reflection; steps 3–4 reuse already-built infra). This is a new **Known Blocker** — the planner must
build the criterion as a separate lane FIRST and not re-dispatch `cechAugmented_exact` as-is.

## This iter's analysis
- **No forced mathematics, no papering.** The `mathlib-build` no-sorry invariant held on both lanes:
  Lane 1 closed fully; Lane 2 stopped at an honest infra wall rather than insert a hole.
- **Soundness independently confirmed three ways:** (1) prover full `lake env lean` exit 0 +
  `lean_verify` axiom-clean on all 10 decls; (2) **lean-auditor `iter051`: 0 critical / 0 major / 3
  minor** — explicitly confirmed the `erw` defeq-match (the `Comma (const) (𝟭)` codomain wall), the
  `change`/`IsLocalizedModule.ext` closures, and the heartbeat raises are all genuine, NOT the
  subsingleton-coherence kernel-soundness trap; (3) lean-vs-blueprint (`cechacyclic` + `cechhdi`):
  Lane-1 main theorem signature + proof faithful to the route-B blueprint sketch, sorry-free.
- **Blueprint coverage debt surfaced (planner domain, no soundness impact):** lean-vs-blueprint flagged
  4 major `cechacyclic` items — 2 new helpers (`isLocalizedModule_comp_away`,
  `dDiff_exact_of_localizationAway`) have no `\lean{}` block, and the `lem:affine_cech_vanishing_tilde_subcover`
  proof sketch understates the ~120-LOC transport as "instantiate over `R_f`". This (plus the
  unblueprinted Lane-2 object layer) is why `\leanok` did NOT propagate to the subcover lemma — its
  proof-`\leanok` gate fails on unblueprinted/mis-pinned deps. Honest, not laundering; resolved once the
  10 unmatched nodes are blueprinted. All listed in `recommendations.md`.
- **Process:** both dispatched lanes ran this iter (fixing the iter-049/050 single-prover-launch issue).

## Markers / coverage
- **Manual marker edit (1):** `% NOTE (iter-051)` on `lem:cech_augmented_resolution` recording the
  object-built / exactness-blocked split + the missing stalkwise-exactness criterion, flagging the
  planner to split the lemma.
- No `\leanok` touched (sync's domain). No `\mathlibok` (all new decls are project lemmas). No stale
  `\notready` found. The missing `\leanok` on `lem:affine_cech_vanishing_tilde_subcover` is conservative
  (gated by unblueprinted deps), left for sync once coverage debt is cleared.

## Subagent skips
- (none — all three highly-recommended review subagents dispatched: lean-auditor + lean-vs-blueprint ×2)
