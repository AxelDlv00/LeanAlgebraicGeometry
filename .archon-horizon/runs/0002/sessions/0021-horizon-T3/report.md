# Session 0021-horizon-T3 report

## Summary

- Closed the `Thm32RationalMapExtension.lean` sorry `isReduced_of_smooth_over_field` (smooth over `k̄` ⇒ reduced). Albanese sorried-decl ledger **16 → 15**; full `lake build` GREEN (8581 jobs, EXIT 0).
- Key discovery: the missing Stacks `00NP` (regular local ⇒ domain) already exists sorry-free in-project (`RingTheory.CohenMacaulay.isDomain_of_regularLocal`, `AuslanderBuchsbaum.lean`) despite docstrings elsewhere calling it a Mathlib gap.
- `av_isIntegral_of_smooth_geomIrred` (integrality of the abelian variety) is now **fully proven, axiom-clean**.

## Progress

- `CodimOneExtension.lean` §3.B: two new public theorems (~90 LOC):
  - Step B.e `isReduced_of_isStandardSmooth_of_isAlgClosed` — standard-smooth `k̄`-algebras are reduced (B.d′ regularity at maximal ideals + 00NP domain + `isReduced_ofLocalizationMaximal`).
  - Step B.f `isReduced_of_smooth_of_isAlgClosed` — schemes smooth over `Spec k̄` are reduced (stalk-local via Stage-2 charts, `gammaSpecField_ringEquiv` base transport with `RingHom.isStandardSmooth_respectsIso`, `isReduced_localizationPreserves`). Reducedness needs only maximal-ideal localisations, so it closes at every point — no 00OF.
- `Thm32RationalMapExtension.lean`: sorry replaced by a call to B.f; hypothesis strengthened to `[IsAlgClosed kbar]` (sole consumer already assumes it); stale docstrings updated. Thm32 now carries 1 sorry.
- `#print axioms` on all four decls (`isReduced_of_isStandardSmooth_of_isAlgClosed`, `isReduced_of_smooth_of_isAlgClosed`, `isReduced_of_smooth_over_field`, `av_isIntegral_of_smooth_geomIrred`): `[propext, Classical.choice, Quot.sound]` — no `sorryAx`.
- Blueprint: nodes `lem:standard_smooth_reduced_algclosed`, `lem:smooth_scheme_reduced_algclosed` added to `Albanese_CodimOneExtension.tex` (`\uses` in statement env so leandag edges resolve); `lem:isReduced_of_smooth_over_field` statement corrected in `Albanese_Thm32RationalMapExtension.tex`. `horizon blueprint` refreshed: 293 nodes / 169 edges / 0 dangling.
- Inbox: `I-0031` (session info → ground), `I-0032` (durable memory recipe). Scratch file deleted.

## Issues

- The recommended-focus hint `I-0026` (AJC.pic0av tangent leaf) targets `MainProjects/Algebraic-Jacobian-Challenge`, outside this session's Albanese write scope — not attempted; needs an AJC-scoped session.
- Known leandag parser caveat re-confirmed: `\uses` inside detached `proof` envs produce no DAG edges (affects some session-0017 nodes too); worked around by placing `\uses` in the statement envs.
- Remaining 15 sorries are all structurally blocked: `AlbaneseUP` ×7 (A.3), `CodimOneExtension` ×3 (00OF + Milne 3.1/3.3), `Thm32` ×1 (Milne-3.1 codim-≥2 unbundling), `FGAPic` ×2 (AJC.picrep), `GmScaling` ×1 (`hCP_check`), `WeilDivisor` ×1 (upstream PR).

## Next

- Expose `indeterminacy_codimGe2_of_smooth_of_complete` when Milne 3.1 lands to close Thm32's last sorry (branch 2 of `av_codimOneFree_of_indeterminacy`).
- 00OF (localisation of regular local is regular) remains the codim1 stalk-keystone blocker — large homological build, per Ground do-not-side-quest.
- Route `I-0026` to an AJC-scoped session.
