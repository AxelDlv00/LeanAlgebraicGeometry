# DAG Walker Report

## Slug
cohom-mv

## Seed
thm:Scheme_subsingleton_HModule_prime_supr_of_hasCechToHModuleIso_curve

## Status
COMPLETE — every node in `Cohomology_MayerVietoris.tex` now carries a complete
statement-block `\uses{}`; the seed's ancestor cone is non-empty and entirely
finite-effort.

## Cone before → after
- ∞ holes: 0 → 0 (every block was already `\leanok`/proved; this was a pure
  wiring task, not a proof-gap task)
- broken `\uses`: 0 → 0 (the one `unknown_uses` in the project graph is
  `thm:genus_zero_curve_iso_p1 → cor:nonconstant_function_genus_zero`, a
  different chapter, untouched by me)
- isolated MV-chapter nodes: 56 → 0
- blocks added: 0; `\uses` edges added: 45 statement-block `\uses{}` clauses

## Root cause
Per the directive's mechanical fact: the leandag builder reads `\uses{}` only
from the **statement block**, never the proof block. Every node in this chapter
had its dependency story written only in prose ("Lemma~REF", "Theorem~REF") with
no machine-readable `\uses{}` on the statement, so all 56 showed `dep=0` and the
seed cone was empty. I transcribed the real mathematical dependencies into each
statement block.

## \uses edges added (the completeness fixes)
Internal linear build, bottom-up:
- `def:..._cohomologyPresheafFunctor` → `def:Scheme_HModule_prime` (cross-chapter carrier)
- `def:..._cohomologyPresheaf` → its functor
- `def:..._toBiprod`, `def:..._fromBiprod` → `def:..._cohomologyPresheaf`, `def:Scheme_HModule_prime`
- `lem:..._toBiprod_fromBiprod` → toBiprod, fromBiprod
- `lem:..._isPushoutModuleCatFreeSheaf` → `def:..._free_isLeftAdjoint`
- `def:..._shortComplex` → the pushout lemma
- `lem:..._shortComplex_f_mono` → shortComplex, `def:..._free_preservesMonomorphisms`
- `lem:..._shortComplex_g_epi`, `lem:..._shortComplex_exact` → shortComplex, pushout lemma
- `lem:..._shortComplex_shortExact` → f_mono, g_epi, exact
- `def:..._delta` → shortExact, carrier
- `def:..._sequence` → toBiprod, fromBiprod, delta
- four `_apply`/bridge lemmas → toBiprod / fromBiprod / shortComplex as appropriate
- `def:..._sequenceIso` → sequence + shortExact + delta + the four bridge lemmas (7 edges)
- `thm:..._sequence_exact` → sequenceIso, sequence
- `lem:..._delta_toBiprod`, `lem:..._fromBiprod_delta` → sequence_exact
- `AffineCoverMVSquare` family: toMayerVietorisSquare → struct; X₁–X₄ corners → toMayerVietorisSquare;
  cover `HModule'_sequence(_exact)(_curve)(_curve_exact)` chained to abstract sequence + curve parents
- cover-totality bridge: `HModule_top_linearEquiv`/`HModule'_top_linearEquiv` → `..._top_sourceIso` (+ H / H' carriers);
  `..._eq_HModule_linearEquiv` → both transports + `def:Abelian_Ext_chgUnivLinearEquiv`
- X₄ corner bridges, finrank, module_finite (abstract + curve) chained to the full bridge + corner-X₄ lemma
- Čech section: `subsingleton_HModule_of_isCechAcyclicCover_top` → cross-chapter
  `thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` + full bridge + `def:Scheme_IsCechAcyclicCover`
- `HasCechToHModuleIso` → `def:Scheme_cechCohomology` + `def:Scheme_HModule_prime`; extractor → carrier
- instance-driven transports → explicit transports + extractor + carrier; **the seed** (`_supr_..._curve`)
  → its abstract `_supr_...` parent + cross-chapter `..._supr_of_isCechAcyclicCover_curve`
- `HasAffineCechAcyclicCover` → `def:Scheme_IsCechAcyclicCover` + `def:Scheme_HasCechToHModuleIso`
- producer `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` →
  carrier + rewrite-bridge + cross-chapter `thm:Scheme_IsAffineHModuleVanishing`

Cross-chapter edges (into `Cohomology_StructureSheafModuleK.tex`, labels verified
on disk): `def:Scheme_HModule`, `def:Scheme_HModule_prime`, `def:Scheme_cechCohomology`,
`def:Scheme_IsCechAcyclicCover`, `thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover(_curve)`,
`thm:Scheme_IsAffineHModuleVanishing`.

Genuine leaves left without `\uses{}` (no internal/cross-chapter dependency —
all have consumers now, so none isolated): `def:Scheme_AffineCoverMVSquare`,
`def:Scheme_ModuleCat_free_isLeftAdjoint`, `def:Scheme_ModuleCat_free_preservesMonomorphisms`,
`def:Scheme_HModule_prime_top_sourceIso`, `def:Abelian_Ext_chgUnivLinearEquiv`.

## Verification
- `archon dag-query node --node <seed>`: dep_count 2, effort_total 0.
- `archon dag-query ancestors --node <seed>`: 7-node cone (abstract parent,
  Čech-acyclic consumers ×2, carrier, extractor, H' carrier, cechCohomology).
- `archon dag-query isolated`: 0 nodes in the Mayer–Vietoris chapter.
- Spot-checked heads (`instIsAffineHModuleVanishing_of_...`, all three curve
  rewrite-bridges, `sequence_exact`, `sequenceIso`): all dep_count ≥ 2.

## Could not complete
None. Pure dependency-transcription task; no ∞ holes, no missing statements,
no proofs to write.

## References consulted
None — project-internal constructions only.

## Notes for dispatcher
- The two carrier classes `HasCechToHModuleIso` and `HasAffineCechAcyclicCover`
  remain unproduced by design (documented in the chapter's "Producer status"
  paragraph); the whole cone ships as conditional theorems under them. Nothing
  to wire there — they are intentional leaf hypotheses.
- 4 MV-relevant `unmatched_lean` entries reported by the builder
  (`IsAffineHModuleHomFinite`, `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`,
  `module_finite_HModule'_of_affine(_curve)`) all live in the **sibling**
  `Cohomology_StructureSheafModuleK.tex`, outside my write domain — flagging for
  the cohom-rr parent / the sibling walker.
