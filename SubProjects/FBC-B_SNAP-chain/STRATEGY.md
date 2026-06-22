# Strategy

## Goal

Close the `sorry`-bearing nodes of the two **Čech-independent (i=0)** legs split out of the parent
*Quot-Foundations* `thm:fga_pic_representability` cone, then merge back (names/labels are the parent's):

- **FBC-B** — flat base change of the degree-0 pushforward: the i=0 map `g^* f_* F ⟶ f'_* g'^* F` is an
  isomorphism. Seed decls `affineBaseChange_pushforward_iso` + `flatBaseChange_pushforward_isIso`
  (`thm:flat_base_change_pushforward`), reached via the CONCRETE-tilde equalizer chain.
- **SNAP** — the section graded ring `Γ_*(X,L) = ⊕_{n≥0} Γ(X,L^{⊗n})` as a graded commutative semiring
  (`lem:sectionGradedRing_gcommSemiring`) + its graded module (`lem:sectionGradedModule_gmodule`).

End-state: zero project `sorry` in these two cones, zero axioms (kernel-only).

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-B — global H⁰ iso (concrete-tilde equalizer chain) | ACTIVE (foundation DONE iter-016; BOTH mate legs CLOSED iter-018; glue decomposed into 6-lemma scaffold iter-022) | 4–6 (16 elapsed since iter-003) | ~150–300 | `iterated_mateEquiv_conjugateEquiv` (REAL, Mates.lean:450; TwoSquare-valued); `mateEquiv_vcomp`; `TensorProduct.piRight`; Stacks 01XJ (unconfirmed) | CHURNING→decomposed (pc022). Foundation + both b2 mate legs closed (engine = `← conjugateEquiv_comp` split ×2 + `simp[…eq_mpr_eq_cast,cast_eq]` cast-dissolve). Frontier glue `pullback_spec_tilde_iso_ring_square_mate_glue` was monolithic-churning 3 iters → SPLIT into 6 `ring_square_glue_*` sub-lemmas (5 tractable: whisker lifts + geom/alg-leg nats + natTrans; 1 linchpin `pst_iterated_mate` via the now-confirmed-REAL `iterated_mateEquiv_conjugateEquiv`). Then crux rewire + 2 seeds + global assembly + separated→MV→bridge→goal (01XJ gate). Dead-mate apparatus excision queued. |
| SNAP — `Γ_*(X,L)` graded comm ring assembly | ACTIVE (Option A alignment — re-base structural defs onto Mathlib `⊗_loc`) | 3–5 (refactor + cascade; assoc-bridge route abandoned after ~10 STUCK iters) | ~120–300 (net DELETION ~900L bridge machinery) | `CategoryTheory.Localization.Monoidal` (`LocalizedMonoidal`/`toMonoidalCategory`/`L.Monoidal`, all VERIFIED present); `DirectSum.GCommSemiring`/`Gmodule` | STUCK (pc022, ~14 iters over budget on the associator bridge). PIVOT: the hand-built parallel product `tensorObj`/`tensorObjAssoc` + its μ-conjugated bridge to `⊗_loc` is the parallel-API anti-pattern that caused the dual-`MonoidalCategory`-instance μ-token-divergence wall. Re-base `tensorObj := ⊗_loc` (synonym defeq → same object spellings) so `tensorObjAssoc_eq_localizedAssociator` becomes `rfl` — the stuck crux is DELETED, not proved; ~900L hK/seam/head machinery removed. μ then lives ONLY opaque inside `sectionsMul`/`tensorObjLocalizedIso`. Downstream coherences re-prove via Mathlib pentagon/triangle/hexagon + `Functor.Monoidal L` lax-coherences. Design: `analogies/snap-instance-design.md` (verdict ALIGN_WITH_MATHLIB). RISK (sc022): section-level coherences (`sectionsMul_*`, `sectionMul_coherent`) cross to Γ/section level — if one re-summons the μ-boundary, the wall moved one layer down (cheap signal: a stubborn post-refactor sorry). Dual-instance DELETION refuted (load-bearing). |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| FBC RegroupHelper | 011 · 4 | ~120 | RegroupHelper.lean | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needs `erw [TensorProduct.zero_tmul]` |
| SNAP coequalizer rows | 060 · 3 | ~400 | SectionGradedRing.lean | `relTensorActL/R/Proj` objectwise coequalizer nat-transforms; `RelativeTensorCoequalizer` 22-decl API | carrier gap fixed by `objRestrict`; `relTensorProj.naturality` = bare-ℤ `TensorProduct.ext'` then transport to `AddCommGrpCat` | the `forget₂ CommRingCat→RingCat` carrier "blocker" was illusory — real obstacle was additivity |
| SNAP crux chain + graded bricks | 001 · ~1 | ~600 | SectionGradedRing.lean | `ztensor_whisker_localIso`, `isIso_sheafification_whiskerRight_unit`, `tensorObjAssoc`, `tensorPowAdd`; graded bricks (`sectionsCast`, `GMul`/`GOne`, `instGMonoid/Semiring/CommSemiring` scaffold) | sheafification-functoriality of presheaf monoidal isos; `sectionsCast`+`gradedMonoid_eq_of_cast` for index-reindex | stalkwise / "presheaf+Γ-at-end" / full `MonoidalCategory(SheafOfModules)` routes DEAD; carrier `AddCommGrpCat` not `AddCommGrp` |
| SNAP left-unit coherence | 002 · 1 | ~120 | SectionGradedRing.lean | `sectionsMul_one_mul` axiom-clean; reusable `unitor_sectionsMul` adjunction-transpose core | `adj.homEquiv` `.apply_eq_iff_eq_symm_apply` + `homEquiv_counit` term-mode; `show`/`change` (default transparency) mandatory to split `Γ(f≫g)` across the `X.Modules` diamond | positional `rw [val_app_top_comp]`/`comp_apply`/`hom_comp` fail (reducible-transparency mismatch) |
| FBC module core + concrete pivot | 002 · 2 | ~500 | FlatBaseChangeGlobal.lean | `gammaTopEquivEqLocus`, `baseChangeGammaEquiv`, finite-cover equalizer; pivot off mate → concrete-tilde; bridge forward dir | `H⁰(X,F)=Γ(X,F)` = finite equalizer `∏Γ(Uᵢ)⇉∏Γ(Uᵢⱼ)`; flat `−⊗B` preserves it (`tensorEqLocusEquiv`) | mate keystone `_legs_conj`/`_gstar_transpose` + `_sections_direct` (illusory, collapses onto mate) abandoned |

## Routes

Single route per leg; the two legs are independent and merge back upstream.

**FBC route — concrete-tilde equalizer chain (Čech-cohomology-free).** Both named seed legs are reached
WITHOUT the adjoint-mate keystone. `H⁰(X,F)=Γ(X,F)` is the finite equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`
over a finite affine cover of a separated qc scheme, and flat `−⊗B` preserves it. Module core DONE
0-sorry (`FlatBaseChangeGlobal.lean`). The frontier `baseChange_sheafConditionFork_tensorIso`
(`lem:base_changed_equalizer_diagram`) was decomposed iter-003 into (a) per-chart iso
`baseChange_chart_tensorIso` (01I9 + affine cancellation), (b) the crux
`pullback_spec_tilde_iso_restriction_naturality` (restriction-compatibility of the concrete affine
tilde-pullback iso along an open immersion of affines — the explicit localization functoriality, not
the mate), (c) `TensorProduct.piRight` (Mathlib). (a)'s affine cancellation `(B⊗_A R)⊗_R M ≅ B⊗_A M`
is Mathlib's `TensorProduct.AlgebraTensorModule.cancelBaseChange` (`Mathlib.LinearAlgebra.TensorProduct.Tower`,
verified loogle iter-003); the project's proved `regroupEquiv` (RegroupHelper.lean) is an equivalent
fallback. Assembly then climbs separated → Mayer–Vietoris → bridge
`flatBaseChange_isIso_iff_gammaTensorComparison` → goal.

*Mate route abandoned, but BOTH seed decls are deliverables.* `flatBaseChange_pushforward_isIso` AND its
affine specialization `affineBaseChange_pushforward_iso` are named goal seeds that must end zero-sorry;
both receive CONCRETE-chain bodies (the affine seed from per-chart (a)+`regroupEquiv`; the global seed
via the bridge). What is dead is the sheaf-level adjoint-MATE PROOF route — the deletable apparatus is
`base_change_mate_{domain,codomain}_read`/`_gstar_transpose`/`_section_identity`/`_generator_trace` +
the `pushforward_base_change_mate_*` helpers (KEEP `base_change_mate_regroupEquiv`, used by (a), and
`base_change_map_affine_local`). The apparatus is 100% COMPILE-DEAD (verified iter-005: nothing outside
the chain calls it; the seeds are bare `sorry`), so the old "would break a proved seed" gate premise is
FALSE. Excision is deferred only for HYGIENE sequencing — it must run in a dedicated cleanup iter (not
the same iter as the FBC crux prover, to avoid file-instability), and must sync the blueprint `\uses`
web the same iter. The seeds keep clean `sorry` stubs until the concrete chain fills them.

**SNAP route — sheaf tensor powers ⟹ graded ring, coherence by monoidal localization (Option A).**
`Γ_*(X,L)` is the direct sum of section groups of `L^{⊗n}`, with multiplication from the lax-monoidal
section pairing `sectionsMul` plus the `tensorPowAdd` index-addition isos; the graded structure rides
`DirectSum.GCommSemiring`. Mathlib's `CategoryTheory.Localization.Monoidal` builds a full symmetric
`MonoidalCategory` (pentagon/triangle/hexagon) on the type synonym `LocalizedMonoidal L W ε`
(`= modulesLocalizedMonoidal X`), with `L = PresheafOfModules.sheafification`, `W.IsMonoidal` discharged
by the proved `ztensor_whisker_localIso`. **Option B (bridge the hand-built product to `⊗_loc` via the
μ-conjugated iso) is ABANDONED** — its bridge coherence `tensorObjAssoc_eq_localizedAssociator` was STUCK
~10 iters on a dual-`MonoidalCategory`-instance μ-token-divergence (classic parallel-API anti-pattern;
the hand-built `tensorObj`/`tensorObjAssoc` and `⊗_loc` are two products on defeq copies of the same
category, irreconcilable syntactically). **Option A (CHOSEN iter-022):** re-base the hand-built defs
DIRECTLY onto `⊗_loc` (`tensorObj := MonoidalCategory.tensorObj (C := modulesLocalizedMonoidal X)`,
similarly the unitor/braiding/associator). Because the synonym is defeq to `X.Modules` and its unit IS
`unitModule X` (via ε), the object spellings are unchanged, so `tensorObjAssoc_eq_localizedAssociator`
(and the unit/braiding bridges) become `rfl` — the stuck crux is DELETED. μ then lives only opaque
inside `sectionsMul`/`tensorObjLocalizedIso` (now `Iso.refl`); it is never again syntactically reconciled
with a second associator, so the structural-layer bomb cannot recur. ~900L of hK/seam/head bridge
machinery is removed. The downstream coherences (`tensorPowAdd_*`, the section cores, `sectionsMul_*`,
`sectionMul_coherent`) re-prove from the Mathlib monoidal laws + `Functor.Monoidal L` lax-coherences.
BOTH monoidal instances are KEPT — the presheaf `pshModMonoidal` is load-bearing (`LocalizedMonoidal` is
built from it); dual-instance DELETION is refuted. Design: `analogies/snap-instance-design.md`.

## Open strategic questions

- **SNAP Option A — does the μ-boundary reappear in the section-level coherences? (sc022 CHALLENGE).**
  The structural coherences (associator/unitors/braiding) are now `rfl` inside `⊗_loc`. The risk is the
  Γ/section-level coherences (`sectionsMul_*`, `sectionMul_coherent`): if any must relate an `⊗_loc`
  coherence to the section structure across the same defeq-not-syntactic boundary, the wall moved one
  layer down. Cheap signal = a stubborn post-refactor sorry that resists the Mathlib-law re-prove. The
  refactor inserts typed sorries there (it does NOT prove them); next-iter prover probes them and we learn.
- **FBC on-path glue vs. dead mate — distinct? (sc022 CHALLENGE, RESOLVED).** The on-path iterated-mate
  glue uses the CONCRETE-tilde leg mates (`chartBaseChangeGeometricComparison_mate` +
  `chartBaseChangeModuleReassoc_extendScalarsComp`, both CLOSED iter-018) assembled via
  `iterated_mateEquiv_conjugateEquiv`. The "do NOT re-attempt the mate" prohibition targets the dead
  SHEAF-level adjoint-mate apparatus (`base_change_mate_{legs_conj,gstar_transpose,sections_direct}`) —
  a different construction (it tried to prove the SEED directly via a sheaf-level mate). No contradiction:
  closed concrete-tilde leg mates ≠ the abandoned sheaf-level seed-mate.
- **FBC chain signatures.** The scaffolded chain decls (`baseChange_sheafConditionFork_tensorIso`,
  `baseChangeEqLocusToPullbackGamma`, `baseChangeGammaPullbackEquiv`) currently omit
  `[IsSeparated X]`/finiteness/`[F.IsQuasicoherent]`. These must be added (not protected — re-sign
  freely) when their sorries fill, else the per-chart + finite-product steps are unlicensed.
- **FBC qcqs-pushforward-QC (Stacks 01XJ) — UNCONFIRMED, scheduled.** The sheaf-level seed
  `flatBaseChange_pushforward_isIso` and the bridge reverse need `g^*(f_*F)`/`f'_*F'` quasi-coherent over
  the affine base + "iso on global sections ⟹ iso of QC sheaves over an affine". Probed iter-003: loogle
  no hit, leansearch down — not confirmed in Mathlib. PLAN: re-verify before the bridge-reverse lane; if
  absent, build project-side via `[prover-mode: mathlib-build]` (est. ~1–2 iters / ~100–200 LOC). Off
  this iter's critical path (this iter proves the affine (a)/(b)).
- **SNAP `W.IsMonoidal` — RESOLVED (iter-004).** `W_isMonoidal` landed axiom-clean: `whiskerRight` =
  `ztensor_whisker_localIso`, `whiskerLeft` by braiding conjugation (symmetric `C`), multiplicativity
  + RespectsIso from Mathlib on `inverseImage`. `localizedMonoidalUnitIso` + `modulesLocalizedMonoidal`
  also landed → symmetric `MonoidalCategory` for free.
- **SNAP glue choice — RE-DECIDED → Option A (iter-022), Option B ABANDONED.** Option B (keep hand-built
  defs, bridge via `tensorObjLocalizedIso = μ⁻¹;counit`) was chosen iter-005 to avoid Option A's defeq
  blast radius, but its bridge coherence `tensorObjAssoc_eq_localizedAssociator` STUCK ~10 iters on the
  dual-instance μ-token-divergence. Option A (re-base `tensorObj := ⊗_loc`) now CHOSEN: the blast radius
  is handled by the refactor (sorry at broken sites) + a cheap Mathlib-law re-prove, and it DELETES the
  stuck bridge (it becomes `rfl`). The iter-005 "large defeq blast radius" objection stands but is now a
  one-time cost worth paying vs. an unbounded stuck bridge.

## Mathlib gaps & new material

Gaps to fill:
- FBC: `pullback_spec_tilde_iso_restriction_naturality` — concrete localization functoriality of the
  tilde-pullback dictionary; project-built axiom-clean (no upstream PR needed). Affine cancellation for
  (a) = Mathlib `TensorProduct.AlgebraTensorModule.cancelBaseChange` (verified, `…TensorProduct.Tower`)
  or project `regroupEquiv` (DONE). `TensorProduct.piRight` present (loogle); `tensorEqLocusEquiv`
  present. qcqs-pushforward-QC (01XJ) UNCONFIRMED — see Open Q.
- SNAP coherence (Option A): re-base `tensorObj`/unitor/braiding/associator DIRECTLY onto Mathlib
  `⊗_loc` (`modulesLocalizedMonoidal X = LocalizedMonoidal L W ε`) — full symmetric monoidal +
  pentagon/triangle/hexagon for free. The bridges (`tensorObjAssoc_eq_localizedAssociator` et al.)
  become `rfl` (their μ-conjugated proof machinery is DELETED). Downstream coherences (`tensorPowAdd_*`,
  section cores, `sectionsMul_*`, `sectionMul_coherent`) re-prove from the Mathlib monoidal laws +
  `Functor.Monoidal L` lax-coherences (the localization functor's `associativity`/`left_unitality`/
  `right_unitality` fields ARE the lax coherences a section-level multiplication needs).

New project material:
- FBC concrete chain (per-chart iso + restriction naturality + finite-product commutation + assembly).
- SNAP tensor-power coherences + the `Γ_*(X,L)` graded (co)semiring/module instances.
