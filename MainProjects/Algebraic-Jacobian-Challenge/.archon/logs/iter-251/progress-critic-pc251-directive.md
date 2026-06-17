# Progress-critic — iter-251 (post-D2′ transition; convergence + dispatch-sanity)

One active route. Assess convergence and sanity-check the proposed objective set.

## Route: Lane TS — Picard pullback–tensor comparison iso (critical path to Pic representability)

File: `Picard/TensorObjSubstrate.lean`. The route builds the loc-triv-restricted comparison iso
`f^*(L⊗N) ≅ f^*L ⊗ f^*N` via the D1′→D2′→D3′→D4′ chart-chase, which unblocks the relative Picard
group law (`RelPicFunctor.addCommGroup`) downstream.

### Last 5 iters' signals (K=5, iters 246–250)
- iter-246: PARTIAL. D2′ δ-wrapping landed; reduced to the η-bridge. file sorry 2. helpers +~3.
- iter-247: PARTIAL. η-bridge reduced one level to the "unit square". file sorry 2. helpers +2.
- iter-248: PARTIAL (fine-grained corrective). 2/3 ★ mate-lemmas closed axiom-clean + the `rfl`
  linchpin; reduced to ONE concrete (∗∗). file sorry 1→2. helpers +~4.
- iter-249: PARTIAL. whole abstract telescope assembled into ONE compiling axiom-clean proof;
  (∗∗) residual did NOT close (armed binary close-test fired NEGATIVE). file sorry 2.
- iter-250: **COMPLETE — D2′ CLOSED axiom-clean.** the (∗∗) residual eliminated;
  `pullbackTensorMap_unit_isIso` closes; verified no `sorryAx`. file sorry 2→1. The armed binary
  close-or-pivot signal fired POSITIVE; reversing/pivot signal did NOT fire.

Recurring blocker phrase across 246–249 (now resolved): "reduce one level, never close" / pervasive
`rw [Category.assoc]` silent-match failure on `.val` composites (defeq-not-syntactic). Resolved
iter-250 by a propositional `:= rfl` strip lemma + `erw` keyed-defeq merge.

### Strategy estimate for this phase (verbatim from STRATEGY.md `Phases & estimations`)
- Phase: "A.1.c.sub — comparison iso on line bundles". Iters-left cell: "D2′: binary (close now OR
  pivot iter-251), then D3′/D4′ ~6–12". The phase entered its current loc-triv sub-form at ~iter-243
  (elapsed ~8 iters). D2′ was flagged OVER_BUDGET vs the original "≤1" estimate.

## Proposed iter-251 objectives (sanity-check these)
The next decls D1′/D3′/D4′ (`pullbackTensorMap_natural`, `pullbackTensorMap_restrict`,
`pullbackTensorIsoOfLocallyTrivial`) do NOT exist in Lean yet; the blueprint blocks are detailed.
D1′ is a frontier node (Mathlib naturality pasting — expected easy). D3′ is "the sole genuinely-new
mate calculus, analog of the CLOSED `pullbackObjUnitToUnit_comp`". D4′ is the chart-chase assembly.

- **Lane TS-cmp** (`TensorObjSubstrate.lean`, `prove`): author + prove D1′ (frontier), attempt D3′
  with the iter-250 idiom KB, assemble D4′ if D3′ closes.
- **Lane TS-inv** (NEW parallel lane, candidate): per the standing PARALLELISM user directive, the
  dual-inverse workstream (`dual_restrict_iso` → `dual_isLocallyTrivial` →
  `exists_tensorObj_inverse`) is INDEPENDENT of the comparison-iso D-chain (both feed
  `RelPicFunctor.addCommGroup`, neither depends on the other). It would be split into a new file
  to run as a second prover. It has ready frontier nodes at its base (`homOfLocalCompat`).

## Questions for you
1. Is the route now CONVERGING (D2′ closed = first canonical critical-path elimination), or do you
   still read churn risk going into D1′/D3′/D4′?
2. Dispatch-sanity: with D2′ closed, is there genuinely a SECOND independent workstream now (the
   dual-inverse lane), making the long-standing "M=1⇒N=1" verdict obsolete? i.e. should iter-251
   open the parallel dual-inverse lane (M=2), or is one lane (D-chain) still the right call?
3. Any signal that D3′ will reproduce the 246–249 "reduce-don't-close" pattern, and if so what
   corrective (it is the same mate-calculus family as the now-closed D2′)?
