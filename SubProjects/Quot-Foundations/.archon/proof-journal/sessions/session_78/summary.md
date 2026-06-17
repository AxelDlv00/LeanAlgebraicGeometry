# Session 78 (iter-078) — Review Summary

## Metadata
- Global sorry count: **18 → 14** (net −4). Per target file: GlueDescent 2→2 (content moved),
  GrassmannianQuot 6→4, SectionGradedRing 2→0. Untouched: FlatBaseChange 4, QuotScheme 4.
- 3 prover lanes, all `status: done`, all builds green, **0 axioms introduced** (kernel-only).
- First real proving iter after the iter-068..076 auth-401 outage; prover role now `opus` works.

## Targets

### GlueDescent.lean — keystone decomposed, 2 sorries remain (was {β coherence, bare keystone})
- **SOLVED** β_ij `pushforwardCongr` coherence inside `glueOverlapBaseChangeIso`: new helper
  `glueData_overlap_appIso_compat` (appLE calculus) closed elementwise via
  `congr($(…) x)` — `rw` cannot cross the RingCat/forget₂ wrapper, elementwise `congr` can.
- **PARTIAL** `isIso_glueRestrictionHom` keystone: body now COMPLETE and compiling, reduced to
  2 named sorries — `glueChartFamily_equalizes` (L1431, C2-transported, genuinely new infra) and
  `glueOverlapFactor_transpose` (L1679, mate core, `hRHS`/`h_a`/`n₁–n₃` already filled; only
  whisker-assembly + `ext V x` restriction-cycle ending left, ≤60 lines, no new math). 23 new
  decls, 21 proven. Obligations 2/3 (`glueChartComponent_self_counit`,
  `glueRestrictionHom_glueChartComponent`) CLOSED.
- **SOLVED (adjacent)** `pullback_map_jointly_faithful` = the `lem:gr_modules_glue_unique` core,
  via `TopCat.Sheaf.eq_of_locally_eq'` over the chart cover. This is the engine lane-2 needs.
- Proof-engineering: `rw`/`simp` with comp-node patterns fail silently under the `X.Modules`
  diamond even when the goal prints the pattern; working levers are `erw` (single closed-head),
  term-mode `whisker_eq`/`eq_whisker`/`Category.assoc` chains (unification crosses the diamond),
  and freshly-quantified generic `have`s closed by `simp` + applied by unification. `include`
  must precede the docstring (`unexpected token 'include'` otherwise).

### GrassmannianQuot.lean — 6→4
- **SOLVED** `isIso_pullback_isoLocus_map`: blueprint stalk-wise route, ~60 lines entirely on
  Mathlib (`restrictStalkNatIso` + `isIso_of_stalkFunctor_map_iso` + `toPresheaf` reflects iso).
  Unblocked `isIso_pullback_chartLocus_map` + all `chartMatrix*` machinery (now sorry-free).
- **SOLVED** `chartLocus_isOpenCover` (the lane's "do first"): ~600 lines. Prover SUBSTITUTED an
  affine projective-splitting route (`exists_section_of_epi_free_spec` via `tildeFinsupp` +
  `Module.projective_lifting_property`; residue-field `exists_isUnit_submatrix`; minor-det basic
  open) for the blueprint's stalkwise-Nakayama sketch, because sheaf-of-modules stalk theory is
  ABSENT in Mathlib (SNAP). Endpoints coincide; mechanism differs → `% NOTE` added to chapter
  (see Blueprint markers), blueprint-writer refresh recommended.
- **BLOCKED** `tautologicalQuotient_epi`: correctly NOT attempted — transferring epi to
  `ι_I^* taut` needs `Mono(glueRestrictionHom I)`, the separation half of the still-sorried
  GlueDescent keystone. Writing it now would silently rest on lane-1 sorries. ~30 lines once
  GlueDescent lands a mono-sorry-free `glueRestrictionHom`.
- **PARTIAL** `grPointOfRankQuotient` overlap (L3217): matrix heart FORMALIZED
  (`presentedMatrix_changeOfBasis` = Nitsure M^I = M^I_J·M^J; `isUnit_of_isIso_matrixEndRect`).
  Remaining = Γ–Spec/localization plumbing (steps 1,4,5), mechanical, route-mapped in-code.
- `represents.left_inv`/`right_inv` (L3928/3931): ride on the overlap; not attempted.

### SectionGradedRing.lean — 2→0 (file now sorry-free)
- **SOLVED** `tensorObjAssoc` (`cor:sheafTensorObjAssoc`): 3-segment composite; segment-3 `asIso`
  needed the `IsIso` instance passed EXPLICITLY (`@asIso _ _ _ _ f h`) — synthesis fails deep in
  a long `≪≫` chain even with the `haveI` present.
- **SOLVED** `tensorPowAdd` (`lem:sheafTensorPow_add`): `match m` induction; whisker helpers as
  `Iso.mk` over morphism-level `whiskerRight` with term-mode congruence proofs (the `whiskerRightIso`
  iso-arg breaks `(C := MonoidalPresheaf X)` unification; `whiskerLeftIso` works). `Nat.succ_add`,
  not `omega`, closes the reindex.
- Hygiene: `unitModule` made **public** (= the `sectionsMul_assoc_unit` precondition; no signature
  change, existing blueprint pin still valid). Stale docstring + section comment fixed.

## Subagent reports (review phase)
- **lean-auditor iter078** (`task_results/lean-auditor-iter078.md`): CLEAN. 0 must-fix, 3 major,
  2 minor. **All 5 sorries confirmed genuinely open, none silently closed by an unsound lemma**;
  axiom-clean and sorry-honest. Majors → recommendations.
- **lean-vs-blueprint-checker glue** (`…-glue.md`): 2 must-fix = the 2 expected open sorries;
  major = 14 substantive GlueDescent helpers lack blueprint blocks (1-to-1 debt).
- **lean-vs-blueprint-checker grquot** (`…-grquot.md`): reported 2 must-fix + 3 "broken pins" —
  **the must-fix and broken-pin findings are FALSE POSITIVES** (verified, see below). The one
  genuine finding is the `chartLocus_isOpenCover` route mismatch + ~15 missing blueprint blocks.
- **lean-vs-blueprint-checker sgr** (`…-sgr.md`): clean; 2 minor stale-comment notes only.

### False-positive verification (grquot checker)
- "3 broken `\lean{}` pins" (`universalMinorInv_self`, `matrixEndRect_pullback`,
  `matrixEndRect_comp`): **all three decls EXIST** (GrassmannianQuot.lean L386, L878, L271). They
  were *relocated* this iter (per the prover task_result), so the checker's positional grep missed
  them. The auditor independently confirms `matrixEndRect_pullback` is *used* at L1872. No `\lean{}`
  correction made.
- "`tautologicalQuotient_epi` invalid `\leanok` on proof block": the `\leanok` is on the
  **statement** line (`\begin{lemma}\leanok`) — legitimate (decl exists with sorry); the proof
  block carries NO `\leanok` (correct). `sync_leanok` behaved correctly. No override made.

## Blueprint markers updated (manual)
- `Picard_GrassmannianQuot.tex`, `lem:chartLocus_isOpenCover`: added `% NOTE:` (review iter-078) —
  formalized proof uses affine projective-splitting (`exists_section_of_epi_free_spec` +
  `exists_isUnit_submatrix`), NOT the stalkwise-Nakayama prose; blueprint-writer should rewrite the
  proof block. (No `\leanok`/`\lean{}`/`\mathlibok` changes — sync was correct, pins resolve, no
  Mathlib re-export among the closures.)

## Notes (LOW)
- sgr checker: 2 stale comments inside SectionGradedRing.lean (prover-owned `.lean`, can't edit) —
  cosmetic.
- GrassmannianQuot stale Lean docstrings: `chartLocus_isOpenCover` "not yet formalized" and
  `grPointOfRankQuotient` "REALIZED (iter-067)" overstate/understate current state — for a future
  prover/refactor to clean (review agent cannot edit `.lean`).
- blueprint-doctor iter-078: **no structural findings** (all chapters `\input`'d, all refs resolve,
  no axioms).
