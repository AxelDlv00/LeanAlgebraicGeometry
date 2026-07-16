# Wave-6 port worksheet — the Albanese algebra/rational-map layer (BINDING)

*Design pass, 2026-07-17 night session (W5/W6 orchestrator), from
`informal/w6-albanese-port-recon.md` (read in full). Scope: the port lanes that are
unblocked TODAY. The Albanese assembly fork (C^(g) vs Div^g-lite) is explicitly
DEFERRED (D6). Lane protocol = `w5-worksheet.md` §0, verbatim, for every W6 agent.*

**VERDICT IN ONE LINE.** Tonight Wave 6 ports the ~6.3k-line sorry-free, field-generic
algebra + rational-map layer from the old in-tree AJC Albanese dir (identical toolchain
+ mathlib pin; file drops modulo the ≤500-line split), re-kernel-verifying everything;
`extend_to_av` is restated with Milne Lemma 3.3 as a NAMED HYPOTHESIS so the tree stays
zero-sorry; AlbaneseUP shapes and the Sym-fork wait for the DD lanes to freeze.

## §1 Decisions

- **D1 (source).** Port from
  `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/` (in-tree copy;
  recon freshness rule — strictly ahead of SubProjects/Albanese). READ-ONLY source.
- **D2 (zero-sorry discipline vs the one inherited sorry).** `CodimOneExtension.lean`'s
  single sorry (Milne Lemma 3.3, `indeterminacy_pure_codim_one_into_grpScheme`) is NOT
  ported as a sorry. The port (i) lands every fully-proved theorem as-is (Milne 3.1
  `indeterminacy_codimGe2_of_smooth_of_complete`, `existsUnique_hom_of_indeterminacyLocus_eq_empty`,
  `hom_ext_of_toRationalMap_eq`, `isReduced_of_smooth_of_isAlgClosed`,
  `isIntegral_pullback_self`), and (ii) states the 3.3 disjunction ONCE as a named
  Prop (`Milne33Statement`-style def) and threads it as an explicit hypothesis into
  `extend_to_av` (Thm 3.2). A later Fable lane proves 3.3 (roadmap `m33`) and
  discharges the hypothesis. The tree never contains `sorry`.
- **D3 (placement + split).** Generic commutative algebra under `Algebra/`:
  AuslanderBuchsbaum (split ≤500L along its own section structure: depth,
  Ext-characterization, short-exact calculus, AB formula, Cohen–Macaulay,
  regular⇒domain — agent pins exact file cuts), CoheightBridge,
  StandardSmoothDimension, SmoothPrimeRegularity (split if needed). Scheme-level under
  new dir `Albanese/`: PolePurity, RationalMapPrecomp, RationalMapProd,
  RationalMapFunctionField, DifferenceMap, Milne33Substeps, CodimOneExtension (split:
  it is 1799L — cut along DVR-stalk / spreading / 3.1 / assembly seams),
  Thm32RationalMapExtension. Namespaces: keep mathlib-house (`Module.depth` etc. stay
  where the old files put them unless they collide; collisions → project namespace).
- **D4 (rework knives).** Drop the `WeilDivisor` import from CodimOneExtension
  (prose-only usage — rewrite the comments); drop nothing else. Old-header stale prose
  (claimed sorries) is NOT ported. `[IsAlgClosed kbar]` pinning of the geometry layer
  is KEPT tonight (descent is S10, later wave).
- **D5 (DO-NOT-PORT).** AlbaneseUP.lean (all of it, tonight — shapes wait for D6);
  the old Picard cone (`FGAPicRepresentability`, `Pic0AbelianVariety`,
  `IdentityComponent`); subproject compile-substrate (`WeilDivisor`,
  `Genus0BaseObjects`, `StructureSheafModuleK*`, old `Genus.lean`).
- **D6 (the fork is gated).** C^(g)-native vs Div^g-lite-rework for Milne S1/S3/S4 is
  a design decision that would bind against the parallel fleet's ACTIVELY MOVING
  DD-1/DD-3/DD-4/DD-Q shapes — deciding tonight is how balloons happen. Gate: DD lane
  shapes frozen in the ledger (same trigger style as DAT-G). Until then no AlbaneseUP
  port, no Sym^g work, no S3 duality decision.
- **D7 (verification).** Every ported file: re-kernel-verify (the old draft has a
  documented falsely-marked-proved incident); `lean_verify` capstones
  (`auslander_buchsbaum_formula`, `isDomain_of_regularLocal`,
  `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`,
  `Scheme.exists_specializes_coheight_eq_one_of_notMem_stalk_range`, `extend_to_av`
  when it lands); wire into `AlgebraicJacobian.lean` (re-read immediately before the
  minimal atomic edit); root closure green under the mutex before commit.

## §2 Port lanes (roadmap `AJCR.w6-albanese.*`)

| Lane | Files (source → dest) | Deps | Size |
|---|---|---|---|
| port-alg-1 | AuslanderBuchsbaum → `Algebra/AB*.lean` (split) | none | L (3219L source) |
| port-alg-2 | CoheightBridge, StandardSmoothDimension, SmoothPrimeRegularity → `Algebra/` | none (SPR ← SSD) | M |
| port-ratmap | RationalMapPrecomp, RationalMapProd, RationalMapFunctionField, DifferenceMap, Milne33Substeps → `Albanese/` | internal siblings | M |
| port-pole | PolePurity → `Albanese/` | port-alg-1 + alg-2 | M |
| port-ext | CodimOneExtension (split, D2/D4) + Thm32RationalMapExtension → `Albanese/` | port-pole, port-ratmap | L |
| m33 | Milne 3.3: substep 2-hard, substep 3, assembly — discharge the D2 hypothesis | port-ext | L [RG] |
| fork | design: C^(g) vs Div^g-lite (D6) | DD freeze | worksheet |
| descent | S10 k̄→k uniqueness-first Galois descent | far gate | L |
| genus0 | S11 `g = 0` (Milne I 3.9 route) | far gate | M |

Launch tonight: port-alg-1, port-alg-2, port-ratmap (wave A, parallel — disjoint
files); port-pole + port-ext (wave B, as their deps land); m33 spec (wave C if slots
free). fork/descent/genus0: NOT tonight.
